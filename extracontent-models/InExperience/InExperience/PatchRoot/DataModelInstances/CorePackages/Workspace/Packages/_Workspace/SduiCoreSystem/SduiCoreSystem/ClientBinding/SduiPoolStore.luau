local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

local Signals = require(parent.Signals)
local CollectionViews = require(parent.CollectionViews)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)
local SduiPoolStoreLayout = require(SduiCoreSystem.ClientBinding.SduiPoolStoreLayout)

local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore
local processOneGrid = CollectionViews.processOneGrid
local makePoolGetSpanConfig = SduiPoolStoreLayout.makePoolGetSpanConfig
local layoutToCells = SduiPoolStoreLayout.layoutToCells
local cellsEqual = SduiPoolStoreLayout.cellsEqual
local EMPTY_CELLS = SduiPoolStoreLayout.EMPTY_CELLS

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiCollectionGridRevealRows = SharedFlags2.FFlagSduiCollectionGridRevealRows
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiSkipFeedAnalyticsPosition = SharedFlags3.FFlagSduiSkipFeedAnalyticsPosition
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiPerSectionPoolSizing = SharedFlags4.FFlagSduiPerSectionPoolSizing

local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiVerticalFeedProgressiveFillOnScroll = SharedFlags5.FFlagSduiVerticalFeedProgressiveFillOnScroll

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = SharedFlags6.FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui

local frozen = table.freeze({})

local function logSkipped(data, p, p2: string)
	local onSkipped = p and p.onSkipped
	local oneByTwoTileFlowId = data and data.oneByTwoTileFlowId

	if onSkipped and data and typeof(oneByTwoTileFlowId) == "string" then
		local success, result = pcall(function(): nil
			onSkipped({
				oneByTwoTileFlowId = oneByTwoTileFlowId,
				contentType = data.contentType,
				adId = data.adId,
				componentType = "OneByTwoTile",
				isSdui = true
			})

			return nil
		end)

		if not success then
			SduiLogger.reportError(
				SduiErrors.SduiErrorType.CodeError,
				{
					name = "OneByTwoTileSkipped",
					message = SduiParseHelpers.stringifyValue(result)
				},
				p2
			)
		end
	end
end

local function sectionConfigsEqual(data, data2)
	if data == data2 then
		return true
	end

	if data == nil or data2 == nil then
		return false
	end

	local v

	if data.poolId == data2.poolId and data.numberOfRows == data2.numberOfRows then
		v = (not FFlagSduiSkipFeedAnalyticsPosition or data.doesNotAdvanceStartRow == data2.doesNotAdvanceStartRow)
			and (not FFlagSduiPerSectionPoolSizing or data.entryCollectionItemSize == data2.entryCollectionItemSize)
			and (not FFlagSduiPerSectionPoolSizing or data.templateCollectionItemSize == data2.templateCollectionItemSize)

		if v then
			if data.prevSectionInPoolId == data2.prevSectionInPoolId then
				return data.prevSectionId == data2.prevSectionId
			end

			return false
		end
	else
		return false
	end

	return v
end

local function getSectionCollectionItemSize(p, p2, p3)
	local collectionItemSize = p2.collectionItemSize

	if typeof(collectionItemSize) == "string" and p.getItemsPerRow[collectionItemSize] ~= nil then
		return collectionItemSize
	end

	local entryCollectionItemSize = p3.entryCollectionItemSize

	if typeof(entryCollectionItemSize) == "string" and p.getItemsPerRow[entryCollectionItemSize] ~= nil then
		return entryCollectionItemSize
	end

	local templateCollectionItemSize = p3.templateCollectionItemSize

	if typeof(templateCollectionItemSize) == "string" and p.getItemsPerRow[templateCollectionItemSize] ~= nil then
		return templateCollectionItemSize
	end

	return "Medium"
end

local function createSduiPoolStore(p: string?)
	local poolSignals = {}
	local sectionConfigSignals = {}

	local v = FFlagSduiCollectionGridRevealRows and {} or nil

	local computeds = {}
	local v2 = {}

	local v3 = FFlagSduiCollectionGridRevealRows and {} or nil

	local computeds2 = {}
	local v4 = {}

	local signal, v5 = Signals.createSignal(nil)
	local v6 = nil

	local function getOrCreatePoolSignal(p2: string) -- 2 equivalent calls inferred from this helper
		local poolSignal = poolSignals[p2]

		if poolSignal == nil then
			local signal2, set = Signals.createSignal(nil)
			poolSignal = { get = signal2, set = set }
			poolSignals[p2] = poolSignal
		end

		return poolSignal
	end

	local function getOrCreateSectionConfigSignal(p2: string) -- 10 equivalent calls inferred from this helper
		local sectionConfigSignal = sectionConfigSignals[p2]

		if sectionConfigSignal == nil then
			local signal2, set = Signals.createSignal(nil, sectionConfigsEqual)
			sectionConfigSignal = { get = signal2, set = set }
			sectionConfigSignals[p2] = sectionConfigSignal
		end

		return sectionConfigSignal
	end

	local fn = FFlagSduiCollectionGridRevealRows and function(p2: string)
		local v7 = v[p2]

		if v7 == nil then
			local signal2, set = Signals.createSignal(nil)
			v7 = { get = signal2, set = set }
			v[p2] = v7
		end

		return v7
	end or nil
	local function fn2(p2: string)
		local v7 = computeds[p2]

		if v7 ~= nil then
			return v7
		end

		local computed = Signals.createComputed(function(p3)
			local v8 = getOrCreateSectionConfigSignal(p2).get(p3) -- inferred equivalent call

			if v8 == nil or v8.poolId == nil then
				return nil
			end

			local v9 = getOrCreatePoolSignal(v8.poolId).get(p3) -- inferred equivalent call

			if v9 == nil or #v9.items == 0 then
				return nil
			end

			local v10 = signal(p3) or getMainCollectionLayoutStore(p3)
			local v11

			if FFlagSduiPerSectionPoolSizing then
				v11 = v9.collectionItemSize

				if typeof(v11) ~= "string" or v10.getItemsPerRow[v11] == nil then
					v11 = v8.entryCollectionItemSize

					if typeof(v11) ~= "string" or v10.getItemsPerRow[v11] == nil then
						local templateCollectionItemSize = v8.templateCollectionItemSize

						v11 = (typeof(templateCollectionItemSize) ~= "string" or v10.getItemsPerRow[templateCollectionItemSize] == nil)
							and "Medium"
							or templateCollectionItemSize
					end
				end
			else
				v11 = (typeof(v9.collectionItemSize) ~= "string" or v10.getItemsPerRow[v9.collectionItemSize] == nil)
					and "Medium"
					or v9.collectionItemSize
			end

			local v12 = v10.getItemsPerRow[v11](p3)

			if v12 <= 0 then
				return nil
			end

			local v13 = frozen
			local nextStartIndex

			if v8.prevSectionInPoolId == nil then
				nextStartIndex = 1
			else
				local v14 = fn2(v8.prevSectionInPoolId)(p3)

				if v14 == nil then
					return nil
				end

				nextStartIndex = v14.nextStartIndex
				v13 = v14.pendingSpanTiles
			end

			local numberOfRows = v8.numberOfRows
			local v14 = numberOfRows <= 0 and 1e999 or numberOfRows

			if v9.layouts == nil and #v13 == 0 then
				local v15 = math.max(0, #v9.items - nextStartIndex + 1)
				local v16

				if v14 == 1e999 then
					v16 = v15
				else
					v16 = v14 * v12
				end

				local v17 = math.min(v16, v15)

				if v17 == 0 then
					return {
						cells = EMPTY_CELLS,
						actualRowCount = 0,
						nextStartIndex = nextStartIndex,
						pendingSpanTiles = frozen
					}
				end

				local actualRowCount = math.ceil(v17 / v12)
				local cells = {}

				for i = 0, v17 - 1 do
					local realIndex = nextStartIndex + i
					cells[i + 1] = { item = v9.items[realIndex], realIndex = realIndex }
				end

				for i = v17 + 1, actualRowCount * v12 do
					cells[i] = {}
				end

				return {
					cells = cells,
					actualRowCount = actualRowCount,
					nextStartIndex = nextStartIndex + v17,
					pendingSpanTiles = frozen
				}
			else
				local v15

				if v9.layouts ~= nil then
					v15 = makePoolGetSpanConfig(v9.layouts)
				end

				local v16 = processOneGrid(
					v9.items,
					nextStartIndex,
					v13,
					v12,
					v14,
					v15,
					not FFlagLuaAppEnableNxMRoduxApportioning
				)

				local cells, actualRowCount = layoutToCells(v16.layout, v12, v9.items, v9.layouts)

				if FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
					local onPlaced = v6 and v6.onPlaced

					for k, v17 in cells do
						local item = v17.item
						local oneByTwoTileFlowId = item and item.oneByTwoTileFlowId

						if not (onPlaced and item and typeof(oneByTwoTileFlowId) == "string") then
							continue
						end

						local success, result = pcall(function(): nil
							onPlaced({
								oneByTwoTileFlowId = oneByTwoTileFlowId,
								contentType = item.contentType,
								adId = item.adId,
								componentType = "OneByTwoTile",
								gridRow = math.ceil(k / v12),
								gridCol = (k - 1) % v12 + 1,
								isSdui = true
							})

							return nil
						end)

						if not success then
							SduiLogger.reportError(
								SduiErrors.SduiErrorType.CodeError,
								{
									name = "OneByTwoTilePlaced",
									message = SduiParseHelpers.stringifyValue(result)
								},
								p
							)
						end
					end

					local v17 = false

					for k, v18 in sectionConfigSignals do
						if k == p2 then
							continue
						end

						local v19 = v18.get(false)

						if v19 and v19.prevSectionInPoolId == p2 then
							v17 = true
							break
						end
					end

					if not v17 then
						for _, pendingSpanTile in v16.pendingSpanTiles do
							logSkipped(v9.items[pendingSpanTile.index], v6, p)
						end

						local oneByTwoTileFlowIdSet = {}

						for _, v18 in cells do
							local item = v18.item
							local oneByTwoTileFlowId = item and item.oneByTwoTileFlowId

							if typeof(oneByTwoTileFlowId) == "string" then
								oneByTwoTileFlowIdSet[oneByTwoTileFlowId] = true
							end
						end

						for i = v16.nextStartIndex, #v9.items do
							local item = v9.items[i]
							local oneByTwoTileFlowId = item and item.oneByTwoTileFlowId

							if typeof(oneByTwoTileFlowId) ~= "string" or oneByTwoTileFlowIdSet[oneByTwoTileFlowId] then
								continue
							end

							logSkipped(item, v6, p)
						end
					end
				end

				return {
					cells = cells,
					actualRowCount = actualRowCount,
					nextStartIndex = v16.nextStartIndex,
					pendingSpanTiles = v16.pendingSpanTiles
				}
			end
		end)

		computeds[p2] = computed
		return computed
	end

	local function getRowCountComputed(p2: string)
		local v7 = v2[p2]

		if v7 ~= nil then
			return v7
		end

		local computed = Signals.createComputed(function(p3)
			local v8 = getOrCreateSectionConfigSignal(p2).get(p3) -- inferred equivalent call

			if v8 == nil then
				return 0
			end

			if v8.poolId == nil or v8.numberOfRows > 0 then
				return v8.numberOfRows
			end

			local v9 = fn2(p2)(p3)
			return if v9 == nil then 0 else v9.actualRowCount
		end)

		v2[p2] = computed
		return computed
	end

	local function getDisplayedRowCountComputed(p2: string)
		local v7 = v3[p2]

		if v7 ~= nil then
			return v7
		end

		local computed = Signals.createComputed(function(p3)
			local v8 = p2
			local v9 = v2[v8]

			if v9 == nil then
				v9 = Signals.createComputed(function(p4)
					local v10 = getOrCreateSectionConfigSignal(v8).get(p4) -- inferred equivalent call

					if v10 == nil then
						return 0
					end

					if v10.poolId == nil or v10.numberOfRows > 0 then
						return v10.numberOfRows
					end

					local v11 = fn2(v8)(p4)
					return if v11 == nil then 0 else v11.actualRowCount
				end)

				v2[v8] = v9
			end

			local v10 = v9(p3)
			local v11 = fn(p2).get(p3)

			if v11 == nil then
				return v10
			end

			return (math.min(math.max(math.floor(v11), 0), v10))
		end)

		v3[p2] = computed
		return computed
	end

	local function fn3(p2: string)
		local v7 = computeds2[p2]

		if v7 ~= nil then
			return v7
		end

		local computed = Signals.createComputed(function(p3)
			local v8 = getOrCreateSectionConfigSignal(p2).get(p3) -- inferred equivalent call

			if v8 == nil or v8.prevSectionId == nil then
				return 1
			end

			local v9 = fn3(v8.prevSectionId)(p3)
			local v10

			if FFlagSduiSkipFeedAnalyticsPosition then
				v10 = getOrCreateSectionConfigSignal(v8.prevSectionId).get(p3) -- inferred equivalent call
			end

			local v11

			if FFlagSduiSkipFeedAnalyticsPosition and v10 ~= nil and v10.doesNotAdvanceStartRow then
				v11 = 0
			elseif FFlagSduiCollectionGridRevealRows then
				local prevSectionId = v8.prevSectionId
				local v12 = v3[prevSectionId]

				if v12 == nil then
					v12 = Signals.createComputed(function(p4)
						local prevSectionId2 = prevSectionId
						local v13 = v2[prevSectionId2]

						if v13 == nil then
							v13 = Signals.createComputed(function(p5)
								local v14 = getOrCreateSectionConfigSignal(prevSectionId2).get(p5) -- inferred equivalent call

								if v14 == nil then
									return 0
								end

								if v14.poolId == nil or v14.numberOfRows > 0 then
									return v14.numberOfRows
								end

								local v15 = fn2(prevSectionId2)(p5)

								if v15 == nil then
									return 0
								end

								return v15.actualRowCount
							end)

							v2[prevSectionId2] = v13
						end

						local v14 = v13(p4)
						local v15 = fn(prevSectionId).get(p4)

						if v15 == nil then
							return v14
						end

						return (math.min(math.max(math.floor(v15), 0), v14))
					end)

					v3[prevSectionId] = v12
				end

				v11 = v12(p3)
			else
				local prevSectionId = v8.prevSectionId
				local v12 = v2[prevSectionId]

				if v12 == nil then
					v12 = Signals.createComputed(function(p4)
						local v13 = getOrCreateSectionConfigSignal(prevSectionId).get(p4) -- inferred equivalent call

						if v13 == nil then
							return 0
						end

						if v13.poolId == nil or v13.numberOfRows > 0 then
							return v13.numberOfRows
						end

						local v14 = fn2(prevSectionId)(p4)

						if v14 == nil then
							return 0
						end

						return v14.actualRowCount
					end)

					v2[prevSectionId] = v12
				end

				v11 = v12(p3)
			end

			return v9 + v11
		end)

		computeds2[p2] = computed
		return computed
	end

	local sduiPoolStore = {
		getSectionInfo = function(p2: string)
			return Signals.createComputed(function(p3)
				if getOrCreateSectionConfigSignal(p2).get(p3) == nil then -- inferred equivalent call
					return nil
				end

				local v8 = p2
				local v9 = v4[v8]

				if v9 == nil then
					v9 = Signals.createComputed(function(p4)
						local v7 = fn2(v8)(p4)

						if v7 == nil then
							return EMPTY_CELLS
						end

						return v7.cells
					end, cellsEqual)

					v4[v8] = v9
				end

				local v7 = { cells = v9(p3), startRow = fn3(p2)(p3), actualRowCount = 0 }
				local v10 = p2
				local v11 = v2[v10]

				if v11 == nil then
					v11 = Signals.createComputed(function(p4)
						local v12 = getOrCreateSectionConfigSignal(v10).get(p4) -- inferred equivalent call

						if v12 == nil then
							return 0
						end

						if v12.poolId == nil or v12.numberOfRows > 0 then
							return v12.numberOfRows
						end

						local v13 = fn2(v10)(p4)

						if v13 == nil then
							return 0
						end

						return v13.actualRowCount
					end)

					v2[v10] = v11
				end

				v7.actualRowCount = v11(p3)
				return v7
			end)
		end,
		getSectionStartRow = fn3,
		getSectionRowCount = 0,
		getSectionCells = 0,
		setSectionDisplayedRowCount = 0,
		setPools = 0,
		setSections = 0,
		setLayoutStore = 0,
		setOneByTwoTileFunnelListener = 0
	}

	if not FFlagSduiVerticalFeedProgressiveFillOnScroll then
		getRowCountComputed = nil
	end

	sduiPoolStore.getSectionRowCount = getRowCountComputed

	function sduiPoolStore.getSectionCells(p2: string)
		local v7 = v4[p2]

		if v7 ~= nil then
			return v7
		end

		local computed = Signals.createComputed(function(p3)
			local v8 = fn2(p2)(p3)
			return if v8 == nil then EMPTY_CELLS else v8.cells
		end, cellsEqual)

		v4[p2] = computed
		return computed
	end
	sduiPoolStore.setSectionDisplayedRowCount = FFlagSduiCollectionGridRevealRows and function(p2: string, p3: number?)
		fn(p2).set(p3)
	end or nil

	function sduiPoolStore.setPools(items)
		for k, item in items do
			getOrCreatePoolSignal(k).set(item) -- inferred equivalent call
		end
	end

	function sduiPoolStore.setSections(items)
		local prevSectionId = nil
		local sectionIdsByPoolId = {}

		for _, item in items do
			local sectionId = item.sectionId
			local poolId = item.poolId
			local prevSectionInPoolId

			if poolId ~= nil then
				prevSectionInPoolId = sectionIdsByPoolId[poolId]
				sectionIdsByPoolId[poolId] = sectionId
			end

			local set = getOrCreateSectionConfigSignal(sectionId).set -- inferred equivalent call
			local v7 = {
				poolId = poolId,
				numberOfRows = item.numberOfRows,
				doesNotAdvanceStartRow = 0,
				entryCollectionItemSize = 0,
				templateCollectionItemSize = 0,
				prevSectionInPoolId = 0,
				prevSectionId = 0
			}
			local doesNotAdvanceStartRow

			if FFlagSduiSkipFeedAnalyticsPosition then
				doesNotAdvanceStartRow = item.doesNotAdvanceStartRow
			end

			v7.doesNotAdvanceStartRow = doesNotAdvanceStartRow

			v7.entryCollectionItemSize = item.entryCollectionItemSize
			v7.templateCollectionItemSize = item.templateCollectionItemSize
			v7.prevSectionInPoolId = prevSectionInPoolId
			v7.prevSectionId = prevSectionId
			set(v7)
			prevSectionId = sectionId
		end
	end
	function sduiPoolStore.setLayoutStore(p2)
		v5(p2)
	end
	sduiPoolStore.setOneByTwoTileFunnelListener = FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui and function(p2)
		v6 = p2
	end or nil
	return sduiPoolStore
end

local object = setmetatable({}, { __mode = "v" })

return {
	getSduiPoolStore = function(p: string)
		local v = object[p]

		if v ~= nil then
			return v
		end

		local selected

		if FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
			selected = createSduiPoolStore(p)
		else
			selected = createSduiPoolStore()
		end

		object[p] = selected
		return selected
	end
}
