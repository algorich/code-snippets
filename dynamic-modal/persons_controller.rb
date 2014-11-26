class Person < ApplicationController
  def new
    @person = Person.new
  end
end