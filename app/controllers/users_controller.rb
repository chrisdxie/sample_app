class UsersController < ApplicationController
  def new
	@user = User.new
  end

  def show
	@user = User.find(params[:id])
  end

  def create
	@user = User.new(params[:user])
	if @user.save
	  flash[:success] = "#{@user.name}, Welcome to the Sample Application! Cool, right?"
	  redirect_to @user
	else
	  render :new
	end
  end

end
