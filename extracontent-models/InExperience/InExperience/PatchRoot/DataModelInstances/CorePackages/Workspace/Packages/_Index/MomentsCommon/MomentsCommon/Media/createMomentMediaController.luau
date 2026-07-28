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
local FFlagMomentsLoopOnEndSeek = require(MomentsCommon.Flags.FFlagMomentsLoopOnEndSeek)

require(MomentsCommon.Media.Nodes.createVideoNode)
require(MomentsCommon.Media.Nodes.createScreenshotNode)
require(MomentsCommon.Media.Nodes.createMusicNode)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local GetFFlagMomentsStickerButton = require(MomentsCommon.Flags.GetFFlagMomentsStickerButton)
local loopEpsilonSeconds = preloadConstants.loopEpsilonSeconds

local function createMomentMediaController(p1, t1: {[any]: any}) -- line: 102
	-- upvalues: defaultMediaNodeRegistry (copy), mediaRoot (copy), createAudioGraph (copy), GetFFlagMomentsStickerButton (copy), createSignal (copy), createComputed (copy), Cryo (copy), loopEpsilonSeconds (copy), FFlagMomentsLoopOnEndSeek (copy)
	local services = t1.services
	local v18 = t1.registry or defaultMediaNodeRegistry()
	local v19 = p1.captureType == Enum.CaptureType.Video
	local v20 = mediaRoot(p1.momentId, t1.parent)
	local folder = v20.folder
	local v22 = createAudioGraph(folder, t1.audioDeviceOutput, t1.masterVolume)
	local edits = p1.edits
	local t2 = {}
	local t3 = {}

	local function addNode(p2) -- line: 118
		-- upvalues: t2 (copy), t3 (copy)
		table.insert(t2, p2)
		t3[p2.id] = p2
	end

	local u27 = nil
	local u28 = nil

	if v19 then
		local v29 = v18.create("video", {
			id = "video",
			kind = "video",
			zIndex = 0,
			content = p1.content,
			region = if edits == nil then nil else edits.trim,
			parent = folder,
			cornerRadius = p1.cornerRadius
		}, services)

		u27 = v29
		table.insert(t2, v29)
		t3[v29.id] = v29
	else
		local v30 = v18.create("screenshot", {
			id = "screenshot",
			kind = "screenshot",
			image = p1.content.Uri,
			poster = if p1.posterContent == nil then nil else p1.posterContent.Uri,
			parent = folder
		}, services)

		u28 = v30
		table.insert(t2, v30)
		t3[v30.id] = v30
	end

	local u31 = nil

	if edits ~= nil and edits.music ~= nil then
		local v32 = v18.create("music", {
			id = "music",
			kind = "music",
			assetId = edits.music.assetId,
			startTime = edits.music.startTime,
			parent = folder
		}, services)

		u31 = v32
		table.insert(t2, v32)
		t3[v32.id] = v32
	end

	local v33 = u31 ~= nil

	if edits ~= nil and edits.textOverlays ~= nil then
		for v34, v35 in edits.textOverlays do
			local v36 = `text:{ v34 - 1 }`
			local v37 = v18.create("text", {
				kind = "text",
				id = v36,
				overlay = v35
			}, services)

			table.insert(t2, v37)
			t3[v37.id] = v37
		end
	end

	if GetFFlagMomentsStickerButton() and edits ~= nil and edits.stickerOverlays ~= nil then
		for v38, v39 in edits.stickerOverlays do
			local v40 = `sticker:{ v38 - 1 }`
			local v41 = v18.create("sticker", {
				kind = "sticker",
				id = v40,
				overlay = v39
			}, services)

			table.insert(t2, v41)
			t3[v41.id] = v41
		end
	end

	local t4 = {}

	for _, v44 in t2 do
		if v44.usesDecoder then
			table.insert(t4, v44)
		end
	end

	local t5 = {}

	for _, v47 in t2 do
		local render = v47.render

		if render ~= nil then
			table.insert(t5, {
				id = v47.id,
				zIndex = v47.zIndex or 0,
				render = render
			})
		end
	end

	table.sort(t5, function(p3, p4) -- line: 220
		return p3.zIndex < p4.zIndex
	end)

	local v49 = createSignal(t5)
	local t6 = {}

	local function addStem(p5) -- line: 232
		-- upvalues: t6 (copy), v22 (copy)
		local audioStem = p5.audioStem
		local getAudioSource = p5.getAudioSource

		if audioStem == nil or (getAudioSource == nil or t6[audioStem.stemId] ~= nil) then
			return
		end

		t6[audioStem.stemId] = v22.addStem(audioStem.stemId, getAudioSource(), audioStem.defaultVolume)
	end
	local function removeStem(p6) -- line: 240
		-- upvalues: t6 (copy)
		local audioStem = p6.audioStem

		if audioStem == nil then
			return
		end

		local v87 = t6[audioStem.stemId]

		if v87 ~= nil then
			v87()
			t6[audioStem.stemId] = nil
		end
	end

	for _, v54 in t2 do
		if v54.getAudioSource ~= nil and not v54.usesDecoder then
			local audioStem = v54.audioStem
			local getAudioSource = v54.getAudioSource

			if audioStem ~= nil and getAudioSource ~= nil and t6[audioStem.stemId] == nil then
				t6[audioStem.stemId] = v22.addStem(audioStem.stemId, getAudioSource(), audioStem.defaultVolume)
			end
		end
	end

	local v57, v58 = createSignal(false)
	local v59, v60 = createSignal(false)
	local v61, v62 = createSignal(false)
	local v63, v64 = createSignal(0)
	local v65, v66 = createSignal(false)
	local u67 = false
	local u68 = nil
	local v69 = if u27 == nil then u28.getPosition else u27.getPosition
	local v70 = createComputed(function(p7) -- line: 285
		-- upvalues: v61 (copy), v59 (copy), v57 (copy)
		if v61(p7) then
			return "Playing"
		end

		if v59(p7) then
			return "Decoded"
		end

		if v57(p7) then
			return "Downloaded"
		end

		return "Idle"
	end)
	local v71 = createComputed(function(p8) -- line: 299
		-- upvalues: u27 (ref), v59 (copy), v57 (copy), u28 (ref), v61 (copy), v65 (copy)
		local v90 = nil
		local v91, v92, v93, v94

		if u27 ~= nil then
			v91 = u27.getFailureReason(p8)
			v92 = if v91 == nil then if not u27.getIsLoaded(p8) then not v59(p8) and not v57(p8) and "Idle" or "Loading" else "Ready" else "Failed"
			v90 = u27.getResolution(p8)
			v93 = u27.getDuration(p8)
			v94 = u27.getTimeLength(p8)
		else
			local v95 = u28

			v91 = v95.getFailureReason(p8)
			v92 = if v91 == nil then not v95.getIsImageLoaded(p8) and "Loading" or "Ready" else "Failed"
			v93 = v95.getDuration()
			v94 = v95.getDuration()
		end

		return {
			readiness = v92,
			resolution = v90,
			duration = v93,
			timeLength = v94,
			isPlaying = v61(p8),
			isMuted = v65(p8),
			failureReason = v91
		}
	end, Cryo.Dictionary.equals)
	local connection = nil
	local n1 = 0

	local function startRealignLoop() -- line: 352
		-- upvalues: connection (ref), u31 (ref), n1 (ref), v69 (copy), services (copy), u67 (ref), loopEpsilonSeconds (copy)
		if connection ~= nil or u31 == nil then
			return
		end

		n1 = v69(false)
		connection = services.runService.RenderStepped:Connect(function() -- line: 357
			-- upvalues: u67 (ref), v69 (copy), n1 (ref), loopEpsilonSeconds (copy), u31 (ref)
			if u67 then
				return
			end

			local v138 = v69(false)

			if v138 < n1 - loopEpsilonSeconds then
				u31.realignToRegionStart()
			end

			n1 = v138
		end)
	end
	local function stopRealignLoop() -- line: 368
		-- upvalues: connection (ref)
		if connection ~= nil then
			connection:Disconnect()
			connection = nil
		end
	end
	local function play() -- line: 431
		-- upvalues: u67 (ref), u68 (ref), u31 (ref), u28 (ref), t2 (copy), v62 (copy), connection (ref), n1 (ref), v69 (copy), services (copy), loopEpsilonSeconds (copy)
		if u67 then
			return
		end

		local v108 = u68

		u68 = nil

		if u31 ~= nil then
			u31.realignToRegionStart()
		end

		if u28 ~= nil then
			u28.seek(0)
		end

		for _, v110 in t2 do
			local play2 = v110.play

			if play2 ~= nil then
				play2()
			end
		end

		if v108 ~= nil and v108 > 0 then
			for _, v113 in t2 do
				local seek = v113.seek

				if seek ~= nil then
					seek(v108)
				end
			end
		end

		v62(true)

		if connection == nil then
			if u31 == nil then
				return
			end

			n1 = v69(false)
			connection = services.runService.RenderStepped:Connect(function() -- line: 357
				-- upvalues: u67 (ref), v69 (copy), n1 (ref), loopEpsilonSeconds (copy), u31 (ref)
				if u67 then
					return
				end

				local v139 = v69(false)

				if v139 < n1 - loopEpsilonSeconds then
					u31.realignToRegionStart()
				end

				n1 = v139
			end)
		end
	end
	local function pauseAndRemember(n2: number) -- line: 475
		-- upvalues: u67 (ref), u27 (ref), u68 (ref), v69 (copy), t2 (copy), v62 (copy), connection (ref)
		if u67 then
			return
		end

		if u27 ~= nil then
			u68 = math.max(0, v69(false) - n2)
		end

		for _, v117 in t2 do
			local pause = v117.pause

			if pause ~= nil then
				pause()
			end
		end

		v62(false)

		if connection ~= nil then
			connection:Disconnect()
			connection = nil
		end
	end

	local t7 = {
		setVolume = function(s1: string, n3: number) -- line: 578
			-- upvalues: u67 (ref), v22 (copy)
			if not u67 then
				v22.setVolume(s1, n3)
			end
		end,
		setMuted = function(s2: string, b1: boolean) -- line: 583
			-- upvalues: u67 (ref), v22 (copy)
			if not u67 then
				v22.setMuted(s2, b1)
			end
		end,
		setMasterMuted = function(b2: boolean) -- line: 545
			-- upvalues: u67 (ref), v22 (copy), v66 (copy)
			if u67 then
				return
			end

			v22.setMasterMuted(b2)
			v66(b2)
		end
	}

	return {
		getState = v71,
		getPosition = v69,
		getUserToggleNonce = v63,
		getVisualLayers = v49,
		getResourceLevel = v70,
		audio = t7,
		download = function() -- line: 375
			-- upvalues: u67 (ref), t2 (copy), v58 (copy)
			if u67 then
				return
			end

			for _, v97 in t2 do
				v97.download()
			end

			if u67 then
				return
			end

			v58(true)
		end,
		decode = function() -- line: 393
			-- upvalues: u67 (ref), t4 (copy), t6 (copy), v22 (copy), v33 (copy), v60 (copy)
			if u67 then
				return
			end

			for _, v99 in t4 do
				local decode = v99.decode

				if decode ~= nil then
					decode()
				end

				local audioStem = v99.audioStem
				local getAudioSource = v99.getAudioSource

				if audioStem ~= nil and getAudioSource ~= nil and t6[audioStem.stemId] == nil then
					t6[audioStem.stemId] = v22.addStem(audioStem.stemId, getAudioSource(), audioStem.defaultVolume)
				end
			end

			if v33 and t6.video ~= nil then
				v22.setMuted("video", true)
			end

			v60(true)
		end,
		releaseDecoder = function() -- line: 414
			-- upvalues: u67 (ref), t4 (copy), t6 (copy), v60 (copy), v62 (copy)
			if u67 then
				return
			end

			for _, v104 in t4 do
				local audioStem = v104.audioStem

				if audioStem ~= nil then
					local v106 = t6[audioStem.stemId]

					if v106 ~= nil then
						v106()
						t6[audioStem.stemId] = nil
					end
				end

				local releaseDecoder = v104.releaseDecoder

				if releaseDecoder ~= nil then
					releaseDecoder()
				end
			end

			v60(false)
			v62(false)
		end,
		play = play,
		pause = function(n4: number?) -- line: 495
			-- upvalues: pauseAndRemember (copy)
			pauseAndRemember(n4 or 2)
		end,
		toggle = function() -- line: 499
			-- upvalues: u67 (ref), v61 (copy), pauseAndRemember (copy), play (copy), v64 (copy), v63 (copy)
			if u67 then
				return
			end

			if v61(false) then
				pauseAndRemember(0)
			else
				play()
			end

			v64(v63(false) + 1)
		end,
		seek = function(n5: number) -- line: 516
			-- upvalues: u67 (ref), FFlagMomentsLoopOnEndSeek (copy), v61 (copy), v71 (copy), t2 (copy)
			if u67 then
				return
			end

			if FFlagMomentsLoopOnEndSeek and v61(false) then
				local duration = v71(false).duration

				if duration > 0 and duration <= n5 then
					n5 = 0
				end
			end

			for _, v123 in t2 do
				local seek = v123.seek

				if seek ~= nil then
					seek(n5)
				end
			end
		end,
		setRegion = function(p9) -- line: 536
			-- upvalues: u67 (ref), u27 (ref)
			if u67 then
				return
			end

			if u27 ~= nil then
				u27.setRegion(p9)
			end
		end,
		setActive = function(b3: boolean) -- line: 555
			-- upvalues: u68 (ref), u67 (ref), v22 (copy), v66 (copy)
			if b3 then
				u68 = nil
			end

			local v128 = not b3

			if u67 then
				return
			end

			v22.setMasterMuted(v128)
			v66(v128)
		end,
		setSurface = function(s3: string, p10) -- line: 567
			-- upvalues: u67 (ref), t3 (copy)
			if u67 then
				return
			end

			local v131 = t3[s3]

			if v131 ~= nil and v131.setSurface ~= nil then
				v131.setSurface(p10)
			end
		end,
		getVideoPreviewSource = function() -- line: 609
			-- upvalues: v19 (copy), p1 (copy), edits (copy)
			if not v19 then
				return nil
			end

			return {
				content = p1.content,
				region = if edits == nil then nil else edits.trim
			}
		end,
		getHasVideoPreview = function() -- line: 619
			-- upvalues: v19 (copy)
			return v19
		end,
		dispose = function() -- line: 591
			-- upvalues: u67 (ref), connection (ref), t2 (copy), v22 (copy), v20 (copy)
			if u67 then
				return
			end

			u67 = true

			if connection ~= nil then
				connection:Disconnect()
				connection = nil
			end

			for _, v137 in t2 do
				v137.dispose()
			end

			v22.dispose()
			v20.dispose()
		end
	}
end

return createMomentMediaController
