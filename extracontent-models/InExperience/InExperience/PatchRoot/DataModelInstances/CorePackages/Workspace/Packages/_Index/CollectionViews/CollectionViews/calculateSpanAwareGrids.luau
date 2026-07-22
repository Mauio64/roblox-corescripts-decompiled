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
local t1 = {
	[GameCollectionItemType.TwoByOneTile] = {
		colSpan = 2,
		rowSpan = 1
	}
}

local function defaultGetSpanConfig(p1) -- line: 77
	-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), SpanForItemType (copy), t1 (copy)
	local v18 = p1 and if not FFlagLuaAppEnableNxMRoduxApportioning then t1[p1.componentType] else SpanForItemType[p1.componentType]

	if not v18 then
		return nil
	end

	return {
		colSpan = v18.colSpan,
		rowSpan = not FFlagLuaAppEnableNxMRoduxApportioning and 1 or v18.rowSpan,
		minRowPadding = tonumber(p1.minRowPadding) or 0,
		alignmentType = p1.alignmentType
	}
end
local function processOneGrid(t2: {[any]: any}, n1: number, t3: {[any]: any}, n2: number, n3: number, p2: ((...any) -> ...any)?, b1: boolean?) -- line: 96
	-- upvalues: DiscoveryEventErrorLogger (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), FFlagSduiPoolBackedFeed (copy), FFlagLuaAppEnableNxMApportioningExtraLogging (copy), ApportioningDiagnosticTelemetry (copy), FFlagLuaAppApportioningInCollectionViews (copy), defaultGetSpanConfig (copy)
	local v26 = n3 * n2
	local t4 = {}
	local t5 = {}
	local n4 = 0
	local n5 = 1
	local t6 = {}

	local function nextFreePosition(n6: number) -- line: 121
		-- upvalues: n2 (copy), t6 (copy)
		repeat
			local v55 = math.floor(n6 / n2) + 1
			local v56 = n6 % n2 + 1
			local v57 = not t6[v55] or t6[v55][v56] ~= -1

			if not v57 then
				n6 += 1
			end
		until v57

		return n6
	end
	local function writeLayoutCell(n7: number, n8: number, n9: number) -- line: 135
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
	local function tryPlaceSpanTile(n10: number, t7: {[any]: any}) -- line: 155
		-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), FFlagSduiPoolBackedFeed (copy), b1 (copy), nextFreePosition (copy), n4 (ref), n2 (copy), n5 (ref), FFlagLuaAppEnableNxMApportioningExtraLogging (copy), ApportioningDiagnosticTelemetry (copy), n3 (copy), v26 (copy), t2 (copy), writeLayoutCell (copy), t4 (copy)
		local colSpan = t7.colSpan
		local v64 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then nil else t7.rowSpan
		local minRowPadding = t7.minRowPadding
		local alignmentType = t7.alignmentType
		local v67 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then n4 else nextFreePosition(n4)
		local v68 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then math.ceil((n4 + 1) / n2) else math.floor(v67 / n2) + 1
		local v69 = v67 % n2 + 1

		if v68 < n5 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "padding_constraint",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v64,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					currentRow = v68,
					currentColumn = v69,
					nextAllowedRow = n5,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if not FFlagLuaAppEnableNxMRoduxApportioning and ((not FFlagSduiPoolBackedFeed or not b1) and n4 + colSpan > v26) then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "totalcells_exceeded_legacy",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v64,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding,
					nextScanPosition = n4,
					totalCells = v26,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if alignmentType == "LeftPin" and v69 ~= 1 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "left_pin_misaligned",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v64,
					alignmentType = alignmentType,
					currentRow = v68,
					currentColumn = v69,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if alignmentType == "RightPin" and v69 + colSpan - 1 ~= n2 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "right_pin_misaligned",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v64,
					alignmentType = alignmentType,
					currentRow = v68,
					currentColumn = v69,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if v69 + colSpan - 1 > n2 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "horizontal_wrap",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v64,
					alignmentType = alignmentType,
					currentRow = v68,
					currentColumn = v69,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if (FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1) and v68 + v64 - 1 > n3 then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "vertical_overflow",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v64,
					alignmentType = alignmentType,
					currentRow = v68,
					currentColumn = v69,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if (FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1) and (v64 > 1 and #t2 - n10 < v69 - 1) then
			if FFlagLuaAppEnableNxMApportioningExtraLogging then
				ApportioningDiagnosticTelemetry.log("SpanDeferred", {
					reason = "insufficient_trailing_entries",
					originalIndex = n10,
					colSpan = colSpan,
					rowSpan = v64,
					alignmentType = alignmentType,
					currentRow = v68,
					currentColumn = v69,
					allEntriesCount = #t2,
					nextScanPosition = n4,
					itemsPerRow = n2,
					maxRows = n3,
					nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
				})
			end

			return false
		end

		if FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1 then
			for i = 0, v64 - 1 do
				for j = 0, colSpan - 1 do
					writeLayoutCell(v68 + i, v69 + j, -1)
				end
			end

			writeLayoutCell(v68, v69, n10)
			n4 = v67 + colSpan
			n5 = v68 + v64 - 1 + minRowPadding
		else
			table.insert(t4, n10)
			n4 += colSpan
			n5 = v68 + minRowPadding
		end

		return true
	end
	local function tryPlaceDeferredSpanTiles() -- line: 339
		-- upvalues: t5 (copy), tryPlaceSpanTile (copy)
		while #t5 > 0 do
			local v72 = t5[1]

			if not tryPlaceSpanTile(v72.index, v72.spanConfig) then
				return
			end

			table.remove(t5, 1)
		end
	end

	for _, v37 in t3 do
		if #t5 > 0 then
			table.insert(t5, v37)
		elseif not tryPlaceSpanTile(v37.index, v37.spanConfig) then
			table.insert(t5, v37)
		end
	end

	for i = n1, #t2 do
		local v39 = t2[i]

		if v39 then
			if v26 <= n4 then
				if not FFlagLuaAppEnableNxMApportioningExtraLogging then
					break
				end

				ApportioningDiagnosticTelemetry.log("GridFull", {
					nextScanPosition = n4,
					totalCells = v26,
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

			local v40 = if not FFlagLuaAppApportioningInCollectionViews or p2 == nil then defaultGetSpanConfig(v39) else p2(v39, i)

			if v40 then
				if #t5 > 0 then
					table.insert(t5, {
						index = i,
						spanConfig = v40
					})
				elseif not tryPlaceSpanTile(i, v40) then
					table.insert(t5, {
						index = i,
						spanConfig = v40
					})
				end

				n1 = i + 1
			else
				if FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1 then
					local v41 = nextFreePosition(n4)

					if v26 <= v41 then
						break
					end

					writeLayoutCell(math.floor(v41 / n2) + 1, v41 % n2 + 1, i)
					n4 = v41 + 1
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
	calculateSpanAwareGrids = function(t8: {[any]: any}, t9: {[any]: any}, n11: number, p3: ((...any) -> ...any)?, b2: boolean?) -- line: 445
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

		for _, v51 in t9 do
			local maxRows = v51.maxRows

			if not maxRows or maxRows <= 0 then
				maxRows = 1e999
			end

			local v53 = processOneGrid(t8, n12, t11, n11, maxRows, if not FFlagLuaAppApportioningInCollectionViews then nil else p3, if not FFlagSduiPoolBackedFeed then nil else b2)

			t10[v51.sortKey] = {
				entryIndices = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b2) then v53.placedIndices else nil,
				layout = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b2) then nil else v53.layout
			}
			n12 = v53.nextStartIndex
			t11 = v53.pendingSpanTiles
		end

		return t10
	end,
	processOneGrid = processOneGrid
}
