local Foundation = script:FindFirstAncestor("Foundation")
local StatusBadgeShape = require(Foundation.Enums.StatusBadgeShape)
local StatusBadgeSize = require(Foundation.Enums.StatusBadgeSize)
local StatusBadgeVariant = require(Foundation.Enums.StatusBadgeVariant)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

function variantsFactory(p1) -- line: 41
	-- upvalues: StatusBadgeVariant (copy), StatusBadgeShape (copy), StatusBadgeSize (copy)
	local t1 = {
		container = {
			tag = "row align-x-center align-y-center auto-xy"
		},
		statusLight = {
			tag = "row align-x-center align-y-center auto-x size-0-300 padding-x-xxsmall"
		},
		content = {
			tag = "row align-y-center auto-x size-0-full"
		},
		dot = {
			tag = "radius-circle"
		},
		text = {
			tag = "auto-xy text-align-x-left text-truncate-split padding-right-xxsmall",
			style = p1.Color.Content.Emphasis
		}
	}
	local t2 = {
		[StatusBadgeVariant.Standard] = {
			dot = {
				tag = "bg-system-neutral"
			}
		},
		[StatusBadgeVariant.Emphasis] = {
			dot = {
				tag = "bg-system-emphasis"
			}
		},
		[StatusBadgeVariant.Success] = {
			dot = {
				tag = "bg-system-success"
			}
		},
		[StatusBadgeVariant.Warning] = {
			dot = {
				tag = "bg-system-warning"
			}
		},
		[StatusBadgeVariant.Alert] = {
			dot = {
				tag = "bg-system-alert"
			}
		}
	}
	local t3 = {
		[StatusBadgeShape.Utility] = {},
		[StatusBadgeShape.Box] = {
			container = {
				tag = "radius-small bg-shift-200"
			}
		}
	}
	local t4 = {
		[StatusBadgeSize.XSmall] = {
			container = {
				tag = "size-0-400"
			},
			content = {
				tag = "gap-xxsmall"
			},
			dot = {
				tag = "size-150"
			},
			text = {
				tag = "text-caption-small"
			}
		},
		[StatusBadgeSize.Small] = {
			container = {
				tag = "size-0-600"
			},
			content = {
				gap = p1.Size.Size_150
			},
			dot = {
				tag = "size-200"
			},
			text = {
				tag = "text-caption-medium"
			}
		}
	}
	local t5 = {
		[StatusBadgeSize.XSmall] = {
			container = {
				tag = "padding-x-xsmall"
			}
		},
		[StatusBadgeSize.Small] = {
			container = {
				tag = "padding-x-small"
			}
		}
	}

	return {
		common = t1,
		variants = t2,
		shapes = t3,
		sizes = t4,
		boxSizes = t5
	}
end

return function(p2, p3, p4, p5) -- line: 113
	-- upvalues: VariantsContext (copy), composeStyleVariant (copy), StatusBadgeShape (copy)
	local v17 = VariantsContext.useVariants("StatusBadge", variantsFactory, p2)

	return composeStyleVariant(v17.common, v17.variants[p3], v17.shapes[p4], v17.sizes[p5], if p4 ~= StatusBadgeShape.Box then nil else v17.boxSizes[p5])
end
