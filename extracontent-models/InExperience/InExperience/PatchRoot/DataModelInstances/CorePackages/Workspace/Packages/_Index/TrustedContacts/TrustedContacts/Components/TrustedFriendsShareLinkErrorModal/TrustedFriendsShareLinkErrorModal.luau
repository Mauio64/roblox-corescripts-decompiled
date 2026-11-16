local parent = script:FindFirstAncestor("TrustedContacts").Parent

local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local SharedFlags = require(parent.SharedFlags)
local FFlagTCShareLinkErrorModalTextRename = SharedFlags.FFlagTCShareLinkErrorModalTextRename
local SharedFlags2 = require(parent.SharedFlags)
local FFlagTCShareLinkWrongRecipient = SharedFlags2.FFlagTCShareLinkWrongRecipient

local function TrustedFriendsShareLinkErrorModal(p)
	local navigation = p.navigation
	local param = navigation.getParam("extraProps")
	local username

	if FFlagTCShareLinkWrongRecipient then
		local recipientUserId = param.recipientUserId
		local v = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = recipientUserId and { recipientUserId } or {},
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})

		if recipientUserId and v.data then
			username = UserProfiles.Selectors.getUsernameFromId(v.data, recipientUserId)
		end
	end

	local v = useLocalization({
		expiredTitle = "Feature.Friends.Title.TrustedFriendsExpiredLink",
		expiredDescription = FFlagTCShareLinkErrorModalTextRename and "Feature.Friends.Description.TrustedFriendsExpiredLink" or "Feature.Friends.Description.TrustedConnectionExpiredLink",
		invalidTitle = "Feature.Friends.Title.TrustedFriendsInvalidLink",
		invalidDescription = "Feature.Friends.Description.TrustedFriendsInvalidLink",
		wrongRecipientDescription = username and {
			"Feature.Friends.Description.TrustedFriendsWrongAccount",
			username = username
		} or nil,
		ok = "CommonUI.Controls.Action.OK"
	})

	local onActivated = React.useCallback(function()
		navigation.pop()
		param.closeModal()
	end, { navigation, param.closeModal })

	local createElement = React.createElement
	local root = Dialog.Root
	local v2 = { size = DialogSize.Medium }

	local createElement2 = React.createElement
	local title = Dialog.Title
	local text2

	if param.errorType == "Expired" then
		text2 = v.expiredTitle
	else
		text2 = v.invalidTitle
	end

	local children = {
		Title = createElement2(title, { LayoutOrder = 1, text = text2 }),
		BodyText = 0,
		DialogActions = 0
	}

	local createElement3 = React.createElement
	local text = Dialog.Text
	local text3

	if param.errorType == "Expired" then
		text3 = v.expiredDescription
	elseif FFlagTCShareLinkWrongRecipient and username then
		text3 = v.wrongRecipientDescription
	else
		text3 = v.invalidDescription
	end

	children.BodyText = createElement3(text, { LayoutOrder = 2, Text = text3 })

	children.DialogActions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{ text = v.ok, variant = ButtonVariant.Emphasis, onActivated = onActivated }
		}
	})
	return createElement(root, v2, children)
end

return TrustedFriendsShareLinkErrorModal
