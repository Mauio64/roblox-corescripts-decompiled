local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ButtonVariant)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)

require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local getSharedVariants = require(Foundation.Components.Button.getSharedVariants)

local function fn(p)
	local sharedVariants = getSharedVariants(p)
	return {
		common = {},
		sizes = {
			[InputSize.XSmall] = {
				container = {
					radius = sharedVariants.sizes[InputSize.XSmall].container.radius,
					size = UDim2.fromOffset(
						sharedVariants.sizes[InputSize.XSmall].container.height,
						sharedVariants.sizes[InputSize.XSmall].container.height
					),
					padding = UDim.new(0, p.Size.Size_150)
				}
			},
			[InputSize.Small] = {
				container = {
					radius = sharedVariants.sizes[InputSize.Small].container.radius,
					size = UDim2.fromOffset(
						sharedVariants.sizes[InputSize.Small].container.height,
						sharedVariants.sizes[InputSize.Small].container.height
					),
					padding = UDim.new(0, p.Size.Size_200)
				}
			},
			[InputSize.Medium] = {
				container = {
					radius = sharedVariants.sizes[InputSize.Medium].container.radius,
					size = UDim2.fromOffset(
						sharedVariants.sizes[InputSize.Medium].container.height,
						sharedVariants.sizes[InputSize.Medium].container.height
					),
					padding = UDim.new(0, p.Size.Size_250)
				}
			},
			[InputSize.Large] = {
				container = {
					radius = sharedVariants.sizes[InputSize.Large].container.radius,
					size = UDim2.fromOffset(
						sharedVariants.sizes[InputSize.Large].container.height,
						sharedVariants.sizes[InputSize.Large].container.height
					),
					padding = UDim.new(0, p.Size.Size_300)
				}
			}
		},
		types = sharedVariants.types
	}
end

return function(p, p2, p3, p4)
	local v = VariantsContext.useVariants("IconButton", fn, p)
	return composeStyleVariant(v.common, v.sizes[p2], v.types[p3][p4 or ColorNamespace.Color])
end
