local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local FillBehavior = require(Foundation.Enums.FillBehavior)

local InputSize = require(Foundation.Enums.InputSize)

local IconSize = require(Foundation.Enums.IconSize)

local SegmentedControlVariant = require(Foundation.Enums.SegmentedControlVariant)

local Flags = require(Foundation.Utility.Flags)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function strokeFromStyle(emphasis, standard: number) -- 1 equivalent call inferred from this helper
	return {
		Color = emphasis.Color3,
		Transparency = emphasis.Transparency,
		Thickness = standard,
		BorderStrokePosition = Enum.BorderStrokePosition.Outer
	}
end

local function variantsFactory_DEPRECATED(p)
	return {
		common = {
			container = { tag = "row align-y-center auto-x bg-surface-300" },
			segment = { tag = "row align-y-center size-0-full auto-x" },
			text = { tag = "auto-x text-truncate-end content-emphasis" },
			icon = { style = p.Color.Content.Emphasis },
			divider = { tag = "row" }
		},
		sizes = {
			[InputSize.XSmall] = {
				container = { tag = "size-600" },
				segment = { tag = "padding-small" },
				text = { tag = "text-caption-small" },
				icon = { size = IconSize.Small },
				divider = {
					Size = UDim2.new(0, p.Stroke.Standard, 1, 0)
				}
			},
			[InputSize.Small] = {
				container = { tag = "size-800" },
				segment = { tag = "padding-small" },
				text = { tag = "text-caption-small" },
				icon = { size = IconSize.Medium },
				divider = {
					Size = UDim2.new(0, p.Stroke.Standard, 1, 0)
				}
			},
			[InputSize.Medium] = {
				container = { tag = "size-1000 padding-xsmall" },
				segment = { tag = "padding-small" },
				text = { tag = "text-caption-medium" },
				icon = { size = IconSize.Medium },
				divider = {
					Size = UDim2.new(0, p.Stroke.Standard, 1, 0)
				}
			},
			[InputSize.Large] = {
				container = { tag = "size-1200 padding-xsmall" },
				segment = { tag = "padding-medium" },
				text = { tag = "text-caption-medium" },
				icon = { size = IconSize.Large },
				divider = {
					Size = UDim2.new(0, p.Stroke.Standard, 1, 0)
				}
			}
		},
		defaultRadius = {
			[InputSize.XSmall] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-medium" }
			},
			[InputSize.Small] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-medium" }
			},
			[InputSize.Medium] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-small" }
			},
			[InputSize.Large] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-small" }
			}
		},
		circularRadius = {
			container = { tag = "radius-circle" },
			segment = { tag = "radius-circle" }
		}
	}
end

local function variantsFactory(p)
	local variantStyles = {
		[SegmentedControlVariant.Filled] = {
			container = { tag = "bg-shift-200" }
		}
	}
	local stroke = SegmentedControlVariant.Stroke
	variantStyles[stroke] = {
		container = {
			stroke = strokeFromStyle(p.Color.Stroke.Emphasis, p.Stroke.Standard) -- inferred equivalent call
		}
	}

	variantStyles[SegmentedControlVariant.Utility] = {}

	local sizes = {
		[InputSize.XSmall] = {
			segment = { tag = "padding-x-small" },
			text = { tag = "text-label-small" },
			icon = { size = IconSize.XSmall }
		},
		[InputSize.Small] = {
			segment = { tag = "padding-x-medium" },
			text = { tag = "text-label-small" },
			icon = { size = IconSize.Small }
		},
		[InputSize.Medium] = {
			container = { tag = "padding-xsmall" },
			segment = { tag = "padding-x-medium" },
			text = { tag = "text-label-medium" },
			icon = { size = IconSize.Medium }
		},
		[InputSize.Large] = {
			container = { tag = "padding-xsmall" },
			segment = { tag = "padding-x-large" },
			text = { tag = "text-label-large" },
			icon = { size = IconSize.Large }
		}
	}

	local fitSizes = {
		[InputSize.XSmall] = {
			container = { tag = "size-0-600 auto-x" }
		},
		[InputSize.Small] = {
			container = { tag = "size-0-800 auto-x" }
		},
		[InputSize.Medium] = {
			container = { tag = "size-0-1000 auto-x" }
		},
		[InputSize.Large] = {
			container = { tag = "size-0-1200 auto-x" }
		}
	}

	local fillBehaviorStyles = {
		[FillBehavior.Fit] = {
			segment = { tag = "size-0-full auto-xy" }
		},
		[FillBehavior.Fill] = {
			segment = { tag = "grow auto-xy" }
		}
	}

	local fillSizes = {
		[InputSize.XSmall] = {
			container = { tag = "size-full-600" }
		},
		[InputSize.Small] = {
			container = { tag = "size-full-800" }
		},
		[InputSize.Medium] = {
			container = { tag = "size-full-1000" }
		},
		[InputSize.Large] = {
			container = { tag = "size-full-1200" }
		}
	}

	local utilityPadding = {
		[InputSize.XSmall] = {},
		[InputSize.Small] = {
			segment = { tag = "padding-x-medium" }
		},
		[InputSize.Medium] = {
			segment = { tag = "padding-x-large" }
		},
		[InputSize.Large] = {
			segment = { tag = "padding-x-xlarge" }
		}
	}

	return {
		common = {
			container = { tag = "row flex-y-fill align-y-center gap-xxsmall" },
			segment = { tag = "row align-x-center align-y-center" },
			text = { tag = "auto-x text-align-x-center text-truncate-end" },
			icon = {}
		},
		activeStyles = {
			[true] = {
				text = { style = p.Color.Content.Emphasis },
				icon = { style = p.Color.Content.Emphasis }
			},
			[false] = {
				text = { style = p.Color.Content.Default },
				icon = { style = p.Color.Content.Default }
			}
		},
		variantStyles = variantStyles,
		sizes = sizes,
		fitSizes = fitSizes,
		fillBehaviorStyles = fillBehaviorStyles,
		fillSizes = fillSizes,
		utilityPadding = utilityPadding,
		defaultRadius = {
			[InputSize.XSmall] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-medium" }
			},
			[InputSize.Small] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-medium" }
			},
			[InputSize.Medium] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-small" }
			},
			[InputSize.Large] = {
				container = { tag = "radius-medium" },
				segment = { tag = "radius-small" }
			}
		},
		circularRadius = {
			container = { tag = "radius-circle" },
			segment = { tag = "radius-circle" }
		}
	}
end

return function(p, p2, p3, p4, flag: boolean?, flag2: boolean?)
	if Flags.FoundationSegmentedControlBeta then
		local v = VariantsContext.useVariants("SegmentedControl", variantsFactory, p)

		local common = v.common
		local siz = v.sizes[p2]
		local v2 = p3 ~= SegmentedControlVariant.Utility and {} or v.utilityPadding[p2]
		local v3

		if p4 == FillBehavior.Fill then
			v3 = v.fillSizes[p2]
		else
			v3 = v.fitSizes[p2]
		end

		local fillBehaviorStyle = v.fillBehaviorStyles[p4]
		local activeStyle = v.activeStyles[flag2 == true]
		local variantStyle = v.variantStyles[p3]
		local v4

		if flag then
			v4 = v.circularRadius
		else
			v4 = v.defaultRadius[p2]
		end

		return composeStyleVariant(common, siz, v2, v3, fillBehaviorStyle, activeStyle, variantStyle, v4)
	else
		local v = VariantsContext.useVariants("SegmentedControl", variantsFactory_DEPRECATED, p)

		local common = v.common
		local siz = v.sizes[p2]
		local v2

		if flag then
			v2 = v.circularRadius
		else
			v2 = v.defaultRadius[p2]
		end

		return composeStyleVariant(common, siz, v2)
	end
end
