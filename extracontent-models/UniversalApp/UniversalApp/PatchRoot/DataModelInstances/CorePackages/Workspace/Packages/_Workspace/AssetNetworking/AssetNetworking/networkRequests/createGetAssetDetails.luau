local AssetNetworking = script:FindFirstAncestor("AssetNetworking")
local ASSETS_API_URL = require(AssetNetworking.ASSETS_API_URL)

return function(p1) -- line: 9
	-- upvalues: ASSETS_API_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetAssetDetails"
	}, function(p2, s1: string) -- line: 12
		-- upvalues: ASSETS_API_URL (copy)
		return p2(ASSETS_API_URL):path("v1"):path("assets"):path(s1)
	end)
end
