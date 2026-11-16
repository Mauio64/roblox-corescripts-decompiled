local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local CampaignStats = require(parent.DataHydration.CampaignStats)

local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local v = { plays = false, adClicks = false, adViews = false, playtimeSeconds = false }

local computed = createComputed(function(): nil
	return nil
end)

local computed2 = createComputed(function(): string
	return "NotReady"
end)

local function hasFailedMetric(p)
	if p == nil then
		return false
	end

	local failedMetrics = p.failedMetrics
	return failedMetrics.plays or failedMetrics.adClicks or failedMetrics.adViews or failedMetrics.playtimeSeconds
end

local function useGetCampaignStats(universeId: number?, p)
	local store = p or CampaignStats.getCampaignStatsStore(false)
	local v2

	if universeId == nil then
		v2 = false
	else
		v2 = universeId ~= 0
	end

	local ref = React.useRef(nil)
	local v3 = nil

	if v2 then
		local current = ref.current

		if current == nil or current.store ~= store or current.universeId ~= universeId then
			v3 = hasFailedMetric
			ref.current = { store = store, universeId = universeId }
		end
	else
		ref.current = nil
	end

	local v4

	if v2 then
		v4 = store.getAndFetchCampaignStats(universeId, v3)
	end

	local v5 = if v4 == nil then computed else v4.data
	local v6 = useSignalState(v5)
	local v7 = if v4 == nil then computed2 else v4.status
	local v8 = useSignalState(v7)
	local byCampaign

	if v6 ~= nil then
		byCampaign = v6.byCampaign
	end

	if v6 == nil then
		return byCampaign, v8, v
	end

	return byCampaign, v8, v6.failedMetrics
end

return useGetCampaignStats
