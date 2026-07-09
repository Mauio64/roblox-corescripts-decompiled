local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local OpenAccountSwitcher = require(Modules.LuaApp.Thunks.Authentication.OpenAccountSwitcher)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppOmniRecommendationsRequest = RoactServiceTags.AppOmniRecommendationsRequest
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableLuaLoginRevamp = SharedFlags.FFlagEnableLuaLoginRevamp
local FStringLuaLoginRevampIxpLayer = SharedFlags.FStringLuaLoginRevampIxpLayer

local function useFlyoutSwitchAccount(p1, p2) -- line: 19
	-- upvalues: useRoactService (copy), RoactNetworking (copy), RoactAnalyticsAuthEvents (copy), useAppPolicy (copy), AppOmniRecommendationsRequest (copy), useDispatch (copy), FFlagEnableLuaLoginRevamp (copy), RoactAppExperiment (copy), FStringLuaLoginRevampIxpLayer (copy), React (copy), OpenAccountSwitcher (copy), EventStreamConstants (copy)
	local v20 = useRoactService(RoactNetworking)
	local v21 = useRoactService(RoactAnalyticsAuthEvents)
	local v22 = useAppPolicy(function(p3) -- line: 22
		return p3
	end)
	local v23 = useRoactService(AppOmniRecommendationsRequest)
	local v24 = useDispatch()
	local t1 = {
		showLoginRevamp = false
	}

	if FFlagEnableLuaLoginRevamp then
		t1 = RoactAppExperiment.useBrowserTrackerExperiment({ FStringLuaLoginRevampIxpLayer }, function(p4) -- line: 32
			-- upvalues: FStringLuaLoginRevampIxpLayer (copy)
			return {
				showLoginRevamp = (p4[FStringLuaLoginRevampIxpLayer] or {}).showLoginRevamp
			}
		end)
	end

	return React.useCallback(function() -- line: 41
		-- upvalues: v24 (copy), OpenAccountSwitcher (copy), v20 (copy), EventStreamConstants (copy), v21 (copy), v22 (copy), v23 (copy), p1 (copy), p2 (copy), t1 (ref)
		v24(OpenAccountSwitcher(true, v20, EventStreamConstants.Origin.FlyoutSidePanel, v21, v22, v23, p1, p2, t1.showLoginRevamp))
		v21.reportAuthButtonClick(EventStreamConstants.Context.FlyoutSidePanel, EventStreamConstants.Button.SwitchAccounts)
	end, {
		v20,
		v21,
		v22,
		v23,
		p1,
		p2,
		t1.showLoginRevamp,
		v24
	})
end

return useFlyoutSwitchAccount
