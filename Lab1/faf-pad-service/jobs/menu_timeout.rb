class MenuTimeout
  include SuckerPunch::Job

  AMOUNT = 30

  def perform(params)
    menu = Menu.find(params[:id])
    return unless menu.status == 'building'

    menu.status = 'timed_out'
    menu.save
  end
end
