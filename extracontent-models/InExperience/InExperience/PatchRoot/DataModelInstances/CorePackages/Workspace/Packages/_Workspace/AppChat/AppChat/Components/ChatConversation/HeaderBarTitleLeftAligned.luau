local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local ConversationTitleWithFacePile = require(AppChat.Components.ChatConversation.ConversationTitleWithFacePile)
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

	local v3 = {
		LeftFrame = leftFrame,
		CenterFrame = React.createElement(Foundation.View, {
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = 2
		}, {
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
