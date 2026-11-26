local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local creatorApiHttp = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/creatorApiHttp")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperSubscription/DeveloperSubscriptionTypes")

local function collectionUrl(p2, p3)
	return ("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(p2, p3)
end

local function subscriptionUrl(p2, p3, p4)
	return ("%s/%s"):format(
		("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(p2, p3),
		p4
	)
end

local function normalize(p2)
	local clone = table.clone(p2)

	if clone.productType == nil and clone.developerSubscriptionProductType ~= nil then
		clone.productType = clone.developerSubscriptionProductType
		clone.developerSubscriptionProductType = nil
	end

	local v5 = typeof(clone.id) == "string" and clone.id ~= ""
	assert(v5, "Invalid Developer Subscription ID")
	return clone
end

local function successDecoder(callback)
	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p2)
		return p2
	end)

	return function(p2)
		local v5, v6, v7 = jsonDecoder(p2)

		if v6 ~= nil then
			return nil, v6, v7
		end

		assert(typeof(v5.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v8 = {
			success = v5.success,
			responseCode = p2.statusCode,
			failureReason = v5.failureReason,
			subscription = 0
		}
		local v9 = if v5.success then callback() else nil
		v8.subscription = v9

		return v8, nil, nil
	end
end

local function imageSuccessDecoder(p2)
	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p3)
		return p3
	end)

	return function(p3)
		local v5, v6, v7 = jsonDecoder(p3)

		if v6 ~= nil then
			return nil, v6, v7
		end

		assert(typeof(v5) == "table", "Invalid Developer Subscription image upload response")

		assert(typeof(v5.status) == "boolean", "Invalid Developer Subscription image upload status")
		return {
			success = v5.status,
			responseCode = p3.statusCode,
			subscription = v5.status and { id = p2 } or nil
		}, nil, nil
	end
end

local function fn(p2)
	local v5, v6, v7 = creatorApiHttp.jsonDecoder(function(p3)
		return p3
	end)(p2)

	if v6 ~= nil then
		return nil, v6, v7
	end

	if v5.success == false then
		return {
			success = false,
			responseCode = p2.statusCode,
			failureReason = v5.failureReason
		}, nil, nil
	end

	local v8 = { success = true, responseCode = p2.statusCode, subscription = 0 }
	local developerSubscription = v5.developerSubscription
	local clone = table.clone(developerSubscription)

	if clone.productType == nil and clone.developerSubscriptionProductType ~= nil then
		clone.productType = clone.developerSubscriptionProductType
		clone.developerSubscriptionProductType = nil
	end

	local v9 = typeof(clone.id) == "string" and clone.id ~= ""
	assert(v9, "Invalid Developer Subscription ID")

	v8.subscription = clone

	return v8, nil, nil
end

local v5 = {}

function v5.getPermission(p2, p3)
	return creatorApiHttp.get(
		p3,
		("%s/permission"):format(collectionUrl(creatorApiHttp.baseUrl(p3), p2)),
		"developer-subscription.permission",
		function(p4)
			return {
				canEdit = p4.canUserEditExperienceSubscription == true
			}
		end
	)
end

function v5.getPrices(p2, p3)
	return creatorApiHttp.get(
		p3,
		("%s/prices"):format(collectionUrl(creatorApiHttp.baseUrl(p3), p2)),
		"developer-subscription.prices",
		function(p4)
			return {
				priceTierPrices = p4.priceTierPrices or {}
			}
		end
	)
end

local function listPage(p2, p3, p4)
	local v6 = creatorApiHttp.withQuery(
		("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(
			creatorApiHttp.baseUrl(p4),
			p2
		),
		{ cursor = p3, resultsPerPage = "50" }
	)

	return creatorApiHttp.get(p4, v6, "developer-subscription.list", function(data)
		return {
			developerSubscriptions = data.developerSubscriptions or {},
			nextCursor = data.nextCursor,
			hasMoreResults = data.hasMoreResults == true
		}
	end)
end

function v5.list(p2, p3)
	local clones = {}
	local nextCursorSet = {}
	local idSet = {}
	local function fetchNext(p4, p5)
		return listPage(p2, p4, p3):andThen(function(data)
			for k, developerSubscription in data.developerSubscriptions do
				local clone = table.clone(developerSubscription)

				if clone.productType == nil and clone.developerSubscriptionProductType ~= nil then
					clone.productType = clone.developerSubscriptionProductType
					clone.developerSubscriptionProductType = nil
				end

				local v6 = typeof(clone.id) == "string" and clone.id ~= ""
				assert(v6, "Invalid Developer Subscription ID")

				assert(
					clone.universeId == nil or clone.universeId == p2,
					"Developer Subscription list contains an item from another universe"
				)

				assert(not idSet[clone.id], "Developer Subscription list contains a duplicate ID")
				idSet[clone.id] = true
				table.insert(clones, clone)
			end

			local nextCursor = data.nextCursor

			if not data.hasMoreResults then
				return { developerSubscriptions = clones }
			end

			if nextCursor == nil or nextCursor == "" then
				return Promise.reject({
					code = "IncompleteDeveloperSubscriptionList",
					message = "The service reported another page without a cursor",
					developerSubscriptions = clones
				})
			end

			if nextCursorSet[nextCursor] or p5 >= 50 then
				return Promise.reject({
					code = "IncompleteDeveloperSubscriptionList",
					message = nextCursorSet[nextCursor] and "Repeated cursor" or "Page limit reached",
					developerSubscriptions = clones,
					nextCursor = nextCursor
				})
			end

			nextCursorSet[nextCursor] = true
			return fetchNext(nextCursor, p5 + 1)
		end)
	end

	return fetchNext(nil, 1)
end

function v5.get(p2, p3, p4)
	return creatorApiHttp.get(
		p4,
		("%s/%s"):format(
			("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(
				creatorApiHttp.baseUrl(p4),
				p2
			),
			p3
		),
		"developer-subscription.get",
		function(p5)
			local clone = table.clone(p5)

			if clone.productType == nil and clone.developerSubscriptionProductType ~= nil then
				clone.productType = clone.developerSubscriptionProductType
				clone.developerSubscriptionProductType = nil
			end

			local v6 = typeof(clone.id) == "string" and clone.id ~= ""
			assert(v6, "Invalid Developer Subscription ID")

			assert(clone.id == p3, "Developer Subscription response ID does not match the requested ID")

			assert(
				clone.universeId == nil or clone.universeId == p2,
				"Developer Subscription response universe does not match the requested universe"
			)

			return clone
		end
	)
end

function v5.create(p2, data, p3)
	return creatorApiHttp.json(
		creatorApiHttp.mutatingNetwork(p3),
		"POST",
		("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(
			creatorApiHttp.baseUrl(p3),
			p2
		),
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

function v5.update(p2, p3, data, p4)
	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p4)
	local formatted = ("%s/%s"):format(
		("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(
			creatorApiHttp.baseUrl(p4),
			p2
		),
		p3
	)
	local v6 = {
		description = data.description,
		basePriceId = data.basePriceId,
		currencyType = data.currencyType,
		priceInRobux = data.priceInRobux,
		isRegionalPricingEnabled = data.isRegionalPricingEnabled
	}

	local function fn2()
		return {
			id = p3,
			description = data.description,
			basePriceId = data.basePriceId,
			priceInRobux = data.priceInRobux
		}
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p5)
		return p5
	end)

	return json(mutatingNetwork, "PATCH", formatted, v6, "developer-subscription.update", function(p5)
		local v7, v8, v9 = jsonDecoder(p5)

		if v8 ~= nil then
			return nil, v8, v9
		end

		assert(typeof(v7.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v10 = {
			success = v7.success,
			responseCode = p5.statusCode,
			failureReason = v7.failureReason,
			subscription = 0
		}
		local v11 = if v7.success then fn2() else nil
		v10.subscription = v11

		return v10, nil, nil
	end)
end

function v5.uploadImage(p2, p3, p4, p5, p6)
	local multipart = creatorApiHttp.multipart
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p6)

	local formatted = ("%s/upload-image"):format(subscriptionUrl(creatorApiHttp.baseUrl(p6), p2, p3))
	local v6 = {
		{ name = "ActingUserId", value = tostring(p4) },
		creatorApiHttp.imagePart(p5)
	}
	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p7)
		return p7
	end)

	return multipart(
		mutatingNetwork,
		"POST",
		formatted,
		v6,
		"developer-subscription.upload-image",
		function(p7)
			local v7, v8, v9 = jsonDecoder(p7)

			if v8 ~= nil then
				return nil, v8, v9
			end

			assert(typeof(v7) == "table", "Invalid Developer Subscription image upload response")

			assert(typeof(v7.status) == "boolean", "Invalid Developer Subscription image upload status")
			return {
				success = v7.status,
				responseCode = p7.statusCode,
				subscription = v7.status and { id = p3 } or nil
			}, nil, nil
		end
	)
end

function v5.activate(p2, p3, p4)
	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p4)

	local formatted = ("%s/activate"):format(subscriptionUrl(creatorApiHttp.baseUrl(p4), p2, p3))

	local function fn2()
		return { id = p3 }
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p5)
		return p5
	end)

	return json(mutatingNetwork, "POST", formatted, nil, "developer-subscription.activate", function(p5)
		local v6, v7, v8 = jsonDecoder(p5)

		if v7 ~= nil then
			return nil, v7, v8
		end

		assert(typeof(v6.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v9 = {
			success = v6.success,
			responseCode = p5.statusCode,
			failureReason = v6.failureReason,
			subscription = 0
		}
		local v10 = if v6.success then fn2() else nil
		v9.subscription = v10

		return v9, nil, nil
	end)
end

function v5.deactivate(p2, p3, p4, p5)
	local v6 = creatorApiHttp.withQuery(("%s/deactivate"):format(subscriptionUrl(creatorApiHttp.baseUrl(p5), p2, p3)), {
		cancelRenewals = tostring(p4)
	})

	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p5)

	local function fn2()
		return { id = p3 }
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p6)
		return p6
	end)

	return json(mutatingNetwork, "POST", v6, nil, "developer-subscription.deactivate", function(p6)
		local v7, v8, v9 = jsonDecoder(p6)

		if v8 ~= nil then
			return nil, v8, v9
		end

		assert(typeof(v7.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v10 = {
			success = v7.success,
			responseCode = p6.statusCode,
			failureReason = v7.failureReason,
			subscription = 0
		}
		local v11 = if v7.success then fn2() else nil
		v10.subscription = v11

		return v10, nil, nil
	end)
end

function v5.delete(p2, p3, p4)
	local json = creatorApiHttp.json
	local mutatingNetwork = creatorApiHttp.mutatingNetwork(p4)
	local formatted = ("%s/%s"):format(
		("%s/experience-subscriptions/v1/experiences/%d/experience-subscriptions"):format(
			creatorApiHttp.baseUrl(p4),
			p2
		),
		p3
	)

	local function fn2()
		return { id = p3 }
	end

	local jsonDecoder = creatorApiHttp.jsonDecoder(function(p5)
		return p5
	end)

	return json(mutatingNetwork, "DELETE", formatted, nil, "developer-subscription.delete", function(p5)
		local v6, v7, v8 = jsonDecoder(p5)

		if v7 ~= nil then
			return nil, v7, v8
		end

		assert(typeof(v6.success) == "boolean", "Invalid Developer Subscription mutation success")
		local v9 = {
			success = v6.success,
			responseCode = p5.statusCode,
			failureReason = v6.failureReason,
			subscription = 0
		}
		local v10 = if v6.success then fn2() else nil
		v9.subscription = v10

		return v9, nil, nil
	end)
end

return v5
