local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local getCreatorAnalyticsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").getCreatorAnalyticsStore

local function useMetricMetadata(current, value)
	local joined = table.concat(current, ",")

	local fetchMetricMetadata = getCreatorAnalyticsStore(false).getAndFetchMetricMetadata(current)
	local v5 = SignalsReact.useSignalState(fetchMetricMetadata.data)
	local v6 = SignalsReact.useSignalState(fetchMetricMetadata.status)

	local ref = React.useRef(current)
	ref.current = current

	local v7 = value or 600
	React.useEffect(function()
		local thread = nil
		local function scheduleRefresh()
			thread = task.delay(v7, function()
				getCreatorAnalyticsStore(false).getAndFetchMetricMetadata(ref.current)
				scheduleRefresh()
			end)
		end

		thread = task.delay(v7, function()
			getCreatorAnalyticsStore(false).getAndFetchMetricMetadata(ref.current)
			scheduleRefresh()
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { joined, v7 })

	return { latestByMetric = v5, status = v6 }
end

return useMetricMetadata
