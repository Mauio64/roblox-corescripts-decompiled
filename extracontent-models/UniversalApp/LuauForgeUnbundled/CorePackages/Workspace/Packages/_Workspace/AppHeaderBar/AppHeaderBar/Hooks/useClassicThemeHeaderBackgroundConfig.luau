local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/React")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Style")

local uiModeBrandThemeContext = Style.UiModeBrandThemeContext

require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Components/AppHeaderBarClassicThemeBackground")

local fFlagAppNavBarPerItemThemeOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/SharedFlags").FFlagAppNavBarPerItemThemeOverride

local v5 = {
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
	if not fFlagAppNavBarPerItemThemeOverride then
		return nil
	end

	local theme = React.useContext(Style.AppearanceContext).theme:lower()

	return v5[`{module.useContext(uiModeBrandThemeContext).foundationThemeName}_{theme}`]
end

return useClassicThemeHeaderBackgroundConfig
