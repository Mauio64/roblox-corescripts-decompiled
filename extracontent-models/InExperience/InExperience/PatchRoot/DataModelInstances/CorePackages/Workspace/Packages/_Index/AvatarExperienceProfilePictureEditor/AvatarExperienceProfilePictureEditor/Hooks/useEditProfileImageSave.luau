local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagEditProfileFramesEnabled = SharedFlags.FFlagEditProfileFramesEnabled

local editProfileImageHelpers = require(AvatarExperienceProfilePictureEditor.Utils.editProfileImageHelpers)
local saveEditProfileImage = require(AvatarExperienceProfilePictureEditor.Utils.saveEditProfileImage)
local showEditProfileImageToast = require(AvatarExperienceProfilePictureEditor.Utils.showEditProfileImageToast)
local EditProfileImageAnalytics = require(AvatarExperienceProfilePictureEditor.Analytics.EditProfileImageAnalytics)
require(AvatarExperienceProfilePictureEditor.Common.Enums)

local function useEditProfileImageSave(data)
	local state, setState = React.useState(false)

	local resetTransientState = React.useCallback(function()
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
			local v = {
				selectedEmoteId = data.selectedEmoteId,
				savedEmoteAssetId = data.savedEmoteAssetId,
				selectedFrameId = 0,
				showFrames = 0
			}
			local selectedFrameId

			if data.showFrames then
				selectedFrameId = data.selectedFrameId
			end

			v.selectedFrameId = selectedFrameId
			v.showFrames = data.showFrames
			local savePayloadForActiveView = buildSavePayloadForActiveView(activeView, v)

			local v2 = {
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
				local v3 = saveEditProfileImage(v2)
				setState(false)

				if v3 then
					EditProfileImageAnalytics.logSave({
						mode = data.mode,
						emoteAssetId = savePayloadForActiveView.emoteAssetId,
						frameAssetId = savePayloadForActiveView.profileFrameAssetId,
						isPlusSubscriber = data.isPlusSubscriber,
						result = "success"
					})

					local postSaveAction = editProfileImageHelpers.resolvePostSaveAction({
						framesFeatureEnabled = FFlagEditProfileFramesEnabled,
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
		resetTransientState = resetTransientState
	}
end

return useEditProfileImageSave
