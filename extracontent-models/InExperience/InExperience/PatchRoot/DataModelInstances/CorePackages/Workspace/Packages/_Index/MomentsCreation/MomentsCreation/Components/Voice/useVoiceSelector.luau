local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo

local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local voiceCatalog = require(MomentsCreation.Components.Voice.voiceCatalog)
local createTTSAudioManager = require(MomentsCreation.Audio.createTTSAudioManager)
local DialogType = require(MomentsCreation.Enums.DialogType)
require(MomentsCreation.Types.CreationFlowTypes)

local EventNames = MomentsCommon.Analytics.EventNames

local FStringMomentsTTSPreviewText = require(MomentsCreation.Flags.FStringMomentsTTSPreviewText)

local function trimWhitespace(text: string) -- 2 equivalent calls inferred from this helper
	return (text:gsub("^%s*(.-)%s*$", "%1"))
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

	local v = useMemo(function()
		local signal, set = Signals.createSignal(nil)
		return { get = signal, set = set }
	end, {})

	local function ensurePreviewAudio()
		local current = ref.current

		if current ~= nil then
			return current
		end

		local previewAudio = createPreviewAudio()
		ref.current = previewAudio
		ref2.current = Signals.createEffect(function(p)
			local state = previewAudio.getState(p)

			if state == "ready" and ref3.current then
				ref3.current = false
				previewAudio.seek(0)
				previewAudio.play()
			end

			if state ~= "loading" then
				v.set(nil)
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

	local onAudition = useCallback(function(p: number)
		fireAnalyticsEvent(
			EventNames.EditingFlowVoicePreviewPlayed,
			makeCreationEventFields.makeVoiceEventFields({ voice_id = tostring(p) })
		)
		local v2 = trimWhitespace(text) -- inferred equivalent call

		if v2 == "" then
			v2 = FStringMomentsTTSPreviewText
		end

		ttsAudio.pause()
		local current = ref.current

		if current == nil then
			current = createPreviewAudio()
			ref.current = current
			ref2.current = Signals.createEffect(function(p2)
				local state = current.getState(p2)

				if state == "ready" and ref3.current then
					ref3.current = false
					current.seek(0)
					current.play()
				end

				if state ~= "loading" then
					v.set(nil)
				end
			end)
		end

		if
			current.getState(false) == "loading"
			or current.getLoadedVoiceId(false) ~= p
			or current.getLoadedText(false) ~= v2
		then
			ref3.current = true
			v.set(p)
			current.generate(v2, p)
		else
			current.seek(0)
			current.play()
		end
	end, { text })

	local v2 = useCallback(function()
		ref3.current = false

		if ref.current ~= nil then
			ref.current.pause()
		end

		v.set(nil)
	end, { v })

	local ref4 = React.useRef(false)

	local onClose = useCallback(function()
		v2()
		controller.dismissModal()

		if ref4.current then
			ref4.current = false
			playback.play()
		end
	end, { controller, playback, v2 })

	local onSelect = useCallback(function(p: number)
		local v3 = p ~= selectedVoiceId

		if v3 then
			setSelectedVoiceId(p)
			fireAnalyticsEvent(
				EventNames.EditingFlowVoiceSelected,
				makeCreationEventFields.makeVoiceEventFields({ voice_id = tostring(p) })
			)
		end

		if canGenerate and trimWhitespace(text) ~= "" then -- inferred equivalent call
			v2()
			controller.dismissModal()

			local current = ref4.current
			ref4.current = false
			onCreateVoiceover(p, current)
		else
			if not v3 or lastGeneratedTextRef.current == "" then
				onClose()
				return
			end

			v2()
			controller.dismissModal()

			ref4.current = false
			onCreateVoiceover(p, false, lastGeneratedTextRef.current, true)
		end
	end, { controller, canGenerate, selectedVoiceId, onClose, onCreateVoiceover, v2, text })

	return {
		onOpenVoiceSelector = useCallback(function()
			fireAnalyticsEvent(
				EventNames.EditingFlowVoiceSelectorOpened,
				makeCreationEventFields.makeVoiceEventFields()
			)

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
					onSelect = onSelect,
					onClose = onClose,
					onAudition = onAudition,
					getAuditioningVoiceId = v.get
				}
			})
		end, { controller, playback, selectedVoiceId, onSelect, onAudition, onClose })
	}
end

return useVoiceSelector
