local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local ConversationTitleWithFacePile = require(AppChat.Components.ChatConversation.ConversationTitleWithFacePile)
local FFlagAppChatFoundationHeaderBar = require(AppChat.Flags.FFlagAppChatFoundationHeaderBar)
local useTokens = Foundation.Hooks.useTokens

local React = require(parent.React)

local function HeaderBarTitleLeftAligned(props)
	local v = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		Size = UDim2.new(1, 0, 1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v.Gap.Medium),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}
	}
	local leftFrame

	if props.renderLeft then
		leftFrame = React.createElement(
			Foundation.View,
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 1,
				ItemLineAlignment = Enum.ItemLineAlignment.Center
			},
			React.createElement(props.renderLeft)
		)
	end

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v4 = {
		flexItem = { FlexMode = Enum.UIFlexMode.Fill },
		Size = 0,
		LayoutOrder = 2
	}
	local size

	if FFlagAppChatFoundationHeaderBar then
		size = UDim2.new(1, 0, 0, v.Size.Size_1000)
	else
		size = UDim2.new(1, 0, 1, 0)
	end

	v4.Size = size
	local v3 = {
		LeftFrame = leftFrame,
		CenterFrame = createElement2(view2, v4, {
			ConversationTitle = React.createElement(ConversationTitleWithFacePile, {
				titleText = props.titleText,
				conversationId = props.conversationId,
				navigateToChatDetails = props.navigateToChatDetails
			})
		}),
		RightFrame = 0
	}
	local rightFrame

	if props.renderRight then
		rightFrame = React.createElement(Foundation.View, {
			tag = not props.ignoreRightMargin and "padding-right-small" or nil,
			AutomaticSize = Enum.AutomaticSize.XY,
			ItemLineAlignment = Enum.ItemLineAlignment.Center,
			LayoutOrder = 3
		}, React.createElement(props.renderRight))
	end

	v3.RightFrame = rightFrame
	return createElement(view, v2, v3)
end

return HeaderBarTitleLeftAligned
