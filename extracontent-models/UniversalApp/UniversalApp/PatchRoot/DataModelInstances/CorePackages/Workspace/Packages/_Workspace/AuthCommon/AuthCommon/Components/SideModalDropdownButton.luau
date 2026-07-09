local Parent = script:FindFirstAncestor("AuthCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local FFlagUseBirthdayDropdownForGamepad = require(Parent.SharedFlags).FFlagUseBirthdayDropdownForGamepad

local function SideModalDropdown(t1: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), React (copy), ControlState (copy), FFlagUseBirthdayDropdownForGamepad (copy), View (copy), FoundationText (copy), Icon (copy), IconSize (copy)
	local v13 = useTokens()
	local v14, v15 = React.useState(false)
	local v16 = React.useCallback(function(p1) -- line: 35
		-- upvalues: ControlState (copy), v15 (copy)
		if p1 == ControlState.Hover then
			v15(true)

			return
		end

		v15(false)
	end, { v15 })
	local n1 = 40

	if FFlagUseBirthdayDropdownForGamepad then
		n1 = t1.height or n1
	end

	local v18 = not t1.fixSizeToParent and 0 or 1

	return React.createElement(View, {
		Size = UDim2.new(v18, 0, 0, n1),
		tag = {
			["auto-x"] = not t1.fixSizeToParent,
			["radius-medium"] = true,
			["align-x-left"] = true,
			["align-y-center"] = true,
			["padding-xxsmall"] = true,
			["bg-shift-100"] = true
		},
		onStateChanged = v16,
		onActivated = t1.onActivated,
		backgroundStyle = if not FFlagUseBirthdayDropdownForGamepad then nil else t1.backgroundColorToken
	}, {
		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = if not t1.isDropdownError then v13.Color.Stroke.Default.Color3 else v13.Color.System.Alert.Color3,
			Transparency = if not t1.isDropdownError then if not v14 then v13.Color.Stroke.Default.Transparency else v13.Color.Stroke.Emphasis.Transparency else v13.Color.System.Alert.Transparency,
			Thickness = v13.Stroke.Standard
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
			Text = t1.text or "",
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 1, 0)
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
