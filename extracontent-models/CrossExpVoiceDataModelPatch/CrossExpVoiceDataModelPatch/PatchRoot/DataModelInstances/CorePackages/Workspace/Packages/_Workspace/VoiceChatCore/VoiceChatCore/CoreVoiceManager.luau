local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local SoundService = game:GetService("SoundService")
local VoiceChatService = game:GetService("VoiceChatService")
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local AppStorageService = game:GetService("AppStorageService")
local NotificationService = game:GetService("NotificationService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IXPServiceWrapper = require(scriptParentParent.IXPServiceWrapper).IXPServiceWrapper
local Players2 = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local AdService = game:GetService("AdService")
local Chat = game:GetService("Chat")
local Constants = require(script.Parent.Constants)
local Utils = require(script.Parent.Utils)
local Flags = script.Parent.Flags
local Analytics = require(script.Parent.Analytics)
local Requests = script.Parent.Requests
local Promise = require(scriptParentParent.Promise)
local Cryo = require(scriptParentParent.Cryo)
local default = require(scriptParentParent.CallProtocol).CallProtocol.default
local Enums = require(scriptParentParent.CallProtocol).Enums
local PermissionsProtocol = require(scriptParentParent.PermissionsProtocol).PermissionsProtocol
local BlockingUtility = require(scriptParentParent.BlockingUtility)
local CoreGui = game:GetService("CoreGui")
local v31 = require(scriptParentParent.CoreScriptsInitializer).CoreLogger:new(script.Name)
local v32 = require(Flags.GetFFlagUpdateDeviceInputPlayerChanged)()
local v33 = game:DefineFastFlag("StringKeyFixForParticipantsTable", false)
local v34 = game:DefineFastFlag("ShowJoinVoiceRaceConditionFix", false)
local v35 = game:DefineFastFlag("ConsoleVoiceIXPEnabled", false)
local FFlagExpChatDictation = require(scriptParentParent.SharedFlags).FFlagExpChatDictation
local v37 = game:DefineFastString("ConsoleVoiceIXPLayerName", "User.Communication.ConsoleVoice")
local v38 = game:DefineFastString("ConsoleVoiceEnabledIXPLayerValue", "ConsoleVoiceEnabled")
local v39 = game:DefineFastFlag("TalkingChangedWithDebounceV2", false)
local v40 = game:DefineFastInt("TalkingChangedDebounceTime", 300)
local v41 = game:DefineFastFlag("SendVoiceCapturedDuringVideoCaptureEvent", false)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = require(scriptParentParent.SharedFlags).GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local GetFFlagLuaConsumePlayerModerated = require(Flags.GetFFlagLuaConsumePlayerModerated)
local GetFFlagLocalMutedNilFix = require(scriptParentParent.SharedFlags).GetFFlagLocalMutedNilFix
local GetFFlagEnableVoiceReverseNudge = require(Flags.GetFFlagEnableVoiceReverseNudge)
local GetFFlagClearUserFromRecentVoiceDataOnLeave = require(Flags.GetFFlagClearUserFromRecentVoiceDataOnLeave)
local GetFIntVoiceUsersInteractionExpiryTimeSeconds = require(Flags.GetFIntVoiceUsersInteractionExpiryTimeSeconds)
local GetFFlagAvatarChatServiceEnabled = require(scriptParentParent.SharedFlags).GetFFlagAvatarChatServiceEnabled
local GetFFlagVoiceChatServiceManagerUseAvatarChat = require(Flags.GetFFlagVoiceChatServiceManagerUseAvatarChat)
local GetFFlagJoinWithoutMicPermissions = require(scriptParentParent.SharedFlags).GetFFlagJoinWithoutMicPermissions
local GetFFlagBatchVoiceParticipantsUpdates = require(Flags.GetFFlagBatchVoiceParticipantsUpdates)
local GetFIntThrottleParticipantsUpdateMs = require(Flags.GetFIntThrottleParticipantsUpdateMs)
local GetFFlagSeamlessVoiceFTUX = require(scriptParentParent.SharedFlags).GetFFlagSeamlessVoiceFTUX
local GetFFlagNonVoiceFTUX = require(scriptParentParent.SharedFlags).GetFFlagNonVoiceFTUX
local GetFFlagEnableFtuxExitOnMuteToggle = require(Flags.GetFFlagEnableFtuxExitOnMuteToggle)
local GetFFlagEnableExpJoinMicPermAnalytics = require(Flags.GetFFlagEnableExpJoinMicPermAnalytics)
local GetFFlagEnableSeamlessVoiceFeature = require(Flags.GetFFlagEnableSeamlessVoiceFeature)
local GetFFlagFixGetPlayerByUserIdStringCast = require(Flags.GetFFlagFixGetPlayerByUserIdStringCast)
local v59 = require(scriptParentParent.SharedFlags).GetFFlagDebugShowAudioDeviceInputDebugger()
local v60 = game:DefineFastString("VoicePerformanceThrottlingIXPLayerName", "Voice.Performance")
local v61 = game:DefineFastString("ThrottleParticipantsUpdateIXPLayerValue", "ThrottleParticipantsUpdate")
local v62 = game:DefineFastFlag("UseAudioAnalyzerForLocalMetering2", false)
local v63 = game:DefineFastFlag("StopModerationConnectionOnLeave", false)
local v64 = game:DefineFastFlag("DeactivateAudioDeviceOnVoiceLeave", false)
local v65 = game:DefineFastFlag("DisableRejoinGroupIdDoubleRead", false)
local EngineFeature = game:GetEngineFeature("VoiceVolumeControlsApplyGameSettingsVoiceVolume")
local v67 = game:DefineFastFlag("VoiceVolumeControlsEnableVoiceVolumeEligibilityTelemetry", false)
local v68 = require(Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry)()
local VoiceVolumeControlsEligibility = require(scriptParent.VoiceVolumeControlsEligibility)
local EngineFeature2 = game:GetEngineFeature("EnableMutedByLocalUser")
local v71 = game:DefineFastFlag("VoiceChatMuteAllSyncMutedPlayers", false)
local EngineFeature3 = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFFlagEnableVoiceChatMuteForVideoCaptures = require(scriptParentParent.SharedFlags).GetFFlagEnableVoiceChatMuteForVideoCaptures
local v74 = v41 and GetFFlagEnableVoiceChatMuteForVideoCaptures()
local GetFFlagEnableVoiceSignal = require(scriptParentParent.SharedFlags).GetFFlagEnableVoiceSignal
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = require(scriptParentParent.SharedFlags).GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints
local GetFFlagVoiceChatClientRewriteMasterLua = require(scriptParentParent.SharedFlags).GetFFlagVoiceChatClientRewriteMasterLua
local GetFFlagCheckUniversePlaceBeforeSuspending = require(scriptParentParent.SharedFlags).GetFFlagCheckUniversePlaceBeforeSuspending
local GetFFlagEnableSeamlessVoiceV2 = require(scriptParentParent.SharedFlags).GetFFlagEnableSeamlessVoiceV2
local GetFFlagDisconnectToastClientRewrite = require(scriptParentParent.SharedFlags).GetFFlagDisconnectToastClientRewrite
local FFlagEnablePartyVoiceChangersInLua = require(scriptParentParent.SharedFlags).FFlagEnablePartyVoiceChangersInLua
local GetFFlagEnableVoiceUxUpdates = require(scriptParentParent.SharedFlags).GetFFlagEnableVoiceUxUpdates
local WATCHED_NAMESPACES = Constants.WATCHED_NAMESPACES
local WATCHED_MESSAGE_TYPES = Constants.WATCHED_MESSAGE_TYPES
local VOICE_CHAT_AVAILABILITY = Constants.VOICE_CHAT_AVAILABILITY
local MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED = Constants.MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED
local MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY = Constants.MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY
local PERMISSION_STATE = Constants.PERMISSION_STATE
local VOICE_JOIN_PROGRESS = Constants.VOICE_JOIN_PROGRESS
local FAE_ENABLED = Constants.FAE_ENABLED
local FAE_SETTINGS_TOAST = Constants.FAE_SETTINGS_TOAST
local GetShowAgeVerificationOverlay = require(Requests.GetShowAgeVerificationOverlay)
local GetShowPhoneVerificationUpsell = require(Requests.GetShowPhoneVerificationUpsell)
local t1 = {
	eventName = "VoiceCapturedDuringVideoCapture",
	description = "Event fired when a video capture has stopped logging if voice was captured",
	links = "",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("VoiceCapturedDuringVideoCaptureThrottlingPercentage", 10000),
	lastUpdated = {
		26,
		1,
		28
	}
}
local v95 = if not GetFFlagAvatarChatServiceEnabled() then nil else game:GetService("AvatarChatService")
local v96 = if not GetFFlagEnableVoiceChatMuteForVideoCaptures() then nil else game:GetService("CaptureService")
local v97 = if not v74 then nil else game:GetService("TelemetryService")
local t2 = {
	available = nil,
	canUseServicePromise = nil,
	userEligible = false,
	participants = nil,
	localMuted = nil,
	isVoiceChangerActive = false,
	isVoiceChangerHearMyselfActive = false,
	currentVoicePack = nil,
	isTalking = false,
	previousGroupId = nil,
	muteAll = false,
	previousMutedState = nil,
	permissionPromise = nil,
	hasOptedToJoinVoiceOnAgeVerification = false,
	permissionState = if not GetFFlagJoinWithoutMicPermissions() then nil else PERMISSION_STATE.IDLE,
	recentUsersInteractionData = nil,
	NotificationService = NotificationService,
	PermissionsService = PermissionsProtocol.default,
	ChatService = Chat,
	voiceEnabled = false,
	service = nil,
	SignalREventTable = {},
	isInCall = false,
	callMutedState = false,
	audioDeviceInputAdded = nil,
	muteChanged = Instance.new("BindableEvent"),
	voiceChangerChanged = Instance.new("BindableEvent"),
	voiceChangerHearMyselfChanged = Instance.new("BindableEvent"),
	muteAllChanged = Instance.new("BindableEvent"),
	participantLeft = Instance.new("BindableEvent"),
	participantJoined = Instance.new("BindableEvent"),
	participantsUpdate = Instance.new("BindableEvent"),
	talkingChanged = Instance.new("BindableEvent"),
	_lastTalkingChangedFireTime = 0,
	_lastTalkingChangedFireValue = nil,
	attemptVoiceRejoin = Instance.new("BindableEvent"),
	onPlayerMuteToggled = Instance.new("BindableEvent"),
	setVoiceUIVisibility = Instance.new("BindableEvent"),
	communicationPermissionsResult = nil,
	VoiceJoinProgress = VOICE_JOIN_PROGRESS.Idle,
	VoiceJoinProgressChanged = Instance.new("BindableEvent"),
	_voiceVolumeEligibilityReported = false,
	mutedPlayers = {},
	voiceChangerActivePlayers = {},
	BlockStatusChanged = nil,
	AvatarChatService = v95,
	HttpRbxApiService = HttpRbxApiService,
	ThirdPartyUserService = ThirdPartyUserService,
	CaptureService = v96,
	TelemetryService = v97,
	SendMuteEvent = nil,
	SetVoicePackEvent = nil,
	VoiceChangerWasToggledEvent = nil,
	InputToModifierWire = nil,
	PartyVoiceDeviceInput = nil,
	_mutedAnyone = false,
	canUseServiceResult = nil,
	signalRConnectionChanged = nil,
	signalRConnection = nil,
	AdService = AdService,
	isPlayerWatchingAd = false,
	options = {
		allowSeamlessVoice = true,
		passInitErrorInPromiseReject = false,
		forceVoiceEnabled = false
	},
	initializedPostSuspension = false,
	voiceCapturedDuringVideoCapture = false,
	_voiceJoinTimestampMs = nil,
	_voiceVolumeSliderEligibleAtJoin = false,
	_gameSettingsOpenedTimestampMs = nil
}

t2.__index = t2

function t2.new(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) -- line: 312
	-- upvalues: Utils (copy), Analytics (copy), AppStorageService (copy), t2 (copy), WATCHED_MESSAGE_TYPES (copy), GetFIntThrottleParticipantsUpdateMs (copy), Players2 (copy), v31 (copy), IXPServiceWrapper (copy), v60 (copy), v61 (copy)
	local v116 = setmetatable({
		previousSessionId = nil,
		HttpRbxApiService = p3,
		eventEmitter = Utils.EventEmitter.new(),
		service = p4,
		PermissionsService = p2,
		NotificationService = p6,
		AvatarChatService = p7,
		Analytics = Analytics.new(p5),
		SequenceNumbers = {},
		SignalREventTable = {},
		audioDevices = {},
		BlockStatusChanged = p1,
		AppStorageService = p8 or AppStorageService,
		ThirdPartyUserService = p9,
		CaptureService = p10,
		AdService = p11
	}, t2)

	for _, v118 in WATCHED_MESSAGE_TYPES do
		v116.SignalREventTable[v118] = Instance.new("BindableEvent")
	end

	v116.shouldThrottleParticipantUpdate = false
	v116.participantsStateThrottleTime = 0
	v116.lastParticipantsStateUpdate = 0
	v116.lastStateUpdateCounter = 0

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		task.spawn(function() -- line: 354
			-- upvalues: Players2 (copy), p4 (copy), v31 (copy), IXPServiceWrapper (copy), v60 (copy)
			local ok, result = pcall(function() -- line: 355
				-- upvalues: Players2 (copy), p4 (copy)
				if Players2.LocalPlayer then
					return p4:IsVoiceEnabledForUserIdAsync(Players2.LocalPlayer.UserId)
				end

				return false
			end)

			if not ok then
				v31:debug("Unable to get voice enabled status: ", result)

				return
			end

			if result then
				IXPServiceWrapper:LogUserLayerExposure(v60)
			end
		end)
		v116.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000

		local ok, result = pcall(function() -- line: 371
			-- upvalues: IXPServiceWrapper (copy), v60 (copy)
			return IXPServiceWrapper:GetLayerData(v60)
		end)

		if ok and result and result[v61] then
			v116.shouldThrottleParticipantUpdate = true
		end
	end

	return v116
end
function t2.emit(t3: {[any]: any}, s1: string, ...) -- line: 382
	t3.eventEmitter:emit(s1, ...)
end
function t2.subscribe(t4: {[any]: any}, s2: string, p12) -- line: 386
	t4.eventEmitter:addListener(s2, p12)
end
function t2.unsubscribe(t5: {[any]: any}, s3: string, p13) -- line: 390
	t5.eventEmitter:removeListener(s3, p13)
end
function t2.unsubscribeAll(p14) -- line: 394
	p14.eventEmitter:removeAllListeners()
end
function t2.CheckCallStateWithPromise(p15) -- line: 398
	-- upvalues: default (copy), v31 (copy), Enums (copy)
	return default:getCallState():andThen(function(p16) -- line: 400
		-- upvalues: v31 (copy), Enums (copy), p15 (copy)
		v31:trace("Got user call state")

		if p16.status ~= Enums.CallStatus.Idle.rawValue() and p16.status ~= Enums.CallStatus.Ringing.rawValue() then
			p15.isInCall = true
			p15.callMutedState = p16.muted
			v31:trace("Changing call muted state to {}", p16.muted)
		end
	end):catch(function(p17) -- line: 412
		-- upvalues: v31 (copy)
		v31:trace("User not in call {}", p17)
	end)
end
function t2.CheckCallState(p18) -- line: 418
	-- upvalues: v31 (copy), default (copy), Enums (copy)
	v31:trace("Checking user call state")

	local ok, result = pcall(function() -- line: 420
		-- upvalues: default (copy), v31 (copy), Enums (copy), p18 (copy)
		default:getCallState():andThen(function(p19) -- line: 422
			-- upvalues: v31 (copy), Enums (copy), p18 (copy)
			v31:trace("Got user call state")

			if p19.status ~= Enums.CallStatus.Idle.rawValue() and p19.status ~= Enums.CallStatus.Ringing.rawValue() then
				p18.isInCall = true
				p18.callMutedState = p19.muted
				v31:trace("Changing call muted state to {}", p19.muted)
			end
		end):catch(function(p20) -- line: 434
			-- upvalues: v31 (copy)
			v31:trace("User not in call {}", p20)
		end)
	end)

	if not ok then
		v31:debug("Error checking user call state {}", result)
	end
end
function t2._GetShowAgeVerificationOverlay(p21, p22) -- line: 453
	-- upvalues: GetShowAgeVerificationOverlay (copy), Utils (copy)
	return GetShowAgeVerificationOverlay(Utils.bind(p21, "GetRequest"), tostring(game.GameId), tostring(game.PlaceId), p22)
end
function t2.FetchAgeVerificationOverlay(p23, p24) -- line: 462
	-- upvalues: Promise (copy)
	if not p23._getShowAgeVerificationOverlayResult then
		if not p23._getShowAgeVerificationOverlayPromise then
			p23._getShowAgeVerificationOverlayPromise = Promise.new(function(resolve, _) -- line: 465
				-- upvalues: p23 (copy), p24 (copy)
				p23._getShowAgeVerificationOverlayResult = p23:_GetShowAgeVerificationOverlay(p24)
				resolve(p23._getShowAgeVerificationOverlayResult)
			end)
		end

		p23._getShowAgeVerificationOverlayPromise:await()
	end

	return p23._getShowAgeVerificationOverlayResult
end
function t2._GetShowPhoneVerificationUpsell(t6: {[any]: any}, s4: string, n1: number?) -- line: 481
	-- upvalues: GetShowPhoneVerificationUpsell (copy), Utils (copy)
	return (GetShowPhoneVerificationUpsell(Utils.bind(t6, "GetRequest"), tostring(game.GameId), s4, n1))
end
function t2.FetchPhoneVerificationUpsell(t7: {[any]: any}, s5: string, n2: number?, b1: boolean?) -- line: 494
	-- upvalues: Promise (copy), Constants (copy)
	if not t7._getShowPhoneVerificationUpsellResult then
		t7._getShowPhoneVerificationUpsellResult = {}
		t7._getShowPhoneVerificationUpsellPromise = {}
	end

	if not t7._getShowPhoneVerificationUpsellResult[s5] or b1 then
		if not t7._getShowPhoneVerificationUpsellPromise[s5] or b1 then
			t7._getShowPhoneVerificationUpsellPromise[s5] = Promise.new(function(resolve, _) -- line: 505
				-- upvalues: t7 (copy), s5 (copy), n2 (copy), Constants (copy)
				local v456 = t7:_GetShowPhoneVerificationUpsell(s5, n2)

				t7._getShowPhoneVerificationUpsellResult[s5] = if type(v456) ~= "table" or v456.valueProp == nil then Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None else v456.valueProp
				resolve()
			end)
		end

		t7._getShowPhoneVerificationUpsellPromise[s5]:await()
	end

	return t7._getShowPhoneVerificationUpsellResult[s5]
end
function t2.DisablePhoneVerificationUpsell(p27) -- line: 519
	-- upvalues: Cryo (copy), Constants (copy)
	p27._getShowPhoneVerificationUpsellResult = Cryo.Dictionary.map(p27._getShowPhoneVerificationUpsellResult, function() -- line: 522
		-- upvalues: Constants (copy)
		return Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None
	end)
end
function t2.GetNudgeAnalyticsData(p28) -- line: 528
	-- upvalues: Players (copy)
	return Players.LocalPlayer.UserId, p28:GetSessionId()
end
function t2.avatarChatUserAndPlaceSettingsValueOfClientFeatures(p29, p30) -- line: 533
	-- upvalues: GetFFlagEnableVoiceSignal (copy)
	local t8 = {
		isUniverseEnabledForVoice = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UniverseAudio),
		isPlaceEnabledForVoice = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.PlaceAudio),
		isUniverseEnabledForAvatarVideo = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UniverseVideo),
		isPlaceEnabledForAvatarVideo = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.PlaceVideo)
	}
	local t9 = {
		bannedUntil = nil,
		isUserEligible = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UserAudioEligible),
		isVoiceEnabled = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UserAudio),
		isAvatarVideoEligible = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UserVideoEligible),
		isAvatarVideoEnabled = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UserVideo),
		isUserVerifiedForVoice = if not GetFFlagEnableVoiceSignal() then nil else p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UserVerifiedForVoice),
		isBanned = p29.AvatarChatService:IsEnabled(p30, Enum.AvatarChatServiceFeature.UserBanned)
	}

	return {
		universePlaceVoiceEnabledSettings = t8,
		voiceSettings = t9
	}
end
function t2.resolveAvatarChatUserAndPlaceSettings(p31) -- line: 580
	local ok, result = pcall(p31.AvatarChatService.GetClientFeaturesAsync, p31.AvatarChatService)

	if not ok then
		return nil
	end

	return p31:avatarChatUserAndPlaceSettingsValueOfClientFeatures(result)
end
function t2.GetRequest(p32, p33, _) -- line: 590
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 591
		-- upvalues: p32 (copy), p33 (copy), HttpService (copy)
		local AsyncFullUrl = p32.HttpRbxApiService:GetAsyncFullUrl(p33, Enum.ThrottlingPriority.Default, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(AsyncFullUrl)
	end)

	return ok and result
end
function t2.PostUserVoiceConnectionStatus(p35, p36) -- line: 599
	-- upvalues: HttpService (copy), Constants (copy)
	local ok, _ = pcall(function() -- line: 600
		-- upvalues: HttpService (copy), p36 (copy), p35 (copy), Constants (copy)
		local json = HttpService:JSONEncode({
			IsUserVoiceConnected = p36
		})
		local v459 = p35.HttpRbxApiService:PostAsyncFullUrl(Constants.VOICE_URL .. "/v1/user-voice-connection-state", json)

		return HttpService:JSONDecode(v459)
	end)

	return ok
end
function t2.GetVoiceAnalyticsData(p37) -- line: 609
	-- upvalues: EngineFeature3 (copy), RbxAnalyticsService (copy)
	return {
		micAvailability = "",
		universeId = game.GameId,
		placeId = game.PlaceId,
		playSessionId = not EngineFeature3 and "" or RbxAnalyticsService:GetPlaySessionId(),
		voiceSessionId = not p37.service and "" or p37:GetSessionId()
	}
end
function t2.RecordExperienceJoinMicPermissionStatus(p38, p39) -- line: 621
	-- upvalues: PermissionsProtocol (copy), PERMISSION_STATE (copy)
	local VoiceAnalyticsData = p38:GetVoiceAnalyticsData()

	if p39 ~= nil and typeof(p39) == "table" then
		if p39.status == PermissionsProtocol.Status.AUTHORIZED then
			VoiceAnalyticsData.micAvailability = "Granted"
		else
			VoiceAnalyticsData.micAvailability = "Denied"
		end
	elseif p38.permissionState then
		if p38.permissionState == PERMISSION_STATE.LISTEN_AND_TALK then
			VoiceAnalyticsData.micAvailability = "Granted"
		else
			VoiceAnalyticsData.micAvailability = "Denied"
		end
	end

	p38.Analytics:reportVoiceEvents("experienceJoinDeviceMicPermissionEvent", VoiceAnalyticsData)
end
function t2.CheckCaptureMute(p40) -- line: 641
	-- upvalues: GetFFlagEnableVoiceChatMuteForVideoCaptures (copy)
	if GetFFlagEnableVoiceChatMuteForVideoCaptures() then
		return p40.CaptureService:IsCapturingVideo()
	end

	return false
end
function t2.ToggleMuteSome(t10: {[any]: any}, t11: {[any]: any}, b2: boolean, s6: string, s7: string) -- line: 650
	-- upvalues: VoiceChatService (copy), EngineFeature2 (copy), Players (copy)
	t10:ensureInitialized("mute some players")
	t10._mutedAnyone = true

	local t12 = {}
	local v174 = b2 or t10:CheckCaptureMute()

	for _, v176 in t11 do
		if VoiceChatService.UseNewAudioApi then
			t12[v176] = true
			t10.mutedPlayers[v176] = v174
		else
			t10.service:SubscribePause(v176, v174)
		end

		local v177 = t10.participants[tostring(v176)]

		if v177 then
			v177.isMutedLocally = v174
			t10.participantsUpdate:Fire(t10.participants)
		end
	end

	if VoiceChatService.UseNewAudioApi then
		for v178 in t10.audioDevices do
			if v178.Player and t12[v178.Player.UserId] then
				if EngineFeature2 and v178.Player ~= Players.LocalPlayer then
					v178.MutedByLocalUser = v174
				else
					if not EngineFeature2 then
					end

					v178.Active = not v174
				end
			end
		end
	end

	if s6 and s7 then
		t10.Analytics:reportVoiceMuteGroup((t10:JoinWithVoiceMuteData({
			groupType = s6,
			context = s7,
			muted = v174
		})))
	end
end
function t2.GetMutedAnyone(p41) -- line: 695
	return p41._mutedAnyone
end
function t2.RecordGameSettingsOpened(p42) -- line: 699
	-- upvalues: v68 (copy), EngineFeature (copy)
	if v68 and (EngineFeature and p42._voiceJoinTimestampMs and not p42._gameSettingsOpenedTimestampMs) then
		p42._gameSettingsOpenedTimestampMs = DateTime.now().UnixTimestampMillis
	end
end
function t2.ResetVoiceVolumeImpressionsSession(p43) -- line: 710
	-- upvalues: v68 (copy), EngineFeature (copy)
	if v68 and EngineFeature then
		p43._voiceJoinTimestampMs = nil
		p43._voiceVolumeSliderEligibleAtJoin = false
		p43._gameSettingsOpenedTimestampMs = nil
	end
end
function t2.ReportVoiceVolumeImpressionsIfNeeded(p44) -- line: 721
	-- upvalues: v68 (copy), EngineFeature (copy)
	if not v68 or (not EngineFeature or not p44._voiceJoinTimestampMs or not p44._voiceVolumeSliderEligibleAtJoin) then
		return
	end

	local v183 = p44._gameSettingsOpenedTimestampMs ~= nil
	local VoiceAnalyticsData = p44:GetVoiceAnalyticsData()

	p44.Analytics:reportVoiceVolumeImpressions({
		playSessionId = VoiceAnalyticsData.playSessionId,
		voiceSessionId = VoiceAnalyticsData.voiceSessionId,
		sliderSeen = v183,
		voiceJoinTimestampMs = p44._voiceJoinTimestampMs,
		sliderSeenTimestampMs = p44._gameSettingsOpenedTimestampMs
	})
	p44:ResetVoiceVolumeImpressionsSession()
end
function t2.ToggleMutePlayer(t13: {[any]: any}, n3: number, s8: string) -- line: 743
	-- upvalues: VoiceChatService (copy), v31 (copy), Utils (copy), GetFFlagEnableFtuxExitOnMuteToggle (copy), EngineFeature2 (copy), Players (copy)
	t13:ensureInitialized("mute player " .. n3)
	t13._mutedAnyone = true

	local v188 = ((if not VoiceChatService.UseNewAudioApi then not t13.service:IsSubscribePaused(n3) else not t13.mutedPlayers[n3])) or t13:CheckCaptureMute()

	v31:trace("Setting mute for {} to {}", Utils.shorten(n3), v188)

	if GetFFlagEnableFtuxExitOnMuteToggle() then
		t13.onPlayerMuteToggled:Fire()
	end

	if VoiceChatService.UseNewAudioApi then
		t13.mutedPlayers[n3] = v188

		for v189 in t13.audioDevices do
			if v189.Player and n3 == v189.Player.UserId then
				if EngineFeature2 and v189.Player ~= Players.LocalPlayer then
					v189.MutedByLocalUser = v188
				else
					if not EngineFeature2 then
					end

					local v190 = t13.participants[tostring(n3)]
					local v191 = v190 and not v190.isMuted

					v189.Active = not v188 and v191
				end
			end
		end

		t13:emit("OnPlayerMuted")
	else
		t13.service:SubscribePause(n3, v188)
	end

	for _, v in pairs(t13.participants) do
		if n3 == v.userId then
			v.isMutedLocally = v188
			t13.participantsUpdate:Fire(t13.participants)
		end
	end

	if s8 then
		t13.Analytics:reportVoiceMuteIndividual((t13:JoinWithVoiceMuteData({
			targetUserId = tonumber(n3),
			context = s8,
			muted = v188
		})))
	end
end
function t2.MuteAll(t14: {[any]: any}, b3: boolean, s9: string) -- line: 797
	-- upvalues: VoiceChatService (copy), v31 (copy), v71 (copy), Players (copy), EngineFeature2 (copy), Constants (copy)
	t14:ensureInitialized("mute all")
	t14._mutedAnyone = true

	local v197 = b3 or t14:CheckCaptureMute()

	if VoiceChatService.UseNewAudioApi then
		t14.muteAll = v197
		v31:trace("Setting self mute all to {} context: {}", v197, s9)

		if v71 and not v197 then
			table.clear(t14.mutedPlayers)
		end

		for v198 in t14.audioDevices do
			if v198.Player and v198.Player ~= Players.LocalPlayer then
				v31:debug("Local muting {} to '{} = {}'", v198.Player.Name, v198.Active, v197)

				if EngineFeature2 then
					v198.MutedByLocalUser = v197

					if v71 then
						t14.mutedPlayers[v198.Player.UserId] = v197
					end
				else
					local UserId = v198.Player.UserId

					t14.mutedPlayers[UserId] = v197

					local v200 = t14.participants[tostring(UserId)]
					local v201 = v200 and not v200.isMuted

					v198.Active = not v197 and v201
				end
			end
		end
	else
		t14.service:SubscribePauseAll(v197)
	end

	for _, v in pairs(t14.participants) do
		v.isMutedLocally = v197
		t14.participantsUpdate:Fire(t14.participants)
	end

	t14.muteAllChanged:Fire(v197)

	if s9 then
		t14.Analytics:reportVoiceMuteGroup((t14:JoinWithVoiceMuteData({
			groupType = Constants.VOICE_GROUP_TYPE.ALL,
			context = s9,
			muted = v197
		})))
	end
end
function t2.FetchVoicePermissions(p45) -- line: 846
	if not p45.communicationPermissionsResult then
		p45.communicationPermissionsResult = p45:resolveAvatarChatUserAndPlaceSettings()
	end

	return p45.communicationPermissionsResult
end
function t2.verifyUniverseAndPlaceCanUseVoice(p46) -- line: 854
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), Analytics (copy)
	local v206 = if not GetFFlagAvatarChatServiceEnabled() or not GetFFlagVoiceChatServiceManagerUseAvatarChat() then p46:FetchAgeVerificationOverlay() else p46:resolveAvatarChatUserAndPlaceSettings()

	if not v206 then
		p46:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	local universePlaceVoiceEnabledSettings = v206.universePlaceVoiceEnabledSettings

	return universePlaceVoiceEnabledSettings and (universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice and universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice)
end
function t2.IsUserInFTUX(p47) -- line: 874
	-- upvalues: GetFFlagSeamlessVoiceFTUX (copy), GetFFlagCheckUniversePlaceBeforeSuspending (copy), v31 (copy)
	if not GetFFlagSeamlessVoiceFTUX() then
		return false
	end

	if GetFFlagCheckUniversePlaceBeforeSuspending() and not p47:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local AppStorageService2 = game:GetService("AppStorageService")
	local u210 = nil

	if not pcall(function() -- line: 884
		-- upvalues: AppStorageService2 (copy), u210 (ref)
		u210 = AppStorageService2:GetItem("SeamlessVoiceFTUX") == "true"
	end) then
		v31:warning("Failed to read FTUX/STUX from AppStorage")

		return false
	end

	local v211 = p47:FetchAgeVerificationOverlay()

	if type(v211) == "table" and v211.voiceSettings and v211.voiceSettings.seamlessVoiceStatus ~= 3 then
		v31:debug("User not eligible for FTUX/STUX")

		return false
	end

	return not u210
end
function t2.isEnableDefaultVoiceOnForPlace(_) -- line: 907
	-- upvalues: VoiceChatService (copy)
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	return VoiceChatService.UseNewAudioApi or VoiceChatService.EnableDefaultVoice
end
function t2.verifyPlaceCanUseVoice(p49, p50, p51) -- line: 918
	-- upvalues: Analytics (copy)
	if not p50 or not p51 then
		p49:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	if not p50.isUniverseEnabledForVoice then
		p49:_reportJoinFailed("universeNotEnabled")

		return false
	end

	p49:emit("OnUserAndPlaceCanUseVoiceResolved", p51, p50)

	if not p50.isPlaceEnabledForVoice then
		p49:_reportJoinFailed("placeNotEnabled")

		return false
	end

	if not p49:isEnableDefaultVoiceOnForPlace() then
		return false
	end

	return true
end
function t2.EligibleForFaeUpsell(p52) -- line: 943
	-- upvalues: FAE_ENABLED (copy)
	local v217 = p52:FetchAgeVerificationOverlay()

	if not v217 or type(v217) ~= "table" then
		return false
	end

	local v218 = v217.inExperienceFaeUpsell == FAE_ENABLED
	local isPlaceEnabledForVoice = v217.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice

	return v218 and isPlaceEnabledForVoice
end
function t2.OptUserToJoinVoice(p53) -- line: 953
	-- upvalues: v31 (copy)
	v31:debug("Opting user to join voice on age verification")
	p53.hasOptedToJoinVoiceOnAgeVerification = true
end
function t2.SetupFAECompleteListener(p54) -- line: 958
	-- upvalues: v31 (copy)
	v31:debug("Setting up FAE complete listener")

	if game:GetEngineFeature("ChatReconcileAccess") then
		v31:debug("Using ChatService ReconcileCommunicationAccessCompleted event")
		p54.ChatService.ReconcileCommunicationAccessCompleted:Connect(function() -- line: 962
			-- upvalues: v31 (copy), p54 (copy)
			v31:debug("FAE complete listener triggered, re-fetching voice permissions")
			p54.communicationPermissionsResult = nil
			p54:FetchVoicePermissions()
			p54._getShowAgeVerificationOverlayResult = p54:_GetShowAgeVerificationOverlay()

			if p54.hasOptedToJoinVoiceOnAgeVerification then
				v31:debug("FAE complete listener triggered, attempting voice rejoin")

				if p54:IsSeamlessVoice() then
					v31:debug("Opting-in user to voice")
					p54.AvatarChatService:EnableVoice()
					p54.attemptVoiceRejoin:Fire()
				end
			end
		end)
	end
end
function t2.EligibleForAgeCheckToast(p55) -- line: 982
	-- upvalues: FAE_SETTINGS_TOAST (copy)
	local v223 = p55:FetchAgeVerificationOverlay()

	if not v223 or type(v223) ~= "table" then
		return false
	end

	local isPlaceEnabledForVoice = v223.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	local v225 = v223.inExperienceFaeUpsell == FAE_SETTINGS_TOAST

	return isPlaceEnabledForVoice and (p55:isEnableDefaultVoiceOnForPlace() and v225)
end
function t2.userAndPlaceCanUseVoice(p56) -- line: 992
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), GetShowAgeVerificationOverlay (copy), Utils (copy), Analytics (copy), v31 (copy), GetFFlagEnableVoiceSignal (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), Constants (copy), VOICE_JOIN_PROGRESS (copy), GetFFlagEnableVoiceUxUpdates (copy), GetFFlagNonVoiceFTUX (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if p56.ThirdPartyUserService ~= nil and (p56.ThirdPartyUserService:IsChatRestrictionSupported() and p56.ThirdPartyUserService:GetVoiceChatRestrictionStatus() ~= Enum.ChatRestrictionStatus.NotRestricted) then
		return false
	end

	local v227 = if not GetFFlagAvatarChatServiceEnabled() or not GetFFlagVoiceChatServiceManagerUseAvatarChat() then GetShowAgeVerificationOverlay(Utils.bind(p56, "GetRequest"), tostring(game.GameId), (tostring(game.PlaceId))) else p56:resolveAvatarChatUserAndPlaceSettings()

	if not v227 then
		p56:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	if p56.options.forceVoiceEnabled then
		v227.voiceSettings.isVoiceEnabled = true
		v31:debug("bypassing voice permissions check")
	end

	local universePlaceVoiceEnabledSettings = v227.universePlaceVoiceEnabledSettings
	local voiceSettings = v227.voiceSettings

	v31:trace("Voice settings endpoint returned {}", v227)

	if not p56:verifyPlaceCanUseVoice(universePlaceVoiceEnabledSettings, voiceSettings) then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		p56.communicationPermissionsResult = v227

		local v230 = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and os.time()
		local v231 = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and (not p56:UserVoiceEnabled() and (not voiceSettings.isUserVerifiedForVoice and (p56:FetchPhoneVerificationUpsell(Constants.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat or v230 and p56:FetchPhoneVerificationUpsell(Constants.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER, v230) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat)))

		if p56:UserEligibleForInExperienceUpsell() or v231 then
			p56:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
		end

		if GetFFlagEnableVoiceUxUpdates() then
			local VoiceConnectCookie = p56:GetVoiceConnectCookie()
			local v233 = p56:HasSeamlessVoiceFeature(Constants.SeamlessVoiceFeatures.DeferConnection) and VoiceConnectCookie == ""
			local v234 = p56:IsSeamlessVoice() and VoiceConnectCookie == "false"

			if v233 or v234 then
				p56:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif p56:EligibleForFaeUpsell() then
				v31:debug("Suspending voice join for FAE Eligible user")
				p56:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
				p56:SetupFAECompleteListener()
			end
		else
			if GetFFlagNonVoiceFTUX() and p56:IsUserInFTUX() then
				p56:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			end

			if p56:IsSeamlessVoice() and not p56:GetVoiceConnectCookieValue() then
				v31:debug("Suspending voice join due to voice connect cookie")
				p56:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif GetFFlagEnableSeamlessVoiceV2() and p56:IsNewSeamlessVoiceUserDisconnect() then
				v31:debug("Suspending voice join for new seamless voice user")
				p56:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif p56:IsSeamlessVoice() and p56:UserOnlyEligibleForVoice() then
				v31:debug("Suspending voice join for opt-out user")
				p56:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			end
		end

		task.spawn(function() -- line: 1089
			-- upvalues: p56 (copy)
			p56:FetchAgeVerificationOverlay()
		end)
	end

	if not voiceSettings.isVoiceEnabled then
		p56:_reportJoinFailed("userNotEnabled")
	end

	return voiceSettings.isVoiceEnabled
end
function t2.voicePermissionGranted(_, p58) -- line: 1104
	-- upvalues: PermissionsProtocol (copy), Cryo (copy)
	if typeof(p58) == "table" then
		return p58.status == PermissionsProtocol.Status.AUTHORIZED or not Cryo.List.find(p58.missingPermissions, PermissionsProtocol.Permissions.MICROPHONE_ACCESS)
	end

	return p58 == PermissionsProtocol.Status.AUTHORIZED
end
function t2.RawGetPermissions(p59, p60) -- line: 1124
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 1125
		-- upvalues: p59 (copy), p60 (copy)
		p59:emit("GetPermissions", function(p62) -- line: 1126
			-- upvalues: resolve (copy)
			resolve(p62)
		end, p60, true, true)
	end)
end
function t2.requestMicPermission(p63) -- line: 1133
	-- upvalues: v31 (copy), PermissionsProtocol (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), Promise (copy), GetFFlagEnableExpJoinMicPermAnalytics (copy), Analytics (copy)
	if p63.permissionPromise then
		v31:trace("PermissionProtocol already invoked")

		return p63.permissionPromise
	end

	local t15 = { PermissionsProtocol.Permissions.MICROPHONE_ACCESS }
	local v244

	if not GetFFlagEnableSeamlessVoiceV2() and GetFFlagJoinWithoutMicPermissions(p63:IsSeamlessVoice()) then
		v31:debug("Requesting device permission")

		local ok, result, v243 = pcall(function() -- line: 1147
			-- upvalues: p63 (copy), t15 (copy)
			return p63:RawGetPermissions(t15):await()
		end)

		if ok and result then
			if v243.status == PermissionsProtocol.Status.AUTHORIZED then
				p63.permissionState = PERMISSION_STATE.LISTEN_AND_TALK
			elseif v243.missingPermissions then
				p63.permissionState = PERMISSION_STATE.PENDING_MIC
			elseif v243.deniedPermissions then
				p63.permissionState = PERMISSION_STATE.LISTEN_ONLY
			else
				v31:error("PermissionsService returned unknown permission state. Defaulting to listen only.")
				p63.permissionState = PERMISSION_STATE.LISTEN_ONLY
			end
		else
			v31:error("PermissionsService call failed.")
			p63.permissionState = PERMISSION_STATE.LISTEN_ONLY
		end

		v31:debug("Joining without mic permissions. Permission State: {}", p63.permissionState)
		v244 = Promise.resolve()
	else
		v244 = p63.PermissionsService:requestPermissions(t15)
	end

	p63.permissionPromise = v244:andThen(function(p64) -- line: 1176
		-- upvalues: GetFFlagEnableExpJoinMicPermAnalytics (copy), p63 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), Promise (copy), v31 (copy), Analytics (copy), PermissionsProtocol (copy)
		if GetFFlagEnableExpJoinMicPermAnalytics() then
			p63:RecordExperienceJoinMicPermissionStatus(p64)
		end

		if not GetFFlagEnableSeamlessVoiceV2() and GetFFlagJoinWithoutMicPermissions() then
			return Promise.resolve()
		end

		if not p64 and not p64.status then
			v31:debug("No permission response, rejecting access")
			p63:_reportJoinFailed("noPermissionResponse", Analytics.ERROR)

			if p63.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_NO_PERM_RESPONSE"
				})
			end

			return Promise.reject()
		end

		v31:debug("Permission status {}", p64.status)

		local v463 = p64.status == PermissionsProtocol.Status.AUTHORIZED

		if p63.options.passInitErrorInPromiseReject and not v463 then
			return Promise.reject({
				code = "INIT_ERROR_PERM_NOT_GRANTED"
			})
		end

		return v463 and Promise.resolve() or Promise.reject()
	end):andThen(function() -- line: 1200
		-- upvalues: p63 (copy), Promise (copy)
		p63:emit("OnRequestMicPermissionResolved")

		return Promise.resolve()
	end):catch(function() -- line: 1205
		-- upvalues: p63 (copy), Promise (copy)
		p63:emit("OnRequestMicPermissionRejected")

		if p63.options.passInitErrorInPromiseReject then
			return Promise.reject({
				code = "INIT_ERROR_MIC_PERM_REJECTED"
			})
		end

		return Promise.reject()
	end)

	return p63.permissionPromise
end
function t2.JoinByGroupIdToken(p65, p66, p67) -- line: 1215
	p65.previousGroupId = p66
	p65.previousMutedState = p67

	return p65.service:JoinByGroupIdToken(p66, p67)
end
function t2.EnableVoice(p68) -- line: 1221
	-- upvalues: v31 (copy)
	v31:trace("Enabling voice")
	p68.AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Once(function() -- line: 1224
		-- upvalues: p68 (copy)
		p68.attemptVoiceRejoin:Fire()
	end)
	p68.AvatarChatService:EnableVoice()
end
function t2.ChangeVoiceJoinProgress(p69, p70) -- line: 1230
	p69.VoiceJoinProgress = p70
	p69.VoiceJoinProgressChanged:Fire(p69.VoiceJoinProgress)
end
function t2.setOptions(t16: {[any]: any}, t17: {[any]: any}) -- line: 1235
	t16.options = t17
end
function t2.ShouldShowJoinVoiceOnDisconnect(p71) -- line: 1239
	-- upvalues: VOICE_JOIN_PROGRESS (copy)
	return p71:IsSeamlessVoice() and p71.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended
end
function t2.IsSeamlessVoice(p72) -- line: 1243
	-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagCheckUniversePlaceBeforeSuspending (copy), Constants (copy)
	if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and not p72.options.allowSeamlessVoice then
		return false
	end

	local v255 = p72:FetchAgeVerificationOverlay()

	if type(v255) ~= "table" or not v255 or not v255.voiceSettings then
		return false
	end

	if GetFFlagCheckUniversePlaceBeforeSuspending() and not p72:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local seamlessVoiceStatus = v255.voiceSettings.seamlessVoiceStatus

	return seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledExistingUser or seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledNewUser
end
function t2.HasSeamlessVoiceFeature(p73, p74) -- line: 1265
	-- upvalues: GetFFlagEnableSeamlessVoiceFeature (copy), Utils (copy), Constants (copy)
	if not p73.options.allowSeamlessVoice or not p73:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local v259 = p73:FetchAgeVerificationOverlay()

	if not p73:_isValidAgeVerificationOverlayData(v259) then
		return false
	end

	local seamlessVoiceVariant = v259.voiceSettings.seamlessVoiceVariant

	if not seamlessVoiceVariant then
		return false
	end

	if GetFFlagEnableSeamlessVoiceFeature() then
		if type(p74) == "string" then
			p74 = { p74 }
		end

		if GetFFlagEnableSeamlessVoiceFeature(p74) then
			local v261 = Utils.jsonDecode(seamlessVoiceVariant)
			local t18 = {}

			for _, v in pairs(v261) do
				t18[v] = true
			end

			if #p74 == 1 and p74[1] == Constants.SeamlessVoiceFeatures.ConnectDisconnect and seamlessVoiceVariant == Constants.SeamlessVoiceVariants.OnlyConnectDisconnect then
				return true
			end

			for _, v in pairs(p74) do
				if not t18[v] then
					return false
				end
			end

			return true
		end
	else
		local v267 = ({
			[Constants.SeamlessVoiceFeatures.ConnectDisconnect] = function(p75) -- line: 1310
				-- upvalues: Constants (copy)
				return p75 ~= Constants.SeamlessVoiceVariants.Control
			end,
			[Constants.SeamlessVoiceFeatures.HearingWithoutMicPermissions] = function(p76) -- line: 1313
				-- upvalues: Constants (copy)
				return p76 == Constants.SeamlessVoiceVariants.HearingWithoutMicPermissions
			end
		})[p74]

		if v267 then
			return v267(seamlessVoiceVariant)
		end
	end

	return false
end
function t2.IsNewSeamlessVoiceUserDisconnect(p77) -- line: 1327
	-- upvalues: Constants (copy)
	if not p77.options.allowSeamlessVoice or not p77:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local v269 = p77:FetchAgeVerificationOverlay()

	if not p77:_isValidAgeVerificationOverlayData(v269) then
		return false
	end

	if v269.voiceSettings.seamlessVoiceStatus ~= Constants.SeamlessVoiceStatus.EnabledNewUser then
		return false
	end

	local ok, result = pcall(function() -- line: 1346
		-- upvalues: p77 (copy), Constants (copy)
		return p77.AppStorageService:GetItem(Constants.SEAMLESS_VOICE_FTUX_KEY)
	end)

	return ok and result == "false"
end
function t2._isValidAgeVerificationOverlayData(_: {[any]: any}, t20: {[any]: any}?) -- line: 1354
	return type(t20) == "table" and (t20 and t20.voiceSettings)
end
function t2.UserInInExperienceUpsellTreatment(p78) -- line: 1358
	-- upvalues: Constants (copy)
	local v275 = p78:FetchAgeVerificationOverlay()

	if not v275 then
		return false
	end

	local showVoiceInExperienceUpsellVariant = v275.showVoiceInExperienceUpsellVariant

	return showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT1 or (showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT2 or showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT3)
end
function t2.UserOnlyEligibleForVoice(p79) -- line: 1370
	-- upvalues: v34 (copy)
	local communicationPermissionsResult = p79.communicationPermissionsResult

	if not communicationPermissionsResult or (not communicationPermissionsResult.voiceSettings or not communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		if not v34 then
			return false
		end

		p79:FetchVoicePermissions()
		communicationPermissionsResult = p79.communicationPermissionsResult
	end

	return communicationPermissionsResult.voiceSettings.isUserVerifiedForVoice and (not communicationPermissionsResult.voiceSettings.isVoiceEnabled and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice)
end
function t2.UserOnlyEligibleForVoiceViaOverlay(p80) -- line: 1386
	local v280 = p80:FetchAgeVerificationOverlay()

	if not p80:_isValidAgeVerificationOverlayData(v280) then
		return false
	end

	return v280.voiceSettings.isVerifiedForVoice and (not v280.voiceSettings.isVoiceEnabled and v280.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice)
end
function t2.UserVoiceEnabled(p81) -- line: 1399
	local communicationPermissionsResult = p81.communicationPermissionsResult

	if not communicationPermissionsResult or (not communicationPermissionsResult.voiceSettings or not communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		return false
	end

	return communicationPermissionsResult.voiceSettings.isVoiceEnabled and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
end
function t2.UserEligibleForInExperienceUpsell(p82) -- line: 1409
	-- upvalues: GetFFlagEnableVoiceSignal (copy)
	local v284 = p82:UserOnlyEligibleForVoice()

	if not v284 then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		local v285 = p82:UserInInExperienceUpsellTreatment()

		return v284 and v285
	end

	local v286 = p82:FetchAgeVerificationOverlay()

	return v284 and (v286 and v286.showVoiceInExperienceUpsell)
end
function t2.canUseServiceAsync(p83) -- line: 1430
	-- upvalues: v31 (copy), Promise (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), VOICE_CHAT_AVAILABILITY (copy), VoiceChatService (copy), v35 (copy), IXPServiceWrapper (copy), v37 (copy), v38 (copy)
	if p83.available ~= nil or not game:GetEngineFeature("VoiceChatSupported") then
		v31:debug("Voice Chat is not Available, rejecting canUseService promise")

		if p83.options.passInitErrorInPromiseReject then
			return Promise.reject({
				code = "INIT_ERROR_VOICE_NOT_SUPPORTED"
			})
		end

		return Promise.reject()
	end

	if not p83.canUseServicePromise then
		p83.canUseServicePromise = Promise.defer(function(p84, p85) -- line: 1440
			-- upvalues: p83 (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), v31 (copy), VOICE_CHAT_AVAILABILITY (copy), VoiceChatService (copy), v35 (copy), IXPServiceWrapper (copy), v37 (copy), v38 (copy)
			local v468 = p83:userAndPlaceCanUseVoice()

			if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
				p83.canUseServiceResult = v468
				p83:emit("OnCanUseServiceResult", v468)
			end

			if GetFFlagEnableVoiceSignal() and p83.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended then
				v31:debug("Place is voice enabled but user is not, delaying voice rejection")
				p83.attemptVoiceRejoin.Event:Wait()
				v31:debug("Attempting voice rejoin")
				p83.communicationPermissionsResult.voiceSettings.isVoiceEnabled = true
				p83.userEligible = true
				p83.initializedPostSuspension = true
				p84()
				p83:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joining)

				return
			end

			if not v468 then
				v31:info("Voice access denied")
				p83.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable

				if p83.options.passInitErrorInPromiseReject then
					p85({
						code = "INIT_ERROR_USER_NOT_AVAILABLE"
					})

					return
				end

				p85()

				return
			end

			if game:GetEngineFeature("VoiceChatEnabledRccProperties") and (not VoiceChatService.VoiceChatEnabledForUniverseOnRcc or not VoiceChatService.VoiceChatEnabledForPlaceOnRcc) then
				v31:debug("Disabling voice chat due to RCC Response. Universe: {}, Place: {}", VoiceChatService.VoiceChatEnabledForUniverseOnRcc, VoiceChatService.VoiceChatEnabledForPlaceOnRcc)

				if not VoiceChatService.VoiceChatEnabledForUniverseOnRcc then
					p83:_reportJoinFailed("universeNotEnabled")
				elseif not VoiceChatService.VoiceChatEnabledForPlaceOnRcc then
					p83:_reportJoinFailed("placeNotEnabled")
				end

				p83.available = VOICE_CHAT_AVAILABILITY.PlaceNotAvailable

				if p83.options.passInitErrorInPromiseReject then
					p85({
						code = "INIT_ERROR_PLACE_NOT_AVAILABLE"
					})

					return
				end

				p85()

				return
			end

			if v35 then
				IXPServiceWrapper:WaitForInitialization()

				local ok, result = pcall(function() -- line: 1500
					-- upvalues: IXPServiceWrapper (copy), v37 (copy)
					return IXPServiceWrapper:GetLayerData(v37)
				end)

				if ok and result and result[v38] ~= nil then
					p83.userEligible = result[v38]
					IXPServiceWrapper:LogUserLayerExposure(v37)
				end

				if p83.userEligible then
					p84()

					return
				end

				if p83.options.passInitErrorInPromiseReject then
					p85({
						code = "INIT_ERROR_IXP_NOT_ELIGIBLE"
					})

					return
				end

				p85()

				return
			end

			p83.userEligible = true
			p84()
		end):andThen(function() -- line: 1522
			-- upvalues: p83 (copy)
			return p83:requestMicPermission()
		end)
	end

	return p83.canUseServicePromise
end
function t2._setRecentUserState(p86, p87, p88) -- line: 1529
	-- upvalues: Cryo (copy)
	local v291 = p86.recentUsersInteractionData[tostring(p87)] or {}
	local v292 = Cryo.Dictionary.join(v291, p88)

	p86.recentUsersInteractionData = Cryo.Dictionary.join(p86.recentUsersInteractionData, {
		[tostring(p87)] = v292
	})
end
function t2.getRecentUsersInteractionData(p89) -- line: 1539
	p89:_updateRecentUsersInteractionData()

	return p89.recentUsersInteractionData
end
function t2.GetSignalREvent(p90, p91) -- line: 1544
	return p90.SignalREventTable[p91].Event
end
function t2.StartModerationSignal(p92) -- line: 1549
	-- upvalues: v31 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
	if not p92.playerModeratedConnection then
		p92.playerModeratedConnection = p92:GetSignalREvent("ParticipantModeratedFromVoice"):Connect(function() -- line: 1552
			-- upvalues: v31 (copy), p92 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
			v31:debug("User Moderated")
			p92.previousSessionId = p92.service:GetSessionId()
			p92:emit("OnPlayerModerated")

			if GetFFlagVoiceChatClientRewriteMasterLua() then
				VoiceChatService:notifyServerACSCleanup()
				VoiceChatService:leaveVoice()

				return
			end

			VoiceChatService:notifyServerACSCleanup()
			p92.service:Leave()
		end)
	end
end
function t2.StopModerationSignal(p93) -- line: 1567
	if p93.playerModeratedConnection then
		p93.playerModeratedConnection:Disconnect()
		p93.playerModeratedConnection = nil
	end
end
function t2._updateRecentUsersInteractionData(p94) -- line: 1574
	-- upvalues: v33 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), Players (copy), GetFIntVoiceUsersInteractionExpiryTimeSeconds (copy), Cryo (copy)
	local timestamp = os.time()
	local t21 = {}

	if p94.recentUsersInteractionData then
		for k, v in pairs(p94.recentUsersInteractionData) do
			local v303 = if not v33 then p94.participants[k] else p94.participants[tostring(k)]
			local v304 = GetFFlagClearUserFromRecentVoiceDataOnLeave() and not Players:GetPlayerByUserId((tonumber(k)))
			local v305 = timestamp - v.lastHeardTime >= GetFIntVoiceUsersInteractionExpiryTimeSeconds()
			local v306 = not v303 or v303.isMuted

			if v305 and v306 or v304 then
				t21[k] = Cryo.None
			end
		end

		p94.recentUsersInteractionData = Cryo.Dictionary.join(p94.recentUsersInteractionData, t21)
	end
end
function t2.SetupParticipantListeners(p95) -- line: 1598
	-- upvalues: v31 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), v33 (copy), GetFFlagFixGetPlayerByUserIdStringCast (copy), Players (copy), VoiceChatService (copy), FFlagEnablePartyVoiceChangersInLua (copy), GetFFlagBatchVoiceParticipantsUpdates (copy), v74 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v63 (copy), v64 (copy), v65 (copy), v67 (copy), GetFFlagDisconnectToastClientRewrite (copy), v68 (copy), EngineFeature (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), VoiceVolumeControlsEligibility (copy), v62 (copy), MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY (copy), GetFFlagLocalMutedNilFix (copy), v39 (copy), GetFFlagLuaConsumePlayerModerated (copy), GetFFlagEnableVoiceReverseNudge (copy), Utils (copy), t1 (copy)
	p95:ensureInitialized("setup participant listeners")

	if not p95.participants then
		p95.participants = {}
		p95.recentUsersInteractionData = {}
		p95.updatedParticipants = {}
		p95.participantConnection = p95.service.ParticipantsStateChanged:Connect(function(p96, p97, p98) -- line: 1607
			-- upvalues: v31 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), p95 (copy), v33 (copy), GetFFlagFixGetPlayerByUserIdStringCast (copy), Players (copy), VoiceChatService (copy), FFlagEnablePartyVoiceChangersInLua (copy), GetFFlagBatchVoiceParticipantsUpdates (copy), v74 (copy)
			v31:trace("Participants state changed")

			for _, v in ipairs(p96) do
				if not GetFFlagClearUserFromRecentVoiceDataOnLeave() and not p95.participants[tostring(v)].isMuted then
					p95:_setRecentUserState(v, {
						lastHeardTime = os.time()
					})
				end

				p95.participants[tostring(v)] = nil
				p95.participantLeft:Fire(p95.participants, v)
				p95:emit("OnVoiceParticipantRemoved", v)
			end

			for _, v in ipairs(p97) do
				p95.participantJoined:Fire(p95.participants, v)
				p95:emit("OnVoiceParticipantAdded", v)
			end

			for _, v in pairs(p98) do
				local userId = v.userId
				local v481 = if not v33 then p95.participants[userId] else p95.participants[tostring(userId)]

				if not v.isMuted or v481 and not v481.isMuted then
					p95:_setRecentUserState(userId, {
						lastHeardTime = os.time(),
						player = if not GetFFlagFixGetPlayerByUserIdStringCast() then Players:GetPlayerByUserId(userId) else Players:GetPlayerByUserId((tonumber(userId)))
					})
				end

				if not v481 or v481.isMuted ~= v.isMuted then
					p95:emit("OnVoiceParticipantToggleMuted", userId, v.isMuted)
				end

				if VoiceChatService.UseNewAudioApi then
					v.isMutedLocally = not not p95.mutedPlayers[userId]
				end

				if VoiceChatService.UseNewAudioApi then
					v.isMutedLocally = if not p95.mutedPlayers[userId] then v.isMutedLocally else not not p95.mutedPlayers[userId]
				end

				if FFlagEnablePartyVoiceChangersInLua and VoiceChatService.UseNewAudioApi then
					v.isVoiceChangerActive = if not p95.voiceChangerActivePlayers[userId] then v.isVoiceChangerActive else p95.voiceChangerActivePlayers[userId]
				end

				if p95.muteAll then
					v.isMutedLocally = true
				end

				p95.participants[tostring(userId)] = v

				if GetFFlagBatchVoiceParticipantsUpdates() then
					p95.updatedParticipants[tostring(userId)] = v
				end

				if v74 and p95.CaptureService:IsCapturingVideo() then
					p95.voiceCapturedDuringVideoCapture = p95.voiceCapturedDuringVideoCapture or v.isSignalActive
				end
			end

			p95:_updateRecentUsersInteractionData()

			if p95.shouldThrottleParticipantUpdate then
				local timestamp = tick()

				if timestamp - p95.lastParticipantsStateUpdate >= p95.participantsStateThrottleTime and #p98 > 0 then
					p95.lastParticipantsStateUpdate = timestamp
					p95.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p95.participants else p95.updatedParticipants)
					p95.updatedParticipants = {}

					return
				end

				if #p98 > 0 then
					local v483 = p95.participantsStateThrottleTime - (timestamp - p95.lastParticipantsStateUpdate)

					p95.lastStateUpdateCounter = (p95.lastStateUpdateCounter + 1) % 100

					local lastStateUpdateCounter = p95.lastStateUpdateCounter

					task.wait(v483)

					if lastStateUpdateCounter == p95.lastStateUpdateCounter then
						p95.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p95.participants else p95.updatedParticipants)
						p95.updatedParticipants = {}

						return
					end
				end
			elseif #p98 > 0 then
				p95.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p95.participants else p95.updatedParticipants)
				p95.updatedParticipants = {}
			end
		end)

		local function onStateChanged(p99, p100) -- line: 1725
			-- upvalues: p95 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v31 (copy), v63 (copy), v64 (copy), v65 (copy), v67 (copy), GetFFlagDisconnectToastClientRewrite (copy), v68 (copy), EngineFeature (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy)
			p95:emit("OnStateChanged", p99, p100)

			local v487 = p100 == Enum.VoiceChatState.Failed
			local v488 = p100 == Enum.VoiceChatState.Joining
			local v489 = p100 == Enum.VoiceChatState.Leaving
			local v490 = p100 == Enum.VoiceChatState.Ended
			local v491 = p95.service:IsPublishPaused()

			if v491 ~= p95.localMuted and (not v487 and not v488 and not v489 and not v490) then
				p95.localMuted = v491
				p95.muteChanged:Fire(v491)
			elseif v488 or v489 or v490 then
				p95.localMuted = nil
			end

			if GetFFlagVoiceChatClientRewriteMasterLua() and p100 == Enum.VoiceChatState.Joined and p95.isInCall and v491 ~= p95.callMutedState then
				v31:debug("In call, setting local muted to call muted state {}", p95.callMutedState)
				p95:ToggleMic("InitInCall")
			end

			if v63 and p100 == Enum.VoiceChatState.Joined then
				p95:StartModerationSignal()
			end

			if v64 and p100 == Enum.VoiceChatState.Joined then
				p95:_syncLocalAudioDeviceActive()
			end

			if p100 == Enum.VoiceChatState.Leaving then
				if not v65 or not p95.previousGroupId then
					p95.previousGroupId = p95.service:GetGroupId()
				end

				p95.previousMutedState = p95.service:IsPublishPaused()
			end

			if p100 == Enum.VoiceChatState.Ended or v487 then
				p95.participants = {}
				p95.localMuted = nil

				if v67 then
					p95._voiceVolumeEligibilityReported = false
				end

				p95.participantsUpdate:Fire(p95.participants)

				if v63 then
					p95:StopModerationSignal()
				end

				if v64 then
					p95:_syncLocalAudioDeviceActive()
				end

				if v487 then
					v31:debug("State Changed to Failed. Reason: {}", p95.service:GetAndClearCallFailureMessage())
				end

				if p99 == Enum.VoiceChatState.Joining or p99 == Enum.VoiceChatState.JoiningRetry or p99 == Enum.VoiceChatState.Joined then
					if p100 == Enum.VoiceChatState.Ended then
						v31:debug("State Changed to Ended from {}", p99)
					end

					if not GetFFlagDisconnectToastClientRewrite() or not p95:IsSeamlessVoice() or p95:GetVoiceConnectCookieValue() then
						p95:emit("OnRetryRequested")
					end
				end

				if v68 and EngineFeature then
					p95:ReportVoiceVolumeImpressionsIfNeeded()
				end
			end

			if GetFFlagEnableVoiceSignal() and p95.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Joining and p100 == Enum.VoiceChatState.Joined then
				p95:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joined)
				p95:emit("OnVoiceJoin")
			end

			if v68 and EngineFeature and p100 == Enum.VoiceChatState.Joined then
				p95._voiceJoinTimestampMs = DateTime.now().UnixTimestampMillis
				p95._voiceVolumeSliderEligibleAtJoin = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)
			end

			if v67 and EngineFeature and p100 == Enum.VoiceChatState.Joined and not p95._voiceVolumeEligibilityReported then
				local ok, result = pcall(function() -- line: 1836
					return UserSettings():GetService("UserGameSettings").VoiceChatVolume
				end)
				local UseNewAudioApi = VoiceChatService.UseNewAudioApi
				local v495 = VoiceVolumeControlsEligibility.isCreatorVoiceVolumeControlsEnabled()
				local VoiceAnalyticsData = p95:GetVoiceAnalyticsData()

				p95.Analytics:reportVoiceVolumeEligibility({
					playSessionId = VoiceAnalyticsData.playSessionId,
					voiceSessionId = VoiceAnalyticsData.voiceSessionId,
					voiceChatVolume = if not ok then nil else result,
					usesNewAudioApi = UseNewAudioApi,
					enablesVoiceVolumeControls = v495,
					isEligible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, UseNewAudioApi)
				})
				p95._voiceVolumeEligibilityReported = true
			end
		end

		if p95.service.VoiceChatState and p95.service.VoiceChatState == Enum.VoiceChatState.Joined then
			v31:debug("Joined voice chat {}", p95.service.VoiceChatState)
			onStateChanged(nil, Enum.VoiceChatState.Joined)
		end

		p95.stateConnection = p95.service.StateChanged:Connect(onStateChanged)

		if v62 and VoiceChatService.UseNewAudioApi then
			if not p95.localMeteringTask then
				p95.localMeteringTask = task.spawn(function() -- line: 1862
					-- upvalues: p95 (copy)
					while true do
						p95:UpdateLocalMetering()
						task.wait()
					end
				end)
			end
		elseif p95.service:GetVoiceChatApiVersion() >= MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY then
			p95.micConnection = p95.service.PlayerMicActivitySignalChange:Connect(function(p101) -- line: 1871
				-- upvalues: v74 (copy), p95 (copy), GetFFlagLocalMutedNilFix (copy), v39 (copy)
				if v74 and p95.CaptureService:IsCapturingVideo() then
					p95.voiceCapturedDuringVideoCapture = p95.voiceCapturedDuringVideoCapture or p101.isActive
				end

				p95.isTalking = p101.isActive

				if GetFFlagLocalMutedNilFix() then
					if p95.localMuted == false then
						if v39 then
							p95:FireTalkingChangedDebounced(p95.isTalking)

							return
						end

						p95.talkingChanged:Fire(p95.isTalking)

						return
					end
				elseif not p95.localMuted then
					if v39 then
						p95:FireTalkingChangedDebounced(p95.isTalking)

						return
					end

					p95.talkingChanged:Fire(p95.isTalking)
				end
			end)
		end

		if GetFFlagLuaConsumePlayerModerated() then
			p95:StartModerationSignal()
		elseif game:GetEngineFeature("VoiceChatServicePlayerModeratedEvent") then
			p95.playerModeratedConnection = p95.service.LocalPlayerModerated:connect(function() -- line: 1904
				-- upvalues: v31 (copy), p95 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
				v31:debug("User Moderated old")
				p95.previousSessionId = p95.service:GetSessionId()
				p95:emit("OnPlayerModerated")

				if GetFFlagVoiceChatClientRewriteMasterLua() then
					VoiceChatService:leaveVoice()

					return
				end

				p95.service:Leave()
			end)
		end

		v31:trace("Setting up voice nudge handlers")
		p95.voiceToxicityModalConnection = p95:GetSignalREvent("VoiceToxicityModal"):Connect(function(p102) -- line: 1917
			-- upvalues: p95 (copy)
			p95.Analytics:reportReceivedNudge(p102, p95:GetNudgeAnalyticsData())
			p95:emit("OnVoiceToxicityModal")
		end)
		p95.VoiceToxicityToastConnection = p95:GetSignalREvent("VoiceToxicityToast"):Connect(function(p103) -- line: 1923
			-- upvalues: p95 (copy)
			p95.Analytics:reportReceivedNudge(p103, p95:GetNudgeAnalyticsData())
			p95:emit("OnVoiceToxicityToast")
		end)

		if GetFFlagEnableVoiceReverseNudge() then
			v31:trace("Setting up voice reverse nudge handlers")
			p95.voiceReverseNudgeConnection = p95:GetSignalREvent("VoiceReverseNudgeIconColorChange"):Connect(function(p104) -- line: 1930
				-- upvalues: p95 (copy)
				p95:emit("OnVoiceReverseNudgeIconColorChange", p104)
			end)
		end

		p95.blockConnection = p95.BlockStatusChanged:Connect(function(n4: number, b4: boolean) -- line: 1935
			-- upvalues: p95 (copy), v31 (copy), Utils (copy)
			if b4 then
				if p95.participants[tostring(n4)] then
					v31:debug("Blocking {}", Utils.shorten(n4))
					p95.service:SubscribeBlock(n4)

					return
				end
			else
				v31:debug("UnBlocking {}", Utils.shorten(n4))
				p95.service:SubscribeUnblock(n4)
			end
		end)

		if VoiceChatService.UseNewAudioApi then
			p95:hookupAudioDeviceInputListener()
		end

		if p95.service.TempSetMicMutedToggleMic then
			p95.tempSetMicMutedToggleMicConnection = p95.service.TempSetMicMutedToggleMic:connect(function() -- line: 1953
				-- upvalues: p95 (copy)
				p95:ToggleMic("TempSetMicMutedToggleMic")
			end)
		end

		if v74 then
			p95.videoCaptureInProgressConnection = p95.CaptureService.VideoCaptureInProgress:connect(function(b5: boolean) -- line: 1960
				-- upvalues: p95 (copy), t1 (copy)
				if b5 then
					p95.voiceCapturedDuringVideoCapture = false

					return
				end

				p95.TelemetryService:LogEvent(t1, {
					customFields = {
						voiceCaptured = p95.voiceCapturedDuringVideoCapture
					}
				})
			end)
		end
	end
end

local u99 = nil

function t2.CheckAudioInputExists(p105) -- line: 1975
	-- upvalues: v31 (copy), u99 (ref), Promise (copy), Cryo (copy)
	v31:trace("Checking for AudioDeviceInput")

	if not u99 then
		u99 = Promise.new(function(resolve, _) -- line: 1978
			-- upvalues: Cryo (copy), p105 (copy), v31 (copy)
			if #Cryo.Dictionary.keys(p105.audioDevices) > 0 then
				v31:trace("Found existing AudioDeviceInput")
				resolve()

				return
			end

			p105.audioDeviceInputAdded.Event:Connect(function() -- line: 1983
				-- upvalues: v31 (copy), resolve (copy)
				v31:trace("Found new AudioDeviceInput")
				resolve()
			end)
		end)
	end

	return u99
end
function t2.checkAndUpdateSequence(t22: {[any]: any}, s10: string, n5: number) -- line: 1993
	if not n5 then
		return 0
	end

	if not t22.SequenceNumbers[s10] then
		t22.SequenceNumbers[s10] = n5

		return 0
	end

	local v313 = n5 - t22.SequenceNumbers[s10]

	if v313 > 0 then
		t22.SequenceNumbers[s10] = n5
	end

	return v313 - 1
end

local function isIgnoredAudioInput(p107) -- line: 2020
	-- upvalues: CoreGui (copy)
	return p107:IsDescendantOf(CoreGui)
end

function t2.onInstanceAdded(t23: {[any]: any}, p108) -- line: 2024
	-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), v31 (copy)
	if p108:IsA("AudioDeviceInput") then
		if FFlagExpChatDictation and p108:IsDescendantOf(CoreGui) then
			return
		end

		v31:debug("Found new audio device instance for {}", p108.Player and p108.Player.Name)
		t23.audioDevices[p108] = t23:CreateAudioDeviceData(p108)
		t23:emit("OnAudioDeviceInputAdded")
		t23:StartAnalysis(p108)
	end
end
function t2.GetSendMuteEvent(p109) -- line: 2037
	-- upvalues: RobloxReplicatedStorage (copy)
	if not p109.SendMuteEvent then
		p109.SendMuteEvent = RobloxReplicatedStorage:WaitForChild("SetUserActive", 10)
	end

	return p109.SendMuteEvent
end
function t2.GetToggleVoiceChangerEvent(p110) -- line: 2044
	-- upvalues: ReplicatedStorage (copy)
	if not p110.SendVoiceChangerEvent then
		p110.SendVoiceChangerEvent = ReplicatedStorage:WaitForChild("ToggleUserVoiceChanger", 10)
	end

	return p110.SendVoiceChangerEvent
end
function t2.GetInputToModifierWire(p111) -- line: 2051
	-- upvalues: Players (copy)
	if not p111.InputToModifierWire then
		p111.InputToModifierWire = Players.LocalPlayer:FindFirstChild("InputToModifier")
	end

	return p111.InputToModifierWire
end
function t2.GetPartyVoiceDeviceInput(p112) -- line: 2058
	-- upvalues: Players (copy)
	if not p112.PartyVoiceDeviceInput then
		p112.PartyVoiceDeviceInput = Players.LocalPlayer:FindFirstChild("PartyVoiceDeviceInput")
	end

	return p112.PartyVoiceDeviceInput
end
function t2.GetSetVoicePackEvent(p113) -- line: 2066
	-- upvalues: ReplicatedStorage (copy)
	if not p113.SetVoicePackEvent then
		p113.SetVoicePackEvent = ReplicatedStorage:WaitForChild("SetVoicePack", 10)
	end

	return p113.SetVoicePackEvent
end
function t2.GetVoiceChangerWasToggledEvent(p114) -- line: 2073
	-- upvalues: ReplicatedStorage (copy)
	if not p114.VoiceChangerWasToggledEvent then
		p114.VoiceChangerWasToggledEvent = ReplicatedStorage:WaitForChild("VoiceChangerWasToggled", 3)
	end

	return p114.VoiceChangerWasToggledEvent
end

local function WireUp(p115, p116) -- line: 2081
	local Wire = Instance.new("Wire")

	Wire.SourceInstance = p115
	Wire.TargetInstance = p116
	Wire.Parent = p116

	return Wire
end
local function GetAnalysisHost() -- line: 2090
	-- upvalues: RobloxReplicatedStorage (copy)
	return RobloxReplicatedStorage
end

function t2.GetAnalyzer(_: {[any]: any}, p117) -- line: 2094
	-- upvalues: RobloxReplicatedStorage (copy)
	local v328 = p117.Name .. "_Analyzer"
	local v329 = RobloxReplicatedStorage
	local v330 = v329:FindFirstChild(v328)

	if not v330 then
		v330 = Instance.new("AudioAnalyzer")
		v330.SpectrumEnabled = false
		v330.Name = v328
		v330.Parent = v329
	end

	return v330
end

local function toDecibels(n6: number) -- line: 2107
	return math.log10(n6) * 20
end

function t2.IsSignalActive(t25: {[any]: any}, n7: number) -- line: 2111
	-- upvalues: v62 (copy), Players (copy)
	if not v62 then
		return false
	end

	local PlayerByUserId = Players:GetPlayerByUserId(n7)

	if not PlayerByUserId then
		return false
	end

	return math.log10(t25:GetAnalyzer(PlayerByUserId).PeakLevel) * 20 > -36
end
function t2.StopAnalysis(_: {[any]: any}, p118) -- line: 2125
	-- upvalues: v62 (copy), RobloxReplicatedStorage (copy)
	if not v62 then
		return
	end

	for _, v338 in p118:GetConnectedWires("Output") do
		local TargetInstance = v338.TargetInstance

		if TargetInstance and TargetInstance:IsDescendantOf(RobloxReplicatedStorage) then
			v338:Destroy()
		end
	end
end
function t2.StartAnalysis(t27: {[any]: any}, p119) -- line: 2141
	-- upvalues: v62 (copy)
	if not v62 then
		return
	end

	t27:StopAnalysis(p119)

	local Player = p119.Player

	if not Player then
		return
	end

	local Analyzer = t27:GetAnalyzer(Player)
	local Wire = Instance.new("Wire")

	Wire.SourceInstance = p119
	Wire.TargetInstance = Analyzer
	Wire.Parent = Analyzer
end
function t2.GetVoiceConnectCookie(p120) -- line: 2155
	-- upvalues: Constants (copy)
	local ok, result = pcall(function() -- line: 2156
		-- upvalues: p120 (copy), Constants (copy)
		return p120.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
	end)

	if ok and result then
		return result
	end

	return ""
end
function t2.GetVoiceConnectCookieValue(p121) -- line: 2167
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), Constants (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		local ok, result = pcall(function() -- line: 2169
			-- upvalues: p121 (copy), Constants (copy)
			return p121.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
		end)

		if ok then
			return result == "true"
		end

		return true
	end

	local ok, result = pcall(function() -- line: 2175
		-- upvalues: p121 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), Constants (copy)
		return p121.AppStorageService:GetItem(if not GetFFlagEnableSeamlessVoiceV2() then Constants.VOICE_CONNECT_DISCONNECT_KEY else Constants.VOICE_CONNECT_DISCONNECT_KEY_V2)
	end)

	if ok then
		return result == "true"
	end

	return true
end
function t2.SetVoiceConnectCookieValue(t28: {[any]: any}, b6: boolean) -- line: 2187
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), Constants (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		return (pcall(function() -- line: 2189
			-- upvalues: t28 (copy), Constants (copy), b6 (copy)
			t28.AppStorageService:SetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3, (tostring(b6)))
			t28.AppStorageService:Flush()
		end))
	end

	return (pcall(function() -- line: 2195
		-- upvalues: t28 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), Constants (copy), b6 (copy)
		t28.AppStorageService:SetItem(if not GetFFlagEnableSeamlessVoiceV2() then Constants.VOICE_CONNECT_DISCONNECT_KEY else Constants.VOICE_CONNECT_DISCONNECT_KEY_V2, (tostring(b6)))
		t28.AppStorageService:Flush()
	end))
end
function t2.GetVoiceRewarmCookie(p122) -- line: 2208
	-- upvalues: Constants (copy), v31 (copy)
	local ok, result = pcall(function() -- line: 2209
		-- upvalues: p122 (copy), Constants (copy)
		return p122.AppStorageService:GetItem(Constants.VOICE_REWARM_KEY)
	end)

	if ok and result then
		v31:debug("Got voice re-warm cookie: {}", result)

		return result
	end

	v31:debug("Voice re-warm cookie not set, returning empty string")

	return ""
end
function t2.SetVoiceRewarmCookie(t29: {[any]: any}, s11: string) -- line: 2222
	-- upvalues: v31 (copy), Constants (copy)
	v31:debug("Setting voice re-warm cookie to {}", s11)
	pcall(function() -- line: 2224
		-- upvalues: t29 (copy), Constants (copy), s11 (copy)
		t29.AppStorageService:SetItem(Constants.VOICE_REWARM_KEY, (tostring(s11)))
		t29.AppStorageService:Flush()
	end)
end
function t2.ShouldRewarmUser(p123) -- line: 2230
	return p123:GetVoiceRewarmCookie() == ""
end
function t2.RewarmUser(p124) -- line: 2234
	p124:SetVoiceRewarmCookie("true")
end
function t2.SetNewUserFTUXCookieValue(t30: {[any]: any}, b7: boolean) -- line: 2238
	-- upvalues: Constants (copy)
	return (pcall(function() -- line: 2239
		-- upvalues: t30 (copy), Constants (copy), b7 (copy)
		t30.AppStorageService:SetItem(Constants.SEAMLESS_VOICE_FTUX_KEY, (tostring(b7)))
		t30.AppStorageService:Flush()
	end))
end
function t2.SetAndSyncActive(t31: {[any]: any}, p125, b8: boolean) -- line: 2246
	-- upvalues: Players (copy)
	p125.Active = b8

	local SendMuteEvent = t31:GetSendMuteEvent()

	if SendMuteEvent and p125.Player == Players.LocalPlayer then
		SendMuteEvent:FireServer(b8)
	end
end
function t2.CreateAudioDeviceData(t32: {[any]: any}, p126) -- line: 2255
	-- upvalues: Players (copy), EngineFeature2 (copy), v31 (copy), v32 (copy), v59 (copy), v64 (copy), VoiceChatService (copy)
	local t33 = {}
	local u371 = p126.Player == Players.LocalPlayer

	if EngineFeature2 then
		if not p126.MutedByLocalUser then
			if t32.muteAll and not u371 then
				p126.MutedByLocalUser = true
			end

			if p126.Player and t32.mutedPlayers[p126.Player.UserId] then
				p126.MutedByLocalUser = true
			end
		end
	elseif p126.Active then
		if t32.muteAll and not u371 then
			p126.Active = false
		end

		if p126.Player and t32.mutedPlayers[p126.Player.UserId] then
			p126.Active = false
		end
	end

	if p126.Active and u371 and t32.localMuted == nil then
		t32:SetAndSyncActive(p126, false)
	end

	if u371 and t32.localMuted ~= nil and t32.localMuted ~= not p126.Active and not t32.isInCall then
		v31:debug("Mismatch between LocalMuted and device.Active")

		local v372 = not t32.localMuted

		p126.Active = v372

		local SendMuteEvent = t32:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v372)
		end
	elseif t32.isInCall and u371 then
		local v374 = not t32.callMutedState

		v31:debug("Overwriting Active State to match Iris call. .Active = {}", v374)
		p126.Active = v374

		local SendMuteEvent = t32:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v374)
		end
	end

	t33.onPlayerChanged = p126:GetPropertyChangedSignal("Player"):Connect(function() -- line: 2305
		-- upvalues: v32 (copy), u371 (ref), p126 (copy), Players (copy), t32 (copy), v31 (copy), EngineFeature2 (copy)
		if v32 then
			u371 = p126.Player == Players.LocalPlayer

			if u371 then
				if p126.Active and t32.localMuted == nil then
					v31:debug("Player is still in connecting state, setting Active to false")
					t32:SetAndSyncActive(p126, false)
				elseif t32.localMuted ~= nil and t32.localMuted ~= not p126.Active then
					v31:debug("Mismatch between LocalMuted and device.Active")
					t32:SetAndSyncActive(p126, not t32.localMuted)
				end
			elseif t32.muteAll or p126.Player and t32.mutedPlayers[p126.Player.UserId] then
				if EngineFeature2 then
					p126.MutedByLocalUser = true
				else
					p126.Active = false
				end
			end
		end

		t32:emit("OnDevicePlayerChanged")
		t32:StartAnalysis(p126)
	end)
	t33.onMutedChanged = p126:GetPropertyChangedSignal("Muted"):Connect(function() -- line: 2331
		-- upvalues: t32 (copy)
		t32:emit("OnDeviceMuteChanged")
	end)

	if not EngineFeature2 then
		t33.onActiveChanged = p126:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2336
			-- upvalues: t32 (copy), u371 (ref), p126 (copy)
			t32:emit("OnDeviceActiveChanged")

			if t32.muteAll and not u371 then
				p126.Active = false
			end

			if p126.Player and t32.mutedPlayers[p126.Player.UserId] then
				p126.Active = false
			end
		end)
	elseif v59 then
		t33.onActiveChanged = p126:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2347
			-- upvalues: t32 (copy)
			t32:emit("OnDeviceActiveChanged")
		end)
		t33.onMutedByLocalUserChanged = p126:GetPropertyChangedSignal("MutedByLocalUser"):Connect(function() -- line: 2350
			-- upvalues: t32 (copy)
			t32:emit("OnDeviceMutedByLocalUserChanged")
		end)
	end

	if v64 and VoiceChatService.UseNewAudioApi then
		t33.onActiveChangedDisconnectGuard = p126:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2356
			-- upvalues: p126 (copy), Players (copy), t32 (copy)
			if p126.Active and (p126.Player == Players.LocalPlayer and t32.localMuted == nil) then
				t32:SetAndSyncActive(p126, false)
			end
		end)
	end

	return t33
end
function t2.onInstanceRemove(t34: {[any]: any}, p127) -- line: 2366
	-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), v31 (copy), EngineFeature2 (copy), v59 (copy), v62 (copy)
	if p127:IsA("AudioDeviceInput") then
		if FFlagExpChatDictation and p127:IsDescendantOf(CoreGui) then
			return
		end

		t34:StopAnalysis(p127)
		v31:trace("Removing AudioDeviceInput {} {} {}", p127, "for user", p127.Player and p127.Player.UserId)

		local v378 = t34.audioDevices[p127]

		if v378 then
			if not EngineFeature2 then
				v378.onActiveChanged:Disconnect()
			elseif v59 then
				if v378.onActiveChanged then
					v378.onActiveChanged:Disconnect()
				end

				if v378.onMutedByLocalUserChanged then
					v378.onMutedByLocalUserChanged:Disconnect()
				end
			end

			v378.onMutedChanged:Disconnect()
			v378.onPlayerChanged:Disconnect()

			if v378.onActiveChangedDisconnectGuard then
				v378.onActiveChangedDisconnectGuard:Disconnect()
			end
		end

		t34.audioDevices[p127] = nil
		t34:emit("OnAudioDeviceInputRemoved")

		if v62 and p127.Player then
			t34:GetAnalyzer(p127.Player):Destroy()
		end
	end
end
function t2.hookupAudioDeviceInputListener(p128) -- line: 2400
	-- upvalues: v31 (copy), Players (copy), SoundService (copy), VoiceChatService (copy), CollectionService (copy), Utils (copy)
	v31:debug("Hooking up audio device listeners")

	local LocalPlayer = Players.LocalPlayer

	SoundService.AudioInstanceAdded:Connect(function(p129) -- line: 2403
		-- upvalues: p128 (copy)
		p128:onInstanceAdded(p129)
	end)

	local AudioDeviceInput = LocalPlayer:FindFirstChildOfClass("AudioDeviceInput")

	v31:debug("Found local user audio device {}", AudioDeviceInput)

	if AudioDeviceInput then
		p128:onInstanceAdded(AudioDeviceInput)
	end

	if VoiceChatService.EnableDefaultVoice then
		v31:debug("Creating default voice listener")

		if not game:GetEngineFeature("SoundServiceControlsDefaultListenerLocation") then
			local AudioListener = Instance.new("AudioListener")

			AudioListener.Parent = workspace.CurrentCamera

			local Wire = Instance.new("Wire")

			Wire.Parent = AudioListener

			local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

			AudioDeviceOutput.Parent = Wire
			Wire.SourceInstance = AudioListener
			Wire.TargetInstance = AudioDeviceOutput
		end

		for _, v386 in CollectionService:GetTagged("RbxDefaultVoiceEmitter") do
			Utils.destroyDefaultEmitter(v386)
		end

		CollectionService:GetInstanceAddedSignal("RbxDefaultVoiceEmitter"):Connect(Utils.destroyDefaultEmitter)
		LocalPlayer.CharacterAdded:Connect(Utils.avoidEmitting)

		if LocalPlayer.Character then
			Utils.avoidEmitting(LocalPlayer.Character)
		end
	end

	game.DescendantRemoving:Connect(function(descendant) -- line: 2438
		-- upvalues: p128 (copy)
		p128:onInstanceRemove(descendant)
	end)

	for _, descendant in game:GetDescendants() do
		p128:onInstanceAdded(descendant)
	end

	Players.PlayerRemoving:Connect(function(player) -- line: 2447
		-- upvalues: p128 (copy)
		for v509 in p128.audioDevices do
			if v509.Player and player == v509.Player then
				p128:onInstanceRemove(v509)
			end
		end
	end)
end
function t2.RejoinCurrentChannel(p130) -- line: 2457
	-- upvalues: v31 (copy)
	pcall(function() -- line: 2458
		-- upvalues: p130 (copy), v31 (copy)
		local GroupId = p130.service:GetGroupId()

		if GroupId and GroupId ~= "" then
			local v511 = p130.service:IsPublishPaused()

			p130.service:Leave()
			v31:debug("Rejoining current channel {}", GroupId)
			p130.participants = {}
			p130.participantsUpdate:Fire(p130.participants)

			if not p130.service:JoinByGroupIdToken(GroupId, v511, true) then
				p130:emit("OnInitialJoinFailed")
			end
		end
	end)
end
function t2.RejoinChannel(p131, p132, p133) -- line: 2474
	-- upvalues: v31 (copy)
	v31:debug("Rejoining previous channel {} with mute status {}", p132, p133)

	if p132 and p132 ~= "" then
		pcall(function() -- line: 2478
			-- upvalues: p131 (copy), p132 (copy), p133 (copy)
			p131.service:Leave()
			p131.participants = {}
			p131.participantsUpdate:Fire(p131.participants)

			if not p131.service:JoinByGroupIdToken(p132, p133, true) then
				p131:emit("OnInitialJoinFailed")
			end
		end)
	end
end
function t2.RejoinVoice(p134) -- line: 2490
	-- upvalues: GetFFlagVoiceChatClientRewriteMasterLua (copy), v31 (copy), VoiceChatService (copy)
	if GetFFlagVoiceChatClientRewriteMasterLua() then
		v31:debug("Rejoining voice")
		p134.participants = {}
		p134.participantsUpdate:Fire(p134.participants)
		VoiceChatService:rejoinVoice()
	end
end
function t2.watchSignalR(p135) -- line: 2501
	-- upvalues: WATCHED_NAMESPACES (copy), Utils (copy), v31 (copy)
	p135.signalRConnection = p135.NotificationService.RobloxEventReceived:Connect(function(t35: {[any]: any}) -- line: 2502
		-- upvalues: WATCHED_NAMESPACES (copy), Utils (copy), p135 (copy), v31 (copy)
		local namespace = t35.namespace

		if not WATCHED_NAMESPACES[namespace] then
			return
		end

		local v514 = Utils.jsonDecode(t35.detail)
		local v515 = p135.SignalREventTable[v514.type]

		if v515 then
			v515:Fire(v514)
		end

		local SequenceNumber = v514.SequenceNumber

		v31:trace("SignalR message {}: {}", namespace, SequenceNumber)

		local v517 = p135:checkAndUpdateSequence(namespace, SequenceNumber)

		if v517 > 0 then
			p135.Analytics:reportReconnectDueToMissedSequence()

			return
		end

		if v517 < -1 then
			p135.Analytics:reportOutOfOrderSequence()
		end
	end)
	p135.signalRConnectionChanged = p135.NotificationService.RobloxConnectionChanged:Connect(function(p136, p137, _, p139) -- line: 2526
		-- upvalues: v31 (copy), Utils (copy), WATCHED_NAMESPACES (copy), p135 (copy)
		if p136 == "signalR" then
			if p137 ~= Enum.ConnectionState.Connected then
				v31:info("SignalR disconnected")

				return
			end

			for k, v in pairs(Utils.jsonDecode(p139)) do
				if WATCHED_NAMESPACES[k] then
					v31:trace("SignalR message {}: {}", k, v)

					local v524 = p135:checkAndUpdateSequence(k, v)

					if v524 > 0 then
						p135.Analytics:reportReconnectDueToMissedSequence()
					elseif v524 < -1 then
						p135.Analytics:reportOutOfOrderSequence()
					end
				end
			end
		end
	end)
end
function t2.StopSignalRConnection(p140) -- line: 2551
	if p140.signalRConnectionChanged then
		p140.signalRConnectionChanged:Disconnect()
		p140.signalRConnectionChanged = nil
	end

	if p140.signalRConnection then
		p140.signalRConnection:Disconnect()
		p140.signalRConnection = nil
	end
end
function t2.getService(p141) -- line: 2562
	return p141.service
end
function t2.ToggleMic(t36: {[any]: any}, s12: string?) -- line: 2566
	-- upvalues: v31 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PermissionsProtocol (copy), VoiceChatService (copy), Players (copy)
	t36:ensureInitialized("toggle mic")

	if t36.localMuted == nil then
		v31:trace("ToggleMic context: {} - Voice not connected yet", s12)

		return
	end

	v31:trace("ToggleMic context: {}", s12)

	if GetFFlagJoinWithoutMicPermissions() then
		if t36.permissionState == PERMISSION_STATE.PENDING_MIC then
			v31:debug("In pending mic mode, requesting permission")
			t36:emit("GetPermissions", function(p142) -- line: 2579
				-- upvalues: t36 (copy), PERMISSION_STATE (copy), v31 (copy), s12 (copy)
				t36.permissionState = if not p142.hasMicPermissions then PERMISSION_STATE.LISTEN_ONLY else PERMISSION_STATE.LISTEN_AND_TALK
				v31:debug("Got permissions, setting state to {}", t36.permissionState)
				t36:ToggleMic(s12)
			end, { PermissionsProtocol.Permissions.MICROPHONE_ACCESS }, false)

			return
		end

		if t36.permissionState == PERMISSION_STATE.LISTEN_ONLY then
			v31:debug("User tried to unmute despite being in listen only mode")
			t36:emit("OnPermissionRequested")

			return
		end
	end

	if t36.isPlayerWatchingAd then
		v31:trace("User is watching an ad, skipping toggling mic")

		return
	end

	if VoiceChatService.UseNewAudioApi then
		t36.localMuted = not t36.localMuted

		local v399 = not t36.localMuted

		v31:trace("Setting self mute to {} context: {}", v399, s12)

		local SendMuteEvent = t36:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v399)

			for v401 in t36.audioDevices do
				if v401.Player and v401.Player == Players.LocalPlayer then
					v401.Active = v399
				end
			end

			t36.muteChanged:Fire(t36.localMuted)
		else
			v31:error("Could not find SendMuteEvent")
		end
	else
		local v402 = not t36.service:IsPublishPaused()

		v31:trace("Setting self mute to {} context: {}", v402, s12)
		t36.service:PublishPause(v402)
		t36.localMuted = v402
		t36.muteChanged:Fire(v402)
	end

	if not t36.localMuted then
		t36.talkingChanged:Fire(t36.isTalking)
		t36:emit("OnShowDataConsentToast")
	end

	if s12 then
		t36.Analytics:reportVoiceMuteSelf((t36:JoinWithVoiceMuteData({
			context = s12,
			muted = t36.localMuted
		})))
	end
end
function t2.ToggleVoiceChanger(t37: {[any]: any}, _: string?) -- line: 2640
	-- upvalues: VoiceChatService (copy), v31 (copy)
	t37:ensureInitialized("toggle voice changer")

	if t37.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t37.isVoiceChangerActive = not t37.isVoiceChangerActive
		v31:trace("setting voice changer active to {}", t37.isVoiceChangerActive)

		local ToggleVoiceChangerEvent = t37:GetToggleVoiceChangerEvent()

		if ToggleVoiceChangerEvent then
			ToggleVoiceChangerEvent:FireServer(t37.isVoiceChangerActive)
			t37.voiceChangerChanged:Fire(t37.isVoiceChangerActive)

			return
		end

		v31:error("Could not find ToggleVoiceChangerEvent")

		return
	end

	t37.isVoiceChangerActive = false
	v31:trace("forcibly disabling voice changer since using old audio api", t37.isVoiceChangerActive)

	local ToggleVoiceChangerEvent = t37:GetToggleVoiceChangerEvent()

	if ToggleVoiceChangerEvent then
		ToggleVoiceChangerEvent:FireServer(t37.isVoiceChangerActive)
		t37.voiceChangerChanged:Fire(t37.isVoiceChangerActive)

		return
	end

	v31:error("Could not find ToggleVoiceChangerEvent")
end
function t2.ToggleVoiceChangerHearMyself(t38: {[any]: any}, _: string?) -- line: 2670
	-- upvalues: VoiceChatService (copy), v31 (copy)
	if t38.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t38.isVoiceChangerHearMyselfActive = not t38.isVoiceChangerHearMyselfActive

		local InputToModifierWire = t38:GetInputToModifierWire()
		local PartyVoiceDeviceInput = t38:GetPartyVoiceDeviceInput()

		if InputToModifierWire and PartyVoiceDeviceInput then
			v31:trace("setting voice changer hear myself active to {}", t38.isVoiceChangerHearMyselfActive)

			if t38.isVoiceChangerHearMyselfActive then
				InputToModifierWire.SourceInstance = PartyVoiceDeviceInput
			else
				InputToModifierWire.SourceInstance = nil
			end

			t38.voiceChangerHearMyselfChanged:Fire(t38.isVoiceChangerHearMyselfActive)

			return
		end

		v31:error("Could not find InputToModifierWire or PartyVoiceDeviceInput")
	end
end
function t2.SetVoicePack(t39: {[any]: any}, s15: string) -- line: 2695
	-- upvalues: VoiceChatService (copy), v31 (copy)
	t39:ensureInitialized("set voice pack")

	if t39.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t39.currentVoicePack = s15
		v31:trace("setting current voice pack to {}", t39.currentVoicePack)

		local SetVoicePackEvent = t39:GetSetVoicePackEvent()

		if SetVoicePackEvent then
			SetVoicePackEvent:FireServer("VoicePack_" .. t39.currentVoicePack)

			return
		end

		v31:error("Could not find SetVoicePackEvent")
	end
end
function t2.JoinWithVoiceMuteData(p143, p144) -- line: 2714
	-- upvalues: Players (copy), Cryo (copy)
	local LocalPlayer = Players.LocalPlayer

	return Cryo.Dictionary.join({
		userId = LocalPlayer.UserId,
		clientSessionId = p143:GetSessionId(),
		channelId = p143:GetChannelId()
	}, p144)
end
function t2._reportJoinFailed(p145, p146, p147) -- line: 2723
	p145.Analytics:reportVoiceChatJoinResult(false, p146, p147)
	p145:emit("OnReportJoinFailed", p146)
end
function t2._syncLocalAudioDeviceActive(p148) -- line: 2728
	-- upvalues: VoiceChatService (copy), Players (copy)
	if not VoiceChatService.UseNewAudioApi then
		return
	end

	local v421 = p148.localMuted ~= nil and not p148.localMuted

	for v422 in p148.audioDevices do
		if v422.Player and v422.Player == Players.LocalPlayer then
			v422.Active = v421
		end
	end
end
function t2._setupEarlyAudioDeviceGuard(p149) -- line: 2740
	-- upvalues: VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), SoundService (copy)
	local function shouldDeactivate(p150) -- line: 2741
		-- upvalues: VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p149 (copy)
		return VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and p150:IsDescendantOf(CoreGui)) and (p150.Player == Players.LocalPlayer and (p150.Active and p149.localMuted == nil)))
	end
	local function guardDevice(p151) -- line: 2749
		-- upvalues: VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p149 (copy)
		if VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and p151:IsDescendantOf(CoreGui)) and (p151.Player == Players.LocalPlayer and (p151.Active and p149.localMuted == nil))) then
			p151.Active = false
		end

		p151:GetPropertyChangedSignal("Player"):Connect(function() -- line: 2754
			-- upvalues: p151 (copy), VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p149 (copy)
			local v540 = p151

			if VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and v540:IsDescendantOf(CoreGui)) and (v540.Player == Players.LocalPlayer and (v540.Active and p149.localMuted == nil))) then
				p151.Active = false
			end
		end)
		p151:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2760
			-- upvalues: p151 (copy), VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p149 (copy)
			local v541 = p151

			if VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and v541:IsDescendantOf(CoreGui)) and (v541.Player == Players.LocalPlayer and (v541.Active and p149.localMuted == nil))) then
				p151.Active = false
			end
		end)
	end

	SoundService.AudioInstanceAdded:Connect(function(p152) -- line: 2767
		-- upvalues: guardDevice (copy)
		if p152:IsA("AudioDeviceInput") then
			guardDevice(p152)
		end
	end)

	for _, descendant in game:GetDescendants() do
		if descendant:IsA("AudioDeviceInput") then
			guardDevice(descendant)
		end
	end
end
function t2._asyncInit(p153) -- line: 2780
	-- upvalues: v64 (copy), v31 (copy), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy), Analytics (copy), Promise (copy)
	p153:CheckCallState()

	if v64 then
		p153:_setupEarlyAudioDeviceGuard()
	end

	return p153:canUseServiceAsync():andThen(function(_) -- line: 2786
		-- upvalues: v31 (copy), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), p153 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy), Analytics (copy), Promise (copy)
		local s16 = "VoiceChatService"

		if game:GetEngineFeature("UseNewVoiceChatService") then
			s16 = "VoiceChatInternal"
			v31:debug("Using VoiceChatInternal")
		end

		local ok, result = pcall(function() -- line: 2792
			-- upvalues: s16 (ref), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), p153 (copy)
			local s16_2 = game:GetService(s16)

			if s16_2 and (s16_2:GetVoiceChatApiVersion() < MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED or s16_2:IsContextVoiceEnabled()) then
				p153.voiceEnabled = true
				p153.service = s16_2
				p153:SetupParticipantListeners()
			end
		end)

		if GetFFlagVoiceChatClientRewriteMasterLua() then
			VoiceChatService:joinVoice()
			v31:debug("Starting Voice Chat Client Join Operation")
		else
			local VoiceChatService2 = game:GetService("VoiceChatService")

			if VoiceChatService2 then
				VoiceChatService2:joinVoice()
				v31:debug("Starting Voice Chat Client Join Operation")
			end
		end

		if not ok then
			v31:warning("EnableVoiceChat flag is enabled but GetService panicked {}", result)
			p153:_reportJoinFailed("getServiceFailed", Analytics.ERROR)

			if p153.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_GET_SERVICE_FAILED"
				})
			end

			return Promise.reject()
		end

		if not p153.service then
			v31:debug("VoiceChatService is not set after init")
			p153:_reportJoinFailed("contextNotEnabled")

			if p153.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_CONTEXT_NOT_ENABLED"
				})
			end

			return Promise.reject()
		end

		p153:emit("OnVoiceChatServiceInitialized")
		p153:watchSignalR()

		return Promise.resolve()
	end)
end
function t2.UpdateLocalMetering(p155) -- line: 2842
	-- upvalues: Players (copy), v39 (copy)
	p155.isTalking = p155:IsSignalActive(Players.LocalPlayer.UserId)

	if p155.localMuted == false then
		if v39 then
			p155:FireTalkingChangedDebounced(p155.isTalking)

			return
		end

		p155.talkingChanged:Fire(p155.isTalking)
	end
end
function t2.FireTalkingChangedDebounced(p156, p157) -- line: 2853
	-- upvalues: v40 (copy)
	local v432 = v40
	local v433 = tick() * 1000
	local v434 = p157 ~= p156._lastTalkingChangedFireValue
	local v435 = v432 < v433 - p156._lastTalkingChangedFireTime

	if v434 or v435 then
		p156._lastTalkingChangedFireTime = v433
		p156._lastTalkingChangedFireValue = p157
		p156.talkingChanged:Fire(p157)
	end
end
function t2.asyncInit(p158) -- line: 2868
	-- upvalues: v31 (copy), Promise (copy), Constants (copy), FFlagEnablePartyVoiceChangersInLua (copy), v33 (copy)
	if p158.service then
		v31:trace("Manager already initialized")

		return Promise.resolve()
	end

	if not p158.initPromise then
		p158.initPromise = p158:_asyncInit()

		if p158.AdService then
			local function setupRewardedAdMuting(p159) -- line: 2878
				-- upvalues: Constants (copy)
				local u535 = false

				p159.AdService.RewardedVideoAdStarted:Connect(function() -- line: 2880
					-- upvalues: p159 (copy), u535 (ref), Constants (copy)
					if p159.localMuted == nil then
						return
					end

					u535 = p159.localMuted

					if not p159.localMuted then
						p159:ToggleMic(Constants.REWARDED_VIDEO_AD_STARTED)
					end

					p159.isPlayerWatchingAd = true
				end)
				p159.AdService.RewardedVideoAdEnded:Connect(function() -- line: 2896
					-- upvalues: p159 (copy), u535 (ref), Constants (copy)
					if p159.localMuted == nil then
						return
					end

					p159.isPlayerWatchingAd = false

					if u535 ~= p159.localMuted then
						p159:ToggleMic(Constants.REWARDED_VIDEO_AD_ENDED)
					end
				end)
			end

			setupRewardedAdMuting(p158)
		end

		if FFlagEnablePartyVoiceChangersInLua and not p158.voiceChangerWasToggledEvent then
			task.spawn(function() -- line: 2916
				-- upvalues: p158 (copy), v33 (copy)
				local VoiceChangerWasToggledEvent = p158:GetVoiceChangerWasToggledEvent()

				if VoiceChangerWasToggledEvent then
					VoiceChangerWasToggledEvent.OnClientEvent:Connect(function(n8: number, b9: boolean) -- line: 2920
						-- upvalues: v33 (copy), p158 (copy)
						local v545 = if not v33 then p158.participants[n8] else p158.participants[tostring(n8)]

						if v545 then
							v545.isVoiceChangerActive = b9
							p158.voiceChangerActivePlayers[n8] = b9
							p158.participantsUpdate:Fire(p158.participants)
						end
					end)
				end
			end)
		end
	end

	return p158.initPromise
end
function t2.IsInitialized(p160) -- line: 2940
	if p160.service then
		return true
	end

	return false
end
function t2.ensureInitialized(p161, p162) -- line: 2944
	if not p161.service then
		error("[corescripts VCS Manager] " .. "Attempting to " .. p162 .. " before calling init")
	end
end
function t2.GetSessionId(p163) -- line: 2951
	p163:ensureInitialized("get session id")

	return p163.service:GetSessionId()
end
function t2.GetChannelId(p164) -- line: 2956
	p164:ensureInitialized("get channel id")

	return p164.service:GetChannelId()
end
function t2.Disconnect(p165) -- line: 2961
	-- upvalues: v74 (copy)
	if p165.participantConnection then
		p165.participantConnection:Disconnect()
		p165.participantConnection = nil
	end

	if p165.stateConnection then
		p165.stateConnection:Disconnect()
		p165.stateConnection = nil
	end

	if p165.micConnection then
		p165.micConnection:Disconnect()
		p165.micConnection = nil
	end

	if p165.blockConnection then
		p165.blockConnection:Disconnect()
		p165.blockConnection = nil
	end

	if p165.playerModeratedConnection then
		p165.playerModeratedConnection:Disconnect()
		p165.playerModeratedConnection = nil
	end

	if p165.voiceToxicityModalConnection then
		p165.voiceToxicityModalConnection:Disconnect()
		p165.voiceToxicityModalConnection = nil
	end

	if p165.VoiceToxicityToastConnection then
		p165.VoiceToxicityToastConnection:Disconnect()
		p165.VoiceToxicityToastConnection = nil
	end

	if p165.voiceReverseNudgeConnection then
		p165.voiceReverseNudgeConnection:Disconnect()
		p165.voiceReverseNudgeConnection = nil
	end

	if p165.tempSetMicMutedToggleMicConnection then
		p165.tempSetMicMutedToggleMicConnection:Disconnect()
		p165.tempSetMicMutedToggleMicConnection = nil
	end

	if v74 and p165.videoCaptureInProgressConnection then
		p165.videoCaptureInProgressConnection:Disconnect()
		p165.videoCaptureInProgressConnection = nil
	end
end
function t2.RequestHidePublicVoiceUI(p166) -- line: 3012
	task.defer(function() -- line: 3013
		-- upvalues: p166 (copy)
		p166.setVoiceUIVisibility:Fire(false)
	end)
end
function t2.RequestShowPublicVoiceUI(p167) -- line: 3018
	task.defer(function() -- line: 3019
		-- upvalues: p167 (copy)
		p167.setVoiceUIVisibility:Fire(true)
	end)
end

t2.default = t2.new(BlockingUtility:GetAfterBlockedStatusChangedEvent(), PermissionsProtocol.default, HttpRbxApiService, nil, nil, nil, nil, nil, ThirdPartyUserService, nil, AdService)

if v68 and EngineFeature then
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		LocalPlayer.AncestryChanged:Connect(function(_, parent) -- line: 3046
			-- upvalues: t2 (copy)
			if parent == nil then
				t2.default:ReportVoiceVolumeImpressionsIfNeeded()
			end
		end)
	end
end

return t2
