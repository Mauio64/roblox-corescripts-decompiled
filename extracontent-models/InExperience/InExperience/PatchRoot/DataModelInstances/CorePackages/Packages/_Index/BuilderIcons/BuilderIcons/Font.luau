local scriptParent = script.Parent
local v2 = `rbxassetid://{ require(scriptParent.BuilderIconsFallback) }`

return {
	Regular = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json", Enum.FontWeight.Regular),
	Filled = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json", Enum.FontWeight.Bold),
	Fallback = {
		Regular = Font.new(v2, Enum.FontWeight.Regular),
		Filled = Font.new(v2, Enum.FontWeight.Bold)
	}
}
