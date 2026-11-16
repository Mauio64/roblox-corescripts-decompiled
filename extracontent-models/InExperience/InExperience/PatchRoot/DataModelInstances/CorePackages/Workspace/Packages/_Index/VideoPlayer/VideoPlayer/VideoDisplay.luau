local parent = script:FindFirstAncestor("VideoPlayer").Parent

local RunService = game:GetService("RunService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)

local VideoPlayerWrapper = require(script.Parent.VideoPlayerWrapper)
local VideoLoadingState = require(script.Parent.VideoLoadingState)

local defineFastFlag = game:DefineFastFlag("LuaAppFixStartPlaybackProgress", false)

local function VideoDisplay(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local videoPlayerRef = props.videoPlayerRef or ref2
	local ref3 = React.useRef(0)
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(false)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(VideoLoadingState.Idle)
	local shouldStartPlayback = props.shouldStartPlayback or props.loadImmediately == true

	local ref6 = React.useRef(nil)
	ref6.current = props.onLoadingStateChanged
	local ref7 = React.useRef(nil)
	ref7.current = props.onVideoLoaded
	local ref8 = React.useRef(nil)
	ref8.current = props.onAspectRatioChanged
	local ref9 = React.useRef(nil)
	ref9.current = props.onVideoProgressChanged
	local ref10, ref11

	if defineFastFlag then
		ref10 = React.useRef(props.startPlaybackProgress)
		ref10.current = props.startPlaybackProgress
		ref11 = React.useRef(false)
	else
		ref10 = nil
		ref11 = nil
	end

	local v = React.useCallback(function(p)
		setState2(p)

		if ref6.current then
			ref6.current(p)
		end
	end, {})

	local onVideoLooped = React.useCallback(function()
		ref3.current += 1

		if props.onVideoLooped then
			props.onVideoLooped()
		end
	end, { props.onVideoLooped })

	React.useEffect(function()
		ref3.current = 0
		ref4.current = 0
		ref5.current = false
	end, { props.video })

	React.useEffect(function()
		local videoPlaybackStateRef = props.videoPlaybackStateRef

		if videoPlaybackStateRef == nil then
			return
		end

		local function fn()
			local current = videoPlayerRef.current

			if not current then
				return nil
			end

			local v2 = {
				isPlaying = current.IsPlaying,
				playbackPositionMs = math.round(math.max(0, current.TimePosition) * 1000),
				videoLengthMs = 0,
				loopCount = 0,
				endedCount = 0,
				audioLevel = 0
			}
			local videoLengthMs

			if current.TimeLength > 0 then
				videoLengthMs = math.round(current.TimeLength * 1000)
			end

			v2.videoLengthMs = videoLengthMs
			v2.loopCount = ref3.current
			v2.endedCount = ref4.current
			v2.audioLevel = math.clamp(current.Volume * UserGameSettings.MasterVolume, 0, 1)
			return v2
		end

		videoPlaybackStateRef.current = fn

		return function()
			if videoPlaybackStateRef.current == fn then
				videoPlaybackStateRef.current = nil
			end
		end
	end, { props.videoPlaybackStateRef })

	React.useEffect(function()
		setState(false)

		if not shouldStartPlayback then
			v(VideoLoadingState.Idle)
			return
		end

		local current = videoPlayerRef.current
		ArgCheck.assert(current ~= nil, "VideoDisplay expects videoPlayer ref to be set before loading")
		v(VideoLoadingState.Loading)
		local flag = false
		task.spawn(function()
			local lastTime = tick()
			local success, result = pcall(function()
				return current:LoadAsync()
			end)

			if flag then
				return
			end

			if not success or result ~= Enum.AssetFetchStatus.Success then
				v(VideoLoadingState.Failed)
				return
			end

			if defineFastFlag then
				local current2 = ref10.current

				if current2 ~= nil then
					current.TimePosition = math.clamp(current2, 0, 1) * current.TimeLength
					ref11.current = true
				end
			elseif props.startPlaybackProgress ~= nil then
				current.TimePosition = math.clamp(props.startPlaybackProgress, 0, 1) * current.TimeLength
			end

			if ref7.current then
				ref7.current(current.TimeLength, tick() - lastTime)
			end

			local resolution = current.Resolution

			if ref8.current and resolution and resolution.Y > 0 then
				ref8.current(resolution.X / resolution.Y)
			end

			setState(true)
			v(VideoLoadingState.Loaded)
		end)
		return function()
			flag = true
		end
	end, { props.video, shouldStartPlayback })

	local onVideoEnded = React.useCallback(function()
		ref5.current = true
		ref4.current += 1

		if props.onVideoEnded then
			props.onVideoEnded()
		end
	end, { props.onVideoEnded })

	React.useEffect(function()
		if not state then
			return
		end

		local current = videoPlayerRef.current
		ArgCheck.assert(current ~= nil, "VideoDisplay expects videoPlayer ref to be set before playback")

		if defineFastFlag and ref11.current then
			ref11.current = false
		elseif ref5.current and props.shouldStartPlayback then
			current.TimePosition = 0
			ref5.current = false
		elseif props.shouldStartPlayback and not props.preservePlaybackPosition then
			current.TimePosition = 0
		end

		if props.shouldStartPlayback then
			current:Play()
		else
			current:Pause()
		end
	end, { state, props.preservePlaybackPosition, props.shouldStartPlayback })

	React.useEffect(function()
		if not state then
			return
		end

		local current = videoPlayerRef.current
		ArgCheck.assert(current ~= nil, "VideoDisplay expects videoPlayer ref to be set before reporting progress")
		local renderSteppedConnection = RunService.RenderStepped:Connect(function()
			local current2 = ref9.current

			if current2 then
				current2(not (current.TimeLength > 0) and 0 or current.TimePosition / current.TimeLength)
			end
		end)
		return function()
			renderSteppedConnection:Disconnect()
		end
	end, { state })

	local createElement = React.createElement
	local v2 = {
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = props.ZIndex,
		Selectable = false
	}
	local corner

	if props.cornerRadius then
		corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	local thumbnail

	if props.thumbnail and props.thumbnail ~= "" then
		local createElement2 = React.createElement
		local v3 = {
			Image = props.thumbnail,
			Size = UDim2.fromScale(1, 1),
			ScaleType = props.ScaleType,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1
		}
		local corner2

		if props.cornerRadius then
			corner2 = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, props.cornerRadius)
			})
		end

		thumbnail = createElement2("ImageLabel", v3, { Corner = corner2 })
	end

	local createElement2 = React.createElement
	local v3 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScaleType = props.ScaleType,
		Visible = state2 ~= VideoLoadingState.Failed and (props.shouldStartPlayback or props.showVideoWhenPaused == true),
		ZIndex = 2,
		ref = ref
	}
	local corner2

	if props.cornerRadius then
		corner2 = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	return createElement("Frame", v2, {
		Corner = corner,
		Thumbnail = thumbnail,
		VideoDisplay = createElement2("VideoDisplay", v3, {
			Corner = corner2,
			VideoPlayer = React.createElement(VideoPlayerWrapper, {
				video = props.video,
				muted = props.muted,
				looped = props.looped,
				videoPlayerRef = videoPlayerRef,
				videoDisplayRef = ref,
				onVideoLooped = onVideoLooped,
				onVideoEnded = onVideoEnded
			})
		})
	})
end

return VideoDisplay
