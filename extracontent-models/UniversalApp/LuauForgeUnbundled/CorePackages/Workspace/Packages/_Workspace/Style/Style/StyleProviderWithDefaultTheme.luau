local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Cryo")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/UIBlox")
local appStyleProvider = UIBlox.App.Style.AppStyleProvider
local constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/UiModeStyleProvider")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Foundation")
local foundationProvider = Foundation.FoundationProvider
local colorMode = Foundation.Enums.ColorMode
local useTokens = Foundation.Hooks.useTokens

local v5 = { withUiModeSupport = true, withDarkTheme = true }

return function(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useTokens().Config ~= nil

	local createElement = React.createElement
	local v7 = if p2.withUiModeSupport then UiModeStyleProvider else appStyleProvider

	local v10 = if joined.withDarkTheme then colorMode.Dark else colorMode.Light
	local element = createElement(v7, {
		style = { themeName = v10, fontName = constants.FontName.Gotham }
	}, joined.children)

	if p2.withUiModeSupport or v6 then
		return element
	end

	local createElement2 = React.createElement
	local v13 = if joined.withDarkTheme then colorMode.Dark else colorMode.Light
	return createElement2(foundationProvider, { colorMode = v13 }, element)
end
