local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local IconVariant = require(FoundationParent.BuilderIcons).IconVariant
local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local Accessory = require(script.Parent.Accessory)
local IconPosition = require(Foundation.Enums.IconPosition)
local ColorMode = require(Foundation.Enums.ColorMode)
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

local function Chip(p1, p2) -- line: 72
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), Flags (copy), React (copy), IconPosition (copy), IconVariant (copy), useChipVariants (copy), View (copy), withCommonProps (copy), StateLayerMode (copy), Constants (copy), PresentationContext (copy), ColorMode (copy), Accessory (copy), Text (copy)
	local v24 = withDefaults(p1, t1)
	local v25 = useTokens()
	local v26, v27

	if Flags.FoundationChipBeta then
		v26, v27 = React.useMemo(function() -- line: 78
			-- upvalues: v24 (copy), IconPosition (copy), IconVariant (copy)
			local leading = v24.leading
			local trailing = v24.trailing

			if v24.icon ~= nil then
				if typeof(v24.icon) == "string" then
					leading = {
						iconName = v24.icon
					}
				else
					local t2 = {
						iconName = v24.icon.name
					}

					if v24.icon.position == IconPosition.Left then
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
			v24.leading,
			v24.icon,
			v24.trailing
		})
	else
		v26, v27 = React.useMemo(function() -- line: 110
			-- upvalues: v24 (copy), IconPosition (copy)
			local t3 = nil
			local v34 = nil

			if v24.icon == nil then
				return v24.leading, v24.trailing
			end

			if typeof(v24.icon) == "string" then
				t3 = {
					iconName = v24.icon
				}
			else
				local t4 = {
					iconName = v24.icon.name
				}

				if v24.icon.position == IconPosition.Left then
					t3 = t4
				else
					v34 = t4
				end
			end

			return v24.leading or t3, v24.trailing or v34
		end, {
			v24.leading,
			v24.icon,
			v24.trailing
		})
	end

	local v28 = useChipVariants(v25, v24.size, v24.variant, v24.isChecked, v26 ~= nil, v27 ~= nil)
	local v29 = math.floor(v25.Stroke.Thicker)

	return React.createElement(View, withCommonProps(v24, {
		isDisabled = v24.isDisabled,
		selection = {
			Selectable = not v24.isDisabled and v24.Selectable,
			NextSelectionUp = v24.NextSelectionUp,
			NextSelectionDown = v24.NextSelectionDown,
			NextSelectionLeft = v24.NextSelectionLeft,
			NextSelectionRight = v24.NextSelectionRight
		},
		onActivated = v24.onActivated,
		stateLayer = if not v24.isChecked then nil else {
			mode = StateLayerMode.Inverse
		},
		backgroundStyle = v28.chip.backgroundStyle,
		padding = v28.chip.padding,
		cursor = {
			radius = UDim.new(0, v25.Radius.Circle),
			offset = v29 * 2,
			borderWidth = v29
		},
		tag = v28.chip.tag,
		ref = p2,
		GroupTransparency = not v24.isDisabled and 0 or Constants.DISABLED_TRANSPARENCY
	}), React.createElement(PresentationContext.Provider, {
		value = {
			isIconSize = true,
			colorMode = if not v24.isChecked then ColorMode.Color else ColorMode.Inverse
		}
	}, {
		Leading = if not v26 then nil else React.createElement(Accessory, {
			isLeading = true,
			config = v26,
			size = v24.size,
			chipBackgroundStyle = v28.chip.backgroundStyle,
			contentStyle = v28.text.contentStyle,
			isDisabled = v24.isDisabled,
			testId = `{ v24.testId }--leading-accessory`
		}),
		Text = if not v24.text or v24.text == "" then nil else React.createElement(Text, {
			LayoutOrder = 2,
			Text = v24.text,
			textStyle = v28.text.contentStyle,
			tag = v28.text.tag,
			padding = v28.text.padding,
			testId = `{ v24.testId }--text`
		}),
		Trailing = if not v27 then nil else React.createElement(Accessory, {
			isLeading = false,
			config = v27,
			size = v24.size,
			chipBackgroundStyle = v28.chip.backgroundStyle,
			contentStyle = v28.text.contentStyle,
			isDisabled = v24.isDisabled,
			testId = `{ v24.testId }--trailing-accessory`
		})
	}))
end

return React.memo(React.forwardRef(Chip))
