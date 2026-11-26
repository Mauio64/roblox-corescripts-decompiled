local module = require("@luauforge/bundled/dvt")
local module2 = require("@luauforge/bundled/dtf")
require("@luauforge/bundled/dtp")
local module3 = require("@luauforge/bundled/dtM")
local module4 = require("@luauforge/bundled/dvA")
local module5 = require("@luauforge/bundled/dtD")

local apportioningDiagnosticTelemetry = module3.ApportioningDiagnosticTelemetry
local fFlagLuaAppEnableNxMRoduxApportioning = module5.FFlagLuaAppEnableNxMRoduxApportioning
local fFlagLuaAppEnableNxMApportioningExtraLogging = module5.FFlagLuaAppEnableNxMApportioningExtraLogging

local defineFastFlag = game:DefineFastFlag("LuaAppNxMApportioningDiagnosticIncludeLatency", false)
local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = module5.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry
local oneByTwoTileTelemetry

if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	oneByTwoTileTelemetry = require("@luauforge/bundled/duy").OneByTwoTileTelemetry
else
	oneByTwoTileTelemetry = nil
end

local gameCollectionItemTypes = module4.GameCollectionItemTypes
local spanForItemType = gameCollectionItemTypes.SpanForItemType
local calculateSpanAwareGrids = module.calculateSpanAwareGrids

local module6 = require("@luauforge/bundled/dyr")

local module7 = require("@luauforge/bundled/dyo")

local v5 = {
	[gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile] = {
		colSpan = 2,
		rowSpan = 1
	}
}

local function getSpanConfig(data)
	local v6

	if data then
		if fFlagLuaAppEnableNxMRoduxApportioning then
			v6 = spanForItemType[data.componentType]
		else
			v6 = v5[data.componentType]
		end
	else
		v6 = data
	end

	if v6 then
		return {
			colSpan = v6.colSpan,
			rowSpan = not fFlagLuaAppEnableNxMRoduxApportioning and 1 or v6.rowSpan,
			minRowPadding = tonumber(data.minRowPadding) or 0,
			alignmentType = data.alignmentType
		}
	end

	return nil
end

local function countPlacedTiles(layout)
	local count = 0

	for k, item in layout do
		for k2, v6 in item do
			if v6 > 0 then
				count += 1
			end
		end
	end

	return count
end

local function recalculateFlexBounds(options, list, list2, p2, p3, p4)
	local joined = module2.Dictionary.join(options or {})

	local sortEntries = {}

	for i, item in ipairs(list) do
		table.insert(sortEntries, {
			sortKey = item.sortKey,
			maxRows = item.numberOfRows
		})
	end

	local v6 = defineFastFlag and #sortEntries or nil
	local v7 = defineFastFlag and #list2 or nil

	local lastTime = if defineFastFlag then os.clock() else nil

	local v8 = calculateSpanAwareGrids(list2, sortEntries, p2, getSpanConfig)

	if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
		local set = {}

		for i, v9 in ipairs(sortEntries) do
			local v10 = v8[v9.sortKey]
			local layout = v10 and v10.layout

			if not layout then
				continue
			end

			for k, v11 in layout do
				for k2, v12 in v11 do
					if not (v12 > 0) then
						continue
					end

					local v13 = set[v12] == true
					set[v12] = true
					local item = list2[v12]

					if v13 or not item or not item.oneByTwoTileFlowId then
						continue
					end

					oneByTwoTileTelemetry.logOneByTwoTilePlaced({
						oneByTwoTileFlowId = item.oneByTwoTileFlowId,
						recommendationsRequestId = item.recommendationsRequestId,
						topicId = p3,
						sortIndex = v9.sortKey,
						contentType = item.contentType,
						adId = item.adId,
						componentType = "OneByTwoTile",
						alignmentType = item.alignmentType,
						gridRow = k,
						gridCol = k2,
						isSdui = false
					})
				end
			end
		end

		if p4 then
			local sortKey = sortEntries[#sortEntries].sortKey

			for k, item in list2 do
				if not item or not item.oneByTwoTileFlowId or set[k] then
					continue
				end

				oneByTwoTileTelemetry.logOneByTwoTileSkipped({
					oneByTwoTileFlowId = item.oneByTwoTileFlowId,
					recommendationsRequestId = item.recommendationsRequestId,
					topicId = p3,
					sortIndex = sortKey,
					contentType = item.contentType,
					adId = item.adId,
					componentType = "OneByTwoTile",
					alignmentType = item.alignmentType,
					isSdui = false
				})
			end
		end
	end

	local v9 = if defineFastFlag then (os.clock() - lastTime) * 1000 else nil
	local v10

	if defineFastFlag then
		v10 = 0

		for k, item in list2 do
			if getSpanConfig(item) ~= nil then
				v10 += 1
			end
		end
	end

	if defineFastFlag then
		apportioningDiagnosticTelemetry.log("FeedApportioned", {
			durationMs = v9,
			sectionCount = v6,
			entriesCount = v7,
			spanTileCount = v10,
			itemsPerRow = p2,
			nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
		})
	end

	local total = 1

	for i, v11 in ipairs(sortEntries) do
		local sortKey = v11.sortKey
		local v12 = v8[sortKey]

		if not v12 then
			continue
		end

		if fFlagLuaAppEnableNxMApportioningExtraLogging then
			local v13

			if fFlagLuaAppEnableNxMRoduxApportioning then
				v13 = countPlacedTiles(v12.layout or {})
			else
				v13 = #(v12.entryIndices or {})
			end

			local v14 = fFlagLuaAppEnableNxMRoduxApportioning and #(v12.layout or {}) or 0
			apportioningDiagnosticTelemetry.log("SectionApportioned", {
				sortKey = sortKey,
				maxRows = v11.maxRows,
				itemsPerRow = p2,
				firstIndex = total,
				placedCount = v13,
				layoutRowCount = v14,
				sectionCount = if defineFastFlag then v6 else nil,
				entriesCount = if defineFastFlag then v7 else nil,
				spanTileCount = if defineFastFlag then v10 else nil,
				apportioningDurationMs = if defineFastFlag then v9 else nil,
				nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
			})
		end

		if fFlagLuaAppEnableNxMRoduxApportioning then
			local layout = v12.layout or {}
			joined[sortKey] = { firstIndex = total, layout = layout }

			total += countPlacedTiles(layout)
		else
			joined[sortKey] = { entryIndices = v12.entryIndices, firstIndex = total }

			total += #v12.entryIndices
		end
	end

	return joined
end

return function(options, data)
	local v6 = options or {}

	if data.type == module6.name then
		local v7 = v6[data.topicId] or {}

		local flexItemsInput = v7.flexItemsInput or {}
		local flag = false
		local v8 = {}

		for i, v9 in ipairs(flexItemsInput) do
			if flag then
				table.insert(v8, v9)
			elseif v9.sortKey == data.sortIndex then
				table.insert(v8, {
					sortKey = data.sortIndex,
					numberOfRows = data.numberOfRows
				})
				flag = true
			elseif v9.sortKey > data.sortIndex then
				table.insert(v8, {
					sortKey = data.sortIndex,
					numberOfRows = data.numberOfRows
				})

				table.insert(v8, v9)
				flag = true
			else
				table.insert(v8, v9)
			end
		end

		if not flag then
			table.insert(v8, {
				sortKey = data.sortIndex,
				numberOfRows = data.numberOfRows
			})
		end

		local flexItemsBounds = v7.flexItemsBounds

		local entries = data.entries
		local itemsPerRow = data.itemsPerRow
		local topicId = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then data.topicId else nil
		local v10 = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then data.isLastGameGrid == true else nil
		local v11 = recalculateFlexBounds(flexItemsBounds, v8, entries, itemsPerRow, topicId, v10)

		return (module2.Dictionary.join(v6, {
			[data.topicId] = { flexItemsInput = v8, flexItemsBounds = v11 }
		}))
	else
		if data.type ~= module7.name then
			return v6
		end

		local v7 = v6[data.topicId] or {}
		local flexItemsInput = v7.flexItemsInput or {}

		local v8 = {}

		for i, v9 in ipairs(flexItemsInput) do
			if v9.sortKey ~= data.sortIndex then
				table.insert(v8, v9)
			end
		end

		local flexItemsBounds = v7.flexItemsBounds

		local entries = data.entries
		local itemsPerRow = data.itemsPerRow
		local topicId = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then data.topicId else nil
		local v10 = if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then false else nil
		local v11 = recalculateFlexBounds(flexItemsBounds, v8, entries, itemsPerRow, topicId, v10)

		v6 = module2.Dictionary.join(v6, {
			[data.topicId] = { flexItemsInput = v8, flexItemsBounds = v11 }
		})

		return v6
	end
end
