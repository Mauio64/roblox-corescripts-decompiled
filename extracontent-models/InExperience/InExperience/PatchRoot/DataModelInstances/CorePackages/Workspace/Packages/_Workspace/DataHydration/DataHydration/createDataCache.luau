local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)

local DataHydrationTypes = require(DataHydration.DataHydrationTypes)
local DataStatus = DataHydrationTypes.DataStatus
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local observeLocalPlayerUserId = DataHydrationUtils.observeLocalPlayerUserId
local SharedFlags = require(parent.SharedFlags)
local FFlagDataHydrationAccountReset = SharedFlags.FFlagDataHydrationAccountReset
local FFlagDataHydrationStaleTime = SharedFlags.FFlagDataHydrationStaleTime
local FFlagSduiReleaseSearchResultsPageState = SharedFlags.FFlagSduiReleaseSearchResultsPageState

local FFlagDataHydrationPreserveIncompleteCatalogResults = require(DataHydration.Flags.FFlagDataHydrationPreserveIncompleteCatalogResults)

local defineFastInt = game:DefineFastInt("LuaAppDefaultDataTtlSec", 3600)

local defineFastInt2 = game:DefineFastInt("LuaAppDefaultFailedDataTtlSec", 60)

local function createDataCache(p: number?, p2: number?, data)
	local v = p or defineFastInt
	local v2 = p2 or defineFastInt2
	local sanitizeItem

	if data then
		sanitizeItem = data.sanitizeItem
	else
		sanitizeItem = nil
	end

	local ttlSecondsForItem

	if FFlagDataHydrationPreserveIncompleteCatalogResults and data then
		ttlSecondsForItem = data.ttlSecondsForItem
	else
		ttlSecondsForItem = nil
	end

	local v3 = {}
	local v4 = {}
	local v5 = {}
	local v6 = {}

	local v7 = {}

	local function expiryFor(p3, p4: number) -- 4 equivalent calls inferred from this helper
		if ttlSecondsForItem then
			return os.clock() + (ttlSecondsForItem(p3) or v)
		end

		return p4
	end

	local function getOrCreateSignals(p3: string)
		if v3[p3] ~= nil and v4[p3] ~= nil then
			return v3[p3], v4[p3]
		end

		v3[p3] = {}
		local v8 = v3[p3]
		local v9 = v4
		local signal, v10 = Signals.createSignal(nil)
		v8.data = signal
		v9[p3] = v10
		local v11 = v3[p3]
		local v12 = v5
		local signal2, v13 = Signals.createSignal(DataStatus.NotReady)
		v11.status = signal2
		v12[p3] = v13

		return v3[p3], v4[p3]
	end

	local function getItem(item: string, callback, p3: number?)
		local signals = getOrCreateSignals(item)

		if FFlagDataHydrationStaleTime and p3 ~= nil then
			local data2 = signals.data(false)

			if signals.status(false) ~= DataStatus.Failed then
				local v8 = v7[item]
				local v9

				if data2 == nil or v8 == nil then
					v9 = false
				else
					v9 = os.clock() - v8 < p3
				end

				if v9 and callback then
					return signals, callback(data2)
				end

				return signals, not v9
			end
		end

		local v8 = true

		if not (v6[item] and os.clock() < v6[item]) then
			return signals, true
		end

		local data2 = signals.data(false)
		local status = signals.status(false)

		if data2 == nil and status ~= DataStatus.Failed then
			return signals, v8
		end

		if callback then
			return signals, (callback(data2))
		end

		v8 = false
		return signals, false
	end

	local function getItems(items, callback, p3: number?)
		local result = {}
		local result2 = {}

		if not items then
			return result, result2
		end

		for _, item in items do
			local item2, v8 = getItem(item, callback, p3)
			result[item] = item2
			result2[item] = v8
		end

		return result, result2
	end

	local function replaceItems(items)
		local now = os.clock()
		local v8 = now + v
		local function batchUpdate()
			for k, item in items do
				local _, v9 = getOrCreateSignals(k)
				local v10

				if sanitizeItem then
					v10 = sanitizeItem(item)
				else
					v10 = item
				end

				v9(v10)
				v5[k](DataStatus.Ready)
				v6[k] = expiryFor(item, v8) -- inferred equivalent call

				if FFlagDataHydrationStaleTime then
					v7[k] = now
				end
			end
		end
		SignalsExperimental.batch(batchUpdate)
	end

	local function updateItems(items, flag: boolean?)
		local now = os.clock()
		local v8 = now + v
		local function batchUpdate()
			for k, joined in items do
				local signals, v9 = getOrCreateSignals(k)
				local data2 = signals.data(false)

				if data2 and type(data2) == "table" and type(joined) == "table" then
					joined = Cryo.Dictionary.join(data2, joined)
				end

				local v10

				if sanitizeItem then
					v10 = sanitizeItem(joined)
				else
					v10 = joined
				end

				v9(v10)

				v5[k](DataStatus.Ready)

				if flag == false then
					continue
				end

				v6[k] = expiryFor(joined, v8) -- inferred equivalent call

				if FFlagDataHydrationStaleTime then
					v7[k] = now
				end
			end
		end

		SignalsExperimental.batch(batchUpdate)
	end

	local function updateItem(p3: string, p4, flag: boolean?)
		local signals, v8 = getOrCreateSignals(p3)
		local data2 = signals.data(false)

		if data2 and type(data2) == "table" and type(p4) == "table" then
			p4 = Cryo.Dictionary.join(data2, p4)
		end

		local v9

		if sanitizeItem then
			v9 = sanitizeItem(p4)
		else
			v9 = p4
		end

		v8(v9)

		v5[p3](DataStatus.Ready)

		if flag ~= false then
			v6[p3] = expiryFor(p4, os.clock() + v) -- inferred equivalent call

			if FFlagDataHydrationStaleTime then
				v7[p3] = os.clock()
			end
		end
	end

	local function replaceItem(p3: string, p4)
		local _, v8 = getOrCreateSignals(p3)
		local v9

		if sanitizeItem then
			v9 = sanitizeItem(p4)
		else
			v9 = p4
		end

		v8(v9)

		v5[p3](DataStatus.Ready)
		v6[p3] = expiryFor(p4, os.clock() + v) -- inferred equivalent call

		if FFlagDataHydrationStaleTime then
			v7[p3] = os.clock()
		end
	end

	local function resetFailedItem(item: string) -- 1 equivalent call inferred from this helper
		local v8 = v3[item]

		if v8 and v8.status(false) == DataStatus.Failed then
			v5[item](DataStatus.NotReady)
		end
	end

	local function resetFailedItems(items)
		for _, item in items do
			resetFailedItem(item) -- inferred equivalent call
		end
	end

	local function markItemsAsFailed(items)
		local v8 = os.clock() + v2
		local function batchUpdate()
			for _, item in items do
				if v5[item] then
					v5[item](DataStatus.Failed)
				end

				v6[item] = v8
			end
		end
		SignalsExperimental.batch(batchUpdate)
	end

	local function releaseEntries()
		v6 = {}

		if FFlagDataHydrationStaleTime then
			v7 = {}
		end

		v3 = {}
		v4 = {}
		v5 = {}
	end

	local function removeItem(p3: string)
		v3[p3] = nil
		v4[p3] = nil
		v5[p3] = nil
		v6[p3] = nil
		v7[p3] = nil
	end

	local function invalidateEntries() -- 1 equivalent call inferred from this helper
		SignalsExperimental.batch(function()
			table.clear(v6)

			if FFlagDataHydrationStaleTime then
				table.clear(v7)
			end

			for k in v3 do
				v4[k](nil)
				v5[k](DataStatus.NotReady)
			end
		end)
	end

	local function clear() -- 3 equivalent calls inferred from this helper
		if FFlagDataHydrationAccountReset then
			invalidateEntries() -- inferred equivalent call
		else
			releaseEntries()
		end
	end

	local v8 = getLocalPlayerUserId()
	local localPlayerChangedConnection = nil
	local v9 = nil

	if FFlagDataHydrationAccountReset then
		if not data or data.observeLocalUser == nil or data.observeLocalUser then
			v9 = observeLocalPlayerUserId(function(p3)
				v8 = p3
				clear() -- inferred equivalent call
			end)
		end
	else
		localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
			local localPlayerUserId = getLocalPlayerUserId()

			if localPlayerUserId ~= v8 then
				v8 = localPlayerUserId
				clear() -- inferred equivalent call
			end
		end)
	end

	local function dispose()
		if FFlagDataHydrationAccountReset then
			if v9 then
				v9()
				v9 = nil
			end

			releaseEntries()
		else
			if localPlayerChangedConnection then
				localPlayerChangedConnection:Disconnect()
				localPlayerChangedConnection = nil
			end

			clear() -- inferred equivalent call
		end
	end

	local dataCache = {
		getItem = getItem,
		getItems = getItems,
		updateItems = updateItems,
		updateItem = updateItem,
		replaceItems = replaceItems,
		replaceItem = replaceItem,
		markItemsAsFailed = markItemsAsFailed,
		resetFailedItem = resetFailedItem,
		resetFailedItems = resetFailedItems,
		removeItem = nil,
		clear = nil,
		dispose = nil
	}

	if not FFlagSduiReleaseSearchResultsPageState then
		removeItem = nil
	end

	dataCache.removeItem = removeItem
	dataCache.clear = clear
	dataCache.dispose = dispose
	return dataCache
end

return createDataCache
