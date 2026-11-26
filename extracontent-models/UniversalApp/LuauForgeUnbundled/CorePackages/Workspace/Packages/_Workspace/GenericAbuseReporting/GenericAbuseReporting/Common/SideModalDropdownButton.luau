local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization

local fFlagPrefillPreciseSelectionChoices = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagPrefillPreciseSelectionChoices

local function SideModalDropdown(props)
	local v5 = useTokens()
	local state, setState = React.useState(false)
	local v6 = useLocalization({ ChooseOne = "Feature.ReportAbuse.Label.ChooseOne" })

	local v7 = React.useCallback(function(p2)
		if p2 == controlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, { setState })

	local createElement = React.createElement

	local v10 = if fFlagPrefillPreciseSelectionChoices then UDim2.new(1, 0, 0, 48) else UDim2.new(0, 0, 0, 48)
	local v9 = {
		Size = v10,
		tag = "auto-x radius-medium align-x-left align-y-center padding-xxsmall bg-shift-100",
		onStateChanged = v7,
		onActivated = props.onActivated,
		LayoutOrder = 0
	}
	local v11 = if fFlagPrefillPreciseSelectionChoices then props.layoutOrder else nil
	v9.LayoutOrder = v11

	local createElement2 = React.createElement
	local v13 = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = 0,
		Transparency = 0,
		Thickness = 0
	}
	local v14 = if props.isDropdownError then v5.Color.System.Alert.Color3 else v5.Color.Stroke.Default.Color3
	v13.Color = v14
	local transparency

	if props.isDropdownError then
		transparency = v5.Color.System.Alert.Transparency
	elseif state then
		transparency = v5.Color.Stroke.Emphasis.Transparency
	else
		transparency = v5.Color.Stroke.Default.Transparency
	end

	v13.Transparency = transparency

	v13.Thickness = v5.Stroke.Standard
	return createElement(view, v9, {
		UIStroke = createElement2("UIStroke", v13),
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Text = React.createElement(text, {
			Text = props.text or v6.ChooseOne,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -44, 1, 0),
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
