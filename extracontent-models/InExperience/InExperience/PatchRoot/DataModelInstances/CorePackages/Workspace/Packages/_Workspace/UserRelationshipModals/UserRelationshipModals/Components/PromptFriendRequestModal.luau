local Parent = script:FindFirstAncestor("UserRelationshipModals").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UserTile = require(Parent.UserTile)
local UserTile2 = UserTile.UserTile
local LayoutMode = UserTile.LayoutMode
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename
local v12 = game:DefineFastFlag("PromptFriendRequestModalRevampFriendsRename", false)
local v13 = FFlagConnectionsToFriendsRename and v12
local v14 = game:DefineFastInt("PromptFriendRequestModalInputDelayMs", 1000)

local function PromptFriendRequestModal(t1: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy), v13 (copy), React (copy), Dialog (copy), DialogSize (copy), Foundation (copy), UserTile2 (copy), LayoutMode (copy), ButtonVariant (copy), v14 (copy)
	local v17 = useLocalization({
		sendText = "InGame.FriendPlayerPrompt.Action.Send",
		titleText = not v13 and "InGame.FriendPlayerPrompt.Title.SendFriendRequest" or "InGame.FriendPlayerPrompt.Title.SendFriendRequest.FriendsRename"
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Medium,
		onClose = t1.onClose
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v17.titleText
		}),
		Avatar = React.createElement(Foundation.View, {
			tag = "row align-x-center size-full-3000",
			LayoutOrder = 2
		}, {
			UserTile = React.createElement(UserTile2, {
				userId = t1.userId,
				title = t1.displayName,
				subtitle = "@" .. t1.username,
				layoutMode = LayoutMode.compact
			})
		}),
		Buffer = React.createElement(Foundation.View, {
			tag = "size-full-500",
			LayoutOrder = 3
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {{
				text = v17.sendText,
				variant = ButtonVariant.Emphasis,
				onActivated = t1.onSendClicked,
				inputDelay = if t1.inputDelay ~= nil then t1.inputDelay else v14 / 1000
			}}
		})
	})
end

return PromptFriendRequestModal
