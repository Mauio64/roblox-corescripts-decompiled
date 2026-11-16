require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local fetchDeveloperProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperProduct/fetchDeveloperProduct")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperProduct/DeveloperProductStoreTypes")

local function createDeveloperProductStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createSingleEntityResolver(function(p2)
		return fetchDeveloperProduct.list(p2, v6)
	end)

	local function imageVerificationError(p2, p3)
		return {
			errorMessage = ("Developer product %s was created, but its uploaded image could not be verified because %s. Do not create another product; inspect the existing product before retrying."):format(
				tostring(p2.productId),
				p3
			),
			product = p2
		}
	end

	local function readBackMutation(p2, p3, p4, p5)
		local v8 = fetchDeveloperProduct.get(p2, p3.productId, v6)
		local v9

		if p4 == nil then
			v9 = v8:catch(function()
				if not p5 then
					return p3
				end

				v7.fetch(p2)
				return Promise.reject({
					errorMessage = "The developer product update may have saved, but its text could not be verified because the follow-up read failed. List the product before retrying.",
					product = { productId = p3.productId },
					outcome = "unverified"
				})
			end)
		else
			v9 = v8:catch(function()
				local v10 = p3
				return Promise.reject({
					errorMessage = ("Developer product %s was created, but its uploaded image could not be verified because %s. Do not create another product; inspect the existing product before retrying."):format(
						tostring(v10.productId),
						"the product could not be read back"
					),
					product = v10
				})
			end)
		end

		return v9:andThen(function(p6)
			v7.fetch(p2)

			if p4 == nil or p6.iconImageAssetId == p4 then
				return p6
			end

			local v10 = p3
			return Promise.reject({
				errorMessage = ("Developer product %s was created, but its uploaded image could not be verified because %s. Do not create another product; inspect the existing product before retrying."):format(
					tostring(v10.productId),
					"the stored icon did not match the returned icon"
				),
				product = v10
			})
		end)
	end

	return {
		getProducts = v7.get,
		fetchProducts = v7.fetch,
		getAndFetchProducts = v7.getAndFetch,
		getAccountResetGeneration = v7.getAccountResetGeneration,
		list = function(p2)
			return fetchDeveloperProduct.list(p2, v6):andThen(function(p3)
				v7.update(p2, p3)
				return p3
			end)
		end,
		get = function(p2, p3)
			return fetchDeveloperProduct.get(p2, p3, v6)
		end,
		create = function(p2, p3)
			return fetchDeveloperProduct.create(p2, p3, v6):andThen(function(p4)
				if p3.imageFile ~= nil and p4.iconImageAssetId == nil then
					return Promise.reject({
						errorMessage = ("Developer product %s was created, but its uploaded image could not be verified because %s. Do not create another product; inspect the existing product before retrying."):format(
							tostring(p4.productId),
							"the API did not return an image asset ID"
						),
						product = p4
					})
				end

				local v10 = if p3.imageFile ~= nil then p4.iconImageAssetId else nil
				return readBackMutation(p2, p4, v10)
			end)
		end,
		update = function(p2, p3, p4, p5)
			return fetchDeveloperProduct.update(p2, p3, p4, v6):andThen(function(p6)
				return readBackMutation(p2, p6, nil, p5)
			end)
		end,
		activate = function(p2, p3)
			return fetchDeveloperProduct.activate(p2, p3, v6):andThen(function(p4)
				return readBackMutation(p2, p4)
			end)
		end,
		deactivate = function(p2, p3)
			return fetchDeveloperProduct.deactivate(p2, p3, v6):andThen(function(p4)
				return readBackMutation(p2, p4)
			end)
		end,
		clear = function()
			v7.clear()
		end,
		dispose = function()
			v7.dispose()
		end
	}
end

return createDeveloperProductStore
