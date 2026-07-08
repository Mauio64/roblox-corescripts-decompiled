local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)
local StatusIndicatorShape = require(Foundation.Enums.StatusIndicatorShape)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local v7 = _G.__DEV__ == true
local Constants = require(Foundation.Constants)
local font = Font.new(Constants.BUILDER_SANS_FONT_ASSET, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)

function variantsFactory(p1) -- line: 33
	-- upvalues: Flags (copy), font (copy), StatusIndicatorVariant (copy), StatusIndicatorShape (copy)
	local t1 = {
		content = {
			tag = not Flags.FoundationStatusIndicatorBeta and "auto-xy text-caption-small text-align-x-left" or "auto-xy text-align-x-left",
			font = if not Flags.FoundationStatusIndicatorBeta then nil else font
		}
	}
	local t2 = {
		[StatusIndicatorVariant.Alert] = {
			container = {
				tag = "bg-system-alert"
			},
			content = {
				style = p1.DarkMode.Content.Emphasis
			}
		},
		[StatusIndicatorVariant.Success] = {
			container = {
				tag = "bg-system-success"
			},
			content = {
				style = p1.LightMode.Content.Emphasis
			}
		},
		[StatusIndicatorVariant.Warning] = {
			container = {
				tag = "bg-system-warning"
			},
			content = {
				style = p1.LightMode.Content.Emphasis
			}
		},
		[StatusIndicatorVariant.Emphasis] = if not Flags.FoundationActionEmphasisStatusIndicator then {
			container = {
				tag = "bg-system-emphasis"
			},
			content = {
				style = p1.DarkMode.Content.Emphasis
			}
		} else {
			container = {
				tag = "bg-action-emphasis"
			},
			content = {
				style = p1.Color.ActionEmphasis.Foreground
			}
		},
		[StatusIndicatorVariant.Neutral] = {
			container = {
				tag = "bg-system-neutral"
			},
			content = {
				style = p1.Inverse.Content.Emphasis
			}
		},
		[StatusIndicatorVariant.Standard] = {
			container = {
				tag = "bg-action-standard"
			},
			content = {
				style = p1.Color.Content.Emphasis
			}
		},
		[StatusIndicatorVariant.Contrast_Experiment] = {
			container = {
				tag = "bg-system-contrast"
			},
			content = {
				style = p1.Inverse.Content.Emphasis
			}
		},
		[StatusIndicatorVariant.Voice] = {
			container = {
				backgroundStyle = p1.Color.Extended.Orange.Orange_600
			}
		}
	}
	local t3 = {
		[false] = {
			container = {
				tag = "size-200-200"
			}
		},
		[true] = {
			container = {
				tag = "row align-x-center align-y-center size-400-400 auto-x padding-xsmall"
			}
		}
	}
	local t4 = {
		[StatusIndicatorShape.Circle] = {
			container = {
				tag = "radius-circle"
			}
		},
		[StatusIndicatorShape.Ring] = {
			container = {
				tag = "align-x-center align-y-center radius-circle"
			},
			ring = {
				tag = "size-100-100 radius-circle bg-surface-100"
			}
		},
		[StatusIndicatorShape.Square] = {
			container = {
				tag = "radius-none"
			}
		}
	}

	return {
		common = t1,
		variants = t2,
		hasValue = t3,
		shape = t4
	}
end

return function(p2, p3, b1: boolean, p4) -- line: 141
	-- upvalues: Flags (copy), v7 (copy), StatusIndicatorVariant (copy), VariantsContext (copy), composeStyleVariant (copy)
	if not Flags.FoundationStatusIndicatorVariantExperiment and v7 then
		if p3 == StatusIndicatorVariant.Contrast_Experiment then
			error("Contrast is not a supported StatusIndicator variant.")
		end

		if p3 == StatusIndicatorVariant.Alert and b1 then
			error("Alert is not a supported numeric StatusIndicator variant.")
		end
	end

	local v19 = VariantsContext.useVariants("StatusIndicator", variantsFactory, p2)

	return composeStyleVariant(v19.common, v19.variants[p3], v19.hasValue[b1], v19.shape[p4])
end
