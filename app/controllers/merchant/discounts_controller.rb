class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @discounts = @merchant.discounts.active_discounts
  end 

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = Discount.new
  end 

  def show
    @discount = Discount.find(params[:id])
  end 

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    discount = @merchant.discounts.create(discount_params)
    
    if discount.save
      flash[:message] = "Discount #{discount.id} has been created"
      redirect_to merchant_discount_path(discount)
    else
      flash[:error] = "You must enter all information"
      redirect_to merchant_new_discount_path
    end 
  end 

  def edit
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = Discount.find(params[:id])
  end 

  def update
    discount = Discount.find(params[:id])
    discount.update(discount_params)

    if discount.save
      flash[:message] = "Discount #{discount.id} has been updated"
      redirect_to merchant_discount_path(discount)
    else
      flash[:error] = "You must enter all information"
      redirect_to merchant_edit_discount_path(discount)
    end 
  end 

  def destroy
    discount = Discount.find(params[:id])  
    discount.update(active: false)

    redirect_to merchant_discounts_path
  end 

  def enable_disable
    discount = Discount.find(params[:id])

    case params[:tf]
    when "false"
      discount.update(enabled: false)
      flash[:notice] = "You have disabled item #{discount.id}"
    when "true"
      discount.update(enabled: true)
      flash[:notice] = "You have enabled item #{discount.id}"
    end

    redirect_to merchant_discounts_path
  end 

  private

  def discount_params
    params.require(:discount).permit(:name, :percent_off, :quantity_required)
  end

end 