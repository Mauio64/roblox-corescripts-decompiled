local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/ToastNotificationWrapper")
local react = dependencies.React
local reactRoblox = dependencies.ReactRoblox
require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local styleProviderWithDefaultTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Style").StyleProviderWithDefaultTheme
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation")
local foundationProvider = Foundation.FoundationProvider
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/RobloxAppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Localization").LocalizationProvider

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ReactFocusNavigation")

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local provider = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/FocusNavigationUtils").FocusNavigableSurfaceRegistry.Provider

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/InGameToastNotificationActionEventReceiver")
local SecurityAlertEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/receivers/SecurityAlertEventReceiver")
local engineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")
local getFFlagEnableSecurityAlertToastCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/SharedFlags").GetFFlagEnableSecurityAlertToastCallback

return function(p2)
	local toastNotification = Instance.new("Folder")
	toastNotification.Name = "ToastNotification"
	toastNotification.Parent = CoreGui
	local v5

	if engineFeature then
		local createElement = react.createElement
		local v7 = { colorMode = Foundation.Enums.ColorMode.Dark }

		local createElement2 = react.createElement

		local createElement3 = react.createElement
		local v13 = {
			localization = localization.new(LocalizationService.RobloxLocaleId)
		}

		local createElement4 = react.createElement
		local provider2 = ReactFocusNavigation.FocusNavigationContext.Provider

		local createElement5 = react.createElement

		local v19 = { [1] = nil, [1] = nil, (react.createElement(module5)) }
		local v20 = if getFFlagEnableSecurityAlertToastCallback() then react.createElement(SecurityAlertEventReceiver) else nil
		v19.SecurityAlertEventReceiver = v20

		v19.ToastNotificationWrapper = react.createElement(module2, {
			displayOrder = 13,
			renderLocation = p2.renderLocation
		})
		v5 = createElement(foundationProvider, v7, {
			StyleProvider = createElement2(
				styleProviderWithDefaultTheme,
				{ withUiModeSupport = false, withDarkTheme = true },
				{
					LocalizationProvider = createElement3(localizationProvider, v13, {
						FocusNavigationProvider = createElement4(
							provider2,
							{ value = focusNavigationService },
							{
								FocusNavigationRegistryProvider = createElement5(provider, nil, v19)
							}
						)
					})
				}
			)
		})
	else
		v5 = react.createElement(
			styleProviderWithDefaultTheme,
			{ withUiModeSupport = false, withDarkTheme = true },
			{
				LocalizationProvider = react.createElement(
					localizationProvider,
					{
						localization = localization.new(LocalizationService.RobloxLocaleId)
					},
					{
						ToastNotificationWrapper = react.createElement(module2, {
							displayOrder = 13,
							renderLocation = p2.renderLocation
						}),
						InGameToastNotificationActionEventReceiver = react.createElement(module5)
					}
				)
			}
		)
	end

	reactRoblox.createRoot(toastNotification):render(v5)
end
