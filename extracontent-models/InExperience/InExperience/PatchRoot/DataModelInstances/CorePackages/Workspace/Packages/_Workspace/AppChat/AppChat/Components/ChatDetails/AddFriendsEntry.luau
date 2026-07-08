local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local IconWithTextCell = require(AppChat.Components.Cells.IconWithTextCell)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local t1 = {
	Text = "(translated 'add friends' text here)",
	iconImage = nil,
	iconSize = 36,
	iconCellWidth = 60,
	cellHeight = 64,
	onActivated = nil,
	LayoutOrder = 0,
	style = nil
}

function AddFriendsEntry(t2: {[any]: any}) -- line: 36
	-- upvalues: Cryo (copy), t1 (copy), React (copy), IconWithTextCell (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	local v11 = Cryo.Dictionary.join(t1, t2)

	return React.createElement(IconWithTextCell, {
		showDivider = false,
		Size = UDim2.new(1, 0, 0, v11.cellHeight),
		primaryIcon = v11.iconImage,
		primaryIconSize = v11.iconSize,
		iconCellWidth = v11.iconCellWidth,
		Text = v11.Text,
		onActivated = v11.onActivated,
		LayoutOrder = v11.LayoutOrder,
		style = v11.style,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsListActionButton(v11.Text)
	})
end

return memo(AddFriendsEntry)
