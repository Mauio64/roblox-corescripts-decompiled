local parent = script:FindFirstAncestor("Moments").Parent

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local getPostInsightsQueryParams = require(script.Parent.getPostInsightsQueryParams)
local metricSeriesToChartPoints = require(script.Parent.metricSeriesToChartPoints)

local DataStatus = CreatorAnalytics.DataStatus
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore

local v = {
	views = "lifetime_views",
	watchTime = "lifetime_watch_time",
	watchTimeNoReplay = "lifetime_watch_time_no_replay",
	joins = "lifetime_joins"
}

local function seriesTotal(p)
	if p == nil then
		return nil
	end

	local total = 0

	for _, dataPoint in p.dataPoints do
		total += dataPoint.value
	end

	return total
end

local function combineStatus(items)
	local v2 = DataStatus.Ready

	for _, item in items do
		if item == DataStatus.Failed then
			return DataStatus.Failed
		end

		if item == DataStatus.NotReady then
			v2 = DataStatus.NotReady
		end
	end

	return v2
end

local function usePostInsightsAnalytics(p, p2: number?, value: number?)
	local params = React.useMemo(function()
		return getPostInsightsQueryParams(p, p2 or os.time())
	end, { p.momentId, p.createdAt or false, p2 or false })

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if params == nil then
				return {
					params = params,
					viewsStatus = DataStatus.Failed,
					views = nil,
					lifetimeStatus = DataStatus.Failed,
					lifetime = {},
					lifetimeStatuses = {}
				}
			end

			local creatorAnalyticsStore = getCreatorAnalyticsStore(p3)
			local fetchResourceMetric = creatorAnalyticsStore.getAndFetchResourceMetric(params.views)
			local lifetime = {}
			local lifetimeStatuses = {}
			local v2 = {}

			for k, v3 in params.lifetime do
				local fetchResourceMetric2 = creatorAnalyticsStore.getAndFetchResourceMetric(v3)
				lifetime[k] = fetchResourceMetric2.data(p3)
				lifetimeStatuses[k] = fetchResourceMetric2.status(p3)
				table.insert(v2, fetchResourceMetric2.status(p3))
			end

			return {
				params = params,
				viewsStatus = fetchResourceMetric.status(p3),
				views = fetchResourceMetric.data(p3),
				lifetimeStatus = combineStatus(v2),
				lifetime = lifetime,
				lifetimeStatuses = lifetimeStatuses
			}
		end)
	end, { params })
	local views = SignalsReact.useSignalState(v2)

	local current = React.useRef({
		params = params,
		views = nil,
		lifetimeTotals = {},
		lifetimeFailed = {}
	}).current

	if current.params ~= params then
		current.params = params
		current.views = nil
		current.lifetimeTotals = {}
		current.lifetimeFailed = {}
	end

	if views.params == params then
		if views.viewsStatus == DataStatus.Ready then
			current.views = views
		end

		for k, lifetimeStatus in views.lifetimeStatuses do
			if lifetimeStatus == DataStatus.Ready then
				local lifetimeTotals = current.lifetimeTotals
				local v3 = views.lifetime[k]
				local v4

				if v3 ~= nil then
					v4 = 0

					for _, dataPoint in v3.dataPoints do
						v4 += dataPoint.value
					end
				end

				lifetimeTotals[k] = v4
			elseif lifetimeStatus == DataStatus.Failed then
				current.lifetimeFailed[k] = true
			end
		end
	end

	local v3

	if views.viewsStatus == DataStatus.Ready or current.views == nil then
		v3 = views
	else
		v3 = current.views
	end

	local lifetimeTotals = current.lifetimeTotals

	local function lifetimeQueryStatus(p3: string) -- 4 equivalent calls inferred from this helper
		if lifetimeTotals[p3] ~= nil then
			return DataStatus.Ready
		end

		if current.lifetimeFailed[p3] then
			return DataStatus.Failed
		end

		return views.lifetimeStatuses[p3] or DataStatus.Failed
	end

	local v4

	if
		params == nil
		or lifetimeTotals.views == nil
		or lifetimeTotals.watchTime == nil
		or lifetimeTotals.watchTimeNoReplay == nil
	then
		v4 = false
	else
		v4 = lifetimeTotals.joins ~= nil
	end

	local v5 = value or 600
	React.useEffect(function()
		if params == nil then
			return
		end

		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v5, function()
				local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
				creatorAnalyticsStore.refetchResourceMetric(params.views)

				for _, v6 in params.lifetime do
					creatorAnalyticsStore.refetchResourceMetric(v6)
				end

				scheduleRefresh()
			end)
		end

		thread = task.delay(v5, function()
			local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
			creatorAnalyticsStore.refetchResourceMetric(params.views)

			for _, v6 in params.lifetime do
				creatorAnalyticsStore.refetchResourceMetric(v6)
			end

			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { params, v5 })

	local viewsSeries = React.useMemo(function()
		if params == nil or v3.viewsStatus ~= DataStatus.Ready then
			return nil
		end

		return metricSeriesToChartPoints(v3.views, params.window)
	end, { params, v3.viewsStatus, v3.views })

	local ref = React.useRef({ params = nil, queries = {}, inFlight = {} })

	React.useEffect(function()
		if params == nil then
			return
		end

		local current2 = ref.current

		if current2.params ~= params then
			current2.params = params
			current2.queries = {}
			current2.inFlight = {}
		end

		local function reportOnce(p3: string, p4)
			if current2.queries[p3] then
				return
			end

			if p4 == DataStatus.NotReady then
				if current2.inFlight[p3] == nil then
					current2.inFlight[p3] = os.clock()
				end
			else
				local v6 = current2.inFlight[p3]

				if v6 == nil then
					return
				end

				local v7 = p4 == DataStatus.Ready and "success" or p4 == DataStatus.Failed and "failed" or nil

				if v7 == nil then
					return
				end

				current2.queries[p3] = true
				MomentsCommon.Analytics.reportMomentsPostInsightsRequest(p3, v7)
				local v8 = math.round((os.clock() - v6) * 1000)
				MomentsCommon.Analytics.reportMomentsPostInsightsRequestLatency(p3, v7, v8)
			end
		end
		reportOnce("views", views.viewsStatus)

		for k, v6 in v do
			reportOnce(v6, views.lifetimeStatuses[k])
		end
	end, { params, views })

	local v6 = {
		viewsStatus = v3.viewsStatus,
		viewsSeries = viewsSeries,
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
	local window

	if params ~= nil then
		window = params.window
	end

	v6.window = window
	local lifetimeStatus

	if v4 then
		lifetimeStatus = DataStatus.Ready
	else
		lifetimeStatus = views.lifetimeStatus
	end

	v6.lifetimeStatus = lifetimeStatus
	v6.lifetimeViews = lifetimeTotals.views
	v6.lifetimeViewsStatus = lifetimeQueryStatus("views") -- inferred equivalent call
	v6.lifetimeWatchTimeSeconds = lifetimeTotals.watchTime
	v6.lifetimeWatchTimeStatus = lifetimeQueryStatus("watchTime") -- inferred equivalent call
	v6.lifetimeWatchTimeNoReplaySeconds = lifetimeTotals.watchTimeNoReplay
	v6.lifetimeWatchTimeNoReplayStatus = lifetimeQueryStatus("watchTimeNoReplay") -- inferred equivalent call
	v6.lifetimeJoins = lifetimeTotals.joins
	v6.lifetimeJoinsStatus = lifetimeQueryStatus("joins") -- inferred equivalent call
	return v6
end

return usePostInsightsAnalytics
