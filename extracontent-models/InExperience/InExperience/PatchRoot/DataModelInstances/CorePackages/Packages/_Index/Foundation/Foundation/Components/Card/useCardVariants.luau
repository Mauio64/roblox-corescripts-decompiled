local Foundation = script:FindFirstAncestor("Foundation")

local CardDensity = require(Foundation.Enums.CardDensity)
local CardHeaderSize = require(Foundation.Enums.CardHeaderSize)
local CardHeight = require(Foundation.Enums.CardHeight)
local CardVariant = require(Foundation.Enums.CardVariant)
local IconSize = require(Foundation.Enums.IconSize)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	local densities = {
		[CardDensity.Compact] = {
			container = { tag = "radius-medium" },
			content = { tag = "padding-medium" },
			actionsPadding = { tag = "padding-medium" },
			mediaEnd = { tag = "radius-right-medium" },
			mediaBottom = { tag = "radius-bottom-medium" }
		},
		[CardDensity.Default] = {
			container = { tag = "radius-large" },
			content = { tag = "padding-large" },
			actionsPadding = { tag = "padding-large" },
			mediaEnd = { tag = "radius-right-large" },
			mediaBottom = { tag = "radius-bottom-large" }
		},
		[CardDensity.Comfortable] = {
			container = { tag = "radius-large" },
			content = { tag = "padding-xlarge" },
			actionsPadding = { tag = "padding-xlarge" },
			mediaEnd = { tag = "radius-right-large" },
			mediaBottom = { tag = "radius-bottom-large" }
		}
	}

	local lineHeight = p.Typography.BodySmall.FontSize * p.Typography.BodySmall.LineHeight
	local lineHeight2 = p.Typography.BodyMedium.FontSize * p.Typography.BodyMedium.LineHeight
	return {
		common = {
			container = { tag = "clip" },
			content = { tag = "col auto-y" },
			children = { tag = "col gap-large size-full-0 auto-y" },
			header = { tag = "row gap-small size-full-0 auto-y" },
			headerText = { tag = "col fill auto-y" },
			eyebrow = { tag = "size-full-0 auto-y text-wrap text-align-x-left content-default" },
			titleRow = { tag = "row align-y-center size-full-0 auto-y padding-y-xxsmall" },
			title = { tag = "shrink auto-xy text-wrap text-align-x-left content-emphasis" },
			description = {
				tag = "size-full-0 auto-y padding-bottom-xxsmall text-wrap text-align-x-left content-default"
			},
			actions = { tag = "row gap-small auto-xy" }
		},
		densities = densities,
		headerSizes = {
			[CardHeaderSize.XXSmall] = {
				content = { tag = "gap-medium" },
				eyebrow = { tag = "text-body-small" },
				description = { tag = "text-body-small", lineHeight = lineHeight },
				title = { tag = "text-title-medium" },
				titleRow = { tag = "gap-xsmall" },
				icon = { size = IconSize.Medium }
			},
			[CardHeaderSize.XSmall] = {
				content = { tag = "gap-medium" },
				eyebrow = { tag = "text-body-small" },
				description = { tag = "text-body-small", lineHeight = lineHeight },
				title = { tag = "text-title-large" },
				titleRow = { tag = "gap-xsmall" },
				icon = { size = IconSize.Medium }
			},
			[CardHeaderSize.Small] = {
				content = { tag = "gap-medium" },
				eyebrow = { tag = "text-body-medium" },
				description = { tag = "text-body-medium", lineHeight = lineHeight2 },
				title = { tag = "text-heading-small" },
				titleRow = { gap = p.Size.Size_150 },
				icon = { size = IconSize.Large }
			},
			[CardHeaderSize.Medium] = {
				content = { tag = "gap-large" },
				eyebrow = { tag = "text-body-medium" },
				description = { tag = "text-body-medium", lineHeight = lineHeight2 },
				title = { tag = "text-heading-medium" },
				titleRow = { tag = "gap-small" },
				icon = { size = IconSize.Large }
			},
			[CardHeaderSize.Large] = {
				content = { tag = "gap-large" },
				eyebrow = { tag = "text-body-medium" },
				description = { tag = "text-body-medium", lineHeight = lineHeight2 },
				title = { tag = "text-heading-large" },
				titleRow = { tag = "gap-small" },
				icon = { size = IconSize.Large }
			}
		},
		variants = {
			[CardVariant.Standard] = {
				container = { tag = "stroke-standard stroke-default" }
			},
			[CardVariant.Emphasis] = {
				container = { tag = "bg-shift-200" }
			}
		},
		heights = {
			[CardHeight.Fit] = {
				container = { tag = "size-full-0 auto-y" },
				body = { tag = "size-full-0 auto-y" }
			},
			[CardHeight.Fill] = {
				container = { tag = "fill self-stretch size-full-0" },
				body = { tag = "size-full" }
			}
		},
		endMedia = {
			[true] = {
				body = { tag = "row" },
				content = { tag = "fill" }
			},
			[false] = {
				body = { tag = "col" },
				content = { tag = "size-full-0" }
			}
		},
		singleLine = {
			[true] = {
				header = { tag = "align-y-center" }
			},
			[false] = {
				header = { tag = "align-y-top" }
			}
		}
	}
end

local function useCardVariants(p, p2, p3, p4, p5, flag: boolean, flag2: boolean, flag3: boolean)
	local v = VariantsContext.useVariants("Card", variantsFactory, p)
	local density = v.densities[p3]
	local v2 = composeStyleVariant(
		v.common,
		density,
		v.headerSizes[p4],
		v.variants[p2],
		v.heights[p5],
		v.endMedia[flag],
		v.singleLine[flag2]
	)

	if not flag3 then
		v2 = composeStyleVariant(v2, { actions = density.actionsPadding })
	end

	local media = if flag then density.mediaEnd else density.mediaBottom
	v2.media = media

	return v2
end

return useCardVariants
