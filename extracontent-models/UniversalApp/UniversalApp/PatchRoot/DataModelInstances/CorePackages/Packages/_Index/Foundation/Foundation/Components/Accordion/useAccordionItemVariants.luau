local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local IconSize = require(Foundation.Enums.IconSize)

local function v7(p1) -- line: 28
	-- upvalues: StateLayerAffordance (copy), InputSize (copy), IconSize (copy)
	local t1 = {
		container = {
			tag = "col flex-y-between align-x-center size-full-0 auto-y",
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		},
		header = {
			tag = "row flex-x-between align-y-center"
		},
		content = {
			tag = "size-full-0 auto-y padding-top-xsmall"
		},
		icon = {
			style = p1.Color.Content.Emphasis
		},
		text = {
			tag = "grow auto-y text-align-x-left text-truncate-end content-emphasis"
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "radius-small"
			},
			header = {
				tag = "gap-small size-full-600"
			},
			content = {
				tag = "padding-bottom-small"
			},
			icon = {
				size = IconSize.XSmall
			},
			text = {
				tag = "text-title-small"
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "radius-medium"
			},
			header = {
				tag = "gap-small size-full-800"
			},
			content = {
				tag = "padding-bottom-large"
			},
			icon = {
				size = IconSize.Small
			},
			text = {
				tag = "text-title-small"
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "radius-medium"
			},
			header = {
				tag = "gap-small size-full-1000"
			},
			content = {
				tag = "padding-bottom-xlarge"
			},
			icon = {
				size = IconSize.Medium
			},
			text = {
				tag = "text-title-medium"
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "radius-medium"
			},
			header = {
				tag = "gap-small size-full-1200"
			},
			content = {
				tag = "padding-bottom-xlarge"
			},
			icon = {
				size = IconSize.Large
			},
			text = {
				tag = "text-title-large"
			}
		}
	}
	local t3 = {
		[false] = {
			header = {
				tag = "padding-x-xsmall"
			}
		},
		[true] = {
			header = {
				tag = "padding-x-medium"
			}
		}
	}

	return {
		common = t1,
		sizes = t2,
		isContained = t3
	}
end

return function(p2, p3, b1: boolean) -- line: 79
	-- upvalues: VariantsContext (copy), v7 (copy), composeStyleVariant (copy)
	local v15 = VariantsContext.useVariants("AccordionItem", v7, p2)

	return composeStyleVariant(v15.common, v15.sizes[p3], v15.isContained[b1])
end
