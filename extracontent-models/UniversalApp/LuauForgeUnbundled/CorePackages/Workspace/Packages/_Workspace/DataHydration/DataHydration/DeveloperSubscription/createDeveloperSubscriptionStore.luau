require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").StatusCodes
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local FFlagDataHydrationPreserveIncompleteCatalogResults = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagDataHydrationPreserveIncompleteCatalogResults")

local FFlagBuildExperienceMonetizationManageKinds = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagBuildExperienceMonetizationManageKinds")
local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")

local fetchDeveloperSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperSubscription/fetchDeveloperSubscription")
local DeveloperSubscriptionTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperSubscription/DeveloperSubscriptionTypes")

local frozen = table.freeze({
	errorMessage = "The local user changed while the Developer Subscription request was running"
})

local function createDeveloperSubscriptionStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }
	local getLocalPlayerUserId = v5.getLocalPlayerUserId or DataHydrationUtils.getLocalPlayerUserId
	local observeLocalPlayerUserId = v5.observeLocalPlayerUserId or DataHydrationUtils.observeLocalPlayerUserId

	local count = 0
	local flag = false
	local function fetchSubscriptions(p2)
		local list = fetchDeveloperSubscription.list(p2, v6)

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

	local v7 = createSingleEntityResolver(fetchSubscriptions, {
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

	local function verificationError(p2, p3, p4, p5)
		return {
			outcome = "unverified",
			errorMessage = `The Developer Subscription request could not be confirmed: {p3}. ` .. "Do not automatically retry the write; inspect existing subscriptions first.",
			subscription = p4 or p2 ~= nil and { id = p2 } or nil,
			cause = p5
		}
	end

	local function failedError(p2, p3, p4)
		return {
			outcome = "failed",
			errorMessage = `The Developer Subscription request was rejected: {p3}.`,
			subscription = p2 ~= nil and { id = p2 } or nil,
			cause = p4
		}
	end

	local function captureMutationToken()
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

	local function isTokenCurrent(p2)
		local v9 = not flag

		if v9 then
			v9 = p2.generation == count and p2.userId == getLocalPlayerUserId()
		end

		return v9
	end

	local function currentTokenError(p2)
		local v9 = not flag

		if v9 then
			v9 = p2.generation == count and p2.userId == getLocalPlayerUserId()
		end

		if v9 then
			return nil
		end

		return frozen
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
		return object:andThen(function(data)
			if data.success then
				return assert(
					data.subscription,
					"A successful Developer Subscription mutation must return its identity"
				)
			end

			return Promise.reject(failedError(
				p2,
				`the service returned failureReason {tostring(data.failureReason)}`,
				data
			))
		end, function(p3)
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

			local v9 = p2
			return Promise.reject({
				outcome = "unverified",
				errorMessage = "The Developer Subscription request could not be confirmed: the write outcome is unknown. Do not automatically retry the write; inspect existing subscriptions first.",
				subscription = v9 ~= nil and { id = v9 } or nil,
				cause = p3
			})
		end)
	end

	local function verifyRead(p2, fn, fn2, p3, p4)
		local v9 = not flag

		if v9 then
			v9 = p2.generation == count and p2.userId == getLocalPlayerUserId()
		end

		local v10 = if not v9 then frozen else nil

		if v10 == nil then
			return fn():andThen(function(p5)
				local v11 = p2
				local v12 = not flag

				if v12 then
					v12 = v11.generation == count and v11.userId == getLocalPlayerUserId()
				end

				local v13 = if not v12 then frozen else nil

				if v13 == nil then
					if fn2(p5) then
						return p5
					end

					local v14 = p4
					return Promise.reject({
						outcome = "unverified",
						errorMessage = `The Developer Subscription request could not be confirmed: {p3}. ` .. "Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = p5 or v14 ~= nil and { id = v14 } or nil,
						cause = nil
					})
				else
					local v14 = p4
					return Promise.reject({
						outcome = "unverified",
						errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = v14 ~= nil and { id = v14 } or nil,
						cause = v13
					})
				end
			end, function(p5)
				if p5 ~= frozen then
					local v11 = p2
					local v12 = not flag

					if v12 then
						v12 = v11.generation == count and v11.userId == getLocalPlayerUserId()
					end

					local v13 = if not v12 then frozen else nil

					if v13 == nil then
						local v14 = p4
						return Promise.reject({
							outcome = "unverified",
							errorMessage = `The Developer Subscription request could not be confirmed: {p3}. ` .. "Do not automatically retry the write; inspect existing subscriptions first.",
							subscription = v14 ~= nil and { id = v14 } or nil,
							cause = p5
						})
					end
				end

				local v11 = p4
				return Promise.reject({
					outcome = "unverified",
					errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
					subscription = v11 ~= nil and { id = v11 } or nil,
					cause = p5
				})
			end)
		end

		return Promise.reject({
			outcome = "unverified",
			errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
			subscription = p4 ~= nil and { id = p4 } or nil,
			cause = v10
		})
	end

	local function tokenBoundGet(p2, p3, p4)
		local v9 = not flag

		if v9 then
			v9 = p2.generation == count and p2.userId == getLocalPlayerUserId()
		end

		local v10 = if not v9 then frozen else nil

		if v10 == nil then
			return fetchDeveloperSubscription.get(p3, p4, v6):andThen(function(p5)
				local v11 = p2
				local v12 = not flag

				if v12 then
					v12 = v11.generation == count and v11.userId == getLocalPlayerUserId()
				end

				local v13 = if not v12 then frozen else nil

				if v13 == nil then
					return p5
				end

				return (Promise.reject(v13))
			end)
		end

		return Promise.reject(v10)
	end

	local function withMutationPreflight(p2, p3, fn)
		local localPlayerUserId = getLocalPlayerUserId()
		local v9, v10

		if localPlayerUserId == nil then
			v9 = nil
			v10 = {
				outcome = "failed",
				errorMessage = "The Developer Subscription request was rejected: a signed-in local user is required.",
				subscription = nil,
				cause = nil
			}
		else
			v9 = { generation = count, userId = localPlayerUserId }
		end

		if v9 == nil then
			return Promise.reject(v10)
		end

		return tokenBoundGet(v9, p2, p3):andThen(function(p4)
			local v11 = v9
			local v12 = not flag

			if v12 then
				v12 = v11.generation == count and v11.userId == getLocalPlayerUserId()
			end

			local v13 = if not v12 then frozen else nil

			if v13 == nil then
				return fn(v9, p4)
			end

			return Promise.reject(failedError(p3, v13.errorMessage, v13))
		end, function(p4)
			local v11 = (typeof(p4) ~= "table" or typeof(p4.errorMessage) ~= "string")
				and "the subscription could not be read before the write"
				or p4.errorMessage

			return Promise.reject(failedError(p3, v11, p4))
		end)
	end

	local function runMutation(p2, p3, fn)
		local v9 = not flag

		if v9 then
			v9 = p2.generation == count and p2.userId == getLocalPlayerUserId()
		end

		local v10 = if not v9 then frozen else nil

		if v10 == nil then
			return fn():andThen(function(data)
				if data.success then
					return assert(
						data.subscription,
						"A successful Developer Subscription mutation must return its identity"
					)
				end

				return Promise.reject(failedError(
					p3,
					`the service returned failureReason {tostring(data.failureReason)}`,
					data
				))
			end, function(p4)
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

				local v11 = p3
				return Promise.reject({
					outcome = "unverified",
					errorMessage = "The Developer Subscription request could not be confirmed: the write outcome is unknown. Do not automatically retry the write; inspect existing subscriptions first.",
					subscription = v11 ~= nil and { id = v11 } or nil,
					cause = p4
				})
			end):andThen(function(p4)
				local v11 = p2
				local v12 = not flag

				if v12 then
					v12 = v11.generation == count and v11.userId == getLocalPlayerUserId()
				end

				local v13 = if not v12 then frozen else nil

				if v13 == nil then
					return p4
				end

				local v14 = p3
				return (Promise.reject({
					outcome = "unverified",
					errorMessage = "The Developer Subscription request could not be confirmed: the local user changed after the write. Do not automatically retry the write; inspect existing subscriptions first.",
					subscription = p4 or v14 ~= nil and { id = v14 } or nil,
					cause = v13
				}))
			end)
		end

		return Promise.reject(failedError(p3, v10.errorMessage, v10))
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

	local v9 = {
		"description",
		"basePriceId",
		"currencyType",
		"priceInRobux",
		"isRegionalPricingEnabled"
	}

	local function readBackMutation(p2, p3, id, p4, p5, p6)
		return tokenBoundGet(p2, p3, id):andThen(function(data)
			if p5 then
				local v10 = p4

				if data.name == v10.name then
					if data.productType == v10.productType then
						if data.productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.Inactive then
							local v11 = id
							return Promise.reject({
								outcome = "unverified",
								errorMessage = "The Developer Subscription request could not be confirmed: the new subscription is not inactive. Do not automatically retry the write; inspect existing subscriptions first.",
								subscription = data or v11 ~= nil and { id = v11 } or nil,
								cause = nil
							})
						end
					else
						local v11 = id
						return Promise.reject({
							outcome = "unverified",
							errorMessage = "The Developer Subscription request could not be confirmed: the stored product type does not match. Do not automatically retry the write; inspect existing subscriptions first.",
							subscription = data or v11 ~= nil and { id = v11 } or nil,
							cause = nil
						})
					end
				else
					local v11 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = "The Developer Subscription request could not be confirmed: the stored name does not match. Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = data or v11 ~= nil and { id = v11 } or nil,
						cause = nil
					})
				end
			end

			for k, v10 in v9 do
				local v11 = p6 == true and v10 == "description"

				if not v11 and p4[v10] ~= nil and data[v10] ~= p4[v10] then
					local v12 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = `The Developer Subscription request could not be confirmed: {`the stored {v10} does not match`}. ` .. "Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = data or v12 ~= nil and { id = v12 } or nil,
						cause = nil
					})
				end
			end

			return data
		end, function(p7)
			if p7 ~= frozen then
				local v10 = p2
				local v11 = not flag

				if v11 then
					v11 = v10.generation == count and v10.userId == getLocalPlayerUserId()
				end

				local v12 = if not v11 then frozen else nil

				if v12 == nil then
					local v13 = id
					return Promise.reject({
						outcome = "unverified",
						errorMessage = "The Developer Subscription request could not be confirmed: the authoritative readback failed. Do not automatically retry the write; inspect existing subscriptions first.",
						subscription = v13 ~= nil and { id = v13 } or nil,
						cause = p7
					})
				end
			end

			local v10 = id
			return Promise.reject({
				outcome = "unverified",
				errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during readback. Do not automatically retry the write; inspect existing subscriptions first.",
				subscription = v10 ~= nil and { id = v10 } or nil,
				cause = p7
			})
		end)
	end

	local function describeError(p2)
		if typeof(p2) == "table" and typeof(p2.errorMessage) == "string" then
			return p2.errorMessage
		end

		return (tostring(p2))
	end

	local function imageBlocker(p2, p3)
		local productStatusType = p3.productStatusType

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
			subscription = p2 ~= nil and { id = p2 } or nil,
			cause = p3
		}
	end

	local function sendImage(p2, p3, p4, imageAssetId, p5)
		return runMutation(p2, p4, function()
			return fetchDeveloperSubscription.uploadImage(p3, p4, p2.userId, p5, v6)
		end):andThen(function()
			return verifyRead(p2, function()
				return tokenBoundGet(p2, p3, p4)
			end, function(p6): boolean
				return p6.imageAssetId ~= nil and p6.imageAssetId > 0 and p6.imageAssetId ~= imageAssetId
			end, "the uploaded image did not appear in authoritative reads", p4)
		end)
	end

	local function attachImage(p2, p3, data, imageFile, p4, p5)
		local id = data.id
		local productStatusType = data.productStatusType
		local v10 = productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.Inactive
			and productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.Active
			and productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.OffSale
			and {
				outcome = "failed",
				errorMessage = "The Developer Subscription request was rejected: images can only be changed while a subscription is in a stable state.",
				subscription = id ~= nil and { id = id } or nil,
				cause = data
			}
			or nil
		local v11

		if v10 == nil then
			v11 = sendImage(p2, p3, data.id, data.imageAssetId, imageFile)
		else
			v11 = Promise.reject(v10)
		end

		return v11:catch(function(cause)
			local v12

			if typeof(cause) == "table" and cause.outcome == "unverified" and cause.subscription ~= nil then
				v12 = cause.subscription
			else
				v12 = data
			end

			local reject = Promise.reject
			local v16

			if typeof(cause) == "table" and typeof(cause.errorMessage) == "string" then
				v16 = cause.errorMessage
			else
				v16 = tostring(cause)
			end

			return reject({
				outcome = "unverified",
				errorMessage = `{p4}, but its image could not be attached: {v16} {p5}`,
				subscription = v12,
				cause = cause
			})
		end)
	end

	local function create(p2, p3)
		local localPlayerUserId = getLocalPlayerUserId()
		local v10, v11

		if localPlayerUserId == nil then
			v10 = nil
			v11 = {
				outcome = "failed",
				errorMessage = "The Developer Subscription request was rejected: a signed-in local user is required.",
				subscription = nil,
				cause = nil
			}
		else
			v10 = { generation = count, userId = localPlayerUserId }
		end

		if v10 == nil then
			return Promise.reject(v11)
		end

		return reconcileMutation(p2, runMutation(v10, nil, function()
			return fetchDeveloperSubscription.create(p2, p3, v6)
		end):andThen(function(p4)
			return readBackMutation(v10, p2, p4.id, p3, true):andThen(function(p5)
				local imageFile = p3.imageFile

				if imageFile == nil then
					return p5
				end

				return attachImage(
					v10,
					p2,
					p5,
					imageFile,
					"The subscription was created and is inactive",
					"Do not create it again. Retry only the image with an update action."
				)
			end)
		end))
	end

	local function uploadImage(p2, p3, imageFile)
		return reconcileMutation(p2, withMutationPreflight(p2, p3, function(p4, p5)
			local v11 = p3
			local productStatusType = p5.productStatusType
			local v12 = productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.Inactive
				and productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.Active
				and productStatusType ~= DeveloperSubscriptionTypes.ProductStatusType.OffSale
				and {
					outcome = "failed",
					errorMessage = "The Developer Subscription request was rejected: images can only be changed while a subscription is in a stable state.",
					subscription = v11 ~= nil and { id = v11 } or nil,
					cause = p5
				}
				or nil

			if v12 == nil then
				return sendImage(p4, p2, p3, p5.imageAssetId, imageFile)
			end

			return Promise.reject(v12)
		end))
	end

	local function update(p2, p3, p4, p5)
		local imageFile = p4.imageFile

		if imageFile ~= nil then
			local v10 = false

			for k, v12 in v9 do
				if p4[v12] ~= nil then
					v10 = true
					break
				end
			end

			if not v10 then
				return uploadImage(p2, p3, imageFile)
			end
		end

		local localPlayerUserId = getLocalPlayerUserId()
		local v10, v11

		if localPlayerUserId == nil then
			v10 = nil
			v11 = {
				outcome = "failed",
				errorMessage = "The Developer Subscription request was rejected: a signed-in local user is required.",
				subscription = nil,
				cause = nil
			}
		else
			v10 = { generation = count, userId = localPlayerUserId }
		end

		if v10 == nil then
			return Promise.reject(v11)
		end

		return reconcileMutation(p2, runMutation(v10, p3, function()
			return fetchDeveloperSubscription.update(p2, p3, p4, v6)
		end):andThen(function()
			local v19 = not (p5 == nil) and p5.acceptModeratedText == true
			return readBackMutation(v10, p2, p3, p4, false, v19):andThen(function(p6)
				if imageFile == nil then
					return p6
				end

				return attachImage(
					v10,
					p2,
					p6,
					imageFile,
					"The subscription fields were updated",
					"Retry only the image."
				)
			end)
		end))
	end

	local function delete(p2, p3)
		return reconcileMutation(p2, withMutationPreflight(p2, p3, function(p4, p5)
			if p5.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Inactive then
				return runMutation(p4, p3, function()
					return fetchDeveloperSubscription.delete(p2, p3, v6)
				end):andThen(function()
					return tokenBoundGet(p4, p2, p3):andThen(function(p6)
						if
							p6.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.ToBeDeleted
							or p6.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Deleted
						then
							return p6
						end

						local v11 = p3
						return Promise.reject({
							outcome = "unverified",
							errorMessage = "The Developer Subscription request could not be confirmed: the subscription did not enter a deletion state. Do not automatically retry the write; inspect existing subscriptions first.",
							subscription = p6 or v11 ~= nil and { id = v11 } or nil,
							cause = nil
						})
					end, function(p6)
						if p6 ~= frozen then
							local v11 = p4
							local v12 = not flag

							if v12 then
								v12 = v11.generation == count and v11.userId == getLocalPlayerUserId()
							end

							local v13 = if not v12 then frozen else nil

							if v13 == nil then
								if typeof(p6) == "table" and p6.responseCode == statusCodes.NOT_FOUND then
									return nil
								end

								local v14 = p3
								return Promise.reject({
									outcome = "unverified",
									errorMessage = "The Developer Subscription request could not be confirmed: the deletion readback failed. Do not automatically retry the write; inspect existing subscriptions first.",
									subscription = v14 ~= nil and { id = v14 } or nil,
									cause = p6
								})
							end
						end

						local v11 = p3
						return Promise.reject({
							outcome = "unverified",
							errorMessage = "The Developer Subscription request could not be confirmed: the local user changed during deletion readback. Do not automatically retry the write; inspect existing subscriptions first.",
							subscription = v11 ~= nil and { id = v11 } or nil,
							cause = p6
						})
					end)
				end)
			end

			local v11 = p5.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.ToBeDeactivated
				and "Wait for the subscription to become inactive before deleting it"
				or "Deactivate the subscription and wait for it to become inactive before deleting it"

			return Promise.reject(failedError(p3, v11, p5))
		end))
	end

	local function dispose()
		flag = true
		count += 1
		v8()
		v7.dispose()
	end

	return {
		getSubscriptions = v7.get,
		fetchSubscriptions = v7.fetch,
		getAndFetchSubscriptions = v7.getAndFetch,
		getAccountResetGeneration = v7.getAccountResetGeneration,
		getPermission = function(p2)
			return fetchDeveloperSubscription.getPermission(p2, v6)
		end,
		getPrices = function(p2)
			return fetchDeveloperSubscription.getPrices(p2, v6)
		end,
		list = function(p2)
			return fetchDeveloperSubscription.list(p2, v6)
		end,
		get = function(p2, p3)
			return fetchDeveloperSubscription.get(p2, p3, v6)
		end,
		create = create,
		update = update,
		uploadImage = uploadImage,
		activate = function(p2, p3)
			return reconcileMutation(p2, withMutationPreflight(p2, p3, function(p4, p5)
				if
					p5.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Inactive
					or p5.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale
				then
					return runMutation(p4, p3, function()
						return fetchDeveloperSubscription.activate(p2, p3, v6)
					end):andThen(function()
						return verifyRead(p4, function()
							return tokenBoundGet(p4, p2, p3)
						end, function(p6): boolean
							return p6.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Active
						end, "the subscription did not become active", p3)
					end)
				end

				local v11 = p3
				return Promise.reject({
					outcome = "failed",
					errorMessage = "The Developer Subscription request was rejected: only an inactive or off-sale subscription can be activated.",
					subscription = v11 ~= nil and { id = v11 } or nil,
					cause = p5
				})
			end))
		end,
		deactivate = function(p2, p3, p4)
			if typeof(p4) ~= "boolean" then
				return Promise.reject({
					outcome = "failed",
					errorMessage = "The Developer Subscription request was rejected: cancelRenewals must be chosen explicitly.",
					subscription = p3 ~= nil and { id = p3 } or nil,
					cause = nil
				})
			end

			return reconcileMutation(p2, withMutationPreflight(p2, p3, function(p5, p6)
				if not p4 and p6.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale then
					return Promise.resolve(p6)
				end

				if
					p6.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Active
					or p4 and p6.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale
				then
					return runMutation(p5, p3, function()
						return fetchDeveloperSubscription.deactivate(p2, p3, p4, v6)
					end):andThen(function()
						return verifyRead(p5, function()
							return tokenBoundGet(p5, p2, p3)
						end, function(p7): boolean
							if p4 then
								return p7.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.ToBeDeactivated
									or p7.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.Inactive
							end

							return p7.productStatusType == DeveloperSubscriptionTypes.ProductStatusType.OffSale
						end, p4 and "the subscription did not begin deactivation" or "the subscription did not go off sale", p3)
					end)
				end

				local v11 = p3
				return Promise.reject({
					outcome = "failed",
					errorMessage = "The Developer Subscription request was rejected: the subscription cannot be deactivated from its current state.",
					subscription = v11 ~= nil and { id = v11 } or nil,
					cause = p6
				})
			end))
		end,
		delete = delete,
		clear = function()
			v7.clear()
		end,
		dispose = dispose
	}
end

return createDeveloperSubscriptionStore
