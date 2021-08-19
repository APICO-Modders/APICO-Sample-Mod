-- This Sample Mod is for use with Beeta 1.3+

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
    hooks = {"ready", "gui", "click"}, -- subscribe to these 3 hooks so they're called
    modules = {"utility"} -- load /modules/utility.lua
  }
end

-- init is called once registered and gives you a chance to run any setup code
-- https://wiki.apico.buzz/wiki/Modding_API#init()
function init() 

  -- turn on devmode
  -- api_set_devmode(true)

  -- log to the console
  log("init", "Hello World!")

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

    highlighted = api_get_highlighted("slot")
    if highlighted ~= nil then
      slot = api_get_slot_inst(highlighted)
      if slot["item"] == "sample_mod_my_book_item" then
        api_toggle_menu(MY_BOOK_MENU, true)
      end
    end
  end
  
end
