local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Chrome = require(Parent.Chrome)
local Localization = require(Parent.InExperienceLocales).Localization
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local RoactRodux = require(Parent.RoactRodux)
local Rodux = require(Parent.Rodux)
local Style = require(Parent.Style)
local UIBlox = require(Parent.UIBlox)
local FFlagEnableDrawerFocusNav = require(Parent.SharedFlags).FFlagEnableDrawerFocusNav
local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = Style.UiModeStyleProvider
local UnibarStyle = Chrome.UnibarStyle
local t1 = {
	isFocused = function() -- line: 28
		return true
	end,
	addListener = function(_: string, _: ((...any) -> ...any)) -- line: 31
		return {
			remove = function() -- line: 33
			end
		}
	end
}

local function wrapWithProviders(p2, t2: {[any]: any}, p3) -- line: 38
	-- upvalues: Rodux (copy), React (copy), FFlagEnableDrawerFocusNav (copy), RoactNavigation (copy), t1 (copy), RoactRodux (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UiModeStyleProvider (copy), Constants (copy), UnibarStyle (copy)
	local v23 = p3 or Rodux.Store.new(function(p4) -- line: 39
		return p4 or {}
	end)

	for _, v25 in t2 do
		p2 = React.createElement(v25, nil, p2)
	end

	if FFlagEnableDrawerFocusNav then
		p2 = React.createElement(RoactNavigation.Provider, {
			value = t1
		}, p2)
	end

	return React.createElement(RoactRodux.StoreProvider, {
		store = v23
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			UiModeStyleProvider = React.createElement(UiModeStyleProvider, {
				style = {
					themeName = Constants.ThemeName.Dark,
					fontName = Constants.FontName.Gotham
				}
			}, {
				UnibarStyleProvider = React.createElement(UnibarStyle.Provider, {}, p2)
			})
		})
	})
end

return wrapWithProviders
