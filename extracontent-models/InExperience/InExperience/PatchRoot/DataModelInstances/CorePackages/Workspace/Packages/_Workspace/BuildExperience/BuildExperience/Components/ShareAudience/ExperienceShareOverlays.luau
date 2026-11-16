local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local PlaytestersOnlyShareDialog = require(BuildExperience.Components.ShareAudience.PlaytestersOnlyShareDialog)

require(BuildExperience.utils.useExperienceShareFlow)

local function ExperienceShareOverlays(props)
	local shareLinkError = useLocalization({
		shareLinkError = LocalizationStrings.PRIVATE_INVITES_SHARE_LINK_ERROR
	}).shareLinkError

	local createElement = React.createElement
	local fragment = React.Fragment
	local friendsOnlyShareDialog

	if props.activeDialog == "friends" then
		friendsOnlyShareDialog = React.createElement(FriendsOnlyShareDialog, {
			onCancel = props.onCancel,
			onShare = props.onConfirmFriends
		})
	end

	local playtestersOnlyShareDialog

	if props.activeDialog == "playtesters" then
		local createElement2 = React.createElement
		local v = { onCancel = props.onCancel, onShare = props.onConfirmPlaytesters, errorText = 0 }

		if not props.hasShareError then
			shareLinkError = nil
		end

		v.errorText = shareLinkError
		playtestersOnlyShareDialog = createElement2(PlaytestersOnlyShareDialog, v)
	end

	return createElement(fragment, nil, {
		FriendsOnlyShareDialog = friendsOnlyShareDialog,
		PlaytestersOnlyShareDialog = playtestersOnlyShareDialog
	})
end

return ExperienceShareOverlays
