class AddPayStatusToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :pay_status, :integer
  end
end
