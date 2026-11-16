local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local Chrome = require(parent.Chrome)
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local Style = require(parent.Style)
local UIBlox = require(parent.UIBlox)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy

local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = Style.UiModeStyleProvider
local UnibarStyle = Chrome.UnibarStyle

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local focusNavigationService

if FFlagSideSheetFocusNav then
	focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
else
	focusNavigationService = nil
end

local v = {
	isFocused = function(): boolean
		return true
	end,
	addListener = function(_: string, _)
		return {
			remove = function() end
		}
	end
}

local function wrapWithProviders(p, items, p2)
	local store = p2 or Rodux.Store.new(function(options)
		return options or {}
	end)

	if isPioneerLaunch() then
		p = React.createElement(RoactAppPolicy.Provider, {
			policy = { AppFeaturePolicies }
		}, p)
	end

	for _, item in items do
		p = React.createElement(item, nil, p)
	end

	if FFlagEnableDrawerFocusNav then
		p = React.createElement(RoactNavigation.Provider, { value = v }, p)
	end

	local createElement = React.createElement
	local storeProvider = RoactRodux.StoreProvider

	local createElement2 = React.createElement
	local v2 = {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}

	local createElement3 = React.createElement
	local v3 = {
		style = { themeName = ColorMode.Dark, fontName = Constants.FontName.Gotham }
	}
	local unibarStyleProvider

	if FFlagSideSheetFocusNav then
		unibarStyleProvider = React.createElement(UnibarStyle.Provider, {}, {
			FocusNavigationProvider = React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = focusNavigationService },
				{
					Registry = React.createElement(Provider, nil, p)
				}
			)
		})
	else
		unibarStyleProvider = React.createElement(UnibarStyle.Provider, {}, p)
	end

	return createElement(storeProvider, { store = store }, {
		LocalizationProvider = createElement2(LocalizationProvider, v2, {
			UiModeStyleProvider = createElement3(UiModeStyleProvider, v3, {
				UnibarStyleProvider = unibarStyleProvider
			})
		})
	})
end

return wrapWithProviders
