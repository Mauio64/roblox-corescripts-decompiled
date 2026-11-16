local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local getPostInsightsQueryParams = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/getPostInsightsQueryParams")
local metricSeriesToChartPoints = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/metricSeriesToChartPoints")

local dataStatus = CreatorAnalytics.DataStatus
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore

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
	local v5 = dataStatus.Ready

	for k, item in items do
		if item == dataStatus.Failed then
			return dataStatus.Failed
		end

		if item == dataStatus.NotReady then
			v5 = dataStatus.NotReady
		end
	end

	return v5
end

local function usePostInsightsAnalytics(p2, p3, value)
	local v5 = React.useMemo(function()
		return getPostInsightsQueryParams(p2, p3 or os.time())
	end, { p2.momentId, p2.createdAt or false, p3 or false })

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p4)
			if v5 == nil then
				return {
					viewsStatus = dataStatus.Failed,
					views = nil,
					lifetimeStatus = dataStatus.Failed,
					lifetime = {},
					lifetimeStatuses = {}
				}
			end

			local creatorAnalyticsStore = getCreatorAnalyticsStore(p4)
			local fetchResourceMetric = creatorAnalyticsStore.getAndFetchResourceMetric(v5.views)
			local v7 = {}
			local v8 = {}
			local v9 = {}

			for k, v10 in v5.lifetime do
				local fetchResourceMetric2 = creatorAnalyticsStore.getAndFetchResourceMetric(v10)
				v7[k] = fetchResourceMetric2.data(p4)
				v8[k] = fetchResourceMetric2.status(p4)
				table.insert(v9, fetchResourceMetric2.status(p4))
			end

			return {
				viewsStatus = fetchResourceMetric.status(p4),
				views = fetchResourceMetric.data(p4),
				lifetimeStatus = combineStatus(v9),
				lifetime = v7,
				lifetimeStatuses = v8
			}
		end)
	end, { v5 })
	local v7 = SignalsReact.useSignalState(v6)

	local current = React.useRef({ params = v5, views = nil, lifetimeTotals = {} }).current

	if current.params ~= v5 then
		current.params = v5
		current.views = nil
		current.lifetimeTotals = {}
	end

	if v7.viewsStatus == dataStatus.Ready then
		current.views = v7
	end

	for k, lifetimeStatus in v7.lifetimeStatuses do
		if lifetimeStatus ~= dataStatus.Ready then
			continue
		end

		local lifetimeTotals = current.lifetimeTotals
		local v8 = v7.lifetime[k]
		local v9

		if v8 ~= nil then
			v9 = 0

			for k2, dataPoint in v8.dataPoints do
				v9 += dataPoint.value
			end
		end

		lifetimeTotals[k] = v9
	end

	local v8 = if v7.viewsStatus == dataStatus.Ready or current.views == nil then v7 else current.views
	local lifetimeTotals = current.lifetimeTotals
	local v9

	if v5 == nil or lifetimeTotals.views == nil or lifetimeTotals.watchTime == nil then
		v9 = false
	else
		v9 = lifetimeTotals.joins ~= nil
	end

	local v10 = value or 600
	React.useEffect(function()
		if v5 == nil then
			return
		end

		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v10, function()
				local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
				creatorAnalyticsStore.refetchResourceMetric(v5.views)

				for k, v11 in v5.lifetime do
					creatorAnalyticsStore.refetchResourceMetric(v11)
				end

				scheduleRefresh()
			end)
		end

		thread = task.delay(v10, function()
			local creatorAnalyticsStore = getCreatorAnalyticsStore(false)
			creatorAnalyticsStore.refetchResourceMetric(v5.views)

			for k, v11 in v5.lifetime do
				creatorAnalyticsStore.refetchResourceMetric(v11)
			end

			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { v5, v10 })

	local v11 = React.useMemo(function()
		if v5 == nil or v8.viewsStatus ~= dataStatus.Ready then
			return nil
		end

		return metricSeriesToChartPoints(v8.views, v5.window)
	end, { v5, v8.viewsStatus, v8.views })

	local v12 = {
		viewsStatus = v8.viewsStatus,
		viewsSeries = v11,
		window = 0,
		lifetimeStatus = 0,
		lifetimeViews = 0,
		lifetimeWatchTimeSeconds = 0,
		lifetimeJoins = 0
	}

	local v13 = if v5 ~= nil then v5.window else nil
	v12.window = v13
	local v14 = if v9 then dataStatus.Ready else v7.lifetimeStatus
	v12.lifetimeStatus = v14
	v12.lifetimeViews = lifetimeTotals.views
	v12.lifetimeWatchTimeSeconds = lifetimeTotals.watchTime
	v12.lifetimeJoins = lifetimeTotals.joins
	return v12
end

return usePostInsightsAnalytics
