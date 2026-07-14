local RunService = game:GetService("RunService")
local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local MediaPlayer = require(ProfilePlatform.Components.Videos.MediaPlayer)
local VideoUtils = require(ProfilePlatformParent.VideoUtils)
local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local Responsive = require(ProfilePlatformParent.Responsive)
local useLastInput = Responsive.useLastInput
local FFlagLuaAppGameTileSelectionVideoPlayback = require(ProfilePlatformParent.SharedFlags).FFlagLuaAppGameTileSelectionVideoPlayback

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 38
	-- upvalues: React (copy), useLastInput (copy), RunService (copy), VideoPlaybackDetector (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), Responsive (copy), VideoPlaybackDetectionMethod (copy), MediaPlayer (copy)
	local videoId = t1.videoId
	local v15 = React.useRef(nil)
	local v16 = t1.isFullscreen or false
	local v17, v18 = React.useState(t1.isMuted == nil or t1.isMuted)
	local v19 = React.useRef(nil)
	local v20, v21 = React.useState(false)
	local v22 = useLastInput()
	local v23, v24 = React.useState(false)
	local v25, v26 = React.useState(0)

	React.useImperativeHandle(p1, function() -- line: 49
		-- upvalues: v15 (copy), v18 (copy), v17 (copy), v20 (copy), v25 (copy)
		return {
			setTimePosition = function(n1: number) -- line: 51
				-- upvalues: v15 (copy)
				local current = v15.current

				if current then
					current.TimePosition = n1
				end
			end,
			toggleMute = function() -- line: 57
				-- upvalues: v18 (copy), v17 (copy)
				v18(not v17)
			end,
			togglePlayPause = function() -- line: 60
				-- upvalues: v15 (copy), v20 (copy), v25 (copy)
				local current = v15.current

				if not current then
					return
				end

				if v20 then
					current:Pause()

					return
				end

				if current.TimePosition >= v25 - 0.2 then
					current.TimePosition = 0
				end

				current:Play()
			end
		}
	end, {
		v17,
		v20,
		v25
	})

	local v27 = React.useCallback(function() -- line: 77
		-- upvalues: v15 (copy), v17 (copy)
		local current = v15.current

		if current then
			current.Volume = not v17 and 1 or 0
		end
	end, { v17 })
	local v28 = React.useCallback(function() -- line: 84
		-- upvalues: React (copy)
		return (React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		}))
	end, {})
	local v29 = React.useCallback(function(_) -- line: 91
		-- upvalues: v15 (copy), v27 (copy), v26 (copy)
		local current = v15.current

		if not current then
			return
		end

		v27()
		v26(current.TimeLength)
	end, {})
	local v30 = React.useCallback(function() -- line: 100
		-- upvalues: v24 (copy)
		v24(true)
	end, {})
	local v31 = React.useCallback(function() -- line: 104
		-- upvalues: v24 (copy)
		v24(false)
	end, {})

	React.useEffect(function() -- line: 108
		-- upvalues: v27 (copy)
		v27()
	end, { v17 })
	React.useEffect(function() -- line: 113
		-- upvalues: v15 (copy), v25 (copy), v20 (copy)
		local current = v15.current

		if not current or v25 == 0 then
			return
		end

		if v20 and current.TimePosition >= v25 - 0.2 then
			current.TimePosition = 0
		end
	end, {
		v20,
		v25
	})
	React.useEffect(function() -- line: 124
		-- upvalues: v15 (copy), v25 (copy), t1 (copy)
		local current = v15.current

		if not current or v25 == 0 then
			return
		end

		if t1.initialTimePosition then
			if t1.initialTimePosition >= v25 - 0.2 then
				current.TimePosition = 0

				return
			end

			current.TimePosition = t1.initialTimePosition
		end
	end, {
		t1.initialTimePosition,
		v25
	})
	React.useEffect(function() -- line: 139
		-- upvalues: v15 (copy), v16 (copy), v21 (copy)
		local current = v15.current

		if current and v16 then
			current:Play()
			v21(true)
		end
	end, { v16 })
	React.useEffect(function() -- line: 147
		-- upvalues: v15 (copy), RunService (copy), v26 (copy), t1 (copy), v20 (copy), v17 (copy), v21 (copy)
		local current = v15.current

		if not current then
			return
		end

		local connection = RunService.RenderStepped:Connect(function() -- line: 153
			-- upvalues: current (copy), v26 (copy), t1 (copy), v20 (copy), v17 (copy)
			local currentTimePosition = current.TimePosition
			local TimeLength = current.TimeLength

			v26(TimeLength)

			if t1.onTimeUpdate then
				t1.onTimeUpdate(currentTimePosition)
			end

			if t1.onProgressUpdate then
				t1.onProgressUpdate(currentTimePosition, TimeLength, v20, v17)
			end
		end)
		local connection2 = current.Played:Connect(function() -- line: 165
			-- upvalues: v21 (copy)
			v21(true)
		end)
		local connection3 = current.Paused:Connect(function() -- line: 169
			-- upvalues: v21 (copy)
			v21(false)
		end)
		local connection4 = current.Ended:Connect(function() -- line: 173
			-- upvalues: v21 (copy)
			v21(false)
		end)

		return function() -- line: 177
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy), connection4 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
			connection4:Disconnect()
		end
	end, {
		v17,
		v20,
		t1.onProgressUpdate,
		t1.onTimeUpdate
	})

	local function handleExpand() -- line: 185
		-- upvalues: t1 (copy), v15 (copy)
		if t1.onExpandCallback then
			t1.onExpandCallback(v15.current and v15.current.TimePosition or 0)
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = not v16,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.fromScale(1, 1),
		ZIndex = not v16 and 1 or 1000,
		ref = v19,
		[React.Event.MouseEnter] = v30,
		[React.Event.MouseLeave] = v31
	}, {
		VideoPlaybackDetector = if v16 then nil else React.createElement(VideoPlaybackDetector, {
			isVideoEligible = true,
			itemIndex = nil,
			videoDwellTimeInSec = 1,
			videoVisiblePercent = 80,
			isHovered = v23,
			isHoverSupported = if not FFlagLuaAppGameTileSelectionVideoPlayback then v22 ~= Responsive.Input.Touch else nil,
			playbackDetectionMethod = if not FFlagLuaAppGameTileSelectionVideoPlayback or v22 == Responsive.Input.Touch then nil else VideoPlaybackDetectionMethod.Hover,
			onPlaybackChange = function(b1: boolean) -- line: 213
				-- upvalues: v21 (copy)
				v21(b1)
			end,
			itemFrameRef = v19,
			videoKey = videoId,
			videoPlaybackCoordinator = t1.videoPlaybackCoordinator
		}),
		VideoContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1),
			ZIndex = not v16 and 1 or 1001
		}, {
			VideoContent = React.createElement(MediaPlayer, {
				cornerRadius = t1.cornerRadius,
				isFullScreen = v16,
				Looped = t1.looped,
				onExpandCallback = handleExpand,
				onVideoLoaded = v29,
				Playing = v20,
				Position = UDim2.fromScale(0.5, 0.5),
				renderOnFailed = v28,
				Size = UDim2.fromScale(1, 1),
				thumbnailImage = t1.thumbnailImage,
				timeLength = v25,
				Video = videoId,
				videoRef = v15,
				ZIndex = not v16 and 1 or 1001
			})
		})
	})
end))
