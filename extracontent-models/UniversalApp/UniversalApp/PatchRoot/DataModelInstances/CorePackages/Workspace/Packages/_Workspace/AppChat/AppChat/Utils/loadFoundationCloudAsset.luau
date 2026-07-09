local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FoundationCloudAssets = require(AppChatParent.FoundationCloudAssets)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset
local v6 = require(AppChat.Logger):new("loadFoundationCloudAsset")

local function loadFoundationCloudAsset(s1: string) -- line: 12
	-- upvalues: preloadAsset (copy), Assets (copy), v6 (copy)
	preloadAsset(s1)

	local v9 = Assets[s1]

	if not v9 then
		v6:error("FoundationCloudAsset not found: %s", s1)

		return "", {
			X = 0,
			Y = 0
		}
	end

	return v9.assetId, v9.size
end

return loadFoundationCloudAsset
