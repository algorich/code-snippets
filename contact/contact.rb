class Contact
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :name, :email, :message

  validates_presence_of :name, :email, :message
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def save
    if self.valid?
      ContactMailer.contact(
        name: self.name,
        email: self.email,
        message: self.message,
        to: 'TODO:@change-me.com').deliver
      return true
    end
    false
  end
end

