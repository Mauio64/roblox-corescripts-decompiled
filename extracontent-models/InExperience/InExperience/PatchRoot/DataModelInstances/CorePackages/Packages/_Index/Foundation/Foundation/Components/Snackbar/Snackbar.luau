local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local React = require(parent.React)

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

local v = { testId = "--foundation-snackbar" }

local v2 = { colorNamespace = ColorNamespace.Inverse }

local function Snackbar(p, ref)
	local v3 = withDefaults(p, v)
	local v4 = useTokens()

	local v5 = v3.icon and v3.icon ~= ""
	local v6

	if v3.action == nil then
		v6 = false
	else
		v6 = v3.action.text ~= ""
	end

	local autoypaddingrightsmall = v6 or v3.onClose ~= nil
	local paddingleftmedium = v5 or autoypaddingrightsmall

	local v7 = useScaledValue(371)
	local v8 = useScaledValue(v5 and 304 or 272)
	local v9

	if typeof(v3.icon) == "string" then
		v9 = { name = v3.icon, variant = IconVariant.Regular }
	else
		v9 = v3.icon
	end

	local v10 = v4.Typography.CaptionLarge.FontSize * v4.Typography.CaptionLarge.LineHeight * 2
	local action = v3.action

	local createElement = React.createElement
	local size

	if autoypaddingrightsmall then
		size = UDim2.fromOffset(v7, 0)
	else
		size = UDim2.fromOffset(0, 0)
	end

	local v11 = withCommonProps(v3, {
		Size = size,
		sizeConstraint = not autoypaddingrightsmall and {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(v8, 1e999)
		} or nil,
		tag = {
			["row align-y-center gap-large padding-y-xsmall radius-medium bg-system-contrast"] = true,
			["padding-left-large"] = not paddingleftmedium,
			["padding-left-medium"] = paddingleftmedium,
			["auto-xy padding-right-large"] = not autoypaddingrightsmall,
			["auto-y padding-right-small"] = autoypaddingrightsmall
		},
		ref = ref
	})

	local createElement2 = React.createElement
	local provider = PresentationContext.Provider
	local createElement3 = React.createElement
	local v12 = {
		LayoutOrder = 1,
		tag = "row align-y-center fill gap-small auto-xy padding-y-small",
		testId = `{v3.testId}--content`
	}
	local icon

	if v5 then
		icon = React.createElement(
			Icon,
			Dash.join(v9, {
				style = v4.Inverse.Content.Emphasis,
				LayoutOrder = 1,
				testId = `{v3.testId}--icon`
			})
		)
	end

	local v13 = {
		Content = createElement3(View, v12, {
			Icon = icon,
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v3.title,
				sizeConstraint = { MinSize = Vector2.new(0, 0), MaxSize = Vector2.new(1e999, v10) },
				tag = "fill auto-xy text-caption-large text-wrap text-align-x-left text-truncate-split content-inverse-emphasis",
				testId = `{v3.testId}--title`
			})
		}),
		Buttons = 0
	}
	local buttons

	if autoypaddingrightsmall then
		local createElement4 = React.createElement
		local v14 = {
			LayoutOrder = 2,
			tag = "row align-y-center gap-xsmall auto-xy",
			testId = `{v3.testId}--buttons`
		}
		local action2

		if v6 then
			action2 = React.createElement(Text, {
				LayoutOrder = 1,
				onActivated = action.onActivated,
				stateLayer = { mode = StateLayerMode.Inverse },
				Text = action.text,
				tag = "auto-xy padding-small text-label-medium radius-medium content-inverse-link",
				testId = `{v3.testId}--action`
			})
		end

		local closeAffordance

		if v3.onClose ~= nil then
			closeAffordance = React.createElement(CloseAffordance, {
				LayoutOrder = 2,
				onActivated = v3.onClose,
				size = InputSize.Small,
				variant = CloseAffordanceVariant.Utility,
				testId = `{v3.testId}--close-affordance`
			})
		end

		buttons = createElement4(View, v14, { Action = action2, CloseAffordance = closeAffordance })
	end

	v13.Buttons = buttons
	return createElement(View, v11, createElement2(provider, { value = v2 }, v13))
end

return React.memo(React.forwardRef(Snackbar))
