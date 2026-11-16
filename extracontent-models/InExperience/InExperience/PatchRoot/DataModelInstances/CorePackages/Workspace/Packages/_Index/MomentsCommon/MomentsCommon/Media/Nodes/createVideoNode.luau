local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)
local getFitSize = require(MomentsCommon.Utils.getFitSize)
local FFlagMomentsPreloadVideoPlayerInstance = require(MomentsCommon.Flags.FFlagMomentsPreloadVideoPlayerInstance)
local FFlagMomentsVideoPermissionContextFix = require(MomentsCommon.Flags.FFlagMomentsVideoPermissionContextFix)
local FFlagMomentsVideoLoadAsyncLoadingFix = require(MomentsCommon.Flags.FFlagMomentsVideoLoadAsyncLoadingFix)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending

local useSignalState = SignalsReact.useSignalState
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local signal = createSignal(Enum.ScaleType.Crop)

local function VideoSurface(props)
	local v = useSignalState(props.getItemSize)

	local getResolution = props.getResolution
	local v2 = useSignalState((React.useMemo(function()
		return createComputed(function(p)
			return getResolution(p)
		end)
	end, { getResolution })))
	local v3 = useSignalState(props.getScaleType or signal)

	local size = UDim2.fromScale(1, 1)
	local scaleType = Enum.ScaleType.Stretch

	if v3 == Enum.ScaleType.Fit then
		if v2 ~= nil and v2.X > 0 and v2.Y > 0 then
			size = getFitSize(v, v2)
		end
	else
		scaleType = Enum.ScaleType.Crop
	end

	local createElement = React.createElement
	local v4 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = size,
		BackgroundTransparency = 1,
		ScaleType = scaleType,
		ZIndex = props.zIndex,
		ref = props.setSurface
	}
	local corner

	if props.cornerRadius == nil then
		if props.surfaceCornerRadius ~= nil then
			corner = React.createElement("UICorner", { CornerRadius = props.surfaceCornerRadius })
		end
	else
		corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	return createElement("VideoDisplay", v4, { Corner = corner })
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
	local v

	if FFlagMomentsVideoPermissionContextFix then
		v = data.preloadContent or content
	else
		v = content
	end

	local signal2, v2 = createSignal(data.region)
	local parent2 = data.parent
	local zIndex = data.zIndex or 0
	local cornerRadius = data.cornerRadius

	local runService = data2.runService
	local contentProvider = data2.contentProvider

	local observeLoaded = data2.observeLoaded or defaultObserveLoaded

	local loadVideo = data2.loadVideo or function(object)
		return object:LoadAsync()
	end

	local function getRegionStart() -- 7 equivalent calls inferred from this helper
		local v3 = signal2(false)
		return if v3 == nil then 0 else v3.startTime
	end

	local signal3, v3 = createSignal(false)
	local signal4, v4 = createSignal(false)
	local signal5, v5 = createSignal(false)

	local signal6, v6 = createSignal(false)

	local signal7, v7 = createSignal(nil)
	local signal8, v8 = createSignal(nil)
	local signal9, v9 = createSignal(0)
	local signal10, v10 = createSignal(0)

	local getResourceLevel = createComputed(function(p): string
		if signal5(p) then
			return "Playing"
		end

		if signal4(p) then
			return "Decoded"
		end

		return if signal3(p) then "Downloaded" else "Idle"
	end)

	local getDuration = createComputed(function(p)
		local v11 = signal2(p)

		if v11 == nil then
			return signal9(p)
		end

		return v11.endTime - v11.startTime
	end)

	local v11 = nil
	local v12 = nil
	local v13 = nil
	local connections = {}
	local v14 = nil
	local v15 = nil
	local renderSteppedConnection = nil
	local v16 = false
	local v17 = false
	local v18 = false
	local v19 = false
	local v20 = false
	local v21 = false
	local v22 = false
	local v23 = nil
	local v24 = false
	local v25 = false

	local count = 0
	local flag = false

	local function regionEnd() -- 3 equivalent calls inferred from this helper
		local v26 = signal2(false)

		if v26 == nil then
			return (signal9(false))
		end

		return v26.endTime
	end

	local function applyLoopingMode() -- 3 equivalent calls inferred from this helper
		local v26 = v11

		if not v26 then
			return
		end

		local v27 = signal2(false)
		local v28 = signal9(false)
		local looping

		if v27 == nil then
			looping = true
		elseif v28 > 0 and v27.startTime <= 0.05 then
			local endTime = v27.endTime
			looping = v28 - 0.05 <= endTime
		else
			looping = false
		end

		v16 = looping
		v26.Looping = looping
	end

	local function ensureWire() -- 1 equivalent call inferred from this helper
		local v26 = v11
		local targetInstance = v13

		if not v17 or not v26 or not targetInstance or v12 then
			return
		end

		local wire = Instance.new("Wire")
		wire.SourceInstance = v26
		wire.TargetInstance = targetInstance
		wire.Parent = v26
		v12 = wire
	end

	local function tearWire() -- 3 equivalent calls inferred from this helper
		if v12 then
			v12:Destroy()
			v12 = nil
		end
	end

	local function onStep()
		local v26 = v11

		if not v26 then
			return
		end

		local regionStart = getRegionStart() -- inferred equivalent call
		local v27 = v26.TimePosition

		if not v16 and regionEnd() - 0.05 <= v27 then -- inferred equivalent call
			v26.TimePosition = regionStart
			v27 = regionStart
		end

		v10(v27 - regionStart)
	end

	local function startPlaybackLoop() -- 2 equivalent calls inferred from this helper
		if renderSteppedConnection then
			return
		end

		renderSteppedConnection = runService.RenderStepped:Connect(onStep)
	end

	local function stopPlaybackLoop() -- 3 equivalent calls inferred from this helper
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function startPlayerPlaybackIfReady()
		local v26 = v11

		if
			not v22
			or signal5(false)
			or not v17
			or v26 == nil
			or FFlagMomentsPreloadVideoPlayerInstance and not (v21 or signal6(false))
		then
			return
		end

		v26:Play()
		v5(true)
		startPlaybackLoop() -- inferred equivalent call
	end

	local function assets()
		return { v }
	end

	local function createPlayer()
		local videoPlayer = Instance.new("VideoPlayer")
		videoPlayer.Name = "VideoPlayer"
		videoPlayer.Looping = false
		videoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
		videoPlayer.VideoContent = content

		if FFlagMomentsPreloadVideoPlayerInstance then
			videoPlayer.TimePosition = getRegionStart() -- inferred equivalent call
		end

		videoPlayer.Parent = parent2
		v11 = videoPlayer
		return videoPlayer
	end

	local function runLoad(p, p2, flag2: boolean)
		if flag or v11 ~= p or not v17 then
			return
		end

		local success, result = pcall(loadVideo, p)

		if flag or v11 ~= p or not v17 then
			return
		end

		if not success then
			v7(`video load errored: {tostring(result)}`)
		elseif result == Enum.AssetFetchStatus.Success then
			v21 = true
			v6(p2.getIsLoaded())
			v7(nil)
			startPlayerPlaybackIfReady()
		else
			if not FFlagMomentsVideoLoadAsyncLoadingFix or result ~= Enum.AssetFetchStatus.Loading or flag2 then
				v7(`video load failed: {result.Name}`)

				return
			end

			v6(p2.getIsLoaded())

			if v18 and not v19 then
				v25 = true
			else
				runLoad(p, p2, true)
			end
		end
	end

	local function startLoadIfReady()
		local v26 = v11
		local v27 = v14

		if flag or not v17 or v20 or v26 == nil or v27 == nil then
			return
		end

		if FFlagMomentsPreloadVideoPlayerInstance and v18 and not (v19 or v24) then
			if v23 == nil then
				v23 = v27

				task.delay(2, function()
					if v23 ~= v27 then
						return
					end

					v23 = nil

					if flag or not v17 or v11 ~= v26 or v14 ~= v27 then
						return
					end

					v24 = true
					startLoadIfReady()
				end)
			end
		else
			v23 = nil
			v20 = true
			v21 = false

			task.spawn(runLoad, v26, v27, false)
		end
	end

	local function download()
		local v26 = count

		if FFlagMomentsPreloadVideoPlayerInstance then
			local videoPlayer = v11

			if not videoPlayer then
				videoPlayer = Instance.new("VideoPlayer")
				videoPlayer.Name = "VideoPlayer"
				videoPlayer.Looping = false
				videoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
				videoPlayer.VideoContent = content

				if FFlagMomentsPreloadVideoPlayerInstance then
					videoPlayer.TimePosition = getRegionStart() -- inferred equivalent call
				end

				videoPlayer.Parent = parent2
				v11 = videoPlayer
			end

			v18 = true

			pcall(function()
				contentProvider:PreloadAsync({ videoPlayer })
			end)

			if flag or v26 ~= count or v11 ~= videoPlayer then
				return
			end

			v19 = true

			if FFlagMomentsVideoLoadAsyncLoadingFix and v25 then
				v25 = false
				local v27 = v14

				if v17 and v27 ~= nil and not v27.getIsLoaded() then
					task.spawn(runLoad, videoPlayer, v27, true)
				end
			end
		elseif not FFlagMomentsOptimisticProfilePending or v.Uri ~= nil then
			contentProvider:PreloadAsync({ v.Uri })
		end

		if flag or v26 ~= count then
			return
		end

		v3(true)
		startLoadIfReady()
	end

	local function decode()
		if flag or v17 then
			return
		end

		v7(nil)

		local videoPlayer = v11

		if not videoPlayer then
			videoPlayer = Instance.new("VideoPlayer")
			videoPlayer.Name = "VideoPlayer"
			videoPlayer.Looping = false
			videoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
			videoPlayer.VideoContent = content

			if FFlagMomentsPreloadVideoPlayerInstance then
				videoPlayer.TimePosition = getRegionStart() -- inferred equivalent call
			end

			videoPlayer.Parent = parent2
			v11 = videoPlayer
		end

		local v26 = observeLoaded(videoPlayer)
		v14 = v26
		v6(v26.getIsLoaded())
		v15 = v26.connect(function(p)
			v6(p)

			if p then
				startPlayerPlaybackIfReady()
			end
		end)

		local function readResolution() -- 1 equivalent call inferred from this helper
			local resolution = videoPlayer.Resolution

			if not (resolution.X > 0 and resolution.Y > 0) then
				resolution = nil
			end

			v8(resolution)
		end

		readResolution() -- inferred equivalent call
		table.insert(connections, videoPlayer:GetPropertyChangedSignal("Resolution"):Connect(readResolution))

		v9(videoPlayer.TimeLength)
		table.insert(connections, videoPlayer:GetPropertyChangedSignal("TimeLength"):Connect(function()
			v9(videoPlayer.TimeLength)
			applyLoopingMode() -- inferred equivalent call
		end))

		v17 = true
		applyLoopingMode() -- inferred equivalent call
		ensureWire() -- inferred equivalent call
		startLoadIfReady()
		v4(true)
	end

	local function releaseDecoder()
		local v26 = v11

		if not (v26 and v17) then
			return
		end

		v17 = false
		v23 = nil
		v25 = false
		v22 = false
		stopPlaybackLoop() -- inferred equivalent call
		v5(false)
		tearWire() -- inferred equivalent call

		if v15 then
			v15()
			v15 = nil
		end

		v14 = nil

		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)

		if not (FFlagMomentsPreloadVideoPlayerInstance and v18) or v19 or v20 then
			v11 = nil
			v26:Destroy()
		end

		v20 = false
		v21 = false

		v4(false)
		v6(false)
		v7(nil)
		v10(0)
	end

	local function play()
		local v26 = v11

		if not (v26 and v17) then
			return
		end

		v26.TimePosition = getRegionStart() -- inferred equivalent call
		v10(0)

		if FFlagMomentsPreloadVideoPlayerInstance then
			v22 = true
			startPlayerPlaybackIfReady()
		else
			v26:Play()
			v5(true)
			startPlaybackLoop() -- inferred equivalent call
		end
	end

	local function pause()
		local v26 = v11

		if FFlagMomentsPreloadVideoPlayerInstance then
			v22 = false
		end

		if not (v26 and v17) then
			return
		end

		if FFlagMomentsPreloadVideoPlayerInstance then
			if signal5(false) then
				v26:Pause()
			end
		else
			v26:Pause()
		end

		v5(false)
		stopPlaybackLoop() -- inferred equivalent call
	end

	local function seek(p: number)
		local v26 = v11

		if not v26 then
			return
		end

		local regionStart = getRegionStart() -- inferred equivalent call
		local v27 = regionStart + p
		local timePosition = math.clamp(v27, regionStart, regionEnd()) -- inferred equivalent call
		v26.TimePosition = timePosition
		v10(timePosition - regionStart)
	end

	local function setRegion(p)
		v2(p)
		applyLoopingMode() -- inferred equivalent call
		local v26 = v11

		if v26 ~= nil then
			local regionStart = getRegionStart() -- inferred equivalent call
			local timePosition = v26.TimePosition
			local timePosition2 = math.clamp(timePosition, regionStart, regionEnd()) -- inferred equivalent call
			v26.TimePosition = timePosition2
			v10(timePosition2 - regionStart)
		end
	end

	local function getAudioSource()
		local audioSource = v11
		assert(audioSource and v17, "createVideoNode: getAudioSource() requires decode() first")
		return audioSource
	end

	local function isPlaybackReady()
		return not FFlagMomentsPreloadVideoPlayerInstance or signal6(false)
	end

	local function setSurface(p)
		if p == v13 then
			return
		end

		tearWire() -- inferred equivalent call
		v13 = p
		local v26 = v11
		local targetInstance = v13

		if v17 and v26 and targetInstance then
			if v12 then
				return
			end

			local wire = Instance.new("Wire")
			wire.SourceInstance = v26
			wire.TargetInstance = targetInstance
			wire.Parent = v26
			v12 = wire
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
		v17 = false
		v23 = nil
		v25 = false
		v20 = false
		v21 = false
		v22 = false
		stopPlaybackLoop() -- inferred equivalent call
		tearWire() -- inferred equivalent call

		if v15 then
			v15()
			v15 = nil
		end

		v14 = nil

		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)

		if v11 then
			v11:Destroy()
			v11 = nil
		end

		v13 = nil
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
		getResourceLevel = getResourceLevel,
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
		getDuration = getDuration,
		getPosition = signal10,
		isPlaybackReady = isPlaybackReady,
		setSurface = setSurface
	}
end

return { kind = "video", create = createVideoNode }
