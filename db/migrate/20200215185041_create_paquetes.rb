class CreatePaquetes < ActiveRecord::Migration[5.2]
  def change
    create_table :paquetes do |t|
      t.string :tracking_number
      t.string :carrier
      t.integer :length
      t.integer :width
      t.integer :height
      t.float :weight
      t.string :distance_unit
      t.string :mass_unit
      t.timestamps
    end
  end
end
