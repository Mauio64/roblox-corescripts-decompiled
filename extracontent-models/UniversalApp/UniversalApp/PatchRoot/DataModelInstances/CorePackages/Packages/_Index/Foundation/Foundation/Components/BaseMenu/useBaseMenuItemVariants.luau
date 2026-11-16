local Foundation = script:FindFirstAncestor("Foundation")

local InputSize = require(Foundation.Enums.InputSize)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)

local IconSize = require(Foundation.Enums.IconSize)

local function variantsMap(data)
	return {
		common = {
			container = { tag = "" },
			icon = { tag = "radius-small content-emphasis", style = data.Color.Content.Emphasis },
			text = { tag = "fill auto-xy text-align-x-left text-truncate-end content-emphasis" },
			title = { tag = "fill auto-xy text-align-x-left text-truncate-end content-default" },
			check = { tag = "content-emphasis", style = data.Color.Content.Emphasis },
			slotAlign = { tag = "align-x-center align-y-center" },
			submenuContent = { tag = "stroke-standard stroke-default radius-medium" }
		},
		sizes = {
			[InputSize.XSmall] = {
				container = {
					tag = "size-full-600 radius-small",
					paddingLeftWithCheck = 0,
					paddingLeftWithoutCheck = data.Padding.Small,
					paddingRight = data.Padding.Small
				},
				wrapper = { gap = data.Size.Size_150 },
				icon = { tag = "size-400", size = IconSize.XSmall },
				text = { tag = "text-body-small" },
				title = { tag = "text-caption-small", checkColumnWidth = data.Size.Size_500 },
				check = { tag = "size-500-400", size = data.Size.Size_400 },
				chevron = { size = IconSize.Small },
				groupPadding = { size = data.Padding.XSmall }
			},
			[InputSize.Small] = {
				container = {
					tag = "size-full-800 radius-small",
					paddingLeftWithCheck = 0,
					paddingLeftWithoutCheck = data.Padding.Small,
					paddingRight = data.Padding.Small
				},
				wrapper = { gap = data.Size.Size_150 },
				icon = { tag = "size-500", size = IconSize.Small },
				text = { tag = "text-body-small" },
				title = { tag = "text-caption-small", checkColumnWidth = data.Size.Size_600 },
				check = { tag = "size-600-400", size = data.Size.Size_400 },
				chevron = { size = IconSize.Small },
				groupPadding = { size = data.Padding.Small }
			},
			[InputSize.Medium] = {
				container = {
					tag = "size-full-1000 radius-medium",
					paddingLeftWithCheck = 0,
					paddingLeftWithoutCheck = data.Size.Size_250,
					paddingRight = data.Size.Size_250
				},
				wrapper = { gap = data.Size.Size_150 },
				icon = { tag = "size-500", size = IconSize.Medium },
				text = { tag = "text-body-medium" },
				title = { tag = "text-caption-medium", checkColumnWidth = data.Size.Size_700 },
				check = { tag = "size-700-500", size = data.Size.Size_500 },
				chevron = { size = IconSize.Medium },
				groupPadding = { size = data.Padding.Small }
			},
			[InputSize.Large] = {
				container = {
					tag = "size-full-1200 radius-medium",
					paddingLeftWithCheck = 0,
					paddingLeftWithoutCheck = data.Size.Size_350,
					paddingRight = data.Size.Size_350
				},
				wrapper = { gap = data.Padding.Small },
				icon = { tag = "size-600", size = IconSize.Large },
				text = { tag = "text-body-large" },
				title = { tag = "text-caption-large", checkColumnWidth = data.Size.Size_800 },
				check = { tag = "size-800-600", size = data.Size.Size_600 },
				chevron = { size = IconSize.Large },
				groupPadding = { size = data.Padding.Small }
			}
		},
		isScrollable = {
			[false] = {
				submenuContent = { tag = "col auto-xy" }
			},
			[true] = {
				submenuContent = { tag = "" }
			}
		},
		defaultSize = {
			container = { tag = "auto-x" }
		}
	}
end

return function(p, p2, flag: boolean)
	local v = VariantsContext.useVariants("BaseMenuItem", variantsMap, p)

	return composeStyleVariant(v.common, v.sizes[p2], v.defaultSize, v.isScrollable[flag])
end
