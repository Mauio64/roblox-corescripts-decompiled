local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/CollectionViews")

local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiPoolStoreTypes")
local SduiPoolStoreLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiPoolStoreLayout")

local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore
local processOneGrid = CollectionViews.processOneGrid
local makePoolGetSpanConfig = SduiPoolStoreLayout.makePoolGetSpanConfig
local layoutToCells = SduiPoolStoreLayout.layoutToCells
local cellsEqual = SduiPoolStoreLayout.cellsEqual
local EMPTY_CELLS = SduiPoolStoreLayout.EMPTY_CELLS

local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning
local fFlagSduiCollectionGridRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiCollectionGridRevealRows
local fFlagSduiSkipFeedAnalyticsPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiSkipFeedAnalyticsPosition
local fFlagSduiPerSectionPoolSizing = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiPerSectionPoolSizing

local fFlagSduiVerticalFeedProgressiveFillOnScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiVerticalFeedProgressiveFillOnScroll

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui

local frozen = table.freeze({})

local function logSkipped(data, p2, p3)
	local onSkipped = p2 and p2.onSkipped
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
				p3
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

	local v5

	if data.poolId == data2.poolId and data.numberOfRows == data2.numberOfRows then
		v5 = (not fFlagSduiSkipFeedAnalyticsPosition or data.doesNotAdvanceStartRow == data2.doesNotAdvanceStartRow)
			and (not fFlagSduiPerSectionPoolSizing or data.entryCollectionItemSize == data2.entryCollectionItemSize)
			and (not fFlagSduiPerSectionPoolSizing or data.templateCollectionItemSize == data2.templateCollectionItemSize)

		if v5 then
			if data.prevSectionInPoolId == data2.prevSectionInPoolId then
				v5 = data.prevSectionId == data2.prevSectionId
			else
				v5 = false
			end
		end
	else
		v5 = false
	end

	return v5
end

local function getSectionCollectionItemSize(p2, p3, p4)
	local collectionItemSize = p3.collectionItemSize

	if typeof(collectionItemSize) == "string" and p2.getItemsPerRow[collectionItemSize] ~= nil then
		return collectionItemSize
	end

	local entryCollectionItemSize = p4.entryCollectionItemSize

	if
		typeof(entryCollectionItemSize) == "string"
		and p2.getItemsPerRow[entryCollectionItemSize] ~= nil
	then
		return entryCollectionItemSize
	end

	local templateCollectionItemSize = p4.templateCollectionItemSize

	if
		typeof(templateCollectionItemSize) == "string"
		and p2.getItemsPerRow[templateCollectionItemSize] ~= nil
	then
		return templateCollectionItemSize
	end

	return "Medium"
end

local function createSduiPoolStore(p2)
	local v5 = {}
	local v6 = {}

	local v7 = fFlagSduiCollectionGridRevealRows and {} or nil

	local computeds = {}
	local v8 = {}

	local v9 = fFlagSduiCollectionGridRevealRows and {} or nil

	local computeds2 = {}
	local v10 = {}

	local signal, v11 = Signals.createSignal(nil)
	local v12 = nil

	local function getOrCreatePoolSignal(p3)
		local poolSignal = v5[p3]

		if poolSignal == nil then
			local signal2, v13 = Signals.createSignal(nil)
			poolSignal = { get = signal2, set = v13 }
			v5[p3] = poolSignal
		end

		return poolSignal
	end

	local function getOrCreateSectionConfigSignal(p3)
		local sectionConfigSignal = v6[p3]

		if sectionConfigSignal == nil then
			local signal2, v13 = Signals.createSignal(nil, sectionConfigsEqual)
			sectionConfigSignal = { get = signal2, set = v13 }
			v6[p3] = sectionConfigSignal
		end

		return sectionConfigSignal
	end

	local fn = fFlagSduiCollectionGridRevealRows and function(p3)
		local v13 = v7[p3]

		if v13 == nil then
			local signal2, v14 = Signals.createSignal(nil)
			v13 = { get = signal2, set = v14 }
			v7[p3] = v13
		end

		return v13
	end or nil
	local function fn2(p3)
		local v13 = computeds[p3]

		if v13 ~= nil then
			return v13
		end

		local computed = Signals.createComputed(function(p4)
			local v14 = p3
			local v15 = v6[v14]

			if v15 == nil then
				local signal2, v16 = Signals.createSignal(nil, sectionConfigsEqual)
				v15 = { get = signal2, set = v16 }
				v6[v14] = v15
			end

			local v16 = v15.get(p4)

			if v16 == nil or v16.poolId == nil then
				return nil
			end

			local poolId = v16.poolId
			local v17 = v5[poolId]

			if v17 == nil then
				local signal2, v18 = Signals.createSignal(nil)
				v17 = { get = signal2, set = v18 }
				v5[poolId] = v17
			end

			local v18 = v17.get(p4)

			if v18 == nil or #v18.items == 0 then
				return nil
			end

			local v19 = signal(p4) or getMainCollectionLayoutStore(p4)
			local v20

			if fFlagSduiPerSectionPoolSizing then
				v20 = v18.collectionItemSize

				if typeof(v20) ~= "string" or v19.getItemsPerRow[v20] == nil then
					v20 = v16.entryCollectionItemSize

					if typeof(v20) ~= "string" or v19.getItemsPerRow[v20] == nil then
						local templateCollectionItemSize = v16.templateCollectionItemSize

						v20 = (typeof(templateCollectionItemSize) ~= "string" or v19.getItemsPerRow[templateCollectionItemSize] == nil)
							and "Medium"
							or templateCollectionItemSize
					end
				end
			else
				v20 = (typeof(v18.collectionItemSize) ~= "string" or v19.getItemsPerRow[v18.collectionItemSize] == nil)
					and "Medium"
					or v18.collectionItemSize
			end

			local v21 = v19.getItemsPerRow[v20](p4)

			if v21 <= 0 then
				return nil
			end

			local v22 = frozen
			local v23

			if v16.prevSectionInPoolId == nil then
				v23 = 1
			else
				local v24 = fn2(v16.prevSectionInPoolId)(p4)

				if v24 == nil then
					return nil
				end

				v23 = v24.nextStartIndex
				v22 = v24.pendingSpanTiles
			end

			local numberOfRows = v16.numberOfRows
			local v24 = numberOfRows <= 0 and 1e999 or numberOfRows

			if v18.layouts == nil and #v22 == 0 then
				local v25 = math.max(0, #v18.items - v23 + 1)
				local v26 = if v24 == 1e999 then v25 else v24 * v21
				local v27 = math.min(v26, v25)

				if v27 == 0 then
					return {
						cells = EMPTY_CELLS,
						actualRowCount = 0,
						nextStartIndex = v23,
						pendingSpanTiles = frozen
					}
				end

				local v28 = math.ceil(v27 / v21)
				local v29 = {}

				for i = 0, v27 - 1 do
					local v30 = v23 + i
					v29[i + 1] = { item = v18.items[v30], realIndex = v30 }
				end

				for i = v27 + 1, v28 * v21 do
					v29[i] = {}
				end

				return {
					cells = v29,
					actualRowCount = v28,
					nextStartIndex = v23 + v27,
					pendingSpanTiles = frozen
				}
			else
				local v25 = if v18.layouts ~= nil then makePoolGetSpanConfig(v18.layouts) else nil
				local v26 = processOneGrid(
					v18.items,
					v23,
					v22,
					v21,
					v24,
					v25,
					not fFlagLuaAppEnableNxMRoduxApportioning
				)

				local v27, v28 = layoutToCells(v26.layout, v21, v18.items, v18.layouts)

				if fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
					local onPlaced = v12 and v12.onPlaced

					for k, v29 in v27 do
						local item = v29.item
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
								gridRow = math.ceil(k / v21),
								gridCol = (k - 1) % v21 + 1,
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
								p2
							)
						end
					end

					local v29 = false

					for k, v31 in v6 do
						if k == p3 then
							continue
						end

						local v32 = v31.get(false)

						if v32 and v32.prevSectionInPoolId == p3 then
							v29 = true
							break
						end
					end

					if not v29 then
						for k, pendingSpanTile in v26.pendingSpanTiles do
							logSkipped(v18.items[pendingSpanTile.index], v12, p2)
						end

						local oneByTwoTileFlowIdSet = {}

						for k, v31 in v27 do
							local item = v31.item
							local oneByTwoTileFlowId = item and item.oneByTwoTileFlowId

							if typeof(oneByTwoTileFlowId) == "string" then
								oneByTwoTileFlowIdSet[oneByTwoTileFlowId] = true
							end
						end

						for i = v26.nextStartIndex, #v18.items do
							local item = v18.items[i]
							local oneByTwoTileFlowId = item and item.oneByTwoTileFlowId

							if
								typeof(oneByTwoTileFlowId) ~= "string"
								or oneByTwoTileFlowIdSet[oneByTwoTileFlowId]
							then
								continue
							end

							logSkipped(item, v12, p2)
						end
					end
				end

				return {
					cells = v27,
					actualRowCount = v28,
					nextStartIndex = v26.nextStartIndex,
					pendingSpanTiles = v26.pendingSpanTiles
				}
			end
		end)

		computeds[p3] = computed
		return computed
	end

	local function getRowCountComputed(p3)
		local v13 = v8[p3]

		if v13 ~= nil then
			return v13
		end

		local computed = Signals.createComputed(function(p4)
			local v14 = p3
			local v15 = v6[v14]

			if v15 == nil then
				local signal2, v16 = Signals.createSignal(nil, sectionConfigsEqual)
				v15 = { get = signal2, set = v16 }
				v6[v14] = v15
			end

			local v16 = v15.get(p4)

			if v16 == nil then
				return 0
			end

			if v16.poolId == nil or v16.numberOfRows > 0 then
				return v16.numberOfRows
			end

			local v17 = fn2(p3)(p4)

			if v17 == nil then
				return 0
			end

			return v17.actualRowCount
		end)

		v8[p3] = computed
		return computed
	end

	local function getDisplayedRowCountComputed(p3)
		local v13 = v9[p3]

		if v13 ~= nil then
			return v13
		end

		local computed = Signals.createComputed(function(p4)
			local v14 = p3
			local v15 = v8[v14]

			if v15 == nil then
				v15 = Signals.createComputed(function(p5)
					local v16 = v14
					local v17 = v6[v16]

					if v17 == nil then
						local signal2, v18 = Signals.createSignal(nil, sectionConfigsEqual)
						v17 = { get = signal2, set = v18 }
						v6[v16] = v17
					end

					local v18 = v17.get(p5)

					if v18 == nil then
						return 0
					end

					if v18.poolId == nil or v18.numberOfRows > 0 then
						return v18.numberOfRows
					end

					local v19 = fn2(v14)(p5)

					if v19 == nil then
						return 0
					end

					return v19.actualRowCount
				end)

				v8[v14] = v15
			end

			local v16 = v15(p4)
			local v17 = fn(p3).get(p4)

			if v17 == nil then
				return v16
			end

			return (math.min(math.max(math.floor(v17), 0), v16))
		end)

		v9[p3] = computed
		return computed
	end

	local function fn3(p3)
		local v13 = computeds2[p3]

		if v13 ~= nil then
			return v13
		end

		local computed = Signals.createComputed(function(p4)
			local v14 = p3
			local v15 = v6[v14]

			if v15 == nil then
				local signal2, v16 = Signals.createSignal(nil, sectionConfigsEqual)
				v15 = { get = signal2, set = v16 }
				v6[v14] = v15
			end

			local v16 = v15.get(p4)

			if v16 == nil or v16.prevSectionId == nil then
				return 1
			end

			local v17 = fn3(v16.prevSectionId)(p4)
			local v18

			if fFlagSduiSkipFeedAnalyticsPosition then
				local prevSectionId = v16.prevSectionId
				local v19 = v6[prevSectionId]

				if v19 == nil then
					local signal2, v20 = Signals.createSignal(nil, sectionConfigsEqual)
					v19 = { get = signal2, set = v20 }
					v6[prevSectionId] = v19
				end

				v18 = v19.get(p4)
			end

			local v19

			if fFlagSduiSkipFeedAnalyticsPosition and v18 ~= nil and v18.doesNotAdvanceStartRow then
				v19 = 0
			elseif fFlagSduiCollectionGridRevealRows then
				local prevSectionId = v16.prevSectionId
				local v20 = v9[prevSectionId]

				if v20 == nil then
					v20 = Signals.createComputed(function(p5)
						local v21 = prevSectionId
						local v22 = v8[v21]

						if v22 == nil then
							v22 = Signals.createComputed(function(p6)
								local v23 = v21
								local v24 = v6[v23]

								if v24 == nil then
									local signal2, v25 = Signals.createSignal(nil, sectionConfigsEqual)
									v24 = { get = signal2, set = v25 }
									v6[v23] = v24
								end

								local v25 = v24.get(p6)

								if v25 == nil then
									return 0
								end

								if v25.poolId == nil or v25.numberOfRows > 0 then
									return v25.numberOfRows
								end

								local v26 = fn2(v21)(p6)

								if v26 == nil then
									return 0
								end

								return v26.actualRowCount
							end)

							v8[v21] = v22
						end

						local v23 = v22(p5)
						local v24 = fn(prevSectionId).get(p5)

						if v24 == nil then
							return v23
						end

						return (math.min(math.max(math.floor(v24), 0), v23))
					end)

					v9[prevSectionId] = v20
				end

				v19 = v20(p4)
			else
				local prevSectionId = v16.prevSectionId
				local v20 = v8[prevSectionId]

				if v20 == nil then
					v20 = Signals.createComputed(function(p5)
						local v21 = prevSectionId
						local v22 = v6[v21]

						if v22 == nil then
							local signal2, v23 = Signals.createSignal(nil, sectionConfigsEqual)
							v22 = { get = signal2, set = v23 }
							v6[v21] = v22
						end

						local v23 = v22.get(p5)

						if v23 == nil then
							return 0
						end

						if v23.poolId == nil or v23.numberOfRows > 0 then
							return v23.numberOfRows
						end

						local v24 = fn2(prevSectionId)(p5)

						if v24 == nil then
							return 0
						end

						return v24.actualRowCount
					end)

					v8[prevSectionId] = v20
				end

				v19 = v20(p4)
			end

			return v17 + v19
		end)

		computeds2[p3] = computed
		return computed
	end

	local sduiPoolStore = {
		getSectionInfo = function(p3)
			return Signals.createComputed(function(p4)
				local v13 = p3
				local v14 = v6[v13]

				if v14 == nil then
					local signal2, v15 = Signals.createSignal(nil, sectionConfigsEqual)
					v14 = { get = signal2, set = v15 }
					v6[v13] = v14
				end

				if v14.get(p4) == nil then
					return nil
				end

				local v16 = p3
				local v17 = v10[v16]

				if v17 == nil then
					v17 = Signals.createComputed(function(p5)
						local v18 = fn2(v16)(p5)

						if v18 == nil then
							return EMPTY_CELLS
						end

						return v18.cells
					end, cellsEqual)

					v10[v16] = v17
				end

				local v15 = {
					cells = v17(p4),
					startRow = fn3(p3)(p4),
					actualRowCount = 0
				}
				local v18 = p3
				local v19 = v8[v18]

				if v19 == nil then
					v19 = Signals.createComputed(function(p5)
						local v20 = v18
						local v21 = v6[v20]

						if v21 == nil then
							local signal2, v22 = Signals.createSignal(nil, sectionConfigsEqual)
							v21 = { get = signal2, set = v22 }
							v6[v20] = v21
						end

						local v22 = v21.get(p5)

						if v22 == nil then
							return 0
						end

						if v22.poolId == nil or v22.numberOfRows > 0 then
							return v22.numberOfRows
						end

						local v23 = fn2(v18)(p5)

						if v23 == nil then
							return 0
						end

						return v23.actualRowCount
					end)

					v8[v18] = v19
				end

				v15.actualRowCount = v19(p4)
				return v15
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

	if not fFlagSduiVerticalFeedProgressiveFillOnScroll then
		getRowCountComputed = nil
	end

	sduiPoolStore.getSectionRowCount = getRowCountComputed

	function sduiPoolStore.getSectionCells(p3)
		local v13 = v10[p3]

		if v13 ~= nil then
			return v13
		end

		local computed = Signals.createComputed(function(p4)
			local v14 = fn2(p3)(p4)

			if v14 == nil then
				return EMPTY_CELLS
			end

			return v14.cells
		end, cellsEqual)

		v10[p3] = computed
		return computed
	end
	sduiPoolStore.setSectionDisplayedRowCount = fFlagSduiCollectionGridRevealRows and function(p3, p4)
		fn(p3).set(p4)
	end or nil

	function sduiPoolStore.setPools(items)
		for k, item in items do
			local v13 = v5[k]

			if v13 == nil then
				local signal2, v14 = Signals.createSignal(nil)
				v13 = { get = signal2, set = v14 }
				v5[k] = v13
			end

			v13.set(item)
		end
	end

	function sduiPoolStore.setSections(items)
		local v13 = nil
		local sectionIdsByPoolId = {}

		for k, item in items do
			local sectionId = item.sectionId
			local poolId = item.poolId
			local v14

			if poolId ~= nil then
				v14 = sectionIdsByPoolId[poolId]
				sectionIdsByPoolId[poolId] = sectionId
			end

			local v15 = v6[sectionId]

			if v15 == nil then
				local signal2, v16 = Signals.createSignal(nil, sectionConfigsEqual)
				v15 = { get = signal2, set = v16 }
				v6[sectionId] = v15
			end

			local set = v15.set
			local v16 = {
				poolId = poolId,
				numberOfRows = item.numberOfRows,
				doesNotAdvanceStartRow = 0,
				entryCollectionItemSize = 0,
				templateCollectionItemSize = 0,
				prevSectionInPoolId = 0,
				prevSectionId = 0
			}

			local v17 = if fFlagSduiSkipFeedAnalyticsPosition then item.doesNotAdvanceStartRow else nil
			v16.doesNotAdvanceStartRow = v17

			v16.entryCollectionItemSize = item.entryCollectionItemSize
			v16.templateCollectionItemSize = item.templateCollectionItemSize
			v16.prevSectionInPoolId = v14
			v16.prevSectionId = v13
			set(v16)
			v13 = sectionId
		end
	end
	function sduiPoolStore.setLayoutStore(p3)
		v11(p3)
	end
	sduiPoolStore.setOneByTwoTileFunnelListener = fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui
		and function(p3)
			v12 = p3
		end
		or nil
	return sduiPoolStore
end

local object = setmetatable({}, { __mode = "v" })

return {
	getSduiPoolStore = function(p2)
		local v5 = object[p2]

		if v5 ~= nil then
			return v5
		end

		local v6

		if fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
			v6 = createSduiPoolStore(p2)
		else
			v6 = createSduiPoolStore()
		end

		object[p2] = v6
		return v6
	end
}
