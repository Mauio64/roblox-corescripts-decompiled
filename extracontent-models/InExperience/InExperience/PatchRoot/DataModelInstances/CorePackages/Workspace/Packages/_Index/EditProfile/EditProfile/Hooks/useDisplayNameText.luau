local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local TextKeys = require(EditProfile.Common.TextKeys)
local RealNamesInDisplayNamesIXP = require(EditProfile.Flags.RealNamesInDisplayNamesIXP)

local FFlagEditProfileDisplayNameUseUnder17Description = require(EditProfile.Flags.FFlagEditProfileDisplayNameUseUnder17Description)
local useRealNamesInDisplayNamesEnabled = require(script.Parent.useRealNamesInDisplayNamesEnabled)
local Localization = require(parent.Localization)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	displayNameCaption = TextKeys.DisplayNameCaption,
	displayNameChangeError = TextKeys.DisplayNameError,
	displayNameChangeMixedCharactersError = TextKeys.DisplayNameError,
	displayNameModalCaption = TextKeys.DisplayNameModalCaption,
	displayNameCoolDownMessage = TextKeys.DisplayNameRecently,
	displayNameTooShortError = TextKeys.DisplayNameTooShort,
	displayNameUpdatedMessage = TextKeys.DisplayNameUpdated,
	displayNameEditMessage = TextKeys.EditDisplayName,
	displayNameTitle = TextKeys.DisplayName,
	nameTooShortError = TextKeys.NameTooShortError,
	nameTooLongError = TextKeys.NameTooLongError,
	nameUnsupportedCharsError = TextKeys.NameUnsupportedCharsError,
	nameInappropriateError = TextKeys.NameInappropriateError,
	nameHasChangedError = TextKeys.NameHasChangedError,
	nameNotAvailableError = TextKeys.NameNotAvailableError,
	searchForFriendsPrompt = TextKeys.SearchForFriendPrompt
}

local v2 = {
	displayNameCaption = TextKeys.AgedUpDisplayNameConnectionsCaption,
	displayNameChangeError = TextKeys.AgedUpDisplayNameError,
	displayNameChangeMixedCharactersError = TextKeys.AgedUpDisplayNameMixedCharactersError,
	displayNameModalCaption = TextKeys.AgedUpDisplayNameModalCaption,
	displayNameCoolDownMessage = TextKeys.AgedUpDisplayNameRecently,
	displayNameTooShortError = TextKeys.AgedUpDisplayNameTooShort,
	displayNameUpdatedMessage = TextKeys.AgedUpDisplayNameUpdated,
	displayNameEditMessage = TextKeys.EditAgedUpDisplayName,
	displayNameTitle = TextKeys.AgedUpDisplayName,
	nameTooShortError = TextKeys.AgedUpNameTooShortError,
	nameTooLongError = TextKeys.AgedUpNameTooLongError,
	nameUnsupportedCharsError = TextKeys.AgedUpNameUnsupportedCharsError,
	nameInappropriateError = TextKeys.AgedUpNameInappropriateError,
	nameHasChangedError = TextKeys.AgedUpNameHasChangedError,
	nameNotAvailableError = TextKeys.AgedUpNameNotAvailableError,
	searchForFriendsPrompt = TextKeys.AgedUpSearchForFriendsPrompt
}

return function()
	local v3 = useRealNamesInDisplayNamesEnabled()
	local v4

	if RealNamesInDisplayNamesIXP.useIsExperimentEnabled({ isExposureEnabled = true }) and v3 then
		v4 = v2
	else
		v4 = v
	end

	if FFlagEditProfileDisplayNameUseUnder17Description then
		v4 = table.clone(v4)
		v4.displayNameCaption = v.displayNameCaption
		v4.displayNameModalCaption = v.displayNameModalCaption
	end

	return useLocalization(v4)
end
