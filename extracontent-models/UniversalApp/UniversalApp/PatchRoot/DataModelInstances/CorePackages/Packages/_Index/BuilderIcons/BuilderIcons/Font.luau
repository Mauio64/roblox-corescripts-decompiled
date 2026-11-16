local parent = script.Parent
local BuilderIconsFallback = require(parent.BuilderIconsFallback)

local formatted = `rbxassetid://{BuilderIconsFallback}`

return {
	Regular = Font.new(
		"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
		Enum.FontWeight.Regular
	),
	Filled = Font.new(
		"rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",
		Enum.FontWeight.Bold
	),
	Fallback = {
		Regular = Font.new(formatted, Enum.FontWeight.Regular),
		Filled = Font.new(formatted, Enum.FontWeight.Bold)
	}
}
