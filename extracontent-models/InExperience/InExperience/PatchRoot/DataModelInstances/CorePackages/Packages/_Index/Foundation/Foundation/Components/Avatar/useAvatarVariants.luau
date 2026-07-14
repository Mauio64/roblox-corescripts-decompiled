local Foundation = script:FindFirstAncestor("Foundation")
local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)
local Flags = require(Foundation.Utility.Flags)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local AvatarSize = require(Foundation.Enums.AvatarSize)
local UserPresence = require(Foundation.Enums.UserPresence)
local IndicatorVariant = require(Foundation.Enums.IndicatorVariant)
local IndicatorShape = require(Foundation.Enums.IndicatorShape)
local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)
local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)
local StatusIndicatorShape = require(Foundation.Enums.StatusIndicatorShape)

require(Foundation.Components.Types)

local indexBindable = require(Foundation.Utility.indexBindable)

local function variantsFactory(p1) -- line: 68
	-- upvalues: Flags (copy), AvatarSize (copy), StatusIndicatorSize (copy), UserPresence (copy), StatusIndicatorShape (copy), StatusIndicatorVariant (copy), IndicatorShape (copy), IndicatorVariant (copy)
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
		},
		statusIndicatorBackplate = {
			ZIndex = 2,
			tag = "auto-xy radius-circle bg-surface-0",
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.fromScale(1, 1),
			padding = UDim2.fromOffset(p1.Size.Size_150 / 2, p1.Size.Size_150 / 2)
		}
	}
	local v16 = if not Flags.FoundationAvatarBeta then {
		[AvatarSize.XSmall] = {
			indicator = {
				size = p1.Size.Size_150
			}
		},
		[AvatarSize.Small] = {
			indicator = {
				size = p1.Size.Size_150
			}
		},
		[AvatarSize.Medium] = {
			indicator = {
				size = p1.Size.Size_200
			}
		},
		[AvatarSize.Large] = {
			indicator = {
				size = p1.Size.Size_200
			}
		},
		[AvatarSize.XLarge] = {
			indicator = {
				size = p1.Size.Size_250
			}
		},
		[AvatarSize.Pictogram] = {
			indicator = {
				size = p1.Size.Size_500
			}
		}
	} else {
		[AvatarSize.XSmall] = {
			statusIndicator = {
				size = StatusIndicatorSize.XSmall
			}
		},
		[AvatarSize.Small] = {
			statusIndicator = {
				size = StatusIndicatorSize.XSmall
			}
		},
		[AvatarSize.Medium] = {
			statusIndicator = {
				size = StatusIndicatorSize.Small
			}
		},
		[AvatarSize.Large] = {
			statusIndicator = {
				size = StatusIndicatorSize.Small
			}
		},
		[AvatarSize.XLarge] = {
			statusIndicator = {
				size = StatusIndicatorSize.Medium
			}
		},
		[AvatarSize.Pictogram] = {
			statusIndicator = {
				size = StatusIndicatorSize.Pictogram
			}
		}
	}
	local t2 = {
		[UserPresence.InExperience] = {},
		[UserPresence.Away] = if not Flags.FoundationAvatarBeta then {
			indicator = {
				shape = IndicatorShape.Ring,
				variant = IndicatorVariant.Neutral
			}
		} else {
			statusIndicator = {
				shape = StatusIndicatorShape.Ring,
				variant = StatusIndicatorVariant.Neutral
			}
		},
		[UserPresence.Active] = if not Flags.FoundationAvatarBeta then {
			indicator = {
				shape = IndicatorShape.Circle,
				variant = IndicatorVariant.Success
			}
		} else {
			statusIndicator = {
				shape = StatusIndicatorShape.Circle,
				variant = StatusIndicatorVariant.Success
			}
		},
		[UserPresence.None] = {}
	}
	local v18 = if not Flags.FoundationAvatarBeta then nil else {
		[AvatarSize.Small] = p1.Stroke.Thicker,
		[AvatarSize.Medium] = p1.Stroke.Thicker,
		[AvatarSize.Large] = p1.Stroke.Thicker,
		[AvatarSize.XLarge] = p1.Stroke.Thicker,
		[AvatarSize.Pictogram] = p1.Stroke.Thicker + p1.Stroke.Standard
	}
	local t3 = {
		[AvatarSize.XSmall] = p1.Stroke.Standard,
		[AvatarSize.Small] = p1.Stroke.Thick,
		[AvatarSize.Medium] = p1.Stroke.Thick,
		[AvatarSize.Large] = p1.Stroke.Thicker,
		[AvatarSize.XLarge] = p1.Stroke.Thicker,
		[AvatarSize.Pictogram] = p1.Stroke.Thicker
	}

	return {
		common = t1,
		sizes = v16,
		presence = t2,
		iconSizeStrokes = t3,
		sizeStrokes = if not Flags.FoundationAvatarBeta then nil else v18
	}
end

return function(p2, p3, p4, p5, b1: boolean) -- line: 152
	-- upvalues: VariantsContext (copy), variantsFactory (copy), UserPresence (copy), Flags (copy), composeStyleVariant (copy), indexBindable (copy)
	local v25 = VariantsContext.useVariants("Avatar", variantsFactory, p2)
	local v26 = not b1 and (p4 == UserPresence.Active or p4 == UserPresence.Away)
	local v27 = if b1 or p4 ~= UserPresence.InExperience then p5 else p2.Color.System.Emphasis
	local v28 = if not Flags.FoundationAvatarBeta then if b1 then v25.iconSizeStrokes[p3] else p2.Stroke.Thicker else if not b1 then v25.sizeStrokes[p3] else v25.iconSizeStrokes[p3]

	return composeStyleVariant(v25.common, v25.sizes[p3], v25.presence[p4], {
		container = {
			stroke = if not v27 then nil else {
				Color = indexBindable(v27, "Color3"),
				Transparency = indexBindable(v27, "Transparency"),
				Thickness = v28
			},
			backgroundStyle = p5
		},
		indicator = if not Flags.FoundationAvatarBeta then {
			isVisible = v26
		} else nil,
		statusIndicator = if not Flags.FoundationAvatarBeta then nil else {
			isVisible = v26
		}
	})
end
