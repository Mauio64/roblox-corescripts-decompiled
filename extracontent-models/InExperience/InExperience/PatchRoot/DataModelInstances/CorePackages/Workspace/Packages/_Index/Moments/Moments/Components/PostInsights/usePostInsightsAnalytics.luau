local parent = script:FindFirstAncestor("Moments").Parent

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
require(parent.MomentsTypes)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local getPostInsightsQueryParams = require(script.Parent.getPostInsightsQueryParams)
local metricSeriesToChartPoints = require(script.Parent.metricSeriesToChartPoints)

local DataStatus = CreatorAnalytics.DataStatus
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore

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
	local v = DataStatus.Ready

	for _, item in items do
		if item == DataStatus.Failed then
			return DataStatus.Failed
		end

		if item == DataStatus.NotReady then
			v = DataStatus.NotReady
		end
	end

	return v
end

local function usePostInsightsAnalytics(p, p2: number?, value: number?)
	local params = React.useMemo(function()
		return getPostInsightsQueryParams(p, p2 or os.time())
	end, { p.momentId, p.createdAt or false, p2 or false })

	local v = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if params == nil then
				return {
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
			local v = {}

			for k, v2 in params.lifetime do
				local fetchResourceMetric2 = creatorAnalyticsStore.getAndFetchResourceMetric(v2)
				lifetime[k] = fetchResourceMetric2.data(p3)
				lifetimeStatuses[k] = fetchResourceMetric2.status(p3)
				table.insert(v, fetchResourceMetric2.status(p3))
			end

			return {
				viewsStatus = fetchResourceMetric.status(p3),
				views = fetchResourceMetric.data(p3),
				lifetimeStatus = combineStatus(v),
				lifetime = lifetime,
				lifetimeStatuses = lifetimeStatuses
			}
		end)
	end, { params })
	local views = SignalsReact.useSignalState(v)

	local current = React.useRef({ params = params, views = nil, lifetimeTotals = {} }).current

	if current.params ~= params then
		current.params = params
		current.views = nil
		current.lifetimeTotals = {}
	end

	if views.viewsStatus == DataStatus.Ready then
		current.views = views
	end

	for k, lifetimeStatus in views.lifetimeStatuses do
		if lifetimeStatus ~= DataStatus.Ready then
			continue
		end

		local lifetimeTotals = current.lifetimeTotals
		local v2 = views.lifetime[k]
		local v3

		if v2 ~= nil then
			v3 = 0

			for _, dataPoint in v2.dataPoints do
				v3 += dataPoint.value
			end
		end

		lifetimeTotals[k] = v3
	end

	local v2

	if views.viewsStatus == DataStatus.Ready or current.views == nil then
		v2 = views
	else
		v2 = current.views
	end

	local lifetimeTotals = current.lifetimeTotals
	local v3

	if params == nil or lifetimeTotals.views == nil or lifetimeTotals.watchTime == nil then
		v3 = false
	else
		v3 = lifetimeTotals.joins ~= nil
	end

	local v4 = value or 600
	React.useEffect(function()
		if params == nil then
			return
		end

		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v4, function()
				local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
				creatorAnalyticsStore.refetchResourceMetric(params.views)

				for _, v5 in params.lifetime do
					creatorAnalyticsStore.refetchResourceMetric(v5)
				end

				scheduleRefresh()
			end)
		end

		thread = task.delay(v4, function()
			local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
			creatorAnalyticsStore.refetchResourceMetric(params.views)

			for _, v5 in params.lifetime do
				creatorAnalyticsStore.refetchResourceMetric(v5)
			end

			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { params, v4 })

	local viewsSeries = React.useMemo(function()
		if params == nil or v2.viewsStatus ~= DataStatus.Ready then
			return nil
		end

		return metricSeriesToChartPoints(v2.views, params.window)
	end, { params, v2.viewsStatus, v2.views })

	local v5 = {
		viewsStatus = v2.viewsStatus,
		viewsSeries = viewsSeries,
		window = 0,
		lifetimeStatus = 0,
		lifetimeViews = 0,
		lifetimeWatchTimeSeconds = 0,
		lifetimeJoins = 0
	}
	local window

	if params ~= nil then
		window = params.window
	end

	v5.window = window
	local lifetimeStatus

	if v3 then
		lifetimeStatus = DataStatus.Ready
	else
		lifetimeStatus = views.lifetimeStatus
	end

	v5.lifetimeStatus = lifetimeStatus
	v5.lifetimeViews = lifetimeTotals.views
	v5.lifetimeWatchTimeSeconds = lifetimeTotals.watchTime
	v5.lifetimeJoins = lifetimeTotals.joins
	return v5
end

return usePostInsightsAnalytics
