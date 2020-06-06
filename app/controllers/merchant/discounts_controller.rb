class Merchant::DiscountsController < Merchant::BaseController

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = Discount.new
  end 

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    discount = @merchant.discounts.create(discount_params)
    
    if discount.save
      flash[:message] = "Discount #{discount.id} has been created"
      redirect_to merchant_discount_path(discount)
    else
      flash[:error] = "You must enter all information"
      redirect_to new_merchant_discount_path
    end 
  end 

  def show
    @discount = Discount.find(params[:id])
  end 

  private

  def discount_params
    params.require(:discount).permit(:name, :percent_off, :quantity_required)
  end

end 