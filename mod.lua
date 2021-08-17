-- I would recommend keeping your mod_id in a variable to access with create() methods and stuff
-- there's a bunch of methods that prepend your mod_id to the name/oids so it comes in handy!
MOD_NAME = "sample_mod"

-- register is called first to register your mod with the game
-- https://wiki.apico.buzz/wiki/Modding_API#register()
function register()
  -- register our mod name and the hooks we want
  -- you can see a full list of hooks here:
  -- https://wiki.apico.buzz/wiki/Modding_API#Hooks
  return {
    name = MOD_NAME,
    hooks = {"clock"}
  }
end

-- init is called once registered and gives you a chance to run any setup code
-- https://wiki.apico.buzz/wiki/Modding_API#init()
function init() 

  -- turn on devmode
  api_set_devmode(true)

  -- log to the console
  api_log("init", "Hello World!")

  -- define a custom item with recipe
  define_item()

  -- define a custom bee with hybrid recipe and new trait
  define_bee()

  return "Success"
end

-- clock is called every 1s by the game (real-time)
-- https://wiki.apico.buzz/wiki/Modding_API#clock()
function clock()
  
  -- log the clock time every second
  api_log("clock", api_get_time()["clock"])
  
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
    {r=100, g=100, b=100}
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
