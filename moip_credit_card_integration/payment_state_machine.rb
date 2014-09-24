module PaymentStateMachine
  extend ActiveSupport::Concern

  STATUSES = {
    # our own statuses
    not_started:            0,
    method_choosed:        -2,
    # moip statuses
    authorized:             1,
    started:                2,
    payment_slip_impressed: 3,
    done:                   4,
    canceled:               5,
    under_analysis:         6,
    reversed:               7,
    refunded:               9
  }

  PENDING_STATUSES = %i(not_started method_choosed started payment_slip_impressed under_analysis).map { |i| STATUSES.fetch(i) }

  COMPLETED_STATUSES = %i(authorized done).map { |i| STATUSES.fetch(i) }

  ANNULLED_STATUSES = %i(canceled reversed refunded).map { |i| STATUSES.fetch(i) }

  PENDING_OR_COMPLETED_STATUSES = PENDING_STATUSES + COMPLETED_STATUSES

  AT_LEAST_METHOD_CHOOSED_STATUSES = STATUSES.values - [STATUSES.fetch(:not_started)]

  STATUS_ACTION = {
    -2 => 'choose_method',
    1 => 'authorize',
    2 => 'start',
    3 => 'payment_slip_impressed',
    4 => 'done',
    5 => 'cancel',
    6 => 'under_analysis',
    7 => 'reverse',
    9 => 'refund'
  }

  CANCELABLE_ENROLLMENT_STATUSES = ANNULLED_STATUSES + PENDING_STATUSES

  CANCELABLE_ENROLLMENT_ACTIONS  = %i(cancel reverse refund)

  COMPLETABLE_ENROLLMENT_ACTIONS = %i(authorize done)

  STATUSES.keys.each do |method|
    define_method "#{method}?" do
      status == STATUSES.fetch(method)
    end
  end

  def pending?
    PENDING_STATUSES.include? status
  end

  def completed?
    COMPLETED_STATUSES.include? status
  end

  def pending_or_completed?
    PENDING_OR_COMPLETED_STATUSES.include? status
  end

  def annulled?
    ANNULLED_STATUSES.include? status
  end

  included do
    # Returns a friendly status name, based on the passed key param.
    # The key param must be an Integer or Symbol.
    # It accesses STATUSES from PaymentStateMachine module.
    def self.status(key)
      STATUSES.fetch(key.to_sym)
    end

    state_machine :status, initial: STATUSES.fetch(:not_started) do

      # after_failure do |enrollment, transition|
      #   if transition.from != STATUS_ACTION.key(transition.event.to_s)
      #     message = 'payment state machine error: payment %s: from %s to %s' %
      #       [payment.id, STATUSES.key(transition.from), transition.event]
      #     Rails.logger.info(message)
      #     SystemMailer.delay.notify_general_error('Erro na transição de status', message)
      #   end
      # end

      after_transition on: COMPLETABLE_ENROLLMENT_ACTIONS do |payment|
        payment.wallet_transaction = WalletTransaction.create(
          kind: 'out', wallet: payment.associate.wallet, 
          description: 'Pagamento Anuidade', amount: payment.amount
          )
      end

      event :start do
        transition [STATUSES.fetch(:payment_slip_impressed),
                    STATUSES.fetch(:method_choosed),
                    STATUSES.fetch(:not_started)] => STATUSES.fetch(:started)
      end

      event :choose_method do
        transition [STATUSES.fetch(:not_started)] => STATUSES.fetch(:method_choosed)
      end

      event :done do
        transition PENDING_STATUSES + [STATUSES.fetch(:authorized)] => STATUSES.fetch(:done)
      end

      event :cancel do
        transition CANCELABLE_ENROLLMENT_STATUSES => STATUSES.fetch(:canceled)
      end

      event :authorize do
        transition PENDING_STATUSES => STATUSES.fetch(:authorized)
      end

      event :refund do
        transition COMPLETED_STATUSES + [STATUSES.fetch(:under_analysis)] => STATUSES.fetch(:refunded)
      end

      event :reverse do
        transition COMPLETED_STATUSES => STATUSES.fetch(:reversed)
      end

      event :under_analysis do
        transition any => STATUSES.fetch(:under_analysis)
      end

      event :payment_slip_impressed do
        transition any => STATUSES.fetch(:payment_slip_impressed)
      end
    end
  end
end
