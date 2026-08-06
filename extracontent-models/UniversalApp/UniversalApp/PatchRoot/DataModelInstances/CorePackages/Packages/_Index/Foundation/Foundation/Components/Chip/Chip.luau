local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local IconVariant = require(FoundationParent.BuilderIcons).IconVariant
local Constants = require(Foundation.Constants)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local Accessory = require(script.Parent.Accessory)
local IconPosition = require(Foundation.Enums.IconPosition)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local StateLayerMode = require(Foundation.Enums.StateLayerMode)

require(Foundation.Enums.CursorType)

local ChipSize = require(Foundation.Enums.ChipSize)
local ChipVariant = require(Foundation.Enums.ChipVariant)
local useChipVariants = require(script.Parent.useChipVariants)
local t1 = {
	isChecked = false,
	Selectable = true,
	isDisabled = false,
	testId = "--foundation-chip",
	size = ChipSize.Medium,
	variant = ChipVariant.Standard
}

local function Chip(p1, p2) -- line: 71
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), IconPosition (copy), IconVariant (copy), useChipVariants (copy), View (copy), withCommonProps (copy), StateLayerMode (copy), Constants (copy), PresentationContext (copy), ColorNamespace (copy), Accessory (copy), Text (copy)
	local v23 = withDefaults(p1, t1)
	local v24 = useTokens()
	local v25, v26 = React.useMemo(function() -- line: 75
		-- upvalues: v23 (copy), IconPosition (copy), IconVariant (copy)
		local leading = v23.leading
		local trailing = v23.trailing

		if v23.icon ~= nil then
			if typeof(v23.icon) == "string" then
				leading = {
					iconName = v23.icon
				}
			else
				local t2 = {
					iconName = v23.icon.name
				}

				if v23.icon.position == IconPosition.Left then
					leading = t2
				else
					trailing = t2
				end
			end
		end

		if typeof(leading) == "table" and leading.isCircular then
			leading.iconVariant = IconVariant.Filled
		end

		if typeof(trailing) == "table" and trailing.isCircular then
			trailing.iconVariant = IconVariant.Filled
		end

		return leading, trailing
	end, {
		v23.leading,
		v23.icon,
		v23.trailing
	})
	local v27 = useChipVariants(v24, v23.size, v23.variant, v23.isChecked, v25 ~= nil, v26 ~= nil)
	local v28 = math.floor(v24.Stroke.Thicker)

	return React.createElement(View, withCommonProps(v23, {
		isDisabled = v23.isDisabled,
		selection = {
			Selectable = not v23.isDisabled and v23.Selectable,
			NextSelectionUp = v23.NextSelectionUp,
			NextSelectionDown = v23.NextSelectionDown,
			NextSelectionLeft = v23.NextSelectionLeft,
			NextSelectionRight = v23.NextSelectionRight
		},
		onActivated = v23.onActivated,
		stateLayer = if not v23.isChecked then nil else {
			mode = StateLayerMode.Inverse
		},
		backgroundStyle = v27.chip.backgroundStyle,
		padding = v27.chip.padding,
		cursor = {
			radius = UDim.new(0, v24.Radius.Circle),
			offset = v28 * 2,
			borderWidth = v28
		},
		tag = v27.chip.tag,
		ref = p2,
		GroupTransparency = not v23.isDisabled and 0 or Constants.DISABLED_TRANSPARENCY
	}), React.createElement(PresentationContext.Provider, {
		value = {
			isIconSize = true,
			colorNamespace = if not v23.isChecked then ColorNamespace.Color else ColorNamespace.Inverse
		}
	}, {
		Leading = if not v25 then nil else React.createElement(Accessory, {
			isLeading = true,
			config = v25,
			size = v23.size,
			chipBackgroundStyle = v27.chip.backgroundStyle,
			contentStyle = v27.text.contentStyle,
			isDisabled = v23.isDisabled,
			testId = `{ v23.testId }--leading-accessory`
		}),
		Text = if not v23.text or v23.text == "" then nil else React.createElement(Text, {
			LayoutOrder = 2,
			Text = v23.text,
			textStyle = v27.text.contentStyle,
			tag = v27.text.tag,
			padding = v27.text.padding,
			testId = `{ v23.testId }--text`
		}),
		Trailing = if not v26 then nil else React.createElement(Accessory, {
			isLeading = false,
			config = v26,
			size = v23.size,
			chipBackgroundStyle = v27.chip.backgroundStyle,
			contentStyle = v27.text.contentStyle,
			isDisabled = v23.isDisabled,
			testId = `{ v23.testId }--trailing-accessory`
		})
	}))
end

return React.memo(React.forwardRef(Chip))
