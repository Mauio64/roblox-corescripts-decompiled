local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local Icon = require(Foundation.Components.Icon)
local React = require(FoundationParent.React)
local InputSize = require(Foundation.Enums.InputSize)
local IconVariant = BuilderIcons.IconVariant

require(Foundation.Enums.IconSize)

local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)

require(Foundation.Enums.Radius)

local useTokens = require(Foundation.Providers.Style.useTokens)
local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local Constants = require(Foundation.Constants)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useCloseAffordanceVariants = require(script.Parent.useCloseAffordanceVariants)
local t1 = {
	isDisabled = false,
	isCircular = false,
	hasPadding = true,
	testId = "--foundation-close-affordance",
	size = InputSize.Medium,
	variant = CloseAffordanceVariant.OverMedia
}

local function CloseAffordance(p1, p2) -- line: 53
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePresentationContext (copy), useCloseAffordanceVariants (copy), React (copy), View (copy), withCommonProps (copy), Constants (copy), Icon (copy), BuilderIcons (copy), IconVariant (copy)
	local v20 = withDefaults(p1, t1)
	local v21 = useTokens()
	local v22 = usePresentationContext()
	local v23 = useCloseAffordanceVariants(v21, v20.size, v20.variant, v22.colorMode, v20.hasPadding, v20.isCircular)
	local uDim = UDim.new(0, v23.container.radius)
	local v25 = React.useMemo(function() -- line: 68
		-- upvalues: uDim (copy), v21 (copy)
		return {
			radius = uDim,
			offset = v21.Size.Size_150,
			borderWidth = v21.Stroke.Thicker
		}
	end, {
		v21,
		uDim
	})

	return React.createElement(View, withCommonProps(v20, {
		Size = v23.container.size,
		onActivated = v20.onActivated,
		selection = {
			Selectable = not v20.isDisabled and v20.Selectable,
			NextSelectionUp = v20.NextSelectionUp,
			NextSelectionDown = v20.NextSelectionDown,
			NextSelectionLeft = v20.NextSelectionLeft,
			NextSelectionRight = v20.NextSelectionRight
		},
		isDisabled = v20.isDisabled,
		padding = v23.container.padding,
		cornerRadius = uDim,
		stateLayer = v23.container.stateLayer,
		cursor = v25,
		tag = v23.container.tag,
		GroupTransparency = if not v20.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
		ref = p2
	}), {
		Icon = React.createElement(Icon, {
			name = BuilderIcons.Icon.X,
			variant = IconVariant.Regular,
			size = v23.content.iconSize,
			style = v23.content.style
		})
	})
end

return React.memo(React.forwardRef(CloseAffordance))
