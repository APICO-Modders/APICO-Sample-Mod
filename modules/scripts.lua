-- all functions in this module will be available to use as long as we specify it in our register() hook


-----------------------
--- GENERAL SCRIPTS ---
-----------------------

function command_treats(args)

  -- items, objects, and menu objects use your MOD_NAME in their oid
  api_give_item(MOD_NAME .. "_cool_axe", 1)
  api_give_item(MOD_NAME .. "_test_bed", 1)
  api_give_item(MOD_NAME .. "_test_bench", 1)
  api_give_item(MOD_NAME .. "_test_light", 1)
  api_give_item(MOD_NAME .. "_recycle_bin", 1)

  -- flowers, bees, walls and NPCs DO NOT use your MOD_NAME in their oid!
  api_give_item("wall17", 1)
  api_give_item("flower14", 1)
  api_give_item("bee:nightcrawler", 1)
  api_give_item("npc69", 1)

end


------------------------
--- RECYCLER SCRIPTS ---
------------------------

-- the define script is called when a menu object instance is created
-- this means we can define properties on the menu object for the first time
function recycler_define(menu_id)

  -- create initial props
  api_dp(menu_id, "working", false)
  api_dp(menu_id, "p_start", 0)
  api_dp(menu_id, "p_end", 1)

  -- create gui for the menu
  api_define_gui(menu_id, "progress_bar", 49, 20, "recycler_gui_tooltip", "sprites/recycler/recycler_gui_arrow.png")
  
  -- save gui sprite ref for later
  spr = api_get_sprite("sp_sample_mod_progress_bar")
  api_dp(menu_id, "progress_bar_sprite", spr)

  -- add our p_start and p_end props to the default _fields list so the progress is saved 
  -- any keys in _fields will get their value saved when the game saves, and loaded when the game loads again
  fields = {"p_start", "p_end"}
  fields = api_sp(menu_id, "_fields", fields)

end

-- the change script lets us listen for a change in the menu's slots
-- it's called when a slot changes in the menu
function recycler_change(menu_id)

  -- if we have items in the first four slots let's get to work
  input_slot = api_slot_match_range(menu_id, {"ANY"}, {1, 2, 3, 4}, true)
  if input_slot ~= nil then 
    api_sp(menu_id, "working", true)
  else
    api_sp(menu_id, "working", false)
  end

end

-- the tick script lets us run logic we need for the menu object 
-- it's called every 0.1s (real-time)
function recycler_tick(menu_id)

  -- handle countdown if working
  if api_gp(menu_id, "working") == true then
    -- add to counter
    api_sp(menu_id, "p_start", api_gp(menu_id, "p_start") + 0.1)
    -- if we hit the end, i.e. 10s have passed
    if api_gp(menu_id, "p_start") >= api_gp(menu_id, "p_end") then

      -- reset the counter
      api_sp(menu_id, "p_start", 0)
      
      -- get the "input" slots to get an item
      input_slot = api_slot_match_range(menu_id, {"ANY"}, {1, 2, 3, 4}, true)
      -- assuming there is a slot width stuff
      if input_slot ~= nil then

        -- remove 1 from slot
        api_slot_decr(input_slot["id"])

        -- add seed to output
        seed_item = api_choose({"seed1", "seed2", "seed3"})
        output_slot = api_slot_match_range(menu_id, {"", seed_item}, {5, 6, 7, 8}, true)
        if output_slot ~= nil then
          -- if empty slot add 1 seed item
          if output_slot["item"] == "" then
            api_slot_set(output_slot["id"], seed_item, 1)
          -- otherwise add to existing seed item in slot
          else 
            api_slot_incr(output_slot["id"])
          end
        end

        -- recheck input, if nothing then stop working
        input_slot = api_slot_match_range(menu_id, {"ANY"}, {1, 2, 3, 4}, true)
        if input_slot == nil then api_sp(menu_id, "working", false) end

      end
    end
  end
end

-- the draw script lets us draw custom things on the menu when it's open
-- here we can draw GUI elements or buttons or other things
-- you should avoid putting complex logic in the draw script
function recycler_draw(menu_id)

  -- get camera
  cam = api_get_cam()

  -- draw gui progress here
  gui = api_get_inst(api_gp(menu_id, "progress_bar"))
  spr = api_gp(menu_id, "progress_bar_sprite")

  -- draw arrow "progress" block then cover up with arrow hole
  -- arrow sprite is 47x10
  gx = gui["x"] - cam["x"]
  gy = gui["y"] - cam["y"]
  progress = (api_gp(menu_id, "p_start") / api_gp(menu_id, "p_end") * 47)
  api_draw_sprite_part(spr, 2, 0, 0, progress, 10, gx, gy)
  api_draw_sprite(spr, 1, gx, gy)

  -- draw highlight if highlighted
  if api_get_highlighted("ui") == gui["id"] then
    api_draw_sprite(spr, 0, gx, gy)
  end

end

-- return text for gui tooltip
-- this method is called by the GUI instance when we hover over it
-- the text returned is shown in a tooltip
function recycler_gui_tooltip(menu_id) 
  progress = math.floor((api_gp(menu_id, "p_start") / api_gp(menu_id, "p_end")) * 100)
  percent = tostring(progress) .. "%"
  return {
    {"Progress", "FONT_WHITE"},
    {percent, "FONT_BGREY"}
  }
end


-------------------
--- BEE SCRIPTS ---
-------------------

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