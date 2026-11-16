local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local UserInputService = game:GetService("UserInputService")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useLayoutEffect = React.useLayoutEffect
local useLocalization = Localization.Hooks.useLocalization
local useMemo = React.useMemo
local useState = React.useState
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/VoiceEditorView")
local useVoiceSelector = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/useVoiceSelector")
local useComposerParentTextPadding = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useComposerParentTextPadding")
local useOnScreenKeyboardHeight = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useOnScreenKeyboardHeight")
local useTtsStartTimeDrag = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useTtsStartTimeDrag")
local clampTtsStartTime = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/clampTtsStartTime")
local computeVoiceButtonState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/computeVoiceButtonState")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local measureTextLineCount = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/measureTextLineCount")
local voiceCatalog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/voiceCatalog")

local eventNames = MomentsCommon.Analytics.EventNames

local GetFIntMomentsTTSComposerMaxLines = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSComposerMaxLines")
local GetFIntMomentsTTSComposerMinLines = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSComposerMinLines")
local GetFIntMomentsTTSDefaultVoiceId = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSDefaultVoiceId")
local GetFIntMomentsTTSMaxCharacters = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSMaxCharacters")
local GetFFlagMomentsTTSStartTimePositioning = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSStartTimePositioning")
local FFlagMomentsTTSStartTimeScrubberFollow = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSStartTimeScrubberFollow")
local FFlagMomentsTTSComposerCaretAlignment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSComposerCaretAlignment")
local FFlagMomentsTTSVoiceSelector = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSVoiceSelector")
local FFlagMomentsTTSComposerUncontrolledInput = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSComposerUncontrolledInput")
local FFlagMomentsTTSTooManyDigitsError = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSTooManyDigitsError")
local DialogType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DialogType")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local v5 = GetFIntMomentsTTSDefaultVoiceId()

local v6 = GetFIntMomentsTTSComposerMinLines()
local v7 = GetFIntMomentsTTSComposerMaxLines()

local builderSans = Enum.Font.BuilderSans

local v8 = {
	["‘"] = "'",
	["’"] = "'",
	["“"] = "\"",
	["”"] = "\"",
	["–"] = "-",
	["—"] = "-"
}

local function trimWhitespace(value)
	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function isPointWithin(p2, p3, p4): boolean
	if p2 == nil then
		return false
	end

	local absolutePosition = p2.AbsolutePosition
	local absoluteSize = p2.AbsoluteSize
	return absolutePosition.X <= p3
		and p3 <= absolutePosition.X + absoluteSize.X
		and absolutePosition.Y <= p4
		and p4 <= absolutePosition.Y + absoluteSize.Y
end

local function useVoiceEditorViewModel(data)
	local controller = data.controller
	local v9 = GetFIntMomentsTTSMaxCharacters()
	local playback = controller.preview.playback

	local ttsAudio = controller.ttsAudio
	assert(ttsAudio ~= nil, "VoiceEditor requires controller.ttsAudio")

	local v10 = {
		createText = "Feature.Moments.Action.CreateVoiceover",
		saveText = "Feature.Moments.Action.SaveVoiceover",
		placeholderText = {
			"Feature.Moments.Label.VoicePlaceholder",
			maxCount = v9
		},
		helperDefault = "Feature.Moments.Label.VoiceHelperDefault",
		overLimit = "Feature.Moments.Label.ExceedsCharacterLimit",
		generating = "Feature.Moments.Label.VoiceGenerating",
		moderationError = "Feature.Moments.Label.VoiceModerationError",
		limitError = "Feature.Moments.Label.VoiceLimitReachedBody",
		timeoutError = "Feature.Moments.Label.VoiceTimeoutBody",
		failureError = "Feature.Moments.Label.VoiceGenerationFailedBody"
	}

	if FFlagMomentsTTSTooManyDigitsError then
		v10.tooManyDigitsError = "Feature.Moments.Label.VoiceTooManyNumbersError"
	end

	local v11 = useLocalization(v10)

	local v12 = {
		moderated = v11.moderationError,
		quotaExceeded = v11.limitError,
		timeout = v11.timeoutError,
		tooManyDigits = v11.tooManyDigitsError,
		failure = v11.failureError
	}

	local failureError = v11.failureError

	local v13 = useOnScreenKeyboardHeight() > 0

	local state, setState = useState(UserInputService.PreferredInput == Enum.PreferredInput.Touch)
	useEffect(function()
		local preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			setState(UserInputService.PreferredInput == Enum.PreferredInput.Touch)
		end)
		return function()
			preferredInputChangedConnection:Disconnect()
		end
	end, {})

	local v14 = useComposerParentTextPadding(FFlagMomentsTTSComposerCaretAlignment and state)

	local v15 = useTokens()

	local state2, setState2 = useState("")

	local setSelectedVoiceId = controller.setSelectedVoiceId
	local v16 = v5

	if FFlagMomentsTTSVoiceSelector then
		v16 = useSignalState(controller.getSelectedVoiceId) or v5
	end

	local voiceById = voiceCatalog.getVoiceById(v16)
	local v17, v18, ref

	if FFlagMomentsTTSComposerUncontrolledInput then
		v17, v18 = React.useBinding("")

		ref = React.useRef("")
	else
		ref = nil
		v18 = nil
	end

	local state3, setState3 = useState(0)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(false)

	local ref4 = React.useRef(nil)

	local state4, setState4 = useState(0)

	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)

	local ref7 = if FFlagMomentsTTSVoiceSelector then React.useRef(nil) else nil

	local ref8 = React.useRef(false)
	local state5, setState5 = useState(false)

	local state6, setState6 = useState(false)

	local state7, setState7 = useState("")
	local ref9 = React.useRef("")

	local state8, setState8 = useState(0)

	local state9, setState9 = useState(0)

	local state10 = v5
	local setState10

	if FFlagMomentsTTSVoiceSelector then
		state10, setState10 = useState(v5)
	else
		setState10 = nil
	end

	local v19 = not GetFFlagMomentsTTSStartTimePositioning and 0 or state8
	local ref10 = React.useRef(false)

	local ref11 = React.useRef(false)

	local ref12 = React.useRef(nil)

	local ref13 = React.useRef(0)

	local v20 = useSignalState(ttsAudio.getState)
	local v21 = useSignalState(ttsAudio.getErrorReason)
	local v22 = useSignalState(ttsAudio.getTimeLength)
	local v23 = useSignalState(ttsAudio.getWaveform)

	local ref14 = React.useRef(false)
	local state11, setState11 = useState(controller.getActiveSession(false))
	useEffect(function()
		return Signals.createEffect(function(p2)
			setState11(controller.getActiveSession(p2))
		end)
	end, { controller })

	useEffect(function()
		if ref14.current or state11 == nil then
			return
		end

		local draft = state11.getDraft(false)

		if draft == nil or draft.text == nil or not (#draft.text > 0) then
			ref14.current = true

			return
		end

		ref14.current = true
		setState2(draft.text)

		if FFlagMomentsTTSComposerUncontrolledInput and ref and v18 then
			ref.current = draft.text
			v18(draft.text)
		end

		ref9.current = draft.text
		setState5(true)
		setState7(draft.text)

		if FFlagMomentsTTSVoiceSelector and draft.voiceId ~= nil and setState10 ~= nil then
			setSelectedVoiceId(draft.voiceId)
			setState10(draft.voiceId)
		end

		if GetFFlagMomentsTTSStartTimePositioning then
			local startTime = draft.startTime or 0
			local duration = playback.getDuration(false)

			if duration > 0 then
				startTime = clampTtsStartTime(startTime, duration)
			end

			setState8(startTime)
			setState9(draft.startTime or 0)
		end

		ref10.current = true
	end, { state11, playback, setSelectedVoiceId })

	useEffect(function()
		if v20 == "ready" and ref9.current ~= "" then
			setState5(true)

			if not ref10.current then
				ref10.current = true

				fireAnalyticsEvent(eventNames.EditingFlowVoiceGenerateSucceeded, makeCreationEventFields.makeVoiceEventFields({
					char_count = tostring(utf8.len(ref9.current) or #ref9.current),
					tts_duration = tostring(ttsAudio.getTimeLength(false)),
					voice_id = tostring(ttsAudio.getLoadedVoiceId(false))
				}))

				if ref11.current then
					ref11.current = false

					ref13.current = playback.getPosition(false)
					playback.play()
				else
					ref13.current = v19
					playback.seek(v19)
					ttsAudio.seek(0)
					playback.play()
					ttsAudio.play()
				end
			end
		elseif v20 == "error" then
			setState5(false)

			local errorReason = ttsAudio.getErrorReason(false)

			fireAnalyticsEvent(eventNames.EditingFlowVoiceGenerateFailed, makeCreationEventFields.makeVoiceEventFields({
				failure_reason = tostring(errorReason or "failure")
			}))

			if errorReason ~= "moderated" and errorReason ~= "tooManyDigits" then
				controller.showModal({
					modalType = DialogType.VoiceoverError,
					modalProps = {
						message = v12[errorReason] or failureError,
						onTryAgain = function()
							controller.dismissModal()

							if ref12.current ~= nil then
								ref12.current()
							end
						end,
						onDismiss = controller.dismissModal
					}
				})
			end
		end
	end, { v20 })

	local state12, setState12 = useState(playback.getIsPlaying(false))
	useEffect(function()
		return Signals.createEffect(function(p2)
			setState12(playback.getIsPlaying(p2))
		end)
	end, { playback })

	useEffect(function()
		if v22 <= 0 then
			return
		end

		local isPlaying = playback.getIsPlaying(false)
		local v24 = v19 + v22
		local position = playback.getPosition(false)
		local v25 = v19 <= position and position < v24

		if isPlaying and v25 then
			if v19 > 0 then
				ttsAudio.seek(position - v19)
			end

			ttsAudio.play()
		elseif not isPlaying or GetFFlagMomentsTTSStartTimePositioning then
			ttsAudio.pause()
		end
	end, { state12, v22, v19 })

	useEffect(function()
		if v22 <= 0 then
			return
		end

		local v24 = v19 + v22

		return Signals.createEffect(function(p2)
			local position = playback.getPosition(p2)
			local current = ref13.current
			ref13.current = position

			if not playback.getIsPlaying(false) then
				return
			end

			local v25 = v19 <= position and position < v24

			if current - position > 0.5 then
				if v25 then
					ttsAudio.seek(position - v19)
					ttsAudio.play()
				elseif GetFFlagMomentsTTSStartTimePositioning then
					ttsAudio.pause()
				end
			elseif GetFFlagMomentsTTSStartTimePositioning and current < v19 and v25 then
				ttsAudio.seek(position - v19)
				ttsAudio.play()
			end
		end)
	end, { v22, v19 })

	local v24 = useCallback(function(p2)
		if v22 <= 0 then
			return
		end

		local v25 = v19 + v22

		if v19 <= p2 and p2 < v25 then
			ttsAudio.seek(p2 - v19)
		end
	end, { v22, v19 })

	local v25 = useCallback(function(value)
		local v26 = value:gsub("[\r\n]+", " ")

		for k, v27 in v8 do
			v26 = v26:gsub(k, v27)
		end

		local v27 = v26:gsub("[^ -~]", "")

		if FFlagMomentsTTSComposerUncontrolledInput and ref and v18 then
			setState2(v27)
			ref.current = v27

			if v27 ~= value then
				v18(value)
				v18(v27)
			end
		elseif v27 == state2 and v27 ~= value then
			ref4.current = v27
			setState2(value)
		else
			setState2(v27)
		end

		if v27 ~= "" and not ref3.current then
			ref3.current = true
			fireAnalyticsEvent(eventNames.EditingFlowVoiceTextEntered, makeCreationEventFields.makeVoiceEventFields())
		end

		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		if FFlagMomentsTTSVoiceSelector then
			local draft = activeSession.getDraft(false)

			if draft ~= nil and draft.text == v27 then
				return
			end
		end

		activeSession.update(v27 ~= "" and {
			text = v27,
			voiceId = v16,
			startTime = v19
		} or nil)
	end, { state2, controller, v19, v16 })

	useLayoutEffect(function()
		if ref4.current ~= nil then
			local current = ref4.current
			ref4.current = nil
			setState2(current)
		end
	end)

	local v26 = useCallback(function(p2)
		setState3(p2.AbsoluteSize.X)
	end, {})

	local fontSize = v15.Typography.BodyMedium.FontSize
	local v27 = useMemo(function()
		local v28 = measureTextLineCount(state2, state3 - 32, fontSize, builderSans, v7)

		return (math.max(v6, v28))
	end, { state2, state3, fontSize })

	local v28 = computeVoiceButtonState({
		text = state2,
		lastGeneratedText = ref9.current,
		lastSavedText = state7,
		maxChars = v9,
		ttsState = v20,
		errorReason = v21,
		hasGenerated = state5,
		hasCleared = state6,
		startTime = v19,
		lastSavedStartTime = state9,
		voiceId = v16,
		lastSavedVoiceId = state10
	})

	local isGenerating = v28.isGenerating
	local charCount = v28.charCount
	local isOverLimit = v28.isOverLimit
	local canGenerate = v28.canGenerate

	local v29 = v28.showSave and not v13

	local isModerated = v28.isModerated
	local isTooManyDigits = v28.isTooManyDigits

	local ref15 = React.useRef(false)

	useEffect(function()
		if v20 ~= "loading" then
			ref15.current = false
		end
	end, { v20 })

	local v31 = useCallback(function(p2, p3, p4, p5)
		if ref15.current or ttsAudio.getState(false) == "loading" or not canGenerate and p4 == nil then
			return
		end

		if ref2.current ~= nil then
			ref2.current.releaseFocus()
		end

		if FFlagMomentsTTSComposerUncontrolledInput and v18 and ref then
			v18(ref.current)
		end

		ref15.current = true
		local v32 = p2 or v16
		local v33 = (p4 or state2):gsub("^%s*(.-)%s*$", "%1")

		ref9.current = v33

		local activeSession = controller.getActiveSession(false)

		if v33 == "" then
			ref15.current = false
			controller.clearActiveTool()
			setState5(false)
			setState6(true)
		else
			setState6(false)

			local v34 = v19

			if GetFFlagMomentsTTSStartTimePositioning and not p5 then
				v34 = (p3 or playback.getIsPlaying(false)) and 0
					or clampTtsStartTime(playback.getPosition(false), playback.getDuration(false))
				setState8(v34)

				if v34 > 0 and v34 ~= v19 then
					local duration = playback.getDuration(false)
					fireAnalyticsEvent(
						eventNames.EditingFlowVoiceoverStartTimeAdjusted,
						makeCreationEventFields.makeVoiceEventFields({
							source = "generate",
							start_time_seconds = tostring(v34),
							video_duration_seconds = tostring(duration),
							start_time_fraction = tostring(not (duration > 0) and 0 or v34 / duration)
						})
					)
				end
			end

			if activeSession ~= nil then
				activeSession.update({ text = v33, voiceId = v32, startTime = v34 })
			end

			fireAnalyticsEvent(eventNames.EditingFlowVoiceGeneratePressed, makeCreationEventFields.makeVoiceEventFields())

			ref10.current = false
			ref11.current = p5 == true
			ttsAudio.generate(v33, v32)
		end
	end, { state2, controller, canGenerate, v19, v16 })

	ref12.current = v31

	local v32 = useCallback(function()
		v31()
	end, { v31 })

	local v33 = useCallback(function()
		local current = ref9.current
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update(current ~= "" and {
				text = current,
				voiceId = v16,
				startTime = v19
			} or nil)
		end

		setState7(current)
		setState9(v19)

		if setState10 ~= nil then
			setState10(v16)
		end

		controller.commitActiveTool()
	end, { controller, v19, v16 })
	local v34

	if FFlagMomentsTTSVoiceSelector then
		v34 = useVoiceSelector({
			controller = controller,
			text = state2,
			canGenerate = canGenerate,
			selectedVoiceId = v16,
			onCreateVoiceover = v31,
			lastGeneratedTextRef = ref9,
			createPreviewAudio = data.createPreviewAudio
		})
	end

	local onOpenVoiceSelector = if v34 ~= nil then v34.onOpenVoiceSelector else nil

	useEffect(function()
		if state4 > 0 and ref2.current ~= nil then
			ref2.current.focus()
		end
	end, { state4 })

	local v35 = useCallback(function()
		ref8.current = v13
		local function refocusIfEditing()
			if ref8.current and ref2.current ~= nil then
				ref2.current.focus()
			end
		end
		local function performDelete()
			fireAnalyticsEvent(eventNames.EditingFlowVoiceoverDeleted, makeCreationEventFields.makeVoiceEventFields())
			controller.dismissModal()

			if ref2.current ~= nil then
				ref2.current.releaseFocus()
			end

			setState2("")

			if FFlagMomentsTTSComposerUncontrolledInput and ref and v18 then
				ref.current = ""
				v18("")
			end

			setState5(false)
			setState6(false)
			ref9.current = ""
			ref10.current = false

			controller.clearActiveTool()
			controller.saveActiveTool()
			setState7("")

			if ref8.current then
				setState4(function(p2)
					return p2 + 1
				end)
			end
		end
		local function cancelDelete()
			fireAnalyticsEvent(eventNames.EditingFlowVoiceoverDeleteCancelled, makeCreationEventFields.makeVoiceEventFields())

			controller.dismissModal()

			if ref8.current and ref2.current ~= nil then
				ref2.current.focus()
			end
		end

		fireAnalyticsEvent(eventNames.EditingFlowVoiceoverDeleteButtonPressed, makeCreationEventFields.makeVoiceEventFields())

		controller.showModal({
			modalType = DialogType.VoiceoverDelete,
			modalProps = { onConfirm = performDelete, onCancel = cancelDelete }
		})
	end, { controller, v13 })

	local v36 = useCallback(function(p2)
		if FFlagMomentsTTSComposerUncontrolledInput and v18 and ref then
			v18(ref.current)
		end

		if p2 == nil then
			return
		end

		local position = p2.Position
		local current = ref5.current
		local x = position.X
		local y = position.Y
		local v37

		if current == nil then
			v37 = false
		else
			local absolutePosition = current.AbsolutePosition
			local absoluteSize = current.AbsoluteSize

			if
				absolutePosition.X <= x
				and x <= absolutePosition.X + absoluteSize.X
				and absolutePosition.Y <= y
			then
				v37 = y <= absolutePosition.Y + absoluteSize.Y
			else
				v37 = false
			end
		end

		if v37 then
			if v29 then
				v33()
			else
				v31()
			end
		else
			local current2 = ref6.current
			local x2 = position.X
			local y2 = position.Y
			local v38

			if current2 == nil then
				v38 = false
			else
				local absolutePosition = current2.AbsolutePosition
				local absoluteSize = current2.AbsoluteSize

				if
					absolutePosition.X <= x2
					and x2 <= absolutePosition.X + absoluteSize.X
					and absolutePosition.Y <= y2
				then
					v38 = y2 <= absolutePosition.Y + absoluteSize.Y
				else
					v38 = false
				end
			end

			if v38 then
				v35()
			elseif ref7 ~= nil and onOpenVoiceSelector ~= nil then
				local current3 = ref7.current
				local x3 = position.X
				local y3 = position.Y
				local v39

				if current3 == nil then
					v39 = false
				else
					local absolutePosition = current3.AbsolutePosition
					local absoluteSize = current3.AbsoluteSize

					if
						absolutePosition.X <= x3
						and x3 <= absolutePosition.X + absoluteSize.X
						and absolutePosition.Y <= y3
					then
						v39 = y3 <= absolutePosition.Y + absoluteSize.Y
					else
						v39 = false
					end
				end

				if v39 then
					onOpenVoiceSelector()
				end
			end
		end
	end, { v29, v33, v31, v35, onOpenVoiceSelector })

	local state13, setState13 = useState(controller.preview.getCapture(false))

	local state14, setState14 = useState(playback.getDuration(false))
	useEffect(function()
		return Signals.createEffect(function(p2)
			setState13(controller.preview.getCapture(p2))
			setState14(playback.getDuration(p2))
		end)
	end, { controller, playback })
	local v37

	if isOverLimit then
		v37 = v11.overLimit
	elseif isModerated then
		v37 = v11.moderationError
	elseif isTooManyDigits then
		v37 = v11.tooManyDigitsError
	else
		v37 = if isGenerating then v11.generating else v11.helperDefault
	end

	local v38 = (v20 == "ready" or v20 == "playing") and v22 > 0 and state14 > 0

	local ref16 = React.useRef(v19)

	local v39 = useCallback(function(current)
		setState8(current)

		if FFlagMomentsTTSStartTimeScrubberFollow then
			ref16.current = current
		end

		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)

		if draft ~= nil and draft.text ~= nil and draft.text ~= "" then
			activeSession.update({
				text = draft.text,
				voiceId = draft.voiceId,
				startTime = current
			})
		end
	end, { controller })

	local ref17 = React.useRef(false)
	local ref18 = React.useRef(0)
	local ref19 = React.useRef(v22)
	useEffect(function()
		ref16.current = v19
		ref19.current = v22
	end, { v19, v22 })

	local v42 = useTtsStartTimeDrag(GetFFlagMomentsTTSStartTimePositioning and v38, state14, state8, v39, useCallback(function()
		ref18.current = ref16.current

		if playback.getIsPlaying(false) then
			ref17.current = true
			playback.pause()
		end
	end, { playback }), (useCallback(function(p2)
		local current = ref17.current
		ref17.current = false
		local current2 = ref16.current

		if GetFFlagMomentsTTSStartTimePositioning and current2 ~= ref18.current then
			local duration = playback.getDuration(false)
			fireAnalyticsEvent(eventNames.EditingFlowVoiceoverStartTimeAdjusted, makeCreationEventFields.makeVoiceEventFields({
				source = "drag",
				start_time_seconds = tostring(current2),
				video_duration_seconds = tostring(duration),
				start_time_fraction = tostring(not (duration > 0) and 0 or current2 / duration)
			}))
		end

		if FFlagMomentsTTSStartTimeScrubberFollow and not p2 and current2 ~= ref18.current then
			playback.seek(current2)
			ttsAudio.seek(0)
			playback.play()
			ttsAudio.play()
		else
			local position = playback.getPosition(false)
			local v42 = current2 + ref19.current

			if current2 <= position and position < v42 then
				ttsAudio.seek(position - current2)
			else
				ttsAudio.pause()
			end

			if current then
				playback.play()
			end
		end
	end, { playback })))

	local v43 = {}
	v43.layoutOrder = data.layoutOrder
	v43.playback = playback
	v43.capture = state13
	v43.onTimelineSeek = v24
	local v44 = if FFlagMomentsTTSStartTimeScrubberFollow and v42.isSelected then state8 else nil
	v43.playheadPosition = v44

	v43.showAudioWaveform = v38
	v43.audioDuration = v22
	v43.videoDuration = state14
	v43.startTime = state8
	v43.waveformDragDetectorRef = v42.dragDetectorRef
	v43.waveformSelected = v42.isSelected
	v43.waveformSamples = v23

	if not FFlagMomentsTTSComposerUncontrolledInput then
		v17 = state2
	end

	v43.text = v17
	v43.textBoxRef = ref2
	v43.composerContainerRef = v14
	v43.numLines = v27
	v43.onComposerResize = v26
	v43.onTextChanged = v25
	v43.onTextBoxFocusLost = v36
	v43.createButtonRef = ref5
	v43.deleteButtonRef = ref6
	v43.placeholderText = v11.placeholderText
	v43.isGenerating = isGenerating
	v43.isInputInvalid = isOverLimit or isModerated or isTooManyDigits

	v43.showVoiceSelector = FFlagMomentsTTSVoiceSelector
	local v45 = if voiceById ~= nil then voiceById.name else nil
	v43.selectedVoiceName = v45
	v43.onOpenVoiceSelector = onOpenVoiceSelector
	v43.voiceSelectorButtonRef = ref7

	v43.helperText = v37
	v43.charCount = charCount
	v43.maxChars = v9
	v43.isOverLimit = isOverLimit

	v43.showSave = v29
	v43.canGenerate = canGenerate
	v43.onSave = v33
	v43.onCreateVoiceover = v32
	v43.createText = v11.createText
	v43.saveText = v11.saveText

	v43.showDelete = v38
	v43.onDelete = v35
	return v43
end

return useVoiceEditorViewModel
