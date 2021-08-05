class AddTaxonomyToProviders < ActiveRecord::Migration[6.0]
  def change
    add_column :providers, :taxonomy, :string
  end
end
