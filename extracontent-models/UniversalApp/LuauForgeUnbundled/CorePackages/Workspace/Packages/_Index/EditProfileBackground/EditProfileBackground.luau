local module = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Components/DisplayBackground")

return {
	EditProfileBackgroundPage = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Components/EditProfileBackgroundPage"),
	DisplayBackground = module,
	BackgroundUtils = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/BackgroundUtils"),
	AvatarModelPrefetch = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/AvatarModelPrefetch"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/installReducer"),
	Analytics = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics")
}
