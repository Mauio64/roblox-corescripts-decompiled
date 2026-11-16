local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local IconWithTextCell = require(AppChat.Components.Cells.IconWithTextCell)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local RoactFitComponents = LuaSocialLibrariesDeps.RoactFitComponents

local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local v = {
	leaveGroupText = "leaveGroupText",
	onActivated = nil,
	iconImage = nil,
	cellHeight = 64,
	iconCellWidth = 60,
	marginTop = 12,
	LayoutOrder = 0,
	style = nil
}

function LeaveGroupCell(p)
	local joined = Cryo.Dictionary.join(v, p)

	local createElement = React.createElement
	local fitFrameVertical = RoactFitComponents.FitFrameVertical
	local v2 = {
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		width = UDim.new(1, 0),
		margin = { top = joined.marginTop, left = 0, right = 0, bottom = 0 }
	}

	local createElement2 = React.createElement
	local v3 = {
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
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.chatDetailsListActionButton(joined.leaveGroupText)
	end

	v3.testId = testId
	return createElement(fitFrameVertical, v2, {
		LeaveGroupRow = createElement2(IconWithTextCell, v3)
	})
end

return memo(LeaveGroupCell)
