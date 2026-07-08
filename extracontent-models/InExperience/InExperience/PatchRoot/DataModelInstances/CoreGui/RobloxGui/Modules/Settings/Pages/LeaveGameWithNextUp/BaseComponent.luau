local EventIngestService = game:GetService("EventIngestService")
local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Analytics = require(CorePackages.Workspace.Packages.Analytics).Analytics
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local ServiceProvider = require(CorePackages.Workspace.Packages.RoactServices).RoactServices.ServiceProvider
local Style = require(CorePackages.Workspace.Packages.Style)
local FFlagEnableNextUpImageLatencyTelemetry = require(script.Parent.Flags.FFlagEnableNextUpImageLatencyTelemetry)
local FoundationProvider = Foundation.FoundationProvider
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local v19 = Localization.new(LocalizationService.RobloxLocaleId)
local v20 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

return function(p1) -- line: 29
	-- upvalues: React (copy), ServiceProvider (copy), AppEventIngestService (copy), EventIngest (copy), EventIngestService (copy), RoactAnalytics (copy), Analytics (copy), LocalizationProvider (copy), v19 (copy), FoundationProvider (copy), ReactFocusNavigation (copy), v20 (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), StyleProviderWithDefaultTheme (copy)
	return React.createElement(ServiceProvider, {
		services = {
			[AppEventIngestService] = EventIngest.new(EventIngestService),
			[RoactAnalytics] = Analytics.new()
		}
	}, {
		localizationProvider = React.createElement(LocalizationProvider, {
			localization = v19
		}, {
			foundationProvider = React.createElement(FoundationProvider, nil, {
				FocusNavigationProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
					value = v20
				}, if not FFlagEnableNextUpImageLatencyTelemetry then {
					uiBloxStyleProvider = React.createElement(StyleProviderWithDefaultTheme, nil, p1.children)
				} else p1.children)
			})
		})
	})
end
