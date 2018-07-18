class CreatePhoto < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.bigint :pet_id
      t.bigint :animal_id
      t.bigint :api_id
      t.text :image_path
      t.text :api_path
      t.boolean :isDefault
      t.boolean :isActive
      t.boolean :isDownloaded
    end
  end
end
