local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Foundation = require(ExpChatParent.Foundation)
local useDispatch = require(ExpChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useAsync = require(ExpChatParent.ReactUtils).useAsync
local SignalsReact = require(ExpChatParent.SignalsReact)
local SetUIBloxToast = require(ExpChatParent.NotificationModalsManager).SetUIBloxToast
local LinkingProtocol = require(ExpChatParent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local SettingsRoute = LinkingProtocol.Enums.SettingsRoute
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatLongPressContinuousDictation = SharedFlags.FFlagExpChatLongPressContinuousDictation
local v16 = SharedFlags.FFlagExpChatContinuousDictation or FFlagExpChatLongPressContinuousDictation
local FFlagEnableRetryForLinkingProtocolFetch = SharedFlags.FFlagEnableRetryForLinkingProtocolFetch
local FIntLinkingProtocolFetchRetries = SharedFlags.FIntLinkingProtocolFetchRetries
local FIntLinkingProtocolFetchTimeoutMS = SharedFlags.FIntLinkingProtocolFetchTimeoutMS
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDictationFTUX = require(ExpChat.Flags.FFlagExpChatDictationFTUX)
local FFlagExpChatDictationU13PolicyToast = require(ExpChat.Flags.FFlagExpChatDictationU13PolicyToast)
local FFlagExpChatDictationMicToastFix = require(ExpChat.Flags.FFlagExpChatDictationMicToastFix)
local Localization = require(ExpChat.Localization)
local UniverseChatSystemMessageAdded = require(ExpChat.Actions.UniverseChatSystemMessageAdded)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local Parent = require(script.Parent)
local DictationMode = require(script.Parent.DictationMode)
local DictationAnalytics = require(script.Parent.DictationAnalytics)
local useDictationFTUX = require(script.Parent.useDictationFTUX)
local useDictationTelemetry = require(script.Parent.useDictationTelemetry)
local useTranscribedSamples = require(script.Parent.useTranscribedSamples)
local useDictationEligibility = require(script.Parent.useDictationEligibility)
local useIsLocalUserUnder13 = require(script.Parent.useIsLocalUserUnder13)
local useLongPress = require(script.Parent.Parent.useLongPress)
local U13PolicyToastStorage = require(script.Parent.U13PolicyToastStorage)
local PermissionStatus = require(script.Parent.requestMicPermission).PermissionStatus
local DictationState = Parent.DictationState
local DictationErrorReason = Parent.DictationErrorReason
local useDictation = Parent.useDictation

local function getTapDictationMode() -- line: 88
	-- upvalues: FFlagExpChatLongPressContinuousDictation (copy), DictationMode (copy), v16 (copy)
	if FFlagExpChatLongPressContinuousDictation then
		return DictationMode.Standard
	end

	if v16 then
		return DictationMode.Continuous
	end

	return DictationMode.Standard
end
local function getLongPressDictationMode() -- line: 98
	-- upvalues: FFlagExpChatLongPressContinuousDictation (copy), DictationMode (copy)
	if FFlagExpChatLongPressContinuousDictation then
		return DictationMode.Continuous
	end

	return nil
end
local function getSystemMessageChannelName(p1, b1: boolean?) -- line: 106
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy)
	if GetFFlagTextChatEnableUniverseChatTabs() and b1 then
		return "RBXGlobal"
	end

	if p1 then
		return p1.Name
	end

	return "RBXGeneral"
end
local function useDictationInputBar(t1: {[any]: any}) -- line: 157
	-- upvalues: Foundation (copy), React (copy), FFlagExpChatDictationFTUX (copy), useDispatch (copy), useDictationTelemetry (copy), useDictationEligibility (copy), useIsLocalUserUnder13 (copy), U13PolicyToastStorage (copy), useAsync (copy), FFlagExpChatDictationMicToastFix (copy), FFlagEnableRetryForLinkingProtocolFetch (copy), FIntLinkingProtocolFetchRetries (copy), default (copy), SettingsRoute (copy), FIntLinkingProtocolFetchTimeoutMS (copy), Localization (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), UniverseChatSystemMessageAdded (copy), DictationErrorReason (copy), SetUIBloxToast (copy), useTranscribedSamples (copy), DictationMode (copy), DictationAnalytics (copy), FFlagExpChatDictationU13PolicyToast (copy), PermissionStatus (copy), useDictation (copy), SignalsReact (copy), DictationState (copy), FFlagExpChatLongPressContinuousDictation (copy), v16 (copy), useDictationFTUX (copy), useLongPress (copy)
	local v48 = Foundation.Hooks.useTokens()
	local v49 = Foundation.Hooks.useCursor({
		radius = UDim.new(0, v48.Radius.Circle),
		offset = v48.Size.Size_150,
		borderWidth = v48.Stroke.Thicker
	})
	local v50 = React.useRef(false)
	local v51 = React.useRef(nil)
	local v52 = if not FFlagExpChatDictationFTUX then nil else React.useRef(nil)
	local v53 = if not FFlagExpChatDictationFTUX then nil else React.useRef(false)
	local v54 = useDispatch()
	local v55 = useDictationTelemetry()
	local v56 = useDictationEligibility()
	local v57 = useIsLocalUserUnder13()
	local v58 = React.useRef(U13PolicyToastStorage.hasBeenShown())
	local v59 = useAsync(function() -- line: 180
		-- upvalues: FFlagExpChatDictationMicToastFix (copy), FFlagEnableRetryForLinkingProtocolFetch (copy), FIntLinkingProtocolFetchRetries (copy), default (copy), SettingsRoute (copy), FIntLinkingProtocolFetchTimeoutMS (copy)
		if not FFlagExpChatDictationMicToastFix then
			return false
		end

		if FFlagEnableRetryForLinkingProtocolFetch then
			local u93 = false
			local u94 = nil

			for _ = 0, FIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function() -- line: 188
					-- upvalues: u93 (ref), u94 (ref), default (copy), SettingsRoute (copy)
					local v118, v119 = default:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

					u93 = v118
					u94 = v119
				end)

				task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if u94 ~= nil then
					break
				end
			end

			return u93 and u94 == true
		end

		local v97, v98 = default:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

		return v97 and v98 == true
	end, {})
	local v60 = Localization.useLocalization({
		transcriptionFailedText = "CoreScripts.TextChat.ChatWindow.TranscriptionFailed",
		transcriptionLanguageUnsupportedText = "CoreScripts.TextChat.ChatWindow.TranscriptionLanguageUnsupported",
		noMicAccessToastHeader = "CoreScripts.TextChat.ChatWindow.TranscriptionNoMicAccessToastHeader",
		noMicAccessToastBody = "CoreScripts.TextChat.ChatWindow.TranscriptionNoMicAccessToastBody",
		u13PolicyToastHeader = "CoreScripts.TextChat.ChatWindow.DictationU13PolicyToastHeader",
		u13PolicyToastBody = "CoreScripts.TextChat.ChatWindow.DictationU13PolicyToastBody",
		u13MicAccessToastHeader = "CoreScripts.TextChat.ChatWindow.TranscriptionU13MicAccessToastHeader",
		u13MicAccessToastBody = "CoreScripts.TextChat.ChatWindow.TranscriptionU13MicAccessToastBody"
	})
	local v61 = (not v60.transcriptionFailedText or v60.transcriptionFailedText == "") and "Sorry did not get that! Try to speak again." or v60.transcriptionFailedText
	local v62 = (not v60.transcriptionLanguageUnsupportedText or v60.transcriptionLanguageUnsupportedText == "") and "Sorry, that language isn't supported yet." or v60.transcriptionLanguageUnsupportedText
	local v63 = (not v60.noMicAccessToastHeader or v60.noMicAccessToastHeader == "") and "Microphone access needed" or v60.noMicAccessToastHeader
	local v64 = (not v60.noMicAccessToastBody or v60.noMicAccessToastBody == "") and "Enable microphone access in your device settings to use voice input." or v60.noMicAccessToastBody
	local v65 = (not v60.u13PolicyToastHeader or v60.u13PolicyToastHeader == "") and "You've enabled voice to text chat" or v60.u13PolicyToastHeader
	local v66 = (not v60.u13PolicyToastBody or v60.u13PolicyToastBody == "") and "To send messages with your voice, we'll process your audio and delete it right away, per our privacy policy." or v60.u13PolicyToastBody
	local v67 = (not v60.u13MicAccessToastHeader or v60.u13MicAccessToastHeader == "") and "Microphone enabled" or v60.u13MicAccessToastHeader
	local v68 = (not v60.u13MicAccessToastBody or v60.u13MicAccessToastBody == "") and "Your voice is converted to text and never shared with other players." or v60.u13MicAccessToastBody
	local v69 = React.useCallback(function(s1: string) -- line: 255
		-- upvalues: t1 (copy)
		local v100 = if not t1.customTextBoxRef.current then t1.textBoxRef.current else t1.customTextBoxRef.current

		if v100 == nil then
			return false
		end

		v100.Text = s1
		t1.setInputText(s1)

		return true
	end, {
		t1.setInputText,
		t1.customTextBoxRef,
		t1.textBoxRef,
		t1.chatInputBarSettings.TextBox
	})
	local v70 = React.useCallback(function(s2: string) -- line: 279
		-- upvalues: t1 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), v54 (copy), UniverseChatSystemMessageAdded (copy)
		local targetTextChannel = t1.targetTextChannel
		local isGlobalChatTabActive = t1.isGlobalChatTabActive
		local v104 = if not GetFFlagTextChatEnableUniverseChatTabs() or not isGlobalChatTabActive then not targetTextChannel and "RBXGeneral" or targetTextChannel.Name else "RBXGlobal"

		if FFlagExpChatUseMessagesStore then
			GetMessagesStore(false).addSystemMessage(s2, v104, "Roblox.Dictation.Error", nil, true)

			return
		end

		v54(UniverseChatSystemMessageAdded(s2, v104, "Roblox.Dictation.Error", true))
	end, {
		v54,
		t1.targetTextChannel,
		t1.isGlobalChatTabActive
	})
	local v71 = React.useCallback(function(p2, p3) -- line: 296
		-- upvalues: v50 (copy), DictationErrorReason (copy), SetUIBloxToast (copy), v63 (copy), v64 (copy), FFlagExpChatDictationMicToastFix (copy), v59 (copy), default (copy), SettingsRoute (copy), v55 (copy), v70 (copy), v62 (copy), v61 (copy)
		v50.current = false

		if p3 == DictationErrorReason.PermissionDenied then
			SetUIBloxToast({
				toastTitle = v63,
				toastSubtitle = v64,
				sequenceNumber = if not FFlagExpChatDictationMicToastFix then nil else DateTime.now().UnixTimestamp,
				onActivated = if not FFlagExpChatDictationMicToastFix or (v59.status ~= "ok" or not v59.value) then nil else function() -- line: 311
					-- upvalues: default (copy), SettingsRoute (copy)
					default:switchToSettingsApp(SettingsRoute.Microphone)
				end
			})

			return
		end

		v55.logTranscriptionFailed(p2)

		if p3 == DictationErrorReason.LanguageUnsupported then
			v70(v62)

			return
		end

		v70(v61)
	end, {
		v70,
		v61,
		v62,
		v63,
		v64,
		v59,
		v55.logTranscriptionFailed
	})
	local v72 = useTranscribedSamples()
	local v73 = React.useRef(nil)
	local v74 = React.useCallback(function(n1: number, _: number) -- line: 345
		-- upvalues: v73 (copy)
		v73.current = n1
	end, {})
	local v75 = React.useCallback(function(p4) -- line: 349
		-- upvalues: DictationMode (copy), v73 (copy), v72 (copy), v55 (copy)
		if p4 ~= DictationMode.Continuous then
			return
		end

		if v73.current ~= nil then
			v72.begin(v73.current)
		end

		v55.logSpeechStarted()
	end, {
		v72,
		v55.logSpeechStarted
	})
	local v76 = React.useCallback(function(s3: string, p5) -- line: 362
		-- upvalues: DictationMode (copy), v73 (copy), v72 (copy), v69 (copy), v55 (copy), t1 (copy), DictationAnalytics (copy), v50 (copy)
		if p5 == DictationMode.Continuous then
			if v73.current ~= nil then
				v72.commit(v73.current)
			end

			local v112 = v69(s3)

			v55.logTranscription(s3, p5, v112)

			if v112 then
				t1.onSendRecordingTap({
					mode = DictationAnalytics.Modes.Continuous,
					outcome = DictationAnalytics.Outcomes.Full,
					textStt = s3,
					textSent = s3
				})
			end

			return
		end

		if not v50.current and t1.onTranscriptionStaged ~= nil then
			t1.onTranscriptionStaged(s3, DictationAnalytics.Modes.Standard)
		end

		local v113 = v69(s3)

		v55.logTranscription(s3, p5, v113)

		if v113 and v50.current then
			v50.current = false
			t1.onSendRecordingTap({
				mode = DictationAnalytics.Modes.Standard,
				outcome = DictationAnalytics.Outcomes.Full,
				textStt = s3,
				textSent = s3
			})
		end
	end, {
		v69,
		t1.onSendRecordingTap,
		t1.onTranscriptionStaged,
		v72,
		v55.logTranscription
	})
	local v77 = React.useCallback(function(b2: boolean) -- line: 410
		-- upvalues: FFlagExpChatDictationFTUX (copy), v52 (copy), v53 (copy), FFlagExpChatDictationU13PolicyToast (copy), v57 (copy), v58 (copy), U13PolicyToastStorage (copy), SetUIBloxToast (copy), v65 (copy), v66 (copy), v73 (copy), v72 (copy), t1 (copy)
		if b2 then
			if FFlagExpChatDictationFTUX and v52.current and v53.current then
				v53.current = false
				v52.current.markUsed()
			end

			if FFlagExpChatDictationU13PolicyToast and v57 and not v58.current then
				v58.current = true
				U13PolicyToastStorage.markShown()
				SetUIBloxToast({
					duration = 5,
					toastTitle = v65,
					toastSubtitle = v66,
					onActivated = function() -- line: 427
					end
				})
			end
		else
			v73.current = nil
			v72.reset()
		end

		local onDictationActivityChanged = t1.onDictationActivityChanged

		if onDictationActivityChanged ~= nil then
			onDictationActivityChanged(b2)
		end
	end, {
		v57,
		t1.onDictationActivityChanged,
		v72,
		v66,
		v65
	})
	local v78 = React.useRef(false)
	local v79 = React.useCallback(function(p6, p7) -- line: 454
		-- upvalues: v55 (copy), FFlagExpChatDictationU13PolicyToast (copy), PermissionStatus (copy), v78 (copy), v57 (copy), v58 (copy), SetUIBloxToast (copy), v67 (copy), v68 (copy)
		v55.logPermissionResolved(p7, p6)

		if not FFlagExpChatDictationU13PolicyToast or (p6 ~= PermissionStatus.Granted or v78.current or not v57) then
			return
		end

		v78.current = true
		v58.current = true
		SetUIBloxToast({
			toastTitle = v67,
			toastSubtitle = v68
		})
	end, {
		v55.logPermissionResolved,
		v57,
		v67,
		v68
	})
	local v80 = useDictation({
		onTranscription = v76,
		onSpeechStarted = v75,
		onActivityChanged = v77,
		onPermissionResolved = v79,
		onRecordingStart = v55.logRecordingStart,
		onRecordingStop = v55.logRecordingStop,
		onError = v71
	})
	local v81 = SignalsReact.useSignalState(v80.getDictationState)
	local v82 = v81 == DictationState.Recording
	local v83 = v81 == DictationState.Transcribing
	local v84 = v81 == DictationState.Listening
	local startDictation = v80.startDictation
	local stopDictation = v80.stopDictation
	local v87 = if not FFlagExpChatLongPressContinuousDictation then if not v16 then DictationMode.Standard else DictationMode.Continuous else DictationMode.Standard
	local v88 = if not FFlagExpChatLongPressContinuousDictation then nil else DictationMode.Continuous
	local v89 = if not FFlagExpChatDictationFTUX or not FFlagExpChatLongPressContinuousDictation then nil else useDictationFTUX({
		isEligible = v56,
		isComposing = t1.inputText ~= "",
		isActive = v81 ~= DictationState.Idle
	})

	if v52 then
		v52.current = v89
	end

	local v90 = React.useCallback(function() -- line: 524
		-- upvalues: v80 (copy), DictationState (copy), v50 (copy), stopDictation (copy), v55 (copy), v87 (copy), DictationAnalytics (copy), FFlagExpChatDictationFTUX (copy), v89 (copy), v53 (copy), startDictation (copy)
		if v80.getDictationState(false) == DictationState.Recording then
			v50.current = true
			stopDictation()

			return
		end

		v50.current = false
		v55.logMicClick(v87, DictationAnalytics.EntryPoints.Tap)

		if FFlagExpChatDictationFTUX and v89 and v89.shouldShow then
			v89.dismiss()
		elseif v53 then
			v53.current = true
		end

		startDictation(v87)
	end, {
		v87,
		startDictation,
		stopDictation,
		v89,
		v80.getDictationState,
		v53,
		v55.logMicClick
	})
	local v91 = React.useCallback(function() -- line: 561
		-- upvalues: v80 (copy), DictationState (copy), v55 (copy), DictationMode (copy), DictationAnalytics (copy), FFlagExpChatDictationFTUX (copy), v89 (copy), startDictation (copy)
		if v80.getDictationState(false) == DictationState.Idle then
			v55.logMicClick(DictationMode.Continuous, DictationAnalytics.EntryPoints.LongPress)

			if FFlagExpChatDictationFTUX and v89 and v89.shouldShow then
				v89.dismiss()
			end

			startDictation(DictationMode.Continuous)
		end
	end, {
		v80.getDictationState,
		startDictation,
		v89,
		v55.logMicClick
	})
	local v92 = useLongPress({
		onLongPress = if v88 ~= DictationMode.Continuous then nil else v91,
		onTap = v90
	})

	return {
		state = v81,
		isRecording = v82,
		isTranscribing = v83,
		isListening = v84,
		isDictationEligible = v56,
		dictation = v80,
		onMicTap = v90,
		micGestureHandlers = v92,
		micCursor = v49,
		ftux = v89,
		micButtonSlotRef = v51,
		onWaveformSample = v74,
		transcribedSamplesBinding = v72.binding,
		chatInputBarSettings = t1.chatInputBarSettings,
		customTextBoxRef = t1.customTextBoxRef,
		textBoxRef = t1.textBoxRef
	}
end

return useDictationInputBar
