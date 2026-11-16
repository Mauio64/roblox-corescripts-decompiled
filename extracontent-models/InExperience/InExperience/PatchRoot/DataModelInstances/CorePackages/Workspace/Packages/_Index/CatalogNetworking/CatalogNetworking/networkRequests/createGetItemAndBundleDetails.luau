local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local parent = CatalogNetworking.Parent
local Cryo = require(parent.Cryo)

local CATALOG_URL = require(CatalogNetworking.CATALOG_URL)

return function(p)
	return p.roduxNetworking.POST("GetItemDetails", function(callback, p2)
		return callback(CATALOG_URL):path("v1"):path("catalog"):path("items"):path("details"):body({
			items = Cryo.List.map(p2, function(p3)
				return { itemType = p3.itemType, id = p3.assetId }
			end)
		})
	end)
end
