local RunService = game:GetService("RunService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/LoggingProtocol")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Responsive")
require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/AppCommonLib")
local LoadableVideoFrame = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/LoadableVideoFrame")
local RoundIconButton = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/RoundIconButton")
local videoActions = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoActions
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/VideoAnalyticsTypes")
local VideoLogger = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/VideoLogger")
local VideoPlayerBottomOverlay = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlayerBottomOverlay")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryUtils").DiscoveryEventErrorLogger

local reportWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryAnalytics").Points.reportWarning
local getVideoEdits = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getVideoEdits")

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance
local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen
local fFlagLuaAppVideoTileDisableActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoTileDisableActivation
local fFlagLuaAppVideoTileHideCenterPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoTileHideCenterPlayButton
local fFlagLuaAppEdpConsoleMediaGalleryVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpConsoleMediaGalleryVideo
local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppEnableHomepageOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEnableHomepageOneByTwoTile
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppHomeMomentVideoFallback
local fFlagLuaAppVideoLoadFailureFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoLoadFailureFallback
local fFlagLuaAppVideoPlayerTrimAndMusic = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoPlayerTrimAndMusic

local v5 = game:DefineFastInt("VideoPlayerPlaybackEndThresholdInMs", 100) / 1000

local function VideoPlayer(props)
	local v6, v7

	if fFlagLuaAppVideoPlayerTrimAndMusic then
		v6, v7 = React.useMemo(function()
			return getVideoEdits.getVideoEdits({
				trimStartTime = props.trimStartTime,
				trimEndTime = props.trimEndTime,
				musicAssetId = props.musicAssetId,
				musicStartTime = props.musicStartTime
			})
		end, {
			props.trimStartTime,
			props.trimEndTime,
			props.musicAssetId,
			props.musicStartTime
		})
	else
		v7 = nil
		v6 = nil
	end

	local showMuteButton = props.showMuteButton
		or fFlagLuaAppEdpMediaGalleryFullScreen and (props.showPlayButton or props.showProgressBar)

	local state, setState = React.useState(false)

	local state2, setState2 = React.useState(props.muted)

	local v8 = React.useCallback(function(p2, p3)
		setState(true)

		if props.onVideoLoaded then
			props.onVideoLoaded(p2, p3)
		end
	end, { props.onVideoLoaded })
	local v9

	if fFlagLuaAppVideoLoadFailureFallback then
		v9 = React.useCallback(function(p2)
			local v10 = string.match(props.video, "^rbxassetid://(%d+)") or "unknown"
			local videoAnalyticsData

			if props.videoAnalyticsContext then
				videoAnalyticsData = props.videoAnalyticsContext.videoAnalyticsData
			end

			local formatted = `Video asset {v10} failed to load: {p2}`
			local reportError = discoveryEventErrorLogger.reportError

			local v13 = not (props.accessContext == nil) and props.accessContext ~= ""
			local v12 = {
				message = formatted,
				videoAssetId = v10,
				reason = p2,
				hasAccessContext = tostring(v13),
				source = 0,
				sourceId = 0
			}
			local v14 = if videoAnalyticsData then videoAnalyticsData.source else nil
			v12.source = v14
			local v15 = if videoAnalyticsData then videoAnalyticsData.sourceId else nil
			v12.sourceId = v15
			reportError("VideoLoadFailure", formatted, v12)

			if props.onVideoLoadFailed then
				props.onVideoLoadFailed(p2)
			end
		end, {
			props.video,
			props.accessContext,
			props.videoAnalyticsContext,
			props.onVideoLoadFailed
		})
	end

	if fFlagLuaAppVideoPlayerTrimAndMusic then
		local ref = React.useRef(v9)
		ref.current = v9
		React.useEffect(function()
			if not v7 and props.shouldStartPlayback and ref.current then
				ref.current("InvalidEdits")
			end
		end, { v7, props.shouldStartPlayback, props.video })
	end

	React.useEffect(function()
		if props.onMutedChanged then
			props.onMutedChanged(state2)
		end
	end, { props.onMutedChanged, state2 })

	local v10 = React.useCallback(function()
		setState2(function(p2): boolean
			if props.onMuteButtonActivated then
				props.onMuteButtonActivated(p2)
			end

			return not p2
		end)
	end, { props.onMuteButtonActivated })
	local v11 = React.useMemo(function()
		if props.showMuteButton then
			return { muted = state2, onMuteButtonActivated = v10 }
		end

		return nil
	end, { props.showMuteButton, state2, v10 })
	local ref

	if
		fFlagLuaAppEdpMediaGalleryAutoAdvance
		or fFlagLuaAppEdpMediaGalleryFullScreen
		or fFlagLuaAppEdpConsoleMediaGalleryVideo
		or fFlagLuaAppEnableHomepageOneByTwoTile
	then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	local v12, v13

	if fFlagLuaAppEdpMediaGalleryFullScreen then
		v12, v13 = React.useBinding(0)
	else
		v13 = nil
		v12 = nil
	end

	if fFlagLuaAppEdpMediaGalleryAutoAdvance or fFlagLuaAppEdpMediaGalleryFullScreen then
		local useEffect = React.useEffect
		local function fn()
			local current = ref.current

			if
				props.shouldStartPlayback
				and (fFlagLuaAppEdpMediaGalleryAutoAdvance and props.onVideoProgressChanged or fFlagLuaAppEdpMediaGalleryFullScreen and props.showProgressBar)
				and current
			then
				local renderSteppedConnection = RunService.RenderStepped:Connect(function()
					local v14

					if fFlagLuaAppVideoPlayerTrimAndMusic and v6 and v6.trim then
						local playbackRange, v15 = getVideoEdits.getPlaybackRange(current.TimeLength, v6.trim)
						v14 = not (playbackRange < v15) and 0
							or math.clamp(
								(current.TimePosition - playbackRange) / (v15 - playbackRange),
								0,
								1
							)
					end

					if fFlagLuaAppEdpMediaGalleryAutoAdvance and props.onVideoProgressChanged then
						local onVideoProgressChanged = props.onVideoProgressChanged

						local v15 = if fFlagLuaAppVideoPlayerTrimAndMusic and v14 ~= nil then v14 else not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength
						onVideoProgressChanged(v15)
					end

					if fFlagLuaAppEdpMediaGalleryFullScreen and props.showProgressBar then
						if not fFlagLuaAppVideoPlayerTrimAndMusic or v14 == nil then
							v14 = not (current.TimeLength > 0) and 0
								or current.TimePosition / current.TimeLength
						end

						v13(v14)
					end
				end)

				return function()
					renderSteppedConnection:Disconnect()

					if fFlagLuaAppEdpMediaGalleryAutoAdvance and props.onVideoProgressChanged then
						props.onVideoProgressChanged(0)
					end

					if fFlagLuaAppEdpMediaGalleryFullScreen and props.showProgressBar then
						v13(0)
					end
				end
			end

			return nil
		end

		local shouldStartPlayback = props.shouldStartPlayback
		local onVideoProgressChanged = if fFlagLuaAppEdpMediaGalleryAutoAdvance then props.onVideoProgressChanged else nil
		local showProgressBar = if fFlagLuaAppEdpMediaGalleryFullScreen then props.showProgressBar else nil
		useEffect(fn, {
			shouldStartPlayback,
			onVideoProgressChanged,
			showProgressBar,
			if fFlagLuaAppVideoPlayerTrimAndMusic then v6 else nil
		})
	end

	if fFlagLuaAppEnableHomepageOneByTwoTile then
		React.useEffect(function()
			local onAspectRatioChanged = props.onAspectRatioChanged
			local current = ref and ref.current

			if not (onAspectRatioChanged and current) then
				return
			end

			local v14 = nil
			local function report()
				local resolution = current.Resolution

				if resolution.X > 0 and resolution.Y > 0 then
					local v15 = resolution.X / resolution.Y

					if v15 ~= v14 then
						v14 = v15
						onAspectRatioChanged(v15)
					end
				end
			end

			local resolutionChangedConnection = current:GetPropertyChangedSignal("Resolution"):Connect(report)
			local resolution = current.Resolution

			if resolution.X > 0 and resolution.Y > 0 then
				local v15 = resolution.X / resolution.Y

				if v15 ~= v14 then
					v14 = v15
					onAspectRatioChanged(v15)
				end
			end

			return function()
				resolutionChangedConnection:Disconnect()
			end
		end, { props.onAspectRatioChanged })
	end

	local state3 = nil
	local setState3 = nil
	local v14, v15, v16, v17, v18

	if fFlagLuaAppEdpMediaGalleryFullScreen or fFlagLuaAppEdpConsoleMediaGalleryVideo then
		state3, setState3 = React.useState(false)

		local useCallback = React.useCallback
		local function fn(p2)
			local current = ref.current

			if not current then
				reportWarning(
					LoggingProtocol.default,
					"EventLogging",
					"reportVideoAction requires a valid videoFrame"
				)

				return
			end

			local source, sourceId, v19

			if props.videoAnalyticsContext then
				source = props.videoAnalyticsContext.videoAnalyticsData.source
				sourceId = props.videoAnalyticsContext.videoAnalyticsData.sourceId
				v19 = props.videoAnalyticsContext.getPlaybackSessionId()

				if not (source and sourceId and v19) then
					reportWarning(
						LoggingProtocol.default,
						"EventLogging",
						`reportVideoAction requires a valid {source and "" or "source "}{sourceId and "" or "sourceId "}{v19 and "" or "playbackSessionId"}`
					)
				end
			end

			local v20

			if fFlagLuaAppVideoPlayerTrimAndMusic and v6 then
				local playbackRange, v21 = getVideoEdits.getPlaybackRange(current.TimeLength, v6.trim)
				v20 = v21 - playbackRange
			end

			local reportVideoAction = VideoLogger.reportVideoAction
			local v22 = {
				videoAssetId = props.video,
				source = source or "",
				sourceId = sourceId or "",
				playbackSessionId = v19 or "",
				videoAssetDuration = 0,
				isVisible = true,
				isAudible = 0,
				volumeLevel = 0
			}

			if not fFlagLuaAppVideoPlayerTrimAndMusic or v20 == nil then
				v20 = current.TimeLength
			end

			v22.videoAssetDuration = v20

			local v23 = if fFlagLuaAppVideoPlayerTrimAndMusic then not state2 else current.Volume ~= 0
			v22.isAudible = v23

			local v24 = if fFlagLuaAppVideoPlayerTrimAndMusic then state2 and 0 or 1 else current.Volume == 0 and 0 or 1
			v22.volumeLevel = v24
			reportVideoAction(p2, nil, v22)
		end

		local video = props.video
		local videoAnalyticsContext = props.videoAnalyticsContext
		local v20 = if fFlagLuaAppVideoPlayerTrimAndMusic then v6 else nil
		local v22 = useCallback(fn, {
			video,
			videoAnalyticsContext,
			v20,
			if fFlagLuaAppVideoPlayerTrimAndMusic then state2 else nil
		})

		v14 = React.useCallback(function()
			local current = ref.current

			if not current then
				return
			end

			if state3 then
				current:Pause()
				return
			end

			if math.abs(current.TimePosition - current.TimeLength) <= v5 then
				current.TimePosition = 0
			end

			current:Play()
		end, { state3 })

		v15 = Responsive.usePreferredInput() == Responsive.Input.Directional
		React.useEffect(function()
			local connections = {}

			if props.toggleVideoPlaybackSignal then
				table.insert(connections, props.toggleVideoPlaybackSignal:connect(v14))
			end

			if props.toggleMuteSignal then
				table.insert(connections, props.toggleMuteSignal:connect(v10))
			end

			return function()
				for k, connection in connections do
					if connection then
						connection:disconnect()
					end
				end
			end
		end, { props.toggleVideoPlaybackSignal, props.toggleMuteSignal, v14, v10 })

		v16 = React.useCallback(function()
			if props.onVideoPlayerActivated then
				props.onVideoPlayerActivated()
			else
				v14()
			end
		end, { props.onVideoPlayerActivated, v14 })

		v17 = React.useMemo(function()
			if props.showPlayButton then
				return { isVideoPlaying = state3, onPlayButtonActivated = v14 }
			end

			return nil
		end, { props.showPlayButton, state3, v14 })

		v18 = React.useMemo(function()
			if props.showProgressBar then
				return { progressBinding = v12 }
			end

			return nil
		end, { props.showProgressBar, v12 })

		React.useEffect(function()
			local current = ref.current

			if not (props.shouldStartPlayback and current) then
				return nil
			end

			local playedConnection = current.Played:Connect(function()
				setState3(true)
				v22(videoActions.play)
			end)

			local pausedConnection = current.Paused:Connect(function()
				setState3(false)
				v22(videoActions.pause)
			end)

			local endedConnection = current.Ended:Connect(function()
				setState3(false)
			end)

			return function()
				playedConnection:Disconnect()
				pausedConnection:Disconnect()
				endedConnection:Disconnect()
			end
		end, { props.shouldStartPlayback, v22 })

		React.useEffect(function(): nil
			if not props.shouldStartPlayback then
				setState(false)
				setState3(false)
			end

			return nil
		end, { props.shouldStartPlayback })

		if fFlagLuaAppMediaGalleryGamepadSupport then
			React.useEffect(function()
				if props.onPlayingChanged then
					props.onPlayingChanged(state3)
				end
			end, { props.onPlayingChanged, state3 })

			React.useEffect(function()
				if props.onVideoLoadedChanged then
					props.onVideoLoadedChanged(state)
				end
			end, { props.onVideoLoadedChanged, state })
		end
	else
		v14 = nil
	end

	local createElement = React.createElement
	local v19 = fFlagLuaAppVideoTileDisableActivation and props.disableActivation and "Frame"
		or fFlagLuaAppEdpMediaGalleryFullScreen and "TextButton"
		or "Frame"

	local v20 = {
		["Size"] = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = props.ZIndex
	}
	local v21 = if not (fFlagLuaAppVideoTileDisableActivation and props.disableActivation) then fFlagLuaAppEdpMediaGalleryFullScreen and "" or nil else nil
	v20.Text = v21

	local activated = React.Event.Activated

	if fFlagLuaAppVideoTileDisableActivation and props.disableActivation then
		v16 = nil
	elseif not fFlagLuaAppEdpMediaGalleryFullScreen then
		v16 = nil
	end

	v20[activated] = v16

	v20.Selectable = false

	local v23 = if props.cornerRadius then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, props.cornerRadius)
	}) else nil

	local createElement2 = React.createElement
	local v25 = {
		video = props.video,
		accessContext = 0,
		edits = 0,
		thumbnail = 0,
		thumbnailComponentOverride = 0,
		shouldStartPlayback = 0,
		muted = 0,
		looped = 0,
		ScaleType = 0,
		cornerRadius = 0,
		onVideoLoaded = 0,
		onVideoLooped = 0,
		onVideoEnded = 0,
		onVideoLoadFailed = 0,
		ref = 0
	}
	local v26 = if fFlagLuaAppHomeMomentVideoFallback then props.accessContext else nil
	v25.accessContext = v26
	v25.edits = if fFlagLuaAppVideoPlayerTrimAndMusic then v6 else nil
	v25.thumbnail = props.thumbnail

	local v28 = if fFlagLuaAppSduiVideoThumbnail then props.thumbnailComponentOverride else nil
	v25.thumbnailComponentOverride = v28

	v25.shouldStartPlayback = props.shouldStartPlayback and (not fFlagLuaAppVideoPlayerTrimAndMusic or v7)

	v25.muted = state2
	v25.looped = props.looped
	v25.ScaleType = props.ScaleType
	v25.cornerRadius = props.cornerRadius
	v25.onVideoLoaded = v8
	v25.onVideoLooped = props.onVideoLooped
	local v29 = if fFlagLuaAppEdpMediaGalleryAutoAdvance then props.onVideoEnded else nil
	v25.onVideoEnded = v29

	if not fFlagLuaAppVideoLoadFailureFallback then
		v9 = nil
	end

	v25.onVideoLoadFailed = v9
	local v30 = if fFlagLuaAppEdpMediaGalleryAutoAdvance or fFlagLuaAppEdpMediaGalleryFullScreen or fFlagLuaAppEdpConsoleMediaGalleryVideo or fFlagLuaAppEnableHomepageOneByTwoTile then ref else nil
	v25.ref = v30
	local v22 = {
		Corner = v23,
		Video = createElement2(LoadableVideoFrame, v25),
		PlayButton = 0,
		BottomOverlay = 0
	}
	local v31

	if not ((fFlagLuaAppVideoTileHideCenterPlayButton or fFlagLuaAppEnableHomepageOneByTwoTile) and props.hideCenterPlayButton or not (fFlagLuaAppEdpMediaGalleryFullScreen or fFlagLuaAppMediaGalleryGamepadSupport) or not state or state3 or fFlagLuaAppMediaGalleryGamepadSupport and v14 == nil) then
		v31 = React.createElement(RoundIconButton, {
			icon = "play-large",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = 2,
			Selectable = if v15 then false else nil,
			onActivated = v14
		})
	end

	v22.PlayButton = v31
	local v32

	if showMuteButton then
		local createElement3 = React.createElement
		local v34 = {
			cornerRadius = props.cornerRadius,
			ZIndex = 10,
			videoLoaded = state,
			muteButtonConfig = v11,
			playButtonConfig = 0,
			progressBarConfig = 0
		}

		if not fFlagLuaAppEdpMediaGalleryFullScreen then
			v17 = nil
		end

		v34.playButtonConfig = v17

		if not fFlagLuaAppEdpMediaGalleryFullScreen then
			v18 = nil
		end

		v34.progressBarConfig = v18
		v32 = createElement3(VideoPlayerBottomOverlay, v34)
	end

	v22.BottomOverlay = v32
	return createElement(v19, v20, v22)
end

return VideoPlayer
