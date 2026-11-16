local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")

local CATALOG_URL = require(CatalogNetworking.CATALOG_URL)

local function fetchBundleOwnership(callback, p: number)
	return callback(`{CATALOG_URL}/v1/catalog/items/{p}/details?itemType=bundle`, "GET", {}):andThen(function(p2)
		local responseBody = p2.responseBody

		if responseBody then
			return {
				id = tostring(p),
				owned = responseBody.owned == true
			}
		end

		return nil
	end):catch(function(p2): nil
		warn("[CatalogNetworking] fetchBundleOwnership failed for bundle", p, ":", (tostring(p2)))
		return nil
	end)
end

return fetchBundleOwnership
