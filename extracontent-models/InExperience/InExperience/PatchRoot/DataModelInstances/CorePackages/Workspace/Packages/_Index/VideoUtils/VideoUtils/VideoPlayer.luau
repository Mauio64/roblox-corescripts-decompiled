local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("VideoUtils").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
require(parent.AppCommonLib)
local LoadableVideoFrame = require(script.Parent.LoadableVideoFrame)
local RoundIconButton = require(script.Parent.RoundIconButton)
local Enums = require(script.Parent.Analytics.Enums)
local VideoActions = Enums.VideoActions
require(script.Parent.Analytics.VideoAnalyticsTypes)
local VideoLogger = require(script.Parent.Analytics.VideoLogger)
local VideoPlayerBottomOverlay = require(script.Parent.VideoPlayerBottomOverlay)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local reportWarning = DiscoveryAnalytics.Points.reportWarning
local getVideoEdits = require(script.Parent.getVideoEdits)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryAutoAdvance = SharedFlags.FFlagLuaAppEdpMediaGalleryAutoAdvance
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags2.FFlagLuaAppEdpMediaGalleryFullScreen
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppVideoTileDisableActivation = SharedFlags3.FFlagLuaAppVideoTileDisableActivation
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppVideoTileHideCenterPlayButton = SharedFlags4.FFlagLuaAppVideoTileHideCenterPlayButton
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags5.FFlagLuaAppEdpConsoleMediaGalleryVideo
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags6.FFlagLuaAppMediaGalleryGamepadSupport
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags7.FFlagLuaAppEnableHomepageOneByTwoTile
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags8.FFlagLuaAppSduiVideoThumbnail
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags9.FFlagLuaAppHomeMomentVideoFallback
local SharedFlags10 = require(parent.SharedFlags)
local FFlagLuaAppVideoLoadFailureFallback = SharedFlags10.FFlagLuaAppVideoLoadFailureFallback
local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppVideoPlayerTrimAndMusic = SharedFlags11.FFlagLuaAppVideoPlayerTrimAndMusic

local v = game:DefineFastInt("VideoPlayerPlaybackEndThresholdInMs", 100) / 1000

local function VideoPlayer(props)
	local v2, v3

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		v2, v3 = React.useMemo(function()
			return getVideoEdits.getVideoEdits({
				trimStartTime = props.trimStartTime,
				trimEndTime = props.trimEndTime,
				musicAssetId = props.musicAssetId,
				musicStartTime = props.musicStartTime
			})
		end, { props.trimStartTime, props.trimEndTime, props.musicAssetId, props.musicStartTime })
	else
		v3 = nil
		v2 = nil
	end

	local showMuteButton = props.showMuteButton
		or FFlagLuaAppEdpMediaGalleryFullScreen and (props.showPlayButton or props.showProgressBar)

	local state, setState = React.useState(false)

	local state2, setState2 = React.useState(props.muted)

	local onVideoLoaded = React.useCallback(function(p: number, p2: number)
		setState(true)

		if props.onVideoLoaded then
			props.onVideoLoaded(p, p2)
		end
	end, { props.onVideoLoaded })
	local v4

	if FFlagLuaAppVideoLoadFailureFallback then
		v4 = React.useCallback(function(reason: string)
			local videoAssetId = string.match(props.video, "^rbxassetid://(%d+)") or "unknown"
			local videoAnalyticsData

			if props.videoAnalyticsContext then
				videoAnalyticsData = props.videoAnalyticsContext.videoAnalyticsData
			end

			local formatted = `Video asset {videoAssetId} failed to load: {reason}`
			local reportError = DiscoveryEventErrorLogger.reportError
			local v5

			if props.accessContext == nil then
				v5 = false
			else
				v5 = props.accessContext ~= ""
			end

			local v6 = {
				message = formatted,
				videoAssetId = videoAssetId,
				reason = reason,
				hasAccessContext = tostring(v5),
				source = 0,
				sourceId = 0
			}
			local source

			if videoAnalyticsData then
				source = videoAnalyticsData.source
			end

			v6.source = source
			local sourceId

			if videoAnalyticsData then
				sourceId = videoAnalyticsData.sourceId
			end

			v6.sourceId = sourceId
			reportError("VideoLoadFailure", formatted, v6)

			if props.onVideoLoadFailed then
				props.onVideoLoadFailed(reason)
			end
		end, {
			props.video,
			props.accessContext,
			props.videoAnalyticsContext,
			props.onVideoLoadFailed
		})
	end

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		local ref = React.useRef(v4)
		ref.current = v4
		React.useEffect(function()
			if not v3 and props.shouldStartPlayback and ref.current then
				ref.current("InvalidEdits")
			end
		end, { v3, props.shouldStartPlayback, props.video })
	end

	React.useEffect(function()
		if props.onMutedChanged then
			props.onMutedChanged(state2)
		end
	end, { props.onMutedChanged, state2 })

	local onMuteButtonActivated = React.useCallback(function()
		setState2(function(p): boolean
			if props.onMuteButtonActivated then
				props.onMuteButtonActivated(p)
			end

			return not p
		end)
	end, { props.onMuteButtonActivated })
	local muteButtonConfig = React.useMemo(function()
		if props.showMuteButton then
			return { muted = state2, onMuteButtonActivated = onMuteButtonActivated }
		end

		return nil
	end, { props.showMuteButton, state2, onMuteButtonActivated })
	local ref

	if
		FFlagLuaAppEdpMediaGalleryAutoAdvance
		or FFlagLuaAppEdpMediaGalleryFullScreen
		or FFlagLuaAppEdpConsoleMediaGalleryVideo
		or FFlagLuaAppEnableHomepageOneByTwoTile
	then
		ref = React.useRef(nil)
	else
		ref = nil
	end

	local progressBinding, v5

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		progressBinding, v5 = React.useBinding(0)
	else
		v5 = nil
		progressBinding = nil
	end

	if FFlagLuaAppEdpMediaGalleryAutoAdvance or FFlagLuaAppEdpMediaGalleryFullScreen then
		local useEffect = React.useEffect
		local function fn()
			local current = ref.current

			if
				props.shouldStartPlayback
				and (FFlagLuaAppEdpMediaGalleryAutoAdvance and props.onVideoProgressChanged or FFlagLuaAppEdpMediaGalleryFullScreen and props.showProgressBar)
				and current
			then
				local renderSteppedConnection = RunService.RenderStepped:Connect(function()
					local v6

					if FFlagLuaAppVideoPlayerTrimAndMusic and v2 and v2.trim then
						local playbackRange, v7 = getVideoEdits.getPlaybackRange(current.TimeLength, v2.trim)
						v6 = not (playbackRange < v7) and 0
							or math.clamp((current.TimePosition - playbackRange) / (v7 - playbackRange), 0, 1)
					end

					if FFlagLuaAppEdpMediaGalleryAutoAdvance and props.onVideoProgressChanged then
						local onVideoProgressChanged = props.onVideoProgressChanged
						local v7

						if FFlagLuaAppVideoPlayerTrimAndMusic and v6 ~= nil then
							v7 = v6
						else
							v7 = not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength
						end

						onVideoProgressChanged(v7)
					end

					if FFlagLuaAppEdpMediaGalleryFullScreen and props.showProgressBar then
						if not FFlagLuaAppVideoPlayerTrimAndMusic or v6 == nil then
							v6 = not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength
						end

						v5(v6)
					end
				end)

				return function()
					renderSteppedConnection:Disconnect()

					if FFlagLuaAppEdpMediaGalleryAutoAdvance and props.onVideoProgressChanged then
						props.onVideoProgressChanged(0)
					end

					if FFlagLuaAppEdpMediaGalleryFullScreen and props.showProgressBar then
						v5(0)
					end
				end
			end

			return nil
		end

		local shouldStartPlayback = props.shouldStartPlayback
		local onVideoProgressChanged

		if FFlagLuaAppEdpMediaGalleryAutoAdvance then
			onVideoProgressChanged = props.onVideoProgressChanged
		end

		local showProgressBar

		if FFlagLuaAppEdpMediaGalleryFullScreen then
			showProgressBar = props.showProgressBar
		end

		local v6

		if FFlagLuaAppVideoPlayerTrimAndMusic then
			v6 = v2
		end

		useEffect(fn, { shouldStartPlayback, onVideoProgressChanged, showProgressBar, v6 })
	end

	if FFlagLuaAppEnableHomepageOneByTwoTile then
		React.useEffect(function()
			local onAspectRatioChanged = props.onAspectRatioChanged
			local current = ref and ref.current

			if not (onAspectRatioChanged and current) then
				return
			end

			local v6 = nil
			local function report() -- 1 equivalent call inferred from this helper
				local resolution = current.Resolution

				if resolution.X > 0 and resolution.Y > 0 then
					local v7 = resolution.X / resolution.Y

					if v7 ~= v6 then
						v6 = v7
						onAspectRatioChanged(v7)
					end
				end
			end

			local resolutionChangedConnection = current:GetPropertyChangedSignal("Resolution"):Connect(report)
			report() -- inferred equivalent call
			return function()
				resolutionChangedConnection:Disconnect()
			end
		end, { props.onAspectRatioChanged })
	end

	local state3 = nil
	local setState3 = nil
	local v6, v7, v8, playButtonConfig, progressBarConfig

	if FFlagLuaAppEdpMediaGalleryFullScreen or FFlagLuaAppEdpConsoleMediaGalleryVideo then
		state3, setState3 = React.useState(false)

		local useCallback = React.useCallback
		local function fn(p)
			local current = ref.current

			if not current then
				reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoAction requires a valid videoFrame")

				return
			end

			local source, sourceId, v9

			if props.videoAnalyticsContext then
				source = props.videoAnalyticsContext.videoAnalyticsData.source
				sourceId = props.videoAnalyticsContext.videoAnalyticsData.sourceId
				v9 = props.videoAnalyticsContext.getPlaybackSessionId()

				if not (source and sourceId and v9) then
					reportWarning(
						LoggingProtocol.default,
						"EventLogging",
						`reportVideoAction requires a valid {source and "" or "source "}{sourceId and "" or "sourceId "}{v9 and "" or "playbackSessionId"}`
					)
				end
			end

			local videoAssetDuration

			if FFlagLuaAppVideoPlayerTrimAndMusic and v2 then
				local playbackRange, v10 = getVideoEdits.getPlaybackRange(current.TimeLength, v2.trim)
				videoAssetDuration = v10 - playbackRange
			end

			local reportVideoAction = VideoLogger.reportVideoAction
			local v10 = {
				videoAssetId = props.video,
				source = source or "",
				sourceId = sourceId or "",
				playbackSessionId = v9 or "",
				videoAssetDuration = 0,
				isVisible = true,
				isAudible = 0,
				volumeLevel = 0
			}

			if not FFlagLuaAppVideoPlayerTrimAndMusic or videoAssetDuration == nil then
				videoAssetDuration = current.TimeLength
			end

			v10.videoAssetDuration = videoAssetDuration
			local isAudible

			if FFlagLuaAppVideoPlayerTrimAndMusic then
				isAudible = not state2
			else
				isAudible = current.Volume ~= 0
			end

			v10.isAudible = isAudible
			local volumeLevel

			if FFlagLuaAppVideoPlayerTrimAndMusic then
				volumeLevel = state2 and 0 or 1
			else
				volumeLevel = current.Volume == 0 and 0 or 1
			end

			v10.volumeLevel = volumeLevel
			reportVideoAction(p, nil, v10)
		end

		local video = props.video
		local videoAnalyticsContext = props.videoAnalyticsContext
		local v9

		if FFlagLuaAppVideoPlayerTrimAndMusic then
			v9 = v2
		end

		local v10

		if FFlagLuaAppVideoPlayerTrimAndMusic then
			v10 = state2
		end

		local v11 = useCallback(fn, { video, videoAnalyticsContext, v9, v10 })

		v6 = React.useCallback(function()
			local current = ref.current

			if not current then
				return
			end

			if state3 then
				current:Pause()
				return
			end

			if math.abs(current.TimePosition - current.TimeLength) <= v then
				current.TimePosition = 0
			end

			current:Play()
		end, { state3 })

		v7 = Responsive.usePreferredInput() == Responsive.Input.Directional
		React.useEffect(function()
			local connections = {}

			if props.toggleVideoPlaybackSignal then
				table.insert(connections, props.toggleVideoPlaybackSignal:connect(v6))
			end

			if props.toggleMuteSignal then
				table.insert(connections, props.toggleMuteSignal:connect(onMuteButtonActivated))
			end

			return function()
				for _, connection in connections do
					if connection then
						connection:disconnect()
					end
				end
			end
		end, { props.toggleVideoPlaybackSignal, props.toggleMuteSignal, v6, onMuteButtonActivated })

		v8 = React.useCallback(function()
			if props.onVideoPlayerActivated then
				props.onVideoPlayerActivated()
			else
				v6()
			end
		end, { props.onVideoPlayerActivated, v6 })

		playButtonConfig = React.useMemo(function()
			if props.showPlayButton then
				return { isVideoPlaying = state3, onPlayButtonActivated = v6 }
			end

			return nil
		end, { props.showPlayButton, state3, v6 })

		progressBarConfig = React.useMemo(function()
			if props.showProgressBar then
				return { progressBinding = progressBinding }
			end

			return nil
		end, { props.showProgressBar, progressBinding })

		React.useEffect(function()
			local current = ref.current

			if not (props.shouldStartPlayback and current) then
				return nil
			end

			local playedConnection = current.Played:Connect(function()
				setState3(true)
				v11(VideoActions.play)
			end)

			local pausedConnection = current.Paused:Connect(function()
				setState3(false)
				v11(VideoActions.pause)
			end)

			local endedConnection = current.Ended:Connect(function()
				setState3(false)
			end)

			return function()
				playedConnection:Disconnect()
				pausedConnection:Disconnect()
				endedConnection:Disconnect()
			end
		end, { props.shouldStartPlayback, v11 })

		React.useEffect(function(): nil
			if not props.shouldStartPlayback then
				setState(false)
				setState3(false)
			end

			return nil
		end, { props.shouldStartPlayback })

		if FFlagLuaAppMediaGalleryGamepadSupport then
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
		v6 = nil
	end

	local createElement = React.createElement
	local v9 = FFlagLuaAppVideoTileDisableActivation and props.disableActivation and "Frame"
		or FFlagLuaAppEdpMediaGalleryFullScreen and "TextButton"
		or "Frame"

	local v10 = {
		["Size"] = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = props.ZIndex
	}
	local text

	if not (FFlagLuaAppVideoTileDisableActivation and props.disableActivation) then
		text = FFlagLuaAppEdpMediaGalleryFullScreen and "" or nil
	end

	v10.Text = text

	local activated = React.Event.Activated

	if FFlagLuaAppVideoTileDisableActivation and props.disableActivation then
		v8 = nil
	elseif not FFlagLuaAppEdpMediaGalleryFullScreen then
		v8 = nil
	end

	v10[activated] = v8

	v10.Selectable = false
	local corner

	if props.cornerRadius then
		corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	local createElement2 = React.createElement
	local v11 = {
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
	local accessContext

	if FFlagLuaAppHomeMomentVideoFallback then
		accessContext = props.accessContext
	end

	v11.accessContext = accessContext
	local edits

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		edits = v2
	end

	v11.edits = edits
	v11.thumbnail = props.thumbnail
	local thumbnailComponentOverride

	if FFlagLuaAppSduiVideoThumbnail then
		thumbnailComponentOverride = props.thumbnailComponentOverride
	end

	v11.thumbnailComponentOverride = thumbnailComponentOverride

	v11.shouldStartPlayback = props.shouldStartPlayback and (not FFlagLuaAppVideoPlayerTrimAndMusic or v3)

	v11.muted = state2
	v11.looped = props.looped
	v11.ScaleType = props.ScaleType
	v11.cornerRadius = props.cornerRadius
	v11.onVideoLoaded = onVideoLoaded
	v11.onVideoLooped = props.onVideoLooped
	local onVideoEnded

	if FFlagLuaAppEdpMediaGalleryAutoAdvance then
		onVideoEnded = props.onVideoEnded
	end

	v11.onVideoEnded = onVideoEnded

	if not FFlagLuaAppVideoLoadFailureFallback then
		v4 = nil
	end

	v11.onVideoLoadFailed = v4
	local ref2

	if
		FFlagLuaAppEdpMediaGalleryAutoAdvance
		or FFlagLuaAppEdpMediaGalleryFullScreen
		or FFlagLuaAppEdpConsoleMediaGalleryVideo
		or FFlagLuaAppEnableHomepageOneByTwoTile
	then
		ref2 = ref
	end

	v11.ref = ref2
	local v12 = {
		Corner = corner,
		Video = createElement2(LoadableVideoFrame, v11),
		PlayButton = 0,
		BottomOverlay = 0
	}
	local playButton

	if not ((FFlagLuaAppVideoTileHideCenterPlayButton or FFlagLuaAppEnableHomepageOneByTwoTile) and props.hideCenterPlayButton or not (FFlagLuaAppEdpMediaGalleryFullScreen or FFlagLuaAppMediaGalleryGamepadSupport) or not state or state3 or FFlagLuaAppMediaGalleryGamepadSupport and v6 == nil) then
		playButton = React.createElement(RoundIconButton, {
			icon = "play-large",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = 2,
			Selectable = not v7 and nil,
			onActivated = v6
		})
	end

	v12.PlayButton = playButton
	local bottomOverlay

	if showMuteButton then
		local createElement3 = React.createElement
		local v13 = {
			cornerRadius = props.cornerRadius,
			ZIndex = 10,
			videoLoaded = state,
			muteButtonConfig = muteButtonConfig,
			playButtonConfig = 0,
			progressBarConfig = 0
		}

		if not FFlagLuaAppEdpMediaGalleryFullScreen then
			playButtonConfig = nil
		end

		v13.playButtonConfig = playButtonConfig

		if not FFlagLuaAppEdpMediaGalleryFullScreen then
			progressBarConfig = nil
		end

		v13.progressBarConfig = progressBarConfig
		bottomOverlay = createElement3(VideoPlayerBottomOverlay, v13)
	end

	v12.BottomOverlay = bottomOverlay
	return createElement(v9, v10, v12)
end

return VideoPlayer
