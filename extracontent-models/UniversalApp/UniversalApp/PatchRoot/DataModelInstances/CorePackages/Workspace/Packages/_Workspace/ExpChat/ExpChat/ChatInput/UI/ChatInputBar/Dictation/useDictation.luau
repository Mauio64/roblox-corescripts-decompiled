local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local v6 = require(Parent.ExpChatShared).Logger:new("ExpChat/Dictation")
local DictationMode = require(script.Parent.DictationMode)
local DictationAnalytics = require(script.Parent.DictationAnalytics)
local useDictationAudioPipeline = require(script.Parent.useDictationAudioPipeline)
local requestMicPermission = require(script.Parent.requestMicPermission)
local requestMicPermission2 = requestMicPermission.requestMicPermission
local PermissionStatus = requestMicPermission.PermissionStatus
local createSignal = Signals.createSignal
local useSignalBinding = SignalsReact.useSignalBinding
local t1 = {
	Idle = "idle",
	Recording = "recording",
	Transcribing = "transcribing",
	Listening = "listening"
}
local t2 = {
	PermissionDenied = "permission_denied",
	TranscriptionFailed = "transcription_failed",
	LanguageUnsupported = "language_unsupported",
	Other = "other"
}
local t3 = {
	duration = 10,
	easingStyle = Enum.EasingStyle.Linear
}

local function formatTime(n1: number) -- line: 122
	return string.format("%d:%02d", math.floor(n1 / 60), n1 % 60)
end
local function safeCancelThread(t4: {[any]: any}) -- line: 126
	if t4.current then
		pcall(task.cancel, t4.current)
		t4.current = nil
	end
end
local function startCountdownTimer(t5: {[any]: any}, p1: ((...any) -> ...any)) -- line: 133
	if t5.current then
		pcall(task.cancel, t5.current)
		t5.current = nil
	end

	t5.current = task.spawn(function() -- line: 135
		-- upvalues: p1 (copy)
		for i = 1, 10 do
			task.wait(1)
			p1(10 - i)
		end
	end)
end

return {
	MAX_RECORDING_SECONDS = 10,
	useDictation = function(t6: {[any]: any}?) -- line: 143
		-- upvalues: React (copy), createSignal (copy), t1 (copy), useDictationAudioPipeline (copy), ReactOtter (copy), useSignalBinding (copy), v6 (copy), DictationAnalytics (copy), t2 (copy), DictationMode (copy), t3 (copy), requestMicPermission2 (copy), PermissionStatus (copy), formatTime (copy)
		local v26 = React.useMemo(function() -- line: 145
			-- upvalues: createSignal (copy), t1 (copy)
			local v59, v60 = createSignal(t1.Idle)

			return {
				get = v59,
				set = v60
			}
		end, {})
		local get = v26.get
		local set = v26.set
		local v29 = useDictationAudioPipeline()
		local v30, v31 = React.useBinding(0)
		local v32, v33 = ReactOtter.useAnimatedBinding(0)
		local v34 = useSignalBinding(function(p2) -- line: 158
			-- upvalues: get (copy), t1 (copy)
			return get(p2) == t1.Recording
		end)
		local v35 = useSignalBinding(function(p3) -- line: 161
			-- upvalues: get (copy), t1 (copy)
			return get(p3) == t1.Transcribing
		end)
		local v36 = useSignalBinding(function(p4) -- line: 164
			-- upvalues: get (copy), t1 (copy)
			local v64 = get(p4)

			return v64 == t1.Recording or v64 == t1.Transcribing
		end)
		local v37 = useSignalBinding(function(p5) -- line: 168
			-- upvalues: get (copy), t1 (copy)
			return get(p5) == t1.Idle
		end)
		local v38 = useSignalBinding(function(p6) -- line: 171
			-- upvalues: get (copy), t1 (copy)
			return get(p6) ~= t1.Recording
		end)
		local v39 = useSignalBinding(function(p7) -- line: 174
			-- upvalues: get (copy), t1 (copy)
			return get(p7) == t1.Listening
		end)
		local v40 = useSignalBinding(function(p8) -- line: 177
			-- upvalues: get (copy), t1 (copy)
			local v69 = get(p8)

			return v69 == t1.Recording or v69 == t1.Listening
		end)
		local v41 = React.useRef(t6)

		v41.current = t6

		local v42 = React.useRef(false)
		local v43 = React.useRef(false)
		local v44 = React.useRef(nil)
		local v45 = React.useRef(nil)
		local v46 = React.useRef(0)
		local v47 = React.useRef(nil)

		local function transitionTo(p9) -- line: 206
			-- upvalues: set (copy), t1 (copy), v42 (copy), v41 (copy)
			set(p9)

			local v71 = p9 == t1.Recording or (p9 == t1.Transcribing or p9 == t1.Listening)

			if v71 ~= v42.current then
				v42.current = v71

				local current = v41.current

				if current ~= nil and current.onActivityChanged ~= nil then
					current.onActivityChanged(v71)
				end
			end
		end
		local function fullCleanup() -- line: 221
			-- upvalues: v29 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy)
			v29.stop()

			local v73 = v45

			if v73.current then
				pcall(task.cancel, v73.current)
				v73.current = nil
			end

			local v74 = v44

			if v74.current then
				pcall(task.cancel, v74.current)
				v74.current = nil
			end

			v33(ReactOtter.instant(0))
		end
		local function handleError(p10, s1: string) -- line: 233
			-- upvalues: v6 (copy), v47 (copy), v29 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy), t1 (copy), set (copy), v42 (copy), v41 (copy)
			v6:warning("Dictation: {} ({})", s1, p10)

			local v77 = v47.current and v47.current.mode or nil

			v29.stop()

			local v78 = v45

			if v78.current then
				pcall(task.cancel, v78.current)
				v78.current = nil
			end

			local v79 = v44

			if v79.current then
				pcall(task.cancel, v79.current)
				v79.current = nil
			end

			v33(ReactOtter.instant(0))

			local Idle = t1.Idle

			set(Idle)

			local v81 = Idle == t1.Recording or (Idle == t1.Transcribing or Idle == t1.Listening)

			if v81 ~= v42.current then
				v42.current = v81

				local current = v41.current

				if current ~= nil and current.onActivityChanged ~= nil then
					current.onActivityChanged(v81)
				end
			end

			local current = v41.current

			if current ~= nil and current.onError ~= nil then
				current.onError(v77, p10)
			end

			v47.current = nil
		end

		React.useEffect(function() -- line: 248
			-- upvalues: v46 (copy), v45 (copy), v44 (copy)
			return function() -- line: 249
				-- upvalues: v46 (copy), v45 (copy), v44 (copy)
				local v128 = v46

				v128.current = v128.current + 1

				local v129 = v45

				if v129.current then
					pcall(task.cancel, v129.current)
					v129.current = nil
				end

				local v130 = v44

				if v130.current then
					pcall(task.cancel, v130.current)
					v130.current = nil
				end
			end
		end, {})

		local function emitRecordingStop(p11, n2: number?) -- line: 256
			-- upvalues: v47 (copy), v41 (copy)
			local current = v47.current
			local current2 = v41.current

			if current2 == nil or (current2.onRecordingStop == nil or current == nil or current.startedAt == nil) then
				return
			end

			current2.onRecordingStop(current.mode, p11, os.clock() - current.startedAt, n2)
		end

		local v52 = React.useRef(nil)
		local v53 = React.useCallback(function(p12) -- line: 267
			-- upvalues: DictationAnalytics (copy), get (copy), t1 (copy), v6 (copy), v29 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy), set (copy), v42 (copy), v41 (copy), v47 (copy), v43 (copy), handleError (copy), t2 (copy)
			local v89 = p12 or DictationAnalytics.TriggerTypes.UserManual
			local v90 = get(false)

			if v90 == t1.Listening then
				v6:debug("Dictation: exited continuous mode")
				v29.stop()

				local v91 = v45

				if v91.current then
					pcall(task.cancel, v91.current)
					v91.current = nil
				end

				local v92 = v44

				if v92.current then
					pcall(task.cancel, v92.current)
					v92.current = nil
				end

				v33(ReactOtter.instant(0))

				local Idle = t1.Idle

				set(Idle)

				local v94 = Idle == t1.Recording or (Idle == t1.Transcribing or Idle == t1.Listening)

				if v94 ~= v42.current then
					v42.current = v94

					local current = v41.current

					if current ~= nil and current.onActivityChanged ~= nil then
						current.onActivityChanged(v94)
					end
				end

				local current = v47.current
				local current3 = v41.current

				if current3 ~= nil and current3.onRecordingStop ~= nil and current ~= nil and current.startedAt ~= nil then
					current3.onRecordingStop(current.mode, v89, os.clock() - current.startedAt, nil)
				end

				v47.current = nil

				return
			end

			if v90 ~= t1.Recording then
				return
			end

			local v98 = v45

			if v98.current then
				pcall(task.cancel, v98.current)
				v98.current = nil
			end

			local v99 = v44

			if v99.current then
				pcall(task.cancel, v99.current)
				v99.current = nil
			end

			if not v43.current then
				v6:debug("Dictation: no voice activity, returning to idle")
				v29.stop()

				local v100 = v45

				if v100.current then
					pcall(task.cancel, v100.current)
					v100.current = nil
				end

				local v101 = v44

				if v101.current then
					pcall(task.cancel, v101.current)
					v101.current = nil
				end

				v33(ReactOtter.instant(0))

				local Idle = t1.Idle

				set(Idle)

				local v103 = Idle == t1.Recording or (Idle == t1.Transcribing or Idle == t1.Listening)

				if v103 ~= v42.current then
					v42.current = v103

					local current = v41.current

					if current ~= nil and current.onActivityChanged ~= nil then
						current.onActivityChanged(v103)
					end
				end

				local current = v47.current
				local current4 = v41.current

				if current4 ~= nil and current4.onRecordingStop ~= nil and current ~= nil and current.startedAt ~= nil then
					current4.onRecordingStop(current.mode, v89, os.clock() - current.startedAt, nil)
				end

				v47.current = nil

				return
			end

			if v29.audioDeviceInputRef.current then
				v29.audioDeviceInputRef.current.Muted = true
			end

			local Transcribing = t1.Transcribing

			set(Transcribing)

			local v108 = Transcribing == t1.Recording or (Transcribing == t1.Transcribing or Transcribing == t1.Listening)

			if v108 ~= v42.current then
				v42.current = v108

				local current = v41.current

				if current ~= nil and current.onActivityChanged ~= nil then
					current.onActivityChanged(v108)
				end
			end

			v6:debug("Dictation: stopped recording, waiting for transcription")

			local current = v47.current
			local current5 = v41.current

			if current5 ~= nil and current5.onRecordingStop ~= nil and current ~= nil and current.startedAt ~= nil then
				current5.onRecordingStop(current.mode, v89, os.clock() - current.startedAt, nil)
			end

			v45.current = task.delay(5, function() -- line: 304
				-- upvalues: handleError (copy), t2 (copy)
				handleError(t2.TranscriptionFailed, "transcription timed out")
			end)
		end, {
			v29,
			get
		})

		v52.current = v53

		local v54 = React.useCallback(function(p13) -- line: 310
			-- upvalues: get (copy), t1 (copy), v47 (copy), v46 (copy), v43 (copy), v29 (copy), v6 (copy), DictationAnalytics (copy), v41 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy), set (copy), v42 (copy), DictationMode (copy), handleError (copy), t2 (copy), v31 (copy), t3 (copy), v52 (copy), requestMicPermission2 (copy), PermissionStatus (copy)
			if get(false) ~= t1.Idle then
				return
			end

			v47.current = {
				mode = p13
			}

			local v113 = v46

			v113.current = v113.current + 1

			local current = v46.current

			local function doStartStandard() -- line: 322
				-- upvalues: v43 (copy), v29 (copy), v6 (copy), get (copy), t1 (copy), DictationAnalytics (copy), v47 (copy), v41 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy), set (copy), v42 (copy), DictationMode (copy), handleError (copy), t2 (copy), v31 (copy), t3 (copy), v52 (copy)
				v43.current = false

				local ok, result = pcall(function() -- line: 325
					-- upvalues: v29 (copy), v6 (copy), get (copy), t1 (copy), DictationAnalytics (copy), v47 (copy), v41 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy), set (copy), v42 (copy), DictationMode (copy), v43 (copy), handleError (copy), t2 (copy)
					v29.start({
						onTranscription = function(s2: string) -- line: 327
							-- upvalues: v6 (copy), get (copy), t1 (copy), DictationAnalytics (copy), v47 (copy), v41 (copy), v29 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy), set (copy), v42 (copy), DictationMode (copy)
							v6:debug("Dictation: received transcription: {}", s2)

							if get(false) == t1.Recording then
								local AutoPause = DictationAnalytics.TriggerTypes.AutoPause
								local v151 = #s2
								local current6 = v47.current
								local current7 = v41.current

								if current7 ~= nil and current7.onRecordingStop ~= nil and current6 ~= nil and current6.startedAt ~= nil then
									current7.onRecordingStop(current6.mode, AutoPause, os.clock() - current6.startedAt, v151)
								end
							end

							v29.stop()

							local v154 = v45

							if v154.current then
								pcall(task.cancel, v154.current)
								v154.current = nil
							end

							local v155 = v44

							if v155.current then
								pcall(task.cancel, v155.current)
								v155.current = nil
							end

							v33(ReactOtter.instant(0))

							local Idle = t1.Idle

							set(Idle)

							local v157 = Idle == t1.Recording or (Idle == t1.Transcribing or Idle == t1.Listening)

							if v157 ~= v42.current then
								v42.current = v157

								local current8 = v41.current

								if current8 ~= nil and current8.onActivityChanged ~= nil then
									current8.onActivityChanged(v157)
								end
							end

							local current9 = v41.current

							if current9 ~= nil and current9.onTranscription ~= nil then
								current9.onTranscription(s2, DictationMode.Standard)
							end

							v47.current = nil
						end,
						onSpeechStarted = function() -- line: 343
							-- upvalues: v43 (copy)
							v43.current = true
						end,
						onError = function(s3: string) -- line: 346
							-- upvalues: handleError (copy), t2 (copy)
							handleError(t2.TranscriptionFailed, s3)
						end
					})
				end)

				if ok then
					local Recording = t1.Recording

					set(Recording)

					local v134 = Recording == t1.Recording or (Recording == t1.Transcribing or Recording == t1.Listening)

					if v134 ~= v42.current then
						v42.current = v134

						local current10 = v41.current

						if current10 ~= nil and current10.onActivityChanged ~= nil then
							current10.onActivityChanged(v134)
						end
					end

					if v47.current then
						v47.current.startedAt = os.clock()
					end

					local current11 = v41.current

					if current11 and current11.onRecordingStart then
						current11.onRecordingStart(DictationMode.Standard, DictationAnalytics.TriggerTypes.UserManual)
					end

					v31(10)
					v33(ReactOtter.instant(1))
					task.defer(function() -- line: 372
						-- upvalues: v33 (copy), ReactOtter (copy), t3 (copy)
						v33(ReactOtter.ease(0, t3))
					end)
					v6:debug("Dictation: started recording")

					local v137 = v44
					local v138 = v31

					if v137.current then
						pcall(task.cancel, v137.current)
						v137.current = nil
					end

					v137.current = task.spawn(function() -- line: 135
						-- upvalues: v138 (copy)
						for i = 1, 10 do
							task.wait(1)
							v138(10 - i)
						end
					end)
					v45.current = task.delay(10, function() -- line: 379
						-- upvalues: v6 (copy), v52 (copy), DictationAnalytics (copy)
						v6:debug("Dictation: max recording time reached, stopping")

						if v52.current then
							v52.current(DictationAnalytics.TriggerTypes.TimeUp)
						end
					end)

					return
				end

				handleError(t2.Other, "failed to start recording: " .. tostring(result))
			end
			local function doStartContinuous() -- line: 390
				-- upvalues: v29 (copy), v6 (copy), v41 (copy), DictationMode (copy), handleError (copy), t2 (copy), t1 (copy), set (copy), v42 (copy), v47 (copy), DictationAnalytics (copy)
				local ok, result = pcall(function() -- line: 391
					-- upvalues: v29 (copy), v6 (copy), v41 (copy), DictationMode (copy), handleError (copy), t2 (copy)
					v29.start({
						onTranscription = function(s4: string) -- line: 393
							-- upvalues: v6 (copy), v41 (copy), DictationMode (copy)
							v6:debug("Dictation: continuous utterance: {}", s4)

							local current12 = v41.current

							if current12 ~= nil and current12.onTranscription ~= nil then
								current12.onTranscription(s4, DictationMode.Continuous)
							end
						end,
						onSpeechStarted = function() -- line: 400
							-- upvalues: v41 (copy), DictationMode (copy)
							local current13 = v41.current

							if current13 ~= nil and current13.onSpeechStarted ~= nil then
								current13.onSpeechStarted(DictationMode.Continuous)
							end
						end,
						onError = function(s5: string) -- line: 406
							-- upvalues: handleError (copy), t2 (copy)
							handleError(t2.TranscriptionFailed, s5)
						end
					}, {
						continuous = true
					})
				end)

				if ok then
					local Listening = t1.Listening

					set(Listening)

					local v142 = Listening == t1.Recording or (Listening == t1.Transcribing or Listening == t1.Listening)

					if v142 ~= v42.current then
						v42.current = v142

						local current14 = v41.current

						if current14 ~= nil and current14.onActivityChanged ~= nil then
							current14.onActivityChanged(v142)
						end
					end

					if v47.current then
						v47.current.startedAt = os.clock()
					end

					local current15 = v41.current

					if current15 and current15.onRecordingStart then
						current15.onRecordingStart(DictationMode.Continuous, DictationAnalytics.TriggerTypes.UserManual)
					end

					v6:debug("Dictation: entered continuous mode")

					return
				end

				handleError(t2.Other, "failed to enter continuous mode: " .. tostring(result))
			end
			local function isStalePermissionRequest() -- line: 428
				-- upvalues: v46 (copy), current (copy)
				return v46.current ~= current
			end

			requestMicPermission2():andThen(function(p14) -- line: 435
				-- upvalues: v46 (copy), current (copy), v41 (copy), p13 (copy), PermissionStatus (copy), handleError (copy), t2 (copy), DictationMode (copy), doStartContinuous (copy), doStartStandard (copy)
				if v46.current ~= current then
					return
				end

				local current16 = v41.current

				if current16 ~= nil and current16.onPermissionResolved ~= nil then
					current16.onPermissionResolved(p14.status, p13)
				end

				if p14.status == PermissionStatus.Denied then
					handleError(t2.PermissionDenied, not p14.error and "microphone permission denied" or "microphone permission denied: " .. p14.error)

					return
				end

				if p13 == DictationMode.Continuous then
					doStartContinuous()

					return
				end

				doStartStandard()
			end):catch(function(p15) -- line: 458
				-- upvalues: v46 (copy), current (copy), handleError (copy), t2 (copy)
				if v46.current ~= current then
					return
				end

				handleError(t2.PermissionDenied, "mic permission request failed: " .. tostring(p15))
			end)
		end, {
			v29,
			get
		})
		local v55 = React.useCallback(function() -- line: 470
			-- upvalues: v6 (copy), v46 (copy), v29 (copy), v45 (copy), v44 (copy), v33 (copy), ReactOtter (copy), t1 (copy), set (copy), v42 (copy), v41 (copy), DictationAnalytics (copy), v47 (copy)
			v6:debug("Dictation: cancelled")

			local v118 = v46

			v118.current = v118.current + 1
			v29.stop()

			local v119 = v45

			if v119.current then
				pcall(task.cancel, v119.current)
				v119.current = nil
			end

			local v120 = v44

			if v120.current then
				pcall(task.cancel, v120.current)
				v120.current = nil
			end

			v33(ReactOtter.instant(0))

			local Idle = t1.Idle

			set(Idle)

			local v122 = Idle == t1.Recording or (Idle == t1.Transcribing or Idle == t1.Listening)

			if v122 ~= v42.current then
				v42.current = v122

				local current = v41.current

				if current ~= nil and current.onActivityChanged ~= nil then
					current.onActivityChanged(v122)
				end
			end

			local UserManual = DictationAnalytics.TriggerTypes.UserManual
			local current = v47.current
			local current17 = v41.current

			if current17 ~= nil and current17.onRecordingStop ~= nil and current ~= nil and current.startedAt ~= nil then
				current17.onRecordingStop(current.mode, UserManual, os.clock() - current.startedAt, nil)
			end

			v47.current = nil
		end, {})
		local v56 = v30:map(function(n3: number) -- line: 480
			-- upvalues: formatTime (copy)
			return formatTime(n3)
		end)
		local v57 = React.useMemo(function() -- line: 485
			-- upvalues: v34 (copy), v38 (copy), v35 (copy), v36 (copy), v37 (copy), v39 (copy), v40 (copy), v56 (copy), v32 (copy)
			return {
				isRecording = v34,
				isNotRecording = v38,
				isTranscribing = v35,
				isBusy = v36,
				isIdle = v37,
				isListening = v39,
				isAudioActive = v40,
				countdownText = v56,
				countdownProgress = v32
			}
		end, {
			v56,
			v32,
			v40,
			v36,
			v37,
			v39,
			v38,
			v34,
			v35
		})

		return {
			getDictationState = get,
			startDictation = v54,
			stopDictation = v53,
			cancel = v55,
			audioDeviceInput = v29.audioDeviceInput,
			bindings = v57
		}
	end,
	DictationState = t1,
	DictationErrorReason = t2,
	formatTime = formatTime
}
