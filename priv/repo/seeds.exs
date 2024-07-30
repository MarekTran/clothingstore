# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Clothingstore.Repo.insert!(%Clothingstore.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Clean
Clothingstore.Repo.delete_all(Clothingstore.Items.Item)
Clothingstore.Repo.delete_all(Clothingstore.Tags.Tag)

# Insert Tags
clothes_tag = Clothingstore.Repo.insert!(%Clothingstore.Tags.Tag{name: "Clothes"})
workout_tag = Clothingstore.Repo.insert!(%Clothingstore.Tags.Tag{name: "Workout"})
headwear_tag = Clothingstore.Repo.insert!(%Clothingstore.Tags.Tag{name: "Headwear"})


# Insert Items
gray_hoodie = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Stay cozy and stylish with our Classic Heather Gray Hoodie. Crafted from soft, durable fabric, it features a kangaroo pocket, adjustable drawstring hood, and ribbed cuffs. Perfect for a casual day out or a relaxing evening in, this hoodie is a versatile addition to any wardrobe.",
  title: "Essentials Gray Hoodie",
  img: "https://i.imgur.com/cHddUCu.jpeg",
  price: Decimal.new("100.00"),
  stock: 0
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: gray_hoodie.id,
  tag_id: clothes_tag.id
})

gray_sweatshirt = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Elevate your casual wear with our Classic Grey Hooded Sweatshirt. Made from a soft cotton blend, this hoodie features a front kangaroo pocket, an adjustable drawstring hood, and ribbed cuffs for a snug fit. Perfect for those chilly evenings or lazy weekends, it pairs effortlessly with your favorite jeans or joggers.",
  title: "Classic Grey Hooded Sweatshirt",
  img: "https://i.imgur.com/R2PN9Wq.jpeg",
  price: Decimal.new("90.00"),
  stock: 1
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: gray_sweatshirt.id,
  tag_id: clothes_tag.id
})


black_hoodie = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Elevate your casual wardrobe with our Classic Black Hooded Sweatshirt. Made from high-quality, soft fabric that ensures comfort and durability, this hoodie features a spacious kangaroo pocket and an adjustable drawstring hood. Its versatile design makes it perfect for a relaxed day at home or a casual outing.",
  title: "Classic Black Hooded Sweatshirt",
  img: "https://i.imgur.com/cSytoSD.jpeg",
  price: Decimal.new("79.00"),
  stock: 2
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: black_hoodie.id,
  tag_id: clothes_tag.id
})


black_joggers = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Discover the perfect blend of style and comfort with our Classic Comfort Fit Joggers. These versatile black joggers feature a soft elastic waistband with an adjustable drawstring, two side pockets, and ribbed ankle cuffs for a secure fit. Made from a lightweight and durable fabric, they are ideal for both active days and relaxed lounging.",
  title: "Classic Comfort Fit Joggers",
  img: "https://i.imgur.com/ZKGofuB.jpeg",
  price: Decimal.new("25.00"),
  stock: 3
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: black_joggers.id,
  tag_id: clothes_tag.id
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: black_joggers.id,
  tag_id: workout_tag.id
})

drawstring_joggers = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Experience the perfect blend of comfort and style with our Classic Comfort Drawstring Joggers. Designed for a relaxed fit, these joggers feature a soft, stretchable fabric, convenient side pockets, and an adjustable drawstring waist with elegant gold-tipped detailing. Ideal for lounging or running errands, these pants will quickly become your go-to for effortless, casual wear.",
  title: "Classic Comfort Drawstring Joggers",
  img: "https://i.imgur.com/mp3rUty.jpeg",
  price: Decimal.new("79.00"),
  stock: 4
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: drawstring_joggers.id,
  tag_id: clothes_tag.id
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: drawstring_joggers.id,
  tag_id: workout_tag.id
})

red_joggers = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Experience ultimate comfort with our red jogger sweatpants, perfect for both workout sessions and lounging around the house. Made with soft, durable fabric, these joggers feature a snug waistband, adjustable drawstring, and practical side pockets for functionality. Their tapered design and elastic cuffs offer a modern fit that keeps you looking stylish on the go.",
  title: "Classic Red Jogger Sweatpants",
  img: "https://i.imgur.com/9LFjwpI.jpeg",
  price: Decimal.new("98.00"),
  stock: 5
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: red_joggers.id,
  tag_id: clothes_tag.id
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: red_joggers.id,
  tag_id: workout_tag.id
})

blue_cap = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Step out in style with this sleek navy blue baseball cap. Crafted from durable material, it features a smooth, structured design and an adjustable strap for the perfect fit. Protect your eyes from the sun and complement your casual looks with this versatile and timeless accessory.",
  title: "Classic Navy Blue Baseball Cap",
  img: "https://i.imgur.com/R3iobJA.jpeg",
  price: Decimal.new("61.00"),
  stock: 6
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: blue_cap.id,
  tag_id: headwear_tag.id
})

lightblue_cap = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Top off your casual look with our Classic Blue Baseball Cap, made from high-quality materials for lasting comfort. Featuring a timeless six-panel design with a pre-curved visor, this adjustable cap offers both style and practicality for everyday wear.",
  title: "Classic Blue Baseball Cap",
  img: "https://i.imgur.com/wXuQ7bm.jpeg",
  price: Decimal.new("86.00"),
  stock: 7
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: lightblue_cap.id,
  tag_id: headwear_tag.id
})

red_cap = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Elevate your casual wardrobe with this timeless red baseball cap. Crafted from durable fabric, it features a comfortable fit with an adjustable strap at the back, ensuring one size fits all. Perfect for sunny days or adding a sporty touch to your outfit.",
  title: "Classic Red Baseball Cap",
  img: "https://i.imgur.com/cBuLvBi.jpeg",
  price: Decimal.new("35.00"),
  stock: 8
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: red_cap.id,
  tag_id: headwear_tag.id
})


black_cap = Clothingstore.Repo.insert!(%Clothingstore.Items.Item{
  description: "Elevate your casual wear with this timeless black baseball cap. Made with high-quality, breathable fabric, it features an adjustable strap for the perfect fit. Whether you’re out for a jog or just running errands, this cap adds a touch of style to any outfit.",
  title: "Classic Black Baseball Cap",
  img: "https://i.imgur.com/KeqG6r4.jpeg",
  price: Decimal.new("58.00"),
  stock: 9
})

Clothingstore.Repo.insert!(%Clothingstore.Items.ItemsTags{
  item_id: black_cap.id,
  tag_id: headwear_tag.id
})
