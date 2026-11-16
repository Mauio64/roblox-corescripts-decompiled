local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes
local Promise = require(parent.Promise)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local FFlagDataHydrationPreserveIncompleteCatalogResults = require(DataHydration.Flags.FFlagDataHydrationPreserveIncompleteCatalogResults)

local FFlagBuildExperienceMonetizationManageKinds = require(DataHydration.Flags.FFlagBuildExperienceMonetizationManageKinds)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local incompleteListCode = require(script.Parent.incompleteListCode)

local fetchGamePassConfig = require(script.Parent.fetchGamePassConfig)
local isManagedPricingEnabled = require(script.Parent.isManagedPricingEnabled)
require(script.Parent.GamePassConfigTypes)

local frozen = table.freeze({
	errorMessage = "The local user changed while the Game Pass request was running"
})

local function createGamePassConfigStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }
	local getLocalPlayerUserId = v.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local observeLocalPlayerUserId = v.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId

	local v3 = false
	local count = 0

	local function fetchGamePasses(p: number)
		local list = fetchGamePassConfig.list(p, v2)

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

	local singleEntityResolver = createSingleEntityResolver(fetchGamePasses, {
		cache = FFlagDataHydrationPreserveIncompleteCatalogResults and {
			ttlSecondsForItem = function(p): nil | number
				return if p.isIncomplete then 60 else nil
			end
		} or nil,
		resolver = { replaceItems = true }
	})

	local v4 = observeLocalPlayerUserId(function()
		count += 1
	end)

	local function verificationError(gamePass, p: string, cause)
		local v5

		if gamePass == nil then
			v5 = `The Game Pass request could not be verified: {p}. `
		else
			v5 = `Game pass {gamePass.gamePassId} could not be verified: {p}. `
		end

		return {
			outcome = "unverified",
			errorMessage = v5 .. "Inspect the existing game pass before retrying. Do not create another game pass.",
			gamePass = gamePass,
			cause = cause
		}
	end

	local function failedError(gamePassId: number?, errorMessage: string, cause)
		return {
			outcome = "failed",
			errorMessage = `The Game Pass request was rejected: {errorMessage}.`,
			gamePass = gamePassId ~= nil and { gamePassId = gamePassId } or nil,
			cause = cause
		}
	end

	local function captureMutationToken(gamePassId: number?)
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId == nil then
			return nil, {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = gamePassId ~= nil and { gamePassId = gamePassId } or nil,
				cause = nil
			}
		end

		return { generation = count, userId = localPlayerUserId }, nil
	end

	local function currentTokenError(p) -- 6 equivalent calls inferred from this helper
		if v3 or p.generation ~= count or p.userId ~= getLocalPlayerUserId() then
			return frozen
		end

		return nil
	end

	local function refreshInventory(p: number) -- 2 equivalent calls inferred from this helper
		if not v3 then
			if FFlagBuildExperienceMonetizationManageKinds then
				singleEntityResolver.refetch(p)
			else
				singleEntityResolver.clear()
				singleEntityResolver.fetch(p)
			end
		end
	end

	local function mutationResult(object, gamePassId: number?) -- 1 equivalent call inferred from this helper
		return object:catch(function(cause)
			if
				typeof(cause) == "table"
				and cause.responseCode ~= nil
				and cause.responseCode >= StatusCodes.BAD_REQUEST
				and cause.responseCode < StatusCodes.INTERNAL_SERVER_ERROR
				and cause.responseCode ~= StatusCodes.REQUEST_TIMEOUT
			then
				return Promise.reject(failedError(
					gamePassId,
					cause.errorMessage or "the service rejected the write",
					cause
				))
			end

			local reject = Promise.reject

			local gamePass = gamePassId ~= nil and { gamePassId = gamePassId } or nil
			return reject({
				outcome = "unverified",
				errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the write outcome is unknown. " or `Game pass {gamePass.gamePassId} could not be verified: the write outcome is unknown. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
				gamePass = gamePass,
				cause = cause
			})
		end)
	end

	local function runMutation(p, gamePassId: number?, fn)
		local cause = currentTokenError(p) -- inferred equivalent call

		if cause == nil then
			return mutationResult(fn(), gamePassId):andThen(function(gamePass) -- inferred equivalent call
				local cause2 = currentTokenError(p) -- inferred equivalent call

				if cause2 == nil then
					return gamePass
				end

				if typeof(gamePass) ~= "table" or typeof(gamePass.gamePassId) ~= "number" then
					gamePass = gamePassId ~= nil and { gamePassId = gamePassId } or nil
				end

				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the local user changed after the write. " or `Game pass {gamePass.gamePassId} could not be verified: the local user changed after the write. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = cause2
				})
			end)
		end

		return Promise.reject(failedError(gamePassId, cause.errorMessage, cause))
	end

	local function tokenBoundGet(p, p2: number, p3: number)
		local frozen2 = currentTokenError(p) -- inferred equivalent call

		if frozen2 == nil then
			return fetchGamePassConfig.get(p2, p3, v2):andThen(function(p4)
				local frozen3 = currentTokenError(p) -- inferred equivalent call

				if frozen3 == nil then
					return p4
				end

				return (Promise.reject(frozen3))
			end)
		end

		return Promise.reject(frozen2)
	end

	local function reconcileMutation(p: number, object)
		return object:andThen(function(p2)
			refreshInventory(p) -- inferred equivalent call
			return p2
		end, function(p2)
			if typeof(p2) == "table" and p2.outcome == "unverified" then
				refreshInventory(p) -- inferred equivalent call
			end

			return Promise.reject(p2)
		end)
	end

	local function readBackMutation(p, p2: number, gamePassId: number, p3: number?, p4: number?, flag: boolean?, p5, flag2: boolean?)
		return tokenBoundGet(p, p2, gamePassId):andThen(function(gamePass)
			if p3 ~= nil and gamePass.iconAssetId ~= p3 then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the stored icon did not match the returned icon. " or `Game pass {gamePass.gamePassId} could not be verified: the stored icon did not match the returned icon. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			if
				p4 ~= nil
				and (gamePass.iconAssetId == nil or gamePass.iconAssetId <= 0 or gamePass.iconAssetId == p4)
			then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the replacement image is not visible yet. " or `Game pass {gamePass.gamePassId} could not be verified: the replacement image is not visible yet. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			if flag ~= nil and gamePass.isForSale ~= flag then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the sale state does not match the requested state. " or `Game pass {gamePass.gamePassId} could not be verified: the sale state does not match the requested state. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			if p5 == nil then
				return gamePass
			end

			for _, v5 in { "name", "description" } do
				if not flag2 and p5[v5] ~= nil and gamePass[v5] ~= p5[v5] then
					local reject = Promise.reject
					local formatted = `the stored {v5} does not match the request`
					local v6

					if gamePass == nil then
						v6 = `The Game Pass request could not be verified: {formatted}. `
					else
						v6 = `Game pass {gamePass.gamePassId} could not be verified: {formatted}. `
					end

					return reject({
						outcome = "unverified",
						errorMessage = v6 .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = gamePass,
						cause = nil
					})
				end
			end

			if
				p5.isManagedPricingEnabled ~= nil
				and isManagedPricingEnabled(gamePass) ~= p5.isManagedPricingEnabled
			then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the stored isManagedPricingEnabled does not match the request. " or `Game pass {gamePass.gamePassId} could not be verified: the stored isManagedPricingEnabled does not match the request. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			local priceInformation = gamePass.priceInformation

			if
				p5.priceInRobux ~= nil
				and (priceInformation == nil or priceInformation.defaultPriceInRobux ~= p5.priceInRobux)
			then
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the stored price does not match the request. " or `Game pass {gamePass.gamePassId} could not be verified: the stored price does not match the request. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end

			return gamePass
		end, function(cause)
			if cause ~= frozen and currentTokenError(p) == nil then -- inferred equivalent call
				local gamePass = { gamePassId = gamePassId }
				return Promise.reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the readback failed. " or `Game pass {gamePass.gamePassId} could not be verified: the readback failed. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = cause
				})
			end

			local gamePass = { gamePassId = gamePassId }
			return Promise.reject({
				outcome = "unverified",
				errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the local user changed during readback. " or `Game pass {gamePass.gamePassId} could not be verified: the local user changed during readback. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
				gamePass = gamePass,
				cause = cause
			})
		end)
	end

	local function create(p: number, p2)
		local localPlayerUserId = getLocalPlayerUserId()
		local v5, v6

		if localPlayerUserId == nil then
			v5 = nil
			v6 = {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = nil,
				cause = nil
			}
		else
			v5 = { generation = count, userId = localPlayerUserId }
		end

		if v5 == nil then
			return Promise.reject(v6)
		end

		return reconcileMutation(p, runMutation(v5, nil, function()
			return fetchGamePassConfig.create(p, p2, v2)
		end):andThen(function(p3)
			if p2.imageFile == nil or p3.iconAssetId ~= nil and not (p3.iconAssetId <= 0) then
				local gamePassId = p3.gamePassId
				local iconAssetId

				if p2.imageFile ~= nil then
					iconAssetId = p3.iconAssetId
				end

				return readBackMutation(v5, p, gamePassId, iconAssetId, nil, p2.isForSale ~= nil and p2.isForSale, p2)
			else
				local reject = Promise.reject

				local gamePass = { gamePassId = p3.gamePassId }
				return reject({
					outcome = "unverified",
					errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the API did not return an uploaded image asset ID. " or `Game pass {gamePass.gamePassId} could not be verified: the API did not return an uploaded image asset ID. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
					gamePass = gamePass,
					cause = nil
				})
			end
		end))
	end

	local function update(p: number, gamePassId: number, p2, p3)
		local localPlayerUserId = getLocalPlayerUserId()
		local v5, v6

		if localPlayerUserId == nil then
			v5 = {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = gamePassId ~= nil and { gamePassId = gamePassId } or nil,
				cause = nil
			}
			v6 = nil
		else
			v6 = { generation = count, userId = localPlayerUserId }
		end

		if v6 == nil then
			return Promise.reject(v5)
		end

		local function mutate(p4: number?)
			return runMutation(v6, gamePassId, function()
				return fetchGamePassConfig.update(p, gamePassId, p2, v2)
			end):andThen(function()
				return readBackMutation(
					v6,
					p,
					gamePassId,
					nil,
					p4,
					p2.isForSale,
					p2,
					p3 ~= nil and p3.acceptModeratedText == true
				)
			end)
		end

		local v7

		if p2.imageFile == nil then
			v7 = mutate(nil)
		else
			v7 = tokenBoundGet(v6, p, gamePassId):andThen(function(gamePass)
				if gamePass.iconAssetId == nil then
					return Promise.reject({
						outcome = "failed",
						errorMessage = "The existing icon could not be read. No update was sent.",
						gamePass = gamePass
					})
				end

				return mutate(gamePass.iconAssetId)
			end, function(cause)
				if cause ~= frozen and currentTokenError(v6) == nil then -- inferred equivalent call
					return Promise.reject(failedError(
						gamePassId,
						cause.errorMessage or "the existing Game Pass could not be read before the update",
						cause
					))
				end

				return Promise.reject(failedError(gamePassId, frozen.errorMessage, cause))
			end)
		end

		return reconcileMutation(p, v7)
	end

	local function setArchived(p: number, gamePassId: number, flag: boolean)
		local localPlayerUserId = getLocalPlayerUserId()
		local v5, v6

		if localPlayerUserId == nil then
			v5 = {
				outcome = "failed",
				errorMessage = "The Game Pass request was rejected: a signed-in local user is required.",
				gamePass = gamePassId ~= nil and { gamePassId = gamePassId } or nil,
				cause = nil
			}
			v6 = nil
		else
			v6 = { generation = count, userId = localPlayerUserId }
		end

		if v6 == nil then
			return Promise.reject(v5)
		end

		return reconcileMutation(p, runMutation(v6, gamePassId, function()
			return fetchGamePassConfig.setArchived(p, gamePassId, flag, v2)
		end):andThen(function()
			return readBackMutation(v6, p, gamePassId):andThen(function(gamePass)
				if gamePass.isArchived == nil then
					return Promise.reject({
						outcome = "unverified",
						errorMessage = (gamePass == nil and "The Game Pass request could not be verified: archiving is not available for this account yet. " or `Game pass {gamePass.gamePassId} could not be verified: archiving is not available for this account yet. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = gamePass,
						cause = nil
					})
				end

				if gamePass.isArchived ~= flag then
					return Promise.reject({
						outcome = "unverified",
						errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the archive state is unchanged. " or `Game pass {gamePass.gamePassId} could not be verified: the archive state is unchanged. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = gamePass,
						cause = nil
					})
				end

				if flag and gamePass.isForSale ~= false then
					return Promise.reject({
						outcome = "unverified",
						errorMessage = (gamePass == nil and "The Game Pass request could not be verified: the archived pass was not taken off sale. " or `Game pass {gamePass.gamePassId} could not be verified: the archived pass was not taken off sale. `) .. "Inspect the existing game pass before retrying. Do not create another game pass.",
						gamePass = gamePass,
						cause = nil
					})
				end

				return gamePass
			end)
		end))
	end

	local function dispose()
		v3 = true
		count += 1
		v4()
		singleEntityResolver.dispose()
	end

	return {
		getGamePasses = singleEntityResolver.get,
		fetchGamePasses = singleEntityResolver.fetch,
		refetchGamePasses = singleEntityResolver.refetch,
		getAndFetchGamePasses = singleEntityResolver.getAndFetch,
		getAccountResetGeneration = singleEntityResolver.getAccountResetGeneration,
		list = function(p: number)
			return fetchGamePassConfig.list(p, v2)
		end,
		get = function(p: number, p2: number)
			return fetchGamePassConfig.get(p, p2, v2)
		end,
		batchGet = function(p: number, list)
			if #list == 0 then
				return Promise.resolve({ gamePasses = {} })
			end

			return fetchGamePassConfig.batchGet(p, list, v2)
		end,
		create = create,
		update = update,
		activate = function(p: number, p2: number)
			return update(p, p2, { isForSale = true })
		end,
		deactivate = function(p: number, p2: number)
			return update(p, p2, { isForSale = false })
		end,
		setArchived = setArchived,
		getSalesLimit = function(p: number)
			return fetchGamePassConfig.getSalesLimit(p, v2)
		end,
		clear = function()
			singleEntityResolver.clear()
		end,
		dispose = dispose
	}
end

return createGamePassConfigStore
