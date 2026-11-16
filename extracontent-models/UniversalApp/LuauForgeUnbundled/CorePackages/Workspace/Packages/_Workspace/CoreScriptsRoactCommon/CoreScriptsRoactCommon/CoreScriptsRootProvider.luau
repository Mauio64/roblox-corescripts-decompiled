local LocalizationService = game:GetService("LocalizationService")

local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/AppCommonLib").isTenFootInterface
local localization

if game:DefineFastFlag("SwitchCSRootProviderTranslationsPackage", false) then
	localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/InExperienceLocales").Localization
else
	localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/RobloxAppLocales").Localization
end

local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Localization").LocalizationProvider
local designTokenProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Style").DesignTokenProvider
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Rodux")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/RoactRodux")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Foundation")
local selectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/RobloxAppEnums")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/ReactFocusNavigation")
local provider = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/FocusNavigationUtils").FocusNavigableSurfaceRegistry.Provider
local deviceType = RobloxAppEnums.DeviceType
local gamepadDisconnectTokenMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/InputUi").Gamepad.GamepadDisconnectTokenMapper
local feedbackManagerInjectionContextProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/InteractionFeedback").FeedbackManagerInjectionContextProvider

local appInteractionFeedbackProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/RobloxAppInteractionFeedbackConfig").AppInteractionFeedbackProvider

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

local v5 = { themeName = "dark", fontName = "gotham", deviceType = 0 }

local v6 = if isTenFootInterface() then deviceType.Console else deviceType.Desktop
v5.deviceType = v6

local function CoreScriptsRootProvider(p2)
	local joined = Cryo.Dictionary.join(v5, p2.styleOverride or {})

	local element = React.createElement(RoactRodux.StoreProvider, {
		store = Rodux.Store.new(function(p3)
			return p3
		end, {}, {})
	}, {
		AppStyleProvider = React.createElement(UIBlox.App.Style.AppStyleProvider, {
			style = joined
		}, {
			DesignTokenProvider = React.createElement(designTokenProvider, {
				tokenMappers = { GamepadDisconnect = gamepadDisconnectTokenMapper }
			}, {
				CursorProvider = React.createElement(selectionCursorProvider, {}, {
					LocalizationProvider = React.createElement(
						localizationProvider,
						{
							localization = localization.new(LocalizationService.RobloxLocaleId)
						},
						{
							FocusNavigationProvider = React.createElement(
								ReactFocusNavigation.FocusNavigationContext.Provider,
								{ value = focusNavigationService },
								{
									FocusNavigationRegistryProvider = React.createElement(provider, nil, p2.children)
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
	local v8 = if joined.themeName == "dark" then Foundation.Enums.ColorMode.Dark else Foundation.Enums.ColorMode.Light
	local v9 = if joined.deviceType == deviceType.Console then Foundation.Enums.Device.Console else Foundation.Enums.Device.Desktop
	local element2 = createElement(foundationProvider, { colorMode = v8, device = v9 }, {
		tree = element
	})

	return (React.createElement(appInteractionFeedbackProvider, {}, {
		tree = React.createElement(feedbackManagerInjectionContextProvider, nil, {
			tree = element2
		})
	}))
end

return CoreScriptsRootProvider
