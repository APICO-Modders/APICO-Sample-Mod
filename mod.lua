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
    hooks = {"ready", "gui", "click"}, -- subscribe to hooks we want so they're called
    modules = {"utility"} -- load other modules we need, in this case "/modules/utility.lua"
  }
end

-- init is called once registered and gives you a chance to run any setup code
-- https://wiki.apico.buzz/wiki/Modding_API#init()
function init() 

  -- turn on devmode
  api_set_devmode(true)

  -- log to the console
  api_log("init", "Hello World!")

  -- define new stuff (see modules/utility.lua)
  -- define a new axe item and add it to the workbench
  define_item()
  -- define a new bee species, add a hybrid recipe for it, and add a new trait to all bees
  define_bee()
  -- define a menu object that we'll use as a fake "book"
  define_book()
  -- define a new npc
  define_npc()

  return "Success"
end


-- ready is called once all mods are ready and once the world has loaded any undefined instances from mods in the save
-- https://wiki.apico.buzz/wiki/Modding_API#ready()
function ready()

  -- we're going to get the mod "data" file to see if this is the first time the mod has loaded
  api_get_data()

  -- if we don't have a book obj create one
  -- once we create one and the player saves the game, next time we won't need/want to make a new one
  existing = api_get_menu_objects(nil, "sample_mod_my_book")
  if #existing == 0 then
    api_create_obj("sample_mod_my_book", -32, -32)
  end

  -- if we haven't given the player a book give them one
  -- once the player picks up the item it'll be marked in their discovery they got one
  discovery = api_check_discovery("sample_mod_my_book_item")
  if discovery == false then
    api_give_item("sample_mod_my_book_item", 1)
  end

  -- if we haven't already spawned our new npc, spawn them
  friend = api_get_menu_objects(nil, "npc69")
  if #friend == 0 then
    player = api_get_player_position()
    api_create_obj("npc69", player["x"] + 16, player["y"] - 32)
  end

  -- play a sound to celebrate our mod loading! :D
  api_play_sound("confetti")

end


-- data is called any time we run api_get_data() or api_set_data()
-- https://wiki.apico.buzz/wiki/Modding_API#data()
function data(ev, data)
  
  -- for data load, data is nil if we have no data.json file existing
  -- you can have one in your mod root by default, or just make one 
  -- when you call api_set_data()
  if (ev == "LOAD" and data ~= nil) then
    -- worlds dont have unique identifiers so we can check with the player name
    name = api_gp(api_get_player_instance(), "name")
    if data["players"][name] == nil then
      -- this is the first time we have loaded this mod for this player
      -- we can use this to do something, i.e. spawn an object
      api_log("data", "First time!")
      -- once done we set the data value and update the data for next time
      data["players"][name] = true
      api_set_data(data)
    else
      -- this isn't our first rodeo!!
      api_log("data", "Loaded before.")
    end
  end

  -- check save was successful
  if (ev == "SAVE" and data ~= nil) then
    -- save was successful!
  end

end


-- gui is called each draw cycle. anything drawn in this hook will 
-- https://wiki.apico.buzz/wiki/Modding_API#click()
function gui()

  -- draw book if open
  if api_gp(MY_BOOK_OBJ, "open") == true then
    -- get screen pos
    game = api_get_game_size()
    cam = api_get_cam()
    -- draw black rectangle at 0.9 alpha over entire screen
    api_draw_rectangle(0, 0, game["width"], game["height"], "BLACK", false, 0.9)
    -- redraw menu on gui layer
    book_draw(MY_BOOK_MENU)
  end

end


-- click is called whenever the player clicks
-- https://wiki.apico.buzz/wiki/Modding_API#click()
function click(button, click_type)
  
  -- check if we right click out book item to open the book
  if button == "RIGHT" and click_type == "PRESSED" then

    -- fake opening a book by opening our fake menu object when the book is right clicked in a slot
    highlighted = api_get_highlighted("slot")
    if highlighted ~= nil then
      slot = api_get_slot_inst(highlighted)
      if slot["item"] == "sample_mod_my_book_item" then
        api_toggle_menu(MY_BOOK_MENU, true)
      end
    end
  end
  
end
