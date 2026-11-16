local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local AdCampaignEligibility = require(parent.DataHydration.AdCampaignEligibility)

local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local computed = createComputed(function(): nil
	return nil
end)

local computed2 = createComputed(function(): string
	return "NotReady"
end)

local function useGetAdCampaignEligibility(p: number?, p2)
	local v

	if p == nil then
		v = false
	else
		v = p ~= 0
	end

	local v2

	if v then
		v2 = p2 or AdCampaignEligibility.getAdCampaignEligibilityStore(false)
	end

	local v3

	if v2 ~= nil then
		v3 = v2.getAndFetchEligibility(p)
	end

	local v4 = if v3 == nil then computed else v3.data
	local v5 = useSignalState(v4)
	local v6 = if v3 == nil then computed2 else v3.status
	local v7 = useSignalState(v6)

	if v7 ~= "Ready" then
		v5 = nil
	end

	return v5, v7
end

return useGetAdCampaignEligibility
