local Foundation = script:FindFirstAncestor("Foundation")
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local InputSize = require(Foundation.Enums.InputSize)
local UserPresence = require(Foundation.Enums.UserPresence)
local IndicatorVariant = require(Foundation.Enums.IndicatorVariant)
local IndicatorShape = require(Foundation.Enums.IndicatorShape)

require(Foundation.Components.Types)

local indexBindable = require(Foundation.Utility.indexBindable)

local function variantsFactory(p1) -- line: 45
	-- upvalues: InputSize (copy), UserPresence (copy), IndicatorShape (copy), IndicatorVariant (copy)
	local t1 = {
		container = {
			tag = "radius-circle"
		},
		avatar = {
			tag = "size-full radius-circle"
		},
		indicatorBackplate = {
			ZIndex = 2,
			tag = "position-bottom-right anchor-bottom-right auto-xy radius-circle bg-surface-0",
			padding = UDim2.fromOffset(3, 3)
		}
	}
	local t2 = {
		[InputSize.XSmall] = {
			indicator = {
				size = p1.Size.Size_150
			}
		},
		[InputSize.Small] = {
			indicator = {
				size = p1.Size.Size_150
			}
		},
		[InputSize.Medium] = {
			indicator = {
				size = p1.Size.Size_200
			}
		},
		[InputSize.Large] = {
			indicator = {
				size = p1.Size.Size_200
			}
		}
	}
	local t3 = {
		[UserPresence.InExperience] = {},
		[UserPresence.Away] = {
			indicator = {
				shape = IndicatorShape.Ring,
				variant = IndicatorVariant.Neutral
			}
		},
		[UserPresence.Active] = {
			indicator = {
				shape = IndicatorShape.Circle,
				variant = IndicatorVariant.Success
			}
		},
		[UserPresence.None] = {}
	}
	local t4 = {
		[InputSize.XSmall] = p1.Stroke.Standard,
		[InputSize.Small] = p1.Stroke.Thick,
		[InputSize.Medium] = p1.Stroke.Thick,
		[InputSize.Large] = p1.Stroke.Thicker
	}

	return {
		common = t1,
		sizes = t2,
		presence = t3,
		iconSizeStrokes = t4
	}
end

return function(p2, p3, p4, p5, b1: boolean) -- line: 85
	-- upvalues: VariantsContext (copy), variantsFactory (copy), UserPresence (copy), composeStyleVariant (copy), indexBindable (copy)
	local v20 = VariantsContext.useVariants("Avatar", variantsFactory, p2)
	local v21 = not b1 and (p4 == UserPresence.Active or p4 == UserPresence.Away)
	local v22 = if b1 or p4 ~= UserPresence.InExperience then p5 else p2.Color.System.Emphasis
	local v23 = if b1 then v20.iconSizeStrokes[p3] else p2.Stroke.Thicker

	return composeStyleVariant(v20.common, v20.sizes[p3], v20.presence[p4], {
		container = {
			stroke = if not v22 then nil else {
				Color = indexBindable(v22, "Color3"),
				Transparency = indexBindable(v22, "Transparency"),
				Thickness = v23
			},
			backgroundStyle = p5
		},
		indicator = {
			isVisible = v21
		}
	})
end
