local CATALOG_URL = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/CATALOG_URL")

local function fetchBundleOwnership(callback, p2)
	return callback(`{module}/v1/catalog/items/{p2}/details?itemType=bundle`, "GET", {}):andThen(function(p3)
		local responseBody = p3.responseBody

		if responseBody then
			return {
				id = tostring(p2),
				owned = responseBody.owned == true
			}
		end

		return nil
	end):catch(function(p3): nil
		warn("[CatalogNetworking] fetchBundleOwnership failed for bundle", p2, ":", (tostring(p3)))
		return nil
	end)
end

return fetchBundleOwnership
