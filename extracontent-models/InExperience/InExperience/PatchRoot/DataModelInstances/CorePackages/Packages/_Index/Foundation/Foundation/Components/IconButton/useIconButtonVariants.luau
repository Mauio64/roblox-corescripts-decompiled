local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ButtonVariant)

local ColorMode = require(Foundation.Enums.ColorMode)

require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local getSharedVariants = require(Foundation.Components.Button.getSharedVariants)

local function v7(p1) -- line: 41
	-- upvalues: getSharedVariants (copy), InputSize (copy)
	local v9 = getSharedVariants(p1)
	local t1 = {
		[InputSize.XSmall] = {
			container = {
				radius = v9.sizes[InputSize.XSmall].container.radius,
				size = UDim2.fromOffset(v9.sizes[InputSize.XSmall].container.height, v9.sizes[InputSize.XSmall].container.height),
				padding = UDim.new(0, p1.Size.Size_150)
			}
		},
		[InputSize.Small] = {
			container = {
				radius = v9.sizes[InputSize.Small].container.radius,
				size = UDim2.fromOffset(v9.sizes[InputSize.Small].container.height, v9.sizes[InputSize.Small].container.height),
				padding = UDim.new(0, p1.Size.Size_200)
			}
		},
		[InputSize.Medium] = {
			container = {
				radius = v9.sizes[InputSize.Medium].container.radius,
				size = UDim2.fromOffset(v9.sizes[InputSize.Medium].container.height, v9.sizes[InputSize.Medium].container.height),
				padding = UDim.new(0, p1.Size.Size_250)
			}
		},
		[InputSize.Large] = {
			container = {
				radius = v9.sizes[InputSize.Large].container.radius,
				size = UDim2.fromOffset(v9.sizes[InputSize.Large].container.height, v9.sizes[InputSize.Large].container.height),
				padding = UDim.new(0, p1.Size.Size_300)
			}
		}
	}

	return {
		common = {},
		sizes = t1,
		types = v9.types
	}
end

return function(p2, p3, p4, p5) -- line: 92
	-- upvalues: VariantsContext (copy), v7 (copy), composeStyleVariant (copy), ColorMode (copy)
	local v15 = VariantsContext.useVariants("IconButton", v7, p2)

	return composeStyleVariant(v15.common, v15.sizes[p3], v15.types[p4][p5 or ColorMode.Color])
end
