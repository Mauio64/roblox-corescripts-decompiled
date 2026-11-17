local parent = script:FindFirstAncestor("Style").Parent

local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local ThemeName = Foundation.Enums.ThemeName

local v = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#E2F8E3")
}

local v2 = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionEmphasis.Foreground.Color3"] = Color3.fromHex("#FFFFFF"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#022708")
}

local function getClassicThemeTokenOverrides(p, p2)
	if p ~= ThemeName.Classic then
		return nil
	end

	return if p2 == ColorMode.Light then v2 else v
end

return getClassicThemeTokenOverrides
