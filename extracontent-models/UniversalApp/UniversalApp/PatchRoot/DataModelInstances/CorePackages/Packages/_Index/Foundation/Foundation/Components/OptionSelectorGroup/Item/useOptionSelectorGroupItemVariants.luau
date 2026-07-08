local Foundation = script:FindFirstAncestor("Foundation")
local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Components.InternalInput)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.ControlState)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 39
	-- upvalues: InputSize (copy), IconSize (copy)
	local t1 = {
		container = {
			tag = "col wrap align-x-left align-y-center gap-xsmall radius-medium",
			radius = p1.Radius.Medium
		},
		content = p1.Color.Content.Default,
		itemInner = {
			tag = "col gap-xsmall size-full-0 auto-y"
		},
		label = {
			tag = "fill auto-xy"
		},
		metadata = {
			tag = "shrink auto-xy"
		},
		description = {
			tag = "grow auto-xy"
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "padding-medium"
			},
			icon = {
				size = IconSize.XSmall
			},
			label = {
				tag = "text-title-small"
			},
			metadata = {
				tag = "text-caption-small"
			},
			description = {
				tag = "text-body-small"
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "padding-large"
			},
			icon = {
				size = IconSize.Small
			},
			label = {
				tag = "text-title-small"
			},
			metadata = {
				tag = "text-caption-small"
			},
			description = {
				tag = "text-body-small"
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "padding-xlarge"
			},
			icon = {
				size = IconSize.Medium
			},
			label = {
				tag = "text-title-medium"
			},
			metadata = {
				tag = "text-caption-medium"
			},
			description = {
				tag = "text-body-medium"
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "padding-xxlarge"
			},
			icon = {
				size = IconSize.Large
			},
			label = {
				tag = "text-title-large"
			},
			metadata = {
				tag = "text-caption-large"
			},
			description = {
				tag = "text-body-large"
			}
		}
	}

	return {
		common = t1,
		sizes = t2
	}
end

return function(p2, p3) -- line: 88
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v12 = VariantsContext.useVariants("OptionSelectorGroupItem", variantsFactory, p2)

	return composeStyleVariant(v12.common, v12.sizes[p3])
end
