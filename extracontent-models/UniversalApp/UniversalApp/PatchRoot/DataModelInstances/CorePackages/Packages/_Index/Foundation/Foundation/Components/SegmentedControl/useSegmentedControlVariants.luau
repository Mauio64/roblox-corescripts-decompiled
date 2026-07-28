local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local InputSize = require(Foundation.Enums.InputSize)
local IconSize = require(Foundation.Enums.IconSize)
local Flags = require(Foundation.Utility.Flags)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 29
	-- upvalues: Flags (copy), InputSize (copy), IconSize (copy)
	local t1 = {
		container = {
			tag = not Flags.FoundationSegmentedControlAutoXFix and "row align-y-center auto-xy bg-surface-300" or "row align-y-center auto-x bg-surface-300"
		},
		segment = {
			tag = not Flags.FoundationSegmentedControlAutoXFix and "row align-y-center size-0-full auto-xy" or "row align-y-center size-0-full auto-x"
		},
		text = {
			tag = "auto-x text-truncate-end content-emphasis"
		},
		icon = {
			style = p1.Color.Content.Emphasis
		},
		divider = {
			tag = "row"
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "size-600"
			},
			segment = {
				tag = "padding-small"
			},
			text = {
				tag = "text-caption-small"
			},
			icon = {
				size = IconSize.Small
			},
			divider = {
				Size = UDim2.new(0, p1.Stroke.Standard, 1, 0)
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "size-800"
			},
			segment = {
				tag = "padding-small"
			},
			text = {
				tag = "text-caption-small"
			},
			icon = {
				size = IconSize.Medium
			},
			divider = {
				Size = UDim2.new(0, p1.Stroke.Standard, 1, 0)
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "size-1000 padding-xsmall"
			},
			segment = {
				tag = "padding-small"
			},
			text = {
				tag = "text-caption-medium"
			},
			icon = {
				size = IconSize.Medium
			},
			divider = {
				Size = UDim2.new(0, p1.Stroke.Standard, 1, 0)
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "size-1200 padding-xsmall"
			},
			segment = {
				tag = "padding-medium"
			},
			text = {
				tag = "text-caption-medium"
			},
			icon = {
				size = IconSize.Large
			},
			divider = {
				Size = UDim2.new(0, p1.Stroke.Standard, 1, 0)
			}
		}
	}
	local t3 = {
		[InputSize.XSmall] = {
			container = {
				tag = "radius-medium"
			},
			segment = {
				tag = "radius-medium"
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "radius-medium"
			},
			segment = {
				tag = "radius-medium"
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "radius-medium"
			},
			segment = {
				tag = "radius-small"
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "radius-medium"
			},
			segment = {
				tag = "radius-small"
			}
		}
	}
	local t4 = {
		container = {
			tag = "radius-circle"
		},
		segment = {
			tag = "radius-circle"
		}
	}

	return {
		common = t1,
		sizes = t2,
		defaultRadius = t3,
		circularRadius = t4
	}
end

return function(p2, p3, b1: boolean?) -- line: 112
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v16 = VariantsContext.useVariants("SegmentedControl", variantsFactory, p2)

	return composeStyleVariant(v16.common, v16.sizes[p3], if not b1 then v16.defaultRadius[p3] else v16.circularRadius)
end
