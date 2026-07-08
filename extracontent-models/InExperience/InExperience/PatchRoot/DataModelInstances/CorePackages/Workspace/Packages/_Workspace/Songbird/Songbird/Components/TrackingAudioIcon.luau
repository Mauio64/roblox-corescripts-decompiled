local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local createNextOrder = require(Songbird.Parent.ReactUtils).createNextOrder
local MusicPlayingIcon = require(Songbird.Components.MusicPlayingIcon)
local t1 = {
	isMoving = true
}

local function TrackingAudioIcon(t2: {[any]: any}) -- line: 23
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), Foundation (copy), React (copy), MusicPlayingIcon (copy)
	local v10 = Cryo.Dictionary.join(t1, t2)
	local v11 = createNextOrder()
	local Size_900 = Foundation.Hooks.useTokens().Size.Size_900

	return React.createElement(Foundation.View, {
		Size = UDim2.fromOffset(Size_900, Size_900)
	}, {
		BaseIcon = React.createElement(Foundation.Image, {
			Image = "icons/common/musicTrackingBorder_medium",
			Size = UDim2.fromOffset(Size_900, Size_900),
			ZIndex = v11()
		}),
		CenterCover = React.createElement(Foundation.View, {
			Transparency = 1,
			Size = UDim2.fromOffset(Size_900 / 2, Size_900 / 2),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = v11()
		}, {
			Bars = React.createElement(MusicPlayingIcon, {
				numAnimatedBars = 4,
				heightRange = NumberRange.new(0.25, 0.9),
				zIndex = v11(),
				isMoving = v10.isMoving
			})
		})
	})
end

return TrackingAudioIcon
