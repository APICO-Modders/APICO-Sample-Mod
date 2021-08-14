-- require another lua file, containing our custom log() method
require("mods.sample_mod.modules.utility")

function register()
  -- register our mod name and the hooks we want
  return {
    name = "sample_mod",
    hooks = {"clock"}
  }
end

function init() 

  -- init the mod
  log("init", "Hello World!")

  return "Success"
end

function clock()
  -- log the clock time every second
  log("clock", api_get_time()["clock"])
end
