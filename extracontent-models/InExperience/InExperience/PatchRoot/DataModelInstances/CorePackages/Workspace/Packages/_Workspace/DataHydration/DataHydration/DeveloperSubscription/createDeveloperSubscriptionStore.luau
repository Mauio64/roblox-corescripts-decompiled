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

local fetchDeveloperSubscription = require(script.Parent.fetchDeveloperSubscription)
local DeveloperSubscriptionTypes = require(script.Parent.DeveloperSubscriptionTypes)

local frozen = table.freeze({
	errorMessage = "The local user changed while the Developer Subscription request was running"
})

local function createDeveloperSubscriptionStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }
	local getLocalPlayerUserId = v.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local observeLocalPlayerUserId = v.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId

	local count = 0
	local v3 = false
	local function fetchSubscriptions(p: number)
		local list = fetchDeveloperSubscription.list(p, v2)

		if FFlagDataHydrationPreserveIncompleteCatalogResults then
			return list:catch(function(data)
				if typeof(data) == "table" and data.code == "IncompleteDeveloperSubscriptionList" then
					return {
						developerSubscriptions = data.developerSubscriptions,
						nextCursor = data.nextCursor,
						isIncomplete = true
					}
				end

				return Promise.reject(data)
			end)
		end

		return list
	end

	local singleEntityResolver = createSingleEntityResolver(fetchSubscriptions, {
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

	local function verificationError(id: string?, p: string, p2, cause) -- 2 equivalent calls inferred from this helper
		return {
			outcome = "unverified",
			errorMessage = `The Developer Subscription request could not be confirmed: {p}. ` .. "Do not automatically retry the write; inspect existing subscriptions first.",
			subscription = p2 or id ~= nil and { id = id } or nil,
			cause = cause
		}
	end

	local function failedError(id: string?, p: string, cause)
		return {
			outcome = "failed",
			errorMessage = `The Developer Subscription request was rejected: {p}.`,
			subscription = id ~= nil and { id = id } or nil,
			cause = cause
		}
	end

	local function captureMutationToken() -- 3 equivalent calls inferred from this helper
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId == nil then
			return
				nil,
				{
					outcome = "failed",
					errorMessage = "The Developer Subscription request was rejected: a signed-in local user is required.",
					subscription = nil,
					cause = nil
				}
		end

		return { generation = count, userId = localPlayerUserId }, nil
	end

	local function isTokenCurrent(p) -- 1 equivalent call inferred from this helper
		local v5 = not v3

		if v5 then
			if p.generation == count then
				return p.userId == getLocalPlayerUserId()
			end

			return false
		end

		return v5
	end

	local function currentTokenError(p) -- 10 equivalent calls inferred from this helper
		if isTokenCurrent(p) then -- inferred equivalent call
			return nil
		end

		return frozen
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

	local function mutationResult(object, id: string?) -- 1 equivalent call inferred from this helper
		return object:andThen(function(cause)
			if cause.success then
				return assert(
					cause.subscription,
					"A successful Developer Subscription mutation must return its identity"
				)
			end

			return Promise.reject(failedError(
				id,
				`the service returned failureReason {tostring(cause.failureReason)}`,
				cause
			))
		end, function(cause)
			if
				typeof(cause) == "table"
				and cause.responseCode ~= nil
				and cause.responseCode >= StatusCodes.BAD_REQUEST
				and cause.responseCode < StatusCodes.INTERNAL_SERVER_ERROR
				and cause.responseCode ~= StatusCodes.REQUEST_TIMEOUT
			then
				return Promise.reject(failedError(id, cause.errorMessage or "the service rejected the write", cause))
			end

			local id2 = id
			return Promise.reject({
				outcome = "unverified",
				errorMessage = "The Developer Subscription request could not be confirmed: the write outcome is unknown. Do not automatically retry the write; inspect existing subscriptions first.",
				subscription = id2 ~= nil and { id = id2 } or nil,
				cause = cause
			})
		end)
	end

	local function verifyRead(p, fn, fn2, p2: string, id: string)
		local cause = currentTokenError(p) -- inferred equivalent call

		if cause == nil then
			return fn():andThen(function(p3)
				local cause2 = currentTokenError(p) -- inferred equivalent call

				if cause2 ~= nil then
					local id2 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = id2 ~= nil and { id = id2 } or nil,
						cause = cause2
					})
				end

				if fn2(p3) then
					return p3
				end

				return Promise.reject(verificationError(id, p2, p3)) -- inferred equivalent call
			end, function(cause2)
				if cause2 ~= frozen and currentTokenError(p) == nil then -- inferred equivalent call
					local id2 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = `The Developer Subscription request could not be confirmed: {p2}. ` .. "Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = id2 ~= nil and { id = id2 } or nil,
						cause = cause2
					})
				end

				local id2 = id
				return Promise.reject({
					outcome = "unverified",
					errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
					subscription = id2 ~= nil and { id = id2 } or nil,
					cause = cause2
				})
			end)
		end

		return Promise.reject({
			outcome = "unverified",
			errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
			subscription = id ~= nil and { id = id } or nil,
			cause = cause
		})
	end

	local function tokenBoundGet(p, p2: number, p3: string)
		local frozen2 = currentTokenError(p) -- inferred equivalent call

		if frozen2 == nil then
			return fetchDeveloperSubscription.get(p2, p3, v2):andThen(function(p4)
				local frozen3 = currentTokenError(p) -- inferred equivalent call

				if frozen3 == nil then
					return p4
				end

				return (Promise.reject(frozen3))
			end)
		end

		return Promise.reject(frozen2)
	end

	local function withMutationPreflight(p: number, id: string, fn)
		local v5, v6 = captureMutationToken() -- inferred equivalent call

		if v5 == nil then
			return Promise.reject(v6)
		end

		return tokenBoundGet(v5, p, id):andThen(function(p2)
			local cause = currentTokenError(v5) -- inferred equivalent call

			if cause == nil then
				return fn(v5, p2)
			end

			return Promise.reject(failedError(id, cause.errorMessage, cause))
		end, function(cause)
			local v7 = (typeof(cause) ~= "table" or typeof(cause.errorMessage) ~= "string")
				and "the subscription could not be read before the write"
				or cause.errorMessage

			return Promise.reject(failedError(id, v7, cause))
		end)
	end

	local function runMutation(p, id: string?, fn)
		local cause = currentTokenError(p) -- inferred equivalent call

		if cause == nil then
			return mutationResult(fn(), id):andThen(function(p2) -- inferred equivalent call
				local cause2 = currentTokenError(p) -- inferred equivalent call

				if cause2 == nil then
					return p2
				end

				local id2 = id
				return (Promise.reject({
					outcome = "unverified",
					errorMessage = "The Developer Subscription request could not be confirmed: the local user changed after the write. Do not automatically retry the write; inspect existing subscriptions first.",
					subscription = p2 or id2 ~= nil and { id = id2 } or nil,
					cause = cause2
				}))
			end)
		end

		return Promise.reject(failedError(id, cause.errorMessage, cause))
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

	local v5 = {
		"description",
		"basePriceId",
		"currencyType",
		"priceInRobux",
		"isRegionalPricingEnabled"
	}

	local function readBackMutation(p, p2: number, id: string, p3, flag: boolean, flag2: boolean?)
		return tokenBoundGet(p, p2, id):andThen(function(data)
			if flag then
				local v6 = p3

				if data.name ~= v6.name then
					local id2 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = "The Developer Subscription request could not be confirmed: the stored name does not match. Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = data or id2 ~= nil and { id = id2 } or nil,
						cause = nil
					})
				end

				if data.productType ~= v6.productType then
					local id2 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = "The Developer Subscription request could not be confirmed: the stored product type does not match. Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = data or id2 ~= nil and { id = id2 } or nil,
						cause = nil
					})
				end

				if data.productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.Inactive then
					local id2 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = "The Developer Subscription request could not be confirmed: the new subscription is not inactive. Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = data or id2 ~= nil and { id = id2 } or nil,
						cause = nil
					})
				end
			end

			for _, v6 in v5 do
				local v7

				if flag2 == true then
					v7 = v6 == "description"
				else
					v7 = false
				end

				if not v7 and p3[v6] ~= nil and data[v6] ~= p3[v6] then
					return Promise.reject(verificationError(id, `the stored {v6} does not match`, data)) -- inferred equivalent call
				end
			end

			return data
		end, function(cause)
			if cause ~= frozen and currentTokenError(p) == nil then -- inferred equivalent call
				local id2 = id
				return Promise.reject({
					outcome = "unverified",
					errorMessage = "The Developer Subscription request could not be confirmed: the authoritative readback failed. Do not automatically retry the write; inspect existing subscriptions first.",
					subscription = id2 ~= nil and { id = id2 } or nil,
					cause = cause
				})
			end

			local id2 = id
			return Promise.reject({
				outcome = "unverified",
				errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
				subscription = id2 ~= nil and { id = id2 } or nil,
				cause = cause
			})
		end)
	end

	local function describeError(cause) -- 1 equivalent call inferred from this helper
		if typeof(cause) == "table" and typeof(cause.errorMessage) == "string" then
			return cause.errorMessage
		end

		return (tostring(cause))
	end

	local function imageBlocker(id: string, cause) -- 2 equivalent calls inferred from this helper
		local productStatusType = cause.productStatusType

		if
			productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Inactive
			or productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Active
			or productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale
		then
			return nil
		end

		return {
			outcome = "failed",
			errorMessage = "The Developer Subscription request was rejected: images can only be changed while a subscription is in a stable state.",
			subscription = id ~= nil and { id = id } or nil,
			cause = cause
		}
	end

	local function sendImage(p, p2: number, p3: string, imageAssetId: number?, p4)
		return runMutation(p, p3, function()
			return fetchDeveloperSubscription.uploadImage(p2, p3, p.userId, p4, v2)
		end):andThen(function()
			return verifyRead(p, function()
				return tokenBoundGet(p, p2, p3)
			end, function(p5): boolean
				return p5.imageAssetId ~= nil and p5.imageAssetId > 0 and p5.imageAssetId ~= imageAssetId
			end, "the uploaded image did not appear in authoritative reads", p3)
		end)
	end

	local function attachImage(p, p2: number, cause2, imageFile, p3: string, p4: string)
		local v6 = imageBlocker(cause2.id, cause2) -- inferred equivalent call
		local v7

		if v6 == nil then
			v7 = sendImage(p, p2, cause2.id, cause2.imageAssetId, imageFile)
		else
			v7 = Promise.reject(v6)
		end

		return v7:catch(function(cause)
			local subscription

			if typeof(cause) == "table" and cause.outcome == "unverified" and cause.subscription ~= nil then
				subscription = cause.subscription
			else
				subscription = cause2
			end

			return Promise.reject({
				outcome = "unverified",
				errorMessage = `{p3}, but its image could not be attached: {describeError(cause)} {p4}`,
				subscription = subscription,
				cause = cause
			}) -- inferred equivalent call
		end)
	end

	local function create(p: number, p2)
		local v6, v7 = captureMutationToken() -- inferred equivalent call

		if v6 == nil then
			return Promise.reject(v7)
		end

		return reconcileMutation(p, runMutation(v6, nil, function()
			return fetchDeveloperSubscription.create(p, p2, v2)
		end):andThen(function(p3)
			return readBackMutation(v6, p, p3.id, p2, true):andThen(function(cause)
				local imageFile = p2.imageFile

				if imageFile == nil then
					return cause
				end

				return attachImage(
					v6,
					p,
					cause,
					imageFile,
					"The subscription was created and is inactive",
					"Do not create it again. Retry only the image with an update action."
				)
			end)
		end))
	end

	local function uploadImage(p: number, id: string, imageFile)
		return reconcileMutation(p, withMutationPreflight(p, id, function(p2, cause)
			local v6 = imageBlocker(id, cause) -- inferred equivalent call

			if v6 == nil then
				return sendImage(p2, p, id, cause.imageAssetId, imageFile)
			end

			return Promise.reject(v6)
		end))
	end

	local function update(p: number, id: string, p2, p3)
		local imageFile = p2.imageFile

		if imageFile ~= nil then
			local v6 = false

			for _, v7 in v5 do
				if p2[v7] ~= nil then
					v6 = true
					break
				end
			end

			if not v6 then
				return uploadImage(p, id, imageFile)
			end
		end

		local v6, v7 = captureMutationToken() -- inferred equivalent call

		if v6 == nil then
			return Promise.reject(v7)
		end

		return reconcileMutation(p, runMutation(v6, id, function()
			return fetchDeveloperSubscription.update(p, id, p2, v2)
		end):andThen(function()
			local v8

			if p3 == nil then
				v8 = false
			else
				v8 = p3.acceptModeratedText == true
			end

			return readBackMutation(v6, p, id, p2, false, v8):andThen(function(cause)
				if imageFile == nil then
					return cause
				end

				return attachImage(
					v6,
					p,
					cause,
					imageFile,
					"The subscription fields were updated",
					"Retry only the image."
				)
			end)
		end))
	end

	local function delete(p: number, p2: string)
		return reconcileMutation(p, withMutationPreflight(p, p2, function(p3, cause)
			if cause.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Inactive then
				return runMutation(p3, p2, function()
					return fetchDeveloperSubscription.delete(p, p2, v2)
				end):andThen(function()
					return tokenBoundGet(p3, p, p2):andThen(function(p4)
						if
							p4.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.ToBeDeleted
							or p4.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Deleted
						then
							return p4
						end

						local id = p2
						return Promise.reject({
							outcome = "unverified",
							errorMessage = "The Developer Subscription request could not be confirmed: the subscription did not enter a deletion state. Do not automatically retry the write; inspect existing subscriptions first.",
							subscription = p4 or id ~= nil and { id = id } or nil,
							cause = nil
						})
					end, function(cause2)
						if cause2 ~= frozen and currentTokenError(p3) == nil then -- inferred equivalent call
							if typeof(cause2) == "table" and cause2.responseCode == StatusCodes.NOT_FOUND then
								return nil
							end

							local id = p2
							return Promise.reject({
								outcome = "unverified",
								errorMessage = "The Developer Subscription request could not be confirmed: the deletion readback failed. Do not automatically retry the write; inspect existing subscriptions first.",
								subscription = id ~= nil and { id = id } or nil,
								cause = cause2
							})
						end

						local id = p2
						return Promise.reject({
							outcome = "unverified",
							errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during deletion readback. Do not automatically retry the write; inspect existing subscriptions first.",
							subscription = id ~= nil and { id = id } or nil,
							cause = cause2
						})
					end)
				end)
			end

			local v6 = cause.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.ToBeDeactivated
				and "Wait for the subscription to become inactive before deleting it"
				or "Deactivate the subscription and wait for it to become inactive before deleting it"

			return Promise.reject(failedError(p2, v6, cause))
		end))
	end

	local function dispose()
		v3 = true
		count += 1
		v4()
		singleEntityResolver.dispose()
	end

	return {
		getSubscriptions = singleEntityResolver.get,
		fetchSubscriptions = singleEntityResolver.fetch,
		getAndFetchSubscriptions = singleEntityResolver.getAndFetch,
		getAccountResetGeneration = singleEntityResolver.getAccountResetGeneration,
		getPermission = function(p: number)
			return fetchDeveloperSubscription.getPermission(p, v2)
		end,
		getPrices = function(p: number)
			return fetchDeveloperSubscription.getPrices(p, v2)
		end,
		list = function(p: number)
			return fetchDeveloperSubscription.list(p, v2)
		end,
		get = function(p: number, p2: string)
			return fetchDeveloperSubscription.get(p, p2, v2)
		end,
		create = create,
		update = update,
		uploadImage = uploadImage,
		activate = function(p: number, p2: string)
			return reconcileMutation(p, withMutationPreflight(p, p2, function(p3, cause)
				if
					cause.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Inactive
					or cause.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale
				then
					return runMutation(p3, p2, function()
						return fetchDeveloperSubscription.activate(p, p2, v2)
					end):andThen(function()
						return verifyRead(p3, function()
							return tokenBoundGet(p3, p, p2)
						end, function(p4): boolean
							return p4.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Active
						end, "the subscription did not become active", p2)
					end)
				end

				local id = p2
				return Promise.reject({
					outcome = "failed",
					errorMessage = "The Developer Subscription request was rejected: only an inactive or off-sale subscription can be activated.",
					subscription = id ~= nil and { id = id } or nil,
					cause = cause
				})
			end))
		end,
		deactivate = function(p: number, id: string, flag: boolean)
			if typeof(flag) == "boolean" then
				return reconcileMutation(p, withMutationPreflight(p, id, function(p2, cause)
					if not flag and cause.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale then
						return Promise.resolve(cause)
					end

					if
						cause.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Active
						or flag and cause.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale
					then
						return runMutation(p2, id, function()
							return fetchDeveloperSubscription.deactivate(p, id, flag, v2)
						end):andThen(function()
							return verifyRead(p2, function()
								return tokenBoundGet(p2, p, id)
							end, function(p3): boolean
								if flag then
									return p3.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.ToBeDeactivated
										or p3.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Inactive
								end

								return p3.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale
							end, flag and "the subscription did not begin deactivation" or "the subscription did not go off sale", id)
						end)
					end

					local id2 = id
					return Promise.reject({
						outcome = "failed",
						errorMessage = "The Developer Subscription request was rejected: the subscription cannot be deactivated from its current state.",
						subscription = id2 ~= nil and { id = id2 } or nil,
						cause = cause
					})
				end))
			end

			return Promise.reject({
				outcome = "failed",
				errorMessage = "The Developer Subscription request was rejected: cancelRenewals must be chosen explicitly.",
				subscription = id ~= nil and { id = id } or nil,
				cause = nil
			})
		end,
		delete = delete,
		clear = function()
			singleEntityResolver.clear()
		end,
		dispose = dispose
	}
end

return createDeveloperSubscriptionStore
