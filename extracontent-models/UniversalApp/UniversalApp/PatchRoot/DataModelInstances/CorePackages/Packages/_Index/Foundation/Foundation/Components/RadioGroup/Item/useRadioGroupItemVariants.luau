local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.InternalInput)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ControlState)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 28
	-- upvalues: InputSize (copy)
	local t1 = {
		input = {
			tag = "radius-circle",
			cursorRadius = UDim.new(0, p1.Radius.Circle)
		},
		checkmark = {
			tag = "position-center-center anchor-center-center radius-circle",
			style = p1.Inverse.Content.Emphasis
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_400, p1.Size.Size_400)
			},
			checkmark = {
				tag = "size-150"
			}
		},
		[InputSize.Small] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_500, p1.Size.Size_500)
			},
			checkmark = {
				tag = "size-200"
			}
		},
		[InputSize.Medium] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_600, p1.Size.Size_600)
			},
			checkmark = {
				tag = "size-250"
			}
		},
		[InputSize.Large] = {
			input = {
				size = UDim2.fromOffset(p1.Size.Size_700, p1.Size.Size_700)
			},
			checkmark = {
				tag = "size-300"
			}
		}
	}

	return {
		common = t1,
		sizes = t2
	}
end

return function(p2, p3) -- line: 59
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v11 = VariantsContext.useVariants("RadioItem", variantsFactory, p2)

	return composeStyleVariant(v11.common, v11.sizes[p3])
end
