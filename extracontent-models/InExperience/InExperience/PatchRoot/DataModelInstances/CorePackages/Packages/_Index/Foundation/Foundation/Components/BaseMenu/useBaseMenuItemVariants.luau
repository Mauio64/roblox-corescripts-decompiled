local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
local IconSize = require(Foundation.Enums.IconSize)

local function legacyVariants(p1) -- line: 42
	-- upvalues: InputSize (copy), IconSize (copy)
	local t1 = {
		container = {
			tag = "row flex-x-between align-y-center auto-x"
		},
		icon = {
			tag = "radius-small content-emphasis",
			style = p1.Color.Content.Emphasis
		},
		text = {
			tag = "fill auto-xy text-align-x-left text-truncate-split content-emphasis"
		},
		title = {
			tag = "fill auto-xy text-align-x-left text-truncate-split content-default"
		},
		check = {
			tag = "content-emphasis",
			style = p1.Color.Content.Emphasis
		},
		slotAlign = {
			tag = "align-x-center align-y-center"
		},
		submenuContent = {
			tag = "stroke-standard stroke-default radius-medium"
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			container = {
				tag = "gap-xsmall size-full-600 padding-x-medium radius-small"
			},
			icon = {
				tag = "size-400",
				size = IconSize.XSmall
			},
			text = {
				tag = "text-body-small"
			},
			title = {
				tag = "text-caption-small"
			},
			check = {
				tag = "size-300",
				size = p1.Size.Size_600
			},
			chevron = {
				size = IconSize.Small
			},
			groupPadding = {
				size = p1.Padding.XSmall
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "gap-xsmall size-full-800 padding-x-medium radius-medium"
			},
			icon = {
				tag = "size-500",
				size = IconSize.Small
			},
			text = {
				tag = "text-body-small"
			},
			title = {
				tag = "text-caption-small"
			},
			check = {
				tag = "size-400",
				size = p1.Size.Size_700
			},
			chevron = {
				size = IconSize.Small
			},
			groupPadding = {
				size = p1.Padding.Small
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "gap-small size-full-1000 padding-x-medium radius-medium"
			},
			icon = {
				tag = "size-600",
				size = IconSize.Medium
			},
			text = {
				tag = "text-body-medium"
			},
			title = {
				tag = "text-caption-medium"
			},
			check = {
				tag = "size-500",
				size = p1.Size.Size_800
			},
			chevron = {
				size = IconSize.Medium
			},
			groupPadding = {
				size = p1.Padding.Small
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "gap-small size-full-1200 padding-x-large radius-medium"
			},
			icon = {
				tag = "size-700",
				size = IconSize.Large
			},
			text = {
				tag = "text-body-large"
			},
			title = {
				tag = "text-caption-large"
			},
			check = {
				tag = "size-600",
				size = p1.Size.Size_900
			},
			chevron = {
				size = IconSize.Large
			},
			groupPadding = {
				size = p1.Padding.Small
			}
		}
	}
	local t3 = {
		[false] = {
			container = {
				tag = ""
			}
		},
		[true] = {
			container = {
				tag = "bg-surface-200"
			}
		}
	}
	local t4 = {
		[false] = {
			submenuContent = {
				tag = "col auto-xy"
			}
		},
		[true] = {
			submenuContent = {
				tag = ""
			}
		}
	}
	local t5 = {
		container = {
			tag = "auto-x"
		}
	}

	return {
		common = t1,
		sizes = t2,
		isChecked = t3,
		isScrollable = t4,
		defaultSize = t5
	}
end
local function refreshVariants(p2) -- line: 125
	-- upvalues: InputSize (copy), IconSize (copy)
	local t6 = {
		container = {
			tag = ""
		},
		icon = {
			tag = "radius-small content-emphasis",
			style = p2.Color.Content.Emphasis
		},
		text = {
			tag = "fill auto-xy text-align-x-left text-truncate-end content-emphasis"
		},
		title = {
			tag = "fill auto-xy text-align-x-left text-truncate-end content-default"
		},
		check = {
			tag = "content-emphasis",
			style = p2.Color.Content.Emphasis
		},
		slotAlign = {
			tag = "align-x-center align-y-center"
		},
		submenuContent = {
			tag = "stroke-standard stroke-default radius-medium"
		}
	}
	local t7 = {
		[InputSize.XSmall] = {
			container = {
				tag = "size-full-600 radius-small",
				paddingLeftWithCheck = 0,
				paddingLeftWithoutCheck = p2.Padding.Small,
				paddingRight = p2.Padding.Small
			},
			wrapper = {
				gap = p2.Size.Size_150
			},
			icon = {
				tag = "size-400",
				size = IconSize.XSmall
			},
			text = {
				tag = "text-body-small"
			},
			title = {
				tag = "text-caption-small",
				checkColumnWidth = p2.Size.Size_500
			},
			check = {
				tag = "size-500-400",
				size = p2.Size.Size_400
			},
			chevron = {
				size = IconSize.Small
			},
			groupPadding = {
				size = p2.Padding.XSmall
			}
		},
		[InputSize.Small] = {
			container = {
				tag = "size-full-800 radius-small",
				paddingLeftWithCheck = 0,
				paddingLeftWithoutCheck = p2.Padding.Small,
				paddingRight = p2.Padding.Small
			},
			wrapper = {
				gap = p2.Size.Size_150
			},
			icon = {
				tag = "size-500",
				size = IconSize.Small
			},
			text = {
				tag = "text-body-small"
			},
			title = {
				tag = "text-caption-small",
				checkColumnWidth = p2.Size.Size_600
			},
			check = {
				tag = "size-600-400",
				size = p2.Size.Size_400
			},
			chevron = {
				size = IconSize.Small
			},
			groupPadding = {
				size = p2.Padding.Small
			}
		},
		[InputSize.Medium] = {
			container = {
				tag = "size-full-1000 radius-medium",
				paddingLeftWithCheck = 0,
				paddingLeftWithoutCheck = p2.Size.Size_250,
				paddingRight = p2.Size.Size_250
			},
			wrapper = {
				gap = p2.Size.Size_150
			},
			icon = {
				tag = "size-500",
				size = IconSize.Medium
			},
			text = {
				tag = "text-body-medium"
			},
			title = {
				tag = "text-caption-medium",
				checkColumnWidth = p2.Size.Size_700
			},
			check = {
				tag = "size-700-500",
				size = p2.Size.Size_500
			},
			chevron = {
				size = IconSize.Medium
			},
			groupPadding = {
				size = p2.Padding.Small
			}
		},
		[InputSize.Large] = {
			container = {
				tag = "size-full-1200 radius-medium",
				paddingLeftWithCheck = 0,
				paddingLeftWithoutCheck = p2.Size.Size_350,
				paddingRight = p2.Size.Size_350
			},
			wrapper = {
				gap = p2.Padding.Small
			},
			icon = {
				tag = "size-600",
				size = IconSize.Large
			},
			text = {
				tag = "text-body-large"
			},
			title = {
				tag = "text-caption-large",
				checkColumnWidth = p2.Size.Size_800
			},
			check = {
				tag = "size-800-600",
				size = p2.Size.Size_600
			},
			chevron = {
				size = IconSize.Large
			},
			groupPadding = {
				size = p2.Padding.Small
			}
		}
	}
	local t8 = {
		[false] = {
			container = {
				tag = ""
			}
		},
		[true] = {
			container = {
				tag = ""
			}
		}
	}
	local t9 = {
		[false] = {
			submenuContent = {
				tag = "col auto-xy"
			}
		},
		[true] = {
			submenuContent = {
				tag = ""
			}
		}
	}
	local t10 = {
		container = {
			tag = "auto-x"
		}
	}

	return {
		common = t6,
		sizes = t7,
		isChecked = t8,
		isScrollable = t9,
		defaultSize = t10
	}
end
local function variantsMap(p3) -- line: 233
	-- upvalues: Flags (copy), refreshVariants (copy), legacyVariants (copy)
	if Flags.FoundationBaseMenuBeta then
		return (refreshVariants(p3))
	end

	return (legacyVariants(p3))
end

return function(p4, p5, b1: boolean, b2: boolean) -- line: 243
	-- upvalues: VariantsContext (copy), variantsMap (copy), Flags (copy), composeStyleVariant (copy)
	local v27 = VariantsContext.useVariants("BaseMenuItem", variantsMap, p4)

	if not Flags.FoundationBaseMenuBeta then
		return composeStyleVariant(v27.common, v27.sizes[p5], v27.isChecked[b1], v27.isScrollable[b2])
	end

	return composeStyleVariant(v27.common, v27.sizes[p5], v27.defaultSize, v27.isScrollable[b2])
end
