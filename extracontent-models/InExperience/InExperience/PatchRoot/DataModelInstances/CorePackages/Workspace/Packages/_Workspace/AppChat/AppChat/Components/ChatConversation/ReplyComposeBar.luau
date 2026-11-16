local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local FFlagAppChatUseProfileFrameThumbnail = require(AppChat.Flags.FFlagAppChatUseProfileFrameThumbnail)

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local BuilderIcons = require(parent.BuilderIcons)
local ReplyComposeBarText = require(script.Parent.ReplyComposeBarText)
local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)

local v = {
	LayoutOrder = 3,
	replyingToUserText = nil,
	replyingToUserContent = nil,
	replyingToUserId = nil,
	onCloseActivated = function() end
}

function ReplyComposeBar(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = Foundation.Hooks.useTokens()

	local v3 = useFoundationPresence(union.replyingToUserId)

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		tag = "row size-full-0 auto-y align-y-center gap-medium",
		LayoutOrder = union.LayoutOrder
	}
	local avatar

	if union.replyingToUserId then
		avatar = React.createElement(Foundation.Avatar, {
			userId = union.replyingToUserId,
			userPresence = v3.presence,
			backgroundStyle = v2.Color.Surface.Surface_200,
			size = Foundation.Enums.InputSize.Medium,
			includeProfileFrame = FFlagAppChatUseProfileFrameThumbnail,
			LayoutOrder = 1
		}) or nil
	end

	return createElement(view, v4, {
		Avatar = avatar,
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

return React.memo(ReplyComposeBar)
