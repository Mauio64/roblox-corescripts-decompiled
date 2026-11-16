require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local creatorApiHttp = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/creatorApiHttp")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperProduct/DeveloperProductStoreTypes")

local function collectionUrl(p2, p3)
	return ("%s/developer-products/v2/universes/%d/developer-products"):format(p2, p3)
end

local function listUrl(p2, p3)
	return ("%s/creator"):format(collectionUrl(p2, p3))
end

local function getUrl(p2, p3, p4)
	return ("%s/%d/creator"):format(
		("%s/developer-products/v2/universes/%d/developer-products"):format(p2, p3),
		p4
	)
end

local function productUrl(p2, p3, p4)
	return ("%s/%d"):format(("%s/developer-products/v2/universes/%d/developer-products"):format(p2, p3), p4)
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

local jsonDecoder = creatorApiHttp.jsonDecoder(function(p2)
	return p2
end)

local function synthesizedDecoder(fn)
	return creatorApiHttp.jsonDecoder(function(p2)
		return fn()
	end)
end

local v5 = {}

local function listPage(p2, p3, p4)
	local formatted = ("%s/creator"):format(collectionUrl(creatorApiHttp.baseUrl(p4), p2))

	local v6 = creatorApiHttp.withQuery(formatted, { pageToken = p3 })
	return creatorApiHttp.get(p4, v6, "developer-product.list", function(p5)
		return p5
	end)
end

function v5.list(p2, p3)
	local developerProducts = {}
	local function fetchNext(p4, p5)
		return listPage(p2, p4, p3):andThen(function(p6)
			for k, developerProduct in p6.developerProducts do
				table.insert(developerProducts, developerProduct)
			end

			local nextPageToken = p6.nextPageToken

			if nextPageToken ~= nil and nextPageToken ~= "" and p5 < 50 then
				return fetchNext(nextPageToken, p5 + 1)
			end

			local v6 = { developerProducts = developerProducts, nextPageToken = 0 }

			if not (p5 >= 50) then
				nextPageToken = nil
			end

			v6.nextPageToken = nextPageToken
			return v6
		end)
	end

	return fetchNext(nil, 1)
end

function v5.get(p2, p3, p4)
	return creatorApiHttp.get(
		p4,
		("%s/%d/creator"):format(
			("%s/developer-products/v2/universes/%d/developer-products"):format(creatorApiHttp.baseUrl(p4), p2),
			p3
		),
		"developer-product.get",
		function(p5)
			return p5
		end
	)
end

function v5.create(p2, data, p3)
	local baseUrl = creatorApiHttp.baseUrl(p3)

	local v6 = not (data.isForSale == nil) and data.isForSale
	local v7 = requestParts({
		name = data.name,
		description = data.description,
		priceInRobux = data.priceInRobux,
		isForSale = v6,
		isManagedPricingEnabled = data.isManagedPricingEnabled,
		imageFile = data.imageFile
	})
	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p3),
		"POST",
		("%s/developer-products/v2/universes/%d/developer-products"):format(baseUrl, p2),
		v7,
		"developer-product.create",
		jsonDecoder
	)
end

function v5.update(p2, p3, data, p4)
	local baseUrl = creatorApiHttp.baseUrl(p4)
	local v6 = requestParts({
		name = data.name,
		description = data.description,
		priceInRobux = data.priceInRobux,
		isForSale = data.isForSale,
		isManagedPricingEnabled = data.isManagedPricingEnabled,
		imageFile = nil
	})
	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p4),
		"PATCH",
		("%s/%d"):format(
			("%s/developer-products/v2/universes/%d/developer-products"):format(baseUrl, p2),
			p3
		),
		v6,
		"developer-product.update",
		synthesizedDecoder(function()
			return {
				productId = p3,
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

function v5.setForSale(p2, p3, p4, p5)
	local baseUrl = creatorApiHttp.baseUrl(p5)
	return creatorApiHttp.multipart(
		creatorApiHttp.mutatingNetwork(p5),
		"PATCH",
		("%s/%d"):format(
			("%s/developer-products/v2/universes/%d/developer-products"):format(baseUrl, p2),
			p3
		),
		{
			{ name = "isForSale", value = tostring(p4) }
		},
		"developer-product.set-for-sale",
		synthesizedDecoder(function()
			return { productId = p3, isForSale = p4 }
		end)
	)
end

function v5.activate(p2, p3, p4)
	return v5.setForSale(p2, p3, true, p4)
end

function v5.deactivate(p2, p3, p4)
	return v5.setForSale(p2, p3, false, p4)
end

return v5
