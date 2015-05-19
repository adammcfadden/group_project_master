class AddActiveToBattlesTable < ActiveRecord::Migration
  def change
    add_column :battles, :active?, :boolean
  end
end
