require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").StatusCodes
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local FFlagDataHydrationPreserveIncompleteCatalogResults = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagDataHydrationPreserveIncompleteCatalogResults")

local FFlagBuildExperienceMonetizationManageKinds = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagBuildExperienceMonetizationManageKinds")
local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")
local incompleteListCode = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/incompleteListCode")

local fetchGamePassConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/fetchGamePassConfig")
local isManagedPricingEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/isManagedPricingEnabled")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/GamePassConfigTypes")

local frozen = table.freeze({
	errorMessage = "The local user changed while the Game Pass request was running"
})

local function createGamePassConfigStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }
	local getLocalPlayerUserId = v5.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local observeLocalPlayerUserId = v5.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId

	local flag = false
	local count = 0

	local function fetchGamePasses(p2)
		local list = fetchGamePassConfig.list(p2, v6)

		if FFlagDataHydrationPreserveIncompleteCatalogResults then
			return list:catch(function(data)
				if typeof(data) == "table" and data.code == incompleteListCode then
					return {
						gamePasses = data.gamePasses,
						nextPageToken = data.nextPageToken,
						isIncomplete = true
					}
				end

				return Promise.reject(data)
			end)
		end

		return list
	end

	local v7 = createSingleEntityResolver(fetchGamePasses, {
		cache = FFlagDataHydrationPreserveIncompleteCatalogResults and {
			ttlSecondsForItem = function(p2): nil | number
				if p2.isIncomplete then
					return 60
				end

				return nil
			end
		} or nil,
		resolver = { replaceItems = true }
	})

	local v8 = observeLocalPlayerUserId(function()
		count += 1
	end)

	local function verificationError(gamePass, p2, cause)
		local v10 = if gamePass == nil then `The Game Pass request could not be verified: {p2}. ` else `Game pass {gamePass.gamePassId} could not be verified: {p2}. `
		return {
			outcome = "unverified",
			errorMessage = v10 .. "Inspect the existing game pass before retrying. Do not create another game pass.",
			gamePass = gamePass,
			cause = cause
		}
	end

	local function failedError(p2, errorMessage, p3)
		return {
			outcome = "failed",
			errorMessage = `The Game Pass request was rejected: {errorMessage}.`,
			gamePass = p2 ~= nil and { gamePassId = p2 } or nil,
			cause = p3
		}
	end

	local function captureMutationToken(p2)
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId == nil then
			return nil, {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = p2 ~= nil and { gamePassId = p2 } or nil,
				cause = nil
			}
		end

		return { generation = count, userId = localPlayerUserId }, nil
	end

	local function currentTokenError(p2)
		if flag or p2.generation ~= count or p2.userId ~= getLocalPlayerUserId() then
			return frozen
		end

		return nil
	end

	local function refreshInventory(p2)
		if not flag then
			if FFlagBuildExperienceMonetizationManageKinds then
				v7.refetch(p2)
			else
				v7.clear()
				v7.fetch(p2)
			end
		end
	end

	local function mutationResult(object, p2)
		return object:catch(function(p3)
			if
				typeof(p3) == "table"
				and p3.responseCode ~= nil
				and p3.responseCode >= statusCodes.BAD_REQUEST
				and p3.responseCode < statusCodes.INTERNAL_SERVER_ERROR
				and p3.responseCode ~= statusCodes.REQUEST_TIMEOUT
			then
				return Promise.reject(failedError(
					p2,
					p3.errorMessage or "the service rejected the write",
					p3
				))
			end

			local reject = Promise.reject

			local v9 = p2 ~= nil and { gamePassId = p2 } or nil
			return reject({
				outcome = "unverified",
				errorMessage = (v9 == nil and "The Game Pass request could not be verified: the write outcome is unknown. " or `Game pass {v9.gamePassId} could not be verified: the write outcome is unknown. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
				gamePass = v9,
				cause = p3
			})
		end)
	end

	local function runMutation(p2, p3, fn)
		local v9

		if flag or p2.generation ~= count or p2.userId ~= getLocalPlayerUserId() then
			v9 = frozen
		end

		if v9 == nil then
			return fn():catch(function(p4)
				if
					typeof(p4) == "table"
					and p4.responseCode ~= nil
					and p4.responseCode >= statusCodes.BAD_REQUEST
					and p4.responseCode < statusCodes.INTERNAL_SERVER_ERROR
					and p4.responseCode ~= statusCodes.REQUEST_TIMEOUT
				then
					return Promise.reject(failedError(
						p3,
						p4.errorMessage or "the service rejected the write",
						p4
					))
				end

				local reject = Promise.reject

				local v10 = p3 ~= nil and { gamePassId = p3 } or nil
				return reject({
					outcome = "unverified",
					errorMessage = (v10 == nil and "The Game Pass request could not be verified: the write outcome is unknown. " or `Game pass {v10.gamePassId} could not be verified: the write outcome is unknown. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = v10,
					cause = p4
				})
			end):andThen(function(p4)
				local v10 = p2
				local v11

				if flag or v10.generation ~= count or v10.userId ~= getLocalPlayerUserId() then
					v11 = frozen
				end

				if v11 == nil then
					return p4
				end

				if typeof(p4) ~= "table" or typeof(p4.gamePassId) ~= "number" then
					p4 = p3 ~= nil and { gamePassId = p3 } or nil
				end

				return Promise.reject({
					outcome = "unverified",
					errorMessage = (p4 == nil and "The Game Pass request could not be verified: the local user changed after the write. " or `Game pass {p4.gamePassId} could not be verified: the local user changed after the write. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = p4,
					cause = v11
				})
			end)
		end

		return Promise.reject(failedError(p3, v9.errorMessage, v9))
	end

	local function tokenBoundGet(p2, p3, p4)
		local v9

		if flag or p2.generation ~= count or p2.userId ~= getLocalPlayerUserId() then
			v9 = frozen
		end

		if v9 == nil then
			return fetchGamePassConfig.get(p3, p4, v6):andThen(function(p5)
				local v10 = p2
				local v11

				if flag or v10.generation ~= count or v10.userId ~= getLocalPlayerUserId() then
					v11 = frozen
				end

				if v11 == nil then
					return p5
				end

				return (Promise.reject(v11))
			end)
		end

		return Promise.reject(v9)
	end

	local function reconcileMutation(p2, object)
		return object:andThen(function(p3)
			local v9 = p2

			if flag then
				return p3
			end

			if FFlagBuildExperienceMonetizationManageKinds then
				v7.refetch(v9)
				return p3
			end

			v7.clear()
			v7.fetch(v9)

			return p3
		end, function(p3)
			if typeof(p3) == "table" and p3.outcome == "unverified" then
				local v9 = p2

				if not flag then
					if FFlagBuildExperienceMonetizationManageKinds then
						v7.refetch(v9)
					else
						v7.clear()
						v7.fetch(v9)
					end
				end
			end

			return Promise.reject(p3)
		end)
	end

	local function readBackMutation(p2, p3, p4, p5, p6, p7, p8, p9)
		return tokenBoundGet(p2, p3, p4):andThen(function(gamePass)
			if p5 ~= nil and gamePass.iconAssetId ~= p5 then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the stored icon did not match the returned icon. " or `Game pass {gamePass.gamePassId} could not be verified: the stored icon did not match the returned icon. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			if
				p6 ~= nil
				and (gamePass.iconAssetId == nil or gamePass.iconAssetId <= 0 or gamePass.iconAssetId == p6)
			then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the replacement image is not visible yet. " or `Game pass {gamePass.gamePassId} could not be verified: the replacement image is not visible yet. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			if p7 ~= nil and gamePass.isForSale ~= p7 then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the sale state does not match the requested state. " or `Game pass {gamePass.gamePassId} could not be verified: the sale state does not match the requested state. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			if p8 == nil then
				return gamePass
			end

			for k, v9 in { "name", "description" } do
				if not p9 and p8[v9] ~= nil and gamePass[v9] ~= p8[v9] then
					local reject = Promise.reject
					local formatted = `the stored {v9} does not match the request`
					local v11 = if gamePass == nil then `The Game Pass request could not be verified: {formatted}. ` else `Game pass {gamePass.gamePassId} could not be verified: {formatted}. `
					return reject({
						outcome = "unverified",
						errorMessage = v11 .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = gamePass,
						cause = nil
					})
				end
			end

			if p8.isManagedPricingEnabled ~= nil and isManagedPricingEnabled(gamePass) ~= p8.isManagedPricingEnabled then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the stored isManagedPricingEnabled does not match the request. " or `Game pass {gamePass.gamePassId} could not be verified: the stored isManagedPricingEnabled does not match the request. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			local priceInformation = gamePass.priceInformation

			if
				p8.priceInRobux ~= nil
				and (priceInformation == nil or priceInformation.defaultPriceInRobux ~= p8.priceInRobux)
			then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the stored price does not match the request. " or `Game pass {gamePass.gamePassId} could not be verified: the stored price does not match the request. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			return gamePass
		end, function(p10)
			if p10 ~= frozen then
				local v9 = p2
				local v10

				if flag or v9.generation ~= count or v9.userId ~= getLocalPlayerUserId() then
					v10 = frozen
				end

				if v10 == nil then
					local v11 = { gamePassId = p4 }
					return Promise.reject({
						outcome = "unverified",
						errorMessage = (v11 == nil and "The Game Pass request could not be verified: the readback failed. " or `Game pass {v11.gamePassId} could not be verified: the readback failed. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = v11,
						cause = p10
					})
				end
			end

			local v9 = { gamePassId = p4 }
			return Promise.reject({
				outcome = "unverified",
				errorMessage = (v9 == nil and "The Game Pass request could not be verified: the local user changed during readback. " or `Game pass {v9.gamePassId} could not be verified: the local user changed during readback. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
				gamePass = v9,
				cause = p10
			})
		end)
	end

	local function create(p2, p3)
		local localPlayerUserId = getLocalPlayerUserId()
		local v9, v10

		if localPlayerUserId == nil then
			v9 = nil
			v10 = {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = nil,
				cause = nil
			}
		else
			v9 = { generation = count, userId = localPlayerUserId }
		end

		if v9 == nil then
			return Promise.reject(v10)
		end

		return reconcileMutation(p2, runMutation(v9, nil, function()
			return fetchGamePassConfig.create(p2, p3, v6)
		end):andThen(function(p4)
			if p3.imageFile == nil or p4.iconAssetId ~= nil and not (p4.iconAssetId <= 0) then
				local gamePassId = p4.gamePassId
				local iconAssetId = if p3.imageFile ~= nil then p4.iconAssetId else nil
				return readBackMutation(
					v9,
					p2,
					gamePassId,
					iconAssetId,
					nil,
					p3.isForSale ~= nil and p3.isForSale,
					p3
				)
			else
				local reject = Promise.reject

				local v12 = { gamePassId = p4.gamePassId }
				return reject({
					outcome = "unverified",
					errorMessage = (v12 == nil and "The Game Pass request could not be verified: the API did not return an uploaded image asset ID. " or `Game pass {v12.gamePassId} could not be verified: the API did not return an uploaded image asset ID. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = v12,
					cause = nil
				})
			end
		end))
	end

	local function update(p2, p3, p4, p5)
		local localPlayerUserId = getLocalPlayerUserId()
		local v9, v10

		if localPlayerUserId == nil then
			v9 = {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = p3 ~= nil and { gamePassId = p3 } or nil,
				cause = nil
			}
			v10 = nil
		else
			v10 = { generation = count, userId = localPlayerUserId }
		end

		if v10 == nil then
			return Promise.reject(v9)
		end

		local function mutate(p6)
			return runMutation(v10, p3, function()
				return fetchGamePassConfig.update(p2, p3, p4, v6)
			end):andThen(function()
				return readBackMutation(
					v10,
					p2,
					p3,
					nil,
					p6,
					p4.isForSale,
					p4,
					p5 ~= nil and p5.acceptModeratedText == true
				)
			end)
		end

		local v11

		if p4.imageFile == nil then
			v11 = mutate(nil)
		else
			v11 = tokenBoundGet(v10, p2, p3):andThen(function(p6)
				if p6.iconAssetId == nil then
					return Promise.reject({
						outcome = "failed",
						errorMessage = "The existing icon could not be read. No update was sent.",
						gamePass = p6
					})
				end

				return mutate(p6.iconAssetId)
			end, function(p6)
				if p6 ~= frozen then
					local v12 = v10
					local v13

					if flag or v12.generation ~= count or v12.userId ~= getLocalPlayerUserId() then
						v13 = frozen
					end

					if v13 == nil then
						return Promise.reject(failedError(
							p3,
							p6.errorMessage or "the existing Game Pass could not be read before the update",
							p6
						))
					end
				end

				return Promise.reject(failedError(p3, frozen.errorMessage, p6))
			end)
		end

		return reconcileMutation(p2, v11)
	end

	local function setArchived(p2, p3, p4)
		local localPlayerUserId = getLocalPlayerUserId()
		local v9, v10

		if localPlayerUserId == nil then
			v9 = {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = p3 ~= nil and { gamePassId = p3 } or nil,
				cause = nil
			}
			v10 = nil
		else
			v10 = { generation = count, userId = localPlayerUserId }
		end

		if v10 == nil then
			return Promise.reject(v9)
		end

		return reconcileMutation(p2, runMutation(v10, p3, function()
			return fetchGamePassConfig.setArchived(p2, p3, p4, v6)
		end):andThen(function()
			return readBackMutation(v10, p2, p3):andThen(function(data)
				if data.isArchived == nil then
					return Promise.reject({
						outcome = "unverified",
						errorMessage = (data == nil and "The Game Pass request could not be verified: archiving is not available for this account yet. " or `Game pass {data.gamePassId} could not be verified: archiving is not available for this account yet. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = data,
						cause = nil
					})
				end

				if data.isArchived ~= p4 then
					return Promise.reject({
						outcome = "unverified",
						errorMessage = (data == nil and "The Game Pass request could not be verified: the archive state is unchanged. " or `Game pass {data.gamePassId} could not be verified: the archive state is unchanged. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = data,
						cause = nil
					})
				end

				if p4 and data.isForSale ~= false then
					return Promise.reject({
						outcome = "unverified",
						errorMessage = (data == nil and "The Game Pass request could not be verified: the archived pass was not taken off sale. " or `Game pass {data.gamePassId} could not be verified: the archived pass was not taken off sale. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = data,
						cause = nil
					})
				end

				return data
			end)
		end))
	end

	local function dispose()
		flag = true
		count += 1
		v8()
		v7.dispose()
	end

	return {
		getGamePasses = v7.get,
		fetchGamePasses = v7.fetch,
		refetchGamePasses = v7.refetch,
		getAndFetchGamePasses = v7.getAndFetch,
		getAccountResetGeneration = v7.getAccountResetGeneration,
		list = function(p2)
			return fetchGamePassConfig.list(p2, v6)
		end,
		get = function(p2, p3)
			return fetchGamePassConfig.get(p2, p3, v6)
		end,
		batchGet = function(p2, list2)
			if #list2 == 0 then
				return Promise.resolve({ gamePasses = {} })
			end

			return fetchGamePassConfig.batchGet(p2, list2, v6)
		end,
		create = create,
		update = update,
		activate = function(p2, p3)
			return update(p2, p3, { isForSale = true })
		end,
		deactivate = function(p2, p3)
			return update(p2, p3, { isForSale = false })
		end,
		setArchived = setArchived,
		getSalesLimit = function(p2)
			return fetchGamePassConfig.getSalesLimit(p2, v6)
		end,
		clear = function()
			v7.clear()
		end,
		dispose = dispose
	}
end

return createGamePassConfigStore
