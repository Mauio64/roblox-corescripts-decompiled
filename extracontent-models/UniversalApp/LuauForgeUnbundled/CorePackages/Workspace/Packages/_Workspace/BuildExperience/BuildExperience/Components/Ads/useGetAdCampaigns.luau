local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local AdCampaigns = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaigns")

local useSignalState = SignalsReact.useSignalState

local function useGetAdCampaigns(p2)
	local fetchAdCampaigns = (p2 or AdCampaigns.getAdCampaignsStore(false)).getAndFetchAdCampaigns()

	return useSignalState(fetchAdCampaigns.data), (useSignalState(fetchAdCampaigns.status))
end

return useGetAdCampaigns
