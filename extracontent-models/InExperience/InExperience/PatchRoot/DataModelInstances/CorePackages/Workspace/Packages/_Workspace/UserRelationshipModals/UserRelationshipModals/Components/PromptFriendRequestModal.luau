local parent = script:FindFirstAncestor("UserRelationshipModals").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local LayoutMode = UserTile.LayoutMode

local defineFastFlag = game:DefineFastFlag("PromptFriendRequestModalRevampFriendsRename", false)
local defineFastInt = game:DefineFastInt("PromptFriendRequestModalInputDelayMs", 1000)

local function PromptFriendRequestModal(props)
	local v = useLocalization({
		titleText = defineFastFlag and "InGame.FriendPlayerPrompt.Title.SendFriendRequest.FriendsRename" or "InGame.FriendPlayerPrompt.Title.SendFriendRequest",
		sendText = "InGame.FriendPlayerPrompt.Action.Send"
	})

	local createElement = React.createElement
	local root = Dialog.Root
	local v2 = { size = DialogSize.Medium, onClose = props.onClose }
	local v3 = {
		DialogTitle = React.createElement(Dialog.Title, { text = v.titleText }),
		Avatar = React.createElement(Foundation.View, {
			tag = "row align-x-center size-full-3000",
			LayoutOrder = 2
		}, {
			UserTile = React.createElement(userTile, {
				userId = props.userId,
				title = props.displayName,
				subtitle = "@" .. props.username,
				layoutMode = LayoutMode.compact
			})
		}),
		Buffer = React.createElement(Foundation.View, { tag = "size-full-500", LayoutOrder = 3 }),
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = Dialog.Actions

	local v4 = {
		text = v.sendText,
		variant = ButtonVariant.Emphasis,
		onActivated = props.onSendClicked,
		inputDelay = 0
	}
	local inputDelay

	if props.inputDelay == nil then
		inputDelay = defineFastInt / 1000
	else
		inputDelay = props.inputDelay
	end

	v4.inputDelay = inputDelay
	v3.DialogActions = createElement2(actions, {
		LayoutOrder = 4,
		actions = { v4 }
	})
	return createElement(root, v2, v3)
end

return PromptFriendRequestModal
