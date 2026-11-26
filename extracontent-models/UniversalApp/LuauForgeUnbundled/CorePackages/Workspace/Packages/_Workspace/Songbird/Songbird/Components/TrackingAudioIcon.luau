local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local createNextOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils").createNextOrder

local MusicPlayingIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/MusicPlayingIcon")

local v5 = { isMoving = true }

local function TrackingAudioIcon(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
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
