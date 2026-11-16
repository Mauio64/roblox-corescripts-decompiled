local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local IconSize = require(Foundation.Enums.IconSize)

local function fn(p)
	return {
		common = {
			container = {
				tag = "col flex-y-between align-x-center size-full-0 auto-y",
				stateLayer = { affordance = StateLayerAffordance.None }
			},
			header = { tag = "row flex-x-between align-y-center" },
			content = { tag = "size-full-0 auto-y padding-top-xsmall" },
			icon = { style = p.Color.Content.Emphasis },
			text = { tag = "auto-y text-align-x-left text-truncate-end content-emphasis" },
			textContainer = { tag = "col grow auto-y" },
			description = { tag = "size-full-0 auto-y text-align-x-left text-truncate-end" }
		},
		sizes = {
			[InputSize.XSmall] = {
				container = { tag = "radius-small" },
				header = { tag = "gap-small size-full-600" },
				content = { tag = "padding-bottom-small" },
				icon = { size = IconSize.XSmall },
				text = { tag = "text-title-small" },
				description = { tag = "text-body-small" }
			},
			[InputSize.Small] = {
				container = { tag = "radius-medium" },
				header = { tag = "gap-small size-full-800" },
				content = { tag = "padding-bottom-large" },
				icon = { size = IconSize.Small },
				text = { tag = "text-title-small" },
				description = { tag = "text-body-small" }
			},
			[InputSize.Medium] = {
				container = { tag = "radius-medium" },
				header = { tag = "gap-small size-full-1000" },
				content = { tag = "padding-bottom-xlarge" },
				icon = { size = IconSize.Medium },
				text = { tag = "text-title-medium" },
				description = { tag = "text-body-medium" }
			},
			[InputSize.Large] = {
				container = { tag = "radius-medium" },
				header = { tag = "gap-small size-full-1200" },
				content = { tag = "padding-bottom-xlarge" },
				icon = { size = IconSize.Large },
				text = { tag = "text-title-large" },
				description = { tag = "text-body-medium" }
			}
		},
		isContained = {
			[true] = {
				header = { tag = "padding-x-medium" },
				content = { tag = "padding-x-medium" }
			}
		}
	}
end

return function(p, p2, flag: boolean)
	local v = VariantsContext.useVariants("AccordionItem", fn, p)
	return composeStyleVariant(v.common, v.sizes[p2], v.isContained[flag])
end
