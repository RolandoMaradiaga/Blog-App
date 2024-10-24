class AddPgSearchIndexes < ActiveRecord::Migration[7.0]
  def change
    enable_extension "pg_trgm"
    enable_extension "unaccent"

    add_index :posts, :title, using: :gin, opclass: :gin_trgm_ops
    add_index :posts, :body, using: :gin, opclass: :gin_trgm_ops
  end
end
