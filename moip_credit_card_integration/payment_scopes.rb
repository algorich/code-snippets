module PaymentScopes
  extend ActiveSupport::Concern

  included do
    scope :pending, -> { where(status: PaymentStateMachine::PENDING_STATUSES) }

    scope :completed, -> { where(status: PaymentStateMachine::COMPLETED_STATUSES) }

    scope :pending_or_completed, -> { where(status: PaymentStateMachine::PENDING_OR_COMPLETED_STATUSES) }

    scope :annulled, -> { where(status: PaymentStateMachine::ANNULLED_STATUSES) }

    scope :at_least_method_choosed, -> {
      where('payments.status <> ?', status(:not_started))
    }

    scope :done, -> { where(status: status(:done)) }

    scope :not_completed, -> { where('status <> ? AND status <> ?',
                                     status(:done), status(:authorized)) }

    scope :paid, -> { where('status = ? OR status = ?', status(:done),
                            status(:authorized)) }

    scope :free, -> { where(method: 'free') }

    scope :paid_by_gateway, -> { where(method: ['payment_slip', 'credit_card', 'bank_debit']) }

    scope :elderly_enrolled, -> {
      enrollments.joins(:athlete).
      where('athletes.birthday <= ?', Date.today - Athlete::ELDERLY_AGE.years)}

    scope :annullable, -> {
      pending.where(
        '(method = ? AND cancelation_date < ?) OR (method = ? AND cancelation_date < ?)',
        'payment_slip', Payment.limit_days_to_annul('payment_slip'),
        'bank_debit',   Payment.limit_days_to_annul('bank_debit'))
    }

    scope :future, -> { joins(:event).where('events.start >= ?', Time.zone.now) }

    scope :past,   -> { joins(:event).where('events.start < ?', Time.zone.now) }

    scope :created_between, lambda {
      |start_at, end_at| where(created_at: start_at..end_at)
    }
  end
end
