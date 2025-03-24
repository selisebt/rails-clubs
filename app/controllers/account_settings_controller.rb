class AccountSettingsController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(account_settings_params)
      redirect_to account_settings_path, notice: 'Account settings updated successfully.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def account_settings_params
    params.require(:user).permit(
      :name,
      attachment_attributes: [:id, :file]
    )
  end
end 