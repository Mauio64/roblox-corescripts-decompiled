local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo

local IconWithTextCell = require(AppChat.Components.Cells.IconWithTextCell)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local v = {
	groupNameText = "groupName",
	iconImage = nil,
	onActivated = nil,
	LayoutOrder = 1,
	iconCellWidth = 60,
	isDisabled = false,
	cellHeight = 36,
	style = nil,
	paddingBottom = 12
}

function GroupNameEntryCell(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = not joined.isDisabled and 0 or joined.style.Tokens.Size.Size_300

	local createElement = React.createElement
	local v3 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.fromScale(1, 0)
	}
	local v4 = {
		padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v2),
			PaddingBottom = UDim.new(0, joined.paddingBottom)
		})
	}

	local createElement2 = React.createElement
	local primaryIcon

	if not joined.isDisabled then
		primaryIcon = joined.iconImage
	end

	local v5 = {
		primaryIcon = primaryIcon,
		Text = joined.groupNameText,
		iconCellWidth = joined.iconCellWidth,
		showDivider = false,
		isDisabled = joined.isDisabled,
		onActivated = joined.onActivated,
		LayoutOrder = 1,
		Size = UDim2.new(1, -v2, 0, joined.cellHeight),
		style = joined.style,
		testId = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.chatDetailsListActionButton(joined.groupNameText)
	end

	v5.testId = testId
	return createElement("Frame", v3, v4, {
		IconWithText = createElement2(IconWithTextCell, v5)
	})
end

return memo(GroupNameEntryCell)
