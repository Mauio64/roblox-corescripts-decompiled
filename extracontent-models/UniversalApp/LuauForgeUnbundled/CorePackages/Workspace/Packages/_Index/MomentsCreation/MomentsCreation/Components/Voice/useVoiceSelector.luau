local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo

local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local voiceCatalog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/voiceCatalog")
local createTTSAudioManager = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/createTTSAudioManager")
local DialogType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DialogType")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local eventNames = MomentsCommon.Analytics.EventNames

local FStringMomentsTTSPreviewText = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FStringMomentsTTSPreviewText")

local function trimWhitespace(value)
	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function useVoiceSelector(data)
	local controller = data.controller
	local playback = controller.preview.playback
	local ttsAudio = controller.ttsAudio
	assert(ttsAudio ~= nil, "useVoiceSelector requires controller.ttsAudio")
	local setSelectedVoiceId = controller.setSelectedVoiceId
	local selectedVoiceId = data.selectedVoiceId
	local text = data.text
	local canGenerate = data.canGenerate
	local onCreateVoiceover = data.onCreateVoiceover
	local lastGeneratedTextRef = data.lastGeneratedTextRef

	local createPreviewAudio = data.createPreviewAudio or function()
		return createTTSAudioManager(nil, controller.ttsAudioParent)
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(false)

	local v5 = useMemo(function()
		local signal, v6 = Signals.createSignal(nil)
		return { get = signal, set = v6 }
	end, {})

	local function ensurePreviewAudio()
		local current = ref.current

		if current ~= nil then
			return current
		end

		local previewAudio = createPreviewAudio()
		ref.current = previewAudio
		ref2.current = Signals.createEffect(function(p2)
			local state = previewAudio.getState(p2)

			if state == "ready" and ref3.current then
				ref3.current = false
				previewAudio.seek(0)
				previewAudio.play()
			end

			if state ~= "loading" then
				v5.set(nil)
			end
		end)
		return previewAudio
	end

	useEffect(function()
		return function()
			if ref2.current ~= nil then
				ref2.current()
				ref2.current = nil
			end

			if ref.current ~= nil then
				ref.current.destroy()
				ref.current = nil
			end
		end
	end, {})

	local v6 = useCallback(function(p2)
		fireAnalyticsEvent(
			eventNames.EditingFlowVoicePreviewPlayed,
			makeCreationEventFields.makeVoiceEventFields({ voice_id = tostring(p2) })
		)
		local v7 = text:gsub("^%s*(.-)%s*$", "%1")

		if v7 == "" then
			v7 = FStringMomentsTTSPreviewText
		end

		ttsAudio.pause()
		local v8 = ref.current

		if v8 == nil then
			v8 = createPreviewAudio()
			ref.current = v8
			ref2.current = Signals.createEffect(function(p3)
				local state = v8.getState(p3)

				if state == "ready" and ref3.current then
					ref3.current = false
					v8.seek(0)
					v8.play()
				end

				if state ~= "loading" then
					v5.set(nil)
				end
			end)
		end

		if
			v8.getState(false) == "loading"
			or v8.getLoadedVoiceId(false) ~= p2
			or v8.getLoadedText(false) ~= v7
		then
			ref3.current = true
			v5.set(p2)
			v8.generate(v7, p2)
		else
			v8.seek(0)
			v8.play()
		end
	end, { text })

	local v7 = useCallback(function()
		ref3.current = false

		if ref.current ~= nil then
			ref.current.pause()
		end

		v5.set(nil)
	end, { v5 })

	local ref4 = React.useRef(false)

	local v8 = useCallback(function()
		v7()
		controller.dismissModal()

		if ref4.current then
			ref4.current = false
			playback.play()
		end
	end, { controller, playback, v7 })

	local v9 = useCallback(function(p2)
		local v10 = p2 ~= selectedVoiceId

		if v10 then
			setSelectedVoiceId(p2)
			fireAnalyticsEvent(
				eventNames.EditingFlowVoiceSelected,
				makeCreationEventFields.makeVoiceEventFields({ voice_id = tostring(p2) })
			)
		end

		if canGenerate and text:gsub("^%s*(.-)%s*$", "%1") ~= "" then
			v7()
			controller.dismissModal()

			local current = ref4.current
			ref4.current = false
			onCreateVoiceover(p2, current)
		else
			if not v10 or lastGeneratedTextRef.current == "" then
				v8()
				return
			end

			v7()
			controller.dismissModal()

			ref4.current = false
			onCreateVoiceover(p2, false, lastGeneratedTextRef.current, true)
		end
	end, { controller, canGenerate, selectedVoiceId, v8, onCreateVoiceover, v7, text })

	return {
		onOpenVoiceSelector = useCallback(function()
			fireAnalyticsEvent(eventNames.EditingFlowVoiceSelectorOpened, makeCreationEventFields.makeVoiceEventFields())

			if playback.getIsPlaying(false) then
				ref4.current = true
				playback.pause()
			else
				ref4.current = false
			end

			controller.showModal({
				modalType = DialogType.VoiceSelector,
				modalProps = {
					voices = voiceCatalog.getOrderedVoices(),
					selectedVoiceId = selectedVoiceId,
					onSelect = v9,
					onClose = v8,
					onAudition = v6,
					getAuditioningVoiceId = v5.get
				}
			})
		end, { controller, playback, selectedVoiceId, v9, v6, v8 })
	}
end

return useVoiceSelector
