local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
local createAudioGraph = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/createAudioGraph")
local mediaRoot = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaRoot")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")
local defaultMediaNodeRegistry = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/defaultMediaNodeRegistry")
local preloadConstants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Preload/preloadConstants")
local FFlagMomentsVideoPermissionContextFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsVideoPermissionContextFix")
local fFlagMomentsOptimisticProfilePending = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags").FFlagMomentsOptimisticProfilePending
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createVideoNode")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createScreenshotNode")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createMusicNode")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Nodes/createTtsNode")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local GetFFlagMomentsStickerButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsStickerButton")

local loopEpsilonSeconds = preloadConstants.loopEpsilonSeconds

local function createMomentMediaController(data, data2)
	local services = data2.services
	local registry = data2.registry or defaultMediaNodeRegistry()
	local hasVideoPreview = data.captureType == Enum.CaptureType.Video

	local edits = data.edits

	local ttsAudios = if edits ~= nil then edits.ttsAudios else nil

	local v5 = false

	if ttsAudios ~= nil then
		for k, ttsAudio in ttsAudios do
			if ttsAudio.assetId ~= nil then
				v5 = true
				break
			end
		end
	end

	local localTts = data.localTts
	local v6 = localTts ~= nil or v5
	local v7 = mediaRoot(data.momentId, data2.parent)
	local folder = v7.folder
	local v8 = createAudioGraph(folder, data2.audioDeviceOutput, {
		masterVolume = data2.masterVolume,
		enableDucking = v6
	})

	local v9 = {}
	local v10 = {}

	local function addNode(p2)
		table.insert(v9, p2)
		v10[p2.id] = p2
	end

	local v11 = nil
	local v12 = nil

	if hasVideoPreview then
		local create = registry.create
		local v14 = {
			id = "video",
			kind = "video",
			content = data.content,
			preloadContent = 0,
			region = 0,
			parent = 0,
			zIndex = 0,
			cornerRadius = 0
		}
		local v15 = if FFlagMomentsVideoPermissionContextFix then data.preloadContent else nil
		v14.preloadContent = v15

		local v16 = if edits ~= nil then edits.trim else nil
		v14.region = v16
		v14.parent = folder

		v14.cornerRadius = data.cornerRadius
		v11 = create("video", v14, services)
		table.insert(v9, v11)
		v10[v11.id] = v11
	else
		local create = registry.create

		local v15 = if not fFlagMomentsRenderAvatarPostsInFeed or data.isExternalBase ~= true then data.content.Uri else nil
		local v16 = if fFlagMomentsRenderAvatarPostsInFeed and data.isExternalBase == true or fFlagMomentsOptimisticProfilePending then data.content else nil

		local v17 = if data.posterContent ~= nil then data.posterContent.Uri else nil
		local v18 = if fFlagMomentsOptimisticProfilePending then data.posterContent else nil
		v12 = create("screenshot", {
			id = "screenshot",
			kind = "screenshot",
			image = v15,
			imageContent = v16,
			poster = v17,
			posterContent = v18,
			parent = folder
		}, services)
		table.insert(v9, v12)
		v10[v12.id] = v12
	end

	local v13

	if edits == nil or edits.music == nil then
		v13 = nil
	else
		v13 = registry.create("music", {
			id = "music",
			kind = "music",
			assetId = edits.music.assetId,
			startTime = edits.music.startTime,
			parent = folder
		}, services)
		table.insert(v9, v13)
		v10[v13.id] = v13
	end

	local v14 = v13 ~= nil
	local v15 = {}

	if ttsAudios ~= nil then
		for k, ttsAudio in ttsAudios do
			if ttsAudio.assetId == nil then
				continue
			end

			local v16 = registry.create("tts", {
				id = `tts:{k - 1}`,
				kind = "tts",
				assetId = ttsAudio.assetId,
				assetAccessContext = ttsAudio.assetAccessContext,
				startTime = ttsAudio.startTime,
				parent = folder
			}, services)

			table.insert(v15, v16)
			table.insert(v9, v16)
			v10[v16.id] = v16
		end
	end

	if localTts ~= nil then
		local v16 = registry.create("tts", {
			id = `tts:{#v15}`,
			kind = "tts",
			text = localTts.text,
			voiceId = localTts.voiceId,
			startTime = localTts.startTime,
			parent = folder
		}, services)

		table.insert(v15, v16)
		table.insert(v9, v16)
		v10[v16.id] = v16
	end

	if edits ~= nil and edits.textOverlays ~= nil then
		for k, textOverlay in edits.textOverlays do
			local formatted = `text:{k - 1}`
			local v16 = registry.create(
				"text",
				{ id = formatted, kind = "text", overlay = textOverlay },
				services
			)
			table.insert(v9, v16)
			v10[v16.id] = v16
		end
	end

	if GetFFlagMomentsStickerButton() and edits ~= nil and edits.stickerOverlays ~= nil then
		for k, stickerOverlay in edits.stickerOverlays do
			local formatted = `sticker:{k - 1}`
			local v16 = registry.create(
				"sticker",
				{ id = formatted, kind = "sticker", overlay = stickerOverlay },
				services
			)
			table.insert(v9, v16)
			v10[v16.id] = v16
		end
	end

	local v16 = {}

	for k, v17 in v9 do
		if v17.usesDecoder then
			table.insert(v16, v17)
		end
	end

	local v17 = {}

	for k, v18 in v9 do
		local render = v18.render

		if render ~= nil then
			table.insert(v17, {
				id = v18.id,
				zIndex = v18.zIndex or 0,
				render = render
			})
		end
	end

	table.sort(v17, function(a, b): boolean
		return a.zIndex < b.zIndex
	end)

	local signal = createSignal(v17)

	local v18 = {}
	local function addStem(p2)
		local audioStem = p2.audioStem
		local getAudioSource = p2.getAudioSource

		if audioStem == nil or getAudioSource == nil or v18[audioStem.stemId] ~= nil then
			return
		end

		v18[audioStem.stemId] = v8.addStem(
			audioStem.stemId,
			getAudioSource(),
			audioStem.defaultVolume,
			audioStem.role
		)
	end
	local function removeStem(p2)
		local audioStem = p2.audioStem

		if audioStem == nil then
			return
		end

		local v19 = v18[audioStem.stemId]

		if v19 ~= nil then
			v19()
			v18[audioStem.stemId] = nil
		end
	end

	for k, v19 in v9 do
		if v19.getAudioSource == nil or v19.usesDecoder then
			continue
		end

		local audioStem = v19.audioStem
		local getAudioSource = v19.getAudioSource

		if audioStem ~= nil and getAudioSource ~= nil and v18[audioStem.stemId] == nil then
			v18[audioStem.stemId] = v8.addStem(
				audioStem.stemId,
				getAudioSource(),
				audioStem.defaultVolume,
				audioStem.role
			)
		end
	end

	local signal2, v19 = createSignal(false)
	local signal3, v20 = createSignal(false)
	local signal4, v21 = createSignal(false)
	local signal5, v22 = createSignal("Loading")
	local signal6, v23 = createSignal(nil)

	local signal7, v24 = createSignal(0)

	local signal8, v25 = createSignal(false)

	local flag = false

	local v26 = nil

	local getPosition = if v11 == nil then v12.getPosition else v11.getPosition

	local computed = createComputed(function(p2): string
		if signal4(p2) then
			return "Playing"
		end

		if signal3(p2) then
			return "Decoded"
		end

		if signal2(p2) then
			return "Downloaded"
		end

		return "Idle"
	end)

	local computed2 = createComputed(function(p2)
		local v27 = nil
		local v28, v29, v30, v31

		if v11 == nil then
			local v32 = v12

			if fFlagMomentsRenderAvatarPostsInFeed and data.isExternalBase == true then
				v28 = signal5(p2)
				v29 = signal6(p2)
			else
				v29 = v32.getFailureReason(p2)
				v28 = v29 == nil and (v32.getIsImageLoaded(p2) and "Ready" or "Loading") or "Failed"
			end

			v30 = v32.getDuration()
			v31 = v32.getDuration()
		else
			v29 = v11.getFailureReason(p2)
			v28 = v29 == nil
				and (v11.getIsLoaded(p2) and "Ready" or (signal3(p2) or signal2(p2)) and "Loading" or "Idle")
				or "Failed"

			v27 = v11.getResolution(p2)
			v30 = v11.getDuration(p2)
			v31 = v11.getTimeLength(p2)
		end

		return {
			readiness = v28,
			resolution = v27,
			duration = v30,
			timeLength = v31,
			isPlaying = signal4(p2),
			isMuted = signal8(p2),
			failureReason = v29
		}
	end, Cryo.Dictionary.equals)

	local renderSteppedConnection = nil
	local v27 = 0
	local function startRealignLoop()
		if renderSteppedConnection ~= nil or v13 == nil and #v15 == 0 then
			return
		end

		v27 = getPosition(false)
		renderSteppedConnection = services.runService.RenderStepped:Connect(function()
			if flag then
				return
			end

			local position = getPosition(false)

			if position < v27 - loopEpsilonSeconds then
				if v13 ~= nil then
					v13.realignToRegionStart()
				end

				for k, v28 in v15 do
					v28.realignToRegionStart()
				end
			end

			for k, v28 in v15 do
				v28.syncToClock(position)
			end

			v27 = position
		end)
	end
	local function stopRealignLoop()
		if renderSteppedConnection ~= nil then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local function isVideoReadyForPlayback()
		return v11 == nil or v11.isPlaybackReady()
	end

	local function play()
		if flag or v11 ~= nil and not v11.isPlaybackReady() then
			return
		end

		local v28 = v26
		v26 = nil

		if v13 ~= nil then
			v13.realignToRegionStart()
		end

		for k, v29 in v15 do
			v29.realignToRegionStart()
		end

		if v12 ~= nil then
			v12.seek(0)
		end

		for k, v29 in v9 do
			local play2 = v29.play

			if play2 ~= nil then
				play2()
			end
		end

		if v28 ~= nil and v28 > 0 then
			for k, v29 in v9 do
				local seek = v29.seek

				if seek ~= nil then
					seek(v28)
				end
			end
		end

		for k, v29 in v15 do
			v29.syncToClock(getPosition(false))
		end

		v21(true)

		if renderSteppedConnection == nil then
			if v13 == nil and #v15 == 0 then
				return
			end

			v27 = getPosition(false)
			renderSteppedConnection = services.runService.RenderStepped:Connect(function()
				if flag then
					return
				end

				local position = getPosition(false)

				if position < v27 - loopEpsilonSeconds then
					if v13 ~= nil then
						v13.realignToRegionStart()
					end

					for k, v29 in v15 do
						v29.realignToRegionStart()
					end
				end

				for k, v29 in v15 do
					v29.syncToClock(position)
				end

				v27 = position
			end)
		end
	end

	local function pauseAndRemember(p2)
		if flag then
			return
		end

		if v11 ~= nil then
			v26 = math.max(0, getPosition(false) - p2)
		end

		for k, v28 in v9 do
			local pause = v28.pause

			if pause ~= nil then
				pause()
			end
		end

		v21(false)

		if renderSteppedConnection ~= nil then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	return {
		getState = computed2,
		getPosition = getPosition,
		getUserToggleNonce = signal7,
		getVisualLayers = signal,
		getResourceLevel = computed,
		audio = {
			setVolume = function(p2, p3)
				if not flag then
					v8.setVolume(p2, p3)
				end
			end,
			setMuted = function(p2, p3)
				if not flag then
					v8.setMuted(p2, p3)
				end
			end,
			setMasterMuted = function(p2)
				if flag then
					return
				end

				v8.setMasterMuted(p2)
				v25(p2)
			end
		},
		download = function()
			if flag then
				return
			end

			for k, v28 in v9 do
				v28.download()
			end

			if flag then
				return
			end

			v19(true)
		end,
		decode = function()
			if flag then
				return
			end

			for k, v28 in v16 do
				local decode2 = v28.decode

				if decode2 ~= nil then
					decode2()
				end

				local audioStem = v28.audioStem
				local getAudioSource = v28.getAudioSource

				if audioStem ~= nil and getAudioSource ~= nil and v18[audioStem.stemId] == nil then
					v18[audioStem.stemId] = v8.addStem(
						audioStem.stemId,
						getAudioSource(),
						audioStem.defaultVolume,
						audioStem.role
					)
				end
			end

			if v14 and v18.video ~= nil then
				v8.setMuted("video", true)
			end

			v20(true)
		end,
		releaseDecoder = function()
			if flag then
				return
			end

			for k, v28 in v16 do
				local audioStem = v28.audioStem

				if audioStem ~= nil then
					local v29 = v18[audioStem.stemId]

					if v29 ~= nil then
						v29()
						v18[audioStem.stemId] = nil
					end
				end

				local releaseDecoder2 = v28.releaseDecoder

				if releaseDecoder2 ~= nil then
					releaseDecoder2()
				end
			end

			v20(false)
			v21(false)
		end,
		play = play,
		pause = function(value)
			pauseAndRemember(value or 2)
		end,
		toggle = function()
			if flag or not signal4(false) and v11 ~= nil and not v11.isPlaybackReady() then
				return
			end

			if signal4(false) then
				pauseAndRemember(0)
			else
				play()
			end

			v24(signal7(false) + 1)
		end,
		seek = function(p2)
			if flag then
				return
			end

			if signal4(false) then
				local duration = computed2(false).duration
				p2 = duration > 0 and duration <= p2 and 0 or p2
			end

			for k, v28 in v9 do
				local seek2 = v28.seek

				if seek2 ~= nil then
					seek2(p2)
				end
			end
		end,
		setRegion = function(p2)
			if flag then
				return
			end

			if v11 ~= nil then
				v11.setRegion(p2)
			end
		end,
		setActive = function(p2)
			if p2 then
				v26 = nil
			end

			local v28 = not p2

			if flag then
				return
			end

			v8.setMasterMuted(v28)
			v25(v28)
		end,
		setExternalBaseReadiness = function(p2, p3)
			if flag or not fFlagMomentsRenderAvatarPostsInFeed or data.isExternalBase ~= true then
				return
			end

			if p2 ~= "Failed" then
				p3 = nil
			end

			v23(p3)
			v22(p2)
		end,
		setSurface = function(p2, p3)
			if flag then
				return
			end

			local v28 = v10[p2]

			if v28 ~= nil and v28.setSurface ~= nil then
				v28.setSurface(p3)
			end
		end,
		getVideoPreviewSource = function()
			if not hasVideoPreview then
				return nil
			end

			local v28 = { content = data.content, region = 0 }
			local v29 = if edits ~= nil then edits.trim else nil
			v28.region = v29
			return v28
		end,
		getHasVideoPreview = function()
			return hasVideoPreview
		end,
		dispose = function()
			if flag then
				return
			end

			flag = true

			if renderSteppedConnection ~= nil then
				renderSteppedConnection:Disconnect()
				renderSteppedConnection = nil
			end

			for k, v28 in v9 do
				v28.dispose()
			end

			v8.dispose()
			v7.dispose()
		end
	}
end

return createMomentMediaController
