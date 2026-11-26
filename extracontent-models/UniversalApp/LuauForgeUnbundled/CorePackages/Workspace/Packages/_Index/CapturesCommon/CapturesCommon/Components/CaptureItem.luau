local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local CaptureType = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/CaptureType")
local MediaPlayer = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Components/MediaPlayer")
require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Types")
local getCropSize = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Utils/getCropSize")
local getFitSize = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Utils/getFitSize")

local FFlagUseRbxStorageInCapturesCommon = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Flags/FFlagUseRbxStorageInCapturesCommon")

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local state3, setState3 = React.useState(UDim2.fromScale(1, 1))

	local v5 = React.useCallback(function(p2)
		setState2(p2.Resolution)
	end, {})

	local v6 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	React.useEffect(function()
		if props.scaleType == Enum.ScaleType.Fit then
			setState3(getFitSize(state, state2))
		else
			setState3(getCropSize(state, state2))
		end
	end, { state, state2 })

	local createElement = React.createElement
	local v9

	if props.capture.type == CaptureType.Screenshot then
		v9 = props.capture.contentId
	elseif FFlagUseRbxStorageInCapturesCommon then
		v9 = props.capture.thumbnailKey
	end

	local v8 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		["Image"] = v9,
		ScaleType = props.scaleType or Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1)
	}
	local absoluteSize = React.Change.AbsoluteSize

	if FFlagUseRbxStorageInCapturesCommon then
		v6 = nil
	end

	v8[absoluteSize] = v6
	v8[React.Event.Activated] = props.onActivated
	local v10 = { Overlay = props.overlay, VideoPreview = 0 }
	local v11

	if
		FFlagUseRbxStorageInCapturesCommon
		and props.capture.type == CaptureType.Video
		and props.shouldUseMediaPlayer
		and props.mediaPlayerProps
	then
		v11 = React.createElement(MediaPlayer, props.mediaPlayerProps)
	elseif not (FFlagUseRbxStorageInCapturesCommon or props.capture.type ~= CaptureType.Video) then
		if props.shouldUseMediaPlayer and props.mediaPlayerProps then
			v11 = React.createElement(MediaPlayer, props.mediaPlayerProps)
		else
			v11 = React.createElement("VideoFrame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Playing = props.isVideoPlaying == true,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = state3,
				Video = props.capture.contentId,
				[React.Event.Loaded] = v5
			})
		end
	end

	v10.VideoPreview = v11
	return createElement("ImageButton", v8, v10)
end
