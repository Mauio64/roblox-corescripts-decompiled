local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local UserInputService = game:GetService("UserInputService")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useLayoutEffect = React.useLayoutEffect
local useLocalization = Localization.Hooks.useLocalization
local useMemo = React.useMemo
local useState = React.useState
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens

require(script.Parent.VoiceEditorView)
local useVoiceSelector = require(script.Parent.useVoiceSelector)
local useComposerParentTextPadding = require(MomentsCreation.Hooks.useComposerParentTextPadding)
local useOnScreenKeyboardHeight = require(MomentsCreation.Hooks.useOnScreenKeyboardHeight)
local useTtsStartTimeDrag = require(MomentsCreation.Hooks.useTtsStartTimeDrag)
local clampTtsStartTime = require(MomentsCreation.Utils.clampTtsStartTime)
local computeVoiceButtonState = require(MomentsCreation.Utils.computeVoiceButtonState)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local measureTextLineCount = require(MomentsCreation.Utils.measureTextLineCount)
local voiceCatalog = require(MomentsCreation.Components.Voice.voiceCatalog)

local EventNames = MomentsCommon.Analytics.EventNames

local GetFIntMomentsTTSComposerMaxLines = require(MomentsCreation.Flags.GetFIntMomentsTTSComposerMaxLines)
local GetFIntMomentsTTSComposerMinLines = require(MomentsCreation.Flags.GetFIntMomentsTTSComposerMinLines)
local GetFIntMomentsTTSDefaultVoiceId = require(MomentsCreation.Flags.GetFIntMomentsTTSDefaultVoiceId)
local GetFIntMomentsTTSMaxCharacters = require(MomentsCreation.Flags.GetFIntMomentsTTSMaxCharacters)
local GetFFlagMomentsTTSStartTimePositioning = require(MomentsCreation.Flags.GetFFlagMomentsTTSStartTimePositioning)
local FFlagMomentsTTSStartTimeScrubberFollow = require(MomentsCreation.Flags.FFlagMomentsTTSStartTimeScrubberFollow)
local FFlagMomentsTTSComposerCaretAlignment = require(MomentsCreation.Flags.FFlagMomentsTTSComposerCaretAlignment)
local FFlagMomentsTTSVoiceSelector = require(MomentsCreation.Flags.FFlagMomentsTTSVoiceSelector)
local FFlagMomentsTTSComposerUncontrolledInput = require(MomentsCreation.Flags.FFlagMomentsTTSComposerUncontrolledInput)
local FFlagMomentsTTSTooManyDigitsError = require(MomentsCreation.Flags.FFlagMomentsTTSTooManyDigitsError)
local DialogType = require(MomentsCreation.Enums.DialogType)
require(MomentsCreation.Types.CreationFlowTypes)

local fIntMomentsTTSDefaultVoiceId = GetFIntMomentsTTSDefaultVoiceId()

local fIntMomentsTTSComposerMinLines = GetFIntMomentsTTSComposerMinLines()
local fIntMomentsTTSComposerMaxLines = GetFIntMomentsTTSComposerMaxLines()

local BuilderSans = Enum.Font.BuilderSans

local v = {
	["‘"] = "'",
	["’"] = "'",
	["“"] = "\"",
	["”"] = "\"",
	["–"] = "-",
	["—"] = "-"
}

local function trimWhitespace(value: string) -- 1 equivalent call inferred from this helper
	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function isPointWithin(current, x: number, y: number): boolean -- 3 equivalent calls inferred from this helper
	if current == nil then
		return false
	end

	local absolutePosition = current.AbsolutePosition
	local absoluteSize = current.AbsoluteSize
	return absolutePosition.X <= x
		and x <= absolutePosition.X + absoluteSize.X
		and absolutePosition.Y <= y
		and y <= absolutePosition.Y + absoluteSize.Y
end

local function useVoiceEditorViewModel(data)
	local controller = data.controller
	local v2 = GetFIntMomentsTTSMaxCharacters()
	local playback = controller.preview.playback

	local ttsAudio = controller.ttsAudio
	assert(ttsAudio ~= nil, "VoiceEditor requires controller.ttsAudio")

	local v3 = {
		createText = "Feature.Moments.Action.CreateVoiceover",
		saveText = "Feature.Moments.Action.SaveVoiceover",
		placeholderText = {
			"Feature.Moments.Label.VoicePlaceholder",
			maxCount = v2
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
		v3.tooManyDigitsError = "Feature.Moments.Label.VoiceTooManyNumbersError"
	end

	local v4 = useLocalization(v3)

	local v5 = {
		moderated = v4.moderationError,
		quotaExceeded = v4.limitError,
		timeout = v4.timeoutError,
		tooManyDigits = v4.tooManyDigitsError,
		failure = v4.failureError
	}

	local failureError = v4.failureError

	local current3 = useOnScreenKeyboardHeight() > 0

	local state, setState = useState(UserInputService.PreferredInput == Enum.PreferredInput.Touch)
	useEffect(function()
		local preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			setState(UserInputService.PreferredInput == Enum.PreferredInput.Touch)
		end)
		return function()
			preferredInputChangedConnection:Disconnect()
		end
	end, {})

	local composerContainerRef = useComposerParentTextPadding(FFlagMomentsTTSComposerCaretAlignment and state)

	local v6 = useTokens()

	local state2, setState2 = useState("")

	local setSelectedVoiceId = controller.setSelectedVoiceId
	local v7 = fIntMomentsTTSDefaultVoiceId

	if FFlagMomentsTTSVoiceSelector then
		v7 = useSignalState(controller.getSelectedVoiceId) or fIntMomentsTTSDefaultVoiceId
	end

	local voiceById = voiceCatalog.getVoiceById(v7)
	local text, v8, ref

	if FFlagMomentsTTSComposerUncontrolledInput then
		text, v8 = React.useBinding("")

		ref = React.useRef("")
	else
		ref = nil
		v8 = nil
	end

	local state3, setState3 = useState(0)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(false)

	local ref4 = React.useRef(nil)

	local state4, setState4 = useState(0)

	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local ref7

	if FFlagMomentsTTSVoiceSelector then
		ref7 = React.useRef(nil)
	else
		ref7 = nil
	end

	local ref8 = React.useRef(false)
	local state5, setState5 = useState(false)

	local state6, setState6 = useState(false)

	local state7, setState7 = useState("")
	local ref9 = React.useRef("")

	local state8, setState8 = useState(0)

	local state9, setState9 = useState(0)

	local state10 = fIntMomentsTTSDefaultVoiceId
	local setState10

	if FFlagMomentsTTSVoiceSelector then
		state10, setState10 = useState(fIntMomentsTTSDefaultVoiceId)
	else
		setState10 = nil
	end

	local v9 = not GetFFlagMomentsTTSStartTimePositioning and 0 or state8
	local ref10 = React.useRef(false)

	local ref11 = React.useRef(false)

	local ref12 = React.useRef(nil)

	local ref13 = React.useRef(0)

	local ttsState = useSignalState(ttsAudio.getState)
	local errorReason2 = useSignalState(ttsAudio.getErrorReason)
	local v10 = useSignalState(ttsAudio.getTimeLength)
	local waveformSamples = useSignalState(ttsAudio.getWaveform)

	local ref14 = React.useRef(false)
	local state11, setState11 = useState(controller.getActiveSession(false))
	useEffect(function()
		return Signals.createEffect(function(p)
			setState11(controller.getActiveSession(p))
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

		if FFlagMomentsTTSComposerUncontrolledInput and ref and v8 then
			ref.current = draft.text
			v8(draft.text)
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
		if ttsState == "ready" and ref9.current ~= "" then
			setState5(true)

			if not ref10.current then
				ref10.current = true

				fireAnalyticsEvent(
					EventNames.EditingFlowVoiceGenerateSucceeded,
					makeCreationEventFields.makeVoiceEventFields({
						char_count = tostring(utf8.len(ref9.current) or #ref9.current),
						tts_duration = tostring(ttsAudio.getTimeLength(false)),
						voice_id = tostring(ttsAudio.getLoadedVoiceId(false))
					})
				)

				if ref11.current then
					ref11.current = false

					ref13.current = playback.getPosition(false)
					playback.play()
				else
					ref13.current = v9
					playback.seek(v9)
					ttsAudio.seek(0)
					playback.play()
					ttsAudio.play()
				end
			end
		elseif ttsState == "error" then
			setState5(false)

			local errorReason = ttsAudio.getErrorReason(false)

			fireAnalyticsEvent(EventNames.EditingFlowVoiceGenerateFailed, makeCreationEventFields.makeVoiceEventFields({
				failure_reason = tostring(errorReason or "failure")
			}))

			if errorReason ~= "moderated" and errorReason ~= "tooManyDigits" then
				controller.showModal({
					modalType = DialogType.VoiceoverError,
					modalProps = {
						message = v5[errorReason] or failureError,
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
	end, { ttsState })

	local state12, setState12 = useState(playback.getIsPlaying(false))
	useEffect(function()
		return Signals.createEffect(function(p)
			setState12(playback.getIsPlaying(p))
		end)
	end, { playback })

	useEffect(function()
		if v10 <= 0 then
			return
		end

		local isPlaying = playback.getIsPlaying(false)
		local v11 = v9 + v10
		local position = playback.getPosition(false)
		local v12

		if v9 <= position then
			v12 = position < v11
		else
			v12 = false
		end

		if isPlaying and v12 then
			if v9 > 0 then
				ttsAudio.seek(position - v9)
			end

			ttsAudio.play()
		elseif not isPlaying or GetFFlagMomentsTTSStartTimePositioning then
			ttsAudio.pause()
		end
	end, { state12, v10, v9 })

	useEffect(function()
		if v10 <= 0 then
			return
		end

		local v11 = v9 + v10

		return Signals.createEffect(function(p)
			local position = playback.getPosition(p)
			local current = ref13.current
			ref13.current = position

			if not playback.getIsPlaying(false) then
				return
			end

			local v12

			if v9 <= position then
				v12 = position < v11
			else
				v12 = false
			end

			if current - position > 0.5 then
				if v12 then
					ttsAudio.seek(position - v9)
					ttsAudio.play()
				elseif GetFFlagMomentsTTSStartTimePositioning then
					ttsAudio.pause()
				end
			elseif GetFFlagMomentsTTSStartTimePositioning and current < v9 and v12 then
				ttsAudio.seek(position - v9)
				ttsAudio.play()
			end
		end)
	end, { v10, v9 })

	local onTimelineSeek = useCallback(function(p: number)
		if v10 <= 0 then
			return
		end

		local v11 = v9 + v10

		if v9 <= p and p < v11 then
			ttsAudio.seek(p - v9)
		end
	end, { v10, v9 })

	local onTextChanged = useCallback(function(value: string)
		local v11 = value:gsub("[\r\n]+", " ")

		for k, v12 in v do
			v11 = v11:gsub(k, v12)
		end

		local v12 = v11:gsub("[^ -~]", "")

		if FFlagMomentsTTSComposerUncontrolledInput and ref and v8 then
			setState2(v12)
			ref.current = v12

			if v12 ~= value then
				v8(value)
				v8(v12)
			end
		elseif v12 == state2 and v12 ~= value then
			ref4.current = v12
			setState2(value)
		else
			setState2(v12)
		end

		if v12 ~= "" and not ref3.current then
			ref3.current = true
			fireAnalyticsEvent(EventNames.EditingFlowVoiceTextEntered, makeCreationEventFields.makeVoiceEventFields())
		end

		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		if FFlagMomentsTTSVoiceSelector then
			local draft = activeSession.getDraft(false)

			if draft ~= nil and draft.text == v12 then
				return
			end
		end

		activeSession.update(v12 ~= "" and { text = v12, voiceId = v7, startTime = v9 } or nil)
	end, { state2, controller, v9, v7 })

	useLayoutEffect(function()
		if ref4.current ~= nil then
			local current = ref4.current
			ref4.current = nil
			setState2(current)
		end
	end)

	local onComposerResize = useCallback(function(p)
		setState3(p.AbsoluteSize.X)
	end, {})

	local fontSize = v6.Typography.BodyMedium.FontSize
	local numLines = useMemo(function()
		return (math.max(
			fIntMomentsTTSComposerMinLines,
			(measureTextLineCount(state2, state3 - 32, fontSize, BuilderSans, fIntMomentsTTSComposerMaxLines))
		))
	end, { state2, state3, fontSize })

	local v11 = computeVoiceButtonState({
		text = state2,
		lastGeneratedText = ref9.current,
		lastSavedText = state7,
		maxChars = v2,
		ttsState = ttsState,
		errorReason = errorReason2,
		hasGenerated = state5,
		hasCleared = state6,
		startTime = v9,
		lastSavedStartTime = state9,
		voiceId = v7,
		lastSavedVoiceId = state10
	})

	local isGenerating = v11.isGenerating
	local charCount = v11.charCount
	local isOverLimit = v11.isOverLimit
	local canGenerate = v11.canGenerate

	local showSave = v11.showSave and not current3

	local isModerated = v11.isModerated
	local isTooManyDigits = v11.isTooManyDigits

	local ref15 = React.useRef(false)

	useEffect(function()
		if ttsState ~= "loading" then
			ref15.current = false
		end
	end, { ttsState })

	local v12 = useCallback(function(p: number?, flag: boolean?, p2: string?, flag2: boolean?)
		if ref15.current or ttsAudio.getState(false) == "loading" or not canGenerate and p2 == nil then
			return
		end

		if ref2.current ~= nil then
			ref2.current.releaseFocus()
		end

		if FFlagMomentsTTSComposerUncontrolledInput and v8 and ref then
			v8(ref.current)
		end

		ref15.current = true
		local voiceId = p or v7
		local v12 = trimWhitespace(p2 or state2) -- inferred equivalent call
		ref9.current = v12

		local activeSession = controller.getActiveSession(false)

		if v12 == "" then
			ref15.current = false
			controller.clearActiveTool()
			setState5(false)
			setState6(true)
		else
			setState6(false)

			local startTime = v9

			if GetFFlagMomentsTTSStartTimePositioning and not flag2 then
				startTime = (flag or playback.getIsPlaying(false)) and 0
					or clampTtsStartTime(playback.getPosition(false), playback.getDuration(false))
				setState8(startTime)

				if startTime > 0 and startTime ~= v9 then
					local duration = playback.getDuration(false)
					fireAnalyticsEvent(
						EventNames.EditingFlowVoiceoverStartTimeAdjusted,
						makeCreationEventFields.makeVoiceEventFields({
							source = "generate",
							start_time_seconds = tostring(startTime),
							video_duration_seconds = tostring(duration),
							start_time_fraction = tostring(not (duration > 0) and 0 or startTime / duration)
						})
					)
				end
			end

			if activeSession ~= nil then
				activeSession.update({ text = v12, voiceId = voiceId, startTime = startTime })
			end

			fireAnalyticsEvent(
				EventNames.EditingFlowVoiceGeneratePressed,
				makeCreationEventFields.makeVoiceEventFields()
			)

			ref10.current = false
			ref11.current = flag2 == true
			ttsAudio.generate(v12, voiceId)
		end
	end, { state2, controller, canGenerate, v9, v7 })

	ref12.current = v12

	local onCreateVoiceover = useCallback(function()
		v12()
	end, { v12 })

	local onSave = useCallback(function()
		local current = ref9.current
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update(current ~= "" and { text = current, voiceId = v7, startTime = v9 } or nil)
		end

		setState7(current)
		setState9(v9)

		if setState10 ~= nil then
			setState10(v7)
		end

		controller.commitActiveTool()
	end, { controller, v9, v7 })
	local v13

	if FFlagMomentsTTSVoiceSelector then
		v13 = useVoiceSelector({
			controller = controller,
			text = state2,
			canGenerate = canGenerate,
			selectedVoiceId = v7,
			onCreateVoiceover = v12,
			lastGeneratedTextRef = ref9,
			createPreviewAudio = data.createPreviewAudio
		})
	end

	local onOpenVoiceSelector

	if v13 == nil then
		onOpenVoiceSelector = nil
	else
		onOpenVoiceSelector = v13.onOpenVoiceSelector
	end

	useEffect(function()
		if state4 > 0 and ref2.current ~= nil then
			ref2.current.focus()
		end
	end, { state4 })

	local onDelete = useCallback(function()
		ref8.current = current3
		local function refocusIfEditing() -- 1 equivalent call inferred from this helper
			if ref8.current and ref2.current ~= nil then
				ref2.current.focus()
			end
		end
		local function performDelete()
			fireAnalyticsEvent(EventNames.EditingFlowVoiceoverDeleted, makeCreationEventFields.makeVoiceEventFields())
			controller.dismissModal()

			if ref2.current ~= nil then
				ref2.current.releaseFocus()
			end

			setState2("")

			if FFlagMomentsTTSComposerUncontrolledInput and ref and v8 then
				ref.current = ""
				v8("")
			end

			setState5(false)
			setState6(false)
			ref9.current = ""
			ref10.current = false

			controller.clearActiveTool()
			controller.saveActiveTool()
			setState7("")

			if ref8.current then
				setState4(function(p)
					return p + 1
				end)
			end
		end
		local function cancelDelete()
			fireAnalyticsEvent(
				EventNames.EditingFlowVoiceoverDeleteCancelled,
				makeCreationEventFields.makeVoiceEventFields()
			)

			controller.dismissModal()
			refocusIfEditing() -- inferred equivalent call
		end

		fireAnalyticsEvent(
			EventNames.EditingFlowVoiceoverDeleteButtonPressed,
			makeCreationEventFields.makeVoiceEventFields()
		)

		controller.showModal({
			modalType = DialogType.VoiceoverDelete,
			modalProps = { onConfirm = performDelete, onCancel = cancelDelete }
		})
	end, { controller, current3 })

	local onTextBoxFocusLost = useCallback(function(p)
		if FFlagMomentsTTSComposerUncontrolledInput and v8 and ref then
			v8(ref.current)
		end

		if p == nil then
			return
		end

		local position = p.Position

		if isPointWithin(ref5.current, position.X, position.Y) then -- inferred equivalent call
			if showSave then
				onSave()
			else
				v12()
			end
		elseif isPointWithin(ref6.current, position.X, position.Y) then -- inferred equivalent call
			onDelete()
		elseif ref7 ~= nil and onOpenVoiceSelector ~= nil and isPointWithin(ref7.current, position.X, position.Y) then -- inferred equivalent call
			onOpenVoiceSelector()
		end
	end, { showSave, onSave, v12, onDelete, onOpenVoiceSelector })

	local state13, setState13 = useState(controller.preview.getCapture(false))

	local state14, setState14 = useState(playback.getDuration(false))
	useEffect(function()
		return Signals.createEffect(function(p)
			setState13(controller.preview.getCapture(p))
			setState14(playback.getDuration(p))
		end)
	end, { controller, playback })
	local helperText

	if isOverLimit then
		helperText = v4.overLimit
	elseif isModerated then
		helperText = v4.moderationError
	elseif isTooManyDigits then
		helperText = v4.tooManyDigitsError
	elseif isGenerating then
		helperText = v4.generating
	else
		helperText = v4.helperDefault
	end

	local v14

	if (ttsState == "ready" or ttsState == "playing") and v10 > 0 then
		v14 = state14 > 0
	else
		v14 = false
	end

	local ref16 = React.useRef(v9)

	local v15 = useCallback(function(current: number)
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
			activeSession.update({ text = draft.text, voiceId = draft.voiceId, startTime = current })
		end
	end, { controller })

	local ref17 = React.useRef(false)
	local ref18 = React.useRef(0)
	local ref19 = React.useRef(v10)
	useEffect(function()
		ref16.current = v9
		ref19.current = v10
	end, { v9, v10 })

	local v16 = useTtsStartTimeDrag(
		GetFFlagMomentsTTSStartTimePositioning and v14,
		state14,
		state8,
		v15,
		useCallback(function()
			ref18.current = ref16.current

			if playback.getIsPlaying(false) then
				ref17.current = true
				playback.pause()
			end
		end, { playback }),
		(useCallback(function(flag: boolean)
			local current = ref17.current
			ref17.current = false
			local current2 = ref16.current

			if GetFFlagMomentsTTSStartTimePositioning and current2 ~= ref18.current then
				local duration = playback.getDuration(false)
				fireAnalyticsEvent(
					EventNames.EditingFlowVoiceoverStartTimeAdjusted,
					makeCreationEventFields.makeVoiceEventFields({
						source = "drag",
						start_time_seconds = tostring(current2),
						video_duration_seconds = tostring(duration),
						start_time_fraction = tostring(not (duration > 0) and 0 or current2 / duration)
					})
				)
			end

			if FFlagMomentsTTSStartTimeScrubberFollow and not flag and current2 ~= ref18.current then
				playback.seek(current2)
				ttsAudio.seek(0)
				playback.play()
				ttsAudio.play()
			else
				local position = playback.getPosition(false)
				local v16 = current2 + ref19.current

				if current2 <= position and position < v16 then
					ttsAudio.seek(position - current2)
				else
					ttsAudio.pause()
				end

				if current then
					playback.play()
				end
			end
		end, { playback }))
	)

	local v17 = {}
	v17.layoutOrder = data.layoutOrder
	v17.playback = playback
	v17.capture = state13
	v17.onTimelineSeek = onTimelineSeek
	local playheadPosition

	if FFlagMomentsTTSStartTimeScrubberFollow and v16.isSelected then
		playheadPosition = state8
	end

	v17.playheadPosition = playheadPosition

	v17.showAudioWaveform = v14
	v17.audioDuration = v10
	v17.videoDuration = state14
	v17.startTime = state8
	v17.waveformDragDetectorRef = v16.dragDetectorRef
	v17.waveformSelected = v16.isSelected
	v17.waveformSamples = waveformSamples

	if not FFlagMomentsTTSComposerUncontrolledInput then
		text = state2
	end

	v17.text = text
	v17.textBoxRef = ref2
	v17.composerContainerRef = composerContainerRef
	v17.numLines = numLines
	v17.onComposerResize = onComposerResize
	v17.onTextChanged = onTextChanged
	v17.onTextBoxFocusLost = onTextBoxFocusLost
	v17.createButtonRef = ref5
	v17.deleteButtonRef = ref6
	v17.placeholderText = v4.placeholderText
	v17.isGenerating = isGenerating
	v17.isInputInvalid = isOverLimit or isModerated or isTooManyDigits

	v17.showVoiceSelector = FFlagMomentsTTSVoiceSelector
	local selectedVoiceName

	if voiceById ~= nil then
		selectedVoiceName = voiceById.name
	end

	v17.selectedVoiceName = selectedVoiceName
	v17.onOpenVoiceSelector = onOpenVoiceSelector
	v17.voiceSelectorButtonRef = ref7

	v17.helperText = helperText
	v17.charCount = charCount
	v17.maxChars = v2
	v17.isOverLimit = isOverLimit

	v17.showSave = showSave
	v17.canGenerate = canGenerate
	v17.onSave = onSave
	v17.onCreateVoiceover = onCreateVoiceover
	v17.createText = v4.createText
	v17.saveText = v4.saveText

	v17.showDelete = v14
	v17.onDelete = onDelete
	return v17
end

return useVoiceEditorViewModel
