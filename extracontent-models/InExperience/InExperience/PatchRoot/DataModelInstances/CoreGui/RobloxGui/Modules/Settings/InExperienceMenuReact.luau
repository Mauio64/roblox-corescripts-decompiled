local CorePackages = game:GetService("CorePackages")
local EventIngestService = game:GetService("EventIngestService")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local analytics = Analytics.Analytics
local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local EventIngest = Analytics2.AnalyticsReporters.EventIngest
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices)
local ServiceProvider = RoactServices.RoactServices.ServiceProvider
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)

local parent = script.Parent
local Utils = require(parent.Integrations.Utils)

local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local LocalizationProvider = Localization.LocalizationProvider
local GetLocalizationServiceStore = Localization.GetLocalizationServiceStore
local localization = InExperienceLocales.Localization

local FoundationProvider = Foundation.FoundationProvider

local v = { colorMode = Foundation.Enums.ColorMode.Dark }

local function InExperienceMenuReact(p)
	local localizationServiceStore = GetLocalizationServiceStore(false)
	local v2 = SignalsReact.useSignalState(localizationServiceStore.getRobloxLocaleId)
	local localization2 = localization.new(v2)

	return React.createElement(ServiceProvider, {
		services = {
			[AppEventIngestService] = EventIngest.new(EventIngestService),
			[RoactAnalytics] = analytics.new()
		}
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = localization2
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				colorMode = p.theme or v.colorMode,
				device = Utils.getDeviceType()
			}, p.children)
		})
	})
end

return React.memo(InExperienceMenuReact)
