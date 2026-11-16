local Enums = require(script.Common.Enums)
local Constants = require(script.Constants)
local parseCloseupCameraConfig = require(script.Shared.parseCloseupCameraConfig)
local parseProfileFrameAssetId = require(script.Shared.parseProfileFrameAssetId)
local parseUserAvatarConfigurationsV4 = require(script.Shared.parseUserAvatarConfigurationsV4)
local savePPEConfig = require(script.Shared.savePPEConfig)
local getEmoteRecommendations = require(script.Shared.getEmoteRecommendations)
local applyCloseupPreviewPose = require(script.Shared.applyCloseupPreviewPose)
local computeCutoutFieldOfViewDeg = require(script.Shared.computeCutoutFieldOfViewDeg)
local computeFocusAngleAboveCenterRad = require(script.Shared.computeFocusAngleAboveCenterRad)
local frameCloseupPreviewCamera = require(script.Shared.frameCloseupPreviewCamera)

local EditProfileImageAnalytics = require(script.Analytics.EditProfileImageAnalytics)

return {
	["jest.config"] = script["jest.config"],
	["jest.main.config"] = script["jest.main.config"],
	["jest.mockDataModel.config"] = script["jest.mockDataModel.config"],
	EditProfileImage = require(script.Components.EditProfileImage.EditProfileImage),
	EditProfileImageScreen = require(script.Components.EditProfileImage.EditProfileImageScreen),
	EditProfileImageAnalytics = EditProfileImageAnalytics,
	ProfileFramePreviewThumbnail = require(script.Components.ProfileFrameThumbnail.ProfileFrameThumbnail),
	closeProfilePictureEditor = require(script.Utils.closeProfilePictureEditor),
	showEditProfileImageToast = require(script.Utils.showEditProfileImageToast),
	Enums = Enums,
	TextKeys = require(script.Common.TextKeys),
	Constants = Constants,
	useUserAvatarConfigurations = require(script.Hooks.useUserAvatarConfigurations),
	parseCloseupCameraConfig = parseCloseupCameraConfig,
	parseProfileFrameAssetId = parseProfileFrameAssetId,
	parseUserAvatarConfigurationsV4 = parseUserAvatarConfigurationsV4.parseUserAvatarConfigurationsV4,
	parseProfileFrameAssetIdFromV4 = parseUserAvatarConfigurationsV4.parseProfileFrameAssetIdFromV4,
	savePPEConfig = savePPEConfig,
	getEmoteRecommendations = getEmoteRecommendations,
	applyCloseupPreviewPose = applyCloseupPreviewPose,
	computeCutoutFieldOfViewDeg = computeCutoutFieldOfViewDeg,
	computeFocusAngleAboveCenterRad = computeFocusAngleAboveCenterRad,
	frameCloseupPreviewCamera = frameCloseupPreviewCamera
}
