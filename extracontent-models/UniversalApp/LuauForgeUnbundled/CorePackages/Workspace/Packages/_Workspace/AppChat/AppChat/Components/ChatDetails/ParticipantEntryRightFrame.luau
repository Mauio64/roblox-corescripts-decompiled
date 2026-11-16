local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle

local Label = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Label/Label")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")

local buttonVariant = Foundation.Enums.ButtonVariant
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local v5 = {
	onDotsActivated = function() end,
	shouldShowDots = false
}

function LUAUFORGE_MODULE_GLOBALS_hsM_ParticipantEntryRightFrame(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6

	local createElement = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		[React.Change.AbsoluteSize] = joined[React.Change.AbsoluteSize]
	}
	local v9 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 22),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 22),
			PaddingRight = UDim.new(0, 22)
		}),
		label = 0,
		dots = 0
	}

	local v10 = if joined.labelText then React.createElement(Label, {
		backgroundColor3 = style.Theme.BackgroundContrast.Color,
		backgroundTransparency = style.Theme.BackgroundContrast.Transparency,
		bodyText = joined.labelText,
		layoutOrder = 1
	}) else nil
	v9.label = v10
	local v11

	if joined.shouldShowDots then
		local createElement2 = React.createElement
		local v13 = {
			Size = UDim2.new(0, 20, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Name = "dots"
		}

		local createElement3 = React.createElement
		local v16 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			icon = iconName.ThreeDotsHorizontal,
			onActivated = joined.onDotsActivated,
			Position = UDim2.fromScale(0.5, 0.5),
			ref = joined.dotsRef,
			Size = UDim2.new(0, 36, 0, 36),
			testId = 0,
			size = 0,
			variant = 0
		}
		local v17 = if FFlagDebugAppChatEnableDomLocators then joined.testId else nil
		v16.testId = v17
		v16.size = iconSize.Medium
		v16.variant = buttonVariant.Utility
		v11 = createElement2("Frame", v13, {
			Dots = createElement3(iconButton, v16)
		})
	end

	v9.dots = v11
	return createElement("Frame", v8, v9)
end

return memo(LUAUFORGE_MODULE_GLOBALS_hsM_ParticipantEntryRightFrame)
