local ParentParent = script.Parent.Parent
local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")
local u4 = if not game:DefineFastFlag("SwitchCSRootProviderTranslationsPackage", false) then require(ParentParent.RobloxAppLocales).Localization else require(ParentParent.InExperienceLocales).Localization
local LocalizationProvider = require(ParentParent.Localization).LocalizationProvider
local DesignTokenProvider = require(ParentParent.Style).DesignTokenProvider
local Cryo = require(ParentParent.Cryo)
local React = require(ParentParent.React)
local Rodux = require(ParentParent.Rodux)
local RoactRodux = require(ParentParent.RoactRodux)
local UIBlox = require(ParentParent.UIBlox)
local Foundation = require(ParentParent.Foundation)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local RobloxAppEnums = require(ParentParent.RobloxAppEnums)
local ReactFocusNavigation = require(ParentParent.ReactFocusNavigation)
local Provider = require(ParentParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local DeviceType = RobloxAppEnums.DeviceType
local GamepadDisconnectTokenMapper = require(ParentParent.InputUi).Gamepad.GamepadDisconnectTokenMapper
local FeedbackManagerInjectionContextProvider = require(ParentParent.InteractionFeedback).FeedbackManagerInjectionContextProvider
local AppInteractionFeedbackProvider = require(ParentParent.RobloxAppInteractionFeedbackConfig).AppInteractionFeedbackProvider
local v21 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local t1 = {
	themeName = "dark",
	fontName = "gotham",
	deviceType = if not GuiService:IsTenFootInterface() then DeviceType.Desktop else DeviceType.Console
}

local function CoreScriptsRootProvider(t2: {[any]: any}) -- line: 61
	-- upvalues: Cryo (copy), t1 (copy), React (copy), RoactRodux (copy), Rodux (copy), UIBlox (copy), DesignTokenProvider (copy), GamepadDisconnectTokenMapper (copy), SelectionCursorProvider (copy), LocalizationProvider (copy), u4 (ref), LocalizationService (copy), ReactFocusNavigation (copy), v21 (copy), Provider (copy), Foundation (copy), DeviceType (copy), AppInteractionFeedbackProvider (copy), FeedbackManagerInjectionContextProvider (copy)
	local v25 = Cryo.Dictionary.join(t1, t2.styleOverride or {})
	local v26 = React.createElement(RoactRodux.StoreProvider, {
		store = Rodux.Store.new(function(p1) -- line: 65
			return p1
		end, {}, {})
	}, {
		AppStyleProvider = React.createElement(UIBlox.App.Style.AppStyleProvider, {
			style = v25
		}, {
			DesignTokenProvider = React.createElement(DesignTokenProvider, {
				tokenMappers = {
					GamepadDisconnect = GamepadDisconnectTokenMapper
				}
			}, {
				CursorProvider = React.createElement(SelectionCursorProvider, {}, {
					LocalizationProvider = React.createElement(LocalizationProvider, {
						localization = u4.new(LocalizationService.RobloxLocaleId)
					}, {
						FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
							value = v21
						}, {
							FocusNavigationRegistryProvider = React.createElement(Provider, nil, t2.children)
						})
					})
				})
			})
		})
	})
	local v27 = React.createElement(Foundation.FoundationProvider, {
		theme = if v25.themeName ~= "dark" then Foundation.Enums.Theme.Light else Foundation.Enums.Theme.Dark,
		device = if v25.deviceType ~= DeviceType.Console then Foundation.Enums.Device.Desktop else Foundation.Enums.Device.Console
	}, {
		tree = v26
	})

	return (React.createElement(AppInteractionFeedbackProvider, {}, {
		tree = React.createElement(FeedbackManagerInjectionContextProvider, nil, {
			tree = v27
		})
	}))
end

return CoreScriptsRootProvider
