local ContentProvider = game:GetService("ContentProvider")

local EditedVideoFrame = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/EditedVideoFrame")
local VideoFrameWrapper = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoFrameWrapper")
local getAuthorizedVideoUri = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getAuthorizedVideoUri")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/ArgCheck")
local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/UIBlox").App.Loading.LoadableImage
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

local getVideoEdits = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getVideoEdits")

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance
local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen
local fFlagLuaAppEdpConsoleMediaGalleryVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpConsoleMediaGalleryVideo
local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppHomePageFirstImageLoadObserver = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppHomePageFirstImageLoadObserver
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppHomeMomentVideoFallback
local fFlagLuaAppVideoLoadFailureFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoLoadFailureFallback
local fFlagLuaAppVideoPlayerTrimAndMusic = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoPlayerTrimAndMusic

local function LoadableVideoFrame(props, p2)
	local state, setState = React.useState(false)
	local state2, setState2, ref, ref2

	if fFlagLuaAppVideoLoadFailureFallback then
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
		fFlagLuaAppEdpMediaGalleryAutoAdvance
		or fFlagLuaAppEdpMediaGalleryFullScreen
		or fFlagLuaAppEdpConsoleMediaGalleryVideo
		or fFlagLuaAppEnableNxMRoduxApportioning
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

	local v5 = not (props.thumbnail == nil) and props.thumbnail ~= ""
	local v6

	if fFlagLuaAppVideoLoadFailureFallback then
		if fFlagLuaAppHomeMomentVideoFallback then
			v6 = getAuthorizedVideoUri(props.video, props.accessContext)
		else
			v6 = props.video
		end

		React.useEffect(function()
			setState2(false)

			if not props.shouldStartPlayback or v6 == "" then
				return nil
			end

			local v7 = { finished = false, failed = false, connection = nil }
			ref.current = v7
			local function onFetchStatus(assetFetchStatus)
				if
					v7.finished
					or assetFetchStatus ~= Enum.AssetFetchStatus.Failure
					and assetFetchStatus ~= Enum.AssetFetchStatus.TimedOut
				then
					return
				end

				v7.finished = true
				v7.failed = true

				if v7.connection then
					v7.connection:Disconnect()
				end

				setState2(true)

				if ref2.current then
					ref2.current(assetFetchStatus.Name)
				end
			end

			v7.connection = ContentProvider:GetAssetFetchStatusChangedSignal(v6):Connect(onFetchStatus)
			onFetchStatus(ContentProvider:GetAssetFetchStatus(v6))

			return function()
				v7.finished = true
				ref.current = nil

				if v7.connection then
					v7.connection:Disconnect()
				end
			end
		end, { v6, props.shouldStartPlayback, ref, ref2 })
	else
		v6 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		if fFlagLuaAppVideoLoadFailureFallback and ref.current then
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
			fFlagLuaAppEdpMediaGalleryAutoAdvance
			or fFlagLuaAppEdpMediaGalleryFullScreen
			or fFlagLuaAppEdpConsoleMediaGalleryVideo
			or fFlagLuaAppEnableNxMRoduxApportioning
		then
			if typeof(p2) == "table" then
				current = p2.current
			else
				warn(`unsupported ref type: {typeof(p2)}`)
			end
		else
			current = ref3.current
		end

		if current ~= nil then
			local now = tick()
			ArgCheck.assert(ref4.current and ref4.current <= now)

			local v7 = not (ref4.current and ref4.current <= now) and -1 or now - ref4.current

			if props.onVideoLoaded then
				local v8

				if fFlagLuaAppVideoPlayerTrimAndMusic and props.edits and props.edits.trim then
					local playbackRange, v9 = getVideoEdits.getPlaybackRange(current.TimeLength, props.edits.trim)
					v8 = v9 - playbackRange
				else
					v8 = current.TimeLength
				end

				local onVideoLoaded = props.onVideoLoaded

				if not fFlagLuaAppVideoPlayerTrimAndMusic then
					v8 = current.TimeLength
				end

				onVideoLoaded(v8, v7)
			end

			setState(true)
		end
	end

	local onVideoLoaded = props.onVideoLoaded
	local startTime

	if fFlagLuaAppVideoPlayerTrimAndMusic and props.edits and props.edits.trim then
		startTime = props.edits.trim.startTime
	end

	local endTime

	if fFlagLuaAppVideoPlayerTrimAndMusic and props.edits and props.edits.trim then
		endTime = props.edits.trim.endTime
	end

	local v8

	if
		fFlagLuaAppEdpMediaGalleryAutoAdvance
		or fFlagLuaAppEdpMediaGalleryFullScreen
		or fFlagLuaAppEdpConsoleMediaGalleryVideo
		or fFlagLuaAppEnableNxMRoduxApportioning
	then
		v8 = p2
	else
		v8 = ref3
	end

	local v10 = useCallback(fn, {
		onVideoLoaded,
		startTime,
		endTime,
		v8,
		ref4,
		if fFlagLuaAppVideoLoadFailureFallback then ref else nil
	})
	local v11

	if fFlagLuaAppEdpMediaGalleryAutoAdvance then
		v11 = React.useCallback(function()
			if props.onVideoEnded then
				props.onVideoEnded()
			end
		end, { props.onVideoEnded })
	end

	local v12 = React.useCallback(function()
		if props.onVideoLooped then
			props.onVideoLooped()
		end
	end, { props.onVideoLooped })

	local createElement = React.createElement
	local v14 = {
		[React.Tag] = fFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true
	}

	local createElement2 = React.createElement
	local v16 = if fFlagLuaAppVideoPlayerTrimAndMusic and props.edits then EditedVideoFrame else VideoFrameWrapper
	local v18 = if fFlagLuaAppEdpMediaGalleryAutoAdvance or fFlagLuaAppEdpMediaGalleryFullScreen or fFlagLuaAppEdpConsoleMediaGalleryVideo or fFlagLuaAppEnableNxMRoduxApportioning then p2 else ref3
	local v19

	if fFlagLuaAppVideoLoadFailureFallback then
		v19 = v6
	elseif fFlagLuaAppHomeMomentVideoFallback then
		v19 = getAuthorizedVideoUri(props.video, props.accessContext)
	else
		v19 = props.video
	end

	local v17 = {
		videoFrameRef = v18,
		video = v19,
		isPlaying = props.shouldStartPlayback and (not fFlagLuaAppVideoLoadFailureFallback or not state2),
		looped = props.looped,
		edits = 0,
		volume = 0,
		onLoaded = 0,
		onLooped = 0,
		onEnded = 0,
		cornerRadius = 0,
		zIndex = 4
	}
	local v20 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.edits else nil
	v17.edits = v20
	v17.volume = props.muted and 0 or nil
	v17.onLoaded = v10
	v17.onLooped = v12

	if not fFlagLuaAppEdpMediaGalleryAutoAdvance then
		v11 = nil
	end

	v17.onEnded = v11
	v17.cornerRadius = props.cornerRadius
	local v15 = {
		VideoFrame = createElement2(v16, v17),
		VideoThumbnail = 0,
		Skeleton = 0
	}
	local v21

	if fFlagLuaAppSduiVideoThumbnail and props.thumbnailComponentOverride then
		v21 = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2
			},
			{ Thumbnail = props.thumbnailComponentOverride }
		)
	elseif v5 then
		local createElement3 = React.createElement
		local v23 = {
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
		local v24 = if props.ScaleType == Enum.ScaleType.Tile and props.cornerRadius then UDim2.new(1, 0, 1, -props.cornerRadius) else nil
		v23.TileSize = v24
		v21 = createElement3(loadableImage, v23)
	end

	v15.VideoThumbnail = v21
	local v22

	if props.shouldStartPlayback and not state and not (fFlagLuaAppVideoLoadFailureFallback and state2) then
		local createElement3 = React.createElement
		local v24 = { Size = UDim2.fromScale(1, 1), radius = 0, ZIndex = 3 }
		local v25 = if props.cornerRadius then radius.Medium else nil
		v24.radius = v25
		v22 = createElement3(skeleton, v24)
	end

	v15.Skeleton = v22
	return createElement("Frame", v14, v15)
end

if
	fFlagLuaAppEdpMediaGalleryAutoAdvance
	or fFlagLuaAppEdpMediaGalleryFullScreen
	or fFlagLuaAppEdpConsoleMediaGalleryVideo
	or fFlagLuaAppEnableNxMRoduxApportioning
then
	return React.forwardRef(LoadableVideoFrame)
end

return LoadableVideoFrame
