local parent = script.Parent.Parent

local LocalizationService = game:GetService("LocalizationService")

local AppCommonLib = require(parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
local localization

if game:DefineFastFlag("SwitchCSRootProviderTranslationsPackage", false) then
	local InExperienceLocales = require(parent.InExperienceLocales)
	localization = InExperienceLocales.Localization
else
	local RobloxAppLocales = require(parent.RobloxAppLocales)
	localization = RobloxAppLocales.Localization
end

local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local Style = require(parent.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local RobloxAppEnums = require(parent.RobloxAppEnums)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local DeviceType = RobloxAppEnums.DeviceType
local InputUi = require(parent.InputUi)
local GamepadDisconnectTokenMapper = InputUi.Gamepad.GamepadDisconnectTokenMapper
local InteractionFeedback = require(parent.InteractionFeedback)
local FeedbackManagerInjectionContextProvider = InteractionFeedback.FeedbackManagerInjectionContextProvider

local RobloxAppInteractionFeedbackConfig = require(parent.RobloxAppInteractionFeedbackConfig)
local AppInteractionFeedbackProvider = RobloxAppInteractionFeedbackConfig.AppInteractionFeedbackProvider

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

local v = { themeName = "dark", fontName = "gotham", deviceType = 0 }
local deviceType

if isTenFootInterface() then
	deviceType = DeviceType.Console
else
	deviceType = DeviceType.Desktop
end

v.deviceType = deviceType

local function CoreScriptsRootProvider(p)
	local joined = Cryo.Dictionary.join(v, p.styleOverride or {})

	local element = React.createElement(RoactRodux.StoreProvider, {
		store = Rodux.Store.new(function(p2)
			return p2
		end, {}, {})
	}, {
		AppStyleProvider = React.createElement(UIBlox.App.Style.AppStyleProvider, { style = joined }, {
			DesignTokenProvider = React.createElement(DesignTokenProvider, {
				tokenMappers = { GamepadDisconnect = GamepadDisconnectTokenMapper }
			}, {
				CursorProvider = React.createElement(SelectionCursorProvider, {}, {
					LocalizationProvider = React.createElement(
						LocalizationProvider,
						{
							localization = localization.new(LocalizationService.RobloxLocaleId)
						},
						{
							FocusNavigationProvider = React.createElement(
								ReactFocusNavigation.FocusNavigationContext.Provider,
								{ value = focusNavigationService },
								{
									FocusNavigationRegistryProvider = React.createElement(Provider, nil, p.children)
								}
							)
						}
					)
				})
			})
		})
	})

	local createElement = React.createElement
	local foundationProvider = Foundation.FoundationProvider
	local colorMode

	if joined.themeName == "dark" then
		colorMode = Foundation.Enums.ColorMode.Dark
	else
		colorMode = Foundation.Enums.ColorMode.Light
	end

	local device

	if joined.deviceType == DeviceType.Console then
		device = Foundation.Enums.Device.Console
	else
		device = Foundation.Enums.Device.Desktop
	end

	local element2 = createElement(foundationProvider, { colorMode = colorMode, device = device }, {
		tree = element
	})

	return (React.createElement(AppInteractionFeedbackProvider, {}, {
		tree = React.createElement(FeedbackManagerInjectionContextProvider, nil, { tree = element2 })
	}))
end

return CoreScriptsRootProvider
