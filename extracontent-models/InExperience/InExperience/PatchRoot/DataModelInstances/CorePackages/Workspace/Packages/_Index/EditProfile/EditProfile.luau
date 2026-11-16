local EditProfile = {
	Analytics = require(script.Analytics),
	EditDisplayNameErrorModal = require(script.Components.ErrorModals.EditDisplayNameErrorModal),
	EditSocialNetworksErrorModal = require(script.Components.ErrorModals.EditSocialNetworksErrorModal),
	UsernameInsufficientFundsModal = require(script.Components.ErrorModals.UsernameInsufficientFundsModal),
	EditSocialLinksModal = require(script.Components.EditSocialLinksModal),
	Flags = require(script.Flags),
	Constants = require(script.Common.Constants),
	["jest.config"] = script["jest.config"],
	installReducer = require(script.installReducer)
}
local Constants = require(script.Common.Constants)
EditProfile.RoduxKey = Constants.RODUX_KEY
EditProfile.EditUsernameWrapper = require(script.EditUsernameWrapper)
EditProfile.useDisplayNameText = require(script.Hooks.useDisplayNameText)
EditProfile.Enums = require(script.Common.Enums)
EditProfile.EditProfileScreenViewAdapter = require(script.Components.EditProfileScreenViewAdapter)
EditProfile.EditProfileLanding = require(script.Components.EditProfileLanding)
EditProfile.EditProfileToastScreen = require(script.Components.EditProfileToast)
return EditProfile
