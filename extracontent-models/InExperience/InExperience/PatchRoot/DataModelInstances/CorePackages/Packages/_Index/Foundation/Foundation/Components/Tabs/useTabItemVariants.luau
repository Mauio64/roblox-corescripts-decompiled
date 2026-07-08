local Foundation = script:FindFirstAncestor("Foundation")
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local InputSize = require(Foundation.Enums.InputSize)
local IconSize = require(Foundation.Enums.IconSize)

local function variantsFactory(_) -- line: 35
	-- upvalues: InputSize (copy), IconSize (copy), Flags (copy)
	local t1 = {
		text = {
			tag = "auto-x"
		},
		content = {
			tag = "row align-x-center align-y-center gap-small"
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			text = {
				tag = "size-0-400 text-label-small"
			},
			content = {
				tag = "padding-y-small"
			},
			icon = {
				size = IconSize.XSmall
			}
		},
		[InputSize.Small] = {
			text = {
				tag = "size-0-600 text-label-medium"
			},
			content = {
				tag = "padding-y-small"
			},
			icon = {
				size = IconSize.Medium
			}
		},
		[InputSize.Medium] = {
			text = {
				tag = "size-0-600 text-label-medium"
			},
			content = {
				tag = "padding-y-medium"
			},
			icon = {
				size = IconSize.Medium
			}
		},
		[InputSize.Large] = {
			text = {
				tag = "size-0-600 text-label-medium"
			},
			content = {
				tag = "padding-y-xlarge"
			},
			icon = {
				size = IconSize.Medium
			}
		}
	}
	local t3 = {
		[InputSize.XSmall] = {
			content = {
				tag = "padding-x-small"
			}
		},
		[InputSize.Small] = {
			content = {
				tag = "padding-x-small"
			}
		},
		[InputSize.Medium] = {
			content = {
				tag = "padding-x-medium"
			}
		},
		[InputSize.Large] = {
			content = {
				tag = "padding-x-large"
			}
		}
	}
	local t4 = {
		[false] = {
			container = {
				tag = "auto-xy"
			},
			content = {
				tag = "size-0-0 auto-xy"
			}
		},
		[true] = {
			container = {
				tag = "grow auto-xy"
			},
			content = if not Flags.FoundationTabsInlineSizeFull then {
				tag = "size-full-0 auto-y"
			} else {
				tag = "auto-y",
				Size = UDim2.fromScale(1, 0)
			}
		}
	}

	return {
		common = t1,
		sizes = t2,
		isFill = t4,
		paddings = t3
	}
end

return function(p2, p3, b1: boolean) -- line: 84
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v16 = VariantsContext.useVariants("Tab", variantsFactory, p2)

	return composeStyleVariant(v16.common, v16.sizes[p3], v16.isFill[b1], if not b1 then {} else v16.paddings[p3])
end
