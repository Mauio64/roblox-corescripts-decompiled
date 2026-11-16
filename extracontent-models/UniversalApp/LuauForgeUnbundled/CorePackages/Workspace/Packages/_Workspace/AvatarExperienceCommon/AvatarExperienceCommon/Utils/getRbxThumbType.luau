local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/UserLib").Utils.Constants

local function getRbxThumbType(p2)
	if p2 == "Bundle" then
		return constants.RbxthumbTypes.BundleThumbnail
	elseif p2 == "Asset" then
		return constants.RbxthumbTypes.Asset
	end

	return nil
end

return getRbxThumbType
