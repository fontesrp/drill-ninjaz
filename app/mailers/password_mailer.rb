class PasswordMailer < ApplicationMailer
  def reset_user_password(user)
    @user = user

    mail(
      to: @user.email,
      subject: 'Password Reset'
    )
  end
end
