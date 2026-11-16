local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.InternalInput)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ControlState)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local getKnobSize = require(Foundation.Components.Knob.getKnobSize)

local function computeProps(data)
	local offset = data.knobSize.X.Offset
	local v = (data.size.height - offset) / 2

	return {
		input = {
			tag = data.tag,
			size = UDim2.fromOffset(data.size.width, data.size.height),
			stroke = { thickness = data.strokeThickness }
		},
		knob = {
			offPosition = UDim2.new(0, v, 0.5, 0),
			onPosition = UDim2.new(0, data.size.width - offset - v, 0.5, 0)
		}
	}
end

local function variantsFactory(data)
	return {
		common = {
			input = {
				colors = {
					backgroundStyle = data.Color.ActionStandard.Background,
					hoverStyle = data.Color.State.Hover,
					checkedStyle = data.Color.System.Contrast,
					labelStyle = data.Color.Content.Emphasis,
					labelHoverStyle = data.Color.Content.Emphasis
				},
				cursorRadius = UDim.new(0, data.Radius.Circle)
			}
		},
		sizes = {
			[InputSize.XSmall] = computeProps({
				tag = "radius-circle",
				size = { width = data.Size.Size_700, height = data.Size.Size_400 },
				knobSize = getKnobSize(data, InputSize.XSmall),
				strokeThickness = data.Stroke.None
			}),
			[InputSize.Small] = computeProps({
				tag = "radius-circle",
				size = { width = data.Size.Size_800, height = data.Size.Size_500 },
				knobSize = getKnobSize(data, InputSize.Small),
				strokeThickness = data.Stroke.None
			}),
			[InputSize.Medium] = computeProps({
				tag = "radius-circle",
				size = { width = data.Size.Size_1000, height = data.Size.Size_600 },
				knobSize = getKnobSize(data, InputSize.Medium),
				strokeThickness = data.Stroke.None
			}),
			[InputSize.Large] = computeProps({
				tag = "radius-circle",
				size = { width = data.Size.Size_1100, height = data.Size.Size_600 },
				knobSize = getKnobSize(data, InputSize.Medium),
				strokeThickness = data.Stroke.None
			})
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("Toggle", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2])
end
