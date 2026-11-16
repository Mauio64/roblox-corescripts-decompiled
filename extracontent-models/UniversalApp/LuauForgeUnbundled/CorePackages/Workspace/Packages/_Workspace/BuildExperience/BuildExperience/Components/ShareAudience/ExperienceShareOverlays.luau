local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/FriendsOnlyShareDialog")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/PlaytestersOnlyShareDialog")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useExperienceShareFlow")

local function ExperienceShareOverlays(props)
	local shareLinkError = useLocalization({
		shareLinkError = LocalizationStrings.PRIVATE_INVITES_SHARE_LINK_ERROR
	}).shareLinkError

	local createElement = React.createElement
	local fragment = React.Fragment
	local v7 = if props.activeDialog == "friends" then React.createElement(module3, {
		onCancel = props.onCancel,
		onShare = props.onConfirmFriends
	}) else nil
	local v8

	if props.activeDialog == "playtesters" then
		local createElement2 = React.createElement
		local v10 = {
			onCancel = props.onCancel,
			onShare = props.onConfirmPlaytesters,
			errorText = 0
		}

		if not props.hasShareError then
			shareLinkError = nil
		end

		v10.errorText = shareLinkError
		v8 = createElement2(module4, v10)
	end

	return createElement(fragment, nil, {
		FriendsOnlyShareDialog = v7,
		PlaytestersOnlyShareDialog = v8
	})
end

return ExperienceShareOverlays
