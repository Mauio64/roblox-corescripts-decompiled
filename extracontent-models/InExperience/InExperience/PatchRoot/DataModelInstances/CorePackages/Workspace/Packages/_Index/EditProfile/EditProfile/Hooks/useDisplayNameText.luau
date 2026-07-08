local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local TextKeys = require(EditProfile.Common.TextKeys)
local RealNamesInDisplayNamesIXP = require(EditProfile.Flags.RealNamesInDisplayNamesIXP)
local FFlagEditProfileDisplayNameUseUnder17Description = require(EditProfile.Flags.FFlagEditProfileDisplayNameUseUnder17Description)
local useRealNamesInDisplayNamesEnabled = require(script.Parent.useRealNamesInDisplayNamesEnabled)
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local t1 = {
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
local t2 = {
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

return function() -- line: 55
	-- upvalues: useRealNamesInDisplayNamesEnabled (copy), RealNamesInDisplayNamesIXP (copy), t2 (copy), t1 (copy), FFlagEditProfileDisplayNameUseUnder17Description (copy), useLocalization (copy)
	local v10 = useRealNamesInDisplayNamesEnabled()
	local v11 = if not RealNamesInDisplayNamesIXP.useIsExperimentEnabled({
		isExposureEnabled = true
	}) or not v10 then t1 else t2

	if FFlagEditProfileDisplayNameUseUnder17Description then
		v11 = table.clone(v11)
		v11.displayNameCaption = t1.displayNameCaption
		v11.displayNameModalCaption = t1.displayNameModalCaption
	end

	return useLocalization(v11)
end
