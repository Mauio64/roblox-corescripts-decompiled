local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)
local Promise = require(parent.Promise)

local FFlagBuildExperienceMonetizationManageKinds = require(DataHydration.Flags.FFlagBuildExperienceMonetizationManageKinds)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
require(DataHydration.DataHydrationTypes)
local getGamePassConfigStore = require(DataHydration.GamePassConfig.getGamePassConfigStore)
require(DataHydration.GamePassConfig.GamePassConfigTypes)
local fetchMonetizationOptions = require(script.Parent.fetchMonetizationOptions)
require(script.Parent.MonetizationOptionsTypes)

local frozen = table.freeze({
	errorMessage = "The local user changed while the bulk Game Pass request was running"
})

local function updateEntryPoint(p, isEnabled: boolean)
	local clone = table.clone(p)
	local entryPoints = {}
	local v = false

	for _, v2 in p.entryPoints or {} do
		local clone2 = table.clone(v2)

		if clone2.name == "InExperienceGlobalIconEnabled" then
			clone2.isEnabled = isEnabled
			v = true
		end

		table.insert(entryPoints, clone2)
	end

	if not v then
		table.insert(entryPoints, { name = "InExperienceGlobalIconEnabled", isEnabled = isEnabled })
	end

	clone.entryPoints = entryPoints
	return clone
end

local function createMonetizationOptionsStore(options)
	local v = options or {}
	local function logError(p: string, p2)
		if v.logError ~= nil then
			v.logError(p, p2)
		elseif typeof(p2) == "table" then
			warn(`[MonetizationOptions] {p} request failed (responseCode={tostring(p2.responseCode)}): {tostring(p2.errorMessage)}`)
		else
			warn(`[MonetizationOptions] {p} request failed: {tostring(p2)}`)
		end
	end
	local v2 = {
		network = v.network,
		readNetwork = v.readNetwork,
		mutatingNetwork = v.mutatingNetwork,
		baseUrl = v.baseUrl,
		groupsBaseUrl = v.groupsBaseUrl
	}

	local getLocalPlayerUserId = v.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local observeLocalPlayerUserId = v.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId
	local v3 = false
	local count = 0
	local v4 = observeLocalPlayerUserId(function()
		count += 1
	end)

	local function captureMutationToken()
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId == nil then
			return
				nil,
				{
					outcome = "failed",
					errorMessage = "A signed-in local user is required for bulk Game Pass mutations."
				}
		end

		return { generation = count, userId = localPlayerUserId }, nil
	end

	local function isTokenCurrent(p) -- 3 equivalent calls inferred from this helper
		local v5 = not v3

		if v5 then
			if p.generation == count then
				return p.userId == getLocalPlayerUserId()
			end

			return false
		end

		return v5
	end

	local function isShopQueueCurrent(p) -- 9 equivalent calls inferred from this helper
		local v5 = not v3

		if v5 then
			if p.generation == count then
				return p.userId == getLocalPlayerUserId()
			end

			return false
		end

		return v5
	end

	local function bulkFetchOptions(p)
		return {
			network = v2.network,
			readNetwork = v2.readNetwork,
			mutatingNetwork = v2.mutatingNetwork,
			baseUrl = v2.baseUrl,
			groupsBaseUrl = v2.groupsBaseUrl,
			isRequestCurrent = function()
				return isTokenCurrent(p) -- inferred equivalent call
			end
		}
	end

	local function guardBulkGamePassResult(p, object) -- 1 equivalent call inferred from this helper
		return object:andThen(function(p2)
			if isTokenCurrent(p) then -- inferred equivalent call
				return p2
			end

			local v5 = { errors = p2.errors, results = {} }

			for _, result in p2.results do
				local clone = table.clone(result)

				if result.status ~= "failed" then
					clone.status = "unverified"
					clone.reason = "session_changed"
					clone.config = nil
					clone.error = frozen
				end

				table.insert(v5.results, clone)
			end

			return v5
		end)
	end

	local function runBulkGamePassMutation(list, fn)
		if #list == 0 then
			return fn(v2), nil
		end

		local v5, v6 = captureMutationToken()

		if v5 == nil then
			return Promise.reject(v6), nil
		end

		return guardBulkGamePassResult(v5, fn(bulkFetchOptions(v5))), v5 -- inferred equivalent call
	end

	local v5 = {}
	local v6 = {}

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchMonetizationOptions.getManagedPricing(p, v2)
	end, {
		resolver = {
			replaceItems = true,
			logError = function(p)
				logError("managed_pricing", p)
			end
		}
	})

	local singleEntityResolver2 = createSingleEntityResolver(function(p: number)
		return fetchMonetizationOptions.listShops(p, v2)
	end, {
		resolver = {
			replaceItems = true,
			logError = function(p)
				logError("shops", p)
			end
		}
	})

	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		logError = function(p)
			logError("permission", p)
		end,
		fetchFn = function(p: string, _)
			local v7 = v5[p]
			assert(v7 ~= nil, "Permission context must be set before fetching")
			return fetchMonetizationOptions.getMonetizationPermission(
				v7.universeId,
				v7.creatorType,
				v7.creatorTargetId,
				v2
			)
		end
	})

	local function permissionKey(universeId: number, creatorType, creatorTargetId: number?) -- 2 equivalent calls inferred from this helper
		local formatted = `{universeId}:{creatorType}:{creatorTargetId or 0}`
		v5[formatted] = {
			universeId = universeId,
			creatorType = creatorType,
			creatorTargetId = creatorTargetId
		}

		return formatted
	end

	local function acceptManagedPricing(p: number) -- 1 equivalent call inferred from this helper
		return fetchMonetizationOptions.acceptManagedPricing(p, v2):andThen(function(p2)
			singleEntityResolver.update(p, { status = "Accepted" })
			return p2
		end)
	end

	local function readBackShops(p: number, p2, p3)
		if p3 == nil or v6[p] == p3 and isShopQueueCurrent(p3) then -- inferred equivalent call
			return fetchMonetizationOptions.listShops(p, v2):andThen(function(p4)
				if p3 == nil then
					singleEntityResolver2.update(p, p4)
					return p4
				end

				if v6[p] == p3 and isShopQueueCurrent(p3) then -- inferred equivalent call
					singleEntityResolver2.update(p, p4)
					return p4
				end

				return Promise.reject({ kind = "unverified", error = "Shop write was reset" })
			end):catch(function(err)
				if p3 == nil then
					logError("shops_readback", err)

					if p3 == nil or not p3.overlapped then
						return p2
					end

					if v6[p] == p3 then
						singleEntityResolver2.cache.markItemsAsFailed({ (tostring(p)) })
					end
				elseif v6[p] == p3 and isShopQueueCurrent(p3) then -- inferred equivalent call
					logError("shops_readback", err)

					if p3 == nil or not p3.overlapped then
						return p2
					end

					if v6[p] == p3 then
						singleEntityResolver2.cache.markItemsAsFailed({ (tostring(p)) })
					end

					return Promise.reject({ kind = "unverified", error = err })
				end

				return Promise.reject({ kind = "unverified", error = err })
			end)
		end

		return Promise.reject({ kind = "unverified", error = "Shop write session changed" })
	end

	local function performShopGlobalIcon(p: number, isEnabled: boolean, p2)
		if v6[p] == p2 and isShopQueueCurrent(p2) then -- inferred equivalent call
			local data = singleEntityResolver2.get(p).data(false)
			local shops

			if data ~= nil then
				shops = data.shops
			end

			local v7

			if shops ~= nil then
				v7 = shops[1]
			end

			if v7 == nil then
				return fetchMonetizationOptions.createShop(p, isEnabled, v2):andThen(function(p3)
					local v8 = {
						shops = { updateEntryPoint({ shopId = p3.shopId, entryPoints = {} }, isEnabled) }
					}

					if v6[p] == p2 and isShopQueueCurrent(p2) then -- inferred equivalent call
						singleEntityResolver2.update(p, v8)
						return readBackShops(p, v8, p2)
					end

					return Promise.reject({ kind = "unverified", error = "Shop write was reset" })
				end, function(err)
					if v6[p] == p2 and isShopQueueCurrent(p2) then -- inferred equivalent call
						return Promise.reject(err)
					end

					return Promise.reject({ kind = "unverified", error = err })
				end)
			end

			local v8 = assert(data, "Shop data must exist before an optimistic update")
			local clone = table.clone(v8.shops or {})
			clone[1] = updateEntryPoint(v7, isEnabled)
			local v9 = { shops = clone }

			singleEntityResolver2.update(p, v9)

			return fetchMonetizationOptions.setShopGlobalIcon(v7.shopId, isEnabled, v2):andThen(function()
				if isShopQueueCurrent(p2) then -- inferred equivalent call
					return readBackShops(p, v9, p2)
				end

				return Promise.reject({ kind = "unverified", error = "Shop write session changed" })
			end, function(err)
				if v6[p] == p2 and isShopQueueCurrent(p2) then -- inferred equivalent call
					singleEntityResolver2.update(p, v8)
					return Promise.reject(err)
				end

				return Promise.reject({ kind = "unverified", error = err })
			end)
		end

		return Promise.reject({ kind = "unverified", error = "Shop write was reset" })
	end

	local function setShopGlobalIcon(p: number, isEnabled: boolean)
		local v7 = v6[p]

		if v7 ~= nil and not isShopQueueCurrent(v7) then -- inferred equivalent call
			v6[p] = nil
		end

		local v8 = v6[p]

		if v8 == nil then
			v8 = {
				tail = Promise.resolve(),
				pending = 0,
				overlapped = false,
				generation = count,
				userId = getLocalPlayerUserId()
			}

			v6[p] = v8
		end

		if v8.pending > 0 then
			v8.overlapped = true
		end

		v8.pending += 1
		local v9 = v8.tail:andThen(function()
			return performShopGlobalIcon(p, isEnabled, v8)
		end)

		v8.tail = v9:andThen(function()
			v8.pending -= 1

			if v8.pending == 0 and v6[p] == v8 then
				v6[p] = nil
			end
		end, function()
			v8.pending -= 1

			if v8.pending == 0 and v6[p] == v8 then
				v6[p] = nil
			end
		end)
		return v9
	end

	local function refreshGamePassInventory(p: number, list, object, p2)
		if #list == 0 then
			return object
		end

		return object:andThen(function(p3)
			if p2 == nil then
				return p3
			end

			if not isTokenCurrent(p2) then -- inferred equivalent call
				return p3
			end

			local v7 = false

			for _, result in p3.results do
				if result.status ~= "failed" then
					v7 = true
					break
				end
			end

			if not v7 then
				return p3
			end

			local v8

			if v.getGamePassConfigStore == nil then
				v8 = getGamePassConfigStore
			else
				v8 = v.getGamePassConfigStore
			end

			local v9 = v8()

			if FFlagBuildExperienceMonetizationManageKinds then
				v9.refetchGamePasses(p)
				return p3
			end

			v9.clear()
			v9.fetchGamePasses(p)

			return p3
		end)
	end

	local function dispose()
		v3 = true
		count += 1
		v4()
		singleEntityResolver.dispose()
		singleEntityResolver2.dispose()
		dataResolver.dispose()
		table.clear(v5)
		table.clear(v6)
	end

	return {
		getManagedPricing = singleEntityResolver.get,
		fetchManagedPricing = singleEntityResolver.fetch,
		getAndFetchManagedPricing = singleEntityResolver.getAndFetch,
		getShops = singleEntityResolver2.get,
		fetchShops = singleEntityResolver2.fetch,
		getAndFetchShops = singleEntityResolver2.getAndFetch,
		getAndFetchPermission = function(universeId: number, creatorType, creatorTargetId: number?)
			return dataResolver.getAndFetchItem(permissionKey(universeId, creatorType, creatorTargetId)) -- inferred equivalent call
		end,
		fetchPermission = function(universeId: number, creatorType, creatorTargetId: number?)
			return dataResolver.fetchItem(permissionKey(universeId, creatorType, creatorTargetId)) -- inferred equivalent call
		end,
		acceptManagedPricing = acceptManagedPricing,
		ensureManagedPricingAccepted = function(p: number)
			return fetchMonetizationOptions.getManagedPricing(p, v2):andThen(function(p2)
				singleEntityResolver.update(p, p2)

				if p2.status == "Accepted" then
					return true
				end

				if p2.status == "Disabled" then
					return Promise.reject("Managed pricing is not available for this experience.")
				end

				return acceptManagedPricing(p):andThen(function(): boolean -- inferred equivalent call
					return true
				end)
			end)
		end,
		updateDeveloperProductsManagedPricing = function(p, p2, p3)
			return fetchMonetizationOptions.updateDeveloperProductsManagedPricing(p, p2, p3, v2)
		end,
		updateGamePassesManagedPricing = function(p, p2, p3)
			return refreshGamePassInventory(p, p2, runBulkGamePassMutation(p2, function(p4)
				return fetchMonetizationOptions.updateGamePassesManagedPricing(p, p2, p3, p4)
			end))
		end,
		updateGamePassesArchived = function(p, p2, p3)
			return refreshGamePassInventory(p, p2, runBulkGamePassMutation(p2, function(p4)
				return fetchMonetizationOptions.updateGamePassesArchived(p, p2, p3, p4)
			end))
		end,
		setShopGlobalIcon = setShopGlobalIcon,
		clear = function()
			singleEntityResolver.clear()
			singleEntityResolver2.clear()
			dataResolver.clear()
			table.clear(v5)
			table.clear(v6)
		end,
		dispose = dispose
	}
end

return createMonetizationOptionsStore
