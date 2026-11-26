local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/DiscoveryTypes")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/DiscoveryUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags")

local apportioningDiagnosticTelemetry = DiscoveryUtils.ApportioningDiagnosticTelemetry
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local gameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local gameCollectionItemType = gameCollectionItemTypes.GameCollectionItemType
local spanForItemType = gameCollectionItemTypes.SpanForItemType

local fFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local fFlagLuaAppEnableNxMApportioningExtraLogging = SharedFlags.FFlagLuaAppEnableNxMApportioningExtraLogging

local v5 = {
	[gameCollectionItemType.TwoByOneTile] = { colSpan = 2, rowSpan = 1 }
}

local function defaultGetSpanConfig(data)
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

local function processOneGrid(list, p2, items, p3, p4, callback, p5)
	local v6 = p4 * p3
	local v7 = {}
	local v8 = {}

	local v9 = 0
	local v10 = 1

	local v11 = {}

	local function nextFreePosition(count)
		repeat
			local v12 = math.floor(count / p3) + 1
			local v13 = count % p3 + 1
			local v14 = not v11[v12] or v11[v12][v13] ~= -1

			if not v14 then
				count += 1
			end
		until v14

		return count
	end

	local function writeLayoutCell(p6, p7, p8)
		if p4 < p6 then
			discoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_LayoutWritePastMaxRows",
				"writeLayoutCell attempted to write past maxRows",
				{ row = p6, col = p7, maxRows = p4, itemsPerRow = p3 }
			)

			return
		end

		if not v11[p6] then
			v11[p6] = {}
		end

		v11[p6][p7] = p8
	end

	local function tryPlaceSpanTile(p6, data): boolean
		local colSpan = data.colSpan
		local rowSpan = if fFlagLuaAppEnableNxMRoduxApportioning or p5 then data.rowSpan else nil
		local minRowPadding = data.minRowPadding
		local alignmentType = data.alignmentType

		local v12 = if fFlagLuaAppEnableNxMRoduxApportioning or p5 then nextFreePosition(v9) else v9
		local v13

		if fFlagLuaAppEnableNxMRoduxApportioning or p5 then
			v13 = math.floor(v12 / p3) + 1
		else
			v13 = math.ceil((v9 + 1) / p3)
		end

		local v14 = v12 % p3 + 1

		if v13 < v10 then
			if fFlagLuaAppEnableNxMApportioningExtraLogging then
				apportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "padding_constraint",
					originalIndex = p6,
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					currentRow = v13,
					currentColumn = v14,
					nextAllowedRow = v10,
					nextScanPosition = v9,
					itemsPerRow = p3,
					maxRows = p4,
					nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if not (fFlagLuaAppEnableNxMRoduxApportioning or p5) and v6 < v9 + colSpan then
			if fFlagLuaAppEnableNxMApportioningExtraLogging then
				apportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "totalcells_exceeded_legacy",
					originalIndex = p6,
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					nextScanPosition = v9,
					totalCells = v6,
					itemsPerRow = p3,
					maxRows = p4,
					nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if alignmentType == "LeftPin" and v14 ~= 1 then
			if fFlagLuaAppEnableNxMApportioningExtraLogging then
				apportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "left_pin_misaligned",
					originalIndex = p6,
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = "LeftPin",
					currentRow = v13,
					currentColumn = v14,
					nextScanPosition = v9,
					itemsPerRow = p3,
					maxRows = p4,
					nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		elseif alignmentType == "RightPin" and v14 + colSpan - 1 ~= p3 then
			if fFlagLuaAppEnableNxMApportioningExtraLogging then
				apportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "right_pin_misaligned",
					originalIndex = p6,
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = "RightPin",
					currentRow = v13,
					currentColumn = v14,
					nextScanPosition = v9,
					itemsPerRow = p3,
					maxRows = p4,
					nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		elseif p3 < v14 + colSpan - 1 then
			if fFlagLuaAppEnableNxMApportioningExtraLogging then
				apportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "horizontal_wrap",
					originalIndex = p6,
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = alignmentType,
					currentRow = v13,
					currentColumn = v14,
					nextScanPosition = v9,
					itemsPerRow = p3,
					maxRows = p4,
					nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		else
			if (fFlagLuaAppEnableNxMRoduxApportioning or p5) and p4 < v13 + rowSpan - 1 then
				if fFlagLuaAppEnableNxMApportioningExtraLogging then
					apportioningDiagnosticTelemetry.log("SpanDeferred", {
						reason = "vertical_overflow",
						originalIndex = p6,
						colSpan = colSpan,
						rowSpan = rowSpan,
						alignmentType = alignmentType,
						currentRow = v13,
						currentColumn = v14,
						nextScanPosition = v9,
						itemsPerRow = p3,
						maxRows = p4,
						nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
					})
				end

				return false
			end

			if (fFlagLuaAppEnableNxMRoduxApportioning or p5) and rowSpan > 1 and #list - p6 < v14 - 1 then
				if fFlagLuaAppEnableNxMApportioningExtraLogging then
					apportioningDiagnosticTelemetry.log("SpanDeferred", {
						reason = "insufficient_trailing_entries",
						originalIndex = p6,
						colSpan = colSpan,
						rowSpan = rowSpan,
						alignmentType = alignmentType,
						currentRow = v13,
						currentColumn = v14,
						allEntriesCount = #list,
						nextScanPosition = v9,
						itemsPerRow = p3,
						maxRows = p4,
						nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
					})
				end

				return false
			end

			if fFlagLuaAppEnableNxMRoduxApportioning or p5 then
				for i = 0, rowSpan - 1 do
					for j = 0, colSpan - 1 do
						local v16 = v13 + i
						local v17 = v14 + j

						if v11[v16] and v11[v16][v17] ~= nil then
							if fFlagLuaAppEnableNxMApportioningExtraLogging then
								apportioningDiagnosticTelemetry.log("SpanDeferred", {
									reason = "span_cell_collision",
									originalIndex = p6,
									colSpan = colSpan,
									rowSpan = rowSpan,
									alignmentType = alignmentType,
									currentRow = v13,
									currentColumn = v14,
									collidingRow = v16,
									collidingCol = v17,
									collidingValue = v11[v16][v17],
									itemsPerRow = p3,
									maxRows = p4,
									nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
								})
							end

							return false
						end
					end
				end
			end

			if fFlagLuaAppEnableNxMRoduxApportioning or p5 then
				for i = 0, rowSpan - 1 do
					for j = 0, colSpan - 1 do
						writeLayoutCell(v13 + i, v14 + j, -1)
					end
				end

				writeLayoutCell(v13, v14, p6)
				v9 = v12 + colSpan
				v10 = v13 + rowSpan - 1 + minRowPadding
			else
				table.insert(v7, p6)
				v9 += colSpan
				v10 = v13 + minRowPadding
			end

			return true
		end
	end

	local function tryPlaceDeferredSpanTiles()
		while #v8 > 0 do
			local v12 = v8[1]

			if not tryPlaceSpanTile(v12.index, v12.spanConfig) then
				break
			end

			table.remove(v8, 1)
		end
	end

	for k, item in items do
		if #v8 > 0 then
			table.insert(v8, item)
		elseif not tryPlaceSpanTile(item.index, item.spanConfig) then
			table.insert(v8, item)
		end
	end

	for i = p2, #list do
		local item = list[i]

		if item then
			if v6 <= v9 then
				if not fFlagLuaAppEnableNxMApportioningExtraLogging then
					break
				end

				apportioningDiagnosticTelemetry.log("GridFull", {
					nextScanPosition = v9,
					totalCells = v6,
					itemsPerRow = p3,
					maxRows = p4,
					remainingEntries = #list - i + 1,
					deferredCount = #v8,
					stoppedAtIndex = i,
					allEntriesCount = #list,
					nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
				})
				break
			else
				local v12 = if callback == nil then defaultGetSpanConfig(item) else callback(item, i)

				if v12 then
					if #v8 > 0 then
						table.insert(v8, { index = i, spanConfig = v12 })
					elseif not tryPlaceSpanTile(i, v12) then
						table.insert(v8, { index = i, spanConfig = v12 })
					end
				else
					if fFlagLuaAppEnableNxMRoduxApportioning or p5 then
						local v13 = nextFreePosition(v9)

						if v6 <= v13 then
							break
						end

						writeLayoutCell(math.floor(v13 / p3) + 1, v13 % p3 + 1, i)
						v9 = v13 + 1
					else
						table.insert(v7, i)
						v9 += 1
					end

					tryPlaceDeferredSpanTiles()
				end

				p2 = i + 1
			end
		else
			discoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_InvalidEntry",
				"calculateSpanAwareGrids called with an invalid entry",
				{
					allEntriesCount = #list,
					indexInAllEntries = i,
					itemsPerRow = p3
				}
			)

			p2 = i + 1
		end
	end

	local v12 = {
		placedIndices = v7,
		pendingSpanTiles = v8,
		nextStartIndex = p2,
		layout = nil
	}
	local v13 = if fFlagLuaAppEnableNxMRoduxApportioning or p5 then v11 else nil
	v12.layout = v13
	return v12
end

return {
	calculateSpanAwareGrids = function(list, list2, p2, p3, p4)
		if not list then
			discoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_MissingEntries",
				"calculateSpanAwareGrids called without entries",
				{
					gridConfigsCount = #list2,
					itemsPerRow = p2
				}
			)

			return {}
		end

		if #list == 0 then
			discoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_EmptyEntries",
				"calculateSpanAwareGrids called with empty entries",
				{
					allEntriesCount = #list,
					gridConfigsCount = #list2,
					itemsPerRow = p2
				}
			)

			return {}
		end

		if #list2 == 0 then
			return {}
		end

		if not p2 then
			discoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_MissingItemsPerRow",
				"calculateSpanAwareGrids called without itemsPerRow",
				{
					allEntriesCount = #list,
					gridConfigsCount = #list2
				}
			)

			return {}
		end

		if p2 <= 0 then
			discoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_InvalidItemsPerRow",
				"calculateSpanAwareGrids called with invalid itemsPerRow",
				{
					allEntriesCount = #list,
					gridConfigsCount = #list2,
					itemsPerRow = p2
				}
			)

			return {}
		end

		local v6 = 1
		local v7 = {}
		local result = {}

		for k, item in list2 do
			local maxRows = item.maxRows
			local v9 = processOneGrid(
				list,
				v6,
				v7,
				p2,
				(not maxRows or maxRows <= 0) and 1e999 or maxRows,
				p3,
				p4
			)

			local sortKey = item.sortKey
			local v11 = if not (fFlagLuaAppEnableNxMRoduxApportioning or p4) then v9.placedIndices else nil
			local v12 = if fFlagLuaAppEnableNxMRoduxApportioning or p4 then v9.layout else nil
			result[sortKey] = { entryIndices = v11, layout = v12 }

			v6 = v9.nextStartIndex
			v7 = v9.pendingSpanTiles
		end

		return result
	end,
	processOneGrid = processOneGrid
}
