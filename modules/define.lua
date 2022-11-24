-- all functions in this module will be available to use as long as we specify it in our register() hook


-------------------
--- DEFINE ITEM ---
-------------------

-- define an item and add a recipe for it
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_item()
-- this is a basic item, like a tool, or a resource (log, stick, plank)
function define_item()

  -- define a custom item
  api_define_item({
    id = "cool_axe",
    name = "Cool Axe",
    category = "Decoration",
    tooltip = "This is a cool axe!",
    durability = 1000,
    singular = true
  }, "sprites/item/axe_item.png")

  -- add the item to the workbench as a recipe
  recipe = {
    { item = "log", amount = 10 },
    { item = "waterproof", amount = 20 },
    { item = "glue", amount = 5 }
  }
  res = api_define_recipe("tools", MOD_NAME .. "_cool_axe", recipe, 1)

end


------------------
--- DEFINE BED ---
------------------

-- define an object and set it as a "bed"
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_object()
-- objects are items you can place down, but don't have a menu
function define_bed()

  -- define an object as normal
  -- but with the "bed" property we can give it bed functionality
  api_define_object({
    id = 'test_bed',
    name = 'Sample Bed',
    category = 'Vibing',
    tooltip = 'Sleep in me',
    bed = true, -- this allows it to be used as a bed
    has_shadow = true,
    tools = {'hammer1'},
    depth = -8 -- this sets the layering of the player + the object
  }, '/sprites/bed/bed_item.png', nil)

end


--------------------
--- DEFINE BENCH ---
--------------------

-- define an object and set it as a "bench"
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_object()
-- objects are items you can place down, but don't have a menu
function define_bench()

  -- define an object as normal
  -- but with the "bench" property we can give it bench functionality
  api_define_object({
    id = 'test_bench',
    name = 'Sample Bench',
    category = 'Vibing',
    tooltip = 'Sit on me',
    bench = true, -- this allows it to be used as a bench
    has_shadow = true,
    tools = {'hammer1'},
    depth = -8 -- this sets the layering of the player + the object
  }, '/sprites/bench/bench_item.png', nil)

end


--------------------
--- DEFINE LIGHT ---
--------------------

-- define an object and set it as a light source
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_object()
-- objects are items you can place down, but don't have a menu
function define_light()

  -- define an object as normal
  -- but with the "has_lighting" property we can make it light up
  api_define_object({
    id = 'test_light',
    name = 'Sample Light',
    category = 'arm bee aunts',
    tooltip = 'Put me down',
    has_lighting = true,
    has_shadow = true,
    tools = {'hammer1'}
  }, '/sprites/light/light_item.png', nil)

end


-------------------
--- DEFINE WALL ---
-------------------

-- define a new type of wall
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_wall()
-- walls are solid objects that will tile together when placed next to each other
function define_wall()

  -- define an wall as normal
  api_define_wall({
    id = 17,
    name = "Cool Wall" 
  }, "/sprites/wall/wall_sprite.png")

end


---------------------
--- DEFINE FLOWER ---
---------------------

-- define a new type of flower
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_flower()
function define_flower()

  -- create flower_definition table
  flower_def = {
    id = "14",
    species = "my_flower",
    title = "My Flower",
    latin = "Myus Flowerus",
    hint = "Found in deep water",
    desc = "This is my cool ocean flower!",
    aquatic = true,
    variants = 2,
    deep = true,
    smoker = {"stubborn","fiery"},
    recipes = {
      { a = "flower14", b = "flower1", s = "flower6" }
    }
  }
  
  -- define flower
  api_define_flower(flower_def, 
    "sprites/flower/flower_item.png", "sprites/flower/flower_variants.png", 
    "sprites/flower/flower_seed_item.png", "sprites/flower/flower_hd.png",
    {r=100, g=100, b=100}
  );

end


------------------
--- DEFINE BEE ---
------------------

-- define a new bee and a new bee "trait"
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_bee()
-- once created you can spawn the bee with /gimme bee.{id} or use api_give_item(bee:{id}, 1)
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
    "sprites/bee/bee_item.png", "sprites/bee/bee_shiny.png", 
    "sprites/bee/bee_hd.png",
    {r=100, g=100, b=100},
    "sprites/bee/bee_mag.png",
    "My Magazine Headline!",
    "My magazine body text!"
  );

  -- add a new mutation for our new bee
  -- this will appear on the dream + rocky bee pages (if there's room)
  -- "mutation_chance" is a script defined in "scripts.lua"
  api_define_bee_recipe("dream", "rocky", "nightcrawler", "mutation_chance")

  -- add a new bee trait including our newly defined bee
  -- this trait will be added to all bees using the defaults set below
  -- you can then do whatever you like with this trait when you access it through a slot/item stats prop
  api_define_trait("magic", {
    common = {"low"}, 
    dream  = {"low", "medium"}, 
    nightcrawler = {"high"}
  }, {"none"}) -- default for all the other bees

end


------------------------
--- DEFINE BUTTERFLY ---
------------------------

-- used to define a new type of butterfly
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_butterfly()
-- once created you can spawn the bee with /gimme butterfly.{id} 
function define_butterfly()

  -- set up our butterfly definition 
  butt_def = {
    id = "flutterby",
    title = "Flutterby",
    latin = "Fluttery Buttery",
    hint = "Really likes green flowers but during a wet dawn!",
    desc = "This is just a cool damn butterfly",
    biome = "forest",
    lifespan = 120,
    behaviour = "Crepuscular",
    climate = "Temperate",
    rainlover = true,
    snowlover = false,
    flora = "flora1",
    flowers = {"flower4", "flower17"},
    chance = 50,
    named = true
  }
  
  -- actually define the butterfly 
  api_define_butterfly(butt_def, 
    "sprites/butterfly/butterfly_item.png", "sprites/butterfly/butterfly_golden.png", 
    "sprites/butterfly/caterpiller_item.png",
    "sprites/butterfly/butterfly_hd.png",
    {r=100, g=100, b=100}
  );

end


-----------------------
--- DEFINE RECYCLER ---
-----------------------

-- define a menu object, in this case a "recycler" machine
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_menu_object2()
-- menu objects are items you can place down and then click on to open an actual menu
function define_recycler()

  -- define new menu object as normal
  api_define_menu_object2({
    id = "recycle_bin",
    name = "Recycle Bin",
    category = "Tools",
    tooltip = "Let's you recycle items into random flower seeds",
    layout = {
      {7, 17},
      {7, 39},
      {30, 17},
      {30, 39},
      {99, 17, "Output"},
      {99, 39, "Output"},
      {122, 17, "Output"},
      {122, 39, "Output"},
      {7, 66},
      {30, 66},
      {53, 66},
      {76, 66},
      {99, 66},
      {122, 66},
    },
    buttons = {"Help", "Target", "Close"},
    info = {
      {"1. Recycle Input", "GREEN"},
      {"2. Recycled Output", "RED"},
      {"3. Extra Storage", "WHITE"},
    },
    tools = {"mouse1", "hammer1"},
    placeable = true
  }, "sprites/recycler/recycler_item.png", "sprites/recycler/recycler_menu.png", {
    define = "recycler_define", -- defined in "scripts.lua" as a function
    draw = "recycler_draw", -- defined in "scripts.lua" as a function
    tick = "recycler_tick", -- defined in "scripts.lua" as a function
    change = "recycler_change" -- defined in "scripts.lua" as a function
  })

end


------------------
--- DEFINE NPC ---
------------------

-- define a new npc
-- https://wiki.apico.buzz/wiki/Modding_API#api_define_npc2()
-- an npc is a special type of menu object that has a dialogue window + a shop menu
function define_npc()

  -- setup dialogue tree
  dialogue = {}
  dialogue["A"] = {
    P = "I am a prompt for dialogue A!",
    D = {
      "I am the first paragraph for dialogue A",
      "All NPCs need at least a dialogue A or they break",
      "This is a chance for you to introduce an NPC",
      "Goodbye!"
    },
    A = {
      "$action01", -- Next
      "$action01", -- Next
      "$action01", -- Next
      "$action49" -- Back
    }
  }
  dialogue["B"] = {
    P = "I am a new prompt for dialogue B!",
    D = {
      "Well done on getting a glossy pearl!"
    },
    A = {
      "$action49" -- Back
    }
  }

  --set npc definition
  npc_def = {
    id = 69,
    name = "Gobbo",
    pronouns = "They/Them",
    tooltip = "Wassup pal?",
    shop = true,
    walking = true,
    stock = {"bee:nightcrawler", "sample_mod_cool_axe", "sample_mod_test_bed", "sample_mod_test_bench", "sample_mod_test_light", "flower14", "wall17", "sample_mod_recycle_bin", "log", "log"}, -- max 12
    specials = {"log", "log", "log"}, -- min 3
    dialogue = dialogue,
    greeting = "Alright pal ow ya gettin' on"
  }

  -- define actual npc, damn thats a lot of sprites
  api_define_npc2(npc_def,
    "sprites/npc2/npc_standing.png",
    "sprites/npc2/npc_standing_h.png",
    "sprites/npc2/npc_walking.png",
    "sprites/npc2/npc_walking_h.png",
    "sprites/npc2/npc_head.png",
    "sprites/npc2/npc_bust.png",
    "sprites/npc2/npc_item.png",
    "sprites/npc2/npc_dialogue_bg.png",
    "sprites/npc2/npc_shop_bg.png",
    "npc69_dialogue_check" -- defined in "scripts.lua" as a function
  )

end
