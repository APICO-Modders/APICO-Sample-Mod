# APICO-Sample-Mod
This is an example mod to get your started!

This mod will define a bunch of different things, an item, a fake "book" menu, and an NPC

`mod.lua` is your main file where you should have your hooks, at least `register()` and `init()` are required for a mod to load correctly.  
`data.json` is your mod's file data that you can read and set with `api_get_data()` and `api_set_data()` with the `data()` hook.  
`mod-icon.png` is the mod icon you want to be used in-game in the Mods menu, it should be 22px x 22px.  

In the `/modules` folder you will see a module we are loading in with our `register()` hook. 
In the `/sprites` folder you will see an example of various sprites used in `api_define_*()` calls  

