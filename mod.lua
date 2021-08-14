-- require another lua file, containing our custom log() method
-- doesn't work in windows currently due to Steam messing with the working directory
-- require("mods.sample_mod.modules.utility")

-- register is called first to register your mod with the game
-- https://wiki.apico.buzz/wiki/Modding_API#register()
function register()
  -- register our mod name and the hooks we want
  -- you can see a full list of hooks here:
  -- https://wiki.apico.buzz/wiki/Modding_API#Hooks
  return {
    name = "sample_mod",
    hooks = {"clock"}
  }
end

-- init is called once registered and gives you a chance to run any setup code
-- https://wiki.apico.buzz/wiki/Modding_API#init()
function init() 

  -- turn on devmode
  api_set_devmode(true)

  -- log to the console
  log("init", "Hello World!")

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
  res = api_define_recipe("tools", "sample_mod_cool_axe", recipe, 1)

  return "Success"
end

-- clock is called every 1s by the game (real-time)
-- https://wiki.apico.buzz/wiki/Modding_API#clock()
function clock()
  
  -- log the clock time every second
  log("clock", api_get_time()["clock"])
  
end
