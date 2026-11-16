local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local IconWithTextCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/IconWithTextCell")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local v5 = {
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

function LUAUFORGE_MODULE_GLOBALS_hsI_GroupNameEntryCell(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = not joined.isDisabled and 0 or joined.style.Tokens.Size.Size_300

	local createElement = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.fromScale(1, 0)
	}
	local v9 = {
		padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v6),
			PaddingBottom = UDim.new(0, joined.paddingBottom)
		})
	}

	local createElement2 = React.createElement
	local v13 = if not joined.isDisabled then joined.iconImage else nil
	local v12 = {
		primaryIcon = v13,
		Text = joined.groupNameText,
		iconCellWidth = joined.iconCellWidth,
		showDivider = false,
		isDisabled = joined.isDisabled,
		onActivated = joined.onActivated,
		LayoutOrder = 1,
		Size = UDim2.new(1, -v6, 0, joined.cellHeight),
		style = joined.style,
		testId = 0
	}

	local v14 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatDetailsListActionButton(joined.groupNameText) else nil
	v12.testId = v14
	return createElement("Frame", v8, v9, {
		IconWithText = createElement2(IconWithTextCell, v12)
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hsI_GroupNameEntryCell)
