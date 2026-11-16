local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset
local Logger = require(AppChat.Logger)
local v = Logger:new("loadFoundationCloudAsset")

local function loadFoundationCloudAsset(p: string)
	preloadAsset(p)
	local asset = Assets[p]

	if asset then
		return asset.assetId, asset.size
	end

	v:error("FoundationCloudAsset not found: %s", p)
	return "", { X = 0, Y = 0 }
end

return loadFoundationCloudAsset
