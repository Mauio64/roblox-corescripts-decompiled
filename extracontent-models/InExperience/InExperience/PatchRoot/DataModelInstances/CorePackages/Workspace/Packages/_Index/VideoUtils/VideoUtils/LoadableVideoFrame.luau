local ContentProvider = game:GetService("ContentProvider")

local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local EditedVideoFrame = require(VideoUtils.EditedVideoFrame)
local VideoFrameWrapper = require(VideoUtils.VideoFrameWrapper)
local getAuthorizedVideoUri = require(VideoUtils.getAuthorizedVideoUri)

local ArgCheck = require(parent.ArgCheck)
local UIBlox = require(parent.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton

local getVideoEdits = require(script.Parent.getVideoEdits)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryAutoAdvance = SharedFlags.FFlagLuaAppEdpMediaGalleryAutoAdvance
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags2.FFlagLuaAppEdpMediaGalleryFullScreen
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags3.FFlagLuaAppEdpConsoleMediaGalleryVideo
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags4.FFlagLuaAppEnableNxMRoduxApportioning

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags5.FFlagLuaAppHomePageFirstImageLoadObserver
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags6.FFlagLuaAppSduiVideoThumbnail
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags7.FFlagLuaAppHomeMomentVideoFallback
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppVideoLoadFailureFallback = SharedFlags8.FFlagLuaAppVideoLoadFailureFallback
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppVideoPlayerTrimAndMusic = SharedFlags9.FFlagLuaAppVideoPlayerTrimAndMusic

local function LoadableVideoFrame(props, p)
	local state, setState = React.useState(false)
	local state2, setState2, ref, ref2

	if FFlagLuaAppVideoLoadFailureFallback then
		state2, setState2 = React.useState(false)
		ref = React.useRef(nil)

		ref2 = React.useRef(props.onVideoLoadFailed)
		ref2.current = props.onVideoLoadFailed
	else
		ref = nil
		setState2 = nil
		ref2 = nil
	end

	local ref3

	if
		FFlagLuaAppEdpMediaGalleryAutoAdvance
		or FFlagLuaAppEdpMediaGalleryFullScreen
		or FFlagLuaAppEdpConsoleMediaGalleryVideo
		or FFlagLuaAppEnableNxMRoduxApportioning
	then
		ref3 = nil
	else
		ref3 = React.useRef(nil)
	end

	local ref4 = React.useRef(nil)

	if props.shouldStartPlayback and ref4.current == nil then
		ref4.current = tick()
	elseif not props.shouldStartPlayback then
		ref4.current = nil
	end

	local v

	if props.thumbnail == nil then
		v = false
	else
		v = props.thumbnail ~= ""
	end

	local v2

	if FFlagLuaAppVideoLoadFailureFallback then
		if FFlagLuaAppHomeMomentVideoFallback then
			v2 = getAuthorizedVideoUri(props.video, props.accessContext)
		else
			v2 = props.video
		end

		React.useEffect(function()
			setState2(false)

			if not props.shouldStartPlayback or v2 == "" then
				return nil
			end

			local current = { finished = false, failed = false, connection = nil }
			ref.current = current
			local function onFetchStatus(assetFetchStatus)
				if
					current.finished
					or assetFetchStatus ~= Enum.AssetFetchStatus.Failure
					and assetFetchStatus ~= Enum.AssetFetchStatus.TimedOut
				then
					return
				end

				current.finished = true
				current.failed = true

				if current.connection then
					current.connection:Disconnect()
				end

				setState2(true)

				if ref2.current then
					ref2.current(assetFetchStatus.Name)
				end
			end

			current.connection = ContentProvider:GetAssetFetchStatusChangedSignal(v2):Connect(onFetchStatus)
			onFetchStatus(ContentProvider:GetAssetFetchStatus(v2))

			return function()
				current.finished = true
				ref.current = nil

				if current.connection then
					current.connection:Disconnect()
				end
			end
		end, { v2, props.shouldStartPlayback, ref, ref2 })
	else
		v2 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if FFlagLuaAppVideoLoadFailureFallback and ref.current then
			local current = ref.current

			if current.failed then
				return
			end

			current.finished = true

			if current.connection then
				current.connection:Disconnect()
			end
		end

		local current = nil

		if
			FFlagLuaAppEdpMediaGalleryAutoAdvance
			or FFlagLuaAppEdpMediaGalleryFullScreen
			or FFlagLuaAppEdpConsoleMediaGalleryVideo
			or FFlagLuaAppEnableNxMRoduxApportioning
		then
			if typeof(p) == "table" then
				current = p.current
			else
				warn(`unsupported ref type: {typeof(p)}`)
			end
		else
			current = ref3.current
		end

		if current ~= nil then
			local now = tick()
			ArgCheck.assert(ref4.current and ref4.current <= now)

			local v3 = not (ref4.current and ref4.current <= now) and -1 or now - ref4.current

			if props.onVideoLoaded then
				local v4

				if FFlagLuaAppVideoPlayerTrimAndMusic and props.edits and props.edits.trim then
					local playbackRange, v5 = getVideoEdits.getPlaybackRange(current.TimeLength, props.edits.trim)
					v4 = v5 - playbackRange
				else
					v4 = current.TimeLength
				end

				local onVideoLoaded = props.onVideoLoaded

				if not FFlagLuaAppVideoPlayerTrimAndMusic then
					v4 = current.TimeLength
				end

				onVideoLoaded(v4, v3)
			end

			setState(true)
		end
	end

	local onVideoLoaded = props.onVideoLoaded
	local startTime

	if FFlagLuaAppVideoPlayerTrimAndMusic and props.edits and props.edits.trim then
		startTime = props.edits.trim.startTime
	end

	local endTime

	if FFlagLuaAppVideoPlayerTrimAndMusic and props.edits and props.edits.trim then
		endTime = props.edits.trim.endTime
	end

	local v3

	if
		FFlagLuaAppEdpMediaGalleryAutoAdvance
		or FFlagLuaAppEdpMediaGalleryFullScreen
		or FFlagLuaAppEdpConsoleMediaGalleryVideo
		or FFlagLuaAppEnableNxMRoduxApportioning
	then
		v3 = p
	else
		v3 = ref3
	end

	local v4

	if FFlagLuaAppVideoLoadFailureFallback then
		v4 = ref
	end

	local onLoaded = useCallback(fn, { onVideoLoaded, startTime, endTime, v3, ref4, v4 })
	local onEnded

	if FFlagLuaAppEdpMediaGalleryAutoAdvance then
		onEnded = React.useCallback(function()
			if props.onVideoEnded then
				props.onVideoEnded()
			end
		end, { props.onVideoEnded })
	end

	local onLooped = React.useCallback(function()
		if props.onVideoLooped then
			props.onVideoLooped()
		end
	end, { props.onVideoLooped })

	local createElement = React.createElement
	local v5 = {
		[React.Tag] = FFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true
	}

	local createElement2 = React.createElement
	local v6

	if FFlagLuaAppVideoPlayerTrimAndMusic and props.edits then
		v6 = EditedVideoFrame
	else
		v6 = VideoFrameWrapper
	end

	local videoFrameRef

	if
		FFlagLuaAppEdpMediaGalleryAutoAdvance
		or FFlagLuaAppEdpMediaGalleryFullScreen
		or FFlagLuaAppEdpConsoleMediaGalleryVideo
		or FFlagLuaAppEnableNxMRoduxApportioning
	then
		videoFrameRef = p
	else
		videoFrameRef = ref3
	end

	local video

	if FFlagLuaAppVideoLoadFailureFallback then
		video = v2
	elseif FFlagLuaAppHomeMomentVideoFallback then
		video = getAuthorizedVideoUri(props.video, props.accessContext)
	else
		video = props.video
	end

	local v7 = {
		videoFrameRef = videoFrameRef,
		video = video,
		isPlaying = props.shouldStartPlayback and (not FFlagLuaAppVideoLoadFailureFallback or not state2),
		looped = props.looped,
		edits = 0,
		volume = 0,
		onLoaded = 0,
		onLooped = 0,
		onEnded = 0,
		cornerRadius = 0,
		zIndex = 4
	}
	local edits

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		edits = props.edits
	end

	v7.edits = edits
	v7.volume = props.muted and 0 or nil
	v7.onLoaded = onLoaded
	v7.onLooped = onLooped

	if not FFlagLuaAppEdpMediaGalleryAutoAdvance then
		onEnded = nil
	end

	v7.onEnded = onEnded
	v7.cornerRadius = props.cornerRadius
	local v8 = { VideoFrame = createElement2(v6, v7), VideoThumbnail = 0, Skeleton = 0 }
	local videoThumbnail

	if FFlagLuaAppSduiVideoThumbnail and props.thumbnailComponentOverride then
		videoThumbnail = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2
			},
			{ Thumbnail = props.thumbnailComponentOverride }
		)
	elseif v then
		local createElement3 = React.createElement
		local v9 = {
			BackgroundTransparency = 1,
			Image = props.thumbnail,
			Size = UDim2.new(1, 0, 1, props.ScaleType ~= Enum.ScaleType.Tile and 0 or props.cornerRadius),
			cornerRadius = UDim.new(0, props.cornerRadius),
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 2,
			ScaleType = props.ScaleType,
			TileSize = 0
		}
		local tileSize

		if props.ScaleType == Enum.ScaleType.Tile and props.cornerRadius then
			tileSize = UDim2.new(1, 0, 1, -props.cornerRadius)
		end

		v9.TileSize = tileSize
		videoThumbnail = createElement3(LoadableImage, v9)
	end

	v8.VideoThumbnail = videoThumbnail
	local skeleton

	if props.shouldStartPlayback and not state and not (FFlagLuaAppVideoLoadFailureFallback and state2) then
		local createElement3 = React.createElement
		local v9 = { Size = UDim2.fromScale(1, 1), radius = 0, ZIndex = 3 }
		local radius

		if props.cornerRadius then
			radius = Radius.Medium
		end

		v9.radius = radius
		skeleton = createElement3(Skeleton, v9)
	end

	v8.Skeleton = skeleton
	return createElement("Frame", v5, v8)
end

if
	FFlagLuaAppEdpMediaGalleryAutoAdvance
	or FFlagLuaAppEdpMediaGalleryFullScreen
	or FFlagLuaAppEdpConsoleMediaGalleryVideo
	or FFlagLuaAppEnableNxMRoduxApportioning
then
	return React.forwardRef(LoadableVideoFrame)
end

return LoadableVideoFrame
