local HttpService = game:GetService("HttpService")

local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")

local LOOK_API_URL = require(CatalogNetworking.LOOK_API_URL)

local function fetchPurchaseDetails(callback, assets)
	return callback(LOOK_API_URL, "POST", {
		postBody = HttpService:JSONEncode({ assets = assets })
	}):andThen(function(p)
		return p.responseBody
	end):catch(function(p): nil
		warn("[CatalogNetworking] fetchPurchaseDetails failed:", (tostring(p)))
		return nil
	end)
end

return fetchPurchaseDetails
