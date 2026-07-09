local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Style = require(Parent.Style)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.AppLocales).Localization
local LocalizationProvider = require(Parent.Localization).LocalizationProvider

local function ContextProviders(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), Foundation (copy), Style (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy)
	return React.createElement(Foundation.FoundationProvider, {
		theme = t1.theme,
		overlayGui = t1.overlayGui
	}, {
		AppStyleProvider = React.createElement(Style.AppStyleProvider, {
			style = {
				fontName = "Gotham",
				themeName = t1.theme
			}
		}, {
			LocalizationProvider = React.createElement(LocalizationProvider, {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}, t1.children)
		})
	})
end

return ContextProviders
