local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local RealNamesInDisplayNamesIXP = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/RealNamesInDisplayNamesIXP")

local FFlagEditProfileDisplayNameUseUnder17Description = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/FFlagEditProfileDisplayNameUseUnder17Description")
local useRealNamesInDisplayNamesEnabled = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useRealNamesInDisplayNamesEnabled")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization

local v5 = {
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

local v6 = {
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
	local v7 = useRealNamesInDisplayNamesEnabled()
	local v8 = if RealNamesInDisplayNamesIXP.useIsExperimentEnabled({ isExposureEnabled = true }) and v7 then v6 else v5

	if FFlagEditProfileDisplayNameUseUnder17Description then
		v8 = table.clone(v8)
		v8.displayNameCaption = v5.displayNameCaption
		v8.displayNameModalCaption = v5.displayNameModalCaption
	end

	return useLocalization(v8)
end
