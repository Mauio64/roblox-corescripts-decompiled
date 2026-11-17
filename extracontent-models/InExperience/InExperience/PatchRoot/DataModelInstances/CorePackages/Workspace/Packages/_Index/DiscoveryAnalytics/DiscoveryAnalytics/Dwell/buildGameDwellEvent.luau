require(script.Parent.DwellTracker)
require(script.Parent.GameDwellItem)

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

local function join(p, items)
	local clone = table.clone(p)

	for k, list in items do
		clone[k] = table.concat(list, ",")
	end

	return clone
end

local BuildGameDwellEvent = {}

function BuildGameDwellEvent.starts(p, items)
	local v = viewArrays()

	for _, item in items do
		appendView(v, item)
	end

	return join(p, v)
end

function BuildGameDwellEvent.ends(p, items)
	local v = viewArrays()
	v.sampledEndTimestampsMs = {}
	v.dwellTimesMs = {}
	v.lastPresentOffsetsMs = {}
	v.visibleSampleCounts = {}
	v.maxObservationGapsMs = {}
	v.endReasons = {}

	for _, item in items do
		local view = item.view
		appendView(v, view)
		table.insert(v.sampledEndTimestampsMs, (tostring(item.timestamp)))
		table.insert(v.dwellTimesMs, (tostring(item.duration)))
		table.insert(v.lastPresentOffsetsMs, (tostring(view.lastPresent - view.start)))
		table.insert(v.visibleSampleCounts, (tostring(view.count)))
		table.insert(v.maxObservationGapsMs, (tostring(view.maxGap)))
		table.insert(v.endReasons, item.reason)
	end

	return join(p, v)
end

return BuildGameDwellEvent
