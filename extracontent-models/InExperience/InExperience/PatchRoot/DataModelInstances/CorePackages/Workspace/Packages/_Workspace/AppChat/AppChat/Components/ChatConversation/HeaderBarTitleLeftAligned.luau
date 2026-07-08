local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local ConversationTitleWithFacePile = require(AppChat.Components.ChatConversation.ConversationTitleWithFacePile)
local useTokens = Foundation.Hooks.useTokens
local React = require(AppChatParent.React)

local function HeaderBarTitleLeftAligned(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), ConversationTitleWithFacePile (copy)
	local v9 = useTokens()

	return React.createElement(Foundation.View, {
		Size = UDim2.new(1, 0, 1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v9.Gap.Medium),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}
	}, {
		LeftFrame = if not t1.renderLeft then nil else React.createElement(Foundation.View, {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			ItemLineAlignment = Enum.ItemLineAlignment.Center
		}, React.createElement(t1.renderLeft)),
		CenterFrame = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			flexItem = {
				FlexMode = Enum.UIFlexMode.Fill
			},
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			ConversationTitle = React.createElement(ConversationTitleWithFacePile, {
				titleText = t1.titleText,
				conversationId = t1.conversationId,
				navigateToChatDetails = t1.navigateToChatDetails
			})
		}),
		RightFrame = if not t1.renderRight then nil else React.createElement(Foundation.View, {
			LayoutOrder = 3,
			tag = not t1.ignoreRightMargin and "padding-right-small" or nil,
			AutomaticSize = Enum.AutomaticSize.XY,
			ItemLineAlignment = Enum.ItemLineAlignment.Center
		}, React.createElement(t1.renderRight))
	})
end

return HeaderBarTitleLeftAligned
