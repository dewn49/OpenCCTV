class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.string :name
      t.string :camera_id
      t.text :description
      t.references :vms, index: true
      
      t.timestamps
    end
  end
end
