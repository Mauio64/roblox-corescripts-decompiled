local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/Constants")

local v5 = {}

function v5.new()
	return {
		["thumbnailType"] = Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
		thumbnailSize = Constants.RbxThumbnailSizes.Size150x150
	}
end

function v5.fromData(thumbnailType, thumbnailSize)
	local v6 = v5.new()
	v6.thumbnailType = thumbnailType
	v6.thumbnailSize = thumbnailSize
	return v6
end

return v5
