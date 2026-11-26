local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local ConversationTitleWithFacePile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationTitleWithFacePile")
local FFlagAppChatFoundationHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFoundationHeaderBar")
local useTokens = Foundation.Hooks.useTokens

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local function HeaderBarTitleLeftAligned(props)
	local v5 = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		Size = UDim2.new(1, 0, 1, 0),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v5.Gap.Medium),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}
	}

	local v8 = if props.renderLeft then React.createElement(
		Foundation.View,
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 1,
			ItemLineAlignment = Enum.ItemLineAlignment.Center
		},
		React.createElement(props.renderLeft)
	) else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v9 = {
		flexItem = { FlexMode = Enum.UIFlexMode.Fill },
		Size = 0,
		LayoutOrder = 2
	}

	local v10 = if FFlagAppChatFoundationHeaderBar then UDim2.new(1, 0, 0, v5.Size.Size_1000) else UDim2.new(1, 0, 1, 0)
	v9.Size = v10
	local v7 = {
		LeftFrame = v8,
		CenterFrame = createElement2(view2, v9, {
			ConversationTitle = React.createElement(ConversationTitleWithFacePile, {
				titleText = props.titleText,
				conversationId = props.conversationId,
				navigateToChatDetails = props.navigateToChatDetails
			})
		}),
		RightFrame = 0
	}

	local v11 = if props.renderRight then React.createElement(Foundation.View, {
		tag = not props.ignoreRightMargin and "padding-right-small" or nil,
		AutomaticSize = Enum.AutomaticSize.XY,
		ItemLineAlignment = Enum.ItemLineAlignment.Center,
		LayoutOrder = 3
	}, React.createElement(props.renderRight)) else nil
	v7.RightFrame = v11
	return createElement(view, v6, v7)
end

return HeaderBarTitleLeftAligned
