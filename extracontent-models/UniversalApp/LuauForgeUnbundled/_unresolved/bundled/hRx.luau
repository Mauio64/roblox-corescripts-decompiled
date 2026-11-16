local CorePackages = game:GetService("CorePackages")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3cEvents = SharedFlags.FFlagSignalsNavP3cEvents
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module2 = require("@luauforge/bundled/hRy")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getLegacyNavigationStore = if fFlagSignalsNavP3cEvents then require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore else nil

local function RouterAnalyticsReporterForRoactNav(p2)
	local routeHistory = p2.routeHistory
	local v5 = routeHistory[#routeHistory]
	local name = v5[#v5].name

	return Roact.createElement(module2, { currentPage = name })
end

if not fFlagSignalsNavP3cEvents then
	return RoactRodux.connect(function(p2, p3)
		local v6 = if fFlagUseNavigationSelectors then selectors.selectLegacyHistory(p2) else p2.Navigation.history
		return { routeHistory = v6 }
	end)(RouterAnalyticsReporterForRoactNav)
end

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local function RouterAnalyticsReporterForRoactNavWithSignals(p2)
	local v5 = useSignalState(getLegacyNavigationStore(false).getCurrentPageName)
	return React.createElement(module2, Cryo.Dictionary.union(p2, { currentPage = v5 }))
end

return React.memo(RouterAnalyticsReporterForRoactNavWithSignals)
