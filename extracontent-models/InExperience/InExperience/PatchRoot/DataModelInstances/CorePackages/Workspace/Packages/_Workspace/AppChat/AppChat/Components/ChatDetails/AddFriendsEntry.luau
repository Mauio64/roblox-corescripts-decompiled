local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local IconWithTextCell = require(AppChat.Components.Cells.IconWithTextCell)

local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local v = {
	Text = "(translated 'add friends' text here)",
	iconImage = nil,
	iconSize = 36,
	iconCellWidth = 60,
	cellHeight = 64,
	onActivated = nil,
	LayoutOrder = 0,
	style = nil
}

function AddFriendsEntry(p)
	local joined = Cryo.Dictionary.join(v, p)
	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 0, joined.cellHeight),
		primaryIcon = joined.iconImage,
		primaryIconSize = joined.iconSize,
		iconCellWidth = joined.iconCellWidth,
		Text = joined.Text,
		onActivated = joined.onActivated,
		LayoutOrder = joined.LayoutOrder,
		style = joined.style,
		showDivider = false,
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.chatDetailsListActionButton(joined.Text)
	end

	v2.testId = testId
	return createElement(IconWithTextCell, v2)
end

return memo(AddFriendsEntry)
