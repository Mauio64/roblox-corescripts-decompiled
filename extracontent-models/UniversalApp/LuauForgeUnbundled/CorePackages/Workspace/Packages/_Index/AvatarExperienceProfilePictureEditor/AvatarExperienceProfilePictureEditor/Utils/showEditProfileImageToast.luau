local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/ToastRodux")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")

local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local v5 = {
	toastMessage = "Feature.Profile.Heading.ProfilePictureSaved",
	isLocalized = false,
	toastType = toastType.SuccessConfirmation
}

local v6 = {
	toastMessage = TextKeys.SaveFailed,
	isLocalized = false,
	toastType = toastType.NetworkingError
}

return {
	showSaveSuccessToast = function(callback)
		callback(setCurrentToastMessage(v5))
	end,
	showSaveFailureToast = function(callback)
		callback(setCurrentToastMessage(v6))
	end
}
