local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local creatorApiHttp = require(DataHydration.creatorApiHttp)
require(script.Parent.DeveloperProductStoreTypes)

local function collectionUrl(p: string, p2: number) -- 3 equivalent calls inferred from this helper
	return ("%s/developer-products/v2/universes/%d/developer-products"):format(p, p2)
end

local function listUrl(p: string, p2: number) -- 1 equivalent call inferred from this helper
	return ("%s/creator"):format(collectionUrl(p, p2))
end

local function getUrl(p: string, p2: number, p3: number) -- 1 equivalent call inferred from this helper
	return ("%s/%d/creator"):format(collectionUrl(p, p2), p3) -- inferred equivalent call
end

local function productUrl(baseUrl: string, p: number, p2: number) -- 2 equivalent calls inferred from this helper
	return ("%s/%d"):format(collectionUrl(baseUrl, p), p2) -- inferred equivalent call
end

local function requestParts(data)
	local parts = {}

	if data.name ~= nil then
		table.insert(parts, { name = "name", value = data.name })
	end

	if data.description ~= nil then
		table.insert(parts, { name = "description", value = data.description })
	end

	if data.priceInRobux ~= nil then
		table.insert(parts, { name = "price", value = tostring(data.priceInRobux) })
	end

	if data.isForSale ~= nil then
		table.insert(parts, { name = "isForSale", value = tostring(data.isForSale) })
	end

	if data.isManagedPricingEnabled ~= nil then
		table.insert(parts, {
			name = "isManagedPricingEnabled",
			value = tostring(data.isManagedPricingEnabled)
		})
	end

	if data.imageFile ~= nil then
		table.insert(parts, {
			name = "imageFile",
			value = data.imageFile.content,
			fileName = data.imageFile.fileName,
			contentType = data.imageFile.contentType
		})
	end

	return parts
end

local jsonDecoder = creatorApiHttp.jsonDecoder(function(p)
	return p
end)

local function synthesizedDecoder(fn)
	return creatorApiHttp.jsonDecoder(function(_)
		return fn()
	end)
end

local FetchDeveloperProduct = {}

local function listPage(p: number, pageToken: string?, p2)
	local v = listUrl(creatorApiHttp.baseUrl(p2), p) -- inferred equivalent call

	local v2 = creatorApiHttp.withQuery(v, { pageToken = pageToken })
	return creatorApiHttp.get(p2, v2, "developer-product.list", function(p3)
		return p3
	end)
end

function FetchDeveloperProduct.list(p: number, p2)
	local developerProducts = {}
	local function fetchNext(pageToken: string?, p3: number)
		return listPage(p, pageToken, p2):andThen(function(p4)
			for _, developerProduct in p4.developerProducts do
				table.insert(developerProducts, developerProduct)
			end

			local nextPageToken = p4.nextPageToken

			if nextPageToken ~= nil and nextPageToken ~= "" and p3 < 50 then
				return fetchNext(nextPageToken, p3 + 1)
			end

			local v = { developerProducts = developerProducts, nextPageToken = 0 }

			if not (p3 >= 50) then
				nextPageToken = nil
			end

			v.nextPageToken = nextPageToken
			return v
		end)
	end

	return fetchNext(nil, 1)
end

function FetchDeveloperProduct.get(p: number, p2: number, p3)
	return creatorApiHttp.get(p3, getUrl(creatorApiHttp.baseUrl(p3), p, p2), "developer-product.get", function(p4) -- inferred equivalent call
		return p4
	end)
end

function FetchDeveloperProduct.create(p: number, data, p2)
	local baseUrl = creatorApiHttp.baseUrl(p2)

	local isForSale = not (data.isForSale == nil) and data.isForSale
	local v = requestParts({
		name = data.name,
		description = data.description,
		priceInRobux = data.priceInRobux,
		isForSale = isForSale,
		isManagedPricingEnabled = data.isManagedPricingEnabled,
		imageFile = data.imageFile
	})

	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p2),
		"POST",
		collectionUrl(baseUrl, p), -- inferred equivalent call
		v,
		"developer-product.create",
		jsonDecoder
	)
end

function FetchDeveloperProduct.update(p: number, productId: number, data, p2)
	local baseUrl = creatorApiHttp.baseUrl(p2)
	local v = requestParts({
		name = data.name,
		description = data.description,
		priceInRobux = data.priceInRobux,
		isForSale = data.isForSale,
		isManagedPricingEnabled = data.isManagedPricingEnabled,
		imageFile = nil
	})

	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p2),
		"PATCH",
		productUrl(baseUrl, p, productId), -- inferred equivalent call
		v,
		"developer-product.update",
		synthesizedDecoder(function()
			return {
				productId = productId,
				name = data.name,
				description = data.description,
				isForSale = data.isForSale,
				isManagedPricingEnabled = data.isManagedPricingEnabled,
				priceInformation = data.priceInRobux ~= nil and {
					defaultPriceInRobux = data.priceInRobux
				} or nil
			}
		end)
	)
end

function FetchDeveloperProduct.setForSale(p: number, productId: number, isForSale: boolean, p2)
	local baseUrl = creatorApiHttp.baseUrl(p2)
	return creatorApiHttp.multipart(creatorApiHttp.mutatingNetwork(p2), "PATCH", productUrl(baseUrl, p, productId), { -- inferred equivalent call
		{ name = "isForSale", value = tostring(isForSale) }
	}, "developer-product.set-for-sale", synthesizedDecoder(function()
		return { productId = productId, isForSale = isForSale }
	end))
end

function FetchDeveloperProduct.activate(p: number, p2: number, p3)
	return FetchDeveloperProduct.setForSale(p, p2, true, p3)
end

function FetchDeveloperProduct.deactivate(p: number, p2: number, p3)
	return FetchDeveloperProduct.setForSale(p, p2, false, p3)
end

return FetchDeveloperProduct
