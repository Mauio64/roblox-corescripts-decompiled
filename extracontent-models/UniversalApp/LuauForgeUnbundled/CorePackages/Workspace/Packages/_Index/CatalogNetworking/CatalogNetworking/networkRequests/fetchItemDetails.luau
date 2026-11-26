local HttpService = game:GetService("HttpService")

local CATALOG_URL = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/CATALOG_URL")

local function fetchItemDetails(callback, p2)
	local jsonEncode = HttpService:JSONEncode({ items = p2 })

	return callback(`{module}/v1/catalog/items/details`, "POST", {
		postBody = jsonEncode
	}):andThen(function(p3)
		return p3.responseBody
	end):catch(function(p3): nil
		warn("[CatalogNetworking] fetchItemDetails failed:", (tostring(p3)))
		return nil
	end)
end

return fetchItemDetails
