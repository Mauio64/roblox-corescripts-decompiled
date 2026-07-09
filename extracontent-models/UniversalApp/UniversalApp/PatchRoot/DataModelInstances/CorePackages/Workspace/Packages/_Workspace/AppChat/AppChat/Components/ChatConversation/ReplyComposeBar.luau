local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local Foundation = require(AppChatParent.Foundation)
local BuilderIcons = require(AppChatParent.BuilderIcons)
local ReplyComposeBarText = require(script.Parent.ReplyComposeBarText)
local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)
local FFlagAppChatReplyComposeBarContainer = require(AppChat.Flags.FFlagAppChatReplyComposeBarContainer)
local t1 = {
	LayoutOrder = 3,
	totalHeight = 0,
	replyingToUserText = nil,
	replyingToUserContent = nil,
	replyingToUserId = nil,
	onCloseActivated = function() -- line: 35
	end
}

function ReplyComposeBar(p1) -- line: 38
	-- upvalues: Cryo (copy), t1 (copy), Foundation (copy), useFoundationPresence (copy), FFlagAppChatReplyComposeBarContainer (copy), React (copy), ReplyComposeBarText (copy), BuilderIcons (copy)
	local v12 = Cryo.Dictionary.union(t1, p1)
	local v13 = Foundation.Hooks.useTokens()
	local v14 = useFoundationPresence(v12.replyingToUserId)

	if FFlagAppChatReplyComposeBarContainer then
		return (React.createElement(Foundation.View, {
			tag = "row size-full-0 auto-y align-y-center gap-medium",
			LayoutOrder = v12.LayoutOrder
		}, {
			Avatar = v12.replyingToUserId and React.createElement(Foundation.Avatar, {
				LayoutOrder = 1,
				userId = v12.replyingToUserId,
				userPresence = v14.presence,
				backgroundStyle = v13.Color.Surface.Surface_200,
				size = Foundation.Enums.InputSize.Medium
			}) or nil,
			Text = React.createElement(ReplyComposeBarText, {
				layoutOrder = 2,
				userText = v12.replyingToUserText,
				contentText = v12.replyingToUserContent
			}),
			CloseButton = React.createElement(Foundation.IconButton, {
				isCircular = true,
				LayoutOrder = 3,
				onActivated = v12.onCloseActivated,
				icon = BuilderIcons.Icon.X,
				variant = Foundation.Enums.ButtonVariant.Utility,
				size = Foundation.Enums.InputSize.Medium
			})
		}))
	end

	return (React.createElement(Foundation.View, {
		tag = "col",
		Size = UDim2.new(1, 0, 0, v12.totalHeight),
		LayoutOrder = v12.LayoutOrder
	}, {
		TopBorder = React.createElement(Foundation.View, {
			tag = "size-full-50 bg-surface-100",
			LayoutOrder = 1
		}),
		ContentFrame = React.createElement(Foundation.View, {
			tag = "row size-full-0 fill align-y-center padding-medium gap-medium",
			LayoutOrder = 2
		}, {
			Avatar = v12.replyingToUserId and React.createElement(Foundation.Avatar, {
				LayoutOrder = 1,
				userId = v12.replyingToUserId,
				userPresence = v14.presence,
				backgroundStyle = v13.Color.Surface.Surface_100,
				size = Foundation.Enums.InputSize.Medium
			}) or nil,
			Text = React.createElement(ReplyComposeBarText, {
				layoutOrder = 2,
				userText = v12.replyingToUserText,
				contentText = v12.replyingToUserContent
			}),
			CloseButton = React.createElement(Foundation.IconButton, {
				isCircular = true,
				LayoutOrder = 3,
				onActivated = v12.onCloseActivated,
				icon = BuilderIcons.Icon.X,
				variant = Foundation.Enums.ButtonVariant.Utility,
				size = Foundation.Enums.InputSize.Medium
			})
		})
	}))
end

return React.memo(ReplyComposeBar)
