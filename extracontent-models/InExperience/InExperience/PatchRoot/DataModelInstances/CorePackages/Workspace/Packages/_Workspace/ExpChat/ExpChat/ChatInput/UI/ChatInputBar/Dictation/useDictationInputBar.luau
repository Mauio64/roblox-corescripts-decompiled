local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local FFlagExpChatDictationExplicitFinish = require(ExpChat.Flags.FFlagExpChatDictationExplicitFinish)

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactUtils = require(parent.ReactUtils)
local useAsync = ReactUtils.useAsync
local SignalsReact = require(parent.SignalsReact)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local SetUIBloxToast = NotificationModalsManager.SetUIBloxToast

local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local SettingsRoute = LinkingProtocol.Enums.SettingsRoute

local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatLongPressContinuousDictation = SharedFlags.FFlagExpChatLongPressContinuousDictation

local fFlagExpChatContinuousDictation = SharedFlags.FFlagExpChatContinuousDictation
	or FFlagExpChatLongPressContinuousDictation

local FFlagExpChatDictationVoiceTypingModeSetting = SharedFlags.FFlagExpChatDictationVoiceTypingModeSetting
local FFlagExpChatDictationContinuousSafetyReminder = SharedFlags.FFlagExpChatDictationContinuousSafetyReminder
local FFlagExpChatDictationStopOnSafetyIntervention = SharedFlags.FFlagExpChatDictationStopOnSafetyIntervention
local FFlagEnableRetryForLinkingProtocolFetch = SharedFlags.FFlagEnableRetryForLinkingProtocolFetch
local FIntLinkingProtocolFetchRetries = SharedFlags.FIntLinkingProtocolFetchRetries
local FIntLinkingProtocolFetchTimeoutMS = SharedFlags.FIntLinkingProtocolFetchTimeoutMS
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDictationFTUX = require(ExpChat.Flags.FFlagExpChatDictationFTUX)
local FFlagExpChatDictationU13PolicyToast = require(ExpChat.Flags.FFlagExpChatDictationU13PolicyToast)
local FFlagExpChatDictationMicToastFix = require(ExpChat.Flags.FFlagExpChatDictationMicToastFix)
local FFlagExpChatDictationStopOnRateLimit = require(ExpChat.Flags.FFlagExpChatDictationStopOnRateLimit)
local defineFastFlag = game:DefineFastFlag("ExpChatDictationMicToastAnalytics", false)

local v = {
	"CoreScripts.TextChat.ChatWindow.TranscriptionNoMicAccessToastBody",
	"CoreScripts.TextChat.ChatWindow.TranscriptionNoMicAccessToastBodyAlternate"
}

local noMicAccessToastBody = v[game:DefineFastInt("ExpChatDictationNoMicAccessToastBodyKeyIndex", 1)] or v[1]

local engineFeature = FFlagExpChatDictationMicToastFix and game:GetEngineFeature("LinkingResumeOnDataModelThread")

local Localization = require(ExpChat.Localization)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetDictationModeSettingStore = require(ExpChat.Stores.GetDictationModeSettingStore)
local experienceChatInterventionShownSignal = require(parent.InterventionShared.experienceChatInterventionShownSignal)

local parentModule = require(script.Parent)
local DictationMode = require(script.Parent.DictationMode)
local DictationAnalytics = require(script.Parent.DictationAnalytics)
local DictationRateLimit = require(script.Parent.DictationRateLimit)
local useDictationFTUX = require(script.Parent.useDictationFTUX)
local useDictationTelemetry = require(script.Parent.useDictationTelemetry)
local useTranscribedSamples = require(script.Parent.useTranscribedSamples)
local useDictationEligibility = require(script.Parent.useDictationEligibility)
local useIsLocalUserUnder13 = require(script.Parent.useIsLocalUserUnder13)
local useLongPress = require(script.Parent.Parent.useLongPress)
local U13PolicyToastStorage = require(script.Parent.U13PolicyToastStorage)
local DictationSafetyReminder = require(script.Parent.DictationSafetyReminder)
local requestMicPermission = require(script.Parent.requestMicPermission)
local permissionStatus = requestMicPermission.PermissionStatus

local dictationState = parentModule.DictationState
local dictationErrorReason = parentModule.DictationErrorReason
local useDictation = parentModule.useDictation

local function getTapDictationMode() -- 1 equivalent call inferred from this helper
	if FFlagExpChatLongPressContinuousDictation then
		return DictationMode.Standard
	end

	if fFlagExpChatContinuousDictation then
		return DictationMode.Continuous
	end

	return DictationMode.Standard
end

local function getLongPressDictationMode()
	if FFlagExpChatDictationVoiceTypingModeSetting then
		return nil
	end

	if FFlagExpChatLongPressContinuousDictation then
		return DictationMode.Continuous
	end

	return nil
end

local function getSystemMessageChannelName(targetTextChannel, isGlobalChatTabActive: boolean?) -- 1 equivalent call inferred from this helper
	if GetFFlagTextChatEnableUniverseChatTabs() and isGlobalChatTabActive then
		return "RBXGlobal"
	end

	if targetTextChannel then
		return targetTextChannel.Name
	end

	return "RBXGeneral"
end

local function useDictationInputBar(data)
	local v2 = Foundation.Hooks.useTokens()

	local micCursor = Foundation.Hooks.useCursor({
		radius = UDim.new(0, v2.Radius.Circle),
		offset = v2.Size.Size_150,
		borderWidth = v2.Stroke.Thicker
	})

	local ref = React.useRef(false)

	local ref2 = React.useRef(nil)
	local ref3

	if FFlagExpChatDictationFTUX then
		ref3 = React.useRef(nil)
	else
		ref3 = nil
	end

	local ref4

	if FFlagExpChatDictationFTUX then
		ref4 = React.useRef(false)
	else
		ref4 = nil
	end

	local v3 = useDictationTelemetry()
	local ref5

	if defineFastFlag then
		ref5 = React.useRef(nil)
	else
		ref5 = nil
	end

	local onActivated2

	if defineFastFlag then
		onActivated2 = React.useCallback(function()
			v3.logMicToastActivated(ref5.current, false)
		end, { v3.logMicToastActivated })
	else
		onActivated2 = nil
	end

	local v4 = useDictationEligibility()
	local v5 = useIsLocalUserUnder13()
	local ref6 = React.useRef(U13PolicyToastStorage.hasBeenShown())

	local v6 = useAsync(function()
		if not engineFeature then
			return false
		end

		if not FFlagEnableRetryForLinkingProtocolFetch then
			local v6, v7 = default:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()
			return v6 and v7 == true
		end

		local v6 = false
		local v7 = nil

		for _ = 0, FIntLinkingProtocolFetchRetries do
			local thread = task.spawn(function()
				v6, v7 = default:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()
			end)
			task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)

			if coroutine.status(thread) ~= "dead" then
				task.cancel(thread)
			end

			if v7 ~= nil then
				break
			end
		end

		return v6 and v7 == true
	end, {})

	local v7 = Localization.useLocalization({
		transcriptionFailedText = "CoreScripts.TextChat.ChatWindow.TranscriptionFailed",
		transcriptionLanguageUnsupportedText = "CoreScripts.TextChat.ChatWindow.TranscriptionLanguageUnsupported",
		noMicAccessToastHeader = "CoreScripts.TextChat.ChatWindow.TranscriptionNoMicAccessToastHeader",
		noMicAccessToastBody = noMicAccessToastBody,
		u13PolicyToastHeader = "CoreScripts.TextChat.ChatWindow.DictationU13PolicyToastHeader",
		u13PolicyToastBody = "CoreScripts.TextChat.ChatWindow.DictationU13PolicyToastBody",
		u13MicAccessToastHeader = "CoreScripts.TextChat.ChatWindow.TranscriptionU13MicAccessToastHeader",
		u13MicAccessToastBody = "CoreScripts.TextChat.ChatWindow.TranscriptionU13MicAccessToastBody"
	})

	local v8 = (not v7.transcriptionFailedText or v7.transcriptionFailedText == "")
		and "Sorry did not get that! Try to speak again."
		or v7.transcriptionFailedText

	local v9 = (not v7.transcriptionLanguageUnsupportedText or v7.transcriptionLanguageUnsupportedText == "")
		and "Sorry, that language isn't supported yet."
		or v7.transcriptionLanguageUnsupportedText

	local toastTitle = (not v7.noMicAccessToastHeader or v7.noMicAccessToastHeader == "")
		and "Microphone access needed"
		or v7.noMicAccessToastHeader

	local toastSubtitle = (not v7.noMicAccessToastBody or v7.noMicAccessToastBody == "")
		and "Enable microphone access in your device settings to use voice input."
		or v7.noMicAccessToastBody

	local toastTitle2 = (not v7.u13PolicyToastHeader or v7.u13PolicyToastHeader == "")
		and "You've enabled voice to text chat"
		or v7.u13PolicyToastHeader

	local toastSubtitle2 = (not v7.u13PolicyToastBody or v7.u13PolicyToastBody == "")
		and "To send messages with your voice, we'll process your audio and delete it right away, per our privacy policy."
		or v7.u13PolicyToastBody

	local toastTitle3 = (not v7.u13MicAccessToastHeader or v7.u13MicAccessToastHeader == "") and "Microphone enabled"
		or v7.u13MicAccessToastHeader

	local toastSubtitle3 = (not v7.u13MicAccessToastBody or v7.u13MicAccessToastBody == "")
		and "Your voice is converted to text and never shared with other players."
		or v7.u13MicAccessToastBody

	local v10 = React.useCallback(function(text: string): boolean
		local current

		if data.customTextBoxRef.current then
			current = data.customTextBoxRef.current
		else
			current = data.textBoxRef.current
		end

		if current == nil then
			return false
		end

		current.Text = text
		data.setInputText(text)
		return true
	end, {
		data.setInputText,
		data.customTextBoxRef,
		data.textBoxRef,
		data.chatInputBarSettings.TextBox
	})

	local v11 = React.useCallback(function(p: string)
		local systemMessageChannelName = getSystemMessageChannelName(data.targetTextChannel, data.isGlobalChatTabActive) -- inferred equivalent call
		GetMessagesStore(false).addSystemMessage(p, systemMessageChannelName, "Roblox.Dictation.Error", nil, true)
	end, { data.targetTextChannel, data.isGlobalChatTabActive })

	local onError = React.useCallback(function(current, p)
		ref.current = false

		if p == dictationErrorReason.PermissionDenied then
			local v12 = {
				toastTitle = toastTitle,
				toastSubtitle = toastSubtitle,
				sequenceNumber = 0,
				onActivated = 0
			}
			local sequenceNumber

			if engineFeature then
				sequenceNumber = DateTime.now().UnixTimestamp
			end

			v12.sequenceNumber = sequenceNumber
			v12.onActivated = engineFeature and v6.status == "ok" and v6.value and function()
				default:switchToSettingsApp(SettingsRoute.Microphone)
			end or nil

			if defineFastFlag then
				local onActivated = v12.onActivated
				ref5.current = current

				if onActivated then
					function v12.onActivated()
						v3.logMicToastActivated(current, true)
						onActivated()
					end
				else
					v12.onActivated = onActivated2
				end

				function v12.onAppeared()
					v3.logMicToastShown(current, onActivated ~= nil)
				end

				local flag = false
				function v12.onTouchSwipeUp()
					if flag then
						return
					end

					flag = true
					v3.logMicToastDismissed(current, DictationAnalytics.DismissReasons.UserInteraction)
				end
			end

			SetUIBloxToast(v12)
		else
			v3.logTranscriptionFailed(current)

			if p == dictationErrorReason.LanguageUnsupported then
				v11(v9)
			else
				v11(v8)
			end
		end
	end, {
		v11,
		v8,
		v9,
		toastTitle,
		toastSubtitle,
		v6,
		v3.logTranscriptionFailed,
		table.unpack(defineFastFlag and {
			v3.logMicToastShown,
			v3.logMicToastActivated,
			v3.logMicToastDismissed,
			onActivated2
		} or {})
	})

	local v12 = useTranscribedSamples()

	local ref7 = React.useRef(nil)

	local onWaveformSample = React.useCallback(function(current: number, _: number)
		ref7.current = current
	end, {})

	local onSpeechStarted = React.useCallback(function(p)
		if p ~= DictationMode.Continuous then
			return
		end

		if ref7.current ~= nil then
			v12.begin(ref7.current)
		end

		v3.logSpeechStarted()
	end, { v12, v3.logSpeechStarted })

	local onTranscription = React.useCallback(function(p: string, p2)
		if p2 == DictationMode.Continuous then
			if ref7.current ~= nil then
				v12.commit(ref7.current)
			end

			local v13 = v10(p)
			v3.logTranscription(p, p2, v13)

			if v13 then
				if FFlagExpChatDictationContinuousSafetyReminder then
					DictationSafetyReminder.trackContinuousSend(p)
				end

				data.onSendRecordingTap({
					mode = DictationAnalytics.Modes.Continuous,
					outcome = DictationAnalytics.Outcomes.Full,
					textStt = p,
					textSent = p
				})
			end
		else
			if not ref.current and data.onTranscriptionStaged ~= nil then
				data.onTranscriptionStaged(p, DictationAnalytics.Modes.Standard)
			end

			local v13 = v10(p)
			v3.logTranscription(p, p2, v13)

			if v13 and ref.current then
				ref.current = false
				data.onSendRecordingTap({
					mode = DictationAnalytics.Modes.Standard,
					outcome = DictationAnalytics.Outcomes.Full,
					textStt = p,
					textSent = p
				})
			end
		end
	end, { v10, data.onSendRecordingTap, data.onTranscriptionStaged, v12, v3.logTranscription })

	local onActivityChanged = React.useCallback(function(flag: boolean)
		if flag then
			if FFlagExpChatDictationFTUX and ref3.current and ref4.current then
				ref4.current = false
				ref3.current.markUsed()
			end

			if FFlagExpChatDictationU13PolicyToast and v5 and not ref6.current then
				ref6.current = true
				U13PolicyToastStorage.markShown()
				SetUIBloxToast({
					toastTitle = toastTitle2,
					toastSubtitle = toastSubtitle2,
					duration = 5,
					onActivated = function() end
				})
			end
		else
			ref7.current = nil
			v12.reset()
		end

		local onDictationActivityChanged = data.onDictationActivityChanged

		if onDictationActivityChanged ~= nil then
			onDictationActivityChanged(flag)
		end
	end, { v5, data.onDictationActivityChanged, v12, toastSubtitle2, toastTitle2 })

	local ref8 = React.useRef(false)
	local onPermissionResolved = React.useCallback(function(p, p2)
		v3.logPermissionResolved(p2, p)

		if not FFlagExpChatDictationU13PolicyToast or p ~= permissionStatus.Granted or ref8.current or not v5 then
			return
		end

		ref8.current = true

		ref6.current = true
		SetUIBloxToast({ toastTitle = toastTitle3, toastSubtitle = toastSubtitle3 })
	end, { v3.logPermissionResolved, v5, toastTitle3, toastSubtitle3 })

	local dictation = useDictation({
		onTranscription = onTranscription,
		onSpeechStarted = onSpeechStarted,
		onActivityChanged = onActivityChanged,
		onStateChanged = data.onDictationStateChanged,
		onPermissionResolved = onPermissionResolved,
		onRecordingStart = v3.logRecordingStart,
		onRecordingStop = v3.logRecordingStop,
		onError = onError
	})

	local state = SignalsReact.useSignalState(dictation.getDictationState)
	local isRecording = state == dictationState.Recording
	local isTranscribing = state == dictationState.Transcribing
	local isListening = state == dictationState.Listening

	local startDictation = dictation.startDictation
	local stopDictation = dictation.stopDictation

	if FFlagExpChatDictationStopOnSafetyIntervention then
		React.useEffect(function()
			local connection = experienceChatInterventionShownSignal:connect(function()
				if
					FFlagExpChatDictationExplicitFinish
					or dictation.getDictationState(false) == dictationState.Listening
				then
					stopDictation(DictationAnalytics.TriggerTypes.SafetyIntervention)
				end
			end)
			return function()
				connection:disconnect()
			end
		end, { dictation.getDictationState, stopDictation })
	end

	if FFlagExpChatDictationStopOnRateLimit then
		React.useEffect(function()
			local stopRequestedConnection = DictationRateLimit.stopRequested:connect(function()
				if dictation.getDictationState(false) == dictationState.Listening then
					stopDictation(DictationAnalytics.TriggerTypes.RateLimited)
				end
			end)
			return function()
				stopRequestedConnection:disconnect()
			end
		end, { dictation.getDictationState, stopDictation })
	end

	local tapDictationMode = getTapDictationMode() -- inferred equivalent call

	if FFlagExpChatDictationVoiceTypingModeSetting then
		tapDictationMode = SignalsReact.useSignalState(GetDictationModeSettingStore(false).getMode)
	end

	local continuous

	if not (FFlagExpChatDictationVoiceTypingModeSetting or not FFlagExpChatLongPressContinuousDictation) then
		continuous = DictationMode.Continuous
	end

	local v13

	if
		FFlagExpChatDictationFTUX
		and FFlagExpChatLongPressContinuousDictation
		and not FFlagExpChatDictationVoiceTypingModeSetting
	then
		v13 = useDictationFTUX({
			isEligible = v4,
			isComposing = data.inputText ~= "",
			isActive = state ~= dictationState.Idle
		})
	else
		v13 = nil
	end

	if ref3 then
		ref3.current = v13
	end

	local v14 = React.useCallback(function()
		if dictation.getDictationState(false) == dictationState.Recording then
			ref.current = true
			stopDictation()
		else
			ref.current = false
			v3.logMicClick(tapDictationMode, DictationAnalytics.EntryPoints.Tap)

			if FFlagExpChatDictationFTUX and v13 and v13.shouldShow then
				v13.dismiss()
			elseif ref4 then
				ref4.current = true
			end

			startDictation(tapDictationMode)
		end
	end, {
		tapDictationMode,
		startDictation,
		stopDictation,
		v13,
		dictation.getDictationState,
		ref4,
		v3.logMicClick
	})

	local onLongPress = React.useCallback(function()
		if dictation.getDictationState(false) == dictationState.Idle then
			v3.logMicClick(DictationMode.Continuous, DictationAnalytics.EntryPoints.LongPress)

			if FFlagExpChatDictationFTUX and v13 and v13.shouldShow then
				v13.dismiss()
			end

			startDictation(DictationMode.Continuous)
		end
	end, { dictation.getDictationState, startDictation, v13, v3.logMicClick })

	if continuous ~= DictationMode.Continuous then
		onLongPress = nil
	end

	return {
		state = state,
		isRecording = isRecording,
		isTranscribing = isTranscribing,
		isListening = isListening,
		isDictationEligible = v4,
		dictation = dictation,
		onMicTap = v14,
		micGestureHandlers = useLongPress({ onLongPress = onLongPress, onTap = v14 }),
		micCursor = micCursor,
		ftux = v13,
		micButtonSlotRef = ref2,
		onWaveformSample = onWaveformSample,
		transcribedSamplesBinding = v12.binding,
		chatInputBarSettings = data.chatInputBarSettings,
		customTextBoxRef = data.customTextBoxRef,
		textBoxRef = data.textBoxRef
	}
end

return useDictationInputBar
