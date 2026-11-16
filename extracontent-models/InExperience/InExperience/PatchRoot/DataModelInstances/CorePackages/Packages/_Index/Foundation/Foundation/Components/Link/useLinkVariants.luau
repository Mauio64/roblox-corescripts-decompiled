local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

local LinkVariant = require(Foundation.Enums.LinkVariant)

local TextOverflow = require(Foundation.Enums.TextOverflow)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

require(Foundation.Providers.Style.Tokens)

local function variantsFactory(p)
	return {
		common = {
			container = { tag = "row align-y-center" }
		},
		variants = {
			[LinkVariant.Standard] = {
				content = { style = p.Color.Content.Emphasis }
			},
			[LinkVariant.Inverse] = {
				content = { style = p.Inverse.Content.Default }
			}
		},
		sizes = {
			[InputSize.XSmall] = {
				text = { tag = "text-body-small" }
			},
			[InputSize.Small] = {
				text = { tag = "text-body-small" }
			},
			[InputSize.Medium] = {
				text = { tag = "text-body-medium" }
			},
			[InputSize.Large] = {
				text = { tag = "text-body-large" }
			}
		},
		textOverflows = {
			[TextOverflow.None] = {
				container = { tag = "auto-xy" },
				text = { tag = "auto-xy" }
			},
			[TextOverflow.Wrap] = {
				container = { tag = "size-full-0 auto-y" },
				text = { tag = "size-full-0 auto-y text-wrap text-align-x-left" }
			},
			[TextOverflow.Truncate] = {
				container = { tag = "size-full-0 auto-y" },
				text = { tag = "size-full-0 auto-y text-align-x-left text-truncate-end" }
			},
			[TextOverflow.TruncateSplit] = {
				container = { tag = "size-full-0 auto-y" },
				text = { tag = "size-full-0 auto-y text-align-x-left text-truncate-split" }
			}
		}
	}
end

return function(p, p2, p3, p4)
	local v = VariantsContext.useVariants("Link", variantsFactory, p)
	return composeStyleVariant(v.common, v.variants[p3], v.sizes[p2], v.textOverflows[p4])
end
