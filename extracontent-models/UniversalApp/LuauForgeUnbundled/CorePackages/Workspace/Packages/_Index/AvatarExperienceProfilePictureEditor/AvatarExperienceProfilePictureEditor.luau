local module = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseCloseupCameraConfig")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseProfileFrameAssetId")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/parseUserAvatarConfigurationsV4")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/savePPEConfig")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/getEmoteRecommendations")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/applyCloseupPreviewPose")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/computeCutoutFieldOfViewDeg")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/computeFocusAngleAboveCenterRad")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/frameCloseupPreviewCamera")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useProfileFrames")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useProfileFramesGating")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/saveEditProfileImage")

local module15 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Analytics/EditProfileImageAnalytics")

return {
	EditProfileImage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/EditProfileImage"),
	EditProfileImageScreen = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/EditProfileImageScreen"),
	EditProfileImageAnalytics = module15,
	ProfileFramePreviewThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/ProfileFrameThumbnail/ProfileFrameThumbnail"),
	closeProfilePictureEditor = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/closeProfilePictureEditor"),
	showEditProfileImageToast = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/showEditProfileImageToast"),
	Enums = module,
	TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys"),
	Constants = module2,
	useUserAvatarConfigurations = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useUserAvatarConfigurations"),
	useProfileFrames = module12,
	useProfileFramesGating = module13,
	saveEditProfileImage = module14,
	parseCloseupCameraConfig = module3,
	parseProfileFrameAssetId = module4,
	parseUserAvatarConfigurationsV4 = module5.parseUserAvatarConfigurationsV4,
	parseProfileFrameAssetIdFromV4 = module5.parseProfileFrameAssetIdFromV4,
	savePPEConfig = module6,
	getEmoteRecommendations = module7,
	applyCloseupPreviewPose = module8,
	computeCutoutFieldOfViewDeg = module9,
	computeFocusAngleAboveCenterRad = module10,
	frameCloseupPreviewCamera = module11
}
