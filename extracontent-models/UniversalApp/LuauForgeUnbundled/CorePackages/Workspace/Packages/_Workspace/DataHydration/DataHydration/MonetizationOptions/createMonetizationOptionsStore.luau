require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local FFlagBuildExperienceMonetizationManageKinds = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagBuildExperienceMonetizationManageKinds")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")
local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local getGamePassConfigStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/getGamePassConfigStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/GamePassConfigTypes")
local fetchMonetizationOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MonetizationOptions/fetchMonetizationOptions")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MonetizationOptions/MonetizationOptionsTypes")

local frozen = table.freeze({
	errorMessage = "The local user changed while the bulk Game Pass request was running"
})

local function updateEntryPoint(p2, isEnabled)
	local clone = table.clone(p2)
	local v5 = {}
	local v6 = false

	for k, v7 in p2.entryPoints or {} do
		local clone2 = table.clone(v7)

		if clone2.name == "InExperienceGlobalIconEnabled" then
			clone2.isEnabled = isEnabled
			v6 = true
		end

		table.insert(v5, clone2)
	end

	if not v6 then
		table.insert(v5, {
			name = "InExperienceGlobalIconEnabled",
			isEnabled = isEnabled
		})
	end

	clone.entryPoints = v5
	return clone
end

local function createMonetizationOptionsStore(options)
	local v5 = options or {}
	local function logError(p2, p3)
		if v5.logError ~= nil then
			v5.logError(p2, p3)
		elseif typeof(p3) == "table" then
			warn(`[MonetizationOptions] {p2} request failed (responseCode={tostring(p3.responseCode)}): {tostring(p3.errorMessage)}`)
		else
			warn(`[MonetizationOptions] {p2} request failed: {tostring(p3)}`)
		end
	end
	local v6 = {
		network = v5.network,
		readNetwork = v5.readNetwork,
		mutatingNetwork = v5.mutatingNetwork,
		baseUrl = v5.baseUrl,
		groupsBaseUrl = v5.groupsBaseUrl
	}

	local getLocalPlayerUserId = v5.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local observeLocalPlayerUserId = v5.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId
	local v7 = false
	local count = 0
	local v8 = observeLocalPlayerUserId(function()
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

	local function isTokenCurrent(p2)
		local v9 = not v7

		if v9 then
			v9 = p2.generation == count and p2.userId == getLocalPlayerUserId()
		end

		return v9
	end

	local function isShopQueueCurrent(p2)
		local v9 = not v7

		if v9 then
			v9 = p2.generation == count and p2.userId == getLocalPlayerUserId()
		end

		return v9
	end

	local function bulkFetchOptions(p2)
		return {
			network = v6.network,
			readNetwork = v6.readNetwork,
			mutatingNetwork = v6.mutatingNetwork,
			baseUrl = v6.baseUrl,
			groupsBaseUrl = v6.groupsBaseUrl,
			isRequestCurrent = function()
				local v9 = p2
				local v10 = not v7

				if v10 then
					v10 = v9.generation == count and v9.userId == getLocalPlayerUserId()
				end

				return v10
			end
		}
	end

	local function guardBulkGamePassResult(p2, object)
		return object:andThen(function(p3)
			local v9 = p2
			local v10 = not v7

			if v10 then
				v10 = v9.generation == count and v9.userId == getLocalPlayerUserId()
			end

			if v10 then
				return p3
			end

			local v11 = { errors = p3.errors, results = {} }

			for k, result in p3.results do
				local clone = table.clone(result)

				if result.status ~= "failed" then
					clone.status = "unverified"
					clone.reason = "session_changed"
					clone.config = nil
					clone.error = frozen
				end

				table.insert(v11.results, clone)
			end

			return v11
		end)
	end

	local function runBulkGamePassMutation(list, fn)
		if #list == 0 then
			return fn(v6), nil
		end

		local v9, v10 = captureMutationToken()

		if v9 == nil then
			return Promise.reject(v10), nil
		end

		return fn(bulkFetchOptions(v9)):andThen(function(p2)
			local v11 = v9
			local v12 = not v7

			if v12 then
				v12 = v11.generation == count and v11.userId == getLocalPlayerUserId()
			end

			if v12 then
				return p2
			end

			local v13 = { errors = p2.errors, results = {} }

			for k, result in p2.results do
				local clone = table.clone(result)

				if result.status ~= "failed" then
					clone.status = "unverified"
					clone.reason = "session_changed"
					clone.config = nil
					clone.error = frozen
				end

				table.insert(v13.results, clone)
			end

			return v13
		end), v9
	end

	local v9 = {}
	local v10 = {}

	local v11 = createSingleEntityResolver(function(p2)
		return fetchMonetizationOptions.getManagedPricing(p2, v6)
	end, {
		resolver = {
			replaceItems = true,
			logError = function(p2)
				logError("managed_pricing", p2)
			end
		}
	})

	local v12 = createSingleEntityResolver(function(p2)
		return fetchMonetizationOptions.listShops(p2, v6)
	end, {
		resolver = {
			replaceItems = true,
			logError = function(p2)
				logError("shops", p2)
			end
		}
	})

	local v14 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		logError = function(p2)
			logError("permission", p2)
		end,
		fetchFn = function(p2, p3)
			local v15 = v9[p2]
			assert(v15 ~= nil, "Permission context must be set before fetching")
			return fetchMonetizationOptions.getMonetizationPermission(
				v15.universeId,
				v15.creatorType,
				v15.creatorTargetId,
				v6
			)
		end
	})

	local function permissionKey(p2, p3, value)
		local formatted = `{p2}:{p3}:{value or 0}`
		v9[formatted] = { universeId = p2, creatorType = p3, creatorTargetId = value }

		return formatted
	end

	local function readBackShops(p2, p3, data)
		if data == nil then
			return fetchMonetizationOptions.listShops(p2, v6):andThen(function(p4)
				if data == nil then
					v12.update(p2, p4)
					return p4
				end

				if v10[p2] == data then
					local v16 = data
					local v17 = not v7

					if v17 then
						v17 = v16.generation == count and v16.userId == getLocalPlayerUserId()
					end

					if v17 then
						v12.update(p2, p4)
						return p4
					end
				end

				return Promise.reject({
					kind = "unverified",
					error = "Shop write was reset"
				})
			end):catch(function(p4)
				if data == nil then
					logError("shops_readback", p4)

					if data == nil or not data.overlapped then
						return p3
					end

					if v10[p2] == data then
						v12.cache.markItemsAsFailed({ (tostring(p2)) })
					end
				elseif v10[p2] == data then
					local v16 = data
					local v17 = not v7

					if v17 then
						v17 = v16.generation == count and v16.userId == getLocalPlayerUserId()
					end

					if v17 then
						logError("shops_readback", p4)

						if data == nil or not data.overlapped then
							return p3
						end

						if v10[p2] == data then
							v12.cache.markItemsAsFailed({ (tostring(p2)) })
						end

						return Promise.reject({ kind = "unverified", error = p4 })
					end
				end

				return Promise.reject({ kind = "unverified", error = p4 })
			end)
		end

		if v10[p2] == data then
			local v15 = not v7

			if v15 then
				v15 = data.generation == count and data.userId == getLocalPlayerUserId()
			end

			if v15 then
				return fetchMonetizationOptions.listShops(p2, v6):andThen(function(p4)
					if data == nil then
						v12.update(p2, p4)
						return p4
					end

					if v10[p2] == data then
						local v16 = data
						local v17 = not v7

						if v17 then
							v17 = v16.generation == count and v16.userId == getLocalPlayerUserId()
						end

						if v17 then
							v12.update(p2, p4)
							return p4
						end
					end

					return Promise.reject({
						kind = "unverified",
						error = "Shop write was reset"
					})
				end):catch(function(p4)
					if data == nil then
						logError("shops_readback", p4)

						if data == nil or not data.overlapped then
							return p3
						end

						if v10[p2] == data then
							v12.cache.markItemsAsFailed({ (tostring(p2)) })
						end
					elseif v10[p2] == data then
						local v16 = data
						local v17 = not v7

						if v17 then
							v17 = v16.generation == count and v16.userId == getLocalPlayerUserId()
						end

						if v17 then
							logError("shops_readback", p4)

							if data == nil or not data.overlapped then
								return p3
							end

							if v10[p2] == data then
								v12.cache.markItemsAsFailed({ (tostring(p2)) })
							end

							return Promise.reject({ kind = "unverified", error = p4 })
						end
					end

					return Promise.reject({ kind = "unverified", error = p4 })
				end)
			end
		end

		return Promise.reject({
			kind = "unverified",
			error = "Shop write session changed"
		})
	end

	local function performShopGlobalIcon(p2, p3, p4)
		if v10[p2] == p4 then
			local v15 = not v7

			if v15 then
				v15 = p4.generation == count and p4.userId == getLocalPlayerUserId()
			end

			if v15 then
				local data = v12.get(p2).data(false)
				local shops = if data ~= nil then data.shops else nil
				local v16 = if shops ~= nil then shops[1] else nil

				if v16 == nil then
					return fetchMonetizationOptions.createShop(p2, p3, v6):andThen(function(p5)
						local v17 = {
							shops = { updateEntryPoint({
									shopId = p5.shopId,
									entryPoints = {}
								}, p3) }
						}

						if v10[p2] == p4 then
							local v18 = p4
							local v19 = not v7

							if v19 then
								v19 = v18.generation == count and v18.userId == getLocalPlayerUserId()
							end

							if v19 then
								v12.update(p2, v17)
								return readBackShops(p2, v17, p4)
							end
						end

						return Promise.reject({
							kind = "unverified",
							error = "Shop write was reset"
						})
					end, function(p5)
						if v10[p2] == p4 then
							local v17 = p4
							local v18 = not v7

							if v18 then
								v18 = v17.generation == count and v17.userId == getLocalPlayerUserId()
							end

							if v18 then
								return Promise.reject(p5)
							end
						end

						return Promise.reject({ kind = "unverified", error = p5 })
					end)
				end

				local v17 = assert(data, "Shop data must exist before an optimistic update")
				local clone = table.clone(v17.shops or {})
				clone[1] = updateEntryPoint(v16, p3)
				local v18 = { shops = clone }

				v12.update(p2, v18)

				return fetchMonetizationOptions.setShopGlobalIcon(v16.shopId, p3, v6):andThen(function()
					local v19 = p4
					local v20 = not v7

					if v20 then
						v20 = v19.generation == count and v19.userId == getLocalPlayerUserId()
					end

					if v20 then
						return readBackShops(p2, v18, p4)
					end

					return Promise.reject({
						kind = "unverified",
						error = "Shop write session changed"
					})
				end, function(p5)
					if v10[p2] == p4 then
						local v19 = p4
						local v20 = not v7

						if v20 then
							v20 = v19.generation == count and v19.userId == getLocalPlayerUserId()
						end

						if v20 then
							v12.update(p2, v17)
							return Promise.reject(p5)
						end
					end

					return Promise.reject({ kind = "unverified", error = p5 })
				end)
			end
		end

		return Promise.reject({ kind = "unverified", error = "Shop write was reset" })
	end

	local function setShopGlobalIcon(p2, p3)
		local v15 = v10[p2]

		if v15 ~= nil then
			local v16 = not v7

			if v16 then
				v16 = v15.generation == count and v15.userId == getLocalPlayerUserId()
			end

			if not v16 then
				v10[p2] = nil
			end
		end

		local v16 = v10[p2]

		if v16 == nil then
			v16 = {
				tail = Promise.resolve(),
				pending = 0,
				overlapped = false,
				generation = count,
				userId = getLocalPlayerUserId()
			}

			v10[p2] = v16
		end

		if v16.pending > 0 then
			v16.overlapped = true
		end

		v16.pending += 1
		local v17 = v16.tail:andThen(function()
			return performShopGlobalIcon(p2, p3, v16)
		end)

		v16.tail = v17:andThen(function()
			v16.pending -= 1

			if v16.pending == 0 and v10[p2] == v16 then
				v10[p2] = nil
			end
		end, function()
			v16.pending -= 1

			if v16.pending == 0 and v10[p2] == v16 then
				v10[p2] = nil
			end
		end)
		return v17
	end

	local function refreshGamePassInventory(p2, list, object, p3)
		if #list == 0 then
			return object
		end

		return object:andThen(function(p4)
			if p3 == nil then
				return p4
			end

			local v15 = p3
			local v16 = not v7

			if v16 then
				v16 = v15.generation == count and v15.userId == getLocalPlayerUserId()
			end

			if not v16 then
				return p4
			end

			local v17 = false

			for k, result in p4.results do
				if result.status ~= "failed" then
					v17 = true
					break
				end
			end

			if not v17 then
				return p4
			end

			local v19 = if v5.getGamePassConfigStore == nil then getGamePassConfigStore else v5.getGamePassConfigStore

			local v20 = v19()

			if FFlagBuildExperienceMonetizationManageKinds then
				v20.refetchGamePasses(p2)
				return p4
			end

			v20.clear()
			v20.fetchGamePasses(p2)

			return p4
		end)
	end

	local function dispose()
		v7 = true
		count += 1
		v8()
		v11.dispose()
		v12.dispose()
		v14.dispose()
		table.clear(v9)
		table.clear(v10)
	end

	return {
		getManagedPricing = v11.get,
		fetchManagedPricing = v11.fetch,
		getAndFetchManagedPricing = v11.getAndFetch,
		getShops = v12.get,
		fetchShops = v12.fetch,
		getAndFetchShops = v12.getAndFetch,
		getAndFetchPermission = function(p2, p3, value)
			local getAndFetchItem = v14.getAndFetchItem
			local formatted = `{p2}:{p3}:{value or 0}`
			v9[formatted] = {
				universeId = p2,
				creatorType = p3,
				creatorTargetId = value
			}

			return getAndFetchItem(formatted)
		end,
		fetchPermission = function(p2, p3, value)
			local fetchItem = v14.fetchItem
			local formatted = `{p2}:{p3}:{value or 0}`
			v9[formatted] = {
				universeId = p2,
				creatorType = p3,
				creatorTargetId = value
			}

			return fetchItem(formatted)
		end,
		acceptManagedPricing = function(p2)
			return fetchMonetizationOptions.acceptManagedPricing(p2, v6):andThen(function(p3)
				v11.update(p2, { status = "Accepted" })
				return p3
			end)
		end,
		ensureManagedPricingAccepted = function(p2)
			return fetchMonetizationOptions.getManagedPricing(p2, v6):andThen(function(p3)
				v11.update(p2, p3)

				if p3.status == "Accepted" then
					return true
				end

				if p3.status == "Disabled" then
					return Promise.reject("Managed pricing is not available for this experience.")
				end

				local v15 = p2
				return fetchMonetizationOptions.acceptManagedPricing(v15, v6):andThen(function(p4)
					v11.update(v15, { status = "Accepted" })
					return p4
				end):andThen(function(): boolean
					return true
				end)
			end)
		end,
		updateDeveloperProductsManagedPricing = function(p2, p3, p4)
			return fetchMonetizationOptions.updateDeveloperProductsManagedPricing(p2, p3, p4, v6)
		end,
		updateGamePassesManagedPricing = function(p2, p3, p4)
			return refreshGamePassInventory(p2, p3, runBulkGamePassMutation(p3, function(p5)
				return fetchMonetizationOptions.updateGamePassesManagedPricing(p2, p3, p4, p5)
			end))
		end,
		updateGamePassesArchived = function(p2, p3, p4)
			return refreshGamePassInventory(p2, p3, runBulkGamePassMutation(p3, function(p5)
				return fetchMonetizationOptions.updateGamePassesArchived(p2, p3, p4, p5)
			end))
		end,
		setShopGlobalIcon = setShopGlobalIcon,
		clear = function()
			v11.clear()
			v12.clear()
			v14.clear()
			table.clear(v9)
			table.clear(v10)
		end,
		dispose = dispose
	}
end

return createMonetizationOptionsStore
