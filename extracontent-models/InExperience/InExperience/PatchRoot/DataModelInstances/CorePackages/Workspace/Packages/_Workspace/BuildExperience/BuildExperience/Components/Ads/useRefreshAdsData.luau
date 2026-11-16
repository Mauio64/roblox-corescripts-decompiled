local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local AdCampaigns = require(parent.DataHydration.AdCampaigns)
local CampaignStats = require(parent.DataHydration.CampaignStats)
local AdCampaignEligibility = require(parent.DataHydration.AdCampaignEligibility)

local useSignalState = SignalsReact.useSignalState

local computed = Signals.createComputed(function(): string
	return "NotReady"
end)

local computed2 = Signals.createComputed(function(): nil
	return nil
end)

local function useRefreshAdsData(p: number?, options)
	local v = options or {}
	local includeEligibility = v.includeEligibility == true
	local v2

	if p == nil then
		v2 = false
	else
		v2 = p ~= 0
	end

	local adCampaignsStore = v.adCampaignsStore or AdCampaigns.getAdCampaignsStore(false)
	local campaignStatsStore = v.campaignStatsStore or CampaignStats.getCampaignStatsStore(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local adCampaignEligibilityStore

	if includeEligibility then
		adCampaignEligibilityStore = v.adCampaignEligibilityStore
			or AdCampaignEligibility.getAdCampaignEligibilityStore(false)
	else
		adCampaignEligibilityStore = nil
	end

	local adCampaigns = adCampaignsStore.getAdCampaigns()
	local v3

	if v2 then
		v3 = campaignStatsStore.getCampaignStats(p)
	else
		v3 = nil
	end

	local v4 = useSignalState(adCampaigns.status)
	local v5 = useSignalState(adCampaigns.data)

	local v6 = if v3 == nil then computed else v3.status
	local v7 = useSignalState(v6)

	local v8 = if v3 == nil then computed2 else v3.data
	local v9 = useSignalState(v8)
	local v10 = React.useCallback(function()
		ref.current = adCampaignsStore.isAdCampaignsRequestInQueueOrInFlight()
		adCampaignsStore.fetchAdCampaigns()

		if v2 and v3 ~= nil then
			local current

			if campaignStatsStore.isCampaignStatsRequestInQueueOrInFlight(p) then
				current = p
			end

			ref2.current = current

			campaignStatsStore.fetchCampaignStats(p)
		else
			ref2.current = nil
		end

		if adCampaignEligibilityStore ~= nil and v2 then
			adCampaignEligibilityStore.fetchEligibility(p)
		end
	end, {
		p,
		v2,
		adCampaignsStore,
		campaignStatsStore,
		adCampaignEligibilityStore,
		adCampaigns,
		v3
	})

	React.useEffect(function()
		if ref.current and not adCampaignsStore.isAdCampaignsRequestInQueueOrInFlight() then
			ref.current = false
			adCampaignsStore.fetchAdCampaigns()
		end
	end, { v5, v4, adCampaignsStore })

	React.useEffect(function()
		if p ~= nil and ref2.current == p and not campaignStatsStore.isCampaignStatsRequestInQueueOrInFlight(p) then
			ref2.current = nil
			campaignStatsStore.fetchCampaignStats(p)
		end
	end, { p, v9, v7, campaignStatsStore })

	return v10
end

return useRefreshAdsData
