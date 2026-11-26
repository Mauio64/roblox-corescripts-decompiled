local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FoundationCloudAssets")
local assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("loadFoundationCloudAsset")

local function loadFoundationCloudAsset(p2)
	preloadAsset(p2)
	local asset = assets[p2]

	if asset then
		return asset.assetId, asset.size
	end

	v5:error("FoundationCloudAsset not found: %s", p2)
	return "", { X = 0, Y = 0 }
end

return loadFoundationCloudAsset
