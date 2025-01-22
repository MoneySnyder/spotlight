local Toolbar = plugin:CreateToolbar("Spotlight")
local ToggleButton = Toolbar:CreateButton("Spotlight Settings", "Change the way spotlight works", "rbxassetid://6555466821")
local MainModule = require(script.modules.SpotlightController)

--MainModule:Init()

ToggleButton.Click:Connect(function()
   MainModule:ToggleSettings()
end)

plugin.Unloading:Connect(function()
    MainModule:Unload()
end)