--[[
	File: SetProperty.lua
	Author(s): eliphant
	Created: 08/27/2024 @ 14:58:03
	Version: 1.0.0
]]

local SetProperty = {
	Name = "setProperty",
	Aliases = { "setproperty", "set" },
	Description = "Set a property of an object",
	Args = {
		{
			Type = "string",
			Name = "property",
			Description = "The property to set",
		},
		{
			Type = "any",
			Name = "value",
			Description = "The value to set the property to",
		},
	},
}

function SetProperty:Execute(...)
	local args = { ... }
	local objectTable = args[1]
	local property = args[2]
	local value = args[3]
	for _, object in pairs(objectTable) do
		local success, err = pcall(function()
			object[property] = value
		end)

		if not success then
			warn(err)
		end
	end
end

return SetProperty
