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
local v16 = game:DefineFastInt("VideoPlayerPlaybackEndThresholdInMs", 100) / 1000

local function VideoPlayer(t1: {[any]: any}) -- line: 76
	-- upvalues: FFlagLuaAppEdpMediaGalleryFullScreen (copy), React (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), RunService (copy), reportWarning (copy), LoggingProtocol (copy), VideoLogger (copy), v16 (copy), Responsive (copy), VideoActions (copy), FFlagLuaAppVideoTileDisableActivation (copy), LoadableVideoFrame (copy), FFlagLuaAppVideoTileHideCenterPlayButton (copy), RoundIconButton (copy), VideoPlayerBottomOverlay (copy)
	local v19 = t1.showMuteButton or FFlagLuaAppEdpMediaGalleryFullScreen and (t1.showPlayButton or t1.showProgressBar)
	local v20, v21 = React.useState(false)
	local v22, v23 = React.useState(t1.muted)
	local v24 = React.useCallback(function(n1: number, n2: number) -- line: 84
		-- upvalues: v21 (copy), t1 (copy)
		v21(true)

		if t1.onVideoLoaded then
			t1.onVideoLoaded(n1, n2)
		end
	end, { t1.onVideoLoaded })

	React.useEffect(function() -- line: 92
		-- upvalues: t1 (copy), v22 (copy)
		if t1.onMutedChanged then
			t1.onMutedChanged(v22)
		end
	end, {
		t1.onMutedChanged,
		v22
	})

	local v25 = React.useCallback(function() -- line: 98
		-- upvalues: v23 (copy), t1 (copy)
		v23(function(p1) -- line: 99
			-- upvalues: t1 (copy)
			if t1.onMuteButtonActivated then
				t1.onMuteButtonActivated(p1)
			end

			return not p1
		end)
	end, { t1.onMuteButtonActivated })
	local v26 = React.useMemo(function() -- line: 107
		-- upvalues: t1 (copy), v22 (copy), v25 (copy)
		if t1.showMuteButton then
			return {
				muted = v22,
				onMuteButtonActivated = v25
			}
		end

		return nil
	end, {
		t1.showMuteButton,
		v22,
		v25
	})
	local u27 = nil

	if FFlagLuaAppEdpMediaGalleryAutoAdvance or FFlagLuaAppEdpMediaGalleryFullScreen then
		u27 = React.useRef(nil)
	end

	local u28 = nil
	local u29 = nil

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		local v30, v31 = React.useBinding(0)

		u28 = v30
		u29 = v31
	end

	if FFlagLuaAppEdpMediaGalleryAutoAdvance or FFlagLuaAppEdpMediaGalleryFullScreen then
		React.useEffect(function() -- line: 129
			-- upvalues: u27 (ref), t1 (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), RunService (copy), u29 (ref)
			local current = u27.current

			if t1.shouldStartPlayback and ((FFlagLuaAppEdpMediaGalleryAutoAdvance and t1.onVideoProgressChanged or FFlagLuaAppEdpMediaGalleryFullScreen and t1.showProgressBar) and current) then
				local connection = RunService.RenderStepped:Connect(function() -- line: 137
					-- upvalues: FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), t1 (copy), current (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), u29 (ref)
					if FFlagLuaAppEdpMediaGalleryAutoAdvance and t1.onVideoProgressChanged then
						t1.onVideoProgressChanged(not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength)
					end

					if FFlagLuaAppEdpMediaGalleryFullScreen and t1.showProgressBar then
						u29(not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength)
					end
				end)

				return function() -- line: 151
					-- upvalues: connection (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), t1 (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), u29 (ref)
					connection:Disconnect()

					if FFlagLuaAppEdpMediaGalleryAutoAdvance and t1.onVideoProgressChanged then
						t1.onVideoProgressChanged(0)
					end

					if FFlagLuaAppEdpMediaGalleryFullScreen and t1.showProgressBar then
						u29(0)
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

	local u32 = nil
	local u33 = nil
	local u34 = nil
	local v35 = nil
	local v36 = nil
	local v37 = nil
	local v38 = nil

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		local v39, v40 = React.useState(false)

		u32 = v39
		u33 = v40

		local v41 = React.useCallback(function(p2) -- line: 184
			-- upvalues: u27 (ref), reportWarning (copy), LoggingProtocol (copy), t1 (copy), VideoLogger (copy)
			local current = u27.current

			if not current then
				reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoAction requires a valid videoFrame")

				return
			end

			local source = nil
			local sourceId = nil
			local v50 = nil

			if t1.videoAnalyticsContext then
				source = t1.videoAnalyticsContext.videoAnalyticsData.source
				sourceId = t1.videoAnalyticsContext.videoAnalyticsData.sourceId
				v50 = t1.videoAnalyticsContext.getPlaybackSessionId()

				if not source or not sourceId or not v50 then
					local v51 = source and "" or "source "
					local v52 = sourceId and "" or "sourceId "
					local v53 = v50 and "" or "playbackSessionId"

					reportWarning(LoggingProtocol.default, "EventLogging", `reportVideoAction requires a valid { v51 }{ v52 }{ v53 }`)
				end
			end

			VideoLogger.reportVideoAction(p2, nil, {
				isVisible = true,
				videoAssetId = t1.video,
				source = source or "",
				sourceId = sourceId or "",
				playbackSessionId = v50 or "",
				videoAssetDuration = current.TimeLength,
				isAudible = current.Volume ~= 0,
				volumeLevel = current.Volume ~= 0 and 1 or 0
			})
		end, {
			t1.video,
			t1.videoAnalyticsContext
		})

		u34 = React.useCallback(function() -- line: 225
			-- upvalues: u27 (ref), u32 (ref), v16 (copy)
			local current = u27.current

			if not current then
				return
			end

			if u32 then
				current:Pause()

				return
			end

			if math.abs(current.TimePosition - current.TimeLength) <= v16 then
				current.TimePosition = 0
			end

			current:Play()
		end, { u32 })
		v38 = Responsive.usePreferredInput() == Responsive.Input.Directional
		React.useEffect(function() -- line: 245
			-- upvalues: t1 (copy), u34 (ref), v25 (copy)
			local t2 = {}

			if t1.toggleVideoPlaybackSignal then
				table.insert(t2, t1.toggleVideoPlaybackSignal:connect(u34))
			end

			if t1.toggleMuteSignal then
				table.insert(t2, t1.toggleMuteSignal:connect(v25))
			end

			return function() -- line: 253
				-- upvalues: t2 (copy)
				for _, v62 in t2 do
					if v62 then
						v62:disconnect()
					end
				end
			end
		end, {
			t1.toggleVideoPlaybackSignal,
			t1.toggleMuteSignal,
			u34,
			v25
		})
		v35 = React.useCallback(function() -- line: 264
			-- upvalues: t1 (copy), u34 (ref)
			if t1.onVideoPlayerActivated then
				t1.onVideoPlayerActivated()

				return
			end

			u34()
		end, {
			t1.onVideoPlayerActivated,
			u34
		})
		v36 = React.useMemo(function() -- line: 274
			-- upvalues: t1 (copy), u32 (ref), u34 (ref)
			if t1.showPlayButton then
				return {
					isVideoPlaying = u32,
					onPlayButtonActivated = u34
				}
			end

			return nil
		end, {
			t1.showPlayButton,
			u32,
			u34
		})
		v37 = React.useMemo(function() -- line: 283
			-- upvalues: t1 (copy), u28 (ref)
			if t1.showProgressBar then
				return {
					progressBinding = u28
				}
			end

			return nil
		end, {
			t1.showProgressBar,
			u28
		})
		React.useEffect(function() -- line: 291
			-- upvalues: u27 (ref), t1 (copy), u33 (ref), v41 (copy), VideoActions (copy)
			local current = u27.current

			if not t1.shouldStartPlayback or not current then
				return nil
			end

			local connection = current.Played:Connect(function() -- line: 298
				-- upvalues: u33 (ref), v41 (copy), VideoActions (copy)
				u33(true)
				v41(VideoActions.play)
			end)
			local connection2 = current.Paused:Connect(function() -- line: 303
				-- upvalues: u33 (ref), v41 (copy), VideoActions (copy)
				u33(false)
				v41(VideoActions.pause)
			end)
			local connection3 = current.Ended:Connect(function() -- line: 308
				-- upvalues: u33 (ref)
				u33(false)
			end)

			return function() -- line: 312
				-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
				connection:Disconnect()
				connection2:Disconnect()
				connection3:Disconnect()
			end
		end, {
			t1.shouldStartPlayback,
			v41
		})
		React.useEffect(function() -- line: 320
			-- upvalues: t1 (copy), v21 (copy), u33 (ref)
			if not t1.shouldStartPlayback then
				v21(false)
				u33(false)
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
		[React.Event.Activated] = if not FFlagLuaAppVideoTileDisableActivation or not t1.disableActivation then if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v35 else nil,
		Selectable = false
	}, {
		Corner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cornerRadius)
		}),
		Video = React.createElement(LoadableVideoFrame, {
			video = t1.video,
			thumbnail = t1.thumbnail,
			shouldStartPlayback = t1.shouldStartPlayback,
			muted = v22,
			looped = t1.looped,
			ScaleType = t1.ScaleType,
			cornerRadius = t1.cornerRadius,
			onVideoLoaded = v24,
			onVideoLooped = t1.onVideoLooped,
			onVideoEnded = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else t1.onVideoEnded,
			ref = if not FFlagLuaAppEdpMediaGalleryAutoAdvance and not FFlagLuaAppEdpMediaGalleryFullScreen then nil else u27
		}),
		PlayButton = if not FFlagLuaAppVideoTileHideCenterPlayButton or not t1.hideCenterPlayButton then if not FFlagLuaAppEdpMediaGalleryFullScreen or (not v20 or u32) then nil else React.createElement(RoundIconButton, {
			icon = "play-large",
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Selectable = not v38 and nil,
			onActivated = u34
		}) else nil,
		BottomOverlay = if not v19 then nil else React.createElement(VideoPlayerBottomOverlay, {
			ZIndex = 10,
			cornerRadius = t1.cornerRadius,
			videoLoaded = v20,
			muteButtonConfig = v26,
			playButtonConfig = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v36,
			progressBarConfig = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v37
		})
	})
end

return VideoPlayer
