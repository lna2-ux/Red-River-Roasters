ActiveAdmin.register Customer do
  permit_params :full_name, :email, :street_address, :city, :postal_code, :province_id

  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :city
    column :province
    column :postal_code
    column :created_at
    actions
  end
end