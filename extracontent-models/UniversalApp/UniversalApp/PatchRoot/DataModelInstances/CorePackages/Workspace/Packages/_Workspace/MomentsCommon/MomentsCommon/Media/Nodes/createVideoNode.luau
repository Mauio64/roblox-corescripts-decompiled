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
local useSignalState = SignalsReact.useSignalState
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local FFlagLuaAppMomentsInternalVideoUsage = SharedFlags.FFlagLuaAppMomentsInternalVideoUsage
local v14 = createSignal(Enum.ScaleType.Crop)

local function VideoSurface(t1: {[any]: any}) -- line: 75
	-- upvalues: useSignalState (copy), React (copy), createComputed (copy), v14 (copy), getFitSize (copy), getCropSize (copy)
	local v19 = useSignalState(t1.getItemSize)
	local getResolution = t1.getResolution
	local v21 = React.useMemo(function() -- line: 81
		-- upvalues: createComputed (copy), getResolution (copy)
		return createComputed(function(p1) -- line: 82
			-- upvalues: getResolution (copy)
			return getResolution(p1)
		end)
	end, { getResolution })
	local v22 = useSignalState(v21)
	local v23 = useSignalState(t1.getScaleType or v14)
	local uDim2 = UDim2.fromScale(1, 1)

	if v22 ~= nil and (v22.X > 0 and v22.Y > 0) then
		uDim2 = if v23 ~= Enum.ScaleType.Fit then getCropSize(v19, v22) else getFitSize(v19, v22)
	end

	return React.createElement("VideoDisplay", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = uDim2,
		ScaleType = Enum.ScaleType.Stretch,
		ZIndex = t1.zIndex,
		ref = t1.setSurface
	}, {
		Corner = if t1.cornerRadius == nil then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cornerRadius)
		})
	})
end
local function defaultObserveLoaded(p2) -- line: 167
	return {
		getIsLoaded = function() -- line: 169
			-- upvalues: p2 (copy)
			return p2.IsLoaded
		end,
		connect = function(p3) -- line: 172
			-- upvalues: p2 (copy)
			local connection = p2:GetPropertyChangedSignal("IsLoaded"):Connect(function() -- line: 173
				-- upvalues: p3 (copy), p2 (copy)
				p3(p2.IsLoaded)
			end)

			return function() -- line: 176
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end
	}
end
local function createVideoNode(p4, p5) -- line: 183
	-- upvalues: createSignal (copy), defaultObserveLoaded (copy), createComputed (copy), FFlagLuaAppMomentsInternalVideoUsage (copy), GetFFlagMomentsVideoSurfaceMediaRect (copy), React (copy), VideoSurface (copy)
	local id = p4.id
	local content = p4.content
	local v30, v31 = createSignal(p4.region)
	local parent = p4.parent
	local v33 = p4.zIndex or 0
	local cornerRadius = p4.cornerRadius
	local runService = p5.runService
	local contentProvider = p5.contentProvider
	local v37 = p5.observeLoaded or defaultObserveLoaded
	local v38 = p5.loadVideo or function(p6) -- line: 204
		return p6:LoadAsync()
	end

	local function getRegionStart() -- line: 208
		-- upvalues: v30 (copy)
		local v77 = v30(false)

		if v77 ~= nil then
			return v77.startTime
		end

		return 0
	end

	local v40, v41 = createSignal(false)
	local v42, v43 = createSignal(false)
	local v44, v45 = createSignal(false)
	local v46, v47 = createSignal(false)
	local v48, v49 = createSignal(nil)
	local v50, v51 = createSignal(nil)
	local v52, v53 = createSignal(0)
	local v54, v55 = createSignal(0)
	local v56 = createComputed(function(p7) -- line: 230
		-- upvalues: v44 (copy), v42 (copy), v40 (copy)
		if v44(p7) then
			return "Playing"
		end

		if v42(p7) then
			return "Decoded"
		end

		if v40(p7) then
			return "Downloaded"
		end

		return "Idle"
	end)
	local v57 = createComputed(function(p8) -- line: 241
		-- upvalues: v30 (copy), v52 (copy)
		local v80 = v30(p8)

		if v80 ~= nil then
			return v80.endTime - v80.startTime
		end

		return v52(p8)
	end)
	local u58 = nil
	local u59 = nil
	local u60 = nil
	local t2 = {}
	local u62 = nil
	local connection = nil
	local u64 = false
	local n1 = 0
	local u66 = false

	local function regionEnd() -- line: 263
		-- upvalues: v30 (copy), v52 (copy)
		local v81 = v30(false)

		if v81 ~= nil then
			return v81.endTime
		end

		return (v52(false))
	end
	local function applyLoopingMode() -- line: 270
		-- upvalues: u58 (ref), v30 (copy), v52 (copy), u64 (ref)
		local v82 = u58

		if not v82 then
			return
		end

		local v83 = v30(false)
		local v84 = v52(false)
		local v85 = v83 == nil or v84 > 0 and (v83.startTime <= 0.05 and v83.endTime >= v84 - 0.05)

		u64 = v85
		v82.Looping = v85
	end
	local function ensureWire() -- line: 283
		-- upvalues: u58 (ref), u60 (ref), u59 (ref)
		local v86 = u58
		local v87 = u60

		if not v86 or (not v87 or u59) then
			return
		end

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = v86
		Wire.TargetInstance = v87
		Wire.Parent = v86
		u59 = Wire
	end
	local function tearWire() -- line: 298
		-- upvalues: u59 (ref)
		if u59 then
			u59:Destroy()
			u59 = nil
		end
	end
	local function onStep() -- line: 305
		-- upvalues: u58 (ref), v30 (copy), u64 (ref), v52 (copy), v55 (copy)
		local v89 = u58

		if not v89 then
			return
		end

		local v90 = v30(false)
		local v91 = v90 == nil and 0 or v90.startTime
		local TimePosition = v89.TimePosition

		if not u64 then
			local v93 = v30(false)

			if TimePosition >= ((if v93 == nil then v52(false) else v93.endTime)) - 0.05 then
				TimePosition = v91
				v89.TimePosition = v91
			end
		end

		v55(TimePosition - v91)
	end
	local function startPlaybackLoop() -- line: 319
		-- upvalues: connection (ref), runService (copy), onStep (copy)
		if connection then
			return
		end

		connection = runService.RenderStepped:Connect(onStep)
	end
	local function stopPlaybackLoop() -- line: 326
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
		zIndex = v33,
		audioStem = {
			defaultVolume = 1,
			stemId = id
		},
		assets = function() -- line: 333
			-- upvalues: content (copy)
			return { content }
		end,
		download = function() -- line: 337
			-- upvalues: n1 (ref), contentProvider (copy), content (copy), u66 (ref), v41 (copy)
			local v94 = n1

			contentProvider:PreloadAsync({ content.Uri })

			if u66 or v94 ~= n1 then
				return
			end

			v41(true)
		end,
		decode = function() -- line: 351
			-- upvalues: u66 (ref), u58 (ref), v49 (copy), FFlagLuaAppMomentsInternalVideoUsage (copy), content (copy), parent (copy), v37 (copy), v47 (copy), u62 (ref), v51 (copy), t2 (copy), v53 (copy), v30 (copy), v52 (copy), u64 (ref), u60 (ref), u59 (ref), v38 (copy), v43 (copy)
			if u66 or u58 then
				return
			end

			v49(nil)

			local VideoPlayer = Instance.new("VideoPlayer")

			VideoPlayer.Name = "VideoPlayer"
			VideoPlayer.Looping = false

			if FFlagLuaAppMomentsInternalVideoUsage then
				VideoPlayer.InternalVideoUsage = Enum.InternalVideoUsage.WatchPage
			end

			VideoPlayer.VideoContent = content
			VideoPlayer.Parent = parent
			u58 = VideoPlayer

			local v96 = v37(VideoPlayer)

			v47(v96.getIsLoaded())
			u62 = v96.connect(function(p9) -- line: 369
				-- upvalues: v47 (copy)
				v47(p9)
			end)

			local function readResolution() -- line: 373
				-- upvalues: VideoPlayer (copy), v51 (copy)
				local Resolution = VideoPlayer.Resolution

				v51(if not (Resolution.X > 0) or not (Resolution.Y > 0) then nil else Resolution)
			end

			local Resolution = VideoPlayer.Resolution

			v51(if not (Resolution.X > 0) or not (Resolution.Y > 0) then nil else Resolution)
			table.insert(t2, VideoPlayer:GetPropertyChangedSignal("Resolution"):Connect(readResolution))
			v53(VideoPlayer.TimeLength)
			table.insert(t2, VideoPlayer:GetPropertyChangedSignal("TimeLength"):Connect(function() -- line: 383
				-- upvalues: v53 (copy), VideoPlayer (copy), u58 (ref), v30 (copy), v52 (copy), u64 (ref)
				v53(VideoPlayer.TimeLength)

				local v141 = u58

				if not v141 then
					return
				end

				local v142 = v30(false)
				local v143 = v52(false)
				local v144 = v142 == nil or v143 > 0 and (v142.startTime <= 0.05 and v142.endTime >= v143 - 0.05)

				u64 = v144
				v141.Looping = v144
			end))

			local v99 = u58

			if v99 then
				local v100 = v30(false)
				local v101 = v52(false)
				local v102 = v100 == nil or v101 > 0 and (v100.startTime <= 0.05 and v100.endTime >= v101 - 0.05)

				u64 = v102
				v99.Looping = v102
			end

			local v103 = u58
			local v104 = u60

			if v103 and v104 and not u59 then
				local Wire = Instance.new("Wire")

				Wire.SourceInstance = v103
				Wire.TargetInstance = v104
				Wire.Parent = v103
				u59 = Wire
			end

			task.spawn(function() -- line: 396
				-- upvalues: u66 (ref), u58 (ref), VideoPlayer (copy), v38 (copy), v49 (copy), v47 (copy), v96 (copy)
				if u66 or u58 ~= VideoPlayer then
					return
				end

				local ok, result = pcall(v38, VideoPlayer)

				if u66 or u58 ~= VideoPlayer then
					return
				end

				if not ok then
					v49(`video load errored: { tostring(result) }`)

					return
				end

				if result == Enum.AssetFetchStatus.Success then
					v47(v96.getIsLoaded())
					v49(nil)

					return
				end

				v49(`video load failed: { result.Name }`)
			end)
			v43(true)
		end,
		releaseDecoder = function() -- line: 420
			-- upvalues: u58 (ref), connection (ref), v45 (copy), u59 (ref), u62 (ref), t2 (copy), v43 (copy), v47 (copy), v49 (copy), v55 (copy)
			local v106 = u58

			if not v106 then
				return
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			v45(false)

			if u59 then
				u59:Destroy()
				u59 = nil
			end

			if u62 then
				u62()
				u62 = nil
			end

			for _, v108 in t2 do
				v108:Disconnect()
			end

			table.clear(t2)
			u58 = nil
			v106:Destroy()
			v43(false)
			v47(false)
			v49(nil)
			v55(0)
		end,
		getResourceLevel = v56,
		getAudioSource = function() -- line: 501
			-- upvalues: u58 (ref)
			local v130 = u58

			assert(v130, "createVideoNode: getAudioSource() requires decode() first")

			return v130
		end,
		render = function(p10) -- line: 518
			-- upvalues: GetFFlagMomentsVideoSurfaceMediaRect (copy), React (copy), VideoSurface (copy), v33 (copy), cornerRadius (copy)
			if GetFFlagMomentsVideoSurfaceMediaRect() then
				return React.createElement(VideoSurface, {
					getItemSize = p10.getItemSize,
					getResolution = p10.getResolution,
					getScaleType = p10.getScaleType,
					setSurface = p10.setSurface,
					zIndex = v33,
					cornerRadius = cornerRadius
				})
			end

			return React.createElement("VideoDisplay", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ScaleType = p10.scaleType or Enum.ScaleType.Crop,
				ZIndex = v33,
				ref = function(p11) -- line: 538
					-- upvalues: p10 (copy)
					p10.setSurface(p11)
				end
			}, {
				Corner = if cornerRadius == nil then nil else React.createElement("UICorner", {
					CornerRadius = UDim.new(0, cornerRadius)
				})
			})
		end,
		play = function() -- line: 450
			-- upvalues: u58 (ref), v30 (copy), v55 (copy), v45 (copy), connection (ref), runService (copy), onStep (copy)
			local v109 = u58

			if not v109 then
				return
			end

			local v110 = v30(false)

			v109.TimePosition = v110 == nil and 0 or v110.startTime
			v55(0)
			v109:Play()
			v45(true)

			if connection then
				return
			end

			connection = runService.RenderStepped:Connect(onStep)
		end,
		pause = function() -- line: 464
			-- upvalues: u58 (ref), v45 (copy), connection (ref)
			local v111 = u58

			if not v111 then
				return
			end

			v111:Pause()
			v45(false)

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end,
		seek = function(n2: number) -- line: 474
			-- upvalues: u58 (ref), v30 (copy), v52 (copy), v55 (copy)
			local v113 = u58

			if not v113 then
				return
			end

			local v114 = v30(false)
			local v115 = v114 == nil and 0 or v114.startTime
			local v116 = v115 + n2
			local v117 = v30(false)
			local v118 = math.clamp(v116, v115, if v117 == nil then v52(false) else v117.endTime)

			v113.TimePosition = v118
			v55(v118 - v115)
		end,
		setRegion = function(t3: {[any]: any}?) -- line: 487
			-- upvalues: v31 (copy), u58 (ref), v30 (copy), v52 (copy), u64 (ref), v55 (copy)
			v31(t3)

			local v120 = u58

			if v120 then
				local v121 = v30(false)
				local v122 = v52(false)
				local v123 = v121 == nil or v122 > 0 and (v121.startTime <= 0.05 and v121.endTime >= v122 - 0.05)

				u64 = v123
				v120.Looping = v123
			end

			local v124 = u58

			if v124 ~= nil then
				local v125 = v30(false)
				local v126 = v125 == nil and 0 or v125.startTime
				local TimePosition = v124.TimePosition
				local v128 = v30(false)
				local v129 = math.clamp(TimePosition, v126, if v128 == nil then v52(false) else v128.endTime)

				v124.TimePosition = v129
				v55(v129 - v126)
			end
		end,
		dispose = function() -- line: 551
			-- upvalues: u66 (ref), n1 (ref), connection (ref), u59 (ref), u62 (ref), t2 (copy), u58 (ref), u60 (ref)
			if u66 then
				return
			end

			u66 = true
			n1 += 1

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if u59 then
				u59:Destroy()
				u59 = nil
			end

			if u62 then
				u62()
				u62 = nil
			end

			for _, v137 in t2 do
				v137:Disconnect()
			end

			table.clear(t2)

			if u58 then
				u58:Destroy()
				u58 = nil
			end

			u60 = nil
		end,
		getIsLoaded = v46,
		getFailureReason = v48,
		getResolution = v50,
		getTimeLength = v52,
		getDuration = v57,
		getPosition = v54,
		setSurface = function(p12) -- line: 509
			-- upvalues: u60 (ref), u59 (ref), u58 (ref)
			if p12 == u60 then
				return
			end

			if u59 then
				u59:Destroy()
				u59 = nil
			end

			u60 = p12

			local v132 = u58
			local v133 = u60

			if v132 and v133 then
				if u59 then
					return
				end

				local Wire = Instance.new("Wire")

				Wire.SourceInstance = v132
				Wire.TargetInstance = v133
				Wire.Parent = v132
				u59 = Wire
			end
		end
	}
end

return {
	kind = "video",
	create = createVideoNode
}
