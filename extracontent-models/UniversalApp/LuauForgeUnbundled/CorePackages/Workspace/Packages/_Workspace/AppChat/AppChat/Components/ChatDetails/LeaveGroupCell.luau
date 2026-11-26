local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local IconWithTextCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/IconWithTextCell")
local roactFitComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").RoactFitComponents

local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local v5 = {
	leaveGroupText = "leaveGroupText",
	onActivated = nil,
	iconImage = nil,
	cellHeight = 64,
	iconCellWidth = 60,
	marginTop = 12,
	LayoutOrder = 0,
	style = nil
}

function LUAUFORGE_MODULE_GLOBALS_hDV_LeaveGroupCell(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local createElement = React.createElement
	local fitFrameVertical = roactFitComponents.FitFrameVertical
	local v6 = {
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		width = UDim.new(1, 0),
		margin = { top = joined.marginTop, left = 0, right = 0, bottom = 0 }
	}

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = joined.LayoutOrder,
		onActivated = joined.onActivated,
		primaryIcon = joined.iconImage,
		showDivider = false,
		Size = UDim2.new(1, 0, 0, joined.cellHeight),
		style = joined.style,
		Text = joined.leaveGroupText,
		iconCellWidth = joined.iconCellWidth,
		testId = 0
	}

	local v10 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatDetailsListActionButton(joined.leaveGroupText) else nil
	v9.testId = v10
	return createElement(fitFrameVertical, v6, {
		LeaveGroupRow = createElement2(IconWithTextCell, v9)
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hDV_LeaveGroupCell)
