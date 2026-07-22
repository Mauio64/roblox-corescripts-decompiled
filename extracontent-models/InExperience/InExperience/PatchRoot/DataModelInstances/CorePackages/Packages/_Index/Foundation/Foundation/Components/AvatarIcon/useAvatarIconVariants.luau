local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local AvatarIconSize = require(Foundation.Enums.AvatarIconSize)

require(Foundation.Components.Types)

local indexBindable = require(Foundation.Utility.indexBindable)

local function composeStroke(p1, n1: number?) -- line: 18
	-- upvalues: indexBindable (copy)
	if not p1 or not n1 then
		return {}
	end

	return {
		container = {
			stroke = {
				Color = indexBindable(p1, "Color3"),
				Transparency = indexBindable(p1, "Transparency"),
				Thickness = n1
			}
		}
	}
end
local function variantsFactory(p2) -- line: 34
	-- upvalues: AvatarIconSize (copy)
	local t1 = {
		container = {
			tag = "radius-circle"
		},
		avatar = {
			tag = "size-full radius-circle"
		}
	}
	local t2 = {
		[true] = {
			[AvatarIconSize.XSmall] = p2.Stroke.Standard,
			[AvatarIconSize.Small] = p2.Stroke.Standard,
			[AvatarIconSize.Medium] = p2.Stroke.Thick,
			[AvatarIconSize.Large] = p2.Stroke.Thicker,
			[AvatarIconSize.XLarge] = p2.Stroke.Thicker
		},
		[false] = {}
	}
	local t3 = {
		[AvatarIconSize.XSmall] = {
			container = {
				size = p2.Size.Size_300
			}
		},
		[AvatarIconSize.Small] = {
			container = {
				size = p2.Size.Size_400
			}
		},
		[AvatarIconSize.Medium] = {
			container = {
				size = p2.Size.Size_500
			}
		},
		[AvatarIconSize.Large] = {
			container = {
				size = p2.Size.Size_600
			}
		},
		[AvatarIconSize.XLarge] = {
			container = {
				size = p2.Size.Size_700
			}
		}
	}

	return {
		strokes = t2,
		common = t1,
		sizes = t3
	}
end

return function(p3, p4, p5) -- line: 66
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy), composeStroke (copy)
	local v17 = VariantsContext.useVariants("AvatarIcon", variantsFactory, p3)

	return composeStyleVariant(v17.common, v17.sizes[p4], (composeStroke(p5, v17.strokes[p5 ~= nil][p4])))
end
