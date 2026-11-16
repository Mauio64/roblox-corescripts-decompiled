local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ButtonVariant)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)

require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local getSharedVariants = require(script.Parent.getSharedVariants)

require(Foundation.Providers.Style.Tokens)

local function fn(p)
	local sharedVariants = getSharedVariants(p)

	return {
		common = {
			container = { tag = "row align-x-center align-y-center clip" },
			text = { tag = "shrink size-0-full auto-x text-truncate-end" }
		},
		sizes = {
			[InputSize.XSmall] = {
				container = {
					tag = "gap-xsmall padding-small",
					radius = sharedVariants.sizes[InputSize.XSmall].container.radius,
					height = sharedVariants.sizes[InputSize.XSmall].container.height
				},
				icon = {
					size = UDim2.fromOffset(p.Size.Size_300, p.Size.Size_300)
				},
				text = { tag = "text-label-small" }
			},
			[InputSize.Small] = {
				container = {
					tag = "gap-xsmall padding-small",
					radius = sharedVariants.sizes[InputSize.Small].container.radius,
					height = sharedVariants.sizes[InputSize.Small].container.height
				},
				icon = {
					size = UDim2.fromOffset(p.Size.Size_400, p.Size.Size_400)
				},
				text = { tag = "text-label-small" }
			},
			[InputSize.Medium] = {
				container = {
					tag = "gap-small padding-medium",
					radius = sharedVariants.sizes[InputSize.Medium].container.radius,
					height = sharedVariants.sizes[InputSize.Medium].container.height
				},
				icon = {
					size = UDim2.fromOffset(p.Size.Size_500, p.Size.Size_500)
				},
				text = { tag = "text-label-medium" }
			},
			[InputSize.Large] = {
				container = {
					tag = "gap-small padding-medium",
					radius = sharedVariants.sizes[InputSize.Large].container.radius,
					height = sharedVariants.sizes[InputSize.Large].container.height
				},
				icon = {
					size = UDim2.fromOffset(p.Size.Size_600, p.Size.Size_600)
				},
				text = { tag = "text-label-large" }
			}
		},
		types = sharedVariants.types
	}
end

return function(p, p2, p3, p4)
	local v = VariantsContext.useVariants("Button", fn, p)
	return composeStyleVariant(v.common, v.sizes[p2], v.types[p3][p4 or ColorNamespace.Color])
end
