local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Cryo")

local CATALOG_URL = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/CATALOG_URL")

return function(p2)
	return p2.roduxNetworking.POST("GetItemDetails", function(callback, p3)
		return callback(CATALOG_URL):path("v1"):path("catalog"):path("items"):path("details"):body({
			items = Cryo.List.map(p3, function(p4)
				return { itemType = p4.itemType, id = p4.assetId }
			end)
		})
	end)
end
