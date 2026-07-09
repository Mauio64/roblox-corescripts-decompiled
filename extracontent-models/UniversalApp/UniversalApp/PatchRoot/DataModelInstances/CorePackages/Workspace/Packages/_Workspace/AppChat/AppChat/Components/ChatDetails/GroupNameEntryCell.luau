local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local IconWithTextCell = require(AppChat.Components.Cells.IconWithTextCell)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local t1 = {
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

function GroupNameEntryCell(t2: {[any]: any}) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), React (copy), IconWithTextCell (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	local v11 = Cryo.Dictionary.join(t1, t2)
	local v12 = not v11.isDisabled and 0 or v11.style.Tokens.Size.Size_300

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = v11.LayoutOrder,
		Size = UDim2.fromScale(1, 0)
	}, {
		padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v12),
			PaddingBottom = UDim.new(0, v11.paddingBottom)
		})
	}, {
		IconWithText = React.createElement(IconWithTextCell, {
			showDivider = false,
			LayoutOrder = 1,
			primaryIcon = if not v11.isDisabled then v11.iconImage else nil,
			Text = v11.groupNameText,
			iconCellWidth = v11.iconCellWidth,
			isDisabled = v11.isDisabled,
			onActivated = v11.onActivated,
			Size = UDim2.new(1, -v12, 0, v11.cellHeight),
			style = v11.style,
			testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsListActionButton(v11.groupNameText)
		})
	})
end

return memo(GroupNameEntryCell)
