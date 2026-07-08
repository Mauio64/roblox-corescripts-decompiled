local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Components.Types)
require(Foundation.Providers.Style.Tokens)

local Flags = require(Foundation.Utility.Flags)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local getKnobSize = require(script.Parent.getKnobSize)
local IconSize = require(Foundation.Enums.IconSize)

local function computeProps(t1: {[any]: any}) -- line: 39
	local v11 = t1.size.X.Offset + t1.shadowPadding * 2

	return {
		knob = {
			size = t1.size,
			iconSize = t1.iconSize
		},
		knobShadow = {
			size = UDim2.fromOffset(v11, v11),
			padding = t1.shadowPadding
		}
	}
end
local function variantsFactory(p1) -- line: 58
	-- upvalues: Flags (copy), InputSize (copy), computeProps (copy), IconSize (copy), getKnobSize (copy)
	local t2 = {
		knob = {
			tag = not Flags.FoundationToggleVisualUpdate and "position-center-center anchor-center-center radius-circle" or "position-center-center anchor-center-center auto-xy radius-circle"
		},
		knobShadow = {
			tag = "position-center-center anchor-center-center"
		}
	}
	local t3 = {
		[InputSize.XSmall] = computeProps({
			iconSize = IconSize.XSmall,
			size = getKnobSize(p1, InputSize.XSmall),
			shadowPadding = p1.Padding.XXSmall
		}),
		[InputSize.Small] = computeProps({
			iconSize = IconSize.Small,
			size = getKnobSize(p1, InputSize.Small),
			shadowPadding = p1.Padding.XSmall
		}),
		[InputSize.Medium] = computeProps({
			iconSize = IconSize.Medium,
			size = getKnobSize(p1, InputSize.Medium),
			shadowPadding = p1.Padding.Small
		}),
		[InputSize.Large] = computeProps({
			iconSize = IconSize.Large,
			size = getKnobSize(p1, InputSize.Large),
			shadowPadding = p1.Padding.Small
		})
	}
	local v15 = if not Flags.FoundationToggleVisualUpdate then {
		[false] = {
			knob = {
				style = p1.Color.Extended.White.White_100
			},
			iconContainer = {
				backgroundStyle = p1.Inverse.Content.Emphasis
			}
		},
		[true] = {
			knob = {
				style = p1.Color.Extended.White.White_100
			},
			iconContainer = {
				backgroundStyle = p1.Color.Content.Emphasis
			}
		}
	} else {
		[false] = {
			knob = {
				style = p1.Color.Content.Emphasis
			},
			iconContainer = {
				backgroundStyle = p1.Inverse.Content.Emphasis
			}
		},
		[true] = {
			knob = {
				style = p1.Inverse.Content.Emphasis
			},
			iconContainer = {
				backgroundStyle = p1.Color.Content.Emphasis
			}
		}
	}

	return {
		common = t2,
		sizes = t3,
		isInverse = v15
	}
end

return function(p2, p3, b1: boolean) -- line: 135
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v19 = VariantsContext.useVariants("Knob", variantsFactory, p2)

	return composeStyleVariant(v19.common, v19.sizes[p3], v19.isInverse[b1])
end
