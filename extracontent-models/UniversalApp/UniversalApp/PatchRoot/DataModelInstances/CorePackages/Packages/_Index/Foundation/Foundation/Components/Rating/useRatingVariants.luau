local Foundation = script:FindFirstAncestor("Foundation")

local IconSize = require(Foundation.Enums.IconSize)

local ChipSize = require(Foundation.Enums.ChipSize)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p)
	return {
		common = {
			container = {
				tag = "row align-y-center auto-xy radius-circle clip",
				backgroundStyle = p.Color.ActionStandard.Background
			},
			thumbUpSegment = {
				tag = "row align-x-center align-y-center shrink-1 auto-x radius-circle"
			},
			thumbDownSegment = { tag = "row align-x-center align-y-center auto-x radius-circle" },
			text = { contentStyle = p.Color.ActionStandard.Foreground }
		},
		sizes = {
			[ChipSize.Small] = {
				thumbSegment = { tag = "size-0-600" },
				dividerContainer = { tag = "align-y-center size-0-600 auto-x padding-y-xsmall" },
				thumbUpIcon = { tag = "auto-xy padding-left-small padding-right-xsmall" },
				thumbDownIcon = { tag = "auto-xy padding-left-small padding-right-medium" },
				text = {
					tag = "shrink size-0-full auto-x text-label-small text-truncate-end padding-right-small"
				},
				iconSize = IconSize.XSmall
			},
			[ChipSize.Medium] = {
				thumbSegment = { tag = "size-0-800" },
				dividerContainer = { tag = "align-y-center size-0-800 auto-x padding-y-small" },
				thumbUpIcon = { tag = "auto-xy padding-left-medium padding-right-xsmall" },
				thumbDownIcon = { tag = "auto-xy padding-left-medium padding-right-medium" },
				text = {
					tag = "shrink size-0-full auto-x text-label-medium text-truncate-end padding-right-medium"
				},
				iconSize = IconSize.Small
			},
			[ChipSize.Large] = {
				thumbSegment = { tag = "size-0-1000" },
				dividerContainer = { tag = "align-y-center size-0-1000 auto-x padding-y-small" },
				thumbUpIcon = { tag = "auto-xy padding-left-medium padding-right-small" },
				thumbDownIcon = { tag = "auto-xy padding-left-medium padding-right-medium" },
				text = {
					tag = "shrink size-0-full auto-x text-label-medium text-truncate-end padding-right-large"
				},
				iconSize = IconSize.Medium
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("Rating", variantsFactory, p)

	local siz = v.sizes[p2]

	local v2 = composeStyleVariant(v.common, {
		thumbUpSegment = siz.thumbSegment,
		thumbDownSegment = siz.thumbSegment,
		text = siz.text
	})

	return {
		container = v2.container,
		thumbUpSegment = v2.thumbUpSegment,
		thumbDownSegment = v2.thumbDownSegment,
		dividerContainer = siz.dividerContainer,
		thumbUpIcon = siz.thumbUpIcon,
		thumbDownIcon = siz.thumbDownIcon,
		text = { tag = v2.text.tag, contentStyle = v2.text.contentStyle },
		iconSize = siz.iconSize
	}
end
