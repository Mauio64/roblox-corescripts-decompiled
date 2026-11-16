local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local ToastNotificationWrapper = require(parent.ToastNotificationWrapper)
local react = dependencies.React
local reactRoblox = dependencies.ReactRoblox
require(parent.type)
local Style = require(parent2.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Foundation = require(parent2.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local RobloxAppLocales = require(parent2.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local ReactFocusNavigation = require(parent2.ReactFocusNavigation)

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local InGameToastNotificationActionEventReceiver = require(script.Parent.InGameToastNotificationActionEventReceiver)
local SecurityAlertEventReceiver = require(script.Parent.receivers.SecurityAlertEventReceiver)
local engineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")
local SharedFlags = require(parent2.SharedFlags)
local GetFFlagEnableSecurityAlertToastCallback = SharedFlags.GetFFlagEnableSecurityAlertToastCallback

return function(p)
	local toastNotification = Instance.new("Folder")
	toastNotification.Name = "ToastNotification"
	toastNotification.Parent = CoreGui
	local v

	if engineFeature then
		local createElement = react.createElement
		local v2 = { colorMode = Foundation.Enums.ColorMode.Dark }

		local createElement2 = react.createElement

		local createElement3 = react.createElement
		local v3 = {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}

		local createElement4 = react.createElement
		local provider = ReactFocusNavigation.FocusNavigationContext.Provider

		local createElement5 = react.createElement

		local v4 = { [1] = nil, [1] = nil, (react.createElement(InGameToastNotificationActionEventReceiver)) }
		local securityAlertEventReceiver

		if GetFFlagEnableSecurityAlertToastCallback() then
			securityAlertEventReceiver = react.createElement(SecurityAlertEventReceiver)
		end

		v4.SecurityAlertEventReceiver = securityAlertEventReceiver

		v4.ToastNotificationWrapper = react.createElement(ToastNotificationWrapper, {
			displayOrder = 13,
			renderLocation = p.renderLocation
		})
		v = createElement(FoundationProvider, v2, {
			StyleProvider = createElement2(
				StyleProviderWithDefaultTheme,
				{ withUiModeSupport = false, withDarkTheme = true },
				{
					LocalizationProvider = createElement3(LocalizationProvider, v3, {
						FocusNavigationProvider = createElement4(provider, {
							value = focusNavigationService
						}, {
							FocusNavigationRegistryProvider = createElement5(Provider, nil, v4)
						})
					})
				}
			)
		})
	else
		v = react.createElement(StyleProviderWithDefaultTheme, {
			withUiModeSupport = false,
			withDarkTheme = true
		}, {
			LocalizationProvider = react.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{
					ToastNotificationWrapper = react.createElement(ToastNotificationWrapper, {
						displayOrder = 13,
						renderLocation = p.renderLocation
					}),
					InGameToastNotificationActionEventReceiver = react.createElement(InGameToastNotificationActionEventReceiver)
				}
			)
		})
	end

	reactRoblox.createRoot(toastNotification):render(v)
end
