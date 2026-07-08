local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FFlagPrefillPreciseSelectionChoices = require(Parent.SharedFlags).FFlagPrefillPreciseSelectionChoices

local function SideModalDropdown(t1: {[any]: any}) -- line: 29
	-- upvalues: useTokens (copy), React (copy), useLocalization (copy), ControlState (copy), View (copy), FFlagPrefillPreciseSelectionChoices (copy), FoundationText (copy), Icon (copy), IconSize (copy)
	local v14 = useTokens()
	local v15, v16 = React.useState(false)
	local v17 = useLocalization({
		ChooseOne = "Feature.ReportAbuse.Label.ChooseOne"
	})
	local v18 = React.useCallback(function(p1) -- line: 36
		-- upvalues: ControlState (copy), v16 (copy)
		if p1 == ControlState.Hover then
			v16(true)

			return
		end

		v16(false)
	end, { v16 })

	return React.createElement(View, {
		tag = "auto-x radius-medium align-x-left align-y-center padding-xxsmall bg-shift-100",
		Size = if not FFlagPrefillPreciseSelectionChoices then UDim2.new(0, 0, 0, 48) else UDim2.new(1, 0, 0, 48),
		onStateChanged = v18,
		onActivated = t1.onActivated,
		LayoutOrder = if not FFlagPrefillPreciseSelectionChoices then nil else t1.layoutOrder
	}, {
		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = if not t1.isDropdownError then v14.Color.Stroke.Default.Color3 else v14.Color.System.Alert.Color3,
			Transparency = if not t1.isDropdownError then if not v15 then v14.Color.Stroke.Default.Transparency else v14.Color.Stroke.Emphasis.Transparency else v14.Color.System.Alert.Transparency,
			Thickness = v14.Stroke.Standard
		}),
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Text = React.createElement(FoundationText, {
			tag = "text-truncate-split padding-left-small",
			LayoutOrder = 0,
			Text = t1.text or v17.ChooseOne,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -44, 1, 0)
		}),
		IconContainer = React.createElement(View, {
			tag = "auto-xy padding-right-small",
			LayoutOrder = 1
		}, {
			Icon = React.createElement(Icon, {
				name = "icons/actions/truncationExpand",
				LayoutOrder = 1,
				size = IconSize.Medium
			})
		})
	})
end

return SideModalDropdown
