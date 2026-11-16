local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local ExpChatShared = require(parent.ExpChatShared)
local v = ExpChatShared.Logger:new("ExpChat/Dictation")

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatDictationStateStore = SharedFlags.FFlagExpChatDictationStateStore
local GetDictationStateStore = require(ExpChat.Stores.GetDictationStateStore)

local DictationMode = require(script.Parent.DictationMode)
local DictationState = require(script.Parent.DictationState)
local DictationAnalytics = require(script.Parent.DictationAnalytics)
local FFlagExpChatDictationExplicitFinish = require(ExpChat.Flags.FFlagExpChatDictationExplicitFinish)
local useDictationAudioPipeline = require(script.Parent.useDictationAudioPipeline)
local requestMicPermission = require(script.Parent.requestMicPermission)
local requestMicPermission2 = requestMicPermission.requestMicPermission
local permissionStatus = requestMicPermission.PermissionStatus

local createSignal = Signals.createSignal
local useSignalBinding = SignalsReact.useSignalBinding

local function publishDictationState(p) -- 2 equivalent calls inferred from this helper
	GetDictationStateStore(false).setDictationState(p)
end

local dictationErrorReason = {
	PermissionDenied = "permission_denied",
	TranscriptionFailed = "transcription_failed",
	LanguageUnsupported = "language_unsupported",
	Other = "other"
}

local v2 = { duration = 10, easingStyle = Enum.EasingStyle.Linear }

local function formatTime(p: number)
	return string.format("%d:%02d", math.floor(p / 60), p % 60)
end

local function safeCancelThread(p) -- 7 equivalent calls inferred from this helper
	if p.current then
		pcall(task.cancel, p.current)
		p.current = nil
	end
end

local function startCountdownTimer(ref, callback) -- 1 equivalent call inferred from this helper
	safeCancelThread(ref) -- inferred equivalent call
	ref.current = task.spawn(function()
		for i = 1, 10 do
			task.wait(1)
			callback(10 - i)
		end
	end)
end

return {
	useDictation = function(current)
		local v3 = React.useMemo(function()
			local signal, set = createSignal(DictationState.Idle)
			return { get = signal, set = set }
		end, {})
		local get = v3.get
		local set = v3.set

		local v4 = useDictationAudioPipeline()

		local v5, v6 = React.useBinding(0)
		local countdownProgress, v7 = ReactOtter.useAnimatedBinding(0)

		local isRecording = useSignalBinding(function(p): boolean
			return get(p) == DictationState.Recording
		end)

		local isTranscribing = useSignalBinding(function(p): boolean
			return get(p) == DictationState.Transcribing
		end)

		local isBusy = useSignalBinding(function(p): boolean
			local v8 = get(p)
			return v8 == DictationState.Recording or v8 == DictationState.Transcribing
		end)

		local isIdle = useSignalBinding(function(p): boolean
			return get(p) == DictationState.Idle
		end)

		local isNotRecording = useSignalBinding(function(p): boolean
			return get(p) ~= DictationState.Recording
		end)

		local isListening = useSignalBinding(function(p): boolean
			return get(p) == DictationState.Listening
		end)

		local isAudioActive = useSignalBinding(function(p): boolean
			local v8 = get(p)
			return v8 == DictationState.Recording or v8 == DictationState.Listening
		end)

		local ref = React.useRef(current)
		ref.current = current

		local ref2 = React.useRef(false)

		local ref3 = React.useRef(false)

		local ref4 = React.useRef(nil)
		local ref5 = React.useRef(nil)

		local ref6 = React.useRef(0)

		local ref7 = React.useRef(nil)

		local function transitionTo(p)
			local v8 = get(false)
			set(p)

			local current3 = p == DictationState.Recording
				or p == DictationState.Transcribing
				or p == DictationState.Listening

			if current3 ~= ref2.current then
				ref2.current = current3
				local current2 = ref.current

				if current2 ~= nil and current2.onActivityChanged ~= nil then
					current2.onActivityChanged(current3)
				end
			end

			if p ~= v8 then
				if FFlagExpChatDictationStateStore then
					publishDictationState(p) -- inferred equivalent call
				end

				local current2 = ref.current

				if current2 ~= nil and current2.onStateChanged ~= nil then
					current2.onStateChanged(p)
				end
			end
		end

		local function fullCleanup(flag: boolean?) -- 6 equivalent calls inferred from this helper
			v4.stop(flag)
			safeCancelThread(ref5) -- inferred equivalent call
			safeCancelThread(ref4) -- inferred equivalent call
			v7(ReactOtter.instant(0))
		end

		local function handleError(p, p2: string)
			v:warning("Dictation: {} ({})", p2, p)
			local mode = ref7.current and ref7.current.mode or nil
			fullCleanup(nil) -- inferred equivalent call
			transitionTo(DictationState.Idle)
			local current2 = ref.current

			if current2 ~= nil and current2.onError ~= nil then
				current2.onError(mode, p)
			end

			ref7.current = nil
		end

		React.useEffect(function()
			return function()
				ref6.current += 1
				safeCancelThread(ref5) -- inferred equivalent call
				safeCancelThread(ref4) -- inferred equivalent call

				if get(false) ~= DictationState.Idle then
					if FFlagExpChatDictationStateStore then
						publishDictationState(DictationState.Idle) -- inferred equivalent call
					end

					local current2 = ref.current

					if current2 ~= nil and current2.onStateChanged ~= nil then
						current2.onStateChanged(DictationState.Idle)
					end
				end
			end
		end, { get })

		local function emitRecordingStop(p, p2: number?) -- 7 equivalent calls inferred from this helper
			local current2 = ref7.current
			local current3 = ref.current

			if current3 == nil or current3.onRecordingStop == nil or current2 == nil or current2.startedAt == nil then
				return
			end

			current3.onRecordingStop(current2.mode, p, os.clock() - current2.startedAt, p2)
		end

		local ref8 = React.useRef(nil)
		local v8 = React.useCallback(function(p)
			local v8 = p or DictationAnalytics.TriggerTypes.UserManual
			local v9 = get(false)

			if FFlagExpChatDictationExplicitFinish and v8 == DictationAnalytics.TriggerTypes.SafetyIntervention then
				ref6.current += 1
				v4.discardPending()

				if v9 == DictationState.Recording or v9 == DictationState.Transcribing then
					return
				end

				fullCleanup(true) -- inferred equivalent call
				transitionTo(DictationState.Idle)
				emitRecordingStop(v8) -- inferred equivalent call
				ref7.current = nil
			else
				local v10 = FFlagExpChatDictationExplicitFinish

				if v10 then
					if v9 == DictationState.Listening then
						v10 = v8 == DictationAnalytics.TriggerTypes.UserManual
					else
						v10 = false
					end
				end

				if v9 == DictationState.Listening and not v10 then
					v:debug("Dictation: exited continuous mode")
					fullCleanup(true) -- inferred equivalent call
					transitionTo(DictationState.Idle)
					emitRecordingStop(v8) -- inferred equivalent call
					ref7.current = nil
				else
					if v9 ~= DictationState.Recording and not v10 then
						return
					end

					safeCancelThread(ref5) -- inferred equivalent call
					safeCancelThread(ref4) -- inferred equivalent call

					if ref3.current then
						if v4.audioDeviceInputRef.current then
							v4.audioDeviceInputRef.current.Muted = true
						end

						if FFlagExpChatDictationExplicitFinish and not v4.finishInput() then
							v:warning("Dictation: explicit finish unavailable, waiting for muted input to end speech")
						end

						if v10 then
							v4.drain(5)
							transitionTo(DictationState.Idle)
							emitRecordingStop(v8) -- inferred equivalent call
							ref7.current = nil
						else
							transitionTo(DictationState.Transcribing)
							v:debug("Dictation: stopped recording, waiting for transcription")
							emitRecordingStop(v8) -- inferred equivalent call
							ref5.current = task.delay(5, function()
								handleError(dictationErrorReason.TranscriptionFailed, "transcription timed out")
							end)
						end
					else
						v:debug("Dictation: no voice activity, returning to idle")
						fullCleanup(nil) -- inferred equivalent call
						transitionTo(DictationState.Idle)
						emitRecordingStop(v8) -- inferred equivalent call
						ref7.current = nil
					end
				end
			end
		end, { v4, get })
		ref8.current = v8

		local startDictation = React.useCallback(function(mode)
			if get(false) ~= DictationState.Idle then
				return
			end

			ref7.current = { mode = mode }

			ref6.current += 1
			local current2 = ref6.current

			local function doStartStandard()
				ref3.current = false

				local success, result = pcall(function()
					v4.start({
						onTranscription = function(list: string)
							v:debug("Dictation: received transcription: {}", list)

							if get(false) == DictationState.Recording then
								emitRecordingStop(DictationAnalytics.TriggerTypes.AutoPause, #list) -- inferred equivalent call
							end

							fullCleanup(nil) -- inferred equivalent call
							transitionTo(DictationState.Idle)
							local current3 = ref.current

							if current3 ~= nil and current3.onTranscription ~= nil then
								current3.onTranscription(list, DictationMode.Standard)
							end

							ref7.current = nil
						end,
						onSpeechStarted = function()
							ref3.current = true
						end,
						onError = function(p: string)
							handleError(dictationErrorReason.TranscriptionFailed, p)
						end
					})
				end)

				if not success then
					handleError(dictationErrorReason.Other, "failed to start recording: " .. tostring(result))

					return
				end

				transitionTo(DictationState.Recording)

				if ref7.current then
					ref7.current.startedAt = os.clock()
				end

				local current3 = ref.current

				if current3 and current3.onRecordingStart then
					current3.onRecordingStart(DictationMode.Standard, DictationAnalytics.TriggerTypes.UserManual)
				end

				v6(10)

				v7(ReactOtter.instant(1))
				task.defer(function()
					v7(ReactOtter.ease(0, v2))
				end)
				v:debug("Dictation: started recording")
				startCountdownTimer(ref4, v6) -- inferred equivalent call
				ref5.current = task.delay(10, function()
					v:debug("Dictation: max recording time reached, stopping")

					if ref8.current then
						ref8.current(DictationAnalytics.TriggerTypes.TimeUp)
					end
				end)
			end

			local function doStartContinuous()
				local current3 = ref7.current

				if FFlagExpChatDictationExplicitFinish then
					ref3.current = false
				end

				local success, result = pcall(function()
					v4.start({
						onTranscription = function(p: string)
							v:debug("Dictation: continuous utterance: {}", p)
							local current4 = ref.current

							if current4 ~= nil and current4.onTranscription ~= nil then
								current4.onTranscription(p, DictationMode.Continuous)
							end
						end,
						onSpeechStarted = function()
							if FFlagExpChatDictationExplicitFinish and ref7.current ~= current3 then
								return
							end

							if FFlagExpChatDictationExplicitFinish then
								ref3.current = true
							end

							local current4 = ref.current

							if current4 ~= nil and current4.onSpeechStarted ~= nil then
								current4.onSpeechStarted(DictationMode.Continuous)
							end
						end,
						onError = function(p: string)
							if FFlagExpChatDictationExplicitFinish and ref7.current ~= current3 then
								return
							end

							handleError(dictationErrorReason.TranscriptionFailed, p)
						end
					}, { continuous = true })
				end)

				if not success then
					handleError(dictationErrorReason.Other, "failed to enter continuous mode: " .. tostring(result))

					return
				end

				transitionTo(DictationState.Listening)

				if ref7.current then
					ref7.current.startedAt = os.clock()
				end

				local current4 = ref.current

				if current4 and current4.onRecordingStart then
					current4.onRecordingStart(DictationMode.Continuous, DictationAnalytics.TriggerTypes.UserManual)
				end

				v:debug("Dictation: entered continuous mode")
			end

			local function isStalePermissionRequest(): boolean -- 2 equivalent calls inferred from this helper
				return ref6.current ~= current2
			end

			requestMicPermission2():andThen(function(p)
				if isStalePermissionRequest() then -- inferred equivalent call
					return
				end

				local current3 = ref.current

				if current3 ~= nil and current3.onPermissionResolved ~= nil then
					current3.onPermissionResolved(p.status, mode)
				end

				if p.status == permissionStatus.Denied then
					handleError(
						dictationErrorReason.PermissionDenied,
						not p.error and "microphone permission denied" or "microphone permission denied: " .. p.error
					)
				elseif mode == DictationMode.Continuous then
					doStartContinuous()
				else
					doStartStandard()
				end
			end):catch(function(p)
				if isStalePermissionRequest() then -- inferred equivalent call
					return
				end

				handleError(dictationErrorReason.PermissionDenied, "mic permission request failed: " .. tostring(p))
			end)
		end, { v4, get })

		local cancel = React.useCallback(function()
			v:debug("Dictation: cancelled")

			ref6.current += 1
			fullCleanup(true) -- inferred equivalent call
			transitionTo(DictationState.Idle)
			emitRecordingStop(DictationAnalytics.TriggerTypes.UserManual) -- inferred equivalent call
			ref7.current = nil
		end, {})

		local mapped = v5:map(function(p: number)
			return formatTime(p)
		end)

		local bindings = React.useMemo(function()
			return {
				isRecording = isRecording,
				isNotRecording = isNotRecording,
				isTranscribing = isTranscribing,
				isBusy = isBusy,
				isIdle = isIdle,
				isListening = isListening,
				isAudioActive = isAudioActive,
				countdownText = mapped,
				countdownProgress = countdownProgress
			}
		end, {
			mapped,
			countdownProgress,
			isAudioActive,
			isBusy,
			isIdle,
			isListening,
			isNotRecording,
			isRecording,
			isTranscribing
		})

		return {
			getDictationState = get,
			startDictation = startDictation,
			stopDictation = v8,
			cancel = cancel,
			audioDeviceInput = v4.audioDeviceInput,
			bindings = bindings
		}
	end,
	DictationState = DictationState,
	DictationErrorReason = dictationErrorReason,
	formatTime = formatTime,
	MAX_RECORDING_SECONDS = 10
}
