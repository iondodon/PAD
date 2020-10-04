class CreateMenuTable < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.string :status
      t.string :menu_type
      t.string :components, array: true
      t.timestamps
    end
  end
end
