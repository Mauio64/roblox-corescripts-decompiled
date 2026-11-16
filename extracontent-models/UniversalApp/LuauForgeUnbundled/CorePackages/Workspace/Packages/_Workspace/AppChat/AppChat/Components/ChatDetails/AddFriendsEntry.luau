local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local IconWithTextCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/IconWithTextCell")

local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local v5 = {
	Text = "(translated 'add friends' text here)",
	iconImage = nil,
	iconSize = 36,
	iconCellWidth = 60,
	cellHeight = 64,
	onActivated = nil,
	LayoutOrder = 0,
	style = nil
}

function LUAUFORGE_MODULE_GLOBALS_hsK_AddFriendsEntry(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local createElement = React.createElement
	local v7 = {
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

	local v8 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatDetailsListActionButton(joined.Text) else nil
	v7.testId = v8
	return createElement(IconWithTextCell, v7)
end

return memo(LUAUFORGE_MODULE_GLOBALS_hsK_AddFriendsEntry)
