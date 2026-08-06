local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local Image = require(AppChatParent.Foundation).Image
local RoundedVariant = require(AppChat.Enums.RoundedVariant)
local t1 = {
	LayoutOrder = 0,
	cornerRadius = 20,
	aspectRatio = 1,
	Visible = true
}
local t2 = {
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.1, 1),
	NumberSequenceKeypoint.new(0.4, 0),
	NumberSequenceKeypoint.new(1, 0)
}

local function GameCardThumbnail(t3: {[any]: any}) -- line: 36
	-- upvalues: Cryo (copy), t1 (copy), React (copy), RoundedVariant (copy), t2 (copy), Image (copy)
	local v11 = Cryo.Dictionary.union(t1, t3)
	local v12 = React.useMemo(function() -- line: 45
		-- upvalues: v11 (copy), RoundedVariant (copy)
		local v14 = math.deg((math.atan(v11.aspectRatio)))

		return {
			[RoundedVariant.Top] = 90,
			[RoundedVariant.Bottom] = 270,
			[RoundedVariant.Left] = 0,
			[RoundedVariant.Right] = 180,
			[RoundedVariant.TopLeft] = v14 + 0,
			[RoundedVariant.TopRight] = 180 - v14,
			[RoundedVariant.BottomLeft] = v14 + 180,
			[RoundedVariant.BottomRight] = 360 - v14
		}
	end, { v11.aspectRatio })
	local v13 = React.useMemo(function() -- line: 60
		-- upvalues: React (copy), v11 (copy), v12 (copy), t2 (copy)
		return React.createElement("UIGradient", {
			Rotation = not v11.roundedVariant and 0 or v12[v11.roundedVariant],
			Transparency = NumberSequence.new(t2)
		})
	end, {
		v11.roundedVariant,
		v12
	})

	return React.createElement(Image, {
		ZIndex = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Image = v11.gameThumbnail,
		LayoutOrder = v11.LayoutOrder,
		aspectRatio = {
			AspectRatio = v11.aspectRatio,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Width
		},
		cornerRadius = UDim.new(0, v11.cornerRadius),
		onActivated = v11.onActivated,
		Visible = v11.Visible
	}, {
		OverlayImage = React.createElement(Image, {
			tag = "size-full",
			Image = v11.gameThumbnail,
			Visible = v11.Visible
		}, {
			TransparencyGradient = v13
		})
	})
end

return React.memo(GameCardThumbnail)
