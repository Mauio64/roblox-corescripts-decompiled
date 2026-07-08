local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local IconWithTextCell = require(AppChat.Components.Cells.IconWithTextCell)
local RoactFitComponents = require(AppChatParent.LuaSocialLibrariesDeps).RoactFitComponents
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local t1 = {
	leaveGroupText = "leaveGroupText",
	onActivated = nil,
	iconImage = nil,
	cellHeight = 64,
	iconCellWidth = 60,
	marginTop = 12,
	LayoutOrder = 0,
	style = nil
}

function LeaveGroupCell(t2: {[any]: any}) -- line: 37
	-- upvalues: Cryo (copy), t1 (copy), React (copy), RoactFitComponents (copy), IconWithTextCell (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)

	return React.createElement(RoactFitComponents.FitFrameVertical, {
		BackgroundTransparency = 1,
		LayoutOrder = v12.LayoutOrder,
		width = UDim.new(1, 0),
		margin = {
			left = 0,
			right = 0,
			bottom = 0,
			top = v12.marginTop
		}
	}, {
		LeaveGroupRow = React.createElement(IconWithTextCell, {
			showDivider = false,
			LayoutOrder = v12.LayoutOrder,
			onActivated = v12.onActivated,
			primaryIcon = v12.iconImage,
			Size = UDim2.new(1, 0, 0, v12.cellHeight),
			style = v12.style,
			Text = v12.leaveGroupText,
			iconCellWidth = v12.iconCellWidth,
			testId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsListActionButton(v12.leaveGroupText)
		})
	})
end

return memo(LeaveGroupCell)
