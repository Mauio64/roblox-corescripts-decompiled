local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/SduiFeedStoreTypes")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryUtils").DiscoveryEventErrorLogger
local fFlagLuaAppRfySignalApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppRfySignalApportioning
local defineFastFlag = game:DefineFastFlag("LuaAppNilApportionedItems", false)

local fFlagLuaAppAddRequestIdToRfySignalApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppAddRequestIdToRfySignalApportioning

local v5 = game:DefineFastInt("SduiCreateSduiFeedStoreLogDelayMs", 1000) / 1000

local function createSduiFeedStore()
	local v6 = {}

	local v7 = {}

	local v8 = {}

	local signal, v9 = Signals.createSignal({})
	local signal2, v10 = Signals.createSignal(0)

	local signal3, v11 = Signals.createSignal({})

	local function createItemCollectionSignal(p2, p3)
		local signal4, v13 = Signals.createSignal(p3)
		v6[p2] = { get = signal4, set = v13 }

		return v6[p2]
	end

	local function getItemCollection(p2, p3)
		local v13 = v6[p2]

		if v13 ~= nil then
			return v13.get
		end

		if p3 then
			local signal4, v14 = Signals.createSignal(nil)
			v6[p2] = { get = signal4, set = v14 }

			v13 = v6[p2]
		else
			error(`createSduiFeedStore missing item collection for feedItemKey {p2}`)
		end

		return v13.get
	end

	local function getFirstItemCollectionWithFilter(callback)
		for k, v13 in v6 do
			if callback(v13.get(false)) then
				return v13.get
			end
		end

		return nil
	end

	local function setItemCollections(itemCollections)
		for k, item in itemCollections do
			if v6[k] then
				v6[k].set(item)
			else
				local signal4, v13 = Signals.createSignal(item)
				v6[k] = { get = signal4, set = v13 }

				local v14 = v6[k]
			end
		end
	end

	local setApportioningData, updateApportioningCapacity, getSingleGridApportioningMetadata, getApportionedItems

	if fFlagLuaAppRfySignalApportioning then
		local fn = fFlagLuaAppAddRequestIdToRfySignalApportioning and function(p2, p3)
			if p3 then
				return p2 .. "_" .. p3
			end

			return p2
		end or nil

		local function createApportioningDataSignals(p2, p3, p4)
			local v13 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then fn(p2, p4) else p2

			local signal4, v14 = Signals.createSignal(p3.items)

			local signal5, v15 = Signals.createSignal(p3.gridApportioningMetadata)

			local signal6, v16 = Signals.createSignal({
				getItems = signal4,
				setItems = v14,
				getGridApportioningMetadata = signal5,
				setGridApportioningMetadata = v15,
				scheduledCapacityUpdates = {},
				isCapacityUpdateScheduled = false,
				capacityUpdateCoroutine = nil
			})

			v7[v13] = { get = signal6, set = v16 }

			if fFlagLuaAppAddRequestIdToRfySignalApportioning then
				local previousKey = v8[p2] and v8[p2].previousKey
				local currentKey = v8[p2] and v8[p2].currentKey

				if previousKey then
					v7[previousKey] = nil
				end

				v8[p2] = { previousKey = currentKey, currentKey = v13 }
			end
		end

		local function fn2(p2, p3)
			local v13 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then fn(p2, p3) else p2

			if v7[v13] then
				return v7[v13].get
			end

			if not fFlagLuaAppAddRequestIdToRfySignalApportioning then
				p3 = nil
			end

			createApportioningDataSignals(p2, {
				items = {},
				gridApportioningMetadata = {}
			}, p3)

			return v7[v13].get
		end

		setApportioningData = function(items, p2)
			for k, item in items do
				local v13 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then fn(k, p2) else k

				if v7[v13] then
					local v14 = v7[v13].get(false)

					v14.setItems(item.items)
					v14.setGridApportioningMetadata(item.gridApportioningMetadata)
					v14.scheduledCapacityUpdates = {}
					v14.isCapacityUpdateScheduled = false

					if v14.capacityUpdateCoroutine then
						task.cancel(v14.capacityUpdateCoroutine)
						v14.capacityUpdateCoroutine = nil
					end
				else
					createApportioningDataSignals(
						k,
						item,
						if fFlagLuaAppAddRequestIdToRfySignalApportioning then p2 else nil
					)
				end
			end
		end

		local function updateGridApportioningMetadata(p2, p3)
			local v14 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then p3 else nil
			local v15 = fn2(p2, v14)(false)

			local gridApportioningMetadata = v15.getGridApportioningMetadata(false)
			local scheduledCapacityUpdates = v15.scheduledCapacityUpdates

			if #gridApportioningMetadata == 0 then
				if fFlagLuaAppAddRequestIdToRfySignalApportioning then
					p2 = fn(p2, p3)
				end

				task.delay(v5, function()
					local v16 = v7[p2].get(false)

					if #(v16 and v16.getGridApportioningMetadata(false) or {}) == 0 then
						discoveryEventErrorLogger.reportError(
							"ApportioningEmptyGridMetadata",
							`Apportioning grid metadata is empty for {p2} in updateGridApportioningMetadata`,
							{ apportioningKey = p2 }
						)
					end
				end)
			else
				local total = 1
				local v16 = {}

				for k, v17 in gridApportioningMetadata do
					local v18

					if scheduledCapacityUpdates[v17.sortIndex] then
						v18 = scheduledCapacityUpdates[v17.sortIndex]
					else
						v18 = v17.capacity
					end

					table.insert(v16, {
						sortIndex = v17.sortIndex,
						startingItemIndex = total,
						capacity = v18
					})

					total += v18
				end

				v15.setGridApportioningMetadata(v16)
			end
		end

		updateApportioningCapacity = function(p2, p3, p4, p5)
			local v14 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then p5 else nil
			local v15 = fn2(p2, v14)(false)

			v15.scheduledCapacityUpdates[p3] = p4

			if not v15.isCapacityUpdateScheduled then
				v15.isCapacityUpdateScheduled = true
				v15.capacityUpdateCoroutine = task.defer(function()
					updateGridApportioningMetadata(
						p2,
						if fFlagLuaAppAddRequestIdToRfySignalApportioning then p5 else nil
					)

					v15.scheduledCapacityUpdates = {}
					v15.isCapacityUpdateScheduled = false
					v15.capacityUpdateCoroutine = nil
				end)
			end
		end

		getSingleGridApportioningMetadata = function(p2, p3, p4)
			return Signals.createComputed(function(p5)
				local v15 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then p4 else nil
				local gridApportioningMetadata = fn2(p2, v15)(p5).getGridApportioningMetadata(p5)

				if #gridApportioningMetadata == 0 then
					task.delay(v5, function()
						local v16 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then fn(p2, p4) else p2

						local v17 = v7[v16].get(false)

						if #(v17 and v17.getGridApportioningMetadata(false) or {}) == 0 then
							discoveryEventErrorLogger.reportError(
								"ApportioningEmptyGridMetadata",
								`Apportioning grid metadata is empty for {v16} in getSingleGridApportioningMetadata`,
								{ apportioningKey = v16, sortIndex = p3 }
							)
						end
					end)

					return nil
				end

				for k, v16 in gridApportioningMetadata do
					if v16.sortIndex == p3 then
						return v16
					end
				end

				return nil
			end)
		end

		getApportionedItems = function(p2, p3, p4)
			return Signals.createComputed(function(p5)
				local v15 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then p4 else nil
				local v16 = fn2(p2, v15)(p5)

				local items = v16.getItems(p5)
				local v17 = getSingleGridApportioningMetadata
				local v20 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then p4 else nil
				local v21 = v17(p2, p3, v20)(p5)

				if #items == 0 and #v16.getGridApportioningMetadata(false) == 0 then
					local v22 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then fn(p2, p4) else p2

					task.delay(v5, function()
						local v23 = v7[v22].get(false)
						local v24 = v23 and v23.getItems(false) or {}

						local v25 = v23 and v23.getGridApportioningMetadata(false) or {}

						if #v24 == 0 and #v25 == 0 then
							discoveryEventErrorLogger.reportError(
								"ApportioningEmptyData",
								`All apportioning data is empty for {v22} in getApportionedItems`,
								{ apportioningKey = v22, sortIndex = p3 }
							)
						end
					end)

					if defineFastFlag then
						return nil
					end

					return {}
				elseif v21 then
					local startingItemIndex = v21.startingItemIndex

					local result = {}

					for i = startingItemIndex, math.min(startingItemIndex + v21.capacity - 1, #items) do
						table.insert(result, items[i])
					end

					return result
				else
					local v22 = nil

					task.delay(v5, function()
						local v23 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then fn(p2, p4) else p2

						local v24 = getSingleGridApportioningMetadata
						local v27 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then p4 else nil

						if not v24(p2, p3, v27)(false) then
							local v28 = v7[v23].get(false)

							local sortIndexes = {}

							for k, v29 in v28 and v28.getGridApportioningMetadata(false) or {} do
								table.insert(sortIndexes, v29.sortIndex)
							end

							v22 = not (#sortIndexes > 0) and "none" or table.concat(sortIndexes, ",")

							discoveryEventErrorLogger.reportError(
								"ApportioningSortIndexNotFound",
								`Sort index {p3} not found in apportioning data for {v23}`,
								{
									apportioningKey = v23,
									sortIndex = p3,
									availableSortIndices = v22
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

	if not fFlagLuaAppRfySignalApportioning then
		updateApportioningCapacity = nil
	end

	local sduiFeedStore = {
		getFirstItemCollectionWithFilter = getFirstItemCollectionWithFilter,
		getItemCollection = getItemCollection,
		getTemplates = signal,
		getDataUpdatedTimestamp = signal2,
		getItemCollectionKeys = signal3,
		updateApportioningCapacity = updateApportioningCapacity,
		getSingleGridApportioningMetadata = if fFlagLuaAppRfySignalApportioning then getSingleGridApportioningMetadata else nil,
		getApportionedItems = nil,
		updateData = nil
	}

	if not fFlagLuaAppRfySignalApportioning then
		getApportionedItems = nil
	end

	sduiFeedStore.getApportionedItems = getApportionedItems

	function sduiFeedStore.updateData(data, p2)
		if data.templates then
			v9(data.templates)
		end

		if data.dataUpdatedTimestamp then
			v10(data.dataUpdatedTimestamp)
		end

		if data.itemCollections then
			setItemCollections(data.itemCollections)
			local v13 = {}

			for k in data.itemCollections do
				table.insert(v13, k)
			end

			v11(v13)
		end

		if fFlagLuaAppRfySignalApportioning and data.apportioningData then
			local apportioningData = data.apportioningData

			if not fFlagLuaAppAddRequestIdToRfySignalApportioning then
				p2 = nil
			end

			setApportioningData(apportioningData, p2)
		end
	end
	return sduiFeedStore
end

return createSduiFeedStore
