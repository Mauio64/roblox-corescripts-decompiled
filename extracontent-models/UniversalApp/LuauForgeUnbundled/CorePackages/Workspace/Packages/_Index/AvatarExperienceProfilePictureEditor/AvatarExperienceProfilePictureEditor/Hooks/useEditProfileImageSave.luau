local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagEditProfileFramesEnabled

local editProfileImageHelpers = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/editProfileImageHelpers")
local saveEditProfileImage = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/saveEditProfileImage")
local showEditProfileImageToast = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/showEditProfileImageToast")
local EditProfileImageAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Analytics/EditProfileImageAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")

local function useEditProfileImageSave(data)
	local state, setState = React.useState(false)

	local v5 = React.useCallback(function()
		setState(false)
	end, {})

	return {
		isSaving = state,
		onSave = React.useCallback(function()
			if state then
				return
			end

			setState(true)

			local buildSavePayloadForActiveView = editProfileImageHelpers.buildSavePayloadForActiveView
			local activeView = data.activeView
			local v6 = {
				selectedEmoteId = data.selectedEmoteId,
				savedEmoteAssetId = data.savedEmoteAssetId,
				selectedFrameId = 0,
				showFrames = 0
			}
			local v7 = if data.showFrames then data.selectedFrameId else nil
			v6.selectedFrameId = v7
			v6.showFrames = data.showFrames
			local savePayloadForActiveView = buildSavePayloadForActiveView(activeView, v6)

			local v8 = {
				emoteAssetId = savePayloadForActiveView.emoteAssetId,
				profileFrameAssetId = savePayloadForActiveView.profileFrameAssetId,
				cameraDistanceScale = data.distanceScale,
				cameraYRotDeg = data.yRotDeg,
				fieldOfViewDeg = data.cutoutFieldOfViewDeg,
				localUserId = data.localUserId
			}

			local onClose = data.onClose
			local onSaveSuccess = data.onSaveSuccess
			local titleBackAvailable = data.titleBackAvailable

			task.spawn(function()
				local v9 = saveEditProfileImage(v8)
				setState(false)

				if v9 then
					EditProfileImageAnalytics.logSave({
						mode = data.mode,
						emoteAssetId = savePayloadForActiveView.emoteAssetId,
						frameAssetId = savePayloadForActiveView.profileFrameAssetId,
						isPlusSubscriber = data.isPlusSubscriber,
						result = "success"
					})

					local postSaveAction = editProfileImageHelpers.resolvePostSaveAction({
						framesFeatureEnabled = fFlagEditProfileFramesEnabled,
						hasOnTitleBack = titleBackAvailable,
						hasOnSaveSuccess = onSaveSuccess ~= nil
					})

					if postSaveAction == "returnToCombined" then
						data.onReturnToCombined()
					elseif postSaveAction == "exitWithSuccessCallback" and onSaveSuccess then
						onSaveSuccess()
					else
						onClose()
					end
				else
					EditProfileImageAnalytics.logSave({
						mode = data.mode,
						emoteAssetId = savePayloadForActiveView.emoteAssetId,
						frameAssetId = savePayloadForActiveView.profileFrameAssetId,
						isPlusSubscriber = data.isPlusSubscriber,
						result = "failure"
					})

					showEditProfileImageToast.showSaveFailureToast(data.dispatch)
				end
			end)
		end, {
			state,
			data.mode,
			data.activeView,
			data.titleBackAvailable,
			data.selectedEmoteId,
			data.savedEmoteAssetId,
			data.selectedFrameId,
			data.showFrames,
			data.distanceScale,
			data.yRotDeg,
			data.cutoutFieldOfViewDeg,
			data.localUserId,
			data.isPlusSubscriber,
			data.dispatch,
			data.onReturnToCombined,
			data.onClose,
			data.onSaveSuccess
		}),
		resetTransientState = v5
	}
end

return useEditProfileImageSave
