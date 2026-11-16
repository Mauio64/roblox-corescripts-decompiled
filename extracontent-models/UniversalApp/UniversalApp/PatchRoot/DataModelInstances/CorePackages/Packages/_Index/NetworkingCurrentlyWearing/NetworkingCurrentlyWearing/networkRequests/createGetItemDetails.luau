local parent = script:FindFirstAncestor("NetworkingCurrentlyWearing").Parent
local Dash = require(parent.Dash)

local CATALOG_URL = require(script.Parent.Parent.CATALOG_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "GetItemDetails" }, function(callback, p2)
		return callback(CATALOG_URL):path("v1"):path("catalog"):path("items"):path("details"):body({
			items = Dash.map(p2, function(id)
				return { itemType = "Asset", id = id }
			end)
		})
	end)
end
