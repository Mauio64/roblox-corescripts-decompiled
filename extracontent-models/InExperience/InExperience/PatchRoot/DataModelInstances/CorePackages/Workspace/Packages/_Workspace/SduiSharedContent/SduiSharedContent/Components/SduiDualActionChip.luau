local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Cryo = require(parent.Cryo)
require(parent.SduiCompat)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local withCommonProps = Foundation.Utility.withCommonProps

local IconSize = Foundation.Enums.IconSize
local StateLayerMode = Foundation.Enums.StateLayerMode
local CursorType = Foundation.Enums.CursorType

local function SduiDualActionChip(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local position = props.position

	local selectionImageObject = useCursor(CursorType.SmallPill)
	local v = useTokens()

	if not (props.leadingIconName or props.trailingIconName) then
		return React.createElement(React.Fragment, {}, {})
	end

	local leadingOnActivated = props.leadingOnActivated or function() end
	local trailingOnActivated = props.trailingOnActivated or function() end

	local v2 = withCommonProps(props, {
		selection = { Selectable = true, SelectionImageObject = selectionImageObject },
		stateLayer = { mode = StateLayerMode.Inverse },
		backgroundStyle = v.Color.ActionStandard.Background,
		tag = "row size-0-800 auto-x radius-circle align-y-center"
	})

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	local tag = React.Tag
	local v3

	if props.testId then
		v3 = `data-testid={props.testId}`
	end

	local v4 = join(v2, {
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		Position = position,
		[tag] = v3
	})
	local leftActionButton

	if props.leadingIconName then
		local createElement2 = React.createElement
		local v5 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			onActivated = leadingOnActivated
		}

		local v6 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v.Radius.Large)
			}),
			Content = 0
		}

		local createElement3 = React.createElement

		local tag2 = React.Tag
		local v7

		if props.testId then
			v7 = `data-testid={props.testId}-leading`
		end

		local v8 = {
			tag = "row fill auto-xy size-full-800 align-y-center padding-left-medium padding-right-small gap-small",
			[tag2] = v7
		}

		local v9 = {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = props.leadingIconName,
				variant = props.leadingIconVariant,
				size = IconSize.Small
			}),
			Text = 0
		}
		local text

		if props.text and props.text ~= "" then
			text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.text,
				textStyle = v.Color.ActionStandard.Foreground,
				tag = "auto-x size-0-full shrink text-label-medium text-truncate-end"
			})
		end

		v9.Text = text
		v6.Content = createElement3(View, v8, v9)
		leftActionButton = createElement2(View, v5, v6)
	end

	local divider

	if props.leadingIconName and props.trailingIconName then
		divider = React.createElement(View, {
			LayoutOrder = 2,
			Size = UDim2.new(0, 1, 0, 16),
			tag = "bg-shift-200"
		})
	end

	local rightActionButton

	if props.trailingIconName then
		local createElement2 = React.createElement
		local v5 = {
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			onActivated = trailingOnActivated
		}

		local v6 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v.Radius.Circle)
			}),
			Content = 0
		}

		local createElement3 = React.createElement

		local tag2 = React.Tag
		local v7

		if props.testId then
			v7 = `data-testid={props.testId}-trailing`
		end

		v6.Content = createElement3(
			View,
			{
				tag = "row fill auto-xy align-y-center align-x-center size-full-800 padding-right-medium padding-left-small",
				[tag2] = v7
			},
			{
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = props.trailingIconName,
					variant = props.trailingIconVariant,
					size = IconSize.Small
				})
			}
		)
		rightActionButton = createElement2(View, v5, v6)
	end

	return createElement(View, v4, {
		LeftActionButton = leftActionButton,
		Divider = divider,
		RightActionButton = rightActionButton
	})
end

return React.memo(SduiDualActionChip)
