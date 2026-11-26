local profileRefreshSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/ProfilePlatformCommon").Signals.ProfileRefreshSignal
local userAvatarConfigurationsCache = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Api/userAvatarConfigurationsCache")
local saveCloseupAndFullBody = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Shared/savePPEConfig").saveCloseupAndFullBody

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

	profileRefreshSignal.notifyProfileRefresh()

	return true
end

return saveEditProfileImage
