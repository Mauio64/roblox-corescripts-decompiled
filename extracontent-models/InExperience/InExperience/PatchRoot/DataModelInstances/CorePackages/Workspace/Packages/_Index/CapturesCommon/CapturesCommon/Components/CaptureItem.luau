local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local CaptureType = require(parent.Enums.CaptureType)
local MediaPlayer = require(parent.Components.MediaPlayer)
require(parent.Types)
local getCropSize = require(parent.Utils.getCropSize)
local getFitSize = require(parent.Utils.getFitSize)

local FFlagUseRbxStorageInCapturesCommon = require(parent.Flags.FFlagUseRbxStorageInCapturesCommon)

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local state3, setState3 = React.useState(UDim2.fromScale(1, 1))

	local v = React.useCallback(function(p)
		setState2(p.Resolution)
	end, {})

	local v2 = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})

	React.useEffect(function()
		if props.scaleType == Enum.ScaleType.Fit then
			setState3(getFitSize(state, state2))
		else
			setState3(getCropSize(state, state2))
		end
	end, { state, state2 })

	local createElement = React.createElement
	local image

	if props.capture.type == CaptureType.Screenshot then
		image = props.capture.contentId
	elseif FFlagUseRbxStorageInCapturesCommon then
		image = props.capture.thumbnailKey
	end

	local v3 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		["Image"] = image,
		ScaleType = props.scaleType or Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1)
	}
	local absoluteSize = React.Change.AbsoluteSize

	if FFlagUseRbxStorageInCapturesCommon then
		v2 = nil
	end

	v3[absoluteSize] = v2
	v3[React.Event.Activated] = props.onActivated
	local v4 = { Overlay = props.overlay, VideoPreview = 0 }
	local videoPreview

	if
		FFlagUseRbxStorageInCapturesCommon
		and props.capture.type == CaptureType.Video
		and props.shouldUseMediaPlayer
		and props.mediaPlayerProps
	then
		videoPreview = React.createElement(MediaPlayer, props.mediaPlayerProps)
	elseif not (FFlagUseRbxStorageInCapturesCommon or props.capture.type ~= CaptureType.Video) then
		if props.shouldUseMediaPlayer and props.mediaPlayerProps then
			videoPreview = React.createElement(MediaPlayer, props.mediaPlayerProps)
		else
			videoPreview = React.createElement("VideoFrame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Playing = props.isVideoPlaying == true,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = state3,
				Video = props.capture.contentId,
				[React.Event.Loaded] = v
			})
		end
	end

	v4.VideoPreview = videoPreview
	return createElement("ImageButton", v3, v4)
end
