local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/CreatorAnalytics")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local getPostInsightsQueryParams = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsQueryParams")
local metricSeriesToChartPoints = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/metricSeriesToChartPoints")

local dataStatus = CreatorAnalytics.DataStatus
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore

local v5 = {
	views = "lifetime_views",
	watchTime = "lifetime_watch_time",
	watchTimeNoReplay = "lifetime_watch_time_no_replay",
	joins = "lifetime_joins"
}

local function seriesTotal(p2)
	if p2 == nil then
		return nil
	end

	local total = 0

	for k, dataPoint in p2.dataPoints do
		total += dataPoint.value
	end

	return total
end

local function combineStatus(items)
	local v6 = dataStatus.Ready

	for k, item in items do
		if item == dataStatus.Failed then
			return dataStatus.Failed
		end

		if item == dataStatus.NotReady then
			v6 = dataStatus.NotReady
		end
	end

	return v6
end

local function usePostInsightsAnalytics(p2, p3, value)
	local v6 = React.useMemo(function()
		return getPostInsightsQueryParams(p2, p3 or os.time())
	end, { p2.momentId, p2.createdAt or false, p3 or false })

	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p4)
			if v6 == nil then
				return {
					params = v6,
					viewsStatus = dataStatus.Failed,
					views = nil,
					lifetimeStatus = dataStatus.Failed,
					lifetime = {},
					lifetimeStatuses = {}
				}
			end

			local creatorAnalyticsStore = getCreatorAnalyticsStore(p4)
			local fetchResourceMetric = creatorAnalyticsStore.getAndFetchResourceMetric(v6.views)
			local v8 = {}
			local v9 = {}
			local v10 = {}

			for k, v11 in v6.lifetime do
				local fetchResourceMetric2 = creatorAnalyticsStore.getAndFetchResourceMetric(v11)
				v8[k] = fetchResourceMetric2.data(p4)
				v9[k] = fetchResourceMetric2.status(p4)
				table.insert(v10, fetchResourceMetric2.status(p4))
			end

			return {
				params = v6,
				viewsStatus = fetchResourceMetric.status(p4),
				views = fetchResourceMetric.data(p4),
				lifetimeStatus = combineStatus(v10),
				lifetime = v8,
				lifetimeStatuses = v9
			}
		end)
	end, { v6 })
	local v8 = SignalsReact.useSignalState(v7)

	local current = React.useRef({
		params = v6,
		views = nil,
		lifetimeTotals = {},
		lifetimeFailed = {}
	}).current

	if current.params ~= v6 then
		current.params = v6
		current.views = nil
		current.lifetimeTotals = {}
		current.lifetimeFailed = {}
	end

	if v8.params == v6 then
		if v8.viewsStatus == dataStatus.Ready then
			current.views = v8
		end

		for k, lifetimeStatus in v8.lifetimeStatuses do
			if lifetimeStatus == dataStatus.Ready then
				local lifetimeTotals = current.lifetimeTotals
				local v9 = v8.lifetime[k]
				local v10

				if v9 ~= nil then
					v10 = 0

					for k2, dataPoint in v9.dataPoints do
						v10 += dataPoint.value
					end
				end

				lifetimeTotals[k] = v10
			elseif lifetimeStatus == dataStatus.Failed then
				current.lifetimeFailed[k] = true
			end
		end
	end

	local v9 = if v8.viewsStatus == dataStatus.Ready or current.views == nil then v8 else current.views
	local lifetimeTotals = current.lifetimeTotals

	local function lifetimeQueryStatus(p4)
		if lifetimeTotals[p4] ~= nil then
			return dataStatus.Ready
		end

		if current.lifetimeFailed[p4] then
			return dataStatus.Failed
		end

		return v8.lifetimeStatuses[p4] or dataStatus.Failed
	end

	local v10

	if
		v6 == nil
		or lifetimeTotals.views == nil
		or lifetimeTotals.watchTime == nil
		or lifetimeTotals.watchTimeNoReplay == nil
	then
		v10 = false
	else
		v10 = lifetimeTotals.joins ~= nil
	end

	local v11 = value or 600
	React.useEffect(function()
		if v6 == nil then
			return
		end

		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v11, function()
				local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
				creatorAnalyticsStore.refetchResourceMetric(v6.views)

				for k, v12 in v6.lifetime do
					creatorAnalyticsStore.refetchResourceMetric(v12)
				end

				scheduleRefresh()
			end)
		end

		thread = task.delay(v11, function()
			local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
			creatorAnalyticsStore.refetchResourceMetric(v6.views)

			for k, v12 in v6.lifetime do
				creatorAnalyticsStore.refetchResourceMetric(v12)
			end

			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { v6, v11 })

	local v12 = React.useMemo(function()
		if v6 == nil or v9.viewsStatus ~= dataStatus.Ready then
			return nil
		end

		return metricSeriesToChartPoints(v9.views, v6.window)
	end, { v6, v9.viewsStatus, v9.views })

	local ref = React.useRef({ params = nil, queries = {}, inFlight = {} })

	React.useEffect(function()
		if v6 == nil then
			return
		end

		local current2 = ref.current

		if current2.params ~= v6 then
			current2.params = v6
			current2.queries = {}
			current2.inFlight = {}
		end

		local function reportOnce(p4, p5)
			if current2.queries[p4] then
				return
			end

			if p5 == dataStatus.NotReady then
				if current2.inFlight[p4] == nil then
					current2.inFlight[p4] = os.clock()
				end
			else
				local v13 = current2.inFlight[p4]

				if v13 == nil then
					return
				end

				local v14 = p5 == dataStatus.Ready and "success"
					or p5 == dataStatus.Failed and "failed"
					or nil

				if v14 == nil then
					return
				end

				current2.queries[p4] = true
				MomentsCommon.Analytics.reportMomentsPostInsightsRequest(p4, v14)
				local v15 = math.round((os.clock() - v13) * 1000)
				MomentsCommon.Analytics.reportMomentsPostInsightsRequestLatency(p4, v14, v15)
			end
		end
		reportOnce("views", v8.viewsStatus)

		for k, v13 in v5 do
			reportOnce(v13, v8.lifetimeStatuses[k])
		end
	end, { v6, v8 })

	local v13 = {
		viewsStatus = v9.viewsStatus,
		viewsSeries = v12,
		window = 0,
		lifetimeStatus = 0,
		lifetimeViews = 0,
		lifetimeViewsStatus = 0,
		lifetimeWatchTimeSeconds = 0,
		lifetimeWatchTimeStatus = 0,
		lifetimeWatchTimeNoReplaySeconds = 0,
		lifetimeWatchTimeNoReplayStatus = 0,
		lifetimeJoins = 0,
		lifetimeJoinsStatus = 0
	}

	local v14 = if v6 ~= nil then v6.window else nil
	v13.window = v14
	local v15 = if v10 then dataStatus.Ready else v8.lifetimeStatus
	v13.lifetimeStatus = v15
	v13.lifetimeViews = lifetimeTotals.views
	local v16

	if lifetimeTotals.views == nil then
		if current.lifetimeFailed.views then
			v16 = dataStatus.Failed
		else
			v16 = v8.lifetimeStatuses.views or dataStatus.Failed
		end
	else
		v16 = dataStatus.Ready
	end

	v13.lifetimeViewsStatus = v16
	v13.lifetimeWatchTimeSeconds = lifetimeTotals.watchTime
	local v17

	if lifetimeTotals.watchTime == nil then
		if current.lifetimeFailed.watchTime then
			v17 = dataStatus.Failed
		else
			v17 = v8.lifetimeStatuses.watchTime or dataStatus.Failed
		end
	else
		v17 = dataStatus.Ready
	end

	v13.lifetimeWatchTimeStatus = v17
	v13.lifetimeWatchTimeNoReplaySeconds = lifetimeTotals.watchTimeNoReplay
	local v18

	if lifetimeTotals.watchTimeNoReplay == nil then
		if current.lifetimeFailed.watchTimeNoReplay then
			v18 = dataStatus.Failed
		else
			v18 = v8.lifetimeStatuses.watchTimeNoReplay or dataStatus.Failed
		end
	else
		v18 = dataStatus.Ready
	end

	v13.lifetimeWatchTimeNoReplayStatus = v18
	v13.lifetimeJoins = lifetimeTotals.joins
	local v19

	if lifetimeTotals.joins == nil then
		if current.lifetimeFailed.joins then
			v19 = dataStatus.Failed
		else
			v19 = v8.lifetimeStatuses.joins or dataStatus.Failed
		end
	else
		v19 = dataStatus.Ready
	end

	v13.lifetimeJoinsStatus = v19
	return v13
end

return usePostInsightsAnalytics
