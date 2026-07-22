local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local SharedFlags = require(MomentsCommonParent.SharedFlags)
local Signals = require(MomentsCommonParent.Signals)
local SignalsReact = require(MomentsCommonParent.SignalsReact)

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)

local getCropSize = require(MomentsCommon.Utils.getCropSize)
local getFitSize = require(MomentsCommon.Utils.getFitSize)
local GetFFlagMomentsVideoSurfaceMediaRect = require(MomentsCommon.Flags.GetFFlagMomentsVideoSurfaceMediaRect)
local FFlagMomentsVideoCropRoundedCorners = require(MomentsCommon.Flags.FFlagMomentsVideoCropRoundedCorners)
local useSignalState = SignalsReact.useSignalState
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local FFlagLuaAppMomentsInternalVideoUsage = SharedFlags.FFlagLuaAppMomentsInternalVideoUsage
local v15 = createSignal(Enum.ScaleType.Crop)

local function VideoSurface(t1: {[any]: any}) -- line: 76
	-- upvalues: useSignalState (copy), React (copy), createComputed (copy), v15 (copy), FFlagMomentsVideoCropRoundedCorners (copy), getFitSize (copy), getCropSize (copy)
	local v20 = useSignalState(t1.getItemSize)
	local getResolution = t1.getResolution
	local v22 = React.useMemo(function() -- line: 82
		-- upvalues: createComputed (copy), getResolution (copy)
		return createComputed(function(p1) -- line: 83
			-- upvalues: getResolution (copy)
			return getResolution(p1)
		end)
	end, { getResolution })
	local v23 = useSignalState(v22)
	local v24 = useSignalState(t1.getScaleType or v15)
	local uDim2 = UDim2.fromScale(1, 1)
	local Stretch = Enum.ScaleType.Stretch

	if FFlagMomentsVideoCropRoundedCorners and v24 ~= Enum.ScaleType.Fit then
		Stretch = Enum.ScaleType.Crop
	elseif v23 ~= nil and v23.X > 0 and v23.Y > 0 then
		uDim2 = if v24 ~= Enum.ScaleType.Fit then getCropSize(v20, v23) else getFitSize(v20, v23)
	end

	return React.createElement("VideoDisplay", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = uDim2,
		ScaleType = Stretch,
		ZIndex = t1.zIndex,
		ref = t1.setSurface
	}, {
		Corner = if t1.cornerRadius == nil then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cornerRadius)
		})
	})
end
local function defaultObserveLoaded(p2) -- line: 170
	return {
		getIsLoaded = function() -- line: 172
			-- upvalues: p2 (copy)
			return p2.IsLoaded
		end,
		connect = function(p3) -- line: 175
			-- upvalues: p2 (copy)
			local connection = p2:GetPropertyChangedSignal("IsLoaded"):Connect(function() -- line: 176
				-- upvalues: p3 (copy), p2 (copy)
				p3(p2.IsLoaded)
			end)

			return function() -- line: 179
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end
	}
end
local function createVideoNode(p4, p5) -- line: 186
	-- upvalues: createSignal (copy), defaultObserveLoaded (copy), createComputed (copy), FFlagLuaAppMomentsInternalVideoUsage (copy), GetFFlagMomentsVideoSurfaceMediaRect (copy), React (copy), VideoSurface (copy)
	local id = p4.id
	local content = p4.content
	local v32, v33 = createSignal(p4.region)
	local parent = p4.parent
	local v35 = p4.zIndex or 0
	local cornerRadius = p4.cornerRadius
	local runService = p5.runService
	local contentProvider = p5.contentProvider
	local v39 = p5.observeLoaded or defaultObserveLoaded
	local v40 = p5.loadVideo or function(p6) -- line: 207
		return p6:LoadAsync()
	end

	local function getRegionStart() -- line: 211
		-- upvalues: v32 (copy)
		local v79 = v32(false)

		if v79 ~= nil then
			return v79.startTime
		end

		return 0
	end

	local v42, v43 = createSignal(false)
	local v44, v45 = createSignal(false)
	local v46, v47 = createSignal(false)
	local v48, v49 = createSignal(false)
	local v50, v51 = createSignal(nil)
	local v52, v53 = createSignal(nil)
	local v54, v55 = createSignal(0)
	local v56, v57 = createSignal(0)
	local v58 = createComputed(function(p7) -- line: 233
		-- upvalues: v46 (copy), v44 (copy), v42 (copy)
		if v46(p7) then
			return "Playing"
		end

		if v44(p7) then
			return "Decoded"
		end

		if v42(p7) then
			return "Downloaded"
		end

		return "Idle"
	end)
	local v59 = createComputed(function(p8) -- line: 244
		-- upvalues: v32 (copy), v54 (copy)
		local v82 = v32(p8)

		if v82 ~= nil then
			return v82.endTime - v82.startTime
		end

		return v54(p8)
	end)
	local u60 = nil
	local u61 = nil
	local u62 = nil
	local t2 = {}
	local u64 = nil
	local connection = nil
	local u66 = false
	local n1 = 0
	local u68 = false

	local function regionEnd() -- line: 266
		-- upvalues: v32 (copy), v54 (copy)
		local v83 = v32(false)

		if v83 ~= nil then
			return v83.endTime
		end

		return (v54(false))
	end
	local function applyLoopingMode() -- line: 273
		-- upvalues: u60 (ref), v32 (copy), v54 (copy), u66 (ref)
		local v84 = u60

		if not v84 then
			return
		end

		local v85 = v32(false)
		local v86 = v54(false)
		local v87 = v85 == nil or v86 > 0 and (v85.startTime <= 0.05 and v85.endTime >= v86 - 0.05)

		u66 = v87
		v84.Looping = v87
	end
	local function ensureWire() -- line: 286
		-- upvalues: u60 (ref), u62 (ref), u61 (ref)
		local v88 = u60
		local v89 = u62

		if not v88 or (not v89 or u61) then
			return
		end

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = v88
		Wire.TargetInstance = v89
		Wire.Parent = v88
		u61 = Wire
	end
	local function tearWire() -- line: 301
		-- upvalues: u61 (ref)
		if u61 then
			u61:Destroy()
			u61 = nil
		end
	end
	local function onStep() -- line: 308
		-- upvalues: u60 (ref), v32 (copy), u66 (ref), v54 (copy), v57 (copy)
		local v91 = u60

		if not v91 then
			return
		end

		local v92 = v32(false)
		local v93 = v92 == nil and 0 or v92.startTime
		local TimePosition = v91.TimePosition

		if not u66 then
			local v95 = v32(false)

			if TimePosition >= ((if v95 == nil then v54(false) else v95.endTime)) - 0.05 then
				TimePosition = v93
				v91.TimePosition = v93
			end
		end

		v57(TimePosition - v93)
	end
	local function startPlaybackLoop() -- line: 322
		-- upvalues: connection (ref), runService (copy), onStep (copy)
		if connection then
			return
		end

		connection = runService.RenderStepped:Connect(onStep)
	end
	local function stopPlaybackLoop() -- line: 329
		-- upvalues: connection (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	return {
		kind = "video",
		usesDecoder = true,
		id = id,
		zIndex = v35,
		audioStem = {
			defaultVolume = 1,
			stemId = id
		},
		assets = function() -- line: 336
			-- upvalues: content (copy)
			return { content }
		end,
		download = function() -- line: 340
			-- upvalues: n1 (ref), contentProvider (copy), content (copy), u68 (ref), v43 (copy)
			local v96 = n1

			contentProvider:PreloadAsync({ content.Uri })

			if u68 or v96 ~= n1 then
				return
			end

			v43(true)
		end,
		decode = function() -- line: 354
			-- upvalues: u68 (ref), u60 (ref), v51 (copy), FFlagLuaAppMomentsInternalVideoUsage (copy), content (copy), parent (copy), v39 (copy), v49 (copy), u64 (ref), v53 (copy), t2 (copy), v55 (copy), v32 (copy), v54 (copy), u66 (ref), u62 (ref), u61 (ref), v40 (copy), v45 (copy)
			if u68 or u60 then
				return
			end

			v51(nil)

			local VideoPlayer = Instance.new("VideoPlayer")

			VideoPlayer.Name = "VideoPlayer"
			VideoPlayer.Looping = false

			if FFlagLuaAppMomentsInternalVideoUsage then
				VideoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
			end

			VideoPlayer.VideoContent = content
			VideoPlayer.Parent = parent
			u60 = VideoPlayer

			local v98 = v39(VideoPlayer)

			v49(v98.getIsLoaded())
			u64 = v98.connect(function(p9) -- line: 372
				-- upvalues: v49 (copy)
				v49(p9)
			end)

			local function readResolution() -- line: 376
				-- upvalues: VideoPlayer (copy), v53 (copy)
				local Resolution = VideoPlayer.Resolution

				v53(if not (Resolution.X > 0) or not (Resolution.Y > 0) then nil else Resolution)
			end

			local Resolution = VideoPlayer.Resolution

			v53(if not (Resolution.X > 0) or not (Resolution.Y > 0) then nil else Resolution)
			table.insert(t2, VideoPlayer:GetPropertyChangedSignal("Resolution"):Connect(readResolution))
			v55(VideoPlayer.TimeLength)
			table.insert(t2, VideoPlayer:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 386
				-- upvalues: v55 (copy), VideoPlayer (copy), u60 (ref), v32 (copy), v54 (copy), u66 (ref)
				v55(VideoPlayer.TimeLength)

				local v143 = u60

				if not v143 then
					return
				end

				local v144 = v32(false)
				local v145 = v54(false)
				local v146 = v144 == nil or v145 > 0 and (v144.startTime <= 0.05 and v144.endTime >= v145 - 0.05)

				u66 = v146
				v143.Looping = v146
			end))

			local v101 = u60

			if v101 then
				local v102 = v32(false)
				local v103 = v54(false)
				local v104 = v102 == nil or v103 > 0 and (v102.startTime <= 0.05 and v102.endTime >= v103 - 0.05)

				u66 = v104
				v101.Looping = v104
			end

			local v105 = u60
			local v106 = u62

			if v105 and v106 and not u61 then
				local Wire = Instance.new("Wire")

				Wire.SourceInstance = v105
				Wire.TargetInstance = v106
				Wire.Parent = v105
				u61 = Wire
			end

			task.spawn(function() -- line: 399
				-- upvalues: u68 (ref), u60 (ref), VideoPlayer (copy), v40 (copy), v51 (copy), v49 (copy), v98 (copy)
				if u68 or u60 ~= VideoPlayer then
					return
				end

				local ok, result = pcall(v40, VideoPlayer)

				if u68 or u60 ~= VideoPlayer then
					return
				end

				if not ok then
					v51(`video load errored: { tostring(result) }`)

					return
				end

				if result == Enum.AssetFetchStatus.Success then
					v49(v98.getIsLoaded())
					v51(nil)

					return
				end

				v51(`video load failed: { result.Name }`)
			end)
			v45(true)
		end,
		releaseDecoder = function() -- line: 423
			-- upvalues: u60 (ref), connection (ref), v47 (copy), u61 (ref), u64 (ref), t2 (copy), v45 (copy), v49 (copy), v51 (copy), v57 (copy)
			local v108 = u60

			if not v108 then
				return
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			v47(false)

			if u61 then
				u61:Destroy()
				u61 = nil
			end

			if u64 then
				u64()
				u64 = nil
			end

			for _, v110 in t2 do
				v110:Disconnect()
			end

			table.clear(t2)
			u60 = nil
			v108:Destroy()
			v45(false)
			v49(false)
			v51(nil)
			v57(0)
		end,
		getResourceLevel = v58,
		getAudioSource = function() -- line: 504
			-- upvalues: u60 (ref)
			local v132 = u60

			assert(v132, "createVideoNode: getAudioSource() requires decode() first")

			return v132
		end,
		render = function(p10) -- line: 521
			-- upvalues: GetFFlagMomentsVideoSurfaceMediaRect (copy), React (copy), VideoSurface (copy), v35 (copy), cornerRadius (copy)
			if GetFFlagMomentsVideoSurfaceMediaRect() then
				return React.createElement(VideoSurface, {
					getItemSize = p10.getItemSize,
					getResolution = p10.getResolution,
					getScaleType = p10.getScaleType,
					setSurface = p10.setSurface,
					zIndex = v35,
					cornerRadius = cornerRadius
				})
			end

			return React.createElement("VideoDisplay", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ScaleType = p10.scaleType or Enum.ScaleType.Crop,
				ZIndex = v35,
				ref = function(p11) -- line: 541
					-- upvalues: p10 (copy)
					p10.setSurface(p11)
				end
			}, {
				Corner = if cornerRadius == nil then nil else React.createElement("UICorner", {
					CornerRadius = UDim.new(0, cornerRadius)
				})
			})
		end,
		play = function() -- line: 453
			-- upvalues: u60 (ref), v32 (copy), v57 (copy), v47 (copy), connection (ref), runService (copy), onStep (copy)
			local v111 = u60

			if not v111 then
				return
			end

			local v112 = v32(false)

			v111.TimePosition = v112 == nil and 0 or v112.startTime
			v57(0)
			v111:Play()
			v47(true)

			if connection then
				return
			end

			connection = runService.RenderStepped:Connect(onStep)
		end,
		pause = function() -- line: 467
			-- upvalues: u60 (ref), v47 (copy), connection (ref)
			local v113 = u60

			if not v113 then
				return
			end

			v113:Pause()
			v47(false)

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end,
		seek = function(n2: number) -- line: 477
			-- upvalues: u60 (ref), v32 (copy), v54 (copy), v57 (copy)
			local v115 = u60

			if not v115 then
				return
			end

			local v116 = v32(false)
			local v117 = v116 == nil and 0 or v116.startTime
			local v118 = v117 + n2
			local v119 = v32(false)
			local v120 = math.clamp(v118, v117, if v119 == nil then v54(false) else v119.endTime)

			v115.TimePosition = v120
			v57(v120 - v117)
		end,
		setRegion = function(t3: {[any]: any}?) -- line: 490
			-- upvalues: v33 (copy), u60 (ref), v32 (copy), v54 (copy), u66 (ref), v57 (copy)
			v33(t3)

			local v122 = u60

			if v122 then
				local v123 = v32(false)
				local v124 = v54(false)
				local v125 = v123 == nil or v124 > 0 and (v123.startTime <= 0.05 and v123.endTime >= v124 - 0.05)

				u66 = v125
				v122.Looping = v125
			end

			local v126 = u60

			if v126 ~= nil then
				local v127 = v32(false)
				local v128 = v127 == nil and 0 or v127.startTime
				local TimePosition = v126.TimePosition
				local v130 = v32(false)
				local v131 = math.clamp(TimePosition, v128, if v130 == nil then v54(false) else v130.endTime)

				v126.TimePosition = v131
				v57(v131 - v128)
			end
		end,
		dispose = function() -- line: 554
			-- upvalues: u68 (ref), n1 (ref), connection (ref), u61 (ref), u64 (ref), t2 (copy), u60 (ref), u62 (ref)
			if u68 then
				return
			end

			u68 = true
			n1 += 1

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if u61 then
				u61:Destroy()
				u61 = nil
			end

			if u64 then
				u64()
				u64 = nil
			end

			for _, v139 in t2 do
				v139:Disconnect()
			end

			table.clear(t2)

			if u60 then
				u60:Destroy()
				u60 = nil
			end

			u62 = nil
		end,
		getIsLoaded = v48,
		getFailureReason = v50,
		getResolution = v52,
		getTimeLength = v54,
		getDuration = v59,
		getPosition = v56,
		setSurface = function(p12) -- line: 512
			-- upvalues: u62 (ref), u61 (ref), u60 (ref)
			if p12 == u62 then
				return
			end

			if u61 then
				u61:Destroy()
				u61 = nil
			end

			u62 = p12

			local v134 = u60
			local v135 = u62

			if v134 and v135 then
				if u61 then
					return
				end

				local Wire = Instance.new("Wire")

				Wire.SourceInstance = v134
				Wire.TargetInstance = v135
				Wire.Parent = v134
				u61 = Wire
			end
		end
	}
end

return {
	kind = "video",
	create = createVideoNode
}
