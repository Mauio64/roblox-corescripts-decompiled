local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local withCommonProps = Foundation.Utility.withCommonProps

local iconSize = Foundation.Enums.IconSize
local stateLayerMode = Foundation.Enums.StateLayerMode
local cursorType = Foundation.Enums.CursorType

local function SduiDualActionChip(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local position = props.position

	local v5 = useCursor(cursorType.SmallPill)
	local v6 = useTokens()

	if not (props.leadingIconName or props.trailingIconName) then
		return React.createElement(React.Fragment, {}, {})
	end

	local leadingOnActivated = props.leadingOnActivated or function() end
	local trailingOnActivated = props.trailingOnActivated or function() end

	local v7 = withCommonProps(props, {
		selection = { Selectable = true, SelectionImageObject = v5 },
		stateLayer = { mode = stateLayerMode.Inverse },
		backgroundStyle = v6.Color.ActionStandard.Background,
		tag = "row size-0-800 auto-x radius-circle align-y-center"
	})

	local createElement = React.createElement

	local join = Cryo.Dictionary.join

	local tag = React.Tag
	local v10 = if props.testId then `data-testid={props.testId}` else nil
	local v11 = join(v7, {
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		Position = position,
		[tag] = v10
	})
	local v13

	if props.leadingIconName then
		local createElement2 = React.createElement
		local v15 = {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			onActivated = leadingOnActivated
		}

		local v16 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v6.Radius.Large)
			}),
			Content = 0
		}

		local createElement3 = React.createElement

		local tag2 = React.Tag
		local v19 = if props.testId then `data-testid={props.testId}-leading` else nil
		local v18 = {
			tag = "row fill auto-xy size-full-800 align-y-center padding-left-medium padding-right-small gap-small",
			[tag2] = v19
		}

		local v20 = {
			Icon = React.createElement(icon, {
				LayoutOrder = 1,
				name = props.leadingIconName,
				variant = props.leadingIconVariant,
				size = iconSize.Small
			}),
			Text = 0
		}

		local v21 = if props.text and props.text ~= "" then React.createElement(text, {
			LayoutOrder = 2,
			Text = props.text,
			textStyle = v6.Color.ActionStandard.Foreground,
			tag = "auto-x size-0-full shrink text-label-medium text-truncate-end"
		}) else nil
		v20.Text = v21
		v16.Content = createElement3(view, v18, v20)
		v13 = createElement2(view, v15, v16)
	end

	local v14 = if props.leadingIconName and props.trailingIconName then React.createElement(view, {
		LayoutOrder = 2,
		Size = UDim2.new(0, 1, 0, 16),
		tag = "bg-shift-200"
	}) else nil
	local v15

	if props.trailingIconName then
		local createElement2 = React.createElement
		local v17 = {
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			onActivated = trailingOnActivated
		}

		local v18 = {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v6.Radius.Circle)
			}),
			Content = 0
		}

		local createElement3 = React.createElement

		local tag2 = React.Tag
		local v21 = if props.testId then `data-testid={props.testId}-trailing` else nil
		v18.Content = createElement3(
			view,
			{
				tag = "row fill auto-xy align-y-center align-x-center size-full-800 padding-right-medium padding-left-small",
				[tag2] = v21
			},
			{
				Icon = React.createElement(icon, {
					LayoutOrder = 1,
					name = props.trailingIconName,
					variant = props.trailingIconVariant,
					size = iconSize.Small
				})
			}
		)
		v15 = createElement2(view, v17, v18)
	end

	return createElement(view, v11, {
		LeftActionButton = v13,
		Divider = v14,
		RightActionButton = v15
	})
end

return React.memo(SduiDualActionChip)
