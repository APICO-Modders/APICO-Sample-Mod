function register()
  -- register our mod name and the hooks we want
  return {
    name = "sample_mod",
    hooks = {"clock"}
  }
end

function init() 
  -- init the mod
  api_create_log("init", "Hello World!")
  return "Success"
end

function clock()
  -- log the clock time every second
  api_create_log("clock", api_get_time()["clock"])
end
