local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local Signals = require(parent.Signals)
require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppRfySignalApportioning = SharedFlags.FFlagLuaAppRfySignalApportioning
local defineFastFlag = game:DefineFastFlag("LuaAppNilApportionedItems", false)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppAddRequestIdToRfySignalApportioning = SharedFlags2.FFlagLuaAppAddRequestIdToRfySignalApportioning

local v = game:DefineFastInt("SduiCreateSduiFeedStoreLogDelayMs", 1000) / 1000

local function createSduiFeedStore()
	local v2 = {}

	local v3 = {}

	local v4 = {}

	local signal, v5 = Signals.createSignal({})
	local signal2, v6 = Signals.createSignal(0)

	local signal3, v7 = Signals.createSignal({})

	local function createItemCollectionSignal(p: string, item) -- 2 equivalent calls inferred from this helper
		local signal4, set = Signals.createSignal(item)
		v2[p] = { get = signal4, set = set }

		return v2[p]
	end

	local function setItemCollections(itemCollections)
		for k, item in itemCollections do
			if v2[k] then
				v2[k].set(item)
			else
				local _itemCollectionSignal = createItemCollectionSignal(k, item) -- inferred equivalent call
			end
		end
	end

	local setApportioningData, updateApportioningCapacity, getSingleGridApportioningMetadata, getApportionedItems

	if FFlagLuaAppRfySignalApportioning then
		local fn = FFlagLuaAppAddRequestIdToRfySignalApportioning and function(p: string, p2: string?)
			if p2 then
				return p .. "_" .. p2
			end

			return p
		end or nil

		local function createApportioningDataSignals(p: string, p2, p3: string?)
			local currentKey2

			if FFlagLuaAppAddRequestIdToRfySignalApportioning then
				currentKey2 = fn(p, p3)
			else
				currentKey2 = p
			end

			local signal4, setItems = Signals.createSignal(p2.items)

			local signal5, setGridApportioningMetadata = Signals.createSignal(p2.gridApportioningMetadata)

			local signal6, set = Signals.createSignal({
				getItems = signal4,
				setItems = setItems,
				getGridApportioningMetadata = signal5,
				setGridApportioningMetadata = setGridApportioningMetadata,
				scheduledCapacityUpdates = {},
				isCapacityUpdateScheduled = false,
				capacityUpdateCoroutine = nil
			})

			v3[currentKey2] = { get = signal6, set = set }

			if FFlagLuaAppAddRequestIdToRfySignalApportioning then
				local previousKey = v4[p] and v4[p].previousKey
				local currentKey = v4[p] and v4[p].currentKey

				if previousKey then
					v3[previousKey] = nil
				end

				v4[p] = { previousKey = currentKey, currentKey = currentKey2 }
			end
		end

		local function fn2(p: string, p2: string?)
			local v8

			if FFlagLuaAppAddRequestIdToRfySignalApportioning then
				v8 = fn(p, p2)
			else
				v8 = p
			end

			if v3[v8] then
				return v3[v8].get
			end

			if not FFlagLuaAppAddRequestIdToRfySignalApportioning then
				p2 = nil
			end

			createApportioningDataSignals(p, { items = {}, gridApportioningMetadata = {} }, p2)

			return v3[v8].get
		end

		setApportioningData = function(items, p: string?)
			for k, item in items do
				local v8

				if FFlagLuaAppAddRequestIdToRfySignalApportioning then
					v8 = fn(k, p)
				else
					v8 = k
				end

				if v3[v8] then
					local v9 = v3[v8].get(false)

					v9.setItems(item.items)
					v9.setGridApportioningMetadata(item.gridApportioningMetadata)
					v9.scheduledCapacityUpdates = {}
					v9.isCapacityUpdateScheduled = false

					if v9.capacityUpdateCoroutine then
						task.cancel(v9.capacityUpdateCoroutine)
						v9.capacityUpdateCoroutine = nil
					end
				else
					local v9

					if FFlagLuaAppAddRequestIdToRfySignalApportioning then
						v9 = p
					end

					createApportioningDataSignals(k, item, v9)
				end
			end
		end

		local function updateGridApportioningMetadata(apportioningKey: string, p: string?)
			local v8

			if FFlagLuaAppAddRequestIdToRfySignalApportioning then
				v8 = p
			end

			local v9 = fn2(apportioningKey, v8)(false)

			local gridApportioningMetadata = v9.getGridApportioningMetadata(false)
			local scheduledCapacityUpdates = v9.scheduledCapacityUpdates

			if #gridApportioningMetadata == 0 then
				if FFlagLuaAppAddRequestIdToRfySignalApportioning then
					apportioningKey = fn(apportioningKey, p)
				end

				task.delay(v, function()
					local v10 = v3[apportioningKey].get(false)

					if #(v10 and v10.getGridApportioningMetadata(false) or {}) == 0 then
						DiscoveryEventErrorLogger.reportError(
							"ApportioningEmptyGridMetadata",
							`Apportioning grid metadata is empty for {apportioningKey} in updateGridApportioningMetadata`,
							{ apportioningKey = apportioningKey }
						)
					end
				end)
			else
				local total = 1
				local v10 = {}

				for _, v11 in gridApportioningMetadata do
					local capacity

					if scheduledCapacityUpdates[v11.sortIndex] then
						capacity = scheduledCapacityUpdates[v11.sortIndex]
					else
						capacity = v11.capacity
					end

					table.insert(v10, {
						sortIndex = v11.sortIndex,
						startingItemIndex = total,
						capacity = capacity
					})

					total += capacity
				end

				v9.setGridApportioningMetadata(v10)
			end
		end

		updateApportioningCapacity = function(p: string, p2: number, p3: number, p4: string?)
			local v8

			if FFlagLuaAppAddRequestIdToRfySignalApportioning then
				v8 = p4
			end

			local v9 = fn2(p, v8)(false)

			v9.scheduledCapacityUpdates[p2] = p3

			if not v9.isCapacityUpdateScheduled then
				v9.isCapacityUpdateScheduled = true
				v9.capacityUpdateCoroutine = task.defer(function()
					local v10

					if FFlagLuaAppAddRequestIdToRfySignalApportioning then
						v10 = p4
					end

					updateGridApportioningMetadata(p, v10)

					v9.scheduledCapacityUpdates = {}
					v9.isCapacityUpdateScheduled = false
					v9.capacityUpdateCoroutine = nil
				end)
			end
		end

		getSingleGridApportioningMetadata = function(p: string, sortIndex: number, p2: string?)
			return Signals.createComputed(function(p3)
				local v8

				if FFlagLuaAppAddRequestIdToRfySignalApportioning then
					v8 = p2
				end

				local gridApportioningMetadata = fn2(p, v8)(p3).getGridApportioningMetadata(p3)

				if #gridApportioningMetadata == 0 then
					task.delay(v, function()
						local apportioningKey

						if FFlagLuaAppAddRequestIdToRfySignalApportioning then
							apportioningKey = fn(p, p2)
						else
							apportioningKey = p
						end

						local v9 = v3[apportioningKey].get(false)

						if #(v9 and v9.getGridApportioningMetadata(false) or {}) == 0 then
							DiscoveryEventErrorLogger.reportError(
								"ApportioningEmptyGridMetadata",
								`Apportioning grid metadata is empty for {apportioningKey} in getSingleGridApportioningMetadata`,
								{ apportioningKey = apportioningKey, sortIndex = sortIndex }
							)
						end
					end)

					return nil
				end

				for _, v9 in gridApportioningMetadata do
					if v9.sortIndex == sortIndex then
						return v9
					end
				end

				return nil
			end)
		end

		getApportionedItems = function(p: string, sortIndex: number, p2: string?)
			return Signals.createComputed(function(p3)
				local v8

				if FFlagLuaAppAddRequestIdToRfySignalApportioning then
					v8 = p2
				end

				local v9 = fn2(p, v8)(p3)

				local items = v9.getItems(p3)
				local v10 = getSingleGridApportioningMetadata
				local v11

				if FFlagLuaAppAddRequestIdToRfySignalApportioning then
					v11 = p2
				end

				local v12 = v10(p, sortIndex, v11)(p3)

				if #items == 0 and #v9.getGridApportioningMetadata(false) == 0 then
					local apportioningKey

					if FFlagLuaAppAddRequestIdToRfySignalApportioning then
						apportioningKey = fn(p, p2)
					else
						apportioningKey = p
					end

					task.delay(v, function()
						local v13 = v3[apportioningKey].get(false)
						local v14 = v13 and v13.getItems(false) or {}

						local v15 = v13 and v13.getGridApportioningMetadata(false) or {}

						if #v14 == 0 and #v15 == 0 then
							DiscoveryEventErrorLogger.reportError(
								"ApportioningEmptyData",
								`All apportioning data is empty for {apportioningKey} in getApportionedItems`,
								{ apportioningKey = apportioningKey, sortIndex = sortIndex }
							)
						end
					end)

					if defineFastFlag then
						return nil
					end

					return {}
				elseif v12 then
					local startingItemIndex = v12.startingItemIndex

					local result = {}

					for i = startingItemIndex, math.min(startingItemIndex + v12.capacity - 1, #items) do
						table.insert(result, items[i])
					end

					return result
				else
					local availableSortIndices = nil

					task.delay(v, function()
						local apportioningKey

						if FFlagLuaAppAddRequestIdToRfySignalApportioning then
							apportioningKey = fn(p, p2)
						else
							apportioningKey = p
						end

						local v13 = getSingleGridApportioningMetadata
						local v14

						if FFlagLuaAppAddRequestIdToRfySignalApportioning then
							v14 = p2
						end

						if not v13(p, sortIndex, v14)(false) then
							local v15 = v3[apportioningKey].get(false)

							local sortIndexes = {}

							for _, v16 in v15 and v15.getGridApportioningMetadata(false) or {} do
								table.insert(sortIndexes, v16.sortIndex)
							end

							availableSortIndices = not (#sortIndexes > 0) and "none" or table.concat(sortIndexes, ",")

							DiscoveryEventErrorLogger.reportError(
								"ApportioningSortIndexNotFound",
								`Sort index {sortIndex} not found in apportioning data for {apportioningKey}`,
								{
									apportioningKey = apportioningKey,
									sortIndex = sortIndex,
									availableSortIndices = availableSortIndices
								}
							)
						end
					end)
					return {}
				end
			end)
		end
	else
		setApportioningData = nil
		getSingleGridApportioningMetadata = nil
	end

	if not FFlagLuaAppRfySignalApportioning then
		updateApportioningCapacity = nil
	end

	local getSingleGridApportioningMetadata2

	if FFlagLuaAppRfySignalApportioning then
		getSingleGridApportioningMetadata2 = getSingleGridApportioningMetadata
	end

	if not FFlagLuaAppRfySignalApportioning then
		getApportionedItems = nil
	end

	return {
		getFirstItemCollectionWithFilter = function(callback)
			for _, v8 in v2 do
				if callback(v8.get(false)) then
					return v8.get
				end
			end

			return nil
		end,
		getItemCollection = function(p: string, flag: boolean?)
			local v8 = v2[p]

			if v8 == nil then
				if flag then
					v8 = createItemCollectionSignal(p) -- inferred equivalent call
				else
					error(`createSduiFeedStore missing item collection for feedItemKey {p}`)
				end
			end

			return v8.get
		end,
		getTemplates = signal,
		getDataUpdatedTimestamp = signal2,
		getItemCollectionKeys = signal3,
		updateApportioningCapacity = updateApportioningCapacity,
		getSingleGridApportioningMetadata = getSingleGridApportioningMetadata2,
		getApportionedItems = getApportionedItems,
		updateData = function(data, p: string?)
			if data.templates then
				v5(data.templates)
			end

			if data.dataUpdatedTimestamp then
				v6(data.dataUpdatedTimestamp)
			end

			if data.itemCollections then
				setItemCollections(data.itemCollections)
				local v8 = {}

				for k in data.itemCollections do
					table.insert(v8, k)
				end

				v7(v8)
			end

			if FFlagLuaAppRfySignalApportioning and data.apportioningData then
				local apportioningData = data.apportioningData

				if not FFlagLuaAppAddRequestIdToRfySignalApportioning then
					p = nil
				end

				setApportioningData(apportioningData, p)
			end
		end
	}
end

return createSduiFeedStore
