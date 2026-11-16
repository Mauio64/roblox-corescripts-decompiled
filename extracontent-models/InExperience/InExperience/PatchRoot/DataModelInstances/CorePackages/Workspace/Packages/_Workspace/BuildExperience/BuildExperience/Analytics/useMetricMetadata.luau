local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local getCreatorAnalyticsStore = CreatorAnalytics.getCreatorAnalyticsStore

local function useMetricMetadata(current, value: number?)
	local joined = table.concat(current, ",")

	local fetchMetricMetadata = getCreatorAnalyticsStore(false).getAndFetchMetricMetadata(current)
	local latestByMetric = SignalsReact.useSignalState(fetchMetricMetadata.data)
	local status = SignalsReact.useSignalState(fetchMetricMetadata.status)

	local ref = React.useRef(current)
	ref.current = current

	local v = value or 600
	React.useEffect(function()
		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v, function()
				getCreatorAnalyticsStore(false).getAndFetchMetricMetadata(ref.current)
				scheduleRefresh()
			end)
		end

		thread = task.delay(v, function()
			getCreatorAnalyticsStore(false).getAndFetchMetricMetadata(ref.current)
			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { joined, v })

	return { latestByMetric = latestByMetric, status = status }
end

return useMetricMetadata
