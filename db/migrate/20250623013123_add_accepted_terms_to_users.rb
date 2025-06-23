class AddAcceptedTermsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :accepted_terms, :boolean, default: false, null: false
    add_column :users, :accepted_terms_at, :datetime
  end
end
