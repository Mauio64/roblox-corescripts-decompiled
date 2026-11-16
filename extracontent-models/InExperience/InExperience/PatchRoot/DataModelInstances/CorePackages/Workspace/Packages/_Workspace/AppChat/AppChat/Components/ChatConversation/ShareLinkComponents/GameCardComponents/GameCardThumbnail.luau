local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local RoundedVariant = require(AppChat.Enums.RoundedVariant)
local getGameCardThumbnailCornerRadii = require(script.Parent.getGameCardThumbnailCornerRadii)

local FFlagAppChatNativeFoundationCornerRadii = require(AppChat.Flags.FFlagAppChatNativeFoundationCornerRadii)

local v = { LayoutOrder = 0, aspectRatio = 1, Visible = true }

local v2 = {
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.1, 1),
	NumberSequenceKeypoint.new(0.4, 0),
	NumberSequenceKeypoint.new(1, 0)
}

local function GameCardThumbnail(p)
	local union = Cryo.Dictionary.union(v, p)
	local size_500 = useTokens().Size.Size_500

	if FFlagAppChatNativeFoundationCornerRadii then
		return React.createElement(Image, {
			Size = UDim2.new(1, 0, 1, 0),
			Image = union.gameThumbnail,
			ZIndex = 0,
			LayoutOrder = union.LayoutOrder,
			aspectRatio = {
				AspectRatio = union.aspectRatio,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width
			},
			cornerRadius = getGameCardThumbnailCornerRadii(union.roundedVariant, size_500),
			onActivated = union.onActivated,
			Visible = union.Visible
		})
	end

	local v3 = React.useMemo(function()
		local v3 = math.deg((math.atan(union.aspectRatio)))

		return {
			[RoundedVariant.Top] = 90,
			[RoundedVariant.TopLeft] = v3 + 0,
			[RoundedVariant.TopRight] = 180 - v3
		}
	end, { union.aspectRatio })

	local transparencyGradient = React.useMemo(function()
		return React.createElement("UIGradient", {
			Rotation = not union.roundedVariant and 0 or v3[union.roundedVariant],
			Transparency = NumberSequence.new(v2)
		})
	end, { union.roundedVariant, v3 })

	return React.createElement(Image, {
		Size = UDim2.new(1, 0, 1, 0),
		Image = union.gameThumbnail,
		ZIndex = 0,
		LayoutOrder = union.LayoutOrder,
		aspectRatio = {
			AspectRatio = union.aspectRatio,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Width
		},
		cornerRadius = UDim.new(0, size_500),
		onActivated = union.onActivated,
		Visible = union.Visible
	}, {
		OverlayImage = React.createElement(
			Image,
			{ tag = "size-full", Image = union.gameThumbnail, Visible = union.Visible },
			{ TransparencyGradient = transparencyGradient }
		)
	})
end

return React.memo(GameCardThumbnail)
