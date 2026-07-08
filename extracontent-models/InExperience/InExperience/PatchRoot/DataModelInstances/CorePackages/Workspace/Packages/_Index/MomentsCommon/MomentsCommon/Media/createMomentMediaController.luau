local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Cryo = require(MomentsCommonParent.Cryo)
local Signals = require(MomentsCommonParent.Signals)

require(MomentsCommonParent.MomentsTypes)
require(MomentsCommon.Media.MediaTypes)

local createAudioGraph = require(MomentsCommon.Media.createAudioGraph)
local mediaRoot = require(MomentsCommon.Media.mediaRoot)

require(MomentsCommon.Media.mediaNodeRegistry)

local defaultMediaNodeRegistry = require(MomentsCommon.Media.defaultMediaNodeRegistry)
local preloadConstants = require(MomentsCommon.Media.Preload.preloadConstants)

require(MomentsCommon.Media.Nodes.createVideoNode)
require(MomentsCommon.Media.Nodes.createScreenshotNode)
require(MomentsCommon.Media.Nodes.createMusicNode)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local loopEpsilonSeconds = preloadConstants.loopEpsilonSeconds

local function createMomentMediaController(p1, t1: {[any]: any}) -- line: 98
	-- upvalues: defaultMediaNodeRegistry (copy), mediaRoot (copy), createAudioGraph (copy), createSignal (copy), createComputed (copy), Cryo (copy), loopEpsilonSeconds (copy)
	local services = t1.services
	local v16 = t1.registry or defaultMediaNodeRegistry()
	local v17 = p1.captureType == Enum.CaptureType.Video
	local v18 = mediaRoot(p1.momentId, t1.parent)
	local folder = v18.folder
	local v20 = createAudioGraph(folder, t1.audioDeviceOutput, t1.masterVolume)
	local edits = p1.edits
	local t2 = {}
	local t3 = {}

	local function addNode(p2) -- line: 114
		-- upvalues: t2 (copy), t3 (copy)
		table.insert(t2, p2)
		t3[p2.id] = p2
	end

	local u25 = nil
	local u26 = nil

	if v17 then
		local v27 = v16.create("video", {
			id = "video",
			kind = "video",
			zIndex = 0,
			content = p1.content,
			region = if edits == nil then nil else edits.trim,
			parent = folder,
			cornerRadius = p1.cornerRadius
		}, services)

		u25 = v27
		table.insert(t2, v27)
		t3[v27.id] = v27
	else
		local v28 = v16.create("screenshot", {
			id = "screenshot",
			kind = "screenshot",
			image = p1.content.Uri,
			poster = if p1.posterContent == nil then nil else p1.posterContent.Uri,
			parent = folder
		}, services)

		u26 = v28
		table.insert(t2, v28)
		t3[v28.id] = v28
	end

	local u29 = nil

	if edits ~= nil and edits.music ~= nil then
		local v30 = v16.create("music", {
			id = "music",
			kind = "music",
			assetId = edits.music.assetId,
			startTime = edits.music.startTime,
			parent = folder
		}, services)

		u29 = v30
		table.insert(t2, v30)
		t3[v30.id] = v30
	end

	local v31 = u29 ~= nil

	if edits ~= nil and edits.textOverlays ~= nil then
		for v32, v33 in edits.textOverlays do
			local v34 = `text:{ v32 - 1 }`
			local v35 = v16.create("text", {
				kind = "text",
				id = v34,
				overlay = v33
			}, services)

			table.insert(t2, v35)
			t3[v35.id] = v35
		end
	end

	local t4 = {}

	for _, v38 in t2 do
		if v38.usesDecoder then
			table.insert(t4, v38)
		end
	end

	local t5 = {}

	for _, v41 in t2 do
		local render = v41.render

		if render ~= nil then
			table.insert(t5, {
				id = v41.id,
				zIndex = v41.zIndex or 0,
				render = render
			})
		end
	end

	table.sort(t5, function(p3, p4) -- line: 200
		return p3.zIndex < p4.zIndex
	end)

	local v43 = createSignal(t5)
	local t6 = {}

	local function addStem(p5) -- line: 212
		-- upvalues: t6 (copy), v20 (copy)
		local audioStem = p5.audioStem
		local getAudioSource = p5.getAudioSource

		if audioStem == nil or (getAudioSource == nil or t6[audioStem.stemId] ~= nil) then
			return
		end

		t6[audioStem.stemId] = v20.addStem(audioStem.stemId, getAudioSource(), audioStem.defaultVolume)
	end
	local function removeStem(p6) -- line: 220
		-- upvalues: t6 (copy)
		local audioStem = p6.audioStem

		if audioStem == nil then
			return
		end

		local v81 = t6[audioStem.stemId]

		if v81 ~= nil then
			v81()
			t6[audioStem.stemId] = nil
		end
	end

	for _, v48 in t2 do
		if v48.getAudioSource ~= nil and not v48.usesDecoder then
			local audioStem = v48.audioStem
			local getAudioSource = v48.getAudioSource

			if audioStem ~= nil and getAudioSource ~= nil and t6[audioStem.stemId] == nil then
				t6[audioStem.stemId] = v20.addStem(audioStem.stemId, getAudioSource(), audioStem.defaultVolume)
			end
		end
	end

	local v51, v52 = createSignal(false)
	local v53, v54 = createSignal(false)
	local v55, v56 = createSignal(false)
	local v57, v58 = createSignal(0)
	local v59, v60 = createSignal(false)
	local u61 = false
	local u62 = nil
	local v63 = if u25 == nil then u26.getPosition else u25.getPosition
	local v64 = createComputed(function(p7) -- line: 265
		-- upvalues: v55 (copy), v53 (copy), v51 (copy)
		if v55(p7) then
			return "Playing"
		end

		if v53(p7) then
			return "Decoded"
		end

		if v51(p7) then
			return "Downloaded"
		end

		return "Idle"
	end)
	local v65 = createComputed(function(p8) -- line: 279
		-- upvalues: u25 (ref), v53 (copy), v51 (copy), u26 (ref), v55 (copy), v59 (copy)
		local v84 = nil
		local v85, v86, v87, v88

		if u25 ~= nil then
			v85 = u25.getFailureReason(p8)
			v86 = if v85 == nil then if not u25.getIsLoaded(p8) then not v53(p8) and not v51(p8) and "Idle" or "Loading" else "Ready" else "Failed"
			v84 = u25.getResolution(p8)
			v87 = u25.getDuration(p8)
			v88 = u25.getTimeLength(p8)
		else
			local v89 = u26

			v85 = v89.getFailureReason(p8)
			v86 = if v85 == nil then not v89.getIsImageLoaded(p8) and "Loading" or "Ready" else "Failed"
			v87 = v89.getDuration()
			v88 = v89.getDuration()
		end

		return {
			readiness = v86,
			resolution = v84,
			duration = v87,
			timeLength = v88,
			isPlaying = v55(p8),
			isMuted = v59(p8),
			failureReason = v85
		}
	end, Cryo.Dictionary.equals)
	local connection = nil
	local n1 = 0

	local function startRealignLoop() -- line: 332
		-- upvalues: connection (ref), u29 (ref), n1 (ref), v63 (copy), services (copy), u61 (ref), loopEpsilonSeconds (copy)
		if connection ~= nil or u29 == nil then
			return
		end

		n1 = v63(false)
		connection = services.runService.RenderStepped:Connect(function() -- line: 337
			-- upvalues: u61 (ref), v63 (copy), n1 (ref), loopEpsilonSeconds (copy), u29 (ref)
			if u61 then
				return
			end

			local v131 = v63(false)

			if v131 < n1 - loopEpsilonSeconds then
				u29.realignToRegionStart()
			end

			n1 = v131
		end)
	end
	local function stopRealignLoop() -- line: 348
		-- upvalues: connection (ref)
		if connection ~= nil then
			connection:Disconnect()
			connection = nil
		end
	end
	local function play() -- line: 411
		-- upvalues: u61 (ref), u62 (ref), u29 (ref), u26 (ref), t2 (copy), v56 (copy), connection (ref), n1 (ref), v63 (copy), services (copy), loopEpsilonSeconds (copy)
		if u61 then
			return
		end

		local v102 = u62

		u62 = nil

		if u29 ~= nil then
			u29.realignToRegionStart()
		end

		if u26 ~= nil then
			u26.seek(0)
		end

		for _, v104 in t2 do
			local play2 = v104.play

			if play2 ~= nil then
				play2()
			end
		end

		if v102 ~= nil and v102 > 0 then
			for _, v107 in t2 do
				local seek = v107.seek

				if seek ~= nil then
					seek(v102)
				end
			end
		end

		v56(true)

		if connection == nil then
			if u29 == nil then
				return
			end

			n1 = v63(false)
			connection = services.runService.RenderStepped:Connect(function() -- line: 337
				-- upvalues: u61 (ref), v63 (copy), n1 (ref), loopEpsilonSeconds (copy), u29 (ref)
				if u61 then
					return
				end

				local v132 = v63(false)

				if v132 < n1 - loopEpsilonSeconds then
					u29.realignToRegionStart()
				end

				n1 = v132
			end)
		end
	end
	local function pauseAndRemember(n2: number) -- line: 455
		-- upvalues: u61 (ref), u25 (ref), u62 (ref), v63 (copy), t2 (copy), v56 (copy), connection (ref)
		if u61 then
			return
		end

		if u25 ~= nil then
			u62 = math.max(0, v63(false) - n2)
		end

		for _, v111 in t2 do
			local pause = v111.pause

			if pause ~= nil then
				pause()
			end
		end

		v56(false)

		if connection ~= nil then
			connection:Disconnect()
			connection = nil
		end
	end

	local t7 = {
		setVolume = function(s1: string, n3: number) -- line: 552
			-- upvalues: u61 (ref), v20 (copy)
			if not u61 then
				v20.setVolume(s1, n3)
			end
		end,
		setMuted = function(s2: string, b1: boolean) -- line: 557
			-- upvalues: u61 (ref), v20 (copy)
			if not u61 then
				v20.setMuted(s2, b1)
			end
		end,
		setMasterMuted = function(b2: boolean) -- line: 519
			-- upvalues: u61 (ref), v20 (copy), v60 (copy)
			if u61 then
				return
			end

			v20.setMasterMuted(b2)
			v60(b2)
		end
	}

	return {
		getState = v65,
		getPosition = v63,
		getUserToggleNonce = v57,
		getVisualLayers = v43,
		getResourceLevel = v64,
		audio = t7,
		download = function() -- line: 355
			-- upvalues: u61 (ref), t2 (copy), v52 (copy)
			if u61 then
				return
			end

			for _, v91 in t2 do
				v91.download()
			end

			if u61 then
				return
			end

			v52(true)
		end,
		decode = function() -- line: 373
			-- upvalues: u61 (ref), t4 (copy), t6 (copy), v20 (copy), v31 (copy), v54 (copy)
			if u61 then
				return
			end

			for _, v93 in t4 do
				local decode = v93.decode

				if decode ~= nil then
					decode()
				end

				local audioStem = v93.audioStem
				local getAudioSource = v93.getAudioSource

				if audioStem ~= nil and getAudioSource ~= nil and t6[audioStem.stemId] == nil then
					t6[audioStem.stemId] = v20.addStem(audioStem.stemId, getAudioSource(), audioStem.defaultVolume)
				end
			end

			if v31 and t6.video ~= nil then
				v20.setMuted("video", true)
			end

			v54(true)
		end,
		releaseDecoder = function() -- line: 394
			-- upvalues: u61 (ref), t4 (copy), t6 (copy), v54 (copy), v56 (copy)
			if u61 then
				return
			end

			for _, v98 in t4 do
				local audioStem = v98.audioStem

				if audioStem ~= nil then
					local v100 = t6[audioStem.stemId]

					if v100 ~= nil then
						v100()
						t6[audioStem.stemId] = nil
					end
				end

				local releaseDecoder = v98.releaseDecoder

				if releaseDecoder ~= nil then
					releaseDecoder()
				end
			end

			v54(false)
			v56(false)
		end,
		play = play,
		pause = function(n4: number?) -- line: 475
			-- upvalues: pauseAndRemember (copy)
			pauseAndRemember(n4 or 2)
		end,
		toggle = function() -- line: 479
			-- upvalues: u61 (ref), v55 (copy), pauseAndRemember (copy), play (copy), v58 (copy), v57 (copy)
			if u61 then
				return
			end

			if v55(false) then
				pauseAndRemember(0)
			else
				play()
			end

			v58(v57(false) + 1)
		end,
		seek = function(n5: number) -- line: 496
			-- upvalues: u61 (ref), t2 (copy)
			if u61 then
				return
			end

			for _, v116 in t2 do
				local seek = v116.seek

				if seek ~= nil then
					seek(n5)
				end
			end
		end,
		setRegion = function(p9) -- line: 510
			-- upvalues: u61 (ref), u25 (ref)
			if u61 then
				return
			end

			if u25 ~= nil then
				u25.setRegion(p9)
			end
		end,
		setActive = function(b3: boolean) -- line: 529
			-- upvalues: u62 (ref), u61 (ref), v20 (copy), v60 (copy)
			if b3 then
				u62 = nil
			end

			local v121 = not b3

			if u61 then
				return
			end

			v20.setMasterMuted(v121)
			v60(v121)
		end,
		setSurface = function(s3: string, p10) -- line: 541
			-- upvalues: u61 (ref), t3 (copy)
			if u61 then
				return
			end

			local v124 = t3[s3]

			if v124 ~= nil and v124.setSurface ~= nil then
				v124.setSurface(p10)
			end
		end,
		getVideoPreviewSource = function() -- line: 583
			-- upvalues: v17 (copy), p1 (copy), edits (copy)
			if not v17 then
				return nil
			end

			return {
				content = p1.content,
				region = if edits == nil then nil else edits.trim
			}
		end,
		getHasVideoPreview = function() -- line: 593
			-- upvalues: v17 (copy)
			return v17
		end,
		dispose = function() -- line: 565
			-- upvalues: u61 (ref), connection (ref), t2 (copy), v20 (copy), v18 (copy)
			if u61 then
				return
			end

			u61 = true

			if connection ~= nil then
				connection:Disconnect()
				connection = nil
			end

			for _, v130 in t2 do
				v130.dispose()
			end

			v20.dispose()
			v18.dispose()
		end
	}
end

return createMomentMediaController
