local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local ProfileRefreshSignal = ProfilePlatformCommon.Signals.ProfileRefreshSignal
local userAvatarConfigurationsCache = require(AvatarExperienceProfilePictureEditor.Api.userAvatarConfigurationsCache)
local savePPEConfig = require(AvatarExperienceProfilePictureEditor.Shared.savePPEConfig)
local saveCloseupAndFullBody = savePPEConfig.saveCloseupAndFullBody

local function saveEditProfileImage(data): boolean
	local success, result = pcall(function()
		return saveCloseupAndFullBody({
			emoteAssetId = data.emoteAssetId,
			cameraDistanceScale = data.cameraDistanceScale,
			cameraYRotDeg = data.cameraYRotDeg,
			fieldOfViewDeg = data.fieldOfViewDeg,
			profileFrameAssetId = data.profileFrameAssetId
		})
	end)

	if not (success and result.ok) then
		return false
	end

	if data.localUserId then
		userAvatarConfigurationsCache.invalidate(data.localUserId)
	end

	ProfileRefreshSignal.notifyProfileRefresh()

	return true
end

return saveEditProfileImage
