local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local IconVariant = BuilderIcons.IconVariant
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local Icon = require(Foundation.Components.Icon)
local InputSize = require(Foundation.Enums.InputSize)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local StateLayerMode = require(Foundation.Enums.StateLayerMode)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-snackbar"
}
local t2 = {
	colorNamespace = ColorNamespace.Inverse
}

local function Snackbar(p1, p2) -- line: 56
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useScaledValue (copy), IconVariant (copy), React (copy), View (copy), withCommonProps (copy), PresentationContext (copy), t2 (copy), Icon (copy), Dash (copy), Text (copy), StateLayerMode (copy), CloseAffordance (copy), InputSize (copy), CloseAffordanceVariant (copy)
	local v25 = withDefaults(p1, t1)
	local v26 = useTokens()
	local v27 = v25.icon and v25.icon ~= ""
	local v28 = v25.action ~= nil and v25.action.text ~= ""
	local v29 = v28 or v25.onClose ~= nil
	local v30 = v27 or v29
	local v31 = useScaledValue(371)
	local v32 = useScaledValue(not v27 and 272 or 304)
	local v33 = if typeof(v25.icon) ~= "string" then v25.icon else {
		name = v25.icon,
		variant = IconVariant.Regular
	}
	local v34 = v26.Typography.CaptionLarge.FontSize * v26.Typography.CaptionLarge.LineHeight * 2
	local action = v25.action

	return React.createElement(View, withCommonProps(v25, {
		Size = if not v29 then UDim2.fromOffset(0, 0) else UDim2.fromOffset(v31, 0),
		sizeConstraint = if not v29 then {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(v32, 1e999)
		} else nil,
		tag = {
			["row align-y-center gap-large padding-y-xsmall radius-medium bg-system-contrast"] = true,
			["padding-left-large"] = not v30,
			["padding-left-medium"] = v30,
			["auto-xy padding-right-large"] = not v29,
			["auto-y padding-right-small"] = v29
		},
		ref = p2
	}), React.createElement(PresentationContext.Provider, {
		value = t2
	}, {
		Content = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center fill gap-small auto-xy padding-y-small",
			testId = `{ v25.testId }--content`
		}, {
			Icon = if not v27 then nil else React.createElement(Icon, Dash.join(v33, {
				LayoutOrder = 1,
				style = v26.Inverse.Content.Emphasis,
				testId = `{ v25.testId }--icon`
			})),
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "fill auto-xy text-caption-large text-wrap text-align-x-left text-truncate-split content-inverse-emphasis",
				Text = v25.title,
				sizeConstraint = {
					MinSize = Vector2.new(0, 0),
					MaxSize = Vector2.new(1e999, v34)
				},
				testId = `{ v25.testId }--title`
			})
		}),
		Buttons = if not v29 then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-y-center gap-xsmall auto-xy",
			testId = `{ v25.testId }--buttons`
		}, {
			Action = if not v28 then nil else React.createElement(Text, {
				LayoutOrder = 1,
				tag = "auto-xy padding-small text-label-medium radius-medium content-inverse-link",
				onActivated = action.onActivated,
				stateLayer = {
					mode = StateLayerMode.Inverse
				},
				Text = action.text,
				testId = `{ v25.testId }--action`
			}),
			CloseAffordance = if v25.onClose == nil then nil else React.createElement(CloseAffordance, {
				LayoutOrder = 2,
				onActivated = v25.onClose,
				size = InputSize.Small,
				variant = CloseAffordanceVariant.Utility,
				testId = `{ v25.testId }--close-affordance`
			})
		})
	}))
end

return React.memo(React.forwardRef(Snackbar))
