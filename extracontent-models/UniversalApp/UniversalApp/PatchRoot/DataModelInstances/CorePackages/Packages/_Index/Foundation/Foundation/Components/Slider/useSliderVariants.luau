local Foundation = script:FindFirstAncestor("Foundation")
local InputSize = require(Foundation.Enums.InputSize)
local SliderVariant = require(Foundation.Enums.SliderVariant)
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

require(Foundation.Components.Types)

local function variantsFactory(p1) -- line: 38
	-- upvalues: SliderVariant (copy), InputSize (copy)
	local t1 = {
		bar = {
			tag = "position-center-center anchor-center-center size-full-100 radius-small"
		},
		fill = {
			tag = "radius-small"
		}
	}
	local t2 = {
		[SliderVariant.Emphasis] = {
			bar = {
				tag = "bg-shift-400"
			},
			fill = {
				tag = "bg-emphasis"
			},
			knob = {
				hasShadow = true,
				style = p1.Color.Extended.White.White_100,
				dragStyle = p1.Color.ActionEmphasis.Background
			}
		},
		[SliderVariant.Standard] = {
			bar = {
				tag = "bg-shift-400"
			},
			fill = {
				tag = "bg-system-contrast"
			},
			knob = {
				hasShadow = false,
				style = p1.Color.System.Contrast,
				dragStyle = p1.Color.System.Contrast
			}
		},
		[SliderVariant.Utility] = {
			knob = {
				hasShadow = true,
				style = p1.Color.None,
				dragStyle = p1.Color.None,
				stroke = {
					Color = p1.Color.System.Contrast.Color3,
					Transparency = p1.Color.System.Contrast.Transparency,
					Thickness = p1.Stroke.Thicker
				}
			}
		}
	}
	local t3 = {
		[InputSize.XSmall] = {
			hitbox = {
				height = p1.Size.Size_300
			}
		},
		[InputSize.Small] = {
			hitbox = {
				height = p1.Size.Size_400
			}
		},
		[InputSize.Medium] = {
			hitbox = {
				height = p1.Size.Size_500
			}
		},
		[InputSize.Large] = {
			hitbox = {
				height = p1.Size.Size_700
			}
		}
	}

	return {
		common = t1,
		variants = t2,
		sizes = t3
	}
end

return function(p2, p3, p4) -- line: 91
	-- upvalues: VariantsContext (copy), variantsFactory (copy), composeStyleVariant (copy)
	local v14 = VariantsContext.useVariants("Slider", variantsFactory, p2)

	return composeStyleVariant(v14.common, v14.variants[p4], v14.sizes[p3])
end
