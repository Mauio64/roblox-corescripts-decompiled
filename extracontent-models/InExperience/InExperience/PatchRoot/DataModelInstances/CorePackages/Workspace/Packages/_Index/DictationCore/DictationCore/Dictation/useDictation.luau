local DictationCore = script:FindFirstAncestor("DictationCore")
local parent = DictationCore.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local DictationMode = require(script.Parent.DictationMode)
local DictationTriggerTypes = require(script.Parent.DictationTriggerTypes)
local FFlagDictationSharedMic = require(DictationCore.Flags.FFlagDictationSharedMic)
local FFlagDictationExplicitFinish = require(DictationCore.Flags.FFlagDictationExplicitFinish)
local GetMicStore = require(DictationCore.Stores.GetMicStore)
local useDictationAudioPipeline = require(script.Parent.useDictationAudioPipeline)
local requestMicPermission = require(script.Parent.requestMicPermission)
local requestMicPermission2 = requestMicPermission.requestMicPermission
local permissionStatus = requestMicPermission.PermissionStatus

local createSignal = Signals.createSignal
local useSignalBinding = SignalsReact.useSignalBinding

local DictationState = require(script.Parent.DictationState)

local DictationErrorReason = require(script.Parent.DictationErrorReason)

local v = {
	debug = function() end,
	warning = function() end
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

		local micStore = GetMicStore(false)
		local v4 = React.useMemo(function()
			return micStore.createHolderId()
		end, { micStore })

		local getIsMicInUseElsewhere = React.useCallback(function(p): boolean
			local holderId = micStore.getHolderId(p)
			return holderId ~= nil and holderId ~= v4
		end, { micStore, v4 })

		local v5 = useDictationAudioPipeline()

		local v6, v7 = React.useBinding(0)
		local countdownProgress, v8 = ReactOtter.useAnimatedBinding(0)

		local isRecording = useSignalBinding(function(p): boolean
			return get(p) == DictationState.Recording
		end)

		local isTranscribing = useSignalBinding(function(p): boolean
			return get(p) == DictationState.Transcribing
		end)

		local isBusy = useSignalBinding(function(p): boolean
			local v9 = get(p)
			return v9 == DictationState.Recording or v9 == DictationState.Transcribing
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
			local v9 = get(p)
			return v9 == DictationState.Recording or v9 == DictationState.Listening
		end)

		local ref = React.useRef(current)
		ref.current = current

		local function getLogger() -- 11 equivalent calls inferred from this helper
			local current2 = ref.current
			return current2 ~= nil and current2.logger or v
		end

		local ref2 = React.useRef(false)

		local ref3 = React.useRef(false)

		local ref4 = React.useRef(nil)
		local ref5 = React.useRef(nil)

		local ref6 = React.useRef(0)

		local ref7 = React.useRef(nil)

		local function transitionTo(p)
			set(p)

			if not FFlagDictationSharedMic and p ~= DictationState.Recording and p ~= DictationState.Listening then
				micStore.drop(v4)
			end

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
		end

		local function fullCleanup(flag: boolean?) -- 6 equivalent calls inferred from this helper
			v5.stop(flag)
			safeCancelThread(ref5) -- inferred equivalent call
			safeCancelThread(ref4) -- inferred equivalent call
			v8(ReactOtter.instant(0))
		end

		local function handleError(p, p2: string)
			getLogger():warning("Dictation: {} ({})", p2, p) -- inferred equivalent call
			local mode

			if ref7.current then
				mode = ref7.current.mode
			end

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

				if not FFlagDictationSharedMic then
					micStore.drop(v4)
				end
			end
		end, {})

		local function emitRecordingStop(p, p2: number?) -- 7 equivalent calls inferred from this helper
			local current2 = ref7.current
			local current3 = ref.current

			if current3 == nil or current3.onRecordingStop == nil or current2 == nil or current2.startedAt == nil then
				return
			end

			current3.onRecordingStop(current2.mode, p, os.clock() - current2.startedAt, p2)
		end

		local ref8 = React.useRef(nil)
		local v9 = React.useCallback(function(p)
			local v9 = p or DictationTriggerTypes.UserManual
			local v10 = get(false)

			if FFlagDictationExplicitFinish and v9 == DictationTriggerTypes.SafetyIntervention then
				ref6.current += 1
				v5.discardPending()

				if v10 == DictationState.Recording or v10 == DictationState.Transcribing then
					return
				end

				fullCleanup(true) -- inferred equivalent call
				transitionTo(DictationState.Idle)
				emitRecordingStop(v9) -- inferred equivalent call
				ref7.current = nil
			else
				local v11 = FFlagDictationExplicitFinish

				if v11 then
					if v10 == DictationState.Listening then
						v11 = v9 == DictationTriggerTypes.UserManual
					else
						v11 = false
					end
				end

				if v10 == DictationState.Listening and not v11 then
					getLogger():debug("Dictation: exited continuous mode") -- inferred equivalent call
					fullCleanup(true) -- inferred equivalent call
					transitionTo(DictationState.Idle)
					emitRecordingStop(v9) -- inferred equivalent call
					ref7.current = nil
				else
					if v10 ~= DictationState.Recording and not v11 then
						return
					end

					safeCancelThread(ref5) -- inferred equivalent call
					safeCancelThread(ref4) -- inferred equivalent call

					if ref3.current then
						if v5.audioDeviceInputRef.current then
							v5.audioDeviceInputRef.current.Muted = true
						end

						if FFlagDictationExplicitFinish and not v5.finishInput() then
							getLogger():warning("Dictation: explicit finish unavailable, waiting for muted input to end speech") -- inferred equivalent call
						end

						if v11 then
							v5.drain(5)
							transitionTo(DictationState.Idle)
							emitRecordingStop(v9) -- inferred equivalent call
							ref7.current = nil
						else
							transitionTo(DictationState.Transcribing)
							getLogger():debug("Dictation: stopped recording, waiting for transcription") -- inferred equivalent call
							emitRecordingStop(v9) -- inferred equivalent call
							ref5.current = task.delay(5, function()
								handleError(DictationErrorReason.TranscriptionFailed, "transcription timed out")
							end)
						end
					else
						getLogger():debug("Dictation: no voice activity, returning to idle") -- inferred equivalent call
						fullCleanup(nil) -- inferred equivalent call
						transitionTo(DictationState.Idle)
						emitRecordingStop(v9) -- inferred equivalent call
						ref7.current = nil
					end
				end
			end
		end, { v5, get })
		ref8.current = v9

		local v10 = React.useCallback(function()
			local v10 = get(false)

			if v10 == DictationState.Recording or v10 == DictationState.Listening then
				if ref8.current then
					ref8.current(DictationTriggerTypes.MicStolen)
				end
			else
				ref6.current += 1
				ref7.current = nil
			end
		end, { get })

		local startDictation = React.useCallback(function(mode)
			if not (get(false) == DictationState.Idle and (FFlagDictationSharedMic or micStore.hold(v4, v10))) then
				return
			end

			ref7.current = { mode = mode }

			ref6.current += 1
			local current2 = ref6.current

			local function doStartStandard()
				ref3.current = false

				local success, result = pcall(function()
					v5.start({
						onTranscription = function(list: string)
							getLogger():debug("Dictation: received transcription: {}", list) -- inferred equivalent call

							if get(false) == DictationState.Recording then
								emitRecordingStop(DictationTriggerTypes.AutoPause, #list) -- inferred equivalent call
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
							handleError(DictationErrorReason.TranscriptionFailed, p)
						end
					}, {
						containerName = ref.current and ref.current.containerName
					})
				end)

				if not success then
					handleError(DictationErrorReason.Other, "failed to start recording: " .. tostring(result))

					return
				end

				transitionTo(DictationState.Recording)

				if ref7.current then
					ref7.current.startedAt = os.clock()
				end

				local current3 = ref.current

				if current3 and current3.onRecordingStart then
					current3.onRecordingStart(DictationMode.Standard, DictationTriggerTypes.UserManual)
				end

				v7(10)

				v8(ReactOtter.instant(1))
				task.defer(function()
					v8((ReactOtter.ease(0, v2)))
				end)
				getLogger():debug("Dictation: started recording") -- inferred equivalent call
				startCountdownTimer(ref4, v7) -- inferred equivalent call
				ref5.current = task.delay(10, function()
					getLogger():debug("Dictation: max recording time reached, stopping") -- inferred equivalent call

					if ref8.current then
						ref8.current(DictationTriggerTypes.TimeUp)
					end
				end)
			end

			local function doStartContinuous()
				local current3 = ref7.current

				if FFlagDictationExplicitFinish then
					ref3.current = false
				end

				local success, result = pcall(function()
					v5.start({
						onTranscription = function(p: string)
							getLogger():debug("Dictation: continuous utterance: {}", p) -- inferred equivalent call
							local current4 = ref.current

							if current4 ~= nil and current4.onTranscription ~= nil then
								current4.onTranscription(p, DictationMode.Continuous)
							end
						end,
						onSpeechStarted = function()
							if FFlagDictationExplicitFinish and ref7.current ~= current3 then
								return
							end

							if FFlagDictationExplicitFinish then
								ref3.current = true
							end

							local current4 = ref.current

							if current4 ~= nil and current4.onSpeechStarted ~= nil then
								current4.onSpeechStarted(DictationMode.Continuous)
							end
						end,
						onError = function(p: string)
							if FFlagDictationExplicitFinish and ref7.current ~= current3 then
								return
							end

							handleError(DictationErrorReason.TranscriptionFailed, p)
						end
					}, {
						continuous = true,
						containerName = ref.current and ref.current.containerName
					})
				end)

				if not success then
					handleError(DictationErrorReason.Other, "failed to enter continuous mode: " .. tostring(result))

					return
				end

				transitionTo(DictationState.Listening)

				if ref7.current then
					ref7.current.startedAt = os.clock()
				end

				local current4 = ref.current

				if current4 and current4.onRecordingStart then
					current4.onRecordingStart(DictationMode.Continuous, DictationTriggerTypes.UserManual)
				end

				getLogger():debug("Dictation: entered continuous mode") -- inferred equivalent call
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
						DictationErrorReason.PermissionDenied,
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

				handleError(DictationErrorReason.PermissionDenied, "mic permission request failed: " .. tostring(p))
			end)
		end, { v5, get, micStore, v4, v10 })

		local cancel = React.useCallback(function()
			getLogger():debug("Dictation: cancelled") -- inferred equivalent call

			ref6.current += 1
			fullCleanup(true) -- inferred equivalent call
			transitionTo(DictationState.Idle)
			emitRecordingStop(DictationTriggerTypes.UserManual) -- inferred equivalent call
			ref7.current = nil
		end, {})

		local mapped = v6:map(function(p: number)
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
			getIsMicInUseElsewhere = getIsMicInUseElsewhere,
			startDictation = startDictation,
			stopDictation = v9,
			cancel = cancel,
			audioDeviceInput = v5.audioDeviceInput,
			bindings = bindings
		}
	end,
	DictationState = DictationState,
	DictationErrorReason = DictationErrorReason,
	formatTime = formatTime,
	MAX_RECORDING_SECONDS = 10
}
