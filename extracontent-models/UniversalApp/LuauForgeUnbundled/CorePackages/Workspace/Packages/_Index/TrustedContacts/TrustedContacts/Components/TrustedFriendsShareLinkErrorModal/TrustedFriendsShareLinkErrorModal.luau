local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/UserProfiles")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant

local fFlagTCShareLinkErrorModalTextRename = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagTCShareLinkErrorModalTextRename
local fFlagTCShareLinkWrongRecipient = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagTCShareLinkWrongRecipient

local function TrustedFriendsShareLinkErrorModal(p2)
	local navigation = p2.navigation
	local param = navigation.getParam("extraProps")
	local v5

	if fFlagTCShareLinkWrongRecipient then
		local recipientUserId = param.recipientUserId
		local v6 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = recipientUserId and { recipientUserId } or {},
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})

		if recipientUserId and v6.data then
			v5 = UserProfiles.Selectors.getUsernameFromId(v6.data, recipientUserId)
		end
	end

	local v6 = useLocalization({
		expiredTitle = "Feature.Friends.Title.TrustedFriendsExpiredLink",
		expiredDescription = fFlagTCShareLinkErrorModalTextRename and "Feature.Friends.Description.TrustedFriendsExpiredLink" or "Feature.Friends.Description.TrustedConnectionExpiredLink",
		invalidTitle = "Feature.Friends.Title.TrustedFriendsInvalidLink",
		invalidDescription = "Feature.Friends.Description.TrustedFriendsInvalidLink",
		wrongRecipientDescription = v5 and {
			"Feature.Friends.Description.TrustedFriendsWrongAccount",
			username = v5
		} or nil,
		ok = "CommonUI.Controls.Action.OK"
	})

	local v7 = React.useCallback(function()
		navigation.pop()
		param.closeModal()
	end, { navigation, param.closeModal })

	local createElement = React.createElement
	local root = dialog.Root
	local v8 = { size = dialogSize.Medium }

	local createElement2 = React.createElement
	local title = dialog.Title

	local v10 = if param.errorType == "Expired" then v6.expiredTitle else v6.invalidTitle
	local children = {
		Title = createElement2(title, { LayoutOrder = 1, text = v10 }),
		BodyText = 0,
		DialogActions = 0
	}

	local createElement3 = React.createElement
	local text = dialog.Text
	local v12

	if param.errorType == "Expired" then
		v12 = v6.expiredDescription
	elseif fFlagTCShareLinkWrongRecipient and v5 then
		v12 = v6.wrongRecipientDescription
	else
		v12 = v6.invalidDescription
	end

	children.BodyText = createElement3(text, { LayoutOrder = 2, Text = v12 })

	children.DialogActions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{ text = v6.ok, variant = buttonVariant.Emphasis, onActivated = v7 }
		}
	})
	return createElement(root, v8, children)
end

return TrustedFriendsShareLinkErrorModal
