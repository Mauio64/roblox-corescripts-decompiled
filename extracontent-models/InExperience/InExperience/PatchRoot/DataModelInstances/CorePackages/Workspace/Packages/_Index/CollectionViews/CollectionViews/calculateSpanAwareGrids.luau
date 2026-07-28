local Parent = script:FindFirstAncestor("CollectionViews").Parent
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local DiscoveryUtils = require(Parent.DiscoveryUtils)
local SharedFlags = require(Parent.SharedFlags)
local ApportioningDiagnosticTelemetry = DiscoveryUtils.ApportioningDiagnosticTelemetry
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local GameCollectionItemType = GameCollectionItemTypes.GameCollectionItemType
local SpanForItemType = GameCollectionItemTypes.SpanForItemType
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppApportioningInCollectionViews = SharedFlags.FFlagLuaAppApportioningInCollectionViews
local FFlagSduiPoolBackedFeed = SharedFlags.FFlagSduiPoolBackedFeed
local FFlagLuaAppEnableNxMApportioningExtraLogging = SharedFlags.FFlagLuaAppEnableNxMApportioningExtraLogging
local v14 = game:DefineFastFlag("LuaAppFixApportioningTileTailConflict", false)
local t1 = {
	[GameCollectionItemType.TwoByOneTile] = {
		colSpan = 2,
		rowSpan = 1
	}
}

local function defaultGetSpanConfig(p1) -- line: 78
	-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), SpanForItemType (copy), t1 (copy)
	local v19 = p1 and if not FFlagLuaAppEnableNxMRoduxApportioning then t1[p1.componentType] else SpanForItemType[p1.componentType]

	if not v19 then
		return nil
	end

	return {
		colSpan = v19.colSpan,
		rowSpan = not FFlagLuaAppEnableNxMRoduxApportioning and 1 or v19.rowSpan,
		minRowPadding = tonumber(p1.minRowPadding) or 0,
		alignmentType = p1.alignmentType
	}
end
local function processOneGrid(t2: {[any]: any}, n1: number, t3: {[any]: any}, n2: number, n3: number, p2: ((...any) -> ...any)?, b1: boolean?) -- line: 97
	-- upvalues: DiscoveryEventErrorLogger (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), FFlagSduiPoolBackedFeed (copy), FFlagLuaAppEnableNxMApportioningExtraLogging (copy), ApportioningDiagnosticTelemetry (copy), v14 (copy), FFlagLuaAppApportioningInCollectionViews (copy), defaultGetSpanConfig (copy)
	local v27 = n3 * n2
	local t4 = {}
	local t5 = {}
	local n4 = 0
	local n5 = 1
	local t6 = {}

	local function nextFreePosition(n6: number) -- line: 122
		-- upvalues: n2 (copy), t6 (copy)
		repeat
			local v56 = math.floor(n6 / n2) + 1
			local v57 = n6 % n2 + 1
			local v58 = not t6[v56] or t6[v56][v57] ~= -1

			if not v58 then
				n6 += 1
			end
		until v58

		return n6
	end
	local function writeLayoutCell(n7: number, n8: number, n9: number) -- line: 136
		-- upvalues: n3 (copy), DiscoveryEventErrorLogger (copy), n2 (copy), t6 (copy)
		if n7 > n3 then
			DiscoveryEventErrorLogger.reportError("CalculateSpanAwareGrids_LayoutWritePastMaxRows", "writeLayoutCell attempted to write past maxRows", {
				row = n7,
				col = n8,
				maxRows = n3,
				itemsPerRow = n2
			})

			return
		end

		if not t6[n7] then
			t6[n7] = {}
		end

		t6[n7][n8] = n9
	end
	local function tryPlaceSpanTile(n10: number, t7: {[any]: any}) -- line: 156
		-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), FFlagSduiPoolBackedFeed (copy), b1 (copy), nextFreePosition (copy), n4 (ref), n2 (copy), n5 (ref), FFlagLuaAppEnableNxMApportioningExtraLogging (copy), ApportioningDiagnosticTelemetry (copy), n3 (copy), v27 (copy), t2 (copy), v14 (copy), t6 (copy), writeLayoutCell (copy), t4 (copy)
		local colSpan = t7.colSpan
		local v65 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then nil else t7.rowSpan
		local minRowPadding = t7.minRowPadding
		local alignmentType = t7.alignmentType
		local v68 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then n4 else nextFreePosition(n4)
		local v69 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then math.ceil((n4 + 1) / n2) else math.floor(v68 / n2) + 1
		local v70 = v68 % n2 + 1

		if v69 < n5 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "padding_constraint",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v65,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					currentRow = v69,
					currentColumn = v70,
					nextAllowedRow = n5,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if not FFlagLuaAppEnableNxMRoduxApportioning and ((not FFlagSduiPoolBackedFeed or not b1) and n4 + colSpan > v27) then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "totalcells_exceeded_legacy",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v65,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					nextScanPosition = n4,
					totalCells = v27,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if alignmentType == "LeftPin" and v70 ~= 1 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "left_pin_misaligned",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v65,
					alignmentType = alignmentType,
					currentRow = v69,
					currentColumn = v70,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if alignmentType == "RightPin" and v70 + colSpan - 1 ~= n2 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "right_pin_misaligned",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v65,
					alignmentType = alignmentType,
					currentRow = v69,
					currentColumn = v70,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if v70 + colSpan - 1 > n2 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "horizontal_wrap",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v65,
					alignmentType = alignmentType,
					currentRow = v69,
					currentColumn = v70,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if (FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1) and v69 + v65 - 1 > n3 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "vertical_overflow",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v65,
					alignmentType = alignmentType,
					currentRow = v69,
					currentColumn = v70,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if (FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1) and (v65 > 1 and #t2 - n10 < v70 - 1) then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "insufficient_trailing_entries",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v65,
					alignmentType = alignmentType,
					currentRow = v69,
					currentColumn = v70,
					allEntriesCount = #t2,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if v14 and (FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1) then
			for i = 0, v65 - 1 do
				for j = 0, colSpan - 1 do
					local v73 = v69 + i
					local v74 = v70 + j

					if t6[v73] and t6[v73][v74] ~= nil then
						if FFlagLuaAppEnableNxMApportioningExtraLogging then
							ApportioningDiagnosticTelemetry.log("SpanDeferred", {
								reason = "span_cell_collision",
								originalIndex = n10,
								colSpan = colSpan,
								rowSpan = v65,
								alignmentType = alignmentType,
								currentRow = v69,
								currentColumn = v70,
								collidingRow = v73,
								collidingCol = v74,
								collidingValue = t6[v73][v74],
								itemsPerRow = n2,
								maxRows = n3,
								nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
							})
						end

						return false
					end
				end
			end
		end

		if FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1 then
			for i = 0, v65 - 1 do
				for j = 0, colSpan - 1 do
					writeLayoutCell(v69 + i, v70 + j, -1)
				end
			end

			writeLayoutCell(v69, v70, n10)
			n4 = v68 + colSpan
			n5 = v69 + v65 - 1 + minRowPadding
		else
			table.insert(t4, n10)
			n4 += colSpan
			n5 = v69 + minRowPadding
		end

		return true
	end
	local function tryPlaceDeferredSpanTiles() -- line: 372
		-- upvalues: t5 (copy), tryPlaceSpanTile (copy)
		while #t5 > 0 do
			local v77 = t5[1]

			if not tryPlaceSpanTile(v77.index, v77.spanConfig) then
				return
			end

			table.remove(t5, 1)
		end
	end

	for _, v38 in t3 do
		if #t5 > 0 then
			table.insert(t5, v38)
		elseif not tryPlaceSpanTile(v38.index, v38.spanConfig) then
			table.insert(t5, v38)
		end
	end

	for i = n1, #t2 do
		local v40 = t2[i]

		if v40 then
			if v27 <= n4 then
				if not FFlagLuaAppEnableNxMApportioningExtraLogging then
					break
				end

				ApportioningDiagnosticTelemetry.log("GridFull", {
					nextScanPosition = n4,
					totalCells = v27,
					itemsPerRow = n2,
					maxRows = n3,
					remainingEntries = #t2 - i + 1,
					deferredCount = #t5,
					stoppedAtIndex = i,
					allEntriesCount = #t2,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})

				break
			end

			local v41 = if not FFlagLuaAppApportioningInCollectionViews or p2 == nil then defaultGetSpanConfig(v40) else p2(v40, i)

			if v41 then
				if #t5 > 0 then
					table.insert(t5, {
						index = i,
						spanConfig = v41
					})
				elseif not tryPlaceSpanTile(i, v41) then
					table.insert(t5, {
						index = i,
						spanConfig = v41
					})
				end

				n1 = i + 1
			else
				if FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1 then
					local v42 = nextFreePosition(n4)

					if v27 <= v42 then
						break
					end

					writeLayoutCell(math.floor(v42 / n2) + 1, v42 % n2 + 1, i)
					n4 = v42 + 1
				else
					table.insert(t4, i)
					n4 += 1
				end

				tryPlaceDeferredSpanTiles()
				n1 = i + 1
			end

			continue
		end

		DiscoveryEventErrorLogger.reportError("CalculateSpanAwareGrids_InvalidEntry", "calculateSpanAwareGrids called with an invalid entry", {
			allEntriesCount = #t2,
			indexInAllEntries = i,
			itemsPerRow = n2
		})
		n1 = i + 1
	end

	return {
		placedIndices = t4,
		pendingSpanTiles = t5,
		nextStartIndex = n1,
		layout = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then nil else t6
	}
end

return {
	calculateSpanAwareGrids = function(t8: {[any]: any}, t9: {[any]: any}, n11: number, p3: ((...any) -> ...any)?, b2: boolean?) -- line: 478
		-- upvalues: DiscoveryEventErrorLogger (copy), processOneGrid (copy), FFlagLuaAppApportioningInCollectionViews (copy), FFlagSduiPoolBackedFeed (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy)
		if not t8 then
			DiscoveryEventErrorLogger.reportError("CalculateSpanAwareGrids_MissingEntries", "calculateSpanAwareGrids called without entries", {
				gridConfigsCount = #t9,
				itemsPerRow = n11
			})

			return {}
		end

		if #t8 == 0 then
			DiscoveryEventErrorLogger.reportError("CalculateSpanAwareGrids_EmptyEntries", "calculateSpanAwareGrids called with empty entries", {
				allEntriesCount = #t8,
				gridConfigsCount = #t9,
				itemsPerRow = n11
			})

			return {}
		end

		if #t9 == 0 then
			return {}
		end

		if not n11 then
			DiscoveryEventErrorLogger.reportError("CalculateSpanAwareGrids_MissingItemsPerRow", "calculateSpanAwareGrids called without itemsPerRow", {
				allEntriesCount = #t8,
				gridConfigsCount = #t9
			})

			return {}
		end

		if n11 <= 0 then
			DiscoveryEventErrorLogger.reportError("CalculateSpanAwareGrids_InvalidItemsPerRow", "calculateSpanAwareGrids called with invalid itemsPerRow", {
				allEntriesCount = #t8,
				gridConfigsCount = #t9,
				itemsPerRow = n11
			})

			return {}
		end

		local t10 = {}
		local n12 = 1
		local t11 = {}

		for _, v52 in t9 do
			local maxRows = v52.maxRows

			if not maxRows or maxRows <= 0 then
				maxRows = 1e999
			end

			local v54 = processOneGrid(t8, n12, t11, n11, maxRows, if not FFlagLuaAppApportioningInCollectionViews then nil else p3, if not FFlagSduiPoolBackedFeed then nil else b2)

			t10[v52.sortKey] = {
				entryIndices = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b2) then v54.placedIndices else nil,
				layout = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b2) then nil else v54.layout
			}
			n12 = v54.nextStartIndex
			t11 = v54.pendingSpanTiles
		end

		return t10
	end,
	processOneGrid = processOneGrid
}
