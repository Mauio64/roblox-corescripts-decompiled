local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local PlaytestersOnlyShareDialog = require(BuildExperience.Components.ShareAudience.PlaytestersOnlyShareDialog)

require(BuildExperience.utils.useExperienceShareFlow)

local function ExperienceShareOverlays(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), FriendsOnlyShareDialog (copy), PlaytestersOnlyShareDialog (copy), LocalizationStrings (copy)
	return React.createElement(React.Fragment, nil, {
		FriendsOnlyShareDialog = if t1.activeDialog ~= "friends" then nil else React.createElement(FriendsOnlyShareDialog, {
			onCancel = t1.onCancel,
			onShare = t1.onConfirmFriends
		}),
		PlaytestersOnlyShareDialog = if t1.activeDialog ~= "playtesters" then nil else React.createElement(PlaytestersOnlyShareDialog, {
			onCancel = t1.onCancel,
			onShare = t1.onConfirmPlaytesters,
			errorText = if not t1.hasShareError then nil else LocalizationStrings.PRIVATE_INVITES_SHARE_LINK_ERROR
		})
	})
end

return ExperienceShareOverlays
