require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Dwell/DwellTracker")
require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Dwell/GameDwellItem")

local function viewArrays()
	return {
		universeIds = {},
		viewUuids = {},
		absPositions = {},
		topicDataPositions = {},
		rowsOnPage = {},
		itemComponentTypes = {},
		adFlags = {},
		sampledStartTimestampsMs = {},
		precedingScanGapsMs = {},
		positionsInRows = {},
		rows = {}
	}
end

local function appendView(data, data2)
	local item = data2.item
	table.insert(data.universeIds, (tostring(item.universeId)))
	table.insert(data.viewUuids, data2.uuid)
	table.insert(data.absPositions, (tostring(item.cell)))
	table.insert(data.topicDataPositions, (tostring(item.rank)))
	table.insert(data.rowsOnPage, (tostring(item.rowOnPage)))
	table.insert(data.itemComponentTypes, item.componentType)
	table.insert(data.adFlags, (tostring(item.adFlag)))
	table.insert(data.sampledStartTimestampsMs, (tostring(data2.startTimestamp)))
	table.insert(data.precedingScanGapsMs, (tostring(data2.precedingGap)))
	table.insert(data.positionsInRows, (tostring(item.positionInRow)))
	table.insert(data.rows, (tostring(item.row)))
end

local function join(p2, items)
	local clone = table.clone(p2)

	for k, list in items do
		clone[k] = table.concat(list, ",")
	end

	return clone
end

return {
	starts = function(p2, items)
		local v5 = viewArrays()

		for k, item in items do
			appendView(v5, item)
		end

		return join(p2, v5)
	end,
	ends = function(p2, items)
		local v5 = viewArrays()
		v5.sampledEndTimestampsMs = {}
		v5.dwellTimesMs = {}
		v5.lastPresentOffsetsMs = {}
		v5.visibleSampleCounts = {}
		v5.maxObservationGapsMs = {}
		v5.endReasons = {}

		for k, item in items do
			local view = item.view
			appendView(v5, view)
			table.insert(v5.sampledEndTimestampsMs, (tostring(item.timestamp)))
			table.insert(v5.dwellTimesMs, (tostring(item.duration)))
			table.insert(v5.lastPresentOffsetsMs, (tostring(view.lastPresent - view.start)))
			table.insert(v5.visibleSampleCounts, (tostring(view.count)))
			table.insert(v5.maxObservationGapsMs, (tostring(view.maxGap)))
			table.insert(v5.endReasons, item.reason)
		end

		return join(p2, v5)
	end
}
