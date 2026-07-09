local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3cEvents = SharedFlags.FFlagSignalsNavP3cEvents
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RouterAnalyticsReporter = require(script.Parent.RouterAnalyticsReporter)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v10 = if not FFlagSignalsNavP3cEvents then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore

local function RouterAnalyticsReporterForRoactNav(p1) -- line: 18
	-- upvalues: Roact (copy), RouterAnalyticsReporter (copy)
	local routeHistory = p1.routeHistory
	local v17 = routeHistory[#routeHistory]
	local name = v17[#v17].name

	return Roact.createElement(RouterAnalyticsReporter, {
		currentPage = name
	})
end

if FFlagSignalsNavP3cEvents then
	local React = require(CorePackages.Packages.React)
	local Cryo = require(CorePackages.Packages.Cryo)

	local function RouterAnalyticsReporterForRoactNavWithSignals(p2) -- line: 31
		-- upvalues: v10 (copy), useSignalState (copy), React (copy), RouterAnalyticsReporter (copy), Cryo (copy)
		local v20 = v10(false)
		local v21 = useSignalState(v20.getCurrentPage)

		return React.createElement(RouterAnalyticsReporter, Cryo.Dictionary.union(p2, {
			currentPage = v21.name
		}))
	end

	return RouterAnalyticsReporterForRoactNavWithSignals
end

return RoactRodux.connect(function(p3, _) -- line: 43
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	return {
		routeHistory = if not FFlagUseNavigationSelectors then p3.Navigation.history else Selectors.selectLegacyHistory(p3)
	}
end)(RouterAnalyticsReporterForRoactNav)
