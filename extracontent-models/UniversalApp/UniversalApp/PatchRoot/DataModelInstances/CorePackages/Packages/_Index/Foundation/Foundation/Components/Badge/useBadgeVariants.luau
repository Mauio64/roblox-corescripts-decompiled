local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BadgeVariant = require(Foundation.Enums.BadgeVariant)
local Dash = require(FoundationParent.Dash)
local BadgeShape = require(Foundation.Enums.BadgeShape)
local BadgeSize = require(Foundation.Enums.BadgeSize)
local IconPosition = require(Foundation.Enums.IconPosition)
local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

function variantsFactory(p1) -- line: 35
	-- upvalues: Flags (copy), BadgeVariant (copy), BadgeSize (copy), IconSize (copy), BadgeShape (copy), IconPosition (copy), Dash (copy)
	local t1 = {
		container = {
			tag = not Flags.FoundationBadgeBetaUpdate and "row align-x-center align-y-center gap-xsmall" or "row align-x-center align-y-center auto-xy"
		},
		text = {
			tag = not Flags.FoundationBadgeBetaUpdate and "auto-xy text-label-small text-align-x-left text-truncate-split" or "auto-xy text-align-x-left text-truncate-split"
		}
	}
	local t2 = {
		[BadgeVariant.Alert] = {
			container = {
				backgroundStyle = if not Flags.FoundationBadgeBetaUpdate then p1.Color.System.Alert else {
					Transparency = 0.8,
					Color3 = p1.Color.System.Alert.Color3
				}
			},
			content = {
				style = if not Flags.FoundationBadgeBetaUpdate then p1.DarkMode.Content.Emphasis else p1.Color.Content.Emphasis
			},
			icon = {
				style = p1.Color.System.Alert
			}
		},
		[BadgeVariant.Success] = {
			container = {
				backgroundStyle = if not Flags.FoundationBadgeBetaUpdate then p1.Color.System.Success else {
					Transparency = 0.8,
					Color3 = p1.Color.System.Success.Color3
				}
			},
			content = {
				style = if not Flags.FoundationBadgeBetaUpdate then p1.LightMode.Content.Emphasis else p1.Color.Content.Emphasis
			},
			icon = {
				style = p1.Color.System.Success
			}
		},
		[BadgeVariant.Warning] = {
			container = {
				backgroundStyle = if not Flags.FoundationBadgeBetaUpdate then p1.Color.System.Warning else {
					Transparency = 0.8,
					Color3 = p1.Color.System.Warning.Color3
				}
			},
			content = {
				style = if not Flags.FoundationBadgeBetaUpdate then p1.LightMode.Content.Emphasis else p1.Color.Content.Emphasis
			},
			icon = {
				style = p1.Color.System.Warning
			}
		},
		[BadgeVariant.Contrast] = {
			container = {
				backgroundStyle = p1.Color.System.Contrast
			},
			content = {
				style = p1.Inverse.Content.Emphasis
			},
			icon = {
				style = p1.Inverse.Content.Emphasis
			}
		},
		[BadgeVariant.Neutral] = {
			container = {
				backgroundStyle = if not Flags.FoundationBadgeBetaUpdate then p1.Color.Shift.Shift_300 else p1.Color.ActionStandard.Background
			},
			content = {
				style = if not Flags.FoundationBadgeBetaUpdate then p1.Color.Content.Emphasis else p1.Color.ActionStandard.Foreground
			},
			icon = {
				style = p1.Color.ActionStandard.Foreground
			}
		},
		[BadgeVariant.OverMedia] = {
			container = {
				backgroundStyle = if not Flags.FoundationBadgeBetaUpdate then p1.LightMode.Surface.Surface_100 else p1.Color.OverMedia.OverMedia_0,
				stroke = if not Flags.FoundationBadgeBetaUpdate then {
					Color = p1.LightMode.Stroke.Default.Color3,
					Transparency = p1.LightMode.Stroke.Default.Transparency
				} else nil
			},
			content = {
				style = if not Flags.FoundationBadgeBetaUpdate then p1.LightMode.Content.Emphasis else p1.Inverse.OverMedia.OverMedia_0
			},
			icon = {
				style = p1.Inverse.OverMedia.OverMedia_0
			}
		},
		[BadgeVariant.Emphasis] = {
			container = {
				backgroundStyle = p1.Color.ActionEmphasis.Background
			},
			content = {
				style = p1.Color.ActionEmphasis.Foreground
			},
			icon = {
				style = p1.Color.ActionEmphasis.Foreground
			}
		}
	}
	local v15 = if not Flags.FoundationBadgeBetaUpdate then {
		[true] = {
			container = {
				tag = "size-600"
			}
		},
		[false] = {
			container = {
				tag = "size-0-600 auto-x padding-x-small"
			}
		}
	} else nil
	local v16 = if not Flags.FoundationBadgeBetaUpdate then nil else {
		[BadgeSize.XSmall] = {
			container = {
				tag = "gap-xxsmall size-0-400 padding-x-xsmall"
			},
			text = {
				tag = "text-caption-small"
			},
			icon = {
				size = IconSize.XSmall
			}
		},
		[BadgeSize.Small] = {
			container = {
				tag = "gap-xsmall size-0-600 padding-x-small"
			},
			text = {
				tag = "text-caption-medium"
			},
			icon = {
				size = IconSize.XSmall
			}
		},
		[BadgeSize.Medium] = {
			container = {
				tag = "gap-xsmall size-0-600 padding-x-small"
			},
			text = {
				tag = "text-caption-medium"
			},
			icon = {
				size = IconSize.XSmall
			}
		}
	}
	local t3 = {
		[BadgeShape.Pill] = {
			container = {
				tag = "radius-circle"
			}
		},
		[BadgeShape.Box] = {
			container = {
				tag = "radius-small"
			}
		}
	}
	local v18 = if not Flags.FoundationBadgeBetaUpdate then nil else {
		[IconPosition.Left] = {
			text = {
				tag = "padding-right-xsmall"
			}
		},
		[IconPosition.Right] = {
			text = {
				tag = "padding-left-xsmall"
			}
		},
		[Dash.None] = {
			text = {
				tag = "padding-x-xsmall"
			}
		}
	}

	return {
		common = t1,
		variants = t2,
		shapes = t3,
		iconOnly = if not Flags.FoundationBadgeBetaUpdate then v15 else nil,
		sizes = v16,
		iconPlacement = v18
	}
end

return function(p2, p3, p4, p5, p6, b1: boolean) -- line: 211
	-- upvalues: VariantsContext (copy), composeStyleVariant (copy), Flags (copy), Dash (copy)
	local v25 = VariantsContext.useVariants("Badge", variantsFactory, p2)

	return composeStyleVariant(v25.common, v25.variants[p3], v25.shapes[p4], if not Flags.FoundationBadgeBetaUpdate then nil else v25.sizes[p5], if not Flags.FoundationBadgeBetaUpdate then nil else v25.iconPlacement[p6 or Dash.None], if not Flags.FoundationBadgeBetaUpdate then v25.iconOnly[b1] else nil)
end
