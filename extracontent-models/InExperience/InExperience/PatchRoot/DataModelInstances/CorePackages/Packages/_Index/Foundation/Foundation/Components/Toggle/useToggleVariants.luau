local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.InternalInput)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ControlState)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local Flags = require(Foundation.Utility.Flags)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local getKnobSize = require(Foundation.Components.Knob.getKnobSize)

local function computeProps(t1: {[any]: any}) -- line: 30
	local XOffset = t1.knobSize.X.Offset
	local v11 = (t1.size.height - XOffset) / 2

	return {
		input = {
			tag = t1.tag,
			size = UDim2.fromOffset(t1.size.width, t1.size.height),
			stroke = {
				thickness = t1.strokeThickness
			}
		},
		knob = {
			offPosition = UDim2.new(0, v11, 0.5, 0),
			onPosition = UDim2.new(0, t1.size.width - XOffset - v11, 0.5, 0)
		}
	}
end
local function variantsFactory(p1) -- line: 54
	-- upvalues: Flags (copy), InputSize (copy), computeProps (copy), getKnobSize (copy)
	local v13 = if not Flags.FoundationToggleVisualUpdate then {
		input = {
			checkedStyle = p1.Color.ActionEmphasis.Background,
			cursorRadius = UDim.new(0, p1.Radius.Circle)
		}
	} else {
		input = {
			colors = {
				backgroundStyle = p1.Color.ActionStandard.Background,
				hoverStyle = p1.Color.State.Hover,
				checkedStyle = p1.Color.System.Contrast,
				labelStyle = p1.Color.Content.Emphasis,
				labelHoverStyle = p1.Color.Content.Emphasis
			},
			cursorRadius = UDim.new(0, p1.Radius.Circle)
		}
	}
	local v14 = if not Flags.FoundationToggleVisualUpdate then {
		[InputSize.XSmall] = computeProps({
			tag = "radius-large",
			size = {
				width = p1.Size.Size_700,
				height = p1.Size.Size_300
			},
			knobSize = getKnobSize(p1, InputSize.XSmall)
		}),
		[InputSize.Small] = computeProps({
			tag = "radius-large",
			size = {
				width = p1.Size.Size_800,
				height = p1.Size.Size_400
			},
			knobSize = getKnobSize(p1, InputSize.Small)
		}),
		[InputSize.Medium] = computeProps({
			tag = "radius-large",
			size = {
				width = p1.Size.Size_1000,
				height = p1.Size.Size_500
			},
			knobSize = getKnobSize(p1, InputSize.Medium)
		}),
		[InputSize.Large] = computeProps({
			tag = "radius-circle",
			size = {
				width = p1.Size.Size_1600,
				height = p1.Size.Size_900
			},
			knobSize = getKnobSize(p1, InputSize.Large)
		})
	} else {
		[InputSize.XSmall] = computeProps({
			tag = "radius-circle",
			size = {
				width = p1.Size.Size_700,
				height = p1.Size.Size_400
			},
			knobSize = getKnobSize(p1, InputSize.XSmall),
			strokeThickness = p1.Stroke.None
		}),
		[InputSize.Small] = computeProps({
			tag = "radius-circle",
			size = {
				width = p1.Size.Size_800,
				height = p1.Size.Size_500
			},
			knobSize = getKnobSize(p1, InputSize.Small),
			strokeThickness = p1.Stroke.None
		}),
		[InputSize.Medium] = computeProps({
			tag = "radius-circle",
			size = {
				width = p1.Size.Size_1000,
				height = p1.Size.Size_600
			},
			knobSize = getKnobSize(p1, InputSize.Medium),
			strokeThickness = p1.Stroke.None
		}),
		[InputSize.Large] = computeProps({
			tag = "radius-circle",
			size = {
				width = p1.Size.Size_1100,
				height = p1.Size.Size_600
			},
			knobSize = getKnobSize(p1, InputSize.Medium),
			strokeThickness = p1.Stroke.None
		})
	}

	return {
		common = v13,
		sizes = v14
	}
end

return function(p2, p3) -- line: 127
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v17 = VariantsContext.useVariants("Toggle", variantsFactory, p2)

	return composeStyleVariant(v17.common, v17.sizes[p3])
end
