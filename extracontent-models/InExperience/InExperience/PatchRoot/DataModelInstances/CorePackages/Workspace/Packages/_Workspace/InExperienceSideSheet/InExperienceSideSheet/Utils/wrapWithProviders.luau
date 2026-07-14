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
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav
local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = Style.UiModeStyleProvider
local UnibarStyle = Chrome.UnibarStyle
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local Provider = require(Parent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local u20 = nil

if FFlagSideSheetFocusNav then
	u20 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
end

local t1 = {
	isFocused = function() -- line: 38
		return true
	end,
	addListener = function(_: string, _: ((...any) -> ...any)) -- line: 41
		return {
			remove = function() -- line: 43
			end
		}
	end
}

local function wrapWithProviders(p2, t2: {[any]: any}, p3) -- line: 48
	-- upvalues: Rodux (copy), React (copy), FFlagEnableDrawerFocusNav (copy), RoactNavigation (copy), t1 (copy), RoactRodux (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UiModeStyleProvider (copy), Constants (copy), FFlagSideSheetFocusNav (copy), UnibarStyle (copy), ReactFocusNavigation (copy), u20 (ref), Provider (copy)
	local v28 = p3 or Rodux.Store.new(function(p4) -- line: 49
		return p4 or {}
	end)

	for _, v30 in t2 do
		p2 = React.createElement(v30, nil, p2)
	end

	if FFlagEnableDrawerFocusNav then
		p2 = React.createElement(RoactNavigation.Provider, {
			value = t1
		}, p2)
	end

	return React.createElement(RoactRodux.StoreProvider, {
		store = v28
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
				UnibarStyleProvider = if not FFlagSideSheetFocusNav then React.createElement(UnibarStyle.Provider, {}, p2) else React.createElement(UnibarStyle.Provider, {}, {
					FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
						value = u20
					}, {
						Registry = React.createElement(Provider, nil, p2)
					})
				})
			})
		})
	})
end

return wrapWithProviders
