local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Cryo = require(Parent.Cryo)

require(Parent.SduiCompat)

local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local withCommonProps = Foundation.Utility.withCommonProps
local IconSize = Foundation.Enums.IconSize
local StateLayerMode = Foundation.Enums.StateLayerMode
local CursorType = Foundation.Enums.CursorType

local function SduiDualActionChip(t1: {[any]: any}) -- line: 36
	-- upvalues: useCursor (copy), CursorType (copy), useTokens (copy), React (copy), withCommonProps (copy), StateLayerMode (copy), View (copy), Cryo (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	local layoutOrder = t1.layoutOrder
	local anchorPoint = t1.anchorPoint
	local position = t1.position
	local v19 = useCursor(CursorType.SmallPill)
	local v20 = useTokens()

	if not t1.leadingIconName and not t1.trailingIconName then
		return React.createElement(React.Fragment, {}, {})
	end

	local v21 = t1.leadingOnActivated or function() -- line: 50
	end
	local v22 = t1.trailingOnActivated or function() -- line: 51
	end
	local v23 = withCommonProps(t1, {
		tag = "row size-0-800 auto-x radius-circle align-y-center",
		selection = {
			Selectable = true,
			SelectionImageObject = v19
		},
		stateLayer = {
			mode = StateLayerMode.Inverse
		},
		backgroundStyle = v20.Color.ActionStandard.Background
	})

	return React.createElement(View, Cryo.Dictionary.join(v23, {
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		Position = position,
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`
	}), {
		LeftActionButton = if not t1.leadingIconName then nil else React.createElement(View, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			onActivated = v21
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v20.Radius.Large)
			}),
			Content = React.createElement(View, {
				tag = "row fill auto-xy size-full-800 align-y-center padding-left-medium padding-right-small gap-small",
				[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }-leading`
			}, {
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = t1.leadingIconName,
					variant = t1.leadingIconVariant,
					size = IconSize.Small
				}),
				Text = if not t1.text or t1.text == "" then nil else React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-x size-0-full shrink text-label-medium text-truncate-end",
					Text = t1.text,
					textStyle = v20.Color.ActionStandard.Foreground
				})
			})
		}),
		Divider = if not t1.leadingIconName or not t1.trailingIconName then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = "bg-shift-200",
			Size = UDim2.new(0, 1, 0, 16)
		}),
		RightActionButton = if not t1.trailingIconName then nil else React.createElement(View, {
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			onActivated = v22
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v20.Radius.Circle)
			}),
			Content = React.createElement(View, {
				tag = "row fill auto-xy align-y-center align-x-center size-full-800 padding-right-medium padding-left-small",
				[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }-trailing`
			}, {
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = t1.trailingIconName,
					variant = t1.trailingIconVariant,
					size = IconSize.Small
				})
			})
		})
	})
end

return React.memo(SduiDualActionChip)
