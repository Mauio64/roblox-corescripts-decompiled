local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)

require(Foundation.Components.Types)

local indexBindable = require(Foundation.Utility.indexBindable)

local function composeStroke(p, thickness: number?)
	if p and thickness then
		return {
			container = {
				stroke = {
					Color = indexBindable(p, "Color3"),
					Transparency = indexBindable(p, "Transparency"),
					Thickness = thickness
				}
			}
		}
	end

	return {}
end

local function variantsFactory(p)
	return {
		strokes = {
			[true] = {
				[AvatarIconSize.XSmall] = p.Stroke.Standard,
				[AvatarIconSize.Small] = p.Stroke.Standard,
				[AvatarIconSize.Medium] = p.Stroke.Thick,
				[AvatarIconSize.Large] = p.Stroke.Thicker,
				[AvatarIconSize.XLarge] = p.Stroke.Thicker
			},
			[false] = {}
		},
		common = {
			container = { tag = "radius-circle" },
			avatar = { tag = "size-full radius-circle" }
		},
		sizes = {
			[AvatarIconSize.XSmall] = {
				container = { size = p.Size.Size_300 }
			},
			[AvatarIconSize.Small] = {
				container = { size = p.Size.Size_400 }
			},
			[AvatarIconSize.Medium] = {
				container = { size = p.Size.Size_500 }
			},
			[AvatarIconSize.Large] = {
				container = { size = p.Size.Size_600 }
			},
			[AvatarIconSize.XLarge] = {
				container = { size = p.Size.Size_700 }
			}
		}
	}
end

return function(p, p2, p3)
	local v = VariantsContext.useVariants("AvatarIcon", variantsFactory, p)

	return composeStyleVariant(v.common, v.sizes[p2], composeStroke(p3, v.strokes[p3 ~= nil][p2]))
end
