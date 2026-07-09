local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local CatalogNetworkingParent = CatalogNetworking.Parent
local Cryo = require(CatalogNetworkingParent.Cryo)
local CATALOG_URL = require(CatalogNetworking.CATALOG_URL)

return function(p1) -- line: 12
	-- upvalues: CATALOG_URL (copy), Cryo (copy)
	return p1.roduxNetworking.POST({
		Name = "GetItemDetails"
	}, function(p2, t1: {[any]: any}) -- line: 17
		-- upvalues: CATALOG_URL (copy), Cryo (copy)
		return p2(CATALOG_URL):path("v1"):path("catalog"):path("items"):path("details"):body({
			items = Cryo.List.map(t1, function(p3) -- line: 19
				return {
					itemType = p3.itemType,
					id = p3.assetId
				}
			end)
		})
	end)
end
