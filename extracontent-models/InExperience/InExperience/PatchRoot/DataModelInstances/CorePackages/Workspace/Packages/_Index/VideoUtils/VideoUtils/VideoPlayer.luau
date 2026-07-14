local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("VideoUtils").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)

require(Parent.AppCommonLib)

local LoadableVideoFrame = require(script.Parent.LoadableVideoFrame)
local RoundIconButton = require(script.Parent.RoundIconButton)
local VideoActions = require(script.Parent.Analytics.Enums).VideoActions

require(script.Parent.Analytics.VideoAnalyticsTypes)

local VideoLogger = require(script.Parent.Analytics.VideoLogger)
local VideoPlayerBottomOverlay = require(script.Parent.VideoPlayerBottomOverlay)
local reportWarning = require(Parent.DiscoveryAnalytics).Points.reportWarning
local FFlagLuaAppEdpMediaGalleryAutoAdvance = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryAutoAdvance
local FFlagLuaAppEdpMediaGalleryFullScreen = require(Parent.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagLuaAppVideoTileDisableActivation = require(Parent.SharedFlags).FFlagLuaAppVideoTileDisableActivation
local FFlagLuaAppVideoTileHideCenterPlayButton = require(Parent.SharedFlags).FFlagLuaAppVideoTileHideCenterPlayButton
local FFlagLuaAppEdpConsoleMediaGalleryVideo = require(Parent.SharedFlags).FFlagLuaAppEdpConsoleMediaGalleryVideo
local FFlagLuaAppEnableHomepageOneByTwoTile = require(Parent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile
local v18 = game:DefineFastInt("VideoPlayerPlaybackEndThresholdInMs", 100) / 1000

local function VideoPlayer(t1: {[any]: any}) -- line: 81
	-- upvalues: FFlagLuaAppEdpMediaGalleryFullScreen (copy), React (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpConsoleMediaGalleryVideo (copy), FFlagLuaAppEnableHomepageOneByTwoTile (copy), RunService (copy), reportWarning (copy), LoggingProtocol (copy), VideoLogger (copy), v18 (copy), Responsive (copy), VideoActions (copy), FFlagLuaAppVideoTileDisableActivation (copy), LoadableVideoFrame (copy), FFlagLuaAppVideoTileHideCenterPlayButton (copy), RoundIconButton (copy), VideoPlayerBottomOverlay (copy)
	local v21 = t1.showMuteButton or FFlagLuaAppEdpMediaGalleryFullScreen and (t1.showPlayButton or t1.showProgressBar)
	local v22, v23 = React.useState(false)
	local v24, v25 = React.useState(t1.muted)
	local v26 = React.useCallback(function(n1: number, n2: number) -- line: 89
		-- upvalues: v23 (copy), t1 (copy)
		v23(true)

		if t1.onVideoLoaded then
			t1.onVideoLoaded(n1, n2)
		end
	end, { t1.onVideoLoaded })

	React.useEffect(function() -- line: 97
		-- upvalues: t1 (copy), v24 (copy)
		if t1.onMutedChanged then
			t1.onMutedChanged(v24)
		end
	end, {
		t1.onMutedChanged,
		v24
	})

	local v27 = React.useCallback(function() -- line: 103
		-- upvalues: v25 (copy), t1 (copy)
		v25(function(p1) -- line: 104
			-- upvalues: t1 (copy)
			if t1.onMuteButtonActivated then
				t1.onMuteButtonActivated(p1)
			end

			return not p1
		end)
	end, { t1.onMuteButtonActivated })
	local v28 = React.useMemo(function() -- line: 112
		-- upvalues: t1 (copy), v24 (copy), v27 (copy)
		if t1.showMuteButton then
			return {
				muted = v24,
				onMuteButtonActivated = v27
			}
		end

		return nil
	end, {
		t1.showMuteButton,
		v24,
		v27
	})
	local u29 = nil

	if FFlagLuaAppEdpMediaGalleryAutoAdvance or (FFlagLuaAppEdpMediaGalleryFullScreen or FFlagLuaAppEdpConsoleMediaGalleryVideo or FFlagLuaAppEnableHomepageOneByTwoTile) then
		u29 = React.useRef(nil)
	end

	local u30 = nil
	local u31 = nil

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		local v32, v33 = React.useBinding(0)

		u30 = v32
		u31 = v33
	end

	if FFlagLuaAppEdpMediaGalleryAutoAdvance or FFlagLuaAppEdpMediaGalleryFullScreen then
		React.useEffect(function() -- line: 139
			-- upvalues: u29 (ref), t1 (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), RunService (copy), u31 (ref)
			local current = u29.current

			if t1.shouldStartPlayback and ((FFlagLuaAppEdpMediaGalleryAutoAdvance and t1.onVideoProgressChanged or FFlagLuaAppEdpMediaGalleryFullScreen and t1.showProgressBar) and current) then
				local connection = RunService.RenderStepped:Connect(function() -- line: 147
					-- upvalues: FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), t1 (copy), current (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), u31 (ref)
					if FFlagLuaAppEdpMediaGalleryAutoAdvance and t1.onVideoProgressChanged then
						t1.onVideoProgressChanged(not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength)
					end

					if FFlagLuaAppEdpMediaGalleryFullScreen and t1.showProgressBar then
						u31(not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength)
					end
				end)

				return function() -- line: 161
					-- upvalues: connection (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), t1 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), u31 (ref)
					connection:Disconnect()

					if FFlagLuaAppEdpMediaGalleryAutoAdvance and t1.onVideoProgressChanged then
						t1.onVideoProgressChanged(0)
					end

					if FFlagLuaAppEdpMediaGalleryFullScreen and t1.showProgressBar then
						u31(0)
					end
				end
			end

			return nil
		end, {
			t1.shouldStartPlayback,
			if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else t1.onVideoProgressChanged,
			if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t1.showProgressBar
		})
	end

	if FFlagLuaAppEnableHomepageOneByTwoTile then
		React.useEffect(function() -- line: 185
			-- upvalues: t1 (copy), u29 (ref)
			local onAspectRatioChanged = t1.onAspectRatioChanged
			local v49 = u29 and u29.current

			if not onAspectRatioChanged or not v49 then
				return
			end

			local u50 = nil

			local function report() -- line: 193
				-- upvalues: v49 (copy), u50 (ref), onAspectRatioChanged (copy)
				local Resolution = v49.Resolution

				if Resolution.X > 0 and Resolution.Y > 0 then
					local v71 = Resolution.X / Resolution.Y

					if v71 ~= u50 then
						u50 = v71
						onAspectRatioChanged(v71)
					end
				end
			end

			local connection = v49:GetPropertyChangedSignal("Resolution"):Connect(report)
			local Resolution = v49.Resolution

			if Resolution.X > 0 and Resolution.Y > 0 then
				local v54 = Resolution.X / Resolution.Y

				if v54 ~= u50 then
					u50 = v54
					onAspectRatioChanged(v54)
				end
			end

			return function() -- line: 207
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { t1.onAspectRatioChanged })
	end

	local u34 = nil
	local u35 = nil
	local u36 = nil
	local v37 = nil
	local v38 = nil
	local v39 = nil
	local v40 = nil

	if FFlagLuaAppEdpMediaGalleryFullScreen or FFlagLuaAppEdpConsoleMediaGalleryVideo then
		local v41, v42 = React.useState(false)

		u34 = v41
		u35 = v42

		local v43 = React.useCallback(function(p2) -- line: 223
			-- upvalues: u29 (ref), reportWarning (copy), LoggingProtocol (copy), t1 (copy), VideoLogger (copy)
			local current = u29.current

			if not current then
				reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoAction requires a valid videoFrame")

				return
			end

			local source = nil
			local sourceId = nil
			local v59 = nil

			if t1.videoAnalyticsContext then
				source = t1.videoAnalyticsContext.videoAnalyticsData.source
				sourceId = t1.videoAnalyticsContext.videoAnalyticsData.sourceId
				v59 = t1.videoAnalyticsContext.getPlaybackSessionId()

				if not source or not sourceId or not v59 then
					local v60 = source and "" or "source "
					local v61 = sourceId and "" or "sourceId "
					local v62 = v59 and "" or "playbackSessionId"

					reportWarning(LoggingProtocol.default, "EventLogging", `reportVideoAction requires a valid { v60 }{ v61 }{ v62 }`)
				end
			end

			VideoLogger.reportVideoAction(p2, nil, {
				isVisible = true,
				videoAssetId = t1.video,
				source = source or "",
				sourceId = sourceId or "",
				playbackSessionId = v59 or "",
				videoAssetDuration = current.TimeLength,
				isAudible = current.Volume ~= 0,
				volumeLevel = current.Volume ~= 0 and 1 or 0
			})
		end, {
			t1.video,
			t1.videoAnalyticsContext
		})

		u36 = React.useCallback(function() -- line: 264
			-- upvalues: u29 (ref), u34 (ref), v18 (copy)
			local current = u29.current

			if not current then
				return
			end

			if u34 then
				current:Pause()

				return
			end

			if math.abs(current.TimePosition - current.TimeLength) <= v18 then
				current.TimePosition = 0
			end

			current:Play()
		end, { u34 })
		v40 = Responsive.usePreferredInput() == Responsive.Input.Directional
		React.useEffect(function() -- line: 284
			-- upvalues: t1 (copy), u36 (ref), v27 (copy)
			local t2 = {}

			if t1.toggleVideoPlaybackSignal then
				table.insert(t2, t1.toggleVideoPlaybackSignal:connect(u36))
			end

			if t1.toggleMuteSignal then
				table.insert(t2, t1.toggleMuteSignal:connect(v27))
			end

			return function() -- line: 292
				-- upvalues: t2 (copy)
				for _, v73 in t2 do
					if v73 then
						v73:disconnect()
					end
				end
			end
		end, {
			t1.toggleVideoPlaybackSignal,
			t1.toggleMuteSignal,
			u36,
			v27
		})
		v37 = React.useCallback(function() -- line: 303
			-- upvalues: t1 (copy), u36 (ref)
			if t1.onVideoPlayerActivated then
				t1.onVideoPlayerActivated()

				return
			end

			u36()
		end, {
			t1.onVideoPlayerActivated,
			u36
		})
		v38 = React.useMemo(function() -- line: 313
			-- upvalues: t1 (copy), u34 (ref), u36 (ref)
			if t1.showPlayButton then
				return {
					isVideoPlaying = u34,
					onPlayButtonActivated = u36
				}
			end

			return nil
		end, {
			t1.showPlayButton,
			u34,
			u36
		})
		v39 = React.useMemo(function() -- line: 322
			-- upvalues: t1 (copy), u30 (ref)
			if t1.showProgressBar then
				return {
					progressBinding = u30
				}
			end

			return nil
		end, {
			t1.showProgressBar,
			u30
		})
		React.useEffect(function() -- line: 330
			-- upvalues: u29 (ref), t1 (copy), u35 (ref), v43 (copy), VideoActions (copy)
			local current = u29.current

			if not t1.shouldStartPlayback or not current then
				return nil
			end

			local connection = current.Played:Connect(function() -- line: 337
				-- upvalues: u35 (ref), v43 (copy), VideoActions (copy)
				u35(true)
				v43(VideoActions.play)
			end)
			local connection2 = current.Paused:Connect(function() -- line: 342
				-- upvalues: u35 (ref), v43 (copy), VideoActions (copy)
				u35(false)
				v43(VideoActions.pause)
			end)
			local connection3 = current.Ended:Connect(function() -- line: 347
				-- upvalues: u35 (ref)
				u35(false)
			end)

			return function() -- line: 351
				-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
				connection:Disconnect()
				connection2:Disconnect()
				connection3:Disconnect()
			end
		end, {
			t1.shouldStartPlayback,
			v43
		})
		React.useEffect(function() -- line: 359
			-- upvalues: t1 (copy), v23 (copy), u35 (ref)
			if not t1.shouldStartPlayback then
				v23(false)
				u35(false)
			end

			return nil
		end, { t1.shouldStartPlayback })
	end

	return React.createElement(if not FFlagLuaAppVideoTileDisableActivation or not t1.disableActivation then not FFlagLuaAppEdpMediaGalleryFullScreen and "Frame" or "TextButton" else "Frame", {
		Size = t1.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = t1.ZIndex,
		Text = if not FFlagLuaAppVideoTileDisableActivation or not t1.disableActivation then if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else "" else nil,
		[React.Event.Activated] = if not FFlagLuaAppVideoTileDisableActivation or not t1.disableActivation then if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v37 else nil,
		Selectable = false
	}, {
		Corner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cornerRadius)
		}),
		Video = React.createElement(LoadableVideoFrame, {
			video = t1.video,
			thumbnail = t1.thumbnail,
			shouldStartPlayback = t1.shouldStartPlayback,
			muted = v24,
			looped = t1.looped,
			ScaleType = t1.ScaleType,
			cornerRadius = t1.cornerRadius,
			onVideoLoaded = v26,
			onVideoLooped = t1.onVideoLooped,
			onVideoEnded = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else t1.onVideoEnded,
			ref = if not FFlagLuaAppEdpMediaGalleryAutoAdvance and (not FFlagLuaAppEdpMediaGalleryFullScreen and (not FFlagLuaAppEdpConsoleMediaGalleryVideo and not FFlagLuaAppEnableHomepageOneByTwoTile)) then nil else u29
		}),
		PlayButton = if not FFlagLuaAppVideoTileHideCenterPlayButton and not FFlagLuaAppEnableHomepageOneByTwoTile or not t1.hideCenterPlayButton then if not FFlagLuaAppEdpMediaGalleryFullScreen or (not v22 or u34) then nil else React.createElement(RoundIconButton, {
			icon = "play-large",
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Selectable = not v40 and nil,
			onActivated = u36
		}) else nil,
		BottomOverlay = if not v21 then nil else React.createElement(VideoPlayerBottomOverlay, {
			ZIndex = 10,
			cornerRadius = t1.cornerRadius,
			videoLoaded = v22,
			muteButtonConfig = v28,
			playButtonConfig = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v38,
			progressBarConfig = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v39
		})
	})
end

return VideoPlayer
