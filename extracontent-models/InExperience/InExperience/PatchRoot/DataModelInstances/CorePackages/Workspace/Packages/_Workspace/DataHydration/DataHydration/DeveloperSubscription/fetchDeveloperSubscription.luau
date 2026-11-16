local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local creatorApiHttp = require(DataHydration.creatorApiHttp)
require(script.Parent.DeveloperSubscriptionTypes)

local function collectionUrl(p: string, p2: number) -- 3 equivalent calls inferred from this helper
	return ("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(p, p2)
end

local function subscriptionUrl(p: string, p2: number, p3: string) -- 3 equivalent calls inferred from this helper
	return ("%s/%s"):format(collectionUrl(p, p2), p3) -- inferred equivalent call
end

local function normalize(p) -- 3 equivalent calls inferred from this helper
	local clone = table.clone(p)

	if clone.productType == nil and clone.developerSubscriptionProductType ~= nil then
		clone.productType = clone.developerSubscriptionProductType
		clone.developerSubscriptionProductType = nil
	end

	local v = typeof(clone.id) == "string" and clone.id ~= ""
	assert(v, "Invalid Developer Subscription ID")
	return clone
end

local function successDecoder(callback)
	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p)
		return p
	end)

	return function(p)
		local v, v2, v3 = jsonDecoder(p)

		if v2 ~= nil then
			return nil, v2, v3
		end

		assert(typeof(v.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v4 = {
			success = v.success,
			responseCode = p.statusCode,
			failureReason = v.failureReason,
			subscription = 0
		}
		local subscription

		if v.success then
			subscription = callback()
		end

		v4.subscription = subscription

		return v4, nil, nil
	end
end

local function imageSuccessDecoder(id: string)
	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p)
		return p
	end)

	return function(p)
		local v, v2, v3 = jsonDecoder(p)

		if v2 ~= nil then
			return nil, v2, v3
		end

		assert(typeof(v) == "table", "Invalid Developer Subscription image upload response")

		assert(typeof(v.status) == "boolean", "Invalid Developer Subscription image upload status")
		return {
			success = v.status,
			responseCode = p.statusCode,
			subscription = v.status and { id = id } or nil
		}, nil, nil
	end
end

local function fn(p)
	local v, v2, v3 = creatorApiHttp.jsonDecoder(function(p2)
		return p2
	end)(p)

	if v2 ~= nil then
		return nil, v2, v3
	end

	if v.success == false then
		return { success = false, responseCode = p.statusCode, failureReason = v.failureReason }, nil, nil
	end

	return {
		success = true,
		responseCode = p.statusCode,
		subscription = normalize(v.developerSubscription) -- inferred equivalent call
	}, nil, nil
end

local FetchDeveloperSubscription = {}

function FetchDeveloperSubscription.getPermission(p: number, p2)
	return creatorApiHttp.get(
		p2,
		("%s/permission"):format(collectionUrl(creatorApiHttp.baseUrl(p2), p)),
		"developer-subscription.permission",
		function(p3)
			return {
				canEdit = p3.canUserEditExperienceSubscription == true
			}
		end
	)
end

function FetchDeveloperSubscription.getPrices(p: number, p2)
	return creatorApiHttp.get(
		p2,
		("%s/prices"):format(collectionUrl(creatorApiHttp.baseUrl(p2), p)),
		"developer-subscription.prices",
		function(p3)
			return {
				priceTierPrices = p3.priceTierPrices or {}
			}
		end
	)
end

local function listPage(p: number, cursor: string?, p2)
	local v = creatorApiHttp.withQuery(collectionUrl(creatorApiHttp.baseUrl(p2), p), { -- inferred equivalent call
		cursor = cursor,
		resultsPerPage = "50"
	})

	return creatorApiHttp.get(p2, v, "developer-subscription.list", function(data)
		return {
			developerSubscriptions = data.developerSubscriptions or {},
			nextCursor = data.nextCursor,
			hasMoreResults = data.hasMoreResults == true
		}
	end)
end

function FetchDeveloperSubscription.list(p: number, p2)
	local developerSubscriptions = {}
	local nextCursorSet = {}
	local idSet = {}
	local function fetchNext(cursor: string?, p3: number)
		return listPage(p, cursor, p2):andThen(function(data)
			for _, developerSubscription in data.developerSubscriptions do
				local clone = normalize(developerSubscription) -- inferred equivalent call
				assert(
					clone.universeId == nil or clone.universeId == p,
					"Developer Subscription list contains an item from another universe"
				)

				assert(not idSet[clone.id], "Developer Subscription list contains a duplicate ID")
				idSet[clone.id] = true
				table.insert(developerSubscriptions, clone)
			end

			local nextCursor = data.nextCursor

			if not data.hasMoreResults then
				return { developerSubscriptions = developerSubscriptions }
			end

			if nextCursor == nil or nextCursor == "" then
				return Promise.reject({
					code = "IncompleteDeveloperSubscriptionList",
					message = "The service reported another page without a cursor",
					developerSubscriptions = developerSubscriptions
				})
			end

			if nextCursorSet[nextCursor] or p3 >= 50 then
				return Promise.reject({
					code = "IncompleteDeveloperSubscriptionList",
					message = nextCursorSet[nextCursor] and "Repeated cursor" or "Page limit reached",
					developerSubscriptions = developerSubscriptions,
					nextCursor = nextCursor
				})
			end

			nextCursorSet[nextCursor] = true
			return fetchNext(nextCursor, p3 + 1)
		end)
	end

	return fetchNext(nil, 1)
end

function FetchDeveloperSubscription.get(p: number, p2: string, p3)
	return creatorApiHttp.get(
		p3,
		subscriptionUrl(creatorApiHttp.baseUrl(p3), p, p2), -- inferred equivalent call
		"developer-subscription.get",
		function(p4)
			local clone = normalize(p4) -- inferred equivalent call
			assert(clone.id == p2, "Developer Subscription response ID does not match the requested ID")

			assert(
				clone.universeId == nil or clone.universeId == p,
				"Developer Subscription response universe does not match the requested universe"
			)

			return clone
		end
	)
end

function FetchDeveloperSubscription.create(p: number, data, p2)
	return creatorApiHttp.json(
		creatorApiHttp.mutatingNetwork(p2),
		"POST",
		collectionUrl(creatorApiHttp.baseUrl(p2), p), -- inferred equivalent call
		{
			productName = data.name,
			productDescription = data.description,
			productType = data.productType,
			basePriceId = data.basePriceId,
			currencyType = data.currencyType,
			priceInRobux = data.priceInRobux,
			isRegionalPricingEnabled = data.isRegionalPricingEnabled
		},
		"developer-subscription.create",
		fn
	)
end

function FetchDeveloperSubscription.update(p: number, id: string, data, p2)
	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p2)

	local v = subscriptionUrl(creatorApiHttp.baseUrl(p2), p, id) -- inferred equivalent call
	local v2 = {
		description = data.description,
		basePriceId = data.basePriceId,
		currencyType = data.currencyType,
		priceInRobux = data.priceInRobux,
		isRegionalPricingEnabled = data.isRegionalPricingEnabled
	}

	local function fn2()
		return {
			id = id,
			description = data.description,
			basePriceId = data.basePriceId,
			priceInRobux = data.priceInRobux
		}
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p3)
		return p3
	end)

	return json(mutatingNetwork, "PATCH", v, v2, "developer-subscription.update", function(p3)
		local v3, v4, v5 = jsonDecoder(p3)

		if v4 ~= nil then
			return nil, v4, v5
		end

		assert(typeof(v3.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v6 = {
			success = v3.success,
			responseCode = p3.statusCode,
			failureReason = v3.failureReason,
			subscription = 0
		}
		local subscription

		if v3.success then
			subscription = fn2()
		end

		v6.subscription = subscription

		return v6, nil, nil
	end)
end

function FetchDeveloperSubscription.uploadImage(p: number, id: string, p2: number, p3, p4)
	local multipart = creatorApiHttp.multipart
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p4)

	local formatted = ("%s/upload-image"):format(subscriptionUrl(creatorApiHttp.baseUrl(p4), p, id))
	local v = {
		{ name = "ActingUserId", value = tostring(p2) },
		creatorApiHttp.imagePart(p3)
	}
	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p5)
		return p5
	end)

	return multipart(mutatingNetwork, "POST", formatted, v, "developer-subscription.upload-image", function(p5)
		local v2, v3, v4 = jsonDecoder(p5)

		if v3 ~= nil then
			return nil, v3, v4
		end

		assert(typeof(v2) == "table", "Invalid Developer Subscription image upload response")

		assert(typeof(v2.status) == "boolean", "Invalid Developer Subscription image upload status")
		return {
			success = v2.status,
			responseCode = p5.statusCode,
			subscription = v2.status and { id = id } or nil
		}, nil, nil
	end)
end

function FetchDeveloperSubscription.activate(p: number, id: string, p2)
	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p2)

	local formatted = ("%s/activate"):format(subscriptionUrl(creatorApiHttp.baseUrl(p2), p, id))

	local function fn2()
		return { id = id }
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p3)
		return p3
	end)

	return json(mutatingNetwork, "POST", formatted, nil, "developer-subscription.activate", function(p3)
		local v, v2, v3 = jsonDecoder(p3)

		if v2 ~= nil then
			return nil, v2, v3
		end

		assert(typeof(v.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v4 = {
			success = v.success,
			responseCode = p3.statusCode,
			failureReason = v.failureReason,
			subscription = 0
		}
		local subscription

		if v.success then
			subscription = fn2()
		end

		v4.subscription = subscription

		return v4, nil, nil
	end)
end

function FetchDeveloperSubscription.deactivate(p: number, id: string, flag: boolean, p2)
	local v = creatorApiHttp.withQuery(("%s/deactivate"):format(subscriptionUrl(creatorApiHttp.baseUrl(p2), p, id)), {
		cancelRenewals = tostring(flag)
	})

	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p2)

	local function fn2()
		return { id = id }
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p3)
		return p3
	end)

	return json(mutatingNetwork, "POST", v, nil, "developer-subscription.deactivate", function(p3)
		local v2, v3, v4 = jsonDecoder(p3)

		if v3 ~= nil then
			return nil, v3, v4
		end

		assert(typeof(v2.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v5 = {
			success = v2.success,
			responseCode = p3.statusCode,
			failureReason = v2.failureReason,
			subscription = 0
		}
		local subscription

		if v2.success then
			subscription = fn2()
		end

		v5.subscription = subscription

		return v5, nil, nil
	end)
end

function FetchDeveloperSubscription.delete(p: number, id: string, p2)
	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p2)

	local v = subscriptionUrl(creatorApiHttp.baseUrl(p2), p, id) -- inferred equivalent call

	local function fn2()
		return { id = id }
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p3)
		return p3
	end)

	return json(mutatingNetwork, "DELETE", v, nil, "developer-subscription.delete", function(p3)
		local v2, v3, v4 = jsonDecoder(p3)

		if v3 ~= nil then
			return nil, v3, v4
		end

		assert(typeof(v2.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v5 = {
			success = v2.success,
			responseCode = p3.statusCode,
			failureReason = v2.failureReason,
			subscription = 0
		}
		local subscription

		if v2.success then
			subscription = fn2()
		end

		v5.subscription = subscription

		return v5, nil, nil
	end)
end

return FetchDeveloperSubscription
