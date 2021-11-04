-- all functions in this module will be available to use as long as we specify it in our register() hook


-- log helper as i am lazy
function log(group, msg)
  api_log(group, msg)
end


-- define an item and add a recipe for it
function define_item()
  -- define a custom item
  api_define_item({
    id = "cool_axe",
    name = "Cool Axe",
    category = "Decoration",
    tooltip = "This is a cool axe!",
    shop_key = false,
    shop_buy = 0,
    shop_sell = 0,
    durability = 1000,
    singular = true
  }, "sprites/cool_axe.png")
  -- add the item to the workbench as a recipe
  recipe = {
    { item = "log", amount = 10 },
    { item = "waterproof", amount = 20 },
    { item = "glue", amount = 5 }
  }
  res = api_define_recipe("tools", MOD_NAME .. "_cool_axe", recipe, 1)
end


-- define a fake book menu obj
function define_book()
  -- define a new item
  -- this will give us a way to open our book when we want to
  api_define_item({
    id = "my_book_item",
    name = "My Book",
    category = "Books",
    tooltip = "Right-click to open!",
    shop_key = true,
    shop_buy = 0,
    shop_sell = 0,
    singular = true
  }, "sprites/book_item.png")
  -- define new menu object
  -- this will act as our books "menu"
  api_define_menu_object({
    id = "my_book",
    name = "My Book",
    category = "Books",
    tooltip = "This is my cool book",
    shop_key = false,
    shop_buy = 0,
    shop_sell = 0,
    center = true,
    invisible = true,
    layout = {},
    buttons = {"Close"},
    info = {},
    tools = {"mouse1", "hammer1"},
    placeable = true
  }, "sprites/book_item.png", "sprites/book_menu.png", {
    define = "book_define", -- defined below as a function
    draw = "book_draw" -- defined below as a function
  })
  -- finally, this will add our book to the library bar on the bottom
  api_library_add_book("my_sweet_book", "book_open", "sprites/book_button.png")
end


-- function called when clicking the library book button
function book_open()
  api_toggle_menu(MY_BOOK_MENU, true)
end


-- define the book
function book_define(menu_id) 
  -- set the menu object to immortal so it's never deactivated
  obj_id = api_get_menus_obj(menu_id)
  immortal = api_set_immortal(obj_id, true)
  -- set to global for later
  MY_BOOK_MENU = menu_id
  MY_BOOK_OBJ = obj_id
end


-- draw our book, called in the gui() hook
function book_draw(menu_id)

  -- draw something on top!
  menu = api_get_inst(menu_id)
  cam = api_get_cam()
  mx = menu["x"] - cam["x"]
  my = menu["y"] - cam["y"]

  -- draw the menu
  api_draw_sprite(menu["sprite_index"], 0, mx, my)

  -- draw some text
  api_draw_text(mx + 6, my + 4, "Hello World!", false, "FONT_BOOK")

end


-- define a new bee and a new bee trait
function define_bee()
  -- setup bee_definition 
  bee_def = {
    id = "nightcrawler",
    title = "Nightcrawler",
    latin = "Crawly Nighty",
    hint = "Found on only the darkest of nights",
    desc = "This is just a cool damn bee",
    lifespan = {"Normal"},
    productivity = {"Normal", "Fast"},
    fertility = {"Fecund", "Prolific"},
    stability = {"Normal", "Stable"},
    behaviour = {"Nocturnal"},
    climate = {"Temperate"},
    rainlover = false,
    snowlover = false,
    grumpy = true,
    produce = "log",
    recipes = {
      { a = "nightcrawler", b = "dream", s = "chaotic" }
    },
    calming = {"flower10", "flower11"},
    chance = 100,
    bid = "X3",
    requirement = ""
  }
  -- create new bee
  -- in this example we have a "sprites" folder in our mod root
  api_define_bee(bee_def, 
    "sprites/bee_item.png", "sprites/bee_shiny.png", 
    "sprites/bee_hd.png",
    {r=100, g=100, b=100},
    "sprites/bee_mag.png",
    "My Magazine Headline!",
    "My magazine body text!"
  );
  -- add a new mutation for our new bee
  api_define_bee_recipe("dream", "rocky", "nightcrawler", "mutation_chance")
  -- add a new bee trait including our newly defined bee
  api_define_trait("magic", {
    common = {"low"}, 
    dream  = {"low", "medium"}, 
    nightcrawler = {"high"}
  }, {"none"}) -- default for all the other bees
end


-- define the mutation critera/chance for our new bee
function mutation_chance()
  -- rocky-dream 30% chance at night to mutate
  if (bee_a == "rocky" and bee_b == "dream") or (bee_a == "dream" and bee_b == "rocky") then
    time = api_get_time()
    chance = api_random(99) + 1
    if time["name"] == "Night" and chance <= 30 then
      return true
    end
  end
  return false;
end


-- define a new npc
function define_npc()

  --set npc definition
  npc_def = {
    id = 69,
    name = "Gobbo",
    pronouns = "They/Them",
    tooltip = "Wassup pal?",
    shop = true,
    walking = true,
    stock = {"log", "log", "log", "log", "log", "log", "log", "log", "log", "log"}, -- max 10
    specials = {"log", "log", "log"}, -- must be 3
    dialogue = {
      "Wot ya mean av I gots anything other than logs to sell??",
      "Wot a stoopid question hoomie"
    },
    greeting = "Alright pal ow ya gettin' on"
  }

  -- define npc
  api_define_npc(npc_def,
    "sprites/npc_standing.png",
    "sprites/npc_standing_h.png",
    "sprites/npc_walking.png",
    "sprites/npc_walking_h.png",
    "sprites/npc_head.png",
    "sprites/npc_bust.png",
    "sprites/npc_item.png",
    "sprites/npc_dialogue_menu.png",
    "sprites/npc_shop_menu.png"
  )

end
