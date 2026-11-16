local parent = script:FindFirstAncestor("BuildExperience").Parent

local SignalsReact = require(parent.SignalsReact)

local AdCampaigns = require(parent.DataHydration.AdCampaigns)

local useSignalState = SignalsReact.useSignalState

local function useGetAdCampaigns(p)
	local fetchAdCampaigns = (p or AdCampaigns.getAdCampaignsStore(false)).getAndFetchAdCampaigns()

	return useSignalState(fetchAdCampaigns.data), (useSignalState(fetchAdCampaigns.status))
end

return useGetAdCampaigns
