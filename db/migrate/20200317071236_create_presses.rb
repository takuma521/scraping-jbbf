class CreatePresses < ActiveRecord::Migration[6.0]
  def change
    create_table :presses, comment: "equals 'news'. Because 'news' don't have plural" do |t|
      t.string :body, null: false, default: ''
      t.string :url, null: false, default: ''
      t.date :date, null: false

      t.timestamps
    end
    add_index :presses, :url
  end
end
