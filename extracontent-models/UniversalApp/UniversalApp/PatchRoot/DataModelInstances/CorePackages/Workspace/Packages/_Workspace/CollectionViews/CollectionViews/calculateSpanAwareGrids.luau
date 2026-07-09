local Parent = script:FindFirstAncestor("CollectionViews").Parent
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local DiscoveryUtils = require(Parent.DiscoveryUtils)
local SharedFlags = require(Parent.SharedFlags)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local GameCollectionItemType = GameCollectionItemTypes.GameCollectionItemType
local SpanForItemType = GameCollectionItemTypes.SpanForItemType
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppApportioningInCollectionViews = SharedFlags.FFlagLuaAppApportioningInCollectionViews
local FFlagSduiPoolBackedFeed = SharedFlags.FFlagSduiPoolBackedFeed
local t1 = {
	[GameCollectionItemType.TwoByOneTile] = {
		colSpan = 2,
		rowSpan = 1
	}
}

local function defaultGetSpanConfig(p1) -- line: 75
	-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), SpanForItemType (copy), t1 (copy)
	local v16 = p1 and if not FFlagLuaAppEnableNxMRoduxApportioning then t1[p1.componentType] else SpanForItemType[p1.componentType]

	if not v16 then
		return nil
	end

	return {
		colSpan = v16.colSpan,
		rowSpan = not FFlagLuaAppEnableNxMRoduxApportioning and 1 or v16.rowSpan,
		minRowPadding = tonumber(p1.minRowPadding) or 0,
		alignmentType = p1.alignmentType
	}
end
local function processOneGrid(t2: {[any]: any}, n1: number, t3: {[any]: any}, n2: number, n3: number, p2: ((...any) -> ...any)?, b1: boolean?) -- line: 94
	-- upvalues: DiscoveryEventErrorLogger (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), FFlagSduiPoolBackedFeed (copy), FFlagLuaAppApportioningInCollectionViews (copy), defaultGetSpanConfig (copy)
	local v24 = n3 * n2
	local t4 = {}
	local t5 = {}
	local n4 = 0
	local n5 = 1
	local t6 = {}

	local function nextFreePosition(n6: number) -- line: 119
		-- upvalues: n2 (copy), t6 (copy)
		repeat
			local v53 = math.floor(n6 / n2) + 1
			local v54 = n6 % n2 + 1
			local v55 = not t6[v53] or t6[v53][v54] ~= -1

			if not v55 then
				n6 += 1
			end
		until v55

		return n6
	end
	local function writeLayoutCell(n7: number, n8: number, n9: number) -- line: 133
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
	local function tryPlaceSpanTile(n10: number, t7: {[any]: any}) -- line: 153
		-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), FFlagSduiPoolBackedFeed (copy), b1 (copy), nextFreePosition (copy), n4 (ref), n2 (copy), n5 (ref), v24 (copy), n3 (copy), t2 (copy), writeLayoutCell (copy), t4 (copy)
		local colSpan = t7.colSpan
		local v62 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then nil else t7.rowSpan
		local minRowPadding = t7.minRowPadding
		local alignmentType = t7.alignmentType
		local v65 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then n4 else nextFreePosition(n4)
		local v66 = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then math.ceil((n4 + 1) / n2) else math.floor(v65 / n2) + 1
		local v67 = v65 % n2 + 1

		if v66 < n5 then
			return false
		end

		if not FFlagLuaAppEnableNxMRoduxApportioning and ((not FFlagSduiPoolBackedFeed or not b1) and n4 + colSpan > v24) then
			return false
		end

		if alignmentType == "LeftPin" and v67 ~= 1 then
			return false
		end

		if alignmentType == "RightPin" and v67 + colSpan - 1 ~= n2 then
			return false
		end

		if v67 + colSpan - 1 > n2 then
			return false
		end

		if (FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1) and v66 + v62 - 1 > n3 then
			return false
		end

		if (FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1) and (v62 > 1 and #t2 - n10 < v67 - 1) then
			return false
		end

		if FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1 then
			for i = 0, v62 - 1 do
				for j = 0, colSpan - 1 do
					writeLayoutCell(v66 + i, v67 + j, -1)
				end
			end

			writeLayoutCell(v66, v67, n10)
			n4 = v65 + colSpan
			n5 = v66 + v62 - 1 + minRowPadding
		else
			table.insert(t4, n10)
			n4 += colSpan
			n5 = v66 + minRowPadding
		end

		return true
	end
	local function tryPlaceDeferredSpanTiles() -- line: 229
		-- upvalues: t5 (copy), tryPlaceSpanTile (copy)
		while #t5 > 0 do
			local v70 = t5[1]

			if not tryPlaceSpanTile(v70.index, v70.spanConfig) then
				return
			end

			table.remove(t5, 1)
		end
	end

	for _, v35 in t3 do
		if #t5 > 0 then
			table.insert(t5, v35)
		elseif not tryPlaceSpanTile(v35.index, v35.spanConfig) then
			table.insert(t5, v35)
		end
	end

	for i = n1, #t2 do
		local v37 = t2[i]

		if not v37 then
			DiscoveryEventErrorLogger.reportError("CalculateSpanAwareGrids_InvalidEntry", "calculateSpanAwareGrids called with an invalid entry", {
				allEntriesCount = #t2,
				indexInAllEntries = i,
				itemsPerRow = n2
			})
			n1 = i + 1
		else
			if v24 <= n4 then
				break
			end

			local v38 = if not FFlagLuaAppApportioningInCollectionViews or p2 == nil then defaultGetSpanConfig(v37) else p2(v37, i)

			if v38 then
				if #t5 > 0 then
					table.insert(t5, {
						index = i,
						spanConfig = v38
					})
				elseif not tryPlaceSpanTile(i, v38) then
					table.insert(t5, {
						index = i,
						spanConfig = v38
					})
				end

				n1 = i + 1
			else
				if FFlagLuaAppEnableNxMRoduxApportioning or FFlagSduiPoolBackedFeed and b1 then
					local v39 = nextFreePosition(n4)

					if v24 <= v39 then
						break
					end

					writeLayoutCell(math.floor(v39 / n2) + 1, v39 % n2 + 1, i)
					n4 = v39 + 1
				else
					table.insert(t4, i)
					n4 += 1
				end

				tryPlaceDeferredSpanTiles()
				n1 = i + 1
			end
		end
	end

	return {
		placedIndices = t4,
		pendingSpanTiles = t5,
		nextStartIndex = n1,
		layout = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b1) then nil else t6
	}
end

return {
	calculateSpanAwareGrids = function(t8: {[any]: any}, t9: {[any]: any}, n11: number, p3: ((...any) -> ...any)?, b2: boolean?) -- line: 322
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

		for _, v49 in t9 do
			local maxRows = v49.maxRows

			if not maxRows or maxRows <= 0 then
				maxRows = 1e999
			end

			local v51 = processOneGrid(t8, n12, t11, n11, maxRows, if not FFlagLuaAppApportioningInCollectionViews then nil else p3, if not FFlagSduiPoolBackedFeed then nil else b2)

			t10[v49.sortKey] = {
				entryIndices = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b2) then v51.placedIndices else nil,
				layout = if not FFlagLuaAppEnableNxMRoduxApportioning and (not FFlagSduiPoolBackedFeed or not b2) then nil else v51.layout
			}
			n12 = v51.nextStartIndex
			t11 = v51.pendingSpanTiles
		end

		return t10
	end,
	processOneGrid = processOneGrid
}
