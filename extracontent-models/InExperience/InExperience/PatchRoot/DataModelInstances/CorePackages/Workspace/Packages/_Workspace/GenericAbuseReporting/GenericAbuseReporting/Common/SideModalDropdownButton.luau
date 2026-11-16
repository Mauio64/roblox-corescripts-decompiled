local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SharedFlags = require(parent.SharedFlags)
local FFlagPrefillPreciseSelectionChoices = SharedFlags.FFlagPrefillPreciseSelectionChoices

local function SideModalDropdown(props)
	local v = useTokens()
	local state, setState = React.useState(false)
	local v2 = useLocalization({ ChooseOne = "Feature.ReportAbuse.Label.ChooseOne" })

	local onStateChanged = React.useCallback(function(p)
		if p == ControlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, { setState })

	local createElement = React.createElement
	local size

	if FFlagPrefillPreciseSelectionChoices then
		size = UDim2.new(1, 0, 0, 48)
	else
		size = UDim2.new(0, 0, 0, 48)
	end

	local v3 = {
		Size = size,
		tag = "auto-x radius-medium align-x-left align-y-center padding-xxsmall bg-shift-100",
		onStateChanged = onStateChanged,
		onActivated = props.onActivated,
		LayoutOrder = 0
	}
	local layoutOrder

	if FFlagPrefillPreciseSelectionChoices then
		layoutOrder = props.layoutOrder
	end

	v3.LayoutOrder = layoutOrder

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
			Text = props.text or v2.ChooseOne,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -44, 1, 0),
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
