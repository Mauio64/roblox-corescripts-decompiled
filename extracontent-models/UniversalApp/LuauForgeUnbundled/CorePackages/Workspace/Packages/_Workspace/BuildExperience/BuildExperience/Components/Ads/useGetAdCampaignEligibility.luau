local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local AdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")

local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local computed = createComputed(function(): nil
	return nil
end)

local computed2 = createComputed(function(): string
	return "NotReady"
end)

local function useGetAdCampaignEligibility(p2, p3)
	local v5 = not (p2 == nil) and p2 ~= 0

	local v6 = if v5 then p3 or AdCampaignEligibility.getAdCampaignEligibilityStore(false) else nil

	local v7 = if v6 ~= nil then v6.getAndFetchEligibility(p2) else nil

	local v9 = if v7 == nil then computed else v7.data
	local v10 = useSignalState(v9)
	local v12 = if v7 == nil then computed2 else v7.status
	local v13 = useSignalState(v12)

	if v13 ~= "Ready" then
		v10 = nil
	end

	return v10, v13
end

return useGetAdCampaignEligibility
