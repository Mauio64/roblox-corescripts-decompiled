local Foundation = script:FindFirstAncestor("Foundation")

local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)

local IconSize = require(Foundation.Enums.IconSize)

local MetadataSize = require(Foundation.Enums.MetadataSize)

require(Foundation.Components.Types)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

require(Foundation.Providers.Style.Tokens)

local function variantsFactory(data)
	return {
		common = {
			container = { tag = "row align-y-center auto-xy" },
			item = { tag = "row align-y-center gap-xsmall auto-xy", gap = data.Gap.XSmall },
			truncatedItem = { tag = "row align-y-center shrink gap-xsmall auto-xy" },
			text = { tag = "auto-xy content-default", openTypeFeatures = "zero, ss03" },
			truncatedText = { tag = "shrink auto-xy text-truncate-split content-default" },
			wrappedText = {
				tag = "shrink auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split content-default"
			},
			accessory = {
				iconSize = IconSize.Small,
				avatarSize = AvatarIconSize.Small,
				avatarTag = "auto-xy padding-right-xxsmall",
				style = data.Color.Content.Default,
				width = data.Size.Size_400,
				avatarWidth = data.Size.Size_400 + data.Padding.XXSmall
			}
		},
		sizes = {
			[MetadataSize.Medium] = {
				text = { tag = "text-body-medium", fontStyle = data.Typography.BodyMedium },
				truncatedText = { tag = "text-body-medium" },
				wrappedText = { tag = "text-body-medium" }
			},
			[MetadataSize.Small] = {
				text = { tag = "text-body-small", fontStyle = data.Typography.BodySmall },
				truncatedText = { tag = "text-body-small" },
				wrappedText = { tag = "text-body-small" }
			}
		},
		spacing = {
			[true] = {
				container = { tag = "gap-small" }
			},
			[false] = {
				container = { tag = "gap-xsmall" }
			}
		}
	}
end

return function(p, p2, flag: boolean)
	local v = VariantsContext.useVariants("Metadata", variantsFactory, p)
	return composeStyleVariant(v.common, v.sizes[p2], v.spacing[flag])
end
