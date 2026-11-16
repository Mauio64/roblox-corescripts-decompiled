local Songbird = script:FindFirstAncestor("Songbird")

local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)

local createNextOrder = ReactUtils.createNextOrder

local MusicPlayingIcon = require(Songbird.Components.MusicPlayingIcon)

local v = { isMoving = true }

local function TrackingAudioIcon(p)
	local joined = Cryo.Dictionary.join(v, p)
	local nextOrder = createNextOrder()

	local size_900 = Foundation.Hooks.useTokens().Size.Size_900

	return React.createElement(Foundation.View, {
		Size = UDim2.fromOffset(size_900, size_900)
	}, {
		BaseIcon = React.createElement(Foundation.Image, {
			Image = "icons/common/musicTrackingBorder_medium",
			Size = UDim2.fromOffset(size_900, size_900),
			ZIndex = nextOrder()
		}),
		CenterCover = React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(size_900 / 2, size_900 / 2),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Transparency = 1,
			ZIndex = nextOrder()
		}, {
			Bars = React.createElement(MusicPlayingIcon, {
				heightRange = NumberRange.new(0.25, 0.9),
				numAnimatedBars = 4,
				zIndex = nextOrder(),
				isMoving = joined.isMoving
			})
		})
	})
end

return TrackingAudioIcon
