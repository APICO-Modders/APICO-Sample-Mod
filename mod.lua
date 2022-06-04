-- This is the Sample Mod!

-- I would recommend keeping your mod_id in a variable to access with create() methods and stuff
-- there's a bunch of methods that prepend your mod_id to the name/oids so it comes in handy!
MOD_NAME = "sample_mod"

-- store a ref to our book menu for later
MY_BOOK_MENU = nil
MY_BOOK_OBJ = nil

-- register is called first to register your mod with the game
-- https://wiki.apico.buzz/wiki/Modding_API#register()
function register()
  -- register our mod name, hooks, and local modules
  -- you can see a full list of hooks here:
  -- https://wiki.apico.buzz/wiki/Modding_API#Hooks
  return {
    name = MOD_NAME,
    hooks = {"ready"}, -- subscribe to hooks we want so they're called
    modules = {"define", "scripts"} -- load other modules we need, in this case "/modules/define.lua" and "/modules/scripts.lua"
  }
end

-- init is called once registered and gives you a chance to run any setup code
-- https://wiki.apico.buzz/wiki/Modding_API#init()
function init() 

  -- turn on devmode
  api_set_devmode(true)

  -- log to the console
  api_log("init", "Hello World!")

  -- here you can define all your stuff!
  -- i recommend you comment all of these out and play with them one by one until you understand how each works
  -- all define scripts are in "/modules/define.lua"

  -- define a new item, in this case an axe
  define_item()
  -- define a new object that can be sat on like a bench
  define_bench()
  -- define a new object that can be slept in like a bed
  define_bed()
  -- define a new object that will light up like a lantern
  define_light()
  -- define a new type of wall
  define_wall()
  -- define a new type of flower
  define_flower()
  -- define a new type of bee
  define_bee()
  -- define a new NPC
  define_npc()
  -- define a new menu object, in this case a "recycler" that turns items into seeds 
  -- WARNING: advanced
  define_recycler()

  -- define a custom command so we can spawn in all our new goodies
  -- "command_treats" is defined in "scripts.lua"
  api_define_command('/treats', "command_treats")

  -- if you dont return success here your mod will not load
  -- this can be useful if your define fails as you can decide to NOT return "Success" to tell APICO 
  -- that something went wrong and to ignore your mod
  return "Success"
end


-- ready is called once all mods are ready and once the world has loaded any undefined instances from mods in the save
-- https://wiki.apico.buzz/wiki/Modding_API#ready()
function ready()

  -- if we haven't already spawned our new npc, spawn them
  friend = api_get_menu_objects(nil, "npc69")
  if #friend == 0 then
    player = api_get_player_position()
    api_create_obj("npc69", player["x"] + 16, player["y"] - 32)
  end

  -- play a sound to celebrate our mod loading! :D
  api_play_sound("confetti")

end