class Deliver
  include SuckerPunch::Job

  DELIVERY_TIME = 5

  def perform(params)
    menu = Menu.find(params[:id])
    menu.status = "delivered"
    menu.save
  end
end
