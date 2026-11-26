local HttpService = game:GetService("HttpService")

local LOOK_API_URL = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/LOOK_API_URL")

local function fetchPurchaseDetails(callback, p2)
	return callback(LOOK_API_URL, "POST", {
		postBody = HttpService:JSONEncode({ assets = p2 })
	}):andThen(function(p3)
		return p3.responseBody
	end):catch(function(p3): nil
		warn("[CatalogNetworking] fetchPurchaseDetails failed:", (tostring(p3)))
		return nil
	end)
end

return fetchPurchaseDetails
