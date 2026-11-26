local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Foundation")
local colorMode = Foundation.Enums.ColorMode
local themeName = Foundation.Enums.ThemeName

local v5 = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#E2F8E3")
}

local v6 = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionEmphasis.Foreground.Color3"] = Color3.fromHex("#FFFFFF"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#022708")
}

local function getClassicThemeTokenOverrides(p2, p3)
	if p2 ~= themeName.Classic then
		return nil
	end

	if p3 == colorMode.Light then
		return v6
	end

	return v5
end

return getClassicThemeTokenOverrides
