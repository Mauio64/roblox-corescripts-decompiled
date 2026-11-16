local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BadgeVariant = require(Foundation.Enums.BadgeVariant)
local Dash = require(parent.Dash)

local BadgeShape = require(Foundation.Enums.BadgeShape)

local BadgeSize = require(Foundation.Enums.BadgeSize)

local IconPosition = require(Foundation.Enums.IconPosition)

local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local Flags = require(Foundation.Utility.Flags)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

function variantsFactory(data)
	local common = {
		container = {
			tag = Flags.FoundationBadgeBetaUpdate and "row align-x-center align-y-center auto-xy" or "row align-x-center align-y-center gap-xsmall"
		},
		text = {
			tag = Flags.FoundationBadgeBetaUpdate and "auto-xy text-align-x-left text-truncate-split" or "auto-xy text-label-small text-align-x-left text-truncate-split"
		}
	}

	local alert = BadgeVariant.Alert
	local backgroundStyle

	if Flags.FoundationBadgeBetaUpdate then
		backgroundStyle = { Color3 = data.Color.System.Alert.Color3, Transparency = 0.8 }
	else
		backgroundStyle = data.Color.System.Alert
	end

	local style

	if Flags.FoundationBadgeBetaUpdate then
		style = data.Color.Content.Emphasis
	else
		style = data.DarkMode.Content.Emphasis
	end

	local variants = {
		[alert] = {
			container = { backgroundStyle = backgroundStyle },
			content = { style = style },
			icon = { style = data.Color.System.Alert }
		}
	}

	local success = BadgeVariant.Success
	local backgroundStyle2

	if Flags.FoundationBadgeBetaUpdate then
		backgroundStyle2 = { Color3 = data.Color.System.Success.Color3, Transparency = 0.8 }
	else
		backgroundStyle2 = data.Color.System.Success
	end

	local style2

	if Flags.FoundationBadgeBetaUpdate then
		style2 = data.Color.Content.Emphasis
	else
		style2 = data.LightMode.Content.Emphasis
	end

	variants[success] = {
		container = { backgroundStyle = backgroundStyle2 },
		content = { style = style2 },
		icon = { style = data.Color.System.Success }
	}

	local warning = BadgeVariant.Warning
	local backgroundStyle3

	if Flags.FoundationBadgeBetaUpdate then
		backgroundStyle3 = { Color3 = data.Color.System.Warning.Color3, Transparency = 0.8 }
	else
		backgroundStyle3 = data.Color.System.Warning
	end

	local style3

	if Flags.FoundationBadgeBetaUpdate then
		style3 = data.Color.Content.Emphasis
	else
		style3 = data.LightMode.Content.Emphasis
	end

	variants[warning] = {
		container = { backgroundStyle = backgroundStyle3 },
		content = { style = style3 },
		icon = { style = data.Color.System.Warning }
	}

	variants[BadgeVariant.Contrast] = {
		container = { backgroundStyle = data.Color.System.Contrast },
		content = { style = data.Inverse.Content.Emphasis },
		icon = { style = data.Inverse.Content.Emphasis }
	}

	variants[BadgeVariant.Standard] = {
		container = { backgroundStyle = data.Color.ActionStandard.Background },
		content = { style = data.Color.ActionStandard.Foreground },
		icon = { style = data.Color.ActionStandard.Foreground }
	}

	variants[BadgeVariant.Neutral] = not Flags.FoundationBadgeBetaUpdate and {
		container = { backgroundStyle = data.Color.Shift.Shift_300 },
		content = { style = data.Color.Content.Emphasis },
		icon = { style = data.Color.ActionStandard.Foreground }
	} or nil

	local overMedia = BadgeVariant.OverMedia
	local backgroundStyle4

	if Flags.FoundationBadgeOverMediaAdaptive then
		backgroundStyle4 = data.Color.OverMedia.OverMedia_0
	else
		backgroundStyle4 = data.LightMode.Surface.Surface_100
	end

	local container = {
		backgroundStyle = backgroundStyle4,
		stroke = not Flags.FoundationBadgeOverMediaAdaptive and {
			Color = data.LightMode.Stroke.Default.Color3,
			Transparency = data.LightMode.Stroke.Default.Transparency
		} or nil
	}
	local style4

	if Flags.FoundationBadgeOverMediaAdaptive then
		style4 = data.Inverse.OverMedia.OverMedia_0
	else
		style4 = data.LightMode.Content.Emphasis
	end

	local style5

	if Flags.FoundationBadgeOverMediaAdaptive then
		style5 = data.Inverse.OverMedia.OverMedia_0
	else
		style5 = data.LightMode.Content.Emphasis
	end

	variants[overMedia] = {
		container = container,
		content = { style = style4 },
		icon = { style = style5 }
	}

	variants[BadgeVariant.OverMediaWhite] = {
		container = {
			backgroundStyle = data.LightMode.Surface.Surface_100,
			stroke = {
				Color = data.LightMode.Stroke.Default.Color3,
				Transparency = data.LightMode.Stroke.Default.Transparency
			}
		},
		content = { style = data.LightMode.Content.Emphasis },
		icon = { style = data.LightMode.Content.Emphasis }
	}

	variants[BadgeVariant.Emphasis] = {
		container = { backgroundStyle = data.Color.System.Emphasis },
		content = { style = data.DarkMode.Content.Emphasis },
		icon = { style = data.DarkMode.Content.Emphasis }
	}

	local iconOnly = not Flags.FoundationBadgeBetaUpdate and {
		[true] = {
			container = { tag = "size-600" }
		},
		[false] = {
			container = { tag = "size-0-600 auto-x padding-x-small" }
		}
	} or nil
	local sizes

	if Flags.FoundationBadgeBetaUpdate then
		sizes = {}
		sizes[BadgeSize.XSmall] = {
			container = { tag = "gap-xxsmall size-0-400 padding-x-xsmall" },
			text = { tag = "text-caption-small" },
			icon = { size = IconSize.XSmall }
		}

		sizes[BadgeSize.Small] = {
			container = { tag = "gap-xsmall size-0-600 padding-x-small" },
			text = { tag = "text-caption-medium" },
			icon = { size = IconSize.XSmall }
		}

		sizes[BadgeSize.Medium] = {
			container = { tag = "gap-xsmall size-0-600 padding-x-small" },
			text = { tag = "text-caption-medium" },
			icon = { size = IconSize.XSmall }
		}
	end

	local shapes = {
		[BadgeShape.Pill] = {
			container = { tag = "radius-circle" }
		},
		[BadgeShape.Box] = {
			container = { tag = "radius-small" }
		}
	}
	local iconPlacement

	if Flags.FoundationBadgeBetaUpdate then
		iconPlacement = {}
		iconPlacement[IconPosition.Left] = {
			text = { tag = "padding-right-xsmall" }
		}

		iconPlacement[IconPosition.Right] = {
			text = { tag = "padding-left-xsmall" }
		}

		iconPlacement[Dash.None] = {
			text = { tag = "padding-x-xsmall" }
		}
	end

	if Flags.FoundationBadgeBetaUpdate then
		iconOnly = nil
	end

	return {
		common = common,
		variants = variants,
		shapes = shapes,
		iconOnly = iconOnly,
		sizes = sizes,
		iconPlacement = iconPlacement
	}
end

return function(p, p2, p3, p4, p5, flag: boolean)
	local v = VariantsContext.useVariants("Badge", variantsFactory, p)

	local common = v.common
	local variant = v.variants[p2]
	local shape = v.shapes[p3]
	local v2

	if Flags.FoundationBadgeBetaUpdate then
		v2 = v.sizes[p4]
	end

	local v3

	if Flags.FoundationBadgeBetaUpdate then
		v3 = v.iconPlacement[p5 or Dash.None]
	end

	local v4

	if not Flags.FoundationBadgeBetaUpdate then
		v4 = v.iconOnly[flag]
	end

	return composeStyleVariant(common, variant, shape, v2, v3, v4)
end
