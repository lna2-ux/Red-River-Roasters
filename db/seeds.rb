AdminUser.find_or_create_by!(email: "admin@redriverroasters.ca") do |admin|
  admin.password = "password123"
  admin.password_confirmation = "password123"
end

categories_data = [
  {
    name: "Whole Bean Coffee",
    description: "Small-batch single-origin and signature house blends roasted weekly in Winnipeg."
  },
  {
    name: "Brewing Gear",
    description: "Pour-over drippers, French presses, gooseneck kettles, and precision burr grinders."
  },
  {
    name: "Merchandise",
    description: "Ceramic diner mugs, enamel camp cups, and Red River Roasters knit toques."
  },
  {
    name: "Gift Sets",
    description: "Curated tasting flights and Winnipeg coffee lover gift boxes."
  }
]

categories = categories_data.map do |cat|
  Category.find_or_create_by!(name: cat[:name]) do |c|
    c.description = cat[:description]
  end
end

SitePage.find_or_create_by!(slug: "about") do |page|
  page.title = "About Red River Roasters"
  page.body = "Opened in 2016 in Winnipeg's Exchange District, Red River Roasters roasts small-batch specialty coffee weekly for local cafés, markets, and home brewers across Canada."
end

SitePage.find_or_create_by!(slug: "contact") do |page|
  page.title = "Contact Us"
  page.body = "Visit our Exchange District café in Winnipeg, Manitoba, or reach our roasting team at hello@redriverroasters.ca."
end

provinces_data = [
  ["Manitoba", "MB", 0.05, 0.07, 0.0],
  ["Ontario", "ON", 0.0, 0.0, 0.13],
  ["British Columbia", "BC", 0.05, 0.07, 0.0],
  ["Alberta", "AB", 0.05, 0.0, 0.0],
  ["Saskatchewan", "SK", 0.05, 0.06, 0.0],
  ["Quebec", "QC", 0.05, 0.09975, 0.0],
  ["Nova Scotia", "NS", 0.0, 0.0, 0.15],
  ["New Brunswick", "NB", 0.0, 0.0, 0.15],
  ["Newfoundland and Labrador", "NL", 0.0, 0.0, 0.15],
  ["Prince Edward Island", "PE", 0.0, 0.0, 0.15],
  ["Northwest Territories", "NT", 0.05, 0.0, 0.0],
  ["Nunavut", "NU", 0.05, 0.0, 0.0],
  ["Yukon", "YT", 0.05, 0.0, 0.0]
]

provinces_data.each do |name, abbr, gst, pst, hst|
  Province.find_or_create_by!(abbreviation: abbr) do |p|
    p.name = name
    p.gst_rate = gst
    p.pst_rate = pst
    p.hst_rate = hst
  end
end

origins = [
  "Ethiopia Yirgacheffe", "Colombia Huila", "Guatemala Antigua", "Kenya Nyeri",
  "Sumatra Mandheling", "Brazil Cerrado", "Costa Rica Tarrazu", "Peru Chanchamayo"
]
roasts = ["Light Roast", "Medium Roast", "City+ Roast", "Dark Espresso Roast", "Decaf Swiss Water"]

105.times do |i|
  primary_category = categories[i % categories.size]
  product_name = "#{origins[i % origins.size]} #{roasts[i % roasts.size]} Batch ##{i + 1}"

  product = Product.find_or_create_by!(sku: format("RRR-%04d", i + 1)) do |p|
    p.name = product_name
    p.description = "Freshly roasted in Winnipeg's Exchange District. Tasting notes of #{Faker::Coffee.notes} with a clean, balanced finish ideal for filter or espresso brewing."
    p.price = rand(14.0..48.0).round(2)
    p.stock_quantity = rand(5..60)
    p.is_active = true
    p.on_sale = (i % 5).zero?
  end

  product.categories << primary_category unless product.categories.include?(primary_category)
  secondary_category = categories[(i + 1) % categories.size]
  if (i % 4).zero? && !product.categories.include?(secondary_category)
    product.categories << secondary_category
  end

  if i.even?
    product.update_columns(
      created_at: 10.days.ago,
      updated_at: (i % 4).zero? ? 1.day.ago : 10.days.ago
    )
  end
end