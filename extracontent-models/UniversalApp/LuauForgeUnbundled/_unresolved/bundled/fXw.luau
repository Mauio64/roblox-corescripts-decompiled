local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/fXx")
local module3 = require("@luauforge/bundled/dyD")

local module4 = require("@luauforge/bundled/fXz")
local module5 = require("@luauforge/bundled/fXB")
local module6 = require("@luauforge/bundled/fXD")
require("@luauforge/bundled/fXE")

local module7 = require("@luauforge/bundled/fXF")

return function(p2, p3, p4, p5)
	return performFetch.Single("ApiFetchGameDeveloperProducts" .. tostring(p3) .. p5, function(object)
		local v5 = module6()
		local v6 = ""
		local joined = {}

		local function createProductsFromResponseData(responseBody)
			local productsFromResponseData = {}

			if responseBody.developerProducts then
				for k, developerProduct in responseBody.developerProducts do
					table.insert(productsFromResponseData, {
						iconImageAssetId = developerProduct.IconImageAssetId,
						id = developerProduct.DeveloperProductId,
						name = developerProduct.Name,
						priceInRobux = developerProduct.PriceInRobux,
						productId = developerProduct.ProductId
					})
				end
			end

			return productsFromResponseData
		end

		local function fetchPage(p6)
			if v5 < p6 then
				return module.resolve({ responseBody = joined })
			end

			return module2(p2, p3, v6):andThen(function(p7)
				local responseBody = p7.responseBody
				local productsFromResponseData = createProductsFromResponseData(responseBody)
				joined = Cryo.List.join(joined, productsFromResponseData)

				if not responseBody.nextPageCursor or responseBody.nextPageCursor == "" then
					return module.resolve({ responseBody = joined })
				end

				v6 = responseBody.nextPageCursor
				return fetchPage(p6 + 1)
			end):catch(function(p7)
				return module.resolve({ responseBody = joined })
			end)
		end

		return fetchPage(1):andThen(function(p6)
			local responseBody = p6.responseBody
			table.sort(responseBody, module7)

			object:dispatch(module3(p3, responseBody))

			if responseBody and type(responseBody) == "table" and #responseBody > 0 then
				local iconImageAssetIds = {}

				for i, v7 in ipairs(responseBody) do
					if v7.iconImageAssetId then
						table.insert(iconImageAssetIds, v7.iconImageAssetId)
					end
				end

				object:dispatch(module4(p2, iconImageAssetIds))
			end

			object:dispatch(module5(p2, p5, p3, p4))

			return module.resolve(p6)
		end, function(p6)
			return module.resolve()
		end)
	end)
end
