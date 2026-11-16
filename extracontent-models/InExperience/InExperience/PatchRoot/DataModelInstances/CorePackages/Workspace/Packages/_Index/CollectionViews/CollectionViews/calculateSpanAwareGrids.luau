local parent = script:FindFirstAncestor("CollectionViews").Parent
local DiscoveryTypes = require(parent.DiscoveryTypes)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local SharedFlags = require(parent.SharedFlags)

local ApportioningDiagnosticTelemetry = DiscoveryUtils.ApportioningDiagnosticTelemetry
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local GameCollectionItemType = GameCollectionItemTypes.GameCollectionItemType
local SpanForItemType = GameCollectionItemTypes.SpanForItemType

local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppEnableNxMApportioningExtraLogging = SharedFlags.FFlagLuaAppEnableNxMApportioningExtraLogging
local defineFastFlag = game:DefineFastFlag("LuaAppFixApportioningTileTailConflict", false)

local v = {
	[GameCollectionItemType.TwoByOneTile] = { colSpan = 2, rowSpan = 1 }
}

local function defaultGetSpanConfig(data)
	local v2

	if data then
		if FFlagLuaAppEnableNxMRoduxApportioning then
			v2 = SpanForItemType[data.componentType]
		else
			v2 = v[data.componentType]
		end
	else
		v2 = data
	end

	if v2 then
		return {
			colSpan = v2.colSpan,
			rowSpan = not FFlagLuaAppEnableNxMRoduxApportioning and 1 or v2.rowSpan,
			minRowPadding = tonumber(data.minRowPadding) or 0,
			alignmentType = data.alignmentType
		}
	end

	return nil
end

local function processOneGrid(list, nextStartIndex: number, items, itemsPerRow: number, maxRows: number, callback, flag: boolean?)
	local totalCells = maxRows * itemsPerRow
	local placedIndices = {}
	local pendingSpanTiles = {}

	local nextScanPosition = 0
	local nextAllowedRow = 1

	local v2 = {}

	local function nextFreePosition(count: number)
		repeat
			local v3 = math.floor(count / itemsPerRow) + 1
			local v4 = count % itemsPerRow + 1
			local v5 = not v2[v3] or v2[v3][v4] ~= -1

			if not v5 then
				count += 1
			end
		until v5

		return count
	end

	local function writeLayoutCell(row: number, col: number, p: number)
		if maxRows < row then
			DiscoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_LayoutWritePastMaxRows",
				"writeLayoutCell attempted to write past maxRows",
				{ row = row, col = col, maxRows = maxRows, itemsPerRow = itemsPerRow }
			)

			return
		end

		if not v2[row] then
			v2[row] = {}
		end

		v2[row][col] = p
	end

	local function tryPlaceSpanTile(originalIndex: number, data): boolean
		local colSpan = data.colSpan
		local rowSpan

		if FFlagLuaAppEnableNxMRoduxApportioning or flag then
			rowSpan = data.rowSpan
		end

		local minRowPadding = data.minRowPadding
		local alignmentType = data.alignmentType
		local v3

		if FFlagLuaAppEnableNxMRoduxApportioning or flag then
			v3 = nextFreePosition(nextScanPosition)
		else
			v3 = nextScanPosition
		end

		local currentRow

		if FFlagLuaAppEnableNxMRoduxApportioning or flag then
			currentRow = math.floor(v3 / itemsPerRow) + 1
		else
			currentRow = math.ceil((nextScanPosition + 1) / itemsPerRow)
		end

		local currentColumn = v3 % itemsPerRow + 1

		if currentRow < nextAllowedRow then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "padding_constraint",
					originalIndex = originalIndex,
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					currentRow = currentRow,
					currentColumn = currentColumn,
					nextAllowedRow = nextAllowedRow,
					nextScanPosition = nextScanPosition,
					itemsPerRow = itemsPerRow,
					maxRows = maxRows,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		elseif FFlagLuaAppEnableNxMRoduxApportioning or flag or not (totalCells < nextScanPosition + colSpan) then
			if alignmentType == "LeftPin" and currentColumn ~= 1 then
				if FFlagLuaAppEnableNxMApportioningExtraLogging then
					ApportioningDiagnosticTelemetry.log("SpanDeferred", {
						reason = "left_pin_misaligned",
						originalIndex = originalIndex,
						colSpan = colSpan,
						rowSpan = rowSpan,
						alignmentType = "LeftPin",
						currentRow = currentRow,
						currentColumn = currentColumn,
						nextScanPosition = nextScanPosition,
						itemsPerRow = itemsPerRow,
						maxRows = maxRows,
						nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
					})
				end

				return false
			elseif alignmentType == "RightPin" and currentColumn + colSpan - 1 ~= itemsPerRow then
				if FFlagLuaAppEnableNxMApportioningExtraLogging then
					ApportioningDiagnosticTelemetry.log("SpanDeferred", {
						reason = "right_pin_misaligned",
						originalIndex = originalIndex,
						colSpan = colSpan,
						rowSpan = rowSpan,
						alignmentType = "RightPin",
						currentRow = currentRow,
						currentColumn = currentColumn,
						nextScanPosition = nextScanPosition,
						itemsPerRow = itemsPerRow,
						maxRows = maxRows,
						nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
					})
				end

				return false
			elseif itemsPerRow < currentColumn + colSpan - 1 then
				if FFlagLuaAppEnableNxMApportioningExtraLogging then
					ApportioningDiagnosticTelemetry.log("SpanDeferred", {
						reason = "horizontal_wrap",
						originalIndex = originalIndex,
						colSpan = colSpan,
						rowSpan = rowSpan,
						alignmentType = alignmentType,
						currentRow = currentRow,
						currentColumn = currentColumn,
						nextScanPosition = nextScanPosition,
						itemsPerRow = itemsPerRow,
						maxRows = maxRows,
						nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
					})
				end

				return false
			elseif (FFlagLuaAppEnableNxMRoduxApportioning or flag) and maxRows < currentRow + rowSpan - 1 then
				if FFlagLuaAppEnableNxMApportioningExtraLogging then
					ApportioningDiagnosticTelemetry.log("SpanDeferred", {
						reason = "vertical_overflow",
						originalIndex = originalIndex,
						colSpan = colSpan,
						rowSpan = rowSpan,
						alignmentType = alignmentType,
						currentRow = currentRow,
						currentColumn = currentColumn,
						nextScanPosition = nextScanPosition,
						itemsPerRow = itemsPerRow,
						maxRows = maxRows,
						nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
					})
				end

				return false
			elseif
				(FFlagLuaAppEnableNxMRoduxApportioning or flag)
				and rowSpan > 1
				and #list - originalIndex < currentColumn - 1
			then
				if FFlagLuaAppEnableNxMApportioningExtraLogging then
					ApportioningDiagnosticTelemetry.log("SpanDeferred", {
						reason = "insufficient_trailing_entries",
						originalIndex = originalIndex,
						colSpan = colSpan,
						rowSpan = rowSpan,
						alignmentType = alignmentType,
						currentRow = currentRow,
						currentColumn = currentColumn,
						allEntriesCount = #list,
						nextScanPosition = nextScanPosition,
						itemsPerRow = itemsPerRow,
						maxRows = maxRows,
						nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
					})
				end

				return false
			else
				if defineFastFlag and (FFlagLuaAppEnableNxMRoduxApportioning or flag) then
					for i = 0, rowSpan - 1 do
						for j = 0, colSpan - 1 do
							local collidingRow = currentRow + i
							local collidingCol = currentColumn + j

							if v2[collidingRow] and v2[collidingRow][collidingCol] ~= nil then
								if FFlagLuaAppEnableNxMApportioningExtraLogging then
									ApportioningDiagnosticTelemetry.log("SpanDeferred", {
										reason = "span_cell_collision",
										originalIndex = originalIndex,
										colSpan = colSpan,
										rowSpan = rowSpan,
										alignmentType = alignmentType,
										currentRow = currentRow,
										currentColumn = currentColumn,
										collidingRow = collidingRow,
										collidingCol = collidingCol,
										collidingValue = v2[collidingRow][collidingCol],
										itemsPerRow = itemsPerRow,
										maxRows = maxRows,
										nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
									})
								end

								return false
							end
						end
					end
				end

				if FFlagLuaAppEnableNxMRoduxApportioning or flag then
					for i = 0, rowSpan - 1 do
						for j = 0, colSpan - 1 do
							writeLayoutCell(currentRow + i, currentColumn + j, -1)
						end
					end

					writeLayoutCell(currentRow, currentColumn, originalIndex)
					nextScanPosition = v3 + colSpan
					nextAllowedRow = currentRow + rowSpan - 1 + minRowPadding
				else
					table.insert(placedIndices, originalIndex)
					nextScanPosition += colSpan
					nextAllowedRow = currentRow + minRowPadding
				end

				return true
			end
		else
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "totalcells_exceeded_legacy",
					originalIndex = originalIndex,
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					nextScanPosition = nextScanPosition,
					totalCells = totalCells,
					itemsPerRow = itemsPerRow,
					maxRows = maxRows,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end
	end

	local function tryPlaceDeferredSpanTiles()
		while #pendingSpanTiles > 0 do
			local v3 = pendingSpanTiles[1]

			if not tryPlaceSpanTile(v3.index, v3.spanConfig) then
				break
			end

			table.remove(pendingSpanTiles, 1)
		end
	end

	for _, item in items do
		if #pendingSpanTiles > 0 then
			table.insert(pendingSpanTiles, item)
		elseif not tryPlaceSpanTile(item.index, item.spanConfig) then
			table.insert(pendingSpanTiles, item)
		end
	end

	for i = nextStartIndex, #list do
		local item = list[i]

		if item then
			if totalCells <= nextScanPosition then
				if not FFlagLuaAppEnableNxMApportioningExtraLogging then
					break
				end

				ApportioningDiagnosticTelemetry.log("GridFull", {
					nextScanPosition = nextScanPosition,
					totalCells = totalCells,
					itemsPerRow = itemsPerRow,
					maxRows = maxRows,
					remainingEntries = #list - i + 1,
					deferredCount = #pendingSpanTiles,
					stoppedAtIndex = i,
					allEntriesCount = #list,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
				break
			else
				local spanConfig

				if callback == nil then
					spanConfig = defaultGetSpanConfig(item)
				else
					spanConfig = callback(item, i)
				end

				if spanConfig then
					if #pendingSpanTiles > 0 then
						table.insert(pendingSpanTiles, { index = i, spanConfig = spanConfig })
					elseif not tryPlaceSpanTile(i, spanConfig) then
						table.insert(pendingSpanTiles, { index = i, spanConfig = spanConfig })
					end
				else
					if FFlagLuaAppEnableNxMRoduxApportioning or flag then
						local v3 = nextFreePosition(nextScanPosition)

						if totalCells <= v3 then
							break
						end

						writeLayoutCell(math.floor(v3 / itemsPerRow) + 1, v3 % itemsPerRow + 1, i)
						nextScanPosition = v3 + 1
					else
						table.insert(placedIndices, i)
						nextScanPosition += 1
					end

					tryPlaceDeferredSpanTiles()
				end

				nextStartIndex = i + 1
			end
		else
			DiscoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_InvalidEntry",
				"calculateSpanAwareGrids called with an invalid entry",
				{
					allEntriesCount = #list,
					indexInAllEntries = i,
					itemsPerRow = itemsPerRow
				}
			)

			nextStartIndex = i + 1
		end
	end

	local v3 = {
		placedIndices = placedIndices,
		pendingSpanTiles = pendingSpanTiles,
		nextStartIndex = nextStartIndex,
		layout = nil
	}
	local layout

	if FFlagLuaAppEnableNxMRoduxApportioning or flag then
		layout = v2
	end

	v3.layout = layout
	return v3
end

return {
	calculateSpanAwareGrids = function(list, list2, itemsPerRow: number, callback, flag: boolean?)
		if not list then
			DiscoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_MissingEntries",
				"calculateSpanAwareGrids called without entries",
				{
					gridConfigsCount = #list2,
					itemsPerRow = itemsPerRow
				}
			)

			return {}
		end

		if #list == 0 then
			DiscoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_EmptyEntries",
				"calculateSpanAwareGrids called with empty entries",
				{
					allEntriesCount = #list,
					gridConfigsCount = #list2,
					itemsPerRow = itemsPerRow
				}
			)

			return {}
		end

		if #list2 == 0 then
			return {}
		end

		if not itemsPerRow then
			DiscoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_MissingItemsPerRow",
				"calculateSpanAwareGrids called without itemsPerRow",
				{
					allEntriesCount = #list,
					gridConfigsCount = #list2
				}
			)

			return {}
		end

		if itemsPerRow <= 0 then
			DiscoveryEventErrorLogger.reportError(
				"CalculateSpanAwareGrids_InvalidItemsPerRow",
				"calculateSpanAwareGrids called with invalid itemsPerRow",
				{
					allEntriesCount = #list,
					gridConfigsCount = #list2,
					itemsPerRow = itemsPerRow
				}
			)

			return {}
		end

		local v2 = 1
		local v3 = {}
		local result = {}

		for _, item in list2 do
			local maxRows = item.maxRows
			local v4 = processOneGrid(
				list,
				v2,
				v3,
				itemsPerRow,
				(not maxRows or maxRows <= 0) and 1e999 or maxRows,
				callback,
				flag
			)

			local sortKey = item.sortKey
			local entryIndices

			if not (FFlagLuaAppEnableNxMRoduxApportioning or flag) then
				entryIndices = v4.placedIndices
			end

			local layout

			if FFlagLuaAppEnableNxMRoduxApportioning or flag then
				layout = v4.layout
			end

			result[sortKey] = { entryIndices = entryIndices, layout = layout }

			v2 = v4.nextStartIndex
			v3 = v4.pendingSpanTiles
		end

		return result
	end,
	processOneGrid = processOneGrid
}
