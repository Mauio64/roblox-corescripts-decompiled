local Foundation = script:FindFirstAncestor("Foundation")

local Flags = require(Foundation.Utility.Flags)

local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)

local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)

local StatusIndicatorShape = require(Foundation.Enums.StatusIndicatorShape)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local indexBindable = require(Foundation.Utility.indexBindable)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local devAssert = require(Foundation.Utility.devAssert)

local Constants = require(Foundation.Constants)

local font = Font.new(Constants.BUILDER_SANS_FONT_ASSET, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

function variantsFactory(data)
	local common = {
		content = {
			tag = "auto-xy text-align-x-left",
			font = font,
			typography = data.Typography.LabelSmall
		},
		stroke = Flags.FoundationStatusIndicatorDesignUpdate and { Thickness = data.Stroke.Thicker } or nil
	}

	local variants = {
		[StatusIndicatorVariant.Alert] = {
			container = { tag = "bg-system-alert" },
			content = { style = data.DarkMode.Content.Emphasis }
		},
		[StatusIndicatorVariant.Success] = {
			container = { tag = "bg-system-success" },
			content = { style = data.LightMode.Content.Emphasis }
		},
		[StatusIndicatorVariant.Warning] = {
			container = { tag = "bg-system-warning" },
			content = { style = data.LightMode.Content.Emphasis }
		},
		[StatusIndicatorVariant.Emphasis] = {
			container = { tag = "bg-system-emphasis" },
			content = { style = data.DarkMode.Content.Emphasis }
		},
		[StatusIndicatorVariant.Neutral] = {
			container = { tag = "bg-system-neutral" },
			content = { style = data.Inverse.Content.Emphasis }
		},
		[StatusIndicatorVariant.Standard] = {
			container = { tag = "bg-action-standard" },
			content = { style = data.Color.Content.Emphasis }
		},
		[StatusIndicatorVariant.Contrast_Experiment] = {
			container = { tag = "bg-system-contrast" },
			content = { style = data.Inverse.Content.Emphasis }
		},
		[StatusIndicatorVariant.Voice] = {
			container = { backgroundStyle = data.Color.Extended.Orange.Orange_600 }
		}
	}

	local hasValue = {
		[true] = {
			container = {
				tag = Flags.FoundationStatusIndicatorDesignUpdate and "row align-x-center align-y-center auto-x padding-xsmall" or "row align-x-center align-y-center size-400-400 auto-x padding-xsmall"
			}
		}
	}

	local shape = {
		[StatusIndicatorShape.Circle] = {
			container = { tag = "radius-circle" },
			stroke = { LineJoinMode = Enum.LineJoinMode.Round }
		},
		[StatusIndicatorShape.Ring] = {
			container = { tag = "align-x-center align-y-center radius-circle" },
			ring = { tag = "radius-circle bg-surface-100" },
			stroke = { LineJoinMode = Enum.LineJoinMode.Round }
		},
		[StatusIndicatorShape.Square] = {
			container = { tag = "radius-none" },
			stroke = { LineJoinMode = Enum.LineJoinMode.Miter }
		}
	}

	local sizes = {
		[StatusIndicatorSize.XSmall] = {
			container = {
				size = UDim2.fromOffset(data.Size.Size_150, data.Size.Size_150)
			},
			ring = {
				size = UDim2.fromOffset(data.Size.Size_150 / 2, data.Size.Size_150 / 2)
			},
			stroke = not Flags.FoundationStatusIndicatorDesignUpdate and {
				Thickness = data.Stroke.Standard
			} or nil
		},
		[StatusIndicatorSize.Small] = {
			container = {
				size = UDim2.fromOffset(data.Size.Size_200, data.Size.Size_200)
			},
			ring = {
				size = UDim2.fromOffset(data.Size.Size_200 / 2, data.Size.Size_200 / 2)
			},
			stroke = not Flags.FoundationStatusIndicatorDesignUpdate and {
				Thickness = data.Size.Size_50
			} or nil
		},
		[StatusIndicatorSize.Medium] = {
			container = {
				size = UDim2.fromOffset(data.Size.Size_250, data.Size.Size_250)
			},
			ring = {
				size = UDim2.fromOffset(data.Size.Size_250 / 2, data.Size.Size_250 / 2)
			},
			stroke = not Flags.FoundationStatusIndicatorDesignUpdate and {
				Thickness = data.Size.Size_50
			} or nil
		},
		[StatusIndicatorSize.Large] = {
			container = {
				size = UDim2.fromOffset(data.Size.Size_500, data.Size.Size_500)
			},
			ring = {
				size = UDim2.fromOffset(data.Size.Size_500 / 2, data.Size.Size_500 / 2)
			},
			stroke = { Thickness = data.Stroke.Thicker }
		},
		[StatusIndicatorSize.Pictogram] = {
			container = {
				size = UDim2.fromOffset(data.Size.Size_500, data.Size.Size_500)
			},
			ring = {
				size = UDim2.fromOffset(data.Size.Size_500 / 2, data.Size.Size_500 / 2)
			},
			stroke = { Thickness = data.Stroke.Thicker }
		}
	}

	local v = {
		container = {
			size = UDim2.fromOffset(data.Size.Size_400, data.Size.Size_400)
		}
	}

	local v2 = {
		container = {
			size = UDim2.fromOffset(data.Size.Size_500, data.Size.Size_500)
		},
		content = { typography = data.Typography.LabelMedium }
	}

	local numericSizes = {
		[StatusIndicatorSize.XSmall] = v,
		[StatusIndicatorSize.Small] = v,
		[StatusIndicatorSize.Medium] = v,
		[StatusIndicatorSize.Large] = v2,
		[StatusIndicatorSize.Pictogram] = v2
	}

	if not Flags.FoundationStatusIndicatorDesignUpdate then
		numericSizes = nil
	end

	return {
		common = common,
		variants = variants,
		hasValue = hasValue,
		shape = shape,
		sizes = sizes,
		numericSizes = numericSizes
	}
end

return function(p, p2, flag: boolean, p3, p4, p5)
	devAssert(p2 ~= StatusIndicatorVariant.Contrast_Experiment, "Contrast is not a supported StatusIndicator variant.")

	devAssert(
		p2 ~= StatusIndicatorVariant.Alert or not flag,
		"Alert is not a supported numeric StatusIndicator variant."
	)

	local v = p5 and {
		stroke = {
			Color = indexBindable(p5, "Color3"),
			Transparency = indexBindable(p5, "Transparency")
		}
	} or nil

	local v2 = VariantsContext.useVariants("StatusIndicator", variantsFactory, p)

	local common = v2.common
	local variant = v2.variants[p2]
	local v3 = v2.hasValue[flag]
	local v4 = v2.shape[p3]
	local v5

	if Flags.FoundationStatusIndicatorDesignUpdate then
		if flag then
			v5 = v2.numericSizes[p4]
		else
			v5 = v2.sizes[p4]
		end
	else
		v5 = flag and {} or v2.sizes[p4]
	end

	return composeStyleVariant(common, variant, v3, v4, v5, v)
end
