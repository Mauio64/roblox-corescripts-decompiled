local parent = script.Parent.Parent.Parent.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local TouchControlIcon = require(script.Parent.TouchControlIcon)
require(script.Parent.TouchControlList)

local function TouchDeviceMock(props)
	local layout = props.layout
	local v = Foundation.Hooks.useTokens()

	local v2 = v.Gap.XXSmall / (not (props.scale > 0) and 1 or props.scale)
	local children = {}

	for i, slot in ipairs(props.slots) do
		local v3 = layout.centerButtonPosition + layout.slotOffsets[i]
		children[slot.id] = React.createElement(TouchControlIcon, {
			name = slot.icon,
			assetId = slot.assetId,
			diameter = layout.smallButtonSize,
			disabled = slot.disabled,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(v3.X, v3.Y),
			testId = "TouchMockIcon-" .. slot.id
		})
	end

	for i = 1, 3 do
		children["TopAction" .. i] = React.createElement(TouchControlIcon, {
			name = Foundation.Enums.IconName.DiamondSimplified,
			diameter = layout.smallButtonSize,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(
				1,
				-layout.sidePadding - (i - 1) * (layout.smallButtonSize + layout.topGap),
				0,
				layout.topPadding
			),
			testId = "TouchMockTopAction-" .. i
		})
	end

	children[props.centerControl.id] = React.createElement(TouchControlIcon, {
		name = props.centerControl.icon,
		assetId = props.centerControl.assetId,
		diameter = layout.centerButtonSize,
		disabled = props.centerControl.disabled,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(layout.centerButtonPosition.X, layout.centerButtonPosition.Y),
		testId = "TouchMock" .. props.centerControl.id
	})

	children.Roblox = React.createElement(TouchControlIcon, {
		name = Foundation.Enums.IconName.Tilt,
		diameter = layout.smallButtonSize,
		inverted = true,
		Position = UDim2.fromOffset(layout.sidePadding, layout.topPadding),
		testId = "TouchMockRoblox"
	})

	children.InnerOutline = React.createElement(Foundation.View, {
		Position = UDim2.fromOffset(v2, v2),
		Size = UDim2.new(1, -2 * v2, 1, -2 * v2),
		cornerRadius = UDim.new(0, (math.max(0, layout.cornerRadius - layout.inset + v2))),
		stroke = {
			Color = v.Color.Extended.White.White_100.Color3,
			Transparency = v.Color.Extended.White.White_100.Transparency,
			Thickness = 0.33
		},
		testId = "TouchMockInnerOutline"
	})

	return React.createElement("CanvasGroup", {
		Name = "TouchDeviceMock",
		Size = UDim2.fromOffset(layout.size.X, layout.size.Y),
		BackgroundTransparency = 1,
		GroupTransparency = 0,
		[React.Tag] = "data-testid=TouchDeviceMock"
	}, {
		Scale = React.createElement("UIScale", {
			Scale = props.scale,
			[React.Tag] = "data-testid=TouchDeviceMockScale"
		}),
		Phone = React.createElement(Foundation.View, {
			Position = UDim2.fromOffset(layout.inset / 2, layout.inset / 2),
			Size = UDim2.new(1, -layout.inset, 1, -layout.inset),
			cornerRadius = UDim.new(0, layout.cornerRadius),
			stroke = {
				Color = v.Color.Extended.White.White_100.Color3,
				Transparency = v.Color.Extended.White.White_100.Transparency,
				Thickness = 0.75
			},
			testId = "TouchMockOuterOutline"
		}, children)
	})
end

return React.memo(TouchDeviceMock)
