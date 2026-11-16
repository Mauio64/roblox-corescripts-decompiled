local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local UserLib = require(parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants

local function getRbxThumbType(p: string) -- 1 equivalent call inferred from this helper
	if p == "AvatarBundle" then
		return Constants.RbxthumbTypes.BundleThumbnail
	end

	return Constants.RbxthumbTypes.Asset
end

local function getThumbnailUrl(p: string, p2: string)
	return getRbxthumbWithTypeSizeAndOptions(p, getRbxThumbType(p2), 150) -- inferred equivalent call
end

return getThumbnailUrl
