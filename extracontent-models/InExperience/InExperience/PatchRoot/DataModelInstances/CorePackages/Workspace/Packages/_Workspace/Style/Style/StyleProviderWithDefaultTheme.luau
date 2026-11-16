local Style = script:FindFirstAncestor("Style")
local parent = Style.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local UIBlox = require(parent.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = require(Style.UiModeStyleProvider)

local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local useTokens = Foundation.Hooks.useTokens

local v = { withUiModeSupport = true, withDarkTheme = true }

return function(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useTokens().Config ~= nil

	local createElement = React.createElement
	local v3

	if p.withUiModeSupport then
		v3 = UiModeStyleProvider
	else
		v3 = AppStyleProvider
	end

	local themeName

	if joined.withDarkTheme then
		themeName = ColorMode.Dark
	else
		themeName = ColorMode.Light
	end

	local element = createElement(v3, {
		style = { themeName = themeName, fontName = Constants.FontName.Gotham }
	}, joined.children)

	if p.withUiModeSupport or v2 then
		return element
	end

	local createElement2 = React.createElement
	local colorMode

	if joined.withDarkTheme then
		colorMode = ColorMode.Dark
	else
		colorMode = ColorMode.Light
	end

	return createElement2(FoundationProvider, { colorMode = colorMode }, element)
end
