local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local AdCampaigns = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaigns")
local CampaignStats = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CampaignStats")
local AdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")

local useSignalState = SignalsReact.useSignalState

local computed = Signals.createComputed(function(): string
	return "NotReady"
end)

local computed2 = Signals.createComputed(function(): nil
	return nil
end)

local function useRefreshAdsData(p2, options)
	local v5 = options or {}
	local includeEligibility = v5.includeEligibility == true
	local v6 = not (p2 == nil) and p2 ~= 0

	local adCampaignsStore = v5.adCampaignsStore or AdCampaigns.getAdCampaignsStore(false)
	local campaignStatsStore = v5.campaignStatsStore or CampaignStats.getCampaignStatsStore(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local adCampaignEligibilityStore

	if includeEligibility then
		adCampaignEligibilityStore = v5.adCampaignEligibilityStore
			or AdCampaignEligibility.getAdCampaignEligibilityStore(false)
	else
		adCampaignEligibilityStore = nil
	end

	local adCampaigns = adCampaignsStore.getAdCampaigns()

	local v7 = if v6 then campaignStatsStore.getCampaignStats(p2) else nil

	local v8 = useSignalState(adCampaigns.status)
	local v9 = useSignalState(adCampaigns.data)

	local v11 = if v7 == nil then computed else v7.status
	local v12 = useSignalState(v11)

	local v14 = if v7 == nil then computed2 else v7.data
	local v15 = useSignalState(v14)
	local v16 = React.useCallback(function()
		ref.current = adCampaignsStore.isAdCampaignsRequestInQueueOrInFlight()
		adCampaignsStore.fetchAdCampaigns()

		if v6 and v7 ~= nil then
			local v17 = ref2
			local v18 = if campaignStatsStore.isCampaignStatsRequestInQueueOrInFlight(p2) then p2 else nil
			v17.current = v18

			campaignStatsStore.fetchCampaignStats(p2)
		else
			ref2.current = nil
		end

		if adCampaignEligibilityStore ~= nil and v6 then
			adCampaignEligibilityStore.fetchEligibility(p2)
		end
	end, {
		p2,
		v6,
		adCampaignsStore,
		campaignStatsStore,
		adCampaignEligibilityStore,
		adCampaigns,
		v7
	})

	React.useEffect(function()
		if ref.current and not adCampaignsStore.isAdCampaignsRequestInQueueOrInFlight() then
			ref.current = false
			adCampaignsStore.fetchAdCampaigns()
		end
	end, { v9, v8, adCampaignsStore })

	React.useEffect(function()
		if
			p2 ~= nil
			and ref2.current == p2
			and not campaignStatsStore.isCampaignStatsRequestInQueueOrInFlight(p2)
		then
			ref2.current = nil
			campaignStatsStore.fetchCampaignStats(p2)
		end
	end, { p2, v15, v12, campaignStatsStore })

	return v16
end

return useRefreshAdsData
