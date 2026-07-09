local UserLib = script:FindFirstAncestor("UserLib")
local Constants = require(UserLib.Utils.Constants)
local ThumbnailRequest = require(UserLib.Utils.ThumbnailRequest)

return {
	USER_CAROUSEL = { ThumbnailRequest.fromData(Constants.RbxAvatarThumbnailTypesFromEnum.AvatarThumbnail, Constants.RbxThumbnailSizes.Size100x100) },
	USER_CAROUSEL_HEAD_SHOT = { ThumbnailRequest.fromData(Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot, Constants.RbxThumbnailSizes.Size150x150) },
	USER_CAROUSEL_AVATAR_THUMBNAIL = { ThumbnailRequest.fromData(Constants.RbxAvatarThumbnailTypesFromEnum.AvatarThumbnail, Constants.RbxThumbnailSizes.Size150x150) },
	HOME_HEADER_USER = { ThumbnailRequest.fromData(Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot, Constants.RbxThumbnailSizes.Size150x150) },
	FRIEND_CAROUSEL = { ThumbnailRequest.fromData(Constants.RbxAvatarThumbnailTypesFromEnum.HeadShot, Constants.RbxThumbnailSizes.Size48x48) },
	CUSTOMIZE_BUTTON = { ThumbnailRequest.fromData(Constants.RbxAvatarThumbnailTypesFromEnum.AvatarThumbnail, Constants.RbxThumbnailSizes.Size720x720) }
}
