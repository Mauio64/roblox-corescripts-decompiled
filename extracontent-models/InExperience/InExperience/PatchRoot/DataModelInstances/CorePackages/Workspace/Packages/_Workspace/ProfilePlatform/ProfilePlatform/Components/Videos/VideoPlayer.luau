local RunService = game:GetService("RunService")
local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local MediaPlayer = require(ProfilePlatform.Components.Videos.MediaPlayer)
local VideoPlaybackDetector = require(ProfilePlatformParent.VideoUtils).VideoPlaybackDetector
local Responsive = require(ProfilePlatformParent.Responsive)
local useLastInput = Responsive.useLastInput

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 35
	-- upvalues: React (copy), useLastInput (copy), RunService (copy), VideoPlaybackDetector (copy), Responsive (copy), MediaPlayer (copy)
	local videoId = t1.videoId
	local v12 = React.useRef(nil)
	local v13 = t1.isFullscreen or false
	local v14, v15 = React.useState(t1.isMuted == nil or t1.isMuted)
	local v16 = React.useRef(nil)
	local v17, v18 = React.useState(false)
	local v19 = useLastInput()
	local v20, v21 = React.useState(false)
	local v22, v23 = React.useState(0)

	React.useImperativeHandle(p1, function() -- line: 46
		-- upvalues: v12 (copy), v15 (copy), v14 (copy), v17 (copy), v22 (copy)
		return {
			setTimePosition = function(n1: number) -- line: 48
				-- upvalues: v12 (copy)
				local current = v12.current

				if current then
					current.TimePosition = n1
				end
			end,
			toggleMute = function() -- line: 54
				-- upvalues: v15 (copy), v14 (copy)
				v15(not v14)
			end,
			togglePlayPause = function() -- line: 57
				-- upvalues: v12 (copy), v17 (copy), v22 (copy)
				local current = v12.current

				if not current then
					return
				end

				if v17 then
					current:Pause()

					return
				end

				if current.TimePosition >= v22 - 0.2 then
					current.TimePosition = 0
				end

				current:Play()
			end
		}
	end, {
		v14,
		v17,
		v22
	})

	local v24 = React.useCallback(function() -- line: 74
		-- upvalues: v12 (copy), v14 (copy)
		local current = v12.current

		if current then
			current.Volume = not v14 and 1 or 0
		end
	end, { v14 })
	local v25 = React.useCallback(function() -- line: 81
		-- upvalues: React (copy)
		return (React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		}))
	end, {})
	local v26 = React.useCallback(function(_) -- line: 88
		-- upvalues: v12 (copy), v24 (copy), v23 (copy)
		local current = v12.current

		if not current then
			return
		end

		v24()
		v23(current.TimeLength)
	end, {})
	local v27 = React.useCallback(function() -- line: 97
		-- upvalues: v21 (copy)
		v21(true)
	end, {})
	local v28 = React.useCallback(function() -- line: 101
		-- upvalues: v21 (copy)
		v21(false)
	end, {})

	React.useEffect(function() -- line: 105
		-- upvalues: v24 (copy)
		v24()
	end, { v14 })
	React.useEffect(function() -- line: 110
		-- upvalues: v12 (copy), v22 (copy), v17 (copy)
		local current = v12.current

		if not current or v22 == 0 then
			return
		end

		if v17 and current.TimePosition >= v22 - 0.2 then
			current.TimePosition = 0
		end
	end, {
		v17,
		v22
	})
	React.useEffect(function() -- line: 121
		-- upvalues: v12 (copy), v22 (copy), t1 (copy)
		local current = v12.current

		if not current or v22 == 0 then
			return
		end

		if t1.initialTimePosition then
			if t1.initialTimePosition >= v22 - 0.2 then
				current.TimePosition = 0

				return
			end

			current.TimePosition = t1.initialTimePosition
		end
	end, {
		t1.initialTimePosition,
		v22
	})
	React.useEffect(function() -- line: 136
		-- upvalues: v12 (copy), v13 (copy), v18 (copy)
		local current = v12.current

		if current and v13 then
			current:Play()
			v18(true)
		end
	end, { v13 })
	React.useEffect(function() -- line: 144
		-- upvalues: v12 (copy), RunService (copy), v23 (copy), t1 (copy), v17 (copy), v14 (copy), v18 (copy)
		local current = v12.current

		if not current then
			return
		end

		local connection = RunService.RenderStepped:Connect(function() -- line: 150
			-- upvalues: current (copy), v23 (copy), t1 (copy), v17 (copy), v14 (copy)
			local currentTimePosition = current.TimePosition
			local TimeLength = current.TimeLength

			v23(TimeLength)

			if t1.onTimeUpdate then
				t1.onTimeUpdate(currentTimePosition)
			end

			if t1.onProgressUpdate then
				t1.onProgressUpdate(currentTimePosition, TimeLength, v17, v14)
			end
		end)
		local connection2 = current.Played:Connect(function() -- line: 162
			-- upvalues: v18 (copy)
			v18(true)
		end)
		local connection3 = current.Paused:Connect(function() -- line: 166
			-- upvalues: v18 (copy)
			v18(false)
		end)
		local connection4 = current.Ended:Connect(function() -- line: 170
			-- upvalues: v18 (copy)
			v18(false)
		end)

		return function() -- line: 174
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy), connection4 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
			connection4:Disconnect()
		end
	end, {
		v14,
		v17,
		t1.onProgressUpdate,
		t1.onTimeUpdate
	})

	local function handleExpand() -- line: 182
		-- upvalues: t1 (copy), v12 (copy)
		if t1.onExpandCallback then
			t1.onExpandCallback(v12.current and v12.current.TimePosition or 0)
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = not v13,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.fromScale(1, 1),
		ZIndex = not v13 and 1 or 1000,
		ref = v16,
		[React.Event.MouseEnter] = v27,
		[React.Event.MouseLeave] = v28
	}, {
		VideoPlaybackDetector = if v13 then nil else React.createElement(VideoPlaybackDetector, {
			isVideoEligible = true,
			itemIndex = nil,
			videoDwellTimeInSec = 1,
			videoVisiblePercent = 80,
			isHovered = v20,
			isHoverSupported = v19 ~= Responsive.Input.Touch,
			onPlaybackChange = function(b1: boolean) -- line: 204
				-- upvalues: v18 (copy)
				v18(b1)
			end,
			itemFrameRef = v16,
			videoKey = videoId,
			videoPlaybackCoordinator = t1.videoPlaybackCoordinator
		}),
		VideoContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1),
			ZIndex = not v13 and 1 or 1001
		}, {
			VideoContent = React.createElement(MediaPlayer, {
				cornerRadius = t1.cornerRadius,
				isFullScreen = v13,
				Looped = t1.looped,
				onExpandCallback = handleExpand,
				onVideoLoaded = v26,
				Playing = v17,
				Position = UDim2.fromScale(0.5, 0.5),
				renderOnFailed = v25,
				Size = UDim2.fromScale(1, 1),
				thumbnailImage = t1.thumbnailImage,
				timeLength = v22,
				Video = videoId,
				videoRef = v12,
				ZIndex = not v13 and 1 or 1001
			})
		})
	})
end))
