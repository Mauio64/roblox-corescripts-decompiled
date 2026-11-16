local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local ControlState = require(Foundation.Enums.ControlState)

local InputSize = require(Foundation.Enums.InputSize)

local LinkVariant = require(Foundation.Enums.LinkVariant)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local TextOverflow = require(Foundation.Enums.TextOverflow)

local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local escapeRichText = require(Foundation.Utility.escapeRichText)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useLinkVariants = require(script.Parent.useLinkVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)

local set = {
	[ControlState.Hover] = true,
	[ControlState.Pressed] = true,
	[ControlState.Selected] = true,
	[ControlState.SelectedPressed] = true
}

local v = {
	variant = LinkVariant.Standard,
	size = InputSize.Medium,
	hasUnderline = false,
	textOverflow = TextOverflow.None,
	testId = "--foundation-link"
}

local function Link(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = useLinkVariants(v3, v2.size, v2.variant, v2.textOverflow)

	local style = v4.content.style

	local state, setState = React.useState(false)
	local onStateChanged = React.useCallback(function(p2)
		setState(set[p2] == true)
	end, {})

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, v3.Radius.XSmall),
			offset = v3.Size.Size_50,
			borderWidth = v3.Stroke.Standard
		}
	end, { v3 })

	local hasUnderline = v2.hasUnderline or state

	local createElement = React.createElement

	local v5 = withCommonProps(v2, {
		tag = v4.container.tag,
		cursor = cursor,
		stateLayer = { affordance = StateLayerAffordance.None },
		onActivated = v2.onActivated,
		onStateChanged = onStateChanged,
		selection = {
			Selectable = v2.Selectable,
			NextSelectionUp = v2.NextSelectionUp,
			NextSelectionDown = v2.NextSelectionDown,
			NextSelectionLeft = v2.NextSelectionLeft,
			NextSelectionRight = v2.NextSelectionRight
		},
		ref = ref
	})

	local createElement2 = React.createElement
	local text

	if hasUnderline then
		text = `<u>{escapeRichText(v2.text)}</u>`
	else
		text = v2.text
	end

	return createElement(View, v5, {
		Text = createElement2(Text, {
			Text = text,
			RichText = hasUnderline,
			tag = v4.text.tag,
			textStyle = { Color3 = style.Color3, Transparency = style.Transparency },
			LayoutOrder = 1,
			testId = `{v2.testId}--text`
		})
	})
end

return React.memo(React.forwardRef(Link))
