local Parent = script:FindFirstAncestor("AuthCommon").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function SideModalDropdown(t1: {[any]: any}) -- line: 30
	-- upvalues: useTokens (copy), React (copy), ControlState (copy), View (copy), FoundationText (copy), Icon (copy), IconSize (copy)
	local v12 = useTokens()
	local v13, v14 = React.useState(false)
	local v15 = React.useCallback(function(p1) -- line: 33
		-- upvalues: ControlState (copy), v14 (copy)
		if p1 == ControlState.Hover then
			v14(true)

			return
		end

		v14(false)
	end, { v14 })
	local v16 = t1.height or 40
	local v17 = not t1.fixSizeToParent and 0 or 1

	return React.createElement(View, {
		Size = UDim2.new(v17, 0, 0, v16),
		tag = {
			["auto-x"] = not t1.fixSizeToParent,
			["radius-medium"] = true,
			["align-x-left"] = true,
			["align-y-center"] = true,
			["padding-xxsmall"] = true,
			["bg-shift-100"] = true
		},
		onStateChanged = v15,
		onActivated = t1.onActivated,
		backgroundStyle = t1.backgroundColorToken
	}, {
		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = if not t1.isDropdownError then v12.Color.Stroke.Default.Color3 else v12.Color.System.Alert.Color3,
			Transparency = if not t1.isDropdownError then if not v13 then v12.Color.Stroke.Default.Transparency else v12.Color.Stroke.Emphasis.Transparency else v12.Color.System.Alert.Transparency,
			Thickness = v12.Stroke.Standard
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
