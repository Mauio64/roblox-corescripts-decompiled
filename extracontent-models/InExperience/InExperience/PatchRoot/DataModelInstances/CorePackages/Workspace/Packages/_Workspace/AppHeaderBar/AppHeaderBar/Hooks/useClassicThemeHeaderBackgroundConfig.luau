local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local Style = require(parent.Style)

local UiModeBrandThemeContext = Style.UiModeBrandThemeContext

require(script.Parent.Parent.Components.AppHeaderBarClassicThemeBackground)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppNavBarPerItemThemeOverride = SharedFlags.FFlagAppNavBarPerItemThemeOverride

local v = {
	Classic_light = {
		centerImage = "rbxasset://textures/ui/LuaApp/graphic/starburst_center_classic_light.png",
		gradientColor = Color3.fromHex("#CDECFF")
	},
	Classic_dark = {
		centerImage = "rbxasset://textures/ui/LuaApp/graphic/starburst_center_classic_dark.png",
		gradientColor = Color3.fromHex("#042349")
	}
}

local function useClassicThemeHeaderBackgroundConfig()
	if not FFlagAppNavBarPerItemThemeOverride then
		return nil
	end

	local theme = React.useContext(Style.AppearanceContext).theme:lower()

	return v[`{React.useContext(UiModeBrandThemeContext).foundationThemeName}_{theme}`]
end

return useClassicThemeHeaderBackgroundConfig
