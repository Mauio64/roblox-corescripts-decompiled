local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local UserLib = require(Parent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants

local function getRbxThumbType(s1: string) -- line: 9
	-- upvalues: Constants (copy)
	if s1 == "AvatarBundle" then
		return Constants.RbxthumbTypes.BundleThumbnail
	end

	return Constants.RbxthumbTypes.Asset
end
local function getThumbnailUrl(s2: string, s3: string) -- line: 16
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy)
	return getRbxthumbWithTypeSizeAndOptions(s2, if s3 ~= "AvatarBundle" then Constants.RbxthumbTypes.Asset else Constants.RbxthumbTypes.BundleThumbnail, 150)
end

return getThumbnailUrl
