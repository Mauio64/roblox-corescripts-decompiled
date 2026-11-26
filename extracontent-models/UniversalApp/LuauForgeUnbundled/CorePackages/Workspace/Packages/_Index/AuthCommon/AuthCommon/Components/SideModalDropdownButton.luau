local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function SideModalDropdown(props)
	local v5 = useTokens()
	local state, setState = React.useState(false)
	local v6 = React.useCallback(function(p2)
		if p2 == controlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, { setState })

	local height = props.height or 40

	local v7 = props.fixSizeToParent and 1 or 0

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.new(v7, 0, 0, height),
		tag = {
			["auto-x"] = not props.fixSizeToParent,
			["radius-medium"] = true,
			["align-x-left"] = true,
			["align-y-center"] = true,
			["padding-xxsmall"] = true,
			["bg-shift-100"] = true
		},
		onStateChanged = v6,
		onActivated = props.onActivated,
		backgroundStyle = props.backgroundColorToken
	}

	local createElement2 = React.createElement
	local v11 = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = 0,
		Transparency = 0,
		Thickness = 0
	}
	local v12 = if props.isDropdownError then v5.Color.System.Alert.Color3 else v5.Color.Stroke.Default.Color3
	v11.Color = v12
	local transparency

	if props.isDropdownError then
		transparency = v5.Color.System.Alert.Transparency
	elseif state then
		transparency = v5.Color.Stroke.Emphasis.Transparency
	else
		transparency = v5.Color.Stroke.Default.Transparency
	end

	v11.Transparency = transparency

	v11.Thickness = v5.Stroke.Standard
	return createElement(view, v9, {
		UIStroke = createElement2("UIStroke", v11),
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Text = React.createElement(text, {
			Text = props.text or "",
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 1, 0),
			tag = "text-truncate-split padding-left-small",
			LayoutOrder = 0
		}),
		IconContainer = React.createElement(
			view,
			{ tag = "auto-xy padding-right-small", LayoutOrder = 1 },
			{
				Icon = React.createElement(icon, {
					name = "icons/actions/truncationExpand",
					size = iconSize.Medium,
					LayoutOrder = 1
				})
			}
		)
	})
end

return SideModalDropdown
