local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local dependencies = require(scriptParent.dependencies)
local ToastNotificationWrapper = require(scriptParent.ToastNotificationWrapper)
local React = dependencies.React
local ReactRoblox = dependencies.ReactRoblox

require(scriptParent.type)

local StyleProviderWithDefaultTheme = require(scriptParentParent.Style).StyleProviderWithDefaultTheme
local Foundation = require(scriptParentParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(scriptParentParent.RobloxAppLocales).Localization
local LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider
local ReactFocusNavigation = require(scriptParentParent.ReactFocusNavigation)
local v15 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local Provider = require(scriptParentParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local InGameToastNotificationActionEventReceiver = require(script.Parent.InGameToastNotificationActionEventReceiver)
local SecurityAlertEventReceiver = require(script.Parent.receivers.SecurityAlertEventReceiver)
local EngineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")
local GetFFlagEnableSecurityAlertToastCallback = require(scriptParentParent.SharedFlags).GetFFlagEnableSecurityAlertToastCallback

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: CoreGui (copy), EngineFeature (copy), React (copy), FoundationProvider (copy), Foundation (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), ReactFocusNavigation (copy), v15 (copy), Provider (copy), InGameToastNotificationActionEventReceiver (copy), GetFFlagEnableSecurityAlertToastCallback (copy), SecurityAlertEventReceiver (copy), ToastNotificationWrapper (copy), ReactRoblox (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "ToastNotification"
	Folder.Parent = CoreGui

	local v23 = if not EngineFeature then React.createElement(StyleProviderWithDefaultTheme, {
		withUiModeSupport = false,
		withDarkTheme = true
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		}, {
			ToastNotificationWrapper = React.createElement(ToastNotificationWrapper, {
				displayOrder = 13,
				renderLocation = t1.renderLocation
			}),
			InGameToastNotificationActionEventReceiver = React.createElement(InGameToastNotificationActionEventReceiver)
		})
	}) else React.createElement(FoundationProvider, {
		theme = Foundation.Enums.Theme.Dark
	}, {
		StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {
			withUiModeSupport = false,
			withDarkTheme = true
		}, {
			LocalizationProvider = React.createElement(LocalizationProvider, {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
					value = v15
				}, {
					FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
						React.createElement(InGameToastNotificationActionEventReceiver),
						SecurityAlertEventReceiver = if not GetFFlagEnableSecurityAlertToastCallback() then nil else React.createElement(SecurityAlertEventReceiver),
						ToastNotificationWrapper = React.createElement(ToastNotificationWrapper, {
							displayOrder = 13,
							renderLocation = t1.renderLocation
						})
					})
				})
			})
		})
	})

	ReactRoblox.createRoot(Folder):render(v23)
end
