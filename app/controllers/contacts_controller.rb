class ContactsController < ApplicationController
  expose(:message) { Message.new(params[:message]) }

  def new; end

  def create
    if message.send!
      redirect_to contact_path, notice: "Your message was successfully sent."
    else
      render :new
    end
  end
end
