local FFlagAppChatUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseProfileFrameThumbnail")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/BuilderIcons")
local ReplyComposeBarText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ReplyComposeBarText")
local useFoundationPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useFoundationPresence")

local v5 = {
	LayoutOrder = 3,
	replyingToUserText = nil,
	replyingToUserContent = nil,
	replyingToUserId = nil,
	onCloseActivated = function() end
}

function LUAUFORGE_MODULE_GLOBALS_hoT_ReplyComposeBar(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = Foundation.Hooks.useTokens()

	local v7 = useFoundationPresence(union.replyingToUserId)

	local createElement = React.createElement
	local view = Foundation.View
	local v8 = {
		tag = "row size-full-0 auto-y align-y-center gap-medium",
		LayoutOrder = union.LayoutOrder
	}

	local v9 = if union.replyingToUserId then React.createElement(Foundation.Avatar, {
		userId = union.replyingToUserId,
		userPresence = v7.presence,
		backgroundStyle = v6.Color.Surface.Surface_200,
		size = Foundation.Enums.InputSize.Medium,
		includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
		LayoutOrder = 1
	}) or nil else nil
	return createElement(view, v8, {
		Avatar = v9,
		Text = React.createElement(ReplyComposeBarText, {
			layoutOrder = 2,
			userText = union.replyingToUserText,
			contentText = union.replyingToUserContent
		}),
		CloseButton = React.createElement(Foundation.IconButton, {
			onActivated = union.onCloseActivated,
			icon = BuilderIcons.Icon.X,
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.InputSize.Medium,
			isCircular = true,
			LayoutOrder = 3
		})
	})
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hoT_ReplyComposeBar)
