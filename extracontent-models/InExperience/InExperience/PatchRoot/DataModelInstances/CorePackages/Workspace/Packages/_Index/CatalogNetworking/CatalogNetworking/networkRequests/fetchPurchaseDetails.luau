local HttpService = game:GetService("HttpService")
local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local LOOK_API_URL = require(CatalogNetworking.LOOK_API_URL)

local function fetchPurchaseDetails(p1, t1: {[any]: any}) -- line: 7
	-- upvalues: HttpService (copy), LOOK_API_URL (copy)
	local json = HttpService:JSONEncode({
		assets = t1
	})

	return p1(LOOK_API_URL, "POST", {
		postBody = json
	}):andThen(function(p2) -- line: 10
		return p2.responseBody
	end):catch(function(p3) -- line: 13
		warn("[CatalogNetworking] fetchPurchaseDetails failed:", (tostring(p3)))

		return nil
	end)
end

return fetchPurchaseDetails
