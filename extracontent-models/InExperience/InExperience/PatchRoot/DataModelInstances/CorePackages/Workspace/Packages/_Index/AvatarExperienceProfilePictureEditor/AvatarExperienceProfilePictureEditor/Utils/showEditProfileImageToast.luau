local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local ToastRodux = require(parent.ToastRodux)
local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)

local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local v = {
	toastMessage = "Feature.Profile.Heading.ProfilePictureSaved",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local v2 = {
	toastMessage = TextKeys.SaveFailed,
	isLocalized = false,
	toastType = ToastType.NetworkingError
}
local ShowEditProfileImageToast = {}

function ShowEditProfileImageToast.showSaveSuccessToast(callback)
	callback(SetCurrentToastMessage(v))
end

function ShowEditProfileImageToast.showSaveFailureToast(callback)
	callback(SetCurrentToastMessage(v2))
end

return ShowEditProfileImageToast
