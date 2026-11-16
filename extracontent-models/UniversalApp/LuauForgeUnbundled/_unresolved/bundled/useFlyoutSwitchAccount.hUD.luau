local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/fPh")
local module2 = require("@luauforge/bundled/fsy")
local module3 = require("@luauforge/bundled/fMG")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local appOmniRecommendationsRequest = RoactServiceTags.AppOmniRecommendationsRequest
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fStringLuaLoginRevampIxpLayer = SharedFlags.FStringLuaLoginRevampIxpLayer
local fFlagLoginV2FullFlowDevOverride = SharedFlags.FFlagLoginV2FullFlowDevOverride

local function useFlyoutSwitchAccount(p2)
	local v5 = useRoactService(roactNetworking)
	local v6 = useRoactService(module3)
	local v7 = useAppPolicy(function(p3)
		return p3
	end)

	local v8 = useRoactService(appOmniRecommendationsRequest)
	local v9 = useDispatch()

	local v10 = RoactAppExperiment.useBrowserTrackerExperiment(
		{ fStringLuaLoginRevampIxpLayer },
		function(p3)
			local v11 = p3[fStringLuaLoginRevampIxpLayer] or {}
			return {
				showLoginRevamp = fFlagLoginV2FullFlowDevOverride or v11.showLoginRevamp
			}
		end
	)

	return React.useCallback(function()
		v9(module(true, v5, module2.Origin.FlyoutSidePanel, v6, v7, v8, p2, v10.showLoginRevamp))

		v6.reportAuthButtonClick(module2.Context.FlyoutSidePanel, module2.Button.SwitchAccounts)
	end, { v5, v6, v7, v8, p2, v10.showLoginRevamp, v9 })
end

return useFlyoutSwitchAccount
