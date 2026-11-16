local Foundation = script:FindFirstAncestor("Foundation")

local IconSize = require(Foundation.Enums.IconSize)

local InputSize = require(Foundation.Enums.InputSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(_)
	return {
		common = {
			title = { tag = "auto-xy text-wrap text-align-x-left content-emphasis" },
			metadata = { tag = "auto-xy text-align-x-left text-truncate-split" },
			description = { tag = "auto-xy text-wrap text-align-x-left" }
		},
		sizes = {
			[InputSize.XSmall] = {
				title = { tag = "text-title-small" },
				metadata = { tag = "text-body-small" },
				description = { tag = "text-body-small" },
				icon = { size = IconSize.XSmall }
			},
			[InputSize.Small] = {
				title = { tag = "text-title-medium" },
				metadata = { tag = "text-body-small" },
				description = { tag = "text-body-small" },
				icon = { size = IconSize.Small }
			},
			[InputSize.Medium] = {
				title = { tag = "text-title-medium" },
				metadata = { tag = "text-body-medium" },
				description = { tag = "text-body-medium" },
				icon = { size = IconSize.Medium }
			},
			[InputSize.Large] = {
				title = { tag = "text-title-large" },
				metadata = { tag = "text-body-medium" },
				description = { tag = "text-body-medium" },
				icon = { size = IconSize.Large }
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("ListItem", variantsFactory, p)

	return composeStyleVariant(v.common, v.sizes[p2])
end
