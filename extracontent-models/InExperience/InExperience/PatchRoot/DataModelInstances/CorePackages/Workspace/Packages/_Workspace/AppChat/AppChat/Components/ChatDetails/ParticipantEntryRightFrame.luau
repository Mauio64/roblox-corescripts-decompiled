local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local memo = React.memo
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local Label = require(AppChat.Components.Label.Label)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local v = {
	onDotsActivated = function() end,
	shouldShowDots = false
}

function ParticipantEntryRightFrame(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2

	local createElement = React.createElement
	local v3 = {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		[React.Change.AbsoluteSize] = joined[React.Change.AbsoluteSize]
	}
	local v4 = {
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
	local label

	if joined.labelText then
		label = React.createElement(Label, {
			backgroundColor3 = style.Theme.BackgroundContrast.Color,
			backgroundTransparency = style.Theme.BackgroundContrast.Transparency,
			bodyText = joined.labelText,
			layoutOrder = 1
		})
	end

	v4.label = label
	local dots

	if joined.shouldShowDots then
		local createElement2 = React.createElement
		local v5 = {
			Size = UDim2.new(0, 20, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Name = "dots"
		}

		local createElement3 = React.createElement
		local v6 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			icon = IconName.ThreeDotsHorizontal,
			onActivated = joined.onDotsActivated,
			Position = UDim2.fromScale(0.5, 0.5),
			ref = joined.dotsRef,
			Size = UDim2.new(0, 36, 0, 36),
			testId = 0,
			size = 0,
			variant = 0
		}
		local testId

		if FFlagDebugAppChatEnableDomLocators then
			testId = joined.testId
		end

		v6.testId = testId
		v6.size = IconSize.Medium
		v6.variant = ButtonVariant.Utility
		dots = createElement2("Frame", v5, { Dots = createElement3(IconButton, v6) })
	end

	v4.dots = dots
	return createElement("Frame", v3, v4)
end

return memo(ParticipantEntryRightFrame)
