local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Icon = require(Foundation.Components.Icon)
local React = require(parent.React)

local InputSize = require(Foundation.Enums.InputSize)

local IconVariant = BuilderIcons.IconVariant

require(Foundation.Enums.IconSize)

local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)

require(Foundation.Enums.Radius)

local useTokens = require(Foundation.Providers.Style.useTokens)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local Constants = require(Foundation.Constants)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local useCloseAffordanceVariants = require(script.Parent.useCloseAffordanceVariants)

local v = {
	isDisabled = false,
	size = InputSize.Medium,
	variant = CloseAffordanceVariant.OverMedia,
	isCircular = false,
	hasPadding = true,
	testId = "--foundation-close-affordance"
}

local function CloseAffordance(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = usePresentationContext()

	local v5 = useCloseAffordanceVariants(v3, v2.size, v2.variant, v4.colorNamespace, v2.hasPadding, v2.isCircular)

	local udim = UDim.new(0, v5.container.radius)

	local cursor = React.useMemo(function()
		return { radius = udim, offset = v3.Size.Size_150, borderWidth = v3.Stroke.Thicker }
	end, { v3, udim })

	local createElement = React.createElement

	local v6 = {
		Size = v5.container.size,
		onActivated = v2.onActivated,
		selection = {
			Selectable = not v2.isDisabled and v2.Selectable,
			NextSelectionUp = v2.NextSelectionUp,
			NextSelectionDown = v2.NextSelectionDown,
			NextSelectionLeft = v2.NextSelectionLeft,
			NextSelectionRight = v2.NextSelectionRight
		},
		isDisabled = v2.isDisabled,
		padding = v5.container.padding,
		cornerRadius = udim,
		stateLayer = v5.container.stateLayer,
		cursor = cursor,
		tag = v5.container.tag,
		GroupTransparency = 0,
		ref = 0
	}
	local groupTransparency

	if v2.isDisabled then
		groupTransparency = Constants.DISABLED_TRANSPARENCY
	end

	v6.GroupTransparency = groupTransparency
	v6.ref = ref
	return createElement(View, withCommonProps(v2, v6), {
		Icon = React.createElement(Icon, {
			name = BuilderIcons.Icon.X,
			variant = IconVariant.Regular,
			size = v5.content.iconSize,
			style = v5.content.style
		})
	})
end

return React.memo(React.forwardRef(CloseAffordance))
