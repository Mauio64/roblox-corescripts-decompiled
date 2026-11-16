local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")
local getFitSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getFitSize")
local FFlagMomentsPreloadVideoPlayerInstance = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsPreloadVideoPlayerInstance")
local FFlagMomentsVideoPermissionContextFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsVideoPermissionContextFix")
local FFlagMomentsVideoLoadAsyncLoadingFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsVideoLoadAsyncLoadingFix")
local fFlagMomentsOptimisticProfilePending = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags").FFlagMomentsOptimisticProfilePending

local useSignalState = SignalsReact.useSignalState
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local signal = createSignal(Enum.ScaleType.Crop)

local function VideoSurface(props)
	local v5 = useSignalState(props.getItemSize)

	local getResolution = props.getResolution
	local v7 = useSignalState((React.useMemo(function()
		return createComputed(function(p2)
			return getResolution(p2)
		end)
	end, { getResolution })))
	local v8 = useSignalState(props.getScaleType or signal)

	local v9 = UDim2.fromScale(1, 1)
	local v10 = Enum.ScaleType.Stretch

	if v8 == Enum.ScaleType.Fit then
		if v7 ~= nil and v7.X > 0 and v7.Y > 0 then
			v9 = getFitSize(v5, v7)
		end
	else
		v10 = Enum.ScaleType.Crop
	end

	local createElement = React.createElement
	local v12 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = v9,
		BackgroundTransparency = 1,
		ScaleType = v10,
		ZIndex = props.zIndex,
		ref = props.setSurface
	}
	local v14

	if props.cornerRadius == nil then
		if props.surfaceCornerRadius ~= nil then
			v14 = React.createElement("UICorner", {
				CornerRadius = props.surfaceCornerRadius
			})
		end
	else
		v14 = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	return createElement("VideoDisplay", v12, { Corner = v14 })
end

local function defaultObserveLoaded(instance)
	return {
		getIsLoaded = function()
			return instance.IsLoaded
		end,
		connect = function(callback)
			local isLoadedChangedConnection = instance:GetPropertyChangedSignal("IsLoaded"):Connect(function()
				callback(instance.IsLoaded)
			end)
			return function()
				isLoadedChangedConnection:Disconnect()
			end
		end
	}
end

local function createVideoNode(data, data2)
	local id = data.id
	local content = data.content

	local v5 = if FFlagMomentsVideoPermissionContextFix then data.preloadContent or content else content

	local signal2, v6 = createSignal(data.region)
	local parent = data.parent
	local zIndex = data.zIndex or 0
	local cornerRadius = data.cornerRadius

	local runService = data2.runService
	local contentProvider = data2.contentProvider

	local observeLoaded = data2.observeLoaded or defaultObserveLoaded

	local loadVideo = data2.loadVideo or function(object)
		return object:LoadAsync()
	end

	local function getRegionStart()
		local v7 = signal2(false)

		if v7 == nil then
			return 0
		end

		return v7.startTime
	end

	local signal3, v7 = createSignal(false)
	local signal4, v8 = createSignal(false)
	local signal5, v9 = createSignal(false)

	local signal6, v10 = createSignal(false)

	local signal7, v11 = createSignal(nil)
	local signal8, v12 = createSignal(nil)
	local signal9, v13 = createSignal(0)
	local signal10, v14 = createSignal(0)

	local computed = createComputed(function(p2): string
		if signal5(p2) then
			return "Playing"
		end

		if signal4(p2) then
			return "Decoded"
		end

		if signal3(p2) then
			return "Downloaded"
		end

		return "Idle"
	end)

	local computed2 = createComputed(function(p2)
		local v15 = signal2(p2)

		if v15 == nil then
			return signal9(p2)
		end

		return v15.endTime - v15.startTime
	end)

	local v15 = nil
	local v16 = nil
	local v17 = nil
	local connections = {}
	local v18 = nil
	local v19 = nil
	local renderSteppedConnection = nil
	local v20 = false
	local v21 = false
	local v22 = false
	local v23 = false
	local v24 = false
	local v25 = false
	local v26 = false
	local v27 = nil
	local v28 = false
	local v29 = false

	local count = 0
	local flag = false

	local function regionEnd()
		local v30 = signal2(false)

		if v30 == nil then
			return (signal9(false))
		end

		return v30.endTime
	end

	local function applyLoopingMode()
		local v30 = v15

		if not v30 then
			return
		end

		local v31 = signal2(false)
		local v32 = signal9(false)
		local v33

		if v31 == nil then
			v33 = true
		elseif v32 > 0 and v31.startTime <= 0.05 then
			local endTime = v31.endTime
			v33 = v32 - 0.05 <= endTime
		else
			v33 = false
		end

		v20 = v33
		v30.Looping = v33
	end

	local function ensureWire()
		local v30 = v15
		local v31 = v17

		if not v21 or not v30 or not v31 or v16 then
			return
		end

		local wire = Instance.new("Wire")
		wire.SourceInstance = v30
		wire.TargetInstance = v31
		wire.Parent = v30
		v16 = wire
	end

	local function tearWire()
		if v16 then
			v16:Destroy()
			v16 = nil
		end
	end

	local function onStep()
		local v30 = v15

		if not v30 then
			return
		end

		local v31 = signal2(false)
		local v32 = v31 == nil and 0 or v31.startTime

		local v33 = v30.TimePosition

		if not v20 then
			local v34 = signal2(false)
			local v35 = if v34 == nil then signal9(false) else v34.endTime

			if v35 - 0.05 <= v33 then
				v30.TimePosition = v32
				v33 = v32
			end
		end

		v14(v33 - v32)
	end

	local function startPlaybackLoop()
		if renderSteppedConnection then
			return
		end

		renderSteppedConnection = runService.RenderStepped:Connect(onStep)
	end

	local function stopPlaybackLoop()
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function startPlayerPlaybackIfReady()
		local v30 = v15

		if
			not v26
			or signal5(false)
			or not v21
			or v30 == nil
			or FFlagMomentsPreloadVideoPlayerInstance and not (v25 or signal6(false))
		then
			return
		end

		v30:Play()
		v9(true)

		if renderSteppedConnection then
			return
		end

		renderSteppedConnection = runService.RenderStepped:Connect(onStep)
	end

	local function assets()
		return { v5 }
	end

	local function createPlayer()
		local videoPlayer = Instance.new("VideoPlayer")
		videoPlayer.Name = "VideoPlayer"
		videoPlayer.Looping = false
		videoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
		videoPlayer.VideoContent = content

		if FFlagMomentsPreloadVideoPlayerInstance then
			local v30 = signal2(false)
			videoPlayer.TimePosition = v30 == nil and 0 or v30.startTime
		end

		videoPlayer.Parent = parent
		v15 = videoPlayer
		return videoPlayer
	end

	local function runLoad(p2, p3, p4)
		if flag or v15 ~= p2 or not v21 then
			return
		end

		local success, result = pcall(loadVideo, p2)

		if flag or v15 ~= p2 or not v21 then
			return
		end

		if not success then
			v11(`video load errored: {tostring(result)}`)
		elseif result == Enum.AssetFetchStatus.Success then
			v25 = true
			v10(p3.getIsLoaded())
			v11(nil)
			startPlayerPlaybackIfReady()
		else
			if not FFlagMomentsVideoLoadAsyncLoadingFix or result ~= Enum.AssetFetchStatus.Loading or p4 then
				v11(`video load failed: {result.Name}`)

				return
			end

			v10(p3.getIsLoaded())

			if v22 and not v23 then
				v29 = true
			else
				runLoad(p2, p3, true)
			end
		end
	end

	local function startLoadIfReady()
		local v30 = v15
		local v31 = v18

		if flag or not v21 or v24 or v30 == nil or v31 == nil then
			return
		end

		if FFlagMomentsPreloadVideoPlayerInstance and v22 and not (v23 or v28) then
			if v27 == nil then
				v27 = v31

				task.delay(2, function()
					if v27 ~= v31 then
						return
					end

					v27 = nil

					if flag or not v21 or v15 ~= v30 or v18 ~= v31 then
						return
					end

					v28 = true
					startLoadIfReady()
				end)
			end
		else
			v27 = nil
			v24 = true
			v25 = false

			task.spawn(runLoad, v30, v31, false)
		end
	end

	local function download()
		local v30 = count

		if FFlagMomentsPreloadVideoPlayerInstance then
			local videoPlayer = v15

			if not videoPlayer then
				videoPlayer = Instance.new("VideoPlayer")
				videoPlayer.Name = "VideoPlayer"
				videoPlayer.Looping = false
				videoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
				videoPlayer.VideoContent = content

				if FFlagMomentsPreloadVideoPlayerInstance then
					local v31 = signal2(false)
					videoPlayer.TimePosition = v31 == nil and 0 or v31.startTime
				end

				videoPlayer.Parent = parent
				v15 = videoPlayer
			end

			v22 = true

			pcall(function()
				contentProvider:PreloadAsync({ videoPlayer })
			end)

			if flag or v30 ~= count or v15 ~= videoPlayer then
				return
			end

			v23 = true

			if FFlagMomentsVideoLoadAsyncLoadingFix and v29 then
				v29 = false
				local v31 = v18

				if v21 and v31 ~= nil and not v31.getIsLoaded() then
					task.spawn(runLoad, videoPlayer, v31, true)
				end
			end
		elseif not fFlagMomentsOptimisticProfilePending or v5.Uri ~= nil then
			contentProvider:PreloadAsync({ v5.Uri })
		end

		if flag or v30 ~= count then
			return
		end

		v7(true)
		startLoadIfReady()
	end

	local function decode()
		if flag or v21 then
			return
		end

		v11(nil)

		local videoPlayer = v15

		if not videoPlayer then
			videoPlayer = Instance.new("VideoPlayer")
			videoPlayer.Name = "VideoPlayer"
			videoPlayer.Looping = false
			videoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
			videoPlayer.VideoContent = content

			if FFlagMomentsPreloadVideoPlayerInstance then
				local v30 = signal2(false)
				videoPlayer.TimePosition = v30 == nil and 0 or v30.startTime
			end

			videoPlayer.Parent = parent
			v15 = videoPlayer
		end

		local v30 = observeLoaded(videoPlayer)
		v18 = v30
		v10(v30.getIsLoaded())
		v19 = v30.connect(function(p2)
			v10(p2)

			if p2 then
				startPlayerPlaybackIfReady()
			end
		end)

		local function readResolution()
			local resolution = videoPlayer.Resolution

			if not (resolution.X > 0 and resolution.Y > 0) then
				resolution = nil
			end

			v12(resolution)
		end

		local resolution = videoPlayer.Resolution

		if not (resolution.X > 0 and resolution.Y > 0) then
			resolution = nil
		end

		v12(resolution)

		table.insert(
			connections,
			videoPlayer:GetPropertyChangedSignal("Resolution"):Connect(readResolution)
		)

		v13(videoPlayer.TimeLength)
		table.insert(connections, videoPlayer:GetPropertyChangedSignal("TimeLength"):Connect(function()
			v13(videoPlayer.TimeLength)
			local v32 = v15

			if not v32 then
				return
			end

			local v33 = signal2(false)
			local v34 = signal9(false)
			local v35

			if v33 == nil then
				v35 = true
			elseif v34 > 0 and v33.startTime <= 0.05 then
				local endTime = v33.endTime
				v35 = v34 - 0.05 <= endTime
			else
				v35 = false
			end

			v20 = v35
			v32.Looping = v35
		end))

		v21 = true
		local v32 = v15

		if v32 then
			local v33 = signal2(false)
			local v34 = signal9(false)
			local v35

			if v33 == nil then
				v35 = true
			elseif v34 > 0 and v33.startTime <= 0.05 then
				local endTime = v33.endTime
				v35 = v34 - 0.05 <= endTime
			else
				v35 = false
			end

			v20 = v35
			v32.Looping = v35
		end

		local v33 = v15
		local v34 = v17

		if v21 and v33 and v34 and not v16 then
			local wire = Instance.new("Wire")
			wire.SourceInstance = v33
			wire.TargetInstance = v34
			wire.Parent = v33
			v16 = wire
		end

		startLoadIfReady()
		v8(true)
	end

	local function releaseDecoder()
		local v30 = v15

		if not (v30 and v21) then
			return
		end

		v21 = false
		v27 = nil
		v29 = false
		v26 = false

		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end

		v9(false)

		if v16 then
			v16:Destroy()
			v16 = nil
		end

		if v19 then
			v19()
			v19 = nil
		end

		v18 = nil

		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)

		if not (FFlagMomentsPreloadVideoPlayerInstance and v22) or v23 or v24 then
			v15 = nil
			v30:Destroy()
		end

		v24 = false
		v25 = false

		v8(false)
		v10(false)
		v11(nil)
		v14(0)
	end

	local function play()
		local v30 = v15

		if not (v30 and v21) then
			return
		end

		local v31 = signal2(false)
		v30.TimePosition = v31 == nil and 0 or v31.startTime
		v14(0)

		if FFlagMomentsPreloadVideoPlayerInstance then
			v26 = true
			startPlayerPlaybackIfReady()
		else
			v30:Play()
			v9(true)

			if renderSteppedConnection then
				return
			end

			renderSteppedConnection = runService.RenderStepped:Connect(onStep)
		end
	end

	local function pause()
		local v30 = v15

		if FFlagMomentsPreloadVideoPlayerInstance then
			v26 = false
		end

		if not (v30 and v21) then
			return
		end

		if FFlagMomentsPreloadVideoPlayerInstance then
			if signal5(false) then
				v30:Pause()
			end
		else
			v30:Pause()
		end

		v9(false)

		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function seek(p2)
		local v30 = v15

		if not v30 then
			return
		end

		local v31 = signal2(false)
		local v32 = v31 == nil and 0 or v31.startTime

		local v33 = v32 + p2
		local v34 = signal2(false)
		local v35 = if v34 == nil then signal9(false) else v34.endTime

		local v36 = math.clamp(v33, v32, v35)
		v30.TimePosition = v36
		v14(v36 - v32)
	end

	local function setRegion(p2)
		v6(p2)
		local v30 = v15

		if v30 then
			local v31 = signal2(false)
			local v32 = signal9(false)
			local v33

			if v31 == nil then
				v33 = true
			elseif v32 > 0 and v31.startTime <= 0.05 then
				local endTime = v31.endTime
				v33 = v32 - 0.05 <= endTime
			else
				v33 = false
			end

			v20 = v33
			v30.Looping = v33
		end

		local v31 = v15

		if v31 ~= nil then
			local v32 = signal2(false)
			local v33 = v32 == nil and 0 or v32.startTime

			local timePosition = v31.TimePosition
			local v34 = signal2(false)
			local v35 = if v34 == nil then signal9(false) else v34.endTime

			local v36 = math.clamp(timePosition, v33, v35)
			v31.TimePosition = v36
			v14(v36 - v33)
		end
	end

	local function getAudioSource()
		local audioSource = v15
		assert(audioSource and v21, "createVideoNode: getAudioSource() requires decode() first")
		return audioSource
	end

	local function isPlaybackReady()
		return not FFlagMomentsPreloadVideoPlayerInstance or signal6(false)
	end

	local function setSurface(p2)
		if p2 == v17 then
			return
		end

		if v16 then
			v16:Destroy()
			v16 = nil
		end

		v17 = p2
		local v30 = v15
		local v31 = v17

		if v21 and v30 and v31 then
			if v16 then
				return
			end

			local wire = Instance.new("Wire")
			wire.SourceInstance = v30
			wire.TargetInstance = v31
			wire.Parent = v30
			v16 = wire
		end
	end

	local function render(props)
		return React.createElement(VideoSurface, {
			getItemSize = props.getItemSize,
			getResolution = props.getResolution,
			getScaleType = props.getScaleType,
			setSurface = props.setSurface,
			zIndex = zIndex,
			cornerRadius = cornerRadius,
			surfaceCornerRadius = props.cornerRadius
		})
	end

	local function dispose()
		if flag then
			return
		end

		flag = true
		count += 1
		v21 = false
		v27 = nil
		v29 = false
		v24 = false
		v25 = false
		v26 = false

		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end

		if v16 then
			v16:Destroy()
			v16 = nil
		end

		if v19 then
			v19()
			v19 = nil
		end

		v18 = nil

		for k, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)

		if v15 then
			v15:Destroy()
			v15 = nil
		end

		v17 = nil
	end

	return {
		id = id,
		kind = "video",
		usesDecoder = true,
		zIndex = zIndex,
		audioStem = { stemId = id, defaultVolume = 1 },
		assets = assets,
		download = download,
		decode = decode,
		releaseDecoder = releaseDecoder,
		getResourceLevel = computed,
		getAudioSource = getAudioSource,
		render = render,
		play = play,
		pause = pause,
		seek = seek,
		setRegion = setRegion,
		dispose = dispose,
		getIsLoaded = signal6,
		getFailureReason = signal7,
		getResolution = signal8,
		getTimeLength = signal9,
		getDuration = computed2,
		getPosition = signal10,
		isPlaybackReady = isPlaybackReady,
		setSurface = setSurface
	}
end

return { kind = "video", create = createVideoNode }
