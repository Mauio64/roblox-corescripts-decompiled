local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

local RoundedVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Enums/RoundedVariant")
local getGameCardThumbnailCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/getGameCardThumbnailCornerRadii")

local FFlagAppChatNativeFoundationCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatNativeFoundationCornerRadii")

local v5 = { LayoutOrder = 0, aspectRatio = 1, Visible = true }

local v6 = {
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.1, 1),
	NumberSequenceKeypoint.new(0.4, 0),
	NumberSequenceKeypoint.new(1, 0)
}

local function GameCardThumbnail(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local size_500 = useTokens().Size.Size_500

	if FFlagAppChatNativeFoundationCornerRadii then
		return React.createElement(image, {
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

	local v7 = React.useMemo(function()
		local v8 = math.deg((math.atan(union.aspectRatio)))

		return {
			[RoundedVariant.Top] = 90,
			[RoundedVariant.TopLeft] = v8 + 0,
			[RoundedVariant.TopRight] = 180 - v8
		}
	end, { union.aspectRatio })

	local v8 = React.useMemo(function()
		return React.createElement("UIGradient", {
			Rotation = not union.roundedVariant and 0 or v7[union.roundedVariant],
			Transparency = NumberSequence.new(v6)
		})
	end, { union.roundedVariant, v7 })

	return React.createElement(image, {
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
			image,
			{ tag = "size-full", Image = union.gameThumbnail, Visible = union.Visible },
			{ TransparencyGradient = v8 }
		)
	})
end

return React.memo(GameCardThumbnail)
