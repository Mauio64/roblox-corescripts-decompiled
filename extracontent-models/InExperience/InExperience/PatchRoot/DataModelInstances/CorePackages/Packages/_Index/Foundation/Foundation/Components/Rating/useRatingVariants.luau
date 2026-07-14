local Foundation = script:FindFirstAncestor("Foundation")
local IconSize = require(Foundation.Enums.IconSize)
local ChipSize = require(Foundation.Enums.ChipSize)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local function variantsFactory(p1) -- line: 40
	-- upvalues: ChipSize (copy), IconSize (copy)
	local t1 = {
		container = {
			tag = "row align-y-center auto-xy radius-circle clip",
			backgroundStyle = p1.Color.ActionStandard.Background
		},
		thumbUpSegment = {
			tag = "row align-x-center align-y-center shrink-1 auto-x radius-circle"
		},
		thumbDownSegment = {
			tag = "row align-x-center align-y-center auto-x radius-circle"
		},
		text = {
			contentStyle = p1.Color.ActionStandard.Foreground
		}
	}
	local t2 = {
		[ChipSize.Small] = {
			thumbSegment = {
				tag = "size-0-600"
			},
			dividerContainer = {
				tag = "align-y-center size-0-600 auto-x padding-y-xsmall"
			},
			thumbUpIcon = {
				tag = "auto-xy padding-left-small padding-right-xsmall"
			},
			thumbDownIcon = {
				tag = "auto-xy padding-left-small padding-right-medium"
			},
			text = {
				tag = "shrink size-0-full auto-x text-label-small text-truncate-end padding-right-small"
			},
			iconSize = IconSize.XSmall
		},
		[ChipSize.Medium] = {
			thumbSegment = {
				tag = "size-0-800"
			},
			dividerContainer = {
				tag = "align-y-center size-0-800 auto-x padding-y-small"
			},
			thumbUpIcon = {
				tag = "auto-xy padding-left-medium padding-right-xsmall"
			},
			thumbDownIcon = {
				tag = "auto-xy padding-left-medium padding-right-medium"
			},
			text = {
				tag = "shrink size-0-full auto-x text-label-medium text-truncate-end padding-right-medium"
			},
			iconSize = IconSize.Small
		},
		[ChipSize.Large] = {
			thumbSegment = {
				tag = "size-0-1000"
			},
			dividerContainer = {
				tag = "align-y-center size-0-1000 auto-x padding-y-small"
			},
			thumbUpIcon = {
				tag = "auto-xy padding-left-medium padding-right-small"
			},
			thumbDownIcon = {
				tag = "auto-xy padding-left-medium padding-right-medium"
			},
			text = {
				tag = "shrink size-0-full auto-x text-label-medium text-truncate-end padding-right-large"
			},
			iconSize = IconSize.Medium
		}
	}

	return {
		common = t1,
		sizes = t2
	}
end

return function(p2, p3) -- line: 90
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v12 = VariantsContext.useVariants("Rating", variantsFactory, p2)
	local v13 = v12.sizes[p3]
	local v14 = composeStyleVariant(v12.common, {
		thumbUpSegment = v13.thumbSegment,
		thumbDownSegment = v13.thumbSegment,
		text = v13.text
	})

	return {
		container = v14.container,
		thumbUpSegment = v14.thumbUpSegment,
		thumbDownSegment = v14.thumbDownSegment,
		dividerContainer = v13.dividerContainer,
		thumbUpIcon = v13.thumbUpIcon,
		thumbDownIcon = v13.thumbDownIcon,
		text = {
			tag = v14.text.tag,
			contentStyle = v14.text.contentStyle
		},
		iconSize = v13.iconSize
	}
end
