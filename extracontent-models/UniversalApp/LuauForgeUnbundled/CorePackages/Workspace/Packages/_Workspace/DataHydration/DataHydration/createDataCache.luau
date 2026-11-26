local Players = game:GetService("Players")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SignalsExperimental")

local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes").DataStatus
local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local observeLocalPlayerUserId = DataHydrationUtils.observeLocalPlayerUserId
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local fFlagDataHydrationAccountReset = SharedFlags.FFlagDataHydrationAccountReset
local fFlagDataHydrationStaleTime = SharedFlags.FFlagDataHydrationStaleTime
local fFlagSduiReleaseSearchResultsPageState = SharedFlags.FFlagSduiReleaseSearchResultsPageState

local FFlagDataHydrationPreserveIncompleteCatalogResults = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagDataHydrationPreserveIncompleteCatalogResults")

local defineFastInt = game:DefineFastInt("LuaAppDefaultDataTtlSec", 3600)

local defineFastInt2 = game:DefineFastInt("LuaAppDefaultFailedDataTtlSec", 60)

local function createDataCache(p2, p3, data)
	local v5 = p2 or defineFastInt
	local v6 = p3 or defineFastInt2
	local sanitizeItem = if data then data.sanitizeItem else nil

	local ttlSecondsForItem = if FFlagDataHydrationPreserveIncompleteCatalogResults and data then data.ttlSecondsForItem else nil

	local v7 = {}
	local v8 = {}
	local v9 = {}
	local v10 = {}

	local v11 = {}

	local function expiryFor(p4, p5)
		if ttlSecondsForItem then
			return os.clock() + (ttlSecondsForItem(p4) or v5)
		end

		return p5
	end

	local function getOrCreateSignals(p4)
		if v7[p4] ~= nil and v8[p4] ~= nil then
			return v7[p4], v8[p4]
		end

		v7[p4] = {}
		local v12 = v7[p4]
		local v13 = v8
		local signal, v14 = Signals.createSignal(nil)
		v12.data = signal
		v13[p4] = v14
		local v15 = v7[p4]
		local v16 = v9
		local signal2, v17 = Signals.createSignal(dataStatus.NotReady)
		v15.status = signal2
		v16[p4] = v17

		return v7[p4], v8[p4]
	end

	local function getItem(item, callback, p4)
		local signals = getOrCreateSignals(item)

		if fFlagDataHydrationStaleTime and p4 ~= nil then
			local data2 = signals.data(false)

			if signals.status(false) ~= dataStatus.Failed then
				local v12 = v11[item]
				local v13 = not (data2 == nil or v12 == nil) and os.clock() - v12 < p4

				if v13 and callback then
					return signals, callback(data2)
				end

				return signals, not v13
			end
		end

		local v12 = true

		if not (v10[item] and os.clock() < v10[item]) then
			return signals, true
		end

		local data2 = signals.data(false)
		local status = signals.status(false)

		if data2 == nil and status ~= dataStatus.Failed then
			return signals, v12
		end

		if callback then
			return signals, (callback(data2))
		end

		v12 = false
		return signals, false
	end

	local function getItems(items, p4, p5)
		local result = {}
		local result2 = {}

		if not items then
			return result, result2
		end

		for k, item in items do
			local item2, v12 = getItem(item, p4, p5)
			result[item] = item2
			result2[item] = v12
		end

		return result, result2
	end

	local function replaceItems(items)
		local now = os.clock()
		local v12 = now + v5
		local function batchUpdate()
			for k, item in items do
				local signals, v13 = getOrCreateSignals(k)
				local v14 = if sanitizeItem then sanitizeItem(item) else item
				v13(v14)
				v9[k](dataStatus.Ready)
				local v15 = v10
				local v16 = v12

				if ttlSecondsForItem then
					v16 = os.clock() + (ttlSecondsForItem(item) or v5)
				end

				v15[k] = v16

				if fFlagDataHydrationStaleTime then
					v11[k] = now
				end
			end
		end
		SignalsExperimental.batch(batchUpdate)
	end

	local function updateItems(items, p4)
		local now = os.clock()
		local v12 = now + v5
		local function batchUpdate()
			for k, joined in items do
				local signals, v13 = getOrCreateSignals(k)
				local data2 = signals.data(false)

				if data2 and type(data2) == "table" and type(joined) == "table" then
					joined = Cryo.Dictionary.join(data2, joined)
				end

				local v14 = if sanitizeItem then sanitizeItem(joined) else joined
				v13(v14)

				v9[k](dataStatus.Ready)

				if p4 == false then
					continue
				end

				local v15 = v10
				local v16 = v12

				if ttlSecondsForItem then
					v16 = os.clock() + (ttlSecondsForItem(joined) or v5)
				end

				v15[k] = v16

				if fFlagDataHydrationStaleTime then
					v11[k] = now
				end
			end
		end

		SignalsExperimental.batch(batchUpdate)
	end

	local function updateItem(p4, p5, p6)
		local signals, v12 = getOrCreateSignals(p4)
		local data2 = signals.data(false)

		if data2 and type(data2) == "table" and type(p5) == "table" then
			p5 = Cryo.Dictionary.join(data2, p5)
		end

		local v13 = if sanitizeItem then sanitizeItem(p5) else p5
		v12(v13)

		v9[p4](dataStatus.Ready)

		if p6 ~= false then
			local v14 = v10
			local v15 = os.clock() + v5

			if ttlSecondsForItem then
				v15 = os.clock() + (ttlSecondsForItem(p5) or v5)
			end

			v14[p4] = v15

			if fFlagDataHydrationStaleTime then
				v11[p4] = os.clock()
			end
		end
	end

	local function replaceItem(p4, p5)
		local signals, v12 = getOrCreateSignals(p4)
		local v13 = if sanitizeItem then sanitizeItem(p5) else p5
		v12(v13)

		v9[p4](dataStatus.Ready)
		local v14 = v10
		local v15 = os.clock() + v5

		if ttlSecondsForItem then
			v15 = os.clock() + (ttlSecondsForItem(p5) or v5)
		end

		v14[p4] = v15

		if fFlagDataHydrationStaleTime then
			v11[p4] = os.clock()
		end
	end

	local function resetFailedItem(p4)
		local v12 = v7[p4]

		if v12 and v12.status(false) == dataStatus.Failed then
			v9[p4](dataStatus.NotReady)
		end
	end

	local function resetFailedItems(items)
		for k, item in items do
			local v12 = v7[item]

			if v12 and v12.status(false) == dataStatus.Failed then
				v9[item](dataStatus.NotReady)
			end
		end
	end

	local function markItemsAsFailed(items)
		local v12 = os.clock() + v6
		local function batchUpdate()
			for k, item in items do
				if v9[item] then
					v9[item](dataStatus.Failed)
				end

				v10[item] = v12
			end
		end
		SignalsExperimental.batch(batchUpdate)
	end

	local function releaseEntries()
		v10 = {}

		if fFlagDataHydrationStaleTime then
			v11 = {}
		end

		v7 = {}
		v8 = {}
		v9 = {}
	end

	local function removeItem(p4)
		v7[p4] = nil
		v8[p4] = nil
		v9[p4] = nil
		v10[p4] = nil
		v11[p4] = nil
	end

	local function invalidateEntries()
		SignalsExperimental.batch(function()
			table.clear(v10)

			if fFlagDataHydrationStaleTime then
				table.clear(v11)
			end

			for k in v7 do
				v8[k](nil)
				v9[k](dataStatus.NotReady)
			end
		end)
	end

	local function clear()
		if fFlagDataHydrationAccountReset then
			SignalsExperimental.batch(function()
				table.clear(v10)

				if fFlagDataHydrationStaleTime then
					table.clear(v11)
				end

				for k in v7 do
					v8[k](nil)
					v9[k](dataStatus.NotReady)
				end
			end)
		else
			releaseEntries()
		end
	end

	local v12 = getLocalPlayerUserId()
	local localPlayerChangedConnection = nil
	local v13 = nil

	if fFlagDataHydrationAccountReset then
		if not data or data.observeLocalUser == nil or data.observeLocalUser then
			v13 = observeLocalPlayerUserId(function(p4)
				v12 = p4

				if fFlagDataHydrationAccountReset then
					SignalsExperimental.batch(function()
						table.clear(v10)

						if fFlagDataHydrationStaleTime then
							table.clear(v11)
						end

						for k in v7 do
							v8[k](nil)
							v9[k](dataStatus.NotReady)
						end
					end)
				else
					releaseEntries()
				end
			end)
		end
	else
		localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
			local localPlayerUserId = getLocalPlayerUserId()

			if localPlayerUserId ~= v12 then
				v12 = localPlayerUserId

				if fFlagDataHydrationAccountReset then
					SignalsExperimental.batch(function()
						table.clear(v10)

						if fFlagDataHydrationStaleTime then
							table.clear(v11)
						end

						for k in v7 do
							v8[k](nil)
							v9[k](dataStatus.NotReady)
						end
					end)
				else
					releaseEntries()
				end
			end
		end)
	end

	local function dispose()
		if fFlagDataHydrationAccountReset then
			if v13 then
				v13()
				v13 = nil
			end

			releaseEntries()
		else
			if localPlayerChangedConnection then
				localPlayerChangedConnection:Disconnect()
				localPlayerChangedConnection = nil
			end

			if fFlagDataHydrationAccountReset then
				SignalsExperimental.batch(function()
					table.clear(v10)

					if fFlagDataHydrationStaleTime then
						table.clear(v11)
					end

					for k in v7 do
						v8[k](nil)
						v9[k](dataStatus.NotReady)
					end
				end)
			else
				releaseEntries()
			end
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

	if not fFlagSduiReleaseSearchResultsPageState then
		removeItem = nil
	end

	dataCache.removeItem = removeItem
	dataCache.clear = clear
	dataCache.dispose = dispose
	return dataCache
end

return createDataCache
