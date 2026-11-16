local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

require(Foundation.Components.Types)

local function variantsFactory(_)
	return {
		common = {
			container = { tag = "col auto-xy" },
			children = { tag = "col auto-xy" },
			legend = { tag = "auto-xy text-wrap text-align-x-left content-emphasis" }
		},
		sizes = {
			[InputSize.XSmall] = {
				container = { tag = "gap-medium" },
				children = { tag = "gap-small" },
				legend = { tag = "text-title-small" }
			},
			[InputSize.Small] = {
				container = { tag = "gap-large" },
				children = { tag = "gap-medium" },
				legend = { tag = "text-title-small" }
			},
			[InputSize.Medium] = {
				container = { tag = "gap-large" },
				children = { tag = "gap-medium" },
				legend = { tag = "text-title-medium" }
			}
		}
	}
end

local function useInputGroupVariants(p, p2)
	local v = VariantsContext.useVariants("InputGroup", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2])
end

return useInputGroupVariants
