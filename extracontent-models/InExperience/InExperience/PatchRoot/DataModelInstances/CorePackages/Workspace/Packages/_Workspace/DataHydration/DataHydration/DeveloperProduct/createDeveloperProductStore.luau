local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)
local Promise = require(parent.Promise)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchDeveloperProduct = require(script.Parent.fetchDeveloperProduct)
require(script.Parent.DeveloperProductStoreTypes)

local function createDeveloperProductStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchDeveloperProduct.list(p, v2)
	end)

	local function imageVerificationError(product, p: string) -- 3 equivalent calls inferred from this helper
		return {
			errorMessage = ("Developer product %s was created, but its uploaded image could not be verified because %s. Do not create another product; inspect the existing product before retrying."):format(
				tostring(product.productId),
				p
			),
			product = product
		}
	end

	local function readBackMutation(p: number, product, p2: number?, flag: boolean?)
		local v3 = fetchDeveloperProduct.get(p, product.productId, v2)
		local v4

		if p2 == nil then
			v4 = v3:catch(function()
				if not flag then
					return product
				end

				singleEntityResolver.fetch(p)
				return Promise.reject({
					errorMessage = "The developer product update may have saved, but its text could not be verified because the follow-up read failed. List the product before retrying.",
					product = { productId = product.productId },
					outcome = "unverified"
				})
			end)
		else
			v4 = v3:catch(function()
				return Promise.reject(imageVerificationError(product, "the product could not be read back")) -- inferred equivalent call
			end)
		end

		return v4:andThen(function(p3)
			singleEntityResolver.fetch(p)

			if p2 == nil or p3.iconImageAssetId == p2 then
				return p3
			end

			return Promise.reject(imageVerificationError(product, "the stored icon did not match the returned icon")) -- inferred equivalent call
		end)
	end

	return {
		getProducts = singleEntityResolver.get,
		fetchProducts = singleEntityResolver.fetch,
		getAndFetchProducts = singleEntityResolver.getAndFetch,
		getAccountResetGeneration = singleEntityResolver.getAccountResetGeneration,
		list = function(p: number)
			return fetchDeveloperProduct.list(p, v2):andThen(function(p2)
				singleEntityResolver.update(p, p2)
				return p2
			end)
		end,
		get = function(p: number, p2: number)
			return fetchDeveloperProduct.get(p, p2, v2)
		end,
		create = function(p: number, p2)
			return fetchDeveloperProduct.create(p, p2, v2):andThen(function(product)
				if p2.imageFile ~= nil and product.iconImageAssetId == nil then
					return Promise.reject(imageVerificationError(product, "the API did not return an image asset ID")) -- inferred equivalent call
				end

				local v3

				if p2.imageFile ~= nil then
					v3 = product.iconImageAssetId
				end

				return readBackMutation(p, product, v3)
			end)
		end,
		update = function(p: number, p2: number, p3, flag: boolean?)
			return fetchDeveloperProduct.update(p, p2, p3, v2):andThen(function(product)
				return readBackMutation(p, product, nil, flag)
			end)
		end,
		activate = function(p: number, p2: number)
			return fetchDeveloperProduct.activate(p, p2, v2):andThen(function(p3)
				return readBackMutation(p, p3)
			end)
		end,
		deactivate = function(p: number, p2: number)
			return fetchDeveloperProduct.deactivate(p, p2, v2):andThen(function(p3)
				return readBackMutation(p, p3)
			end)
		end,
		clear = function()
			singleEntityResolver.clear()
		end,
		dispose = function()
			singleEntityResolver.dispose()
		end
	}
end

return createDeveloperProductStore
