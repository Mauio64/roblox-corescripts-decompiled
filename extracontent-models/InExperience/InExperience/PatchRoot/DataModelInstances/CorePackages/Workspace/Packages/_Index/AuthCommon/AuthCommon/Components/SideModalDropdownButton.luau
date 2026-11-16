local parent = script:FindFirstAncestor("AuthCommon").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function SideModalDropdown(props)
	local v = useTokens()
	local state, setState = React.useState(false)
	local onStateChanged = React.useCallback(function(p)
		if p == ControlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, { setState })

	local height = props.height or 40

	local v2 = props.fixSizeToParent and 1 or 0

	local createElement = React.createElement
	local v3 = {
		Size = UDim2.new(v2, 0, 0, height),
		tag = {
			["auto-x"] = not props.fixSizeToParent,
			["radius-medium"] = true,
			["align-x-left"] = true,
			["align-y-center"] = true,
			["padding-xxsmall"] = true,
			["bg-shift-100"] = true
		},
		onStateChanged = onStateChanged,
		onActivated = props.onActivated,
		backgroundStyle = props.backgroundColorToken
	}

	local createElement2 = React.createElement
	local v4 = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = 0,
		Transparency = 0,
		Thickness = 0
	}
	local color

	if props.isDropdownError then
		color = v.Color.System.Alert.Color3
	else
		color = v.Color.Stroke.Default.Color3
	end

	v4.Color = color
	local transparency

	if props.isDropdownError then
		transparency = v.Color.System.Alert.Transparency
	elseif state then
		transparency = v.Color.Stroke.Emphasis.Transparency
	else
		transparency = v.Color.Stroke.Default.Transparency
	end

	v4.Transparency = transparency

	v4.Thickness = v.Stroke.Standard
	return createElement(View, v3, {
		UIStroke = createElement2("UIStroke", v4),
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Text = React.createElement(Text, {
			Text = props.text or "",
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 1, 0),
			tag = "text-truncate-split padding-left-small",
			LayoutOrder = 0
		}),
		IconContainer = React.createElement(View, {
			tag = "auto-xy padding-right-small",
			LayoutOrder = 1
		}, {
			Icon = React.createElement(Icon, {
				name = "icons/actions/truncationExpand",
				size = IconSize.Medium,
				LayoutOrder = 1
			})
		})
	})
end

return SideModalDropdown
