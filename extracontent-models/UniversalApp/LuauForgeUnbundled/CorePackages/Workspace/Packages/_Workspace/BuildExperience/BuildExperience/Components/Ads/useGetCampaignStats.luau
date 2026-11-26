local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local CampaignStats = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CampaignStats")

local useSignalState = SignalsReact.useSignalState
local createComputed = Signals.createComputed

local v5 = { plays = false, adClicks = false, adViews = false, playtimeSeconds = false }

local computed = createComputed(function(): nil
	return nil
end)

local computed2 = createComputed(function(): string
	return "NotReady"
end)

local function hasFailedMetric(p2)
	if p2 == nil then
		return false
	end

	local failedMetrics = p2.failedMetrics
	return failedMetrics.plays
		or failedMetrics.adClicks
		or failedMetrics.adViews
		or failedMetrics.playtimeSeconds
end

local function useGetCampaignStats(p2, p3)
	local v6 = p3 or CampaignStats.getCampaignStatsStore(false)
	local v7 = not (p2 == nil) and p2 ~= 0

	local ref = React.useRef(nil)
	local v8 = nil

	if v7 then
		local current = ref.current

		if current == nil or current.store ~= v6 or current.universeId ~= p2 then
			v8 = hasFailedMetric
			ref.current = { store = v6, universeId = p2 }
		end
	else
		ref.current = nil
	end

	local v9 = if v7 then v6.getAndFetchCampaignStats(p2, v8) else nil

	local v11 = if v9 == nil then computed else v9.data
	local v12 = useSignalState(v11)
	local v14 = if v9 == nil then computed2 else v9.status
	local v15 = useSignalState(v14)
	local byCampaign = if v12 ~= nil then v12.byCampaign else nil

	if v12 == nil then
		return byCampaign, v15, v5
	end

	return byCampaign, v15, v12.failedMetrics
end

return useGetCampaignStats
