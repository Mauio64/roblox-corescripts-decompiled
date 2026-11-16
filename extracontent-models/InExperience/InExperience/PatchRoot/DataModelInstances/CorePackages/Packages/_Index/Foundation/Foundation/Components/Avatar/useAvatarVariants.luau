local Foundation = script:FindFirstAncestor("Foundation")

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local Flags = require(Foundation.Utility.Flags)
require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

local AvatarSize = require(Foundation.Enums.AvatarSize)

local UserPresence = require(Foundation.Enums.UserPresence)

local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)

local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)

local StatusIndicatorShape = require(Foundation.Enums.StatusIndicatorShape)

require(Foundation.Components.Types)

local indexBindable = require(Foundation.Utility.indexBindable)

local function variantsFactory(data)
	local common = {
		container = { tag = "radius-circle" },
		avatar = { tag = "size-full radius-circle" },
		statusIndicatorMask = {
			ZIndex = 2,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -data.Size.Size_150 / 2, 1, -data.Size.Size_150 / 2),
			mask = data.Color.Surface.Surface_0
		}
	}

	local sizes = {
		[AvatarSize.XSmall] = {
			statusIndicator = { size = StatusIndicatorSize.XSmall }
		},
		[AvatarSize.Small] = {
			statusIndicator = { size = StatusIndicatorSize.XSmall }
		},
		[AvatarSize.Medium] = {
			statusIndicator = { size = StatusIndicatorSize.Small }
		},
		[AvatarSize.Large] = {
			statusIndicator = { size = StatusIndicatorSize.Small }
		},
		[AvatarSize.XLarge] = {
			statusIndicator = { size = StatusIndicatorSize.Medium }
		}
	}
	local pictogram = AvatarSize.Pictogram
	local size

	if Flags.FoundationStatusIndicatorDesignUpdate then
		size = StatusIndicatorSize.Large
	else
		size = StatusIndicatorSize.Pictogram
	end

	sizes[pictogram] = {
		statusIndicator = { size = size }
	}

	local presence = {
		[UserPresence.InExperience] = {},
		[UserPresence.Away] = {
			statusIndicator = {
				shape = StatusIndicatorShape.Ring,
				variant = StatusIndicatorVariant.Neutral
			}
		},
		[UserPresence.Active] = {
			statusIndicator = {
				shape = StatusIndicatorShape.Circle,
				variant = StatusIndicatorVariant.Success
			}
		},
		[UserPresence.None] = {}
	}

	local sizeStrokes = {
		[AvatarSize.Small] = data.Stroke.Thicker,
		[AvatarSize.Medium] = data.Stroke.Thicker,
		[AvatarSize.Large] = data.Stroke.Thicker,
		[AvatarSize.XLarge] = data.Stroke.Thicker,
		[AvatarSize.Pictogram] = data.Stroke.Thicker + data.Stroke.Standard
	}

	return {
		common = common,
		sizes = sizes,
		presence = presence,
		iconSizeStrokes = {
			[AvatarSize.XSmall] = data.Stroke.Standard,
			[AvatarSize.Small] = data.Stroke.Thick,
			[AvatarSize.Medium] = data.Stroke.Thick,
			[AvatarSize.Large] = data.Stroke.Thicker,
			[AvatarSize.XLarge] = data.Stroke.Thicker,
			[AvatarSize.Pictogram] = data.Stroke.Thicker
		},
		sizeStrokes = sizeStrokes
	}
end

return function(p, p2, p3, backgroundStyle, flag: boolean)
	local v = VariantsContext.useVariants("Avatar", variantsFactory, p)

	local isVisible = not flag and (p3 == UserPresence.Active or p3 == UserPresence.Away)
	local v2

	if flag or p3 ~= UserPresence.InExperience then
		v2 = backgroundStyle
	else
		v2 = p.Color.System.Emphasis
	end

	local thickness

	if flag then
		thickness = v.iconSizeStrokes[p2]
	else
		thickness = v.sizeStrokes[p2]
	end

	return composeStyleVariant(v.common, v.sizes[p2], v.presence[p3], {
		container = {
			stroke = v2 and {
				Color = indexBindable(v2, "Color3"),
				Transparency = indexBindable(v2, "Transparency"),
				Thickness = thickness
			} or nil,
			backgroundStyle = backgroundStyle
		},
		statusIndicator = { isVisible = isVisible }
	})
end
