local Foundation = script:FindFirstAncestor("Foundation")

local IconSize = require(Foundation.Enums.IconSize)

local InputSize = require(Foundation.Enums.InputSize)

local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

require(Foundation.Providers.Style.Tokens)

local function variantsFactory(p)
	return {
		common = {
			container = { tag = "row align-y-center auto-xy padding-y-xsmall" },
			item = { tag = "row align-y-center gap-small auto-x" },
			itemText = { tag = "row align-y-center gap-xsmall auto-xy" },
			separator = { tag = "row align-x-center align-y-center size-600-0 auto-y" },
			current = { tag = "content-emphasis" },
			label = { tag = "content-emphasis" },
			accessory = { style = p.Color.Content.Emphasis }
		},
		sizes = {
			[InputSize.XSmall] = {
				separator = { textTag = "auto-xy text-body-small content-default" },
				current = { tag = "auto-xy text-title-small" },
				label = { tag = "auto-xy text-body-small" },
				accessory = {
					iconSize = IconSize.XSmall,
					avatarSize = AvatarIconSize.Small,
					tag = "size-400-400 radius-small"
				},
				item = { tag = "size-0-600" },
				overflow = { size = InputSize.XSmall }
			},
			[InputSize.Small] = {
				separator = { textTag = "auto-xy text-body-small content-default" },
				current = { tag = "auto-xy text-title-small" },
				label = { tag = "auto-xy text-body-small" },
				accessory = {
					iconSize = IconSize.XSmall,
					avatarSize = AvatarIconSize.Small,
					tag = "size-400-400 radius-small"
				},
				item = { tag = "size-0-600" },
				overflow = { size = InputSize.XSmall }
			},
			[InputSize.Medium] = {
				separator = { textTag = "auto-xy text-body-medium content-default" },
				current = { tag = "auto-xy text-title-medium" },
				label = { tag = "auto-xy text-body-medium" },
				accessory = {
					iconSize = IconSize.Small,
					avatarSize = AvatarIconSize.Medium,
					tag = "size-500-500 radius-small"
				},
				item = { tag = "size-0-600" },
				overflow = { size = InputSize.XSmall }
			},
			[InputSize.Large] = {
				separator = { textTag = "auto-xy text-body-large content-default" },
				current = { tag = "auto-xy text-title-large" },
				label = { tag = "auto-xy text-body-large" },
				accessory = {
					iconSize = IconSize.Medium,
					avatarSize = AvatarIconSize.Large,
					tag = "size-600-600 radius-medium"
				},
				item = { tag = "size-0-800" },
				overflow = { size = InputSize.Small }
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("Breadcrumb", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2])
end
