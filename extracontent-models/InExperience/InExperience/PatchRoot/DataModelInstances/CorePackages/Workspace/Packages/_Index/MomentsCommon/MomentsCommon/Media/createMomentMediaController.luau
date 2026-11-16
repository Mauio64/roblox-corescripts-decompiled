local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

require(parent.MomentsTypes)
require(MomentsCommon.Media.MediaTypes)
local createAudioGraph = require(MomentsCommon.Media.createAudioGraph)
local mediaRoot = require(MomentsCommon.Media.mediaRoot)
require(MomentsCommon.Media.mediaNodeRegistry)
local defaultMediaNodeRegistry = require(MomentsCommon.Media.defaultMediaNodeRegistry)
local preloadConstants = require(MomentsCommon.Media.Preload.preloadConstants)
local FFlagMomentsVideoPermissionContextFix = require(MomentsCommon.Flags.FFlagMomentsVideoPermissionContextFix)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsOptimisticProfilePending = SharedFlags.FFlagMomentsOptimisticProfilePending
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags2.FFlagMomentsRenderAvatarPostsInFeed

require(MomentsCommon.Media.Nodes.createVideoNode)
require(MomentsCommon.Media.Nodes.createScreenshotNode)
require(MomentsCommon.Media.Nodes.createMusicNode)
require(MomentsCommon.Media.Nodes.createTtsNode)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local GetFFlagMomentsStickerButton = require(MomentsCommon.Flags.GetFFlagMomentsStickerButton)

local loopEpsilonSeconds = preloadConstants.loopEpsilonSeconds

local function createMomentMediaController(data, data2)
	local services = data2.services
	local registry = data2.registry or defaultMediaNodeRegistry()
	local hasVideoPreview = data.captureType == Enum.CaptureType.Video

	local edits = data.edits
	local ttsAudios

	if edits ~= nil then
		ttsAudios = edits.ttsAudios
	end

	local v = false

	if ttsAudios ~= nil then
		for _, ttsAudio in ttsAudios do
			if ttsAudio.assetId ~= nil then
				v = true
				break
			end
		end
	end

	local localTts = data.localTts
	local enableDucking = localTts ~= nil or v
	local v2 = mediaRoot(data.momentId, data2.parent)
	local folder = v2.folder
	local audioGraph = createAudioGraph(folder, data2.audioDeviceOutput, {
		masterVolume = data2.masterVolume,
		enableDucking = enableDucking
	})

	local v3 = {}
	local v4 = {}

	local function addNode(p) -- 7 equivalent calls inferred from this helper
		table.insert(v3, p)
		v4[p.id] = p
	end

	local v5 = nil
	local v6 = nil

	if hasVideoPreview then
		local create = registry.create
		local v7 = {
			id = "video",
			kind = "video",
			content = data.content,
			preloadContent = 0,
			region = 0,
			parent = 0,
			zIndex = 0,
			cornerRadius = 0
		}
		local preloadContent

		if FFlagMomentsVideoPermissionContextFix then
			preloadContent = data.preloadContent
		end

		v7.preloadContent = preloadContent
		local region

		if edits ~= nil then
			region = edits.trim
		end

		v7.region = region
		v7.parent = folder

		v7.cornerRadius = data.cornerRadius
		v5 = create("video", v7, services)
		addNode(v5) -- inferred equivalent call
	else
		local create = registry.create
		local image

		if not (FFlagMomentsRenderAvatarPostsInFeed and data.isExternalBase == true) then
			image = data.content.Uri
		end

		local imageContent

		if
			FFlagMomentsRenderAvatarPostsInFeed and data.isExternalBase == true
			or FFlagMomentsOptimisticProfilePending
		then
			imageContent = data.content
		end

		local poster

		if data.posterContent ~= nil then
			poster = data.posterContent.Uri
		end

		local posterContent

		if FFlagMomentsOptimisticProfilePending then
			posterContent = data.posterContent
		end

		v6 = create("screenshot", {
			id = "screenshot",
			kind = "screenshot",
			image = image,
			imageContent = imageContent,
			poster = poster,
			posterContent = posterContent,
			parent = folder
		}, services)
		addNode(v6) -- inferred equivalent call
	end

	local v7

	if edits == nil or edits.music == nil then
		v7 = nil
	else
		v7 = registry.create("music", {
			id = "music",
			kind = "music",
			assetId = edits.music.assetId,
			startTime = edits.music.startTime,
			parent = folder
		}, services)
		addNode(v7) -- inferred equivalent call
	end

	local v8 = v7 ~= nil
	local v9 = {}

	if ttsAudios ~= nil then
		for k, ttsAudio in ttsAudios do
			if ttsAudio.assetId == nil then
				continue
			end

			local v10 = registry.create("tts", {
				id = `tts:{k - 1}`,
				kind = "tts",
				assetId = ttsAudio.assetId,
				assetAccessContext = ttsAudio.assetAccessContext,
				startTime = ttsAudio.startTime,
				parent = folder
			}, services)

			table.insert(v9, v10)
			addNode(v10) -- inferred equivalent call
		end
	end

	if localTts ~= nil then
		local v10 = registry.create("tts", {
			id = `tts:{#v9}`,
			kind = "tts",
			text = localTts.text,
			voiceId = localTts.voiceId,
			startTime = localTts.startTime,
			parent = folder
		}, services)

		table.insert(v9, v10)
		addNode(v10) -- inferred equivalent call
	end

	if edits ~= nil and edits.textOverlays ~= nil then
		for k, textOverlay in edits.textOverlays do
			local formatted = `text:{k - 1}`
			addNode(registry.create("text", { id = formatted, kind = "text", overlay = textOverlay }, services)) -- inferred equivalent call
		end
	end

	if GetFFlagMomentsStickerButton() and edits ~= nil and edits.stickerOverlays ~= nil then
		for k, stickerOverlay in edits.stickerOverlays do
			local formatted = `sticker:{k - 1}`
			addNode(registry.create("sticker", { -- inferred equivalent call
				id = formatted,
				kind = "sticker",
				overlay = stickerOverlay
			}, services))
		end
	end

	local v10 = {}

	for _, v11 in v3 do
		if v11.usesDecoder then
			table.insert(v10, v11)
		end
	end

	local v11 = {}

	for _, v12 in v3 do
		local render = v12.render

		if render ~= nil then
			table.insert(v11, {
				id = v12.id,
				zIndex = v12.zIndex or 0,
				render = render
			})
		end
	end

	table.sort(v11, function(a, b): boolean
		return a.zIndex < b.zIndex
	end)

	local signal = createSignal(v11)

	local v12 = {}
	local function addStem(p)
		local audioStem = p.audioStem
		local getAudioSource = p.getAudioSource

		if audioStem == nil or getAudioSource == nil or v12[audioStem.stemId] ~= nil then
			return
		end

		v12[audioStem.stemId] = audioGraph.addStem(
			audioStem.stemId,
			getAudioSource(),
			audioStem.defaultVolume,
			audioStem.role
		)
	end
	local function removeStem(p) -- 1 equivalent call inferred from this helper
		local audioStem = p.audioStem

		if audioStem == nil then
			return
		end

		local v13 = v12[audioStem.stemId]

		if v13 ~= nil then
			v13()
			v12[audioStem.stemId] = nil
		end
	end

	for _, v13 in v3 do
		if v13.getAudioSource == nil or v13.usesDecoder then
			continue
		end

		local audioStem = v13.audioStem
		local getAudioSource = v13.getAudioSource

		if audioStem ~= nil and getAudioSource ~= nil and v12[audioStem.stemId] == nil then
			v12[audioStem.stemId] = audioGraph.addStem(
				audioStem.stemId,
				getAudioSource(),
				audioStem.defaultVolume,
				audioStem.role
			)
		end
	end

	local signal2, v13 = createSignal(false)
	local signal3, v14 = createSignal(false)
	local signal4, v15 = createSignal(false)
	local signal5, v16 = createSignal("Loading")
	local signal6, v17 = createSignal(nil)

	local signal7, v18 = createSignal(0)

	local signal8, v19 = createSignal(false)

	local flag = false

	local v20 = nil
	local getPosition

	if v5 == nil then
		getPosition = v6.getPosition
	else
		getPosition = v5.getPosition
	end

	local getResourceLevel = createComputed(function(p): string
		if signal4(p) then
			return "Playing"
		end

		if signal3(p) then
			return "Decoded"
		end

		return if signal2(p) then "Downloaded" else "Idle"
	end)

	local getState = createComputed(function(p)
		local resolution = nil
		local readiness, failureReason, duration, timeLength

		if v5 == nil then
			local v21 = v6

			if FFlagMomentsRenderAvatarPostsInFeed and data.isExternalBase == true then
				readiness = signal5(p)
				failureReason = signal6(p)
			else
				failureReason = v21.getFailureReason(p)
				readiness = failureReason == nil and (v21.getIsImageLoaded(p) and "Ready" or "Loading") or "Failed"
			end

			duration = v21.getDuration()
			timeLength = v21.getDuration()
		else
			failureReason = v5.getFailureReason(p)
			readiness = failureReason == nil
				and (v5.getIsLoaded(p) and "Ready" or (signal3(p) or signal2(p)) and "Loading" or "Idle")
				or "Failed"

			resolution = v5.getResolution(p)
			duration = v5.getDuration(p)
			timeLength = v5.getTimeLength(p)
		end

		return {
			readiness = readiness,
			resolution = resolution,
			duration = duration,
			timeLength = timeLength,
			isPlaying = signal4(p),
			isMuted = signal8(p),
			failureReason = failureReason
		}
	end, Cryo.Dictionary.equals)

	local renderSteppedConnection = nil
	local v21 = 0
	local function startRealignLoop()
		if renderSteppedConnection ~= nil or v7 == nil and #v9 == 0 then
			return
		end

		v21 = getPosition(false)
		renderSteppedConnection = services.runService.RenderStepped:Connect(function()
			if flag then
				return
			end

			local position = getPosition(false)

			if position < v21 - loopEpsilonSeconds then
				if v7 ~= nil then
					v7.realignToRegionStart()
				end

				for _, v22 in v9 do
					v22.realignToRegionStart()
				end
			end

			for _, v22 in v9 do
				v22.syncToClock(position)
			end

			v21 = position
		end)
	end
	local function stopRealignLoop() -- 2 equivalent calls inferred from this helper
		if renderSteppedConnection ~= nil then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function isVideoReadyForPlayback()
		return v5 == nil or v5.isPlaybackReady()
	end

	local function play()
		if flag or v5 ~= nil and not v5.isPlaybackReady() then
			return
		end

		local v22 = v20
		v20 = nil

		if v7 ~= nil then
			v7.realignToRegionStart()
		end

		for _, v23 in v9 do
			v23.realignToRegionStart()
		end

		if v6 ~= nil then
			v6.seek(0)
		end

		for _, v23 in v3 do
			local play2 = v23.play

			if play2 ~= nil then
				play2()
			end
		end

		if v22 ~= nil and v22 > 0 then
			for _, v23 in v3 do
				local seek = v23.seek

				if seek ~= nil then
					seek(v22)
				end
			end
		end

		for _, v23 in v9 do
			v23.syncToClock(getPosition(false))
		end

		v15(true)

		if renderSteppedConnection == nil then
			if v7 == nil and #v9 == 0 then
				return
			end

			v21 = getPosition(false)
			renderSteppedConnection = services.runService.RenderStepped:Connect(function()
				if flag then
					return
				end

				local position = getPosition(false)

				if position < v21 - loopEpsilonSeconds then
					if v7 ~= nil then
						v7.realignToRegionStart()
					end

					for _, v23 in v9 do
						v23.realignToRegionStart()
					end
				end

				for _, v23 in v9 do
					v23.syncToClock(position)
				end

				v21 = position
			end)
		end
	end

	local function pauseAndRemember(p: number)
		if flag then
			return
		end

		if v5 ~= nil then
			v20 = math.max(0, getPosition(false) - p)
		end

		for _, v22 in v3 do
			local pause = v22.pause

			if pause ~= nil then
				pause()
			end
		end

		v15(false)
		stopRealignLoop() -- inferred equivalent call
	end

	local function setMasterMuted(flag2: boolean) -- 1 equivalent call inferred from this helper
		if flag then
			return
		end

		audioGraph.setMasterMuted(flag2)
		v19(flag2)
	end

	return {
		getState = getState,
		getPosition = getPosition,
		getUserToggleNonce = signal7,
		getVisualLayers = signal,
		getResourceLevel = getResourceLevel,
		audio = {
			setVolume = function(p: string, p2: number)
				if not flag then
					audioGraph.setVolume(p, p2)
				end
			end,
			setMuted = function(p: string, flag2: boolean)
				if not flag then
					audioGraph.setMuted(p, flag2)
				end
			end,
			setMasterMuted = setMasterMuted
		},
		download = function()
			if flag then
				return
			end

			for _, v22 in v3 do
				v22.download()
			end

			if flag then
				return
			end

			v13(true)
		end,
		decode = function()
			if flag then
				return
			end

			for _, v22 in v10 do
				local decode = v22.decode

				if decode ~= nil then
					decode()
				end

				local audioStem = v22.audioStem
				local getAudioSource = v22.getAudioSource

				if audioStem ~= nil and getAudioSource ~= nil and v12[audioStem.stemId] == nil then
					v12[audioStem.stemId] = audioGraph.addStem(
						audioStem.stemId,
						getAudioSource(),
						audioStem.defaultVolume,
						audioStem.role
					)
				end
			end

			if v8 and v12.video ~= nil then
				audioGraph.setMuted("video", true)
			end

			v14(true)
		end,
		releaseDecoder = function()
			if flag then
				return
			end

			for _, v22 in v10 do
				removeStem(v22) -- inferred equivalent call
				local releaseDecoder = v22.releaseDecoder

				if releaseDecoder ~= nil then
					releaseDecoder()
				end
			end

			v14(false)
			v15(false)
		end,
		play = play,
		pause = function(value: number?)
			pauseAndRemember(value or 2)
		end,
		toggle = function()
			if flag or not signal4(false) and v5 ~= nil and not v5.isPlaybackReady() then
				return
			end

			if signal4(false) then
				pauseAndRemember(0)
			else
				play()
			end

			v18(signal7(false) + 1)
		end,
		seek = function(p: number)
			if flag then
				return
			end

			if signal4(false) then
				local duration = getState(false).duration
				p = duration > 0 and duration <= p and 0 or p
			end

			for _, v22 in v3 do
				local seek = v22.seek

				if seek ~= nil then
					seek(p)
				end
			end
		end,
		setRegion = function(p)
			if flag then
				return
			end

			if v5 ~= nil then
				v5.setRegion(p)
			end
		end,
		setActive = function(flag2: boolean)
			if flag2 then
				v20 = nil
			end

			setMasterMuted(not flag2) -- inferred equivalent call
		end,
		setExternalBaseReadiness = function(p, p2: string?)
			if flag or not FFlagMomentsRenderAvatarPostsInFeed or data.isExternalBase ~= true then
				return
			end

			if p ~= "Failed" then
				p2 = nil
			end

			v17(p2)
			v16(p)
		end,
		setSurface = function(p: string, p2)
			if flag then
				return
			end

			local v22 = v4[p]

			if v22 ~= nil and v22.setSurface ~= nil then
				v22.setSurface(p2)
			end
		end,
		getVideoPreviewSource = function()
			if not hasVideoPreview then
				return nil
			end

			local v22 = { content = data.content, region = 0 }
			local region

			if edits ~= nil then
				region = edits.trim
			end

			v22.region = region
			return v22
		end,
		getHasVideoPreview = function()
			return hasVideoPreview
		end,
		dispose = function()
			if flag then
				return
			end

			flag = true
			stopRealignLoop() -- inferred equivalent call

			for _, v22 in v3 do
				v22.dispose()
			end

			audioGraph.dispose()
			v2.dispose()
		end
	}
end

return createMomentMediaController
