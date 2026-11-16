local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants

local function getRbxThumbType(p: string)
	if p == "Bundle" then
		return Constants.RbxthumbTypes.BundleThumbnail
	elseif p == "Asset" then
		return Constants.RbxthumbTypes.Asset
	end

	return nil
end

return getRbxThumbType
