local UserLib = script:FindFirstAncestor("UserLib")

local Constants = require(UserLib.Utils.Constants)

local ThumbnailRequest = {}

function ThumbnailRequest.new()
	return {
		["thumbnailType"] = Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot,
		thumbnailSize = Constants.RbxThumbnailSizes.Size150x150
	}
end

function ThumbnailRequest.fromData(thumbnailType, thumbnailSize)
	local v = ThumbnailRequest.new()
	v.thumbnailType = thumbnailType
	v.thumbnailSize = thumbnailSize
	return v
end

return ThumbnailRequest
