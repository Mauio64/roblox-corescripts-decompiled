local Parent = script:FindFirstAncestor("NetworkingCurrentlyWearing").Parent
local Dash = require(Parent.Dash)
local CATALOG_URL = require(script.Parent.Parent.CATALOG_URL)

return function(p1) -- line: 11
	-- upvalues: CATALOG_URL (copy), Dash (copy)
	return p1.roduxNetworking.POST({
		Name = "GetItemDetails"
	}, function(p2, p3) -- line: 14
		-- upvalues: CATALOG_URL (copy), Dash (copy)
		return p2(CATALOG_URL):path("v1"):path("catalog"):path("items"):path("details"):body({
			items = Dash.map(p3, function(p4) -- line: 16
				return {
					itemType = "Asset",
					id = p4
				}
			end)
		})
	end)
end
