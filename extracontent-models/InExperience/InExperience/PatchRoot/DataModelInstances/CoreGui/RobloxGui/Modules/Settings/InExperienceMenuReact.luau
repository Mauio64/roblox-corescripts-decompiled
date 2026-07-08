local CorePackages = game:GetService("CorePackages")
local EventIngestService = game:GetService("EventIngestService")
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Analytics = require(CorePackages.Workspace.Packages.Analytics).Analytics
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local ServiceProvider = require(CorePackages.Workspace.Packages.RoactServices).RoactServices.ServiceProvider
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local scriptParent = script.Parent
local Utils = require(scriptParent.Integrations.Utils)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local LocalizationProvider = Localization.LocalizationProvider
local GetLocalizationServiceStore = Localization.GetLocalizationServiceStore
local Localization2 = InExperienceLocales.Localization
local FoundationProvider = Foundation.FoundationProvider
local t1 = {
	theme = Foundation.Enums.Theme.Dark
}

local function InExperienceMenuReact(t2: {[any]: any}) -- line: 38
	-- upvalues: GetLocalizationServiceStore (copy), SignalsReact (copy), Localization2 (copy), React (copy), ServiceProvider (copy), AppEventIngestService (copy), EventIngest (copy), EventIngestService (copy), RoactAnalytics (copy), Analytics (copy), LocalizationProvider (copy), FoundationProvider (copy), t1 (copy), Utils (copy)
	local v23 = GetLocalizationServiceStore(false)
	local v24 = SignalsReact.useSignalState(v23.getRobloxLocaleId)
	local v25 = Localization2.new(v24)

	return React.createElement(ServiceProvider, {
		services = {
			[AppEventIngestService] = EventIngest.new(EventIngestService),
			[RoactAnalytics] = Analytics.new()
		}
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = v25
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				theme = t2.theme or t1.theme,
				device = Utils.getDeviceType()
			}, t2.children)
		})
	})
end

return React.memo(InExperienceMenuReact)
