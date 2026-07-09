local Style = script:FindFirstAncestor("Style")
local StyleParent = Style.Parent
local React = require(StyleParent.React)
local Cryo = require(StyleParent.Cryo)
local UIBlox = require(StyleParent.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = require(Style.UiModeStyleProvider)
local Foundation = require(StyleParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	withUiModeSupport = true,
	withDarkTheme = true
}

return function(p1) -- line: 35
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), React (copy), UiModeStyleProvider (copy), AppStyleProvider (copy), Constants (copy), FoundationProvider (copy), Theme (copy)
	local v15 = Cryo.Dictionary.join(t1, p1)
	local v16 = useTokens().Config ~= nil
	local v17 = React.createElement(if not p1.withUiModeSupport then AppStyleProvider else UiModeStyleProvider, {
		style = {
			themeName = if not v15.withDarkTheme then Constants.ThemeName.Light else Constants.ThemeName.Dark,
			fontName = Constants.FontName.Gotham
		}
	}, v15.children)

	if not p1.withUiModeSupport and not v16 then
		return React.createElement(FoundationProvider, {
			theme = if not v15.withDarkTheme then Theme.Light else Theme.Dark
		}, v17)
	end

	return v17
end
