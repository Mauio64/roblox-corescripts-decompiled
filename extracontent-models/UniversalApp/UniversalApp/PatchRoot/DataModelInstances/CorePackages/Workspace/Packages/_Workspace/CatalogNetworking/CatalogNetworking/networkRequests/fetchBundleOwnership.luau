local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local CATALOG_URL = require(CatalogNetworking.CATALOG_URL)

local function fetchBundleOwnership(p1, n1: number) -- line: 5
	-- upvalues: CATALOG_URL (copy)
	return p1(`{ CATALOG_URL }/v1/catalog/items/{ n1 }/details?itemType=bundle`, "GET", {}):andThen(function(p2) -- line: 8
		-- upvalues: n1 (copy)
		local responseBody = p2.responseBody

		if responseBody then
			return {
				id = tostring(n1),
				owned = responseBody.owned == true
			}
		end

		return nil
	end):catch(function(p3) -- line: 15
		-- upvalues: n1 (copy)
		warn("[CatalogNetworking] fetchBundleOwnership failed for bundle", n1, ":", (tostring(p3)))

		return nil
	end)
end

return fetchBundleOwnership
