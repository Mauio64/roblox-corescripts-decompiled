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
local EngineFeature3 = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFFlagEnableVoiceChatMuteForVideoCaptures = require(scriptParentParent.SharedFlags).GetFFlagEnableVoiceChatMuteForVideoCaptures
local v73 = v41 and GetFFlagEnableVoiceChatMuteForVideoCaptures()
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
local v94 = if not GetFFlagAvatarChatServiceEnabled() then nil else game:GetService("AvatarChatService")
local v95 = if not GetFFlagEnableVoiceChatMuteForVideoCaptures() then nil else game:GetService("CaptureService")
local v96 = if not v73 then nil else game:GetService("TelemetryService")
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
	AvatarChatService = v94,
	HttpRbxApiService = HttpRbxApiService,
	ThirdPartyUserService = ThirdPartyUserService,
	CaptureService = v95,
	TelemetryService = v96,
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

function t2.new(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) -- line: 311
	-- upvalues: Utils (copy), Analytics (copy), AppStorageService (copy), t2 (copy), WATCHED_MESSAGE_TYPES (copy), GetFIntThrottleParticipantsUpdateMs (copy), Players2 (copy), v31 (copy), IXPServiceWrapper (copy), v60 (copy), v61 (copy)
	local v115 = setmetatable({
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

	for _, v117 in WATCHED_MESSAGE_TYPES do
		v115.SignalREventTable[v117] = Instance.new("BindableEvent")
	end

	v115.shouldThrottleParticipantUpdate = false
	v115.participantsStateThrottleTime = 0
	v115.lastParticipantsStateUpdate = 0
	v115.lastStateUpdateCounter = 0

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		task.spawn(function() -- line: 353
			-- upvalues: Players2 (copy), p4 (copy), v31 (copy), IXPServiceWrapper (copy), v60 (copy)
			local ok, result = pcall(function() -- line: 354
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
		v115.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000

		local ok, result = pcall(function() -- line: 370
			-- upvalues: IXPServiceWrapper (copy), v60 (copy)
			return IXPServiceWrapper:GetLayerData(v60)
		end)

		if ok and result and result[v61] then
			v115.shouldThrottleParticipantUpdate = true
		end
	end

	return v115
end
function t2.emit(t3: {[any]: any}, s1: string, ...) -- line: 381
	t3.eventEmitter:emit(s1, ...)
end
function t2.subscribe(t4: {[any]: any}, s2: string, p12) -- line: 385
	t4.eventEmitter:addListener(s2, p12)
end
function t2.unsubscribeAll(p13) -- line: 389
	p13.eventEmitter:removeAllListeners()
end
function t2.CheckCallStateWithPromise(p14) -- line: 393
	-- upvalues: default (copy), v31 (copy), Enums (copy)
	return default:getCallState():andThen(function(p15) -- line: 395
		-- upvalues: v31 (copy), Enums (copy), p14 (copy)
		v31:trace("Got user call state")

		if p15.status ~= Enums.CallStatus.Idle.rawValue() and p15.status ~= Enums.CallStatus.Ringing.rawValue() then
			p14.isInCall = true
			p14.callMutedState = p15.muted
			v31:trace("Changing call muted state to {}", p15.muted)
		end
	end):catch(function(p16) -- line: 407
		-- upvalues: v31 (copy)
		v31:trace("User not in call {}", p16)
	end)
end
function t2.CheckCallState(p17) -- line: 413
	-- upvalues: v31 (copy), default (copy), Enums (copy)
	v31:trace("Checking user call state")

	local ok, result = pcall(function() -- line: 415
		-- upvalues: default (copy), v31 (copy), Enums (copy), p17 (copy)
		default:getCallState():andThen(function(p18) -- line: 417
			-- upvalues: v31 (copy), Enums (copy), p17 (copy)
			v31:trace("Got user call state")

			if p18.status ~= Enums.CallStatus.Idle.rawValue() and p18.status ~= Enums.CallStatus.Ringing.rawValue() then
				p17.isInCall = true
				p17.callMutedState = p18.muted
				v31:trace("Changing call muted state to {}", p18.muted)
			end
		end):catch(function(p19) -- line: 429
			-- upvalues: v31 (copy)
			v31:trace("User not in call {}", p19)
		end)
	end)

	if not ok then
		v31:debug("Error checking user call state {}", result)
	end
end
function t2._GetShowAgeVerificationOverlay(p20, p21) -- line: 448
	-- upvalues: GetShowAgeVerificationOverlay (copy), Utils (copy)
	return GetShowAgeVerificationOverlay(Utils.bind(p20, "GetRequest"), tostring(game.GameId), tostring(game.PlaceId), p21)
end
function t2.FetchAgeVerificationOverlay(p22, p23) -- line: 457
	-- upvalues: Promise (copy)
	if not p22._getShowAgeVerificationOverlayResult then
		if not p22._getShowAgeVerificationOverlayPromise then
			p22._getShowAgeVerificationOverlayPromise = Promise.new(function(resolve, _) -- line: 460
				-- upvalues: p22 (copy), p23 (copy)
				p22._getShowAgeVerificationOverlayResult = p22:_GetShowAgeVerificationOverlay(p23)
				resolve(p22._getShowAgeVerificationOverlayResult)
			end)
		end

		p22._getShowAgeVerificationOverlayPromise:await()
	end

	return p22._getShowAgeVerificationOverlayResult
end
function t2._GetShowPhoneVerificationUpsell(t5: {[any]: any}, s3: string, n1: number?) -- line: 476
	-- upvalues: GetShowPhoneVerificationUpsell (copy), Utils (copy)
	return (GetShowPhoneVerificationUpsell(Utils.bind(t5, "GetRequest"), tostring(game.GameId), s3, n1))
end
function t2.FetchPhoneVerificationUpsell(t6: {[any]: any}, s4: string, n2: number?, b1: boolean?) -- line: 489
	-- upvalues: Promise (copy), Constants (copy)
	if not t6._getShowPhoneVerificationUpsellResult then
		t6._getShowPhoneVerificationUpsellResult = {}
		t6._getShowPhoneVerificationUpsellPromise = {}
	end

	if not t6._getShowPhoneVerificationUpsellResult[s4] or b1 then
		if not t6._getShowPhoneVerificationUpsellPromise[s4] or b1 then
			t6._getShowPhoneVerificationUpsellPromise[s4] = Promise.new(function(resolve, _) -- line: 500
				-- upvalues: t6 (copy), s4 (copy), n2 (copy), Constants (copy)
				local v452 = t6:_GetShowPhoneVerificationUpsell(s4, n2)

				t6._getShowPhoneVerificationUpsellResult[s4] = if type(v452) ~= "table" or v452.valueProp == nil then Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None else v452.valueProp
				resolve()
			end)
		end

		t6._getShowPhoneVerificationUpsellPromise[s4]:await()
	end

	return t6._getShowPhoneVerificationUpsellResult[s4]
end
function t2.DisablePhoneVerificationUpsell(p26) -- line: 514
	-- upvalues: Cryo (copy), Constants (copy)
	p26._getShowPhoneVerificationUpsellResult = Cryo.Dictionary.map(p26._getShowPhoneVerificationUpsellResult, function() -- line: 517
		-- upvalues: Constants (copy)
		return Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None
	end)
end
function t2.GetNudgeAnalyticsData(p27) -- line: 523
	-- upvalues: Players (copy)
	return Players.LocalPlayer.UserId, p27:GetSessionId()
end
function t2.avatarChatUserAndPlaceSettingsValueOfClientFeatures(p28, p29) -- line: 528
	-- upvalues: GetFFlagEnableVoiceSignal (copy)
	local t7 = {
		isUniverseEnabledForVoice = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UniverseAudio),
		isPlaceEnabledForVoice = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.PlaceAudio),
		isUniverseEnabledForAvatarVideo = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UniverseVideo),
		isPlaceEnabledForAvatarVideo = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.PlaceVideo)
	}
	local t8 = {
		bannedUntil = nil,
		isUserEligible = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UserAudioEligible),
		isVoiceEnabled = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UserAudio),
		isAvatarVideoEligible = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UserVideoEligible),
		isAvatarVideoEnabled = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UserVideo),
		isUserVerifiedForVoice = if not GetFFlagEnableVoiceSignal() then nil else p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UserVerifiedForVoice),
		isBanned = p28.AvatarChatService:IsEnabled(p29, Enum.AvatarChatServiceFeature.UserBanned)
	}

	return {
		universePlaceVoiceEnabledSettings = t7,
		voiceSettings = t8
	}
end
function t2.resolveAvatarChatUserAndPlaceSettings(p30) -- line: 575
	local ok, result = pcall(p30.AvatarChatService.GetClientFeaturesAsync, p30.AvatarChatService)

	if not ok then
		return nil
	end

	return p30:avatarChatUserAndPlaceSettingsValueOfClientFeatures(result)
end
function t2.GetRequest(p31, p32, _) -- line: 585
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 586
		-- upvalues: p31 (copy), p32 (copy), HttpService (copy)
		local AsyncFullUrl = p31.HttpRbxApiService:GetAsyncFullUrl(p32, Enum.ThrottlingPriority.Default, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(AsyncFullUrl)
	end)

	return ok and result
end
function t2.PostUserVoiceConnectionStatus(p34, p35) -- line: 594
	-- upvalues: HttpService (copy), Constants (copy)
	local ok, _ = pcall(function() -- line: 595
		-- upvalues: HttpService (copy), p35 (copy), p34 (copy), Constants (copy)
		local json = HttpService:JSONEncode({
			IsUserVoiceConnected = p35
		})
		local v455 = p34.HttpRbxApiService:PostAsyncFullUrl(Constants.VOICE_URL .. "/v1/user-voice-connection-state", json)

		return HttpService:JSONDecode(v455)
	end)

	return ok
end
function t2.GetVoiceAnalyticsData(p36) -- line: 604
	-- upvalues: EngineFeature3 (copy), RbxAnalyticsService (copy)
	return {
		micAvailability = "",
		universeId = game.GameId,
		placeId = game.PlaceId,
		playSessionId = not EngineFeature3 and "" or RbxAnalyticsService:GetPlaySessionId(),
		voiceSessionId = not p36.service and "" or p36:GetSessionId()
	}
end
function t2.RecordExperienceJoinMicPermissionStatus(p37, p38) -- line: 616
	-- upvalues: PermissionsProtocol (copy), PERMISSION_STATE (copy)
	local VoiceAnalyticsData = p37:GetVoiceAnalyticsData()

	if p38 ~= nil and typeof(p38) == "table" then
		if p38.status == PermissionsProtocol.Status.AUTHORIZED then
			VoiceAnalyticsData.micAvailability = "Granted"
		else
			VoiceAnalyticsData.micAvailability = "Denied"
		end
	elseif p37.permissionState then
		if p37.permissionState == PERMISSION_STATE.LISTEN_AND_TALK then
			VoiceAnalyticsData.micAvailability = "Granted"
		else
			VoiceAnalyticsData.micAvailability = "Denied"
		end
	end

	p37.Analytics:reportVoiceEvents("experienceJoinDeviceMicPermissionEvent", VoiceAnalyticsData)
end
function t2.CheckCaptureMute(p39) -- line: 636
	-- upvalues: GetFFlagEnableVoiceChatMuteForVideoCaptures (copy)
	if GetFFlagEnableVoiceChatMuteForVideoCaptures() then
		return p39.CaptureService:IsCapturingVideo()
	end

	return false
end
function t2.ToggleMuteSome(t9: {[any]: any}, t10: {[any]: any}, b2: boolean, s5: string, s6: string) -- line: 645
	-- upvalues: VoiceChatService (copy), EngineFeature2 (copy), Players (copy)
	t9:ensureInitialized("mute some players")
	t9._mutedAnyone = true

	local t11 = {}
	local v170 = b2 or t9:CheckCaptureMute()

	for _, v172 in t10 do
		if VoiceChatService.UseNewAudioApi then
			t11[v172] = true
			t9.mutedPlayers[v172] = v170
		else
			t9.service:SubscribePause(v172, v170)
		end

		local v173 = t9.participants[tostring(v172)]

		if v173 then
			v173.isMutedLocally = v170
			t9.participantsUpdate:Fire(t9.participants)
		end
	end

	if VoiceChatService.UseNewAudioApi then
		for v174 in t9.audioDevices do
			if v174.Player and t11[v174.Player.UserId] then
				if EngineFeature2 and v174.Player ~= Players.LocalPlayer then
					v174.MutedByLocalUser = v170
				else
					if not EngineFeature2 then
					end

					v174.Active = not v170
				end
			end
		end
	end

	if s5 and s6 then
		t9.Analytics:reportVoiceMuteGroup((t9:JoinWithVoiceMuteData({
			groupType = s5,
			context = s6,
			muted = v170
		})))
	end
end
function t2.GetMutedAnyone(p40) -- line: 690
	return p40._mutedAnyone
end
function t2.RecordGameSettingsOpened(p41) -- line: 694
	-- upvalues: v68 (copy), EngineFeature (copy)
	if v68 and (EngineFeature and p41._voiceJoinTimestampMs and not p41._gameSettingsOpenedTimestampMs) then
		p41._gameSettingsOpenedTimestampMs = DateTime.now().UnixTimestampMillis
	end
end
function t2.ResetVoiceVolumeImpressionsSession(p42) -- line: 705
	-- upvalues: v68 (copy), EngineFeature (copy)
	if v68 and EngineFeature then
		p42._voiceJoinTimestampMs = nil
		p42._voiceVolumeSliderEligibleAtJoin = false
		p42._gameSettingsOpenedTimestampMs = nil
	end
end
function t2.ReportVoiceVolumeImpressionsIfNeeded(p43) -- line: 716
	-- upvalues: v68 (copy), EngineFeature (copy)
	if not v68 or (not EngineFeature or not p43._voiceJoinTimestampMs or not p43._voiceVolumeSliderEligibleAtJoin) then
		return
	end

	local v179 = p43._gameSettingsOpenedTimestampMs ~= nil
	local VoiceAnalyticsData = p43:GetVoiceAnalyticsData()

	p43.Analytics:reportVoiceVolumeImpressions({
		playSessionId = VoiceAnalyticsData.playSessionId,
		voiceSessionId = VoiceAnalyticsData.voiceSessionId,
		sliderSeen = v179,
		voiceJoinTimestampMs = p43._voiceJoinTimestampMs,
		sliderSeenTimestampMs = p43._gameSettingsOpenedTimestampMs
	})
	p43:ResetVoiceVolumeImpressionsSession()
end
function t2.ToggleMutePlayer(t12: {[any]: any}, n3: number, s7: string) -- line: 738
	-- upvalues: VoiceChatService (copy), v31 (copy), Utils (copy), GetFFlagEnableFtuxExitOnMuteToggle (copy), EngineFeature2 (copy), Players (copy)
	t12:ensureInitialized("mute player " .. n3)
	t12._mutedAnyone = true

	local v184 = ((if not VoiceChatService.UseNewAudioApi then not t12.service:IsSubscribePaused(n3) else not t12.mutedPlayers[n3])) or t12:CheckCaptureMute()

	v31:trace("Setting mute for {} to {}", Utils.shorten(n3), v184)

	if GetFFlagEnableFtuxExitOnMuteToggle() then
		t12.onPlayerMuteToggled:Fire()
	end

	if VoiceChatService.UseNewAudioApi then
		t12.mutedPlayers[n3] = v184

		for v185 in t12.audioDevices do
			if v185.Player and n3 == v185.Player.UserId then
				if EngineFeature2 and v185.Player ~= Players.LocalPlayer then
					v185.MutedByLocalUser = v184
				else
					if not EngineFeature2 then
					end

					local v186 = t12.participants[tostring(n3)]
					local v187 = v186 and not v186.isMuted

					v185.Active = not v184 and v187
				end
			end
		end

		t12:emit("OnPlayerMuted")
	else
		t12.service:SubscribePause(n3, v184)
	end

	for _, v in pairs(t12.participants) do
		if n3 == v.userId then
			v.isMutedLocally = v184
			t12.participantsUpdate:Fire(t12.participants)
		end
	end

	if s7 then
		t12.Analytics:reportVoiceMuteIndividual((t12:JoinWithVoiceMuteData({
			targetUserId = tonumber(n3),
			context = s7,
			muted = v184
		})))
	end
end
function t2.MuteAll(t13: {[any]: any}, b3: boolean, s8: string) -- line: 792
	-- upvalues: VoiceChatService (copy), v31 (copy), Players (copy), EngineFeature2 (copy), Constants (copy)
	t13:ensureInitialized("mute all")
	t13._mutedAnyone = true

	local v193 = b3 or t13:CheckCaptureMute()

	if VoiceChatService.UseNewAudioApi then
		t13.muteAll = v193
		v31:trace("Setting self mute all to {} context: {}", v193, s8)

		for v194 in t13.audioDevices do
			if v194.Player and v194.Player ~= Players.LocalPlayer then
				v31:debug("Local muting {} to '{} = {}'", v194.Player.Name, v194.Active, v193)

				if EngineFeature2 then
					v194.MutedByLocalUser = v193
				else
					local UserId = v194.Player.UserId

					t13.mutedPlayers[UserId] = v193

					local v196 = t13.participants[tostring(UserId)]
					local v197 = v196 and not v196.isMuted

					v194.Active = not v193 and v197
				end
			end
		end
	else
		t13.service:SubscribePauseAll(v193)
	end

	for _, v in pairs(t13.participants) do
		v.isMutedLocally = v193
		t13.participantsUpdate:Fire(t13.participants)
	end

	t13.muteAllChanged:Fire(v193)

	if s8 then
		t13.Analytics:reportVoiceMuteGroup((t13:JoinWithVoiceMuteData({
			groupType = Constants.VOICE_GROUP_TYPE.ALL,
			context = s8,
			muted = v193
		})))
	end
end
function t2.FetchVoicePermissions(p44) -- line: 835
	if not p44.communicationPermissionsResult then
		p44.communicationPermissionsResult = p44:resolveAvatarChatUserAndPlaceSettings()
	end

	return p44.communicationPermissionsResult
end
function t2.verifyUniverseAndPlaceCanUseVoice(p45) -- line: 843
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), Analytics (copy)
	local v202 = if not GetFFlagAvatarChatServiceEnabled() or not GetFFlagVoiceChatServiceManagerUseAvatarChat() then p45:FetchAgeVerificationOverlay() else p45:resolveAvatarChatUserAndPlaceSettings()

	if not v202 then
		p45:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	local universePlaceVoiceEnabledSettings = v202.universePlaceVoiceEnabledSettings

	return universePlaceVoiceEnabledSettings and (universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice and universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice)
end
function t2.IsUserInFTUX(p46) -- line: 863
	-- upvalues: GetFFlagSeamlessVoiceFTUX (copy), GetFFlagCheckUniversePlaceBeforeSuspending (copy), v31 (copy)
	if not GetFFlagSeamlessVoiceFTUX() then
		return false
	end

	if GetFFlagCheckUniversePlaceBeforeSuspending() and not p46:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local AppStorageService2 = game:GetService("AppStorageService")
	local u206 = nil

	if not pcall(function() -- line: 873
		-- upvalues: AppStorageService2 (copy), u206 (ref)
		u206 = AppStorageService2:GetItem("SeamlessVoiceFTUX") == "true"
	end) then
		v31:warning("Failed to read FTUX/STUX from AppStorage")

		return false
	end

	local v207 = p46:FetchAgeVerificationOverlay()

	if type(v207) == "table" and v207.voiceSettings and v207.voiceSettings.seamlessVoiceStatus ~= 3 then
		v31:debug("User not eligible for FTUX/STUX")

		return false
	end

	return not u206
end
function t2.isEnableDefaultVoiceOnForPlace(_) -- line: 896
	-- upvalues: VoiceChatService (copy)
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	return VoiceChatService.UseNewAudioApi or VoiceChatService.EnableDefaultVoice
end
function t2.verifyPlaceCanUseVoice(p48, p49, p50) -- line: 907
	-- upvalues: Analytics (copy)
	if not p49 or not p50 then
		p48:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	if not p49.isUniverseEnabledForVoice then
		p48:_reportJoinFailed("universeNotEnabled")

		return false
	end

	p48:emit("OnUserAndPlaceCanUseVoiceResolved", p50, p49)

	if not p49.isPlaceEnabledForVoice then
		p48:_reportJoinFailed("placeNotEnabled")

		return false
	end

	if not p48:isEnableDefaultVoiceOnForPlace() then
		return false
	end

	return true
end
function t2.EligibleForFaeUpsell(p51) -- line: 932
	-- upvalues: FAE_ENABLED (copy)
	local v213 = p51:FetchAgeVerificationOverlay()

	if not v213 or type(v213) ~= "table" then
		return false
	end

	local v214 = v213.inExperienceFaeUpsell == FAE_ENABLED
	local isPlaceEnabledForVoice = v213.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice

	return v214 and isPlaceEnabledForVoice
end
function t2.OptUserToJoinVoice(p52) -- line: 942
	-- upvalues: v31 (copy)
	v31:debug("Opting user to join voice on age verification")
	p52.hasOptedToJoinVoiceOnAgeVerification = true
end
function t2.SetupFAECompleteListener(p53) -- line: 947
	-- upvalues: v31 (copy)
	v31:debug("Setting up FAE complete listener")

	if game:GetEngineFeature("ChatReconcileAccess") then
		v31:debug("Using ChatService ReconcileCommunicationAccessCompleted event")
		p53.ChatService.ReconcileCommunicationAccessCompleted:Connect(function() -- line: 951
			-- upvalues: v31 (copy), p53 (copy)
			v31:debug("FAE complete listener triggered, re-fetching voice permissions")
			p53.communicationPermissionsResult = nil
			p53:FetchVoicePermissions()
			p53._getShowAgeVerificationOverlayResult = p53:_GetShowAgeVerificationOverlay()

			if p53.hasOptedToJoinVoiceOnAgeVerification then
				v31:debug("FAE complete listener triggered, attempting voice rejoin")

				if p53:IsSeamlessVoice() then
					v31:debug("Opting-in user to voice")
					p53.AvatarChatService:EnableVoice()
					p53.attemptVoiceRejoin:Fire()
				end
			end
		end)
	end
end
function t2.EligibleForAgeCheckToast(p54) -- line: 971
	-- upvalues: FAE_SETTINGS_TOAST (copy)
	local v219 = p54:FetchAgeVerificationOverlay()

	if not v219 or type(v219) ~= "table" then
		return false
	end

	local isPlaceEnabledForVoice = v219.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	local v221 = v219.inExperienceFaeUpsell == FAE_SETTINGS_TOAST

	return isPlaceEnabledForVoice and (p54:isEnableDefaultVoiceOnForPlace() and v221)
end
function t2.userAndPlaceCanUseVoice(p55) -- line: 981
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), GetShowAgeVerificationOverlay (copy), Utils (copy), Analytics (copy), v31 (copy), GetFFlagEnableVoiceSignal (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), Constants (copy), VOICE_JOIN_PROGRESS (copy), GetFFlagEnableVoiceUxUpdates (copy), GetFFlagNonVoiceFTUX (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if p55.ThirdPartyUserService ~= nil and (p55.ThirdPartyUserService:IsChatRestrictionSupported() and p55.ThirdPartyUserService:GetVoiceChatRestrictionStatus() ~= Enum.ChatRestrictionStatus.NotRestricted) then
		return false
	end

	local v223 = if not GetFFlagAvatarChatServiceEnabled() or not GetFFlagVoiceChatServiceManagerUseAvatarChat() then GetShowAgeVerificationOverlay(Utils.bind(p55, "GetRequest"), tostring(game.GameId), (tostring(game.PlaceId))) else p55:resolveAvatarChatUserAndPlaceSettings()

	if not v223 then
		p55:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	if p55.options.forceVoiceEnabled then
		v223.voiceSettings.isVoiceEnabled = true
		v31:debug("bypassing voice permissions check")
	end

	local universePlaceVoiceEnabledSettings = v223.universePlaceVoiceEnabledSettings
	local voiceSettings = v223.voiceSettings

	v31:trace("Voice settings endpoint returned {}", v223)

	if not p55:verifyPlaceCanUseVoice(universePlaceVoiceEnabledSettings, voiceSettings) then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		p55.communicationPermissionsResult = v223

		local v226 = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and os.time()
		local v227 = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and (not p55:UserVoiceEnabled() and (not voiceSettings.isUserVerifiedForVoice and (p55:FetchPhoneVerificationUpsell(Constants.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat or v226 and p55:FetchPhoneVerificationUpsell(Constants.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER, v226) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat)))

		if p55:UserEligibleForInExperienceUpsell() or v227 then
			p55:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
		end

		if GetFFlagEnableVoiceUxUpdates() then
			local VoiceConnectCookie = p55:GetVoiceConnectCookie()
			local v229 = p55:HasSeamlessVoiceFeature(Constants.SeamlessVoiceFeatures.DeferConnection) and VoiceConnectCookie == ""
			local v230 = p55:IsSeamlessVoice() and VoiceConnectCookie == "false"

			if v229 or v230 then
				p55:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif p55:EligibleForFaeUpsell() then
				v31:debug("Suspending voice join for FAE Eligible user")
				p55:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
				p55:SetupFAECompleteListener()
			end
		else
			if GetFFlagNonVoiceFTUX() and p55:IsUserInFTUX() then
				p55:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			end

			if p55:IsSeamlessVoice() and not p55:GetVoiceConnectCookieValue() then
				v31:debug("Suspending voice join due to voice connect cookie")
				p55:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif GetFFlagEnableSeamlessVoiceV2() and p55:IsNewSeamlessVoiceUserDisconnect() then
				v31:debug("Suspending voice join for new seamless voice user")
				p55:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif p55:IsSeamlessVoice() and p55:UserOnlyEligibleForVoice() then
				v31:debug("Suspending voice join for opt-out user")
				p55:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			end
		end

		task.spawn(function() -- line: 1078
			-- upvalues: p55 (copy)
			p55:FetchAgeVerificationOverlay()
		end)
	end

	if not voiceSettings.isVoiceEnabled then
		p55:_reportJoinFailed("userNotEnabled")
	end

	return voiceSettings.isVoiceEnabled
end
function t2.voicePermissionGranted(_, p57) -- line: 1093
	-- upvalues: PermissionsProtocol (copy), Cryo (copy)
	if typeof(p57) == "table" then
		return p57.status == PermissionsProtocol.Status.AUTHORIZED or not Cryo.List.find(p57.missingPermissions, PermissionsProtocol.Permissions.MICROPHONE_ACCESS)
	end

	return p57 == PermissionsProtocol.Status.AUTHORIZED
end
function t2.RawGetPermissions(p58, p59) -- line: 1113
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 1114
		-- upvalues: p58 (copy), p59 (copy)
		p58:emit("GetPermissions", function(p61) -- line: 1115
			-- upvalues: resolve (copy)
			resolve(p61)
		end, p59, true, true)
	end)
end
function t2.requestMicPermission(p62) -- line: 1122
	-- upvalues: v31 (copy), PermissionsProtocol (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), Promise (copy), GetFFlagEnableExpJoinMicPermAnalytics (copy), Analytics (copy)
	if p62.permissionPromise then
		v31:trace("PermissionProtocol already invoked")

		return p62.permissionPromise
	end

	local t14 = { PermissionsProtocol.Permissions.MICROPHONE_ACCESS }
	local v240

	if not GetFFlagEnableSeamlessVoiceV2() and GetFFlagJoinWithoutMicPermissions(p62:IsSeamlessVoice()) then
		v31:debug("Requesting device permission")

		local ok, result, v239 = pcall(function() -- line: 1136
			-- upvalues: p62 (copy), t14 (copy)
			return p62:RawGetPermissions(t14):await()
		end)

		if ok and result then
			if v239.status == PermissionsProtocol.Status.AUTHORIZED then
				p62.permissionState = PERMISSION_STATE.LISTEN_AND_TALK
			elseif v239.missingPermissions then
				p62.permissionState = PERMISSION_STATE.PENDING_MIC
			elseif v239.deniedPermissions then
				p62.permissionState = PERMISSION_STATE.LISTEN_ONLY
			else
				v31:error("PermissionsService returned unknown permission state. Defaulting to listen only.")
				p62.permissionState = PERMISSION_STATE.LISTEN_ONLY
			end
		else
			v31:error("PermissionsService call failed.")
			p62.permissionState = PERMISSION_STATE.LISTEN_ONLY
		end

		v31:debug("Joining without mic permissions. Permission State: {}", p62.permissionState)
		v240 = Promise.resolve()
	else
		v240 = p62.PermissionsService:requestPermissions(t14)
	end

	p62.permissionPromise = v240:andThen(function(p63) -- line: 1165
		-- upvalues: GetFFlagEnableExpJoinMicPermAnalytics (copy), p62 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), Promise (copy), v31 (copy), Analytics (copy), PermissionsProtocol (copy)
		if GetFFlagEnableExpJoinMicPermAnalytics() then
			p62:RecordExperienceJoinMicPermissionStatus(p63)
		end

		if not GetFFlagEnableSeamlessVoiceV2() and GetFFlagJoinWithoutMicPermissions() then
			return Promise.resolve()
		end

		if not p63 and not p63.status then
			v31:debug("No permission response, rejecting access")
			p62:_reportJoinFailed("noPermissionResponse", Analytics.ERROR)

			if p62.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_NO_PERM_RESPONSE"
				})
			end

			return Promise.reject()
		end

		v31:debug("Permission status {}", p63.status)

		local v459 = p63.status == PermissionsProtocol.Status.AUTHORIZED

		if p62.options.passInitErrorInPromiseReject and not v459 then
			return Promise.reject({
				code = "INIT_ERROR_PERM_NOT_GRANTED"
			})
		end

		return v459 and Promise.resolve() or Promise.reject()
	end):andThen(function() -- line: 1189
		-- upvalues: p62 (copy), Promise (copy)
		p62:emit("OnRequestMicPermissionResolved")

		return Promise.resolve()
	end):catch(function() -- line: 1194
		-- upvalues: p62 (copy), Promise (copy)
		p62:emit("OnRequestMicPermissionRejected")

		if p62.options.passInitErrorInPromiseReject then
			return Promise.reject({
				code = "INIT_ERROR_MIC_PERM_REJECTED"
			})
		end

		return Promise.reject()
	end)

	return p62.permissionPromise
end
function t2.JoinByGroupIdToken(p64, p65, p66) -- line: 1204
	p64.previousGroupId = p65
	p64.previousMutedState = p66

	return p64.service:JoinByGroupIdToken(p65, p66)
end
function t2.EnableVoice(p67) -- line: 1210
	-- upvalues: v31 (copy)
	v31:trace("Enabling voice")
	p67.AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Once(function() -- line: 1213
		-- upvalues: p67 (copy)
		p67.attemptVoiceRejoin:Fire()
	end)
	p67.AvatarChatService:EnableVoice()
end
function t2.ChangeVoiceJoinProgress(p68, p69) -- line: 1219
	p68.VoiceJoinProgress = p69
	p68.VoiceJoinProgressChanged:Fire(p68.VoiceJoinProgress)
end
function t2.setOptions(t15: {[any]: any}, t16: {[any]: any}) -- line: 1224
	t15.options = t16
end
function t2.ShouldShowJoinVoiceOnDisconnect(p70) -- line: 1228
	-- upvalues: VOICE_JOIN_PROGRESS (copy)
	return p70:IsSeamlessVoice() and p70.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended
end
function t2.IsSeamlessVoice(p71) -- line: 1232
	-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagCheckUniversePlaceBeforeSuspending (copy), Constants (copy)
	if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and not p71.options.allowSeamlessVoice then
		return false
	end

	local v251 = p71:FetchAgeVerificationOverlay()

	if type(v251) ~= "table" or not v251 or not v251.voiceSettings then
		return false
	end

	if GetFFlagCheckUniversePlaceBeforeSuspending() and not p71:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local seamlessVoiceStatus = v251.voiceSettings.seamlessVoiceStatus

	return seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledExistingUser or seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledNewUser
end
function t2.HasSeamlessVoiceFeature(p72, p73) -- line: 1254
	-- upvalues: GetFFlagEnableSeamlessVoiceFeature (copy), Utils (copy), Constants (copy)
	if not p72.options.allowSeamlessVoice or not p72:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local v255 = p72:FetchAgeVerificationOverlay()

	if not p72:_isValidAgeVerificationOverlayData(v255) then
		return false
	end

	local seamlessVoiceVariant = v255.voiceSettings.seamlessVoiceVariant

	if not seamlessVoiceVariant then
		return false
	end

	if GetFFlagEnableSeamlessVoiceFeature() then
		if type(p73) == "string" then
			p73 = { p73 }
		end

		if GetFFlagEnableSeamlessVoiceFeature(p73) then
			local v257 = Utils.jsonDecode(seamlessVoiceVariant)
			local t17 = {}

			for _, v in pairs(v257) do
				t17[v] = true
			end

			if #p73 == 1 and p73[1] == Constants.SeamlessVoiceFeatures.ConnectDisconnect and seamlessVoiceVariant == Constants.SeamlessVoiceVariants.OnlyConnectDisconnect then
				return true
			end

			for _, v in pairs(p73) do
				if not t17[v] then
					return false
				end
			end

			return true
		end
	else
		local v263 = ({
			[Constants.SeamlessVoiceFeatures.ConnectDisconnect] = function(p74) -- line: 1299
				-- upvalues: Constants (copy)
				return p74 ~= Constants.SeamlessVoiceVariants.Control
			end,
			[Constants.SeamlessVoiceFeatures.HearingWithoutMicPermissions] = function(p75) -- line: 1302
				-- upvalues: Constants (copy)
				return p75 == Constants.SeamlessVoiceVariants.HearingWithoutMicPermissions
			end
		})[p73]

		if v263 then
			return v263(seamlessVoiceVariant)
		end
	end

	return false
end
function t2.IsNewSeamlessVoiceUserDisconnect(p76) -- line: 1316
	-- upvalues: Constants (copy)
	if not p76.options.allowSeamlessVoice or not p76:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local v265 = p76:FetchAgeVerificationOverlay()

	if not p76:_isValidAgeVerificationOverlayData(v265) then
		return false
	end

	if v265.voiceSettings.seamlessVoiceStatus ~= Constants.SeamlessVoiceStatus.EnabledNewUser then
		return false
	end

	local ok, result = pcall(function() -- line: 1335
		-- upvalues: p76 (copy), Constants (copy)
		return p76.AppStorageService:GetItem(Constants.SEAMLESS_VOICE_FTUX_KEY)
	end)

	return ok and result == "false"
end
function t2._isValidAgeVerificationOverlayData(_: {[any]: any}, t19: {[any]: any}?) -- line: 1343
	return type(t19) == "table" and (t19 and t19.voiceSettings)
end
function t2.UserInInExperienceUpsellTreatment(p77) -- line: 1347
	-- upvalues: Constants (copy)
	local v271 = p77:FetchAgeVerificationOverlay()

	if not v271 then
		return false
	end

	local showVoiceInExperienceUpsellVariant = v271.showVoiceInExperienceUpsellVariant

	return showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT1 or (showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT2 or showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT3)
end
function t2.UserOnlyEligibleForVoice(p78) -- line: 1359
	-- upvalues: v34 (copy)
	local communicationPermissionsResult = p78.communicationPermissionsResult

	if not communicationPermissionsResult or (not communicationPermissionsResult.voiceSettings or not communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		if not v34 then
			return false
		end

		p78:FetchVoicePermissions()
		communicationPermissionsResult = p78.communicationPermissionsResult
	end

	return communicationPermissionsResult.voiceSettings.isUserVerifiedForVoice and (not communicationPermissionsResult.voiceSettings.isVoiceEnabled and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice)
end
function t2.UserOnlyEligibleForVoiceViaOverlay(p79) -- line: 1375
	local v276 = p79:FetchAgeVerificationOverlay()

	if not p79:_isValidAgeVerificationOverlayData(v276) then
		return false
	end

	return v276.voiceSettings.isVerifiedForVoice and (not v276.voiceSettings.isVoiceEnabled and v276.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice)
end
function t2.UserVoiceEnabled(p80) -- line: 1388
	local communicationPermissionsResult = p80.communicationPermissionsResult

	if not communicationPermissionsResult or (not communicationPermissionsResult.voiceSettings or not communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		return false
	end

	return communicationPermissionsResult.voiceSettings.isVoiceEnabled and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
end
function t2.UserEligibleForInExperienceUpsell(p81) -- line: 1398
	-- upvalues: GetFFlagEnableVoiceSignal (copy)
	local v280 = p81:UserOnlyEligibleForVoice()

	if not v280 then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		local v281 = p81:UserInInExperienceUpsellTreatment()

		return v280 and v281
	end

	local v282 = p81:FetchAgeVerificationOverlay()

	return v280 and (v282 and v282.showVoiceInExperienceUpsell)
end
function t2.canUseServiceAsync(p82) -- line: 1419
	-- upvalues: v31 (copy), Promise (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), VOICE_CHAT_AVAILABILITY (copy), VoiceChatService (copy), v35 (copy), IXPServiceWrapper (copy), v37 (copy), v38 (copy)
	if p82.available ~= nil or not game:GetEngineFeature("VoiceChatSupported") then
		v31:debug("Voice Chat is not Available, rejecting canUseService promise")

		if p82.options.passInitErrorInPromiseReject then
			return Promise.reject({
				code = "INIT_ERROR_VOICE_NOT_SUPPORTED"
			})
		end

		return Promise.reject()
	end

	if not p82.canUseServicePromise then
		p82.canUseServicePromise = Promise.defer(function(p83, p84) -- line: 1429
			-- upvalues: p82 (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), v31 (copy), VOICE_CHAT_AVAILABILITY (copy), VoiceChatService (copy), v35 (copy), IXPServiceWrapper (copy), v37 (copy), v38 (copy)
			local v464 = p82:userAndPlaceCanUseVoice()

			if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
				p82.canUseServiceResult = v464
				p82:emit("OnCanUseServiceResult", v464)
			end

			if GetFFlagEnableVoiceSignal() and p82.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended then
				v31:debug("Place is voice enabled but user is not, delaying voice rejection")
				p82.attemptVoiceRejoin.Event:Wait()
				v31:debug("Attempting voice rejoin")
				p82.communicationPermissionsResult.voiceSettings.isVoiceEnabled = true
				p82.userEligible = true
				p82.initializedPostSuspension = true
				p83()
				p82:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joining)

				return
			end

			if not v464 then
				v31:info("Voice access denied")
				p82.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable

				if p82.options.passInitErrorInPromiseReject then
					p84({
						code = "INIT_ERROR_USER_NOT_AVAILABLE"
					})

					return
				end

				p84()

				return
			end

			if game:GetEngineFeature("VoiceChatEnabledRccProperties") and (not VoiceChatService.VoiceChatEnabledForUniverseOnRcc or not VoiceChatService.VoiceChatEnabledForPlaceOnRcc) then
				v31:debug("Disabling voice chat due to RCC Response. Universe: {}, Place: {}", VoiceChatService.VoiceChatEnabledForUniverseOnRcc, VoiceChatService.VoiceChatEnabledForPlaceOnRcc)

				if not VoiceChatService.VoiceChatEnabledForUniverseOnRcc then
					p82:_reportJoinFailed("universeNotEnabled")
				elseif not VoiceChatService.VoiceChatEnabledForPlaceOnRcc then
					p82:_reportJoinFailed("placeNotEnabled")
				end

				p82.available = VOICE_CHAT_AVAILABILITY.PlaceNotAvailable

				if p82.options.passInitErrorInPromiseReject then
					p84({
						code = "INIT_ERROR_PLACE_NOT_AVAILABLE"
					})

					return
				end

				p84()

				return
			end

			if v35 then
				IXPServiceWrapper:WaitForInitialization()

				local ok, result = pcall(function() -- line: 1489
					-- upvalues: IXPServiceWrapper (copy), v37 (copy)
					return IXPServiceWrapper:GetLayerData(v37)
				end)

				if ok and result and result[v38] ~= nil then
					p82.userEligible = result[v38]
					IXPServiceWrapper:LogUserLayerExposure(v37)
				end

				if p82.userEligible then
					p83()

					return
				end

				if p82.options.passInitErrorInPromiseReject then
					p84({
						code = "INIT_ERROR_IXP_NOT_ELIGIBLE"
					})

					return
				end

				p84()

				return
			end

			p82.userEligible = true
			p83()
		end):andThen(function() -- line: 1511
			-- upvalues: p82 (copy)
			return p82:requestMicPermission()
		end)
	end

	return p82.canUseServicePromise
end
function t2._setRecentUserState(p85, p86, p87) -- line: 1518
	-- upvalues: Cryo (copy)
	local v287 = p85.recentUsersInteractionData[tostring(p86)] or {}
	local v288 = Cryo.Dictionary.join(v287, p87)

	p85.recentUsersInteractionData = Cryo.Dictionary.join(p85.recentUsersInteractionData, {
		[tostring(p86)] = v288
	})
end
function t2.getRecentUsersInteractionData(p88) -- line: 1528
	p88:_updateRecentUsersInteractionData()

	return p88.recentUsersInteractionData
end
function t2.GetSignalREvent(p89, p90) -- line: 1533
	return p89.SignalREventTable[p90].Event
end
function t2.StartModerationSignal(p91) -- line: 1538
	-- upvalues: v31 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
	if not p91.playerModeratedConnection then
		p91.playerModeratedConnection = p91:GetSignalREvent("ParticipantModeratedFromVoice"):Connect(function() -- line: 1541
			-- upvalues: v31 (copy), p91 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
			v31:debug("User Moderated")
			p91.previousSessionId = p91.service:GetSessionId()
			p91:emit("OnPlayerModerated")

			if GetFFlagVoiceChatClientRewriteMasterLua() then
				VoiceChatService:notifyServerACSCleanup()
				VoiceChatService:leaveVoice()

				return
			end

			VoiceChatService:notifyServerACSCleanup()
			p91.service:Leave()
		end)
	end
end
function t2.StopModerationSignal(p92) -- line: 1556
	if p92.playerModeratedConnection then
		p92.playerModeratedConnection:Disconnect()
		p92.playerModeratedConnection = nil
	end
end
function t2._updateRecentUsersInteractionData(p93) -- line: 1563
	-- upvalues: v33 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), Players (copy), GetFIntVoiceUsersInteractionExpiryTimeSeconds (copy), Cryo (copy)
	local timestamp = os.time()
	local t20 = {}

	if p93.recentUsersInteractionData then
		for k, v in pairs(p93.recentUsersInteractionData) do
			local v299 = if not v33 then p93.participants[k] else p93.participants[tostring(k)]
			local v300 = GetFFlagClearUserFromRecentVoiceDataOnLeave() and not Players:GetPlayerByUserId((tonumber(k)))
			local v301 = timestamp - v.lastHeardTime >= GetFIntVoiceUsersInteractionExpiryTimeSeconds()
			local v302 = not v299 or v299.isMuted

			if v301 and v302 or v300 then
				t20[k] = Cryo.None
			end
		end

		p93.recentUsersInteractionData = Cryo.Dictionary.join(p93.recentUsersInteractionData, t20)
	end
end
function t2.SetupParticipantListeners(p94) -- line: 1587
	-- upvalues: v31 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), v33 (copy), GetFFlagFixGetPlayerByUserIdStringCast (copy), Players (copy), VoiceChatService (copy), FFlagEnablePartyVoiceChangersInLua (copy), GetFFlagBatchVoiceParticipantsUpdates (copy), v73 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v63 (copy), v64 (copy), v65 (copy), v67 (copy), GetFFlagDisconnectToastClientRewrite (copy), v68 (copy), EngineFeature (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), VoiceVolumeControlsEligibility (copy), v62 (copy), MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY (copy), GetFFlagLocalMutedNilFix (copy), v39 (copy), GetFFlagLuaConsumePlayerModerated (copy), GetFFlagEnableVoiceReverseNudge (copy), Utils (copy), t1 (copy)
	p94:ensureInitialized("setup participant listeners")

	if not p94.participants then
		p94.participants = {}
		p94.recentUsersInteractionData = {}
		p94.updatedParticipants = {}
		p94.participantConnection = p94.service.ParticipantsStateChanged:Connect(function(p95, p96, p97) -- line: 1596
			-- upvalues: v31 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), p94 (copy), v33 (copy), GetFFlagFixGetPlayerByUserIdStringCast (copy), Players (copy), VoiceChatService (copy), FFlagEnablePartyVoiceChangersInLua (copy), GetFFlagBatchVoiceParticipantsUpdates (copy), v73 (copy)
			v31:trace("Participants state changed")

			for _, v in ipairs(p95) do
				if not GetFFlagClearUserFromRecentVoiceDataOnLeave() and not p94.participants[tostring(v)].isMuted then
					p94:_setRecentUserState(v, {
						lastHeardTime = os.time()
					})
				end

				p94.participants[tostring(v)] = nil
				p94.participantLeft:Fire(p94.participants, v)
				p94:emit("OnVoiceParticipantRemoved", v)
			end

			for _, v in ipairs(p96) do
				p94.participantJoined:Fire(p94.participants, v)
				p94:emit("OnVoiceParticipantAdded", v)
			end

			for _, v in pairs(p97) do
				local userId = v.userId
				local v477 = if not v33 then p94.participants[userId] else p94.participants[tostring(userId)]

				if not v.isMuted or v477 and not v477.isMuted then
					p94:_setRecentUserState(userId, {
						lastHeardTime = os.time(),
						player = if not GetFFlagFixGetPlayerByUserIdStringCast() then Players:GetPlayerByUserId(userId) else Players:GetPlayerByUserId((tonumber(userId)))
					})
				end

				if not v477 or v477.isMuted ~= v.isMuted then
					p94:emit("OnVoiceParticipantToggleMuted", userId, v.isMuted)
				end

				if VoiceChatService.UseNewAudioApi then
					v.isMutedLocally = not not p94.mutedPlayers[userId]
				end

				if VoiceChatService.UseNewAudioApi then
					v.isMutedLocally = if not p94.mutedPlayers[userId] then v.isMutedLocally else not not p94.mutedPlayers[userId]
				end

				if FFlagEnablePartyVoiceChangersInLua and VoiceChatService.UseNewAudioApi then
					v.isVoiceChangerActive = if not p94.voiceChangerActivePlayers[userId] then v.isVoiceChangerActive else p94.voiceChangerActivePlayers[userId]
				end

				if p94.muteAll then
					v.isMutedLocally = true
				end

				p94.participants[tostring(userId)] = v

				if GetFFlagBatchVoiceParticipantsUpdates() then
					p94.updatedParticipants[tostring(userId)] = v
				end

				if v73 and p94.CaptureService:IsCapturingVideo() then
					p94.voiceCapturedDuringVideoCapture = p94.voiceCapturedDuringVideoCapture or v.isSignalActive
				end
			end

			p94:_updateRecentUsersInteractionData()

			if p94.shouldThrottleParticipantUpdate then
				local timestamp = tick()

				if timestamp - p94.lastParticipantsStateUpdate >= p94.participantsStateThrottleTime and #p97 > 0 then
					p94.lastParticipantsStateUpdate = timestamp
					p94.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p94.participants else p94.updatedParticipants)
					p94.updatedParticipants = {}

					return
				end

				if #p97 > 0 then
					local v479 = p94.participantsStateThrottleTime - (timestamp - p94.lastParticipantsStateUpdate)

					p94.lastStateUpdateCounter = (p94.lastStateUpdateCounter + 1) % 100

					local lastStateUpdateCounter = p94.lastStateUpdateCounter

					task.wait(v479)

					if lastStateUpdateCounter == p94.lastStateUpdateCounter then
						p94.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p94.participants else p94.updatedParticipants)
						p94.updatedParticipants = {}

						return
					end
				end
			elseif #p97 > 0 then
				p94.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p94.participants else p94.updatedParticipants)
				p94.updatedParticipants = {}
			end
		end)

		local function onStateChanged(p98, p99) -- line: 1714
			-- upvalues: p94 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v31 (copy), v63 (copy), v64 (copy), v65 (copy), v67 (copy), GetFFlagDisconnectToastClientRewrite (copy), v68 (copy), EngineFeature (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy)
			p94:emit("OnStateChanged", p98, p99)

			local v483 = p99 == Enum.VoiceChatState.Failed
			local v484 = p99 == Enum.VoiceChatState.Joining
			local v485 = p99 == Enum.VoiceChatState.Leaving
			local v486 = p99 == Enum.VoiceChatState.Ended
			local v487 = p94.service:IsPublishPaused()

			if v487 ~= p94.localMuted and (not v483 and not v484 and not v485 and not v486) then
				p94.localMuted = v487
				p94.muteChanged:Fire(v487)
			elseif v484 or v485 or v486 then
				p94.localMuted = nil
			end

			if GetFFlagVoiceChatClientRewriteMasterLua() and p99 == Enum.VoiceChatState.Joined and p94.isInCall and v487 ~= p94.callMutedState then
				v31:debug("In call, setting local muted to call muted state {}", p94.callMutedState)
				p94:ToggleMic("InitInCall")
			end

			if v63 and p99 == Enum.VoiceChatState.Joined then
				p94:StartModerationSignal()
			end

			if v64 and p99 == Enum.VoiceChatState.Joined then
				p94:_syncLocalAudioDeviceActive()
			end

			if p99 == Enum.VoiceChatState.Leaving then
				if not v65 or not p94.previousGroupId then
					p94.previousGroupId = p94.service:GetGroupId()
				end

				p94.previousMutedState = p94.service:IsPublishPaused()
			end

			if p99 == Enum.VoiceChatState.Ended or v483 then
				p94.participants = {}
				p94.localMuted = nil

				if v67 then
					p94._voiceVolumeEligibilityReported = false
				end

				p94.participantsUpdate:Fire(p94.participants)

				if v63 then
					p94:StopModerationSignal()
				end

				if v64 then
					p94:_syncLocalAudioDeviceActive()
				end

				if v483 then
					v31:debug("State Changed to Failed. Reason: {}", p94.service:GetAndClearCallFailureMessage())
				end

				if p98 == Enum.VoiceChatState.Joining or p98 == Enum.VoiceChatState.JoiningRetry or p98 == Enum.VoiceChatState.Joined then
					if p99 == Enum.VoiceChatState.Ended then
						v31:debug("State Changed to Ended from {}", p98)
					end

					if not GetFFlagDisconnectToastClientRewrite() or not p94:IsSeamlessVoice() or p94:GetVoiceConnectCookieValue() then
						p94:emit("OnRetryRequested")
					end
				end

				if v68 and EngineFeature then
					p94:ReportVoiceVolumeImpressionsIfNeeded()
				end
			end

			if GetFFlagEnableVoiceSignal() and p94.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Joining and p99 == Enum.VoiceChatState.Joined then
				p94:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joined)
				p94:emit("OnVoiceJoin")
			end

			if v68 and EngineFeature and p99 == Enum.VoiceChatState.Joined then
				p94._voiceJoinTimestampMs = DateTime.now().UnixTimestampMillis
				p94._voiceVolumeSliderEligibleAtJoin = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)
			end

			if v67 and EngineFeature and p99 == Enum.VoiceChatState.Joined and not p94._voiceVolumeEligibilityReported then
				local ok, result = pcall(function() -- line: 1825
					return UserSettings():GetService("UserGameSettings").VoiceChatVolume
				end)
				local UseNewAudioApi = VoiceChatService.UseNewAudioApi
				local v491 = VoiceVolumeControlsEligibility.isCreatorVoiceVolumeControlsEnabled()
				local VoiceAnalyticsData = p94:GetVoiceAnalyticsData()

				p94.Analytics:reportVoiceVolumeEligibility({
					playSessionId = VoiceAnalyticsData.playSessionId,
					voiceSessionId = VoiceAnalyticsData.voiceSessionId,
					voiceChatVolume = if not ok then nil else result,
					usesNewAudioApi = UseNewAudioApi,
					enablesVoiceVolumeControls = v491,
					isEligible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, UseNewAudioApi)
				})
				p94._voiceVolumeEligibilityReported = true
			end
		end

		if p94.service.VoiceChatState and p94.service.VoiceChatState == Enum.VoiceChatState.Joined then
			v31:debug("Joined voice chat {}", p94.service.VoiceChatState)
			onStateChanged(nil, Enum.VoiceChatState.Joined)
		end

		p94.stateConnection = p94.service.StateChanged:Connect(onStateChanged)

		if v62 and VoiceChatService.UseNewAudioApi then
			if not p94.localMeteringTask then
				p94.localMeteringTask = task.spawn(function() -- line: 1851
					-- upvalues: p94 (copy)
					while true do
						p94:UpdateLocalMetering()
						task.wait()
					end
				end)
			end
		elseif p94.service:GetVoiceChatApiVersion() >= MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY then
			p94.micConnection = p94.service.PlayerMicActivitySignalChange:Connect(function(p100) -- line: 1860
				-- upvalues: v73 (copy), p94 (copy), GetFFlagLocalMutedNilFix (copy), v39 (copy)
				if v73 and p94.CaptureService:IsCapturingVideo() then
					p94.voiceCapturedDuringVideoCapture = p94.voiceCapturedDuringVideoCapture or p100.isActive
				end

				p94.isTalking = p100.isActive

				if GetFFlagLocalMutedNilFix() then
					if p94.localMuted == false then
						if v39 then
							p94:FireTalkingChangedDebounced(p94.isTalking)

							return
						end

						p94.talkingChanged:Fire(p94.isTalking)

						return
					end
				elseif not p94.localMuted then
					if v39 then
						p94:FireTalkingChangedDebounced(p94.isTalking)

						return
					end

					p94.talkingChanged:Fire(p94.isTalking)
				end
			end)
		end

		if GetFFlagLuaConsumePlayerModerated() then
			p94:StartModerationSignal()
		elseif game:GetEngineFeature("VoiceChatServicePlayerModeratedEvent") then
			p94.playerModeratedConnection = p94.service.LocalPlayerModerated:connect(function() -- line: 1893
				-- upvalues: v31 (copy), p94 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
				v31:debug("User Moderated old")
				p94.previousSessionId = p94.service:GetSessionId()
				p94:emit("OnPlayerModerated")

				if GetFFlagVoiceChatClientRewriteMasterLua() then
					VoiceChatService:leaveVoice()

					return
				end

				p94.service:Leave()
			end)
		end

		v31:trace("Setting up voice nudge handlers")
		p94.voiceToxicityModalConnection = p94:GetSignalREvent("VoiceToxicityModal"):Connect(function(p101) -- line: 1906
			-- upvalues: p94 (copy)
			p94.Analytics:reportReceivedNudge(p101, p94:GetNudgeAnalyticsData())
			p94:emit("OnVoiceToxicityModal")
		end)
		p94.VoiceToxicityToastConnection = p94:GetSignalREvent("VoiceToxicityToast"):Connect(function(p102) -- line: 1912
			-- upvalues: p94 (copy)
			p94.Analytics:reportReceivedNudge(p102, p94:GetNudgeAnalyticsData())
			p94:emit("OnVoiceToxicityToast")
		end)

		if GetFFlagEnableVoiceReverseNudge() then
			v31:trace("Setting up voice reverse nudge handlers")
			p94.voiceReverseNudgeConnection = p94:GetSignalREvent("VoiceReverseNudgeIconColorChange"):Connect(function(p103) -- line: 1919
				-- upvalues: p94 (copy)
				p94:emit("OnVoiceReverseNudgeIconColorChange", p103)
			end)
		end

		p94.blockConnection = p94.BlockStatusChanged:Connect(function(n4: number, b4: boolean) -- line: 1924
			-- upvalues: p94 (copy), v31 (copy), Utils (copy)
			if b4 then
				if p94.participants[tostring(n4)] then
					v31:debug("Blocking {}", Utils.shorten(n4))
					p94.service:SubscribeBlock(n4)

					return
				end
			else
				v31:debug("UnBlocking {}", Utils.shorten(n4))
				p94.service:SubscribeUnblock(n4)
			end
		end)

		if VoiceChatService.UseNewAudioApi then
			p94:hookupAudioDeviceInputListener()
		end

		if p94.service.TempSetMicMutedToggleMic then
			p94.tempSetMicMutedToggleMicConnection = p94.service.TempSetMicMutedToggleMic:connect(function() -- line: 1942
				-- upvalues: p94 (copy)
				p94:ToggleMic("TempSetMicMutedToggleMic")
			end)
		end

		if v73 then
			p94.videoCaptureInProgressConnection = p94.CaptureService.VideoCaptureInProgress:connect(function(b5: boolean) -- line: 1949
				-- upvalues: p94 (copy), t1 (copy)
				if b5 then
					p94.voiceCapturedDuringVideoCapture = false

					return
				end

				p94.TelemetryService:LogEvent(t1, {
					customFields = {
						voiceCaptured = p94.voiceCapturedDuringVideoCapture
					}
				})
			end)
		end
	end
end

local u98 = nil

function t2.CheckAudioInputExists(p104) -- line: 1964
	-- upvalues: v31 (copy), u98 (ref), Promise (copy), Cryo (copy)
	v31:trace("Checking for AudioDeviceInput")

	if not u98 then
		u98 = Promise.new(function(resolve, _) -- line: 1967
			-- upvalues: Cryo (copy), p104 (copy), v31 (copy)
			if #Cryo.Dictionary.keys(p104.audioDevices) > 0 then
				v31:trace("Found existing AudioDeviceInput")
				resolve()

				return
			end

			p104.audioDeviceInputAdded.Event:Connect(function() -- line: 1972
				-- upvalues: v31 (copy), resolve (copy)
				v31:trace("Found new AudioDeviceInput")
				resolve()
			end)
		end)
	end

	return u98
end
function t2.checkAndUpdateSequence(t21: {[any]: any}, s9: string, n5: number) -- line: 1982
	if not n5 then
		return 0
	end

	if not t21.SequenceNumbers[s9] then
		t21.SequenceNumbers[s9] = n5

		return 0
	end

	local v309 = n5 - t21.SequenceNumbers[s9]

	if v309 > 0 then
		t21.SequenceNumbers[s9] = n5
	end

	return v309 - 1
end

local function isIgnoredAudioInput(p106) -- line: 2009
	-- upvalues: CoreGui (copy)
	return p106:IsDescendantOf(CoreGui)
end

function t2.onInstanceAdded(t22: {[any]: any}, p107) -- line: 2013
	-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), v31 (copy)
	if p107:IsA("AudioDeviceInput") then
		if FFlagExpChatDictation and p107:IsDescendantOf(CoreGui) then
			return
		end

		v31:debug("Found new audio device instance for {}", p107.Player and p107.Player.Name)
		t22.audioDevices[p107] = t22:CreateAudioDeviceData(p107)
		t22:emit("OnAudioDeviceInputAdded")
		t22:StartAnalysis(p107)
	end
end
function t2.GetSendMuteEvent(p108) -- line: 2026
	-- upvalues: RobloxReplicatedStorage (copy)
	if not p108.SendMuteEvent then
		p108.SendMuteEvent = RobloxReplicatedStorage:WaitForChild("SetUserActive", 10)
	end

	return p108.SendMuteEvent
end
function t2.GetToggleVoiceChangerEvent(p109) -- line: 2033
	-- upvalues: ReplicatedStorage (copy)
	if not p109.SendVoiceChangerEvent then
		p109.SendVoiceChangerEvent = ReplicatedStorage:WaitForChild("ToggleUserVoiceChanger", 10)
	end

	return p109.SendVoiceChangerEvent
end
function t2.GetInputToModifierWire(p110) -- line: 2040
	-- upvalues: Players (copy)
	if not p110.InputToModifierWire then
		p110.InputToModifierWire = Players.LocalPlayer:FindFirstChild("InputToModifier")
	end

	return p110.InputToModifierWire
end
function t2.GetPartyVoiceDeviceInput(p111) -- line: 2047
	-- upvalues: Players (copy)
	if not p111.PartyVoiceDeviceInput then
		p111.PartyVoiceDeviceInput = Players.LocalPlayer:FindFirstChild("PartyVoiceDeviceInput")
	end

	return p111.PartyVoiceDeviceInput
end
function t2.GetSetVoicePackEvent(p112) -- line: 2055
	-- upvalues: ReplicatedStorage (copy)
	if not p112.SetVoicePackEvent then
		p112.SetVoicePackEvent = ReplicatedStorage:WaitForChild("SetVoicePack", 10)
	end

	return p112.SetVoicePackEvent
end
function t2.GetVoiceChangerWasToggledEvent(p113) -- line: 2062
	-- upvalues: ReplicatedStorage (copy)
	if not p113.VoiceChangerWasToggledEvent then
		p113.VoiceChangerWasToggledEvent = ReplicatedStorage:WaitForChild("VoiceChangerWasToggled", 3)
	end

	return p113.VoiceChangerWasToggledEvent
end

local function WireUp(p114, p115) -- line: 2070
	local Wire = Instance.new("Wire")

	Wire.SourceInstance = p114
	Wire.TargetInstance = p115
	Wire.Parent = p115

	return Wire
end
local function GetAnalysisHost() -- line: 2079
	-- upvalues: RobloxReplicatedStorage (copy)
	return RobloxReplicatedStorage
end

function t2.GetAnalyzer(_: {[any]: any}, p116) -- line: 2083
	-- upvalues: RobloxReplicatedStorage (copy)
	local v324 = p116.Name .. "_Analyzer"
	local v325 = RobloxReplicatedStorage
	local v326 = v325:FindFirstChild(v324)

	if not v326 then
		v326 = Instance.new("AudioAnalyzer")
		v326.SpectrumEnabled = false
		v326.Name = v324
		v326.Parent = v325
	end

	return v326
end

local function toDecibels(n6: number) -- line: 2096
	return math.log10(n6) * 20
end

function t2.IsSignalActive(t24: {[any]: any}, n7: number) -- line: 2100
	-- upvalues: v62 (copy), Players (copy)
	if not v62 then
		return false
	end

	local PlayerByUserId = Players:GetPlayerByUserId(n7)

	if not PlayerByUserId then
		return false
	end

	return math.log10(t24:GetAnalyzer(PlayerByUserId).PeakLevel) * 20 > -36
end
function t2.StopAnalysis(_: {[any]: any}, p117) -- line: 2114
	-- upvalues: v62 (copy), RobloxReplicatedStorage (copy)
	if not v62 then
		return
	end

	for _, v334 in p117:GetConnectedWires("Output") do
		local TargetInstance = v334.TargetInstance

		if TargetInstance and TargetInstance:IsDescendantOf(RobloxReplicatedStorage) then
			v334:Destroy()
		end
	end
end
function t2.StartAnalysis(t26: {[any]: any}, p118) -- line: 2130
	-- upvalues: v62 (copy)
	if not v62 then
		return
	end

	t26:StopAnalysis(p118)

	local Player = p118.Player

	if not Player then
		return
	end

	local Analyzer = t26:GetAnalyzer(Player)
	local Wire = Instance.new("Wire")

	Wire.SourceInstance = p118
	Wire.TargetInstance = Analyzer
	Wire.Parent = Analyzer
end
function t2.GetVoiceConnectCookie(p119) -- line: 2144
	-- upvalues: Constants (copy)
	local ok, result = pcall(function() -- line: 2145
		-- upvalues: p119 (copy), Constants (copy)
		return p119.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
	end)

	if ok and result then
		return result
	end

	return ""
end
function t2.GetVoiceConnectCookieValue(p120) -- line: 2156
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), Constants (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		local ok, result = pcall(function() -- line: 2158
			-- upvalues: p120 (copy), Constants (copy)
			return p120.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
		end)

		if ok then
			return result == "true"
		end

		return true
	end

	local ok, result = pcall(function() -- line: 2164
		-- upvalues: p120 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), Constants (copy)
		return p120.AppStorageService:GetItem(if not GetFFlagEnableSeamlessVoiceV2() then Constants.VOICE_CONNECT_DISCONNECT_KEY else Constants.VOICE_CONNECT_DISCONNECT_KEY_V2)
	end)

	if ok then
		return result == "true"
	end

	return true
end
function t2.SetVoiceConnectCookieValue(t27: {[any]: any}, b6: boolean) -- line: 2176
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), Constants (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		return (pcall(function() -- line: 2178
			-- upvalues: t27 (copy), Constants (copy), b6 (copy)
			t27.AppStorageService:SetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3, (tostring(b6)))
			t27.AppStorageService:Flush()
		end))
	end

	return (pcall(function() -- line: 2184
		-- upvalues: t27 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), Constants (copy), b6 (copy)
		t27.AppStorageService:SetItem(if not GetFFlagEnableSeamlessVoiceV2() then Constants.VOICE_CONNECT_DISCONNECT_KEY else Constants.VOICE_CONNECT_DISCONNECT_KEY_V2, (tostring(b6)))
		t27.AppStorageService:Flush()
	end))
end
function t2.GetVoiceRewarmCookie(p121) -- line: 2197
	-- upvalues: Constants (copy), v31 (copy)
	local ok, result = pcall(function() -- line: 2198
		-- upvalues: p121 (copy), Constants (copy)
		return p121.AppStorageService:GetItem(Constants.VOICE_REWARM_KEY)
	end)

	if ok and result then
		v31:debug("Got voice re-warm cookie: {}", result)

		return result
	end

	v31:debug("Voice re-warm cookie not set, returning empty string")

	return ""
end
function t2.SetVoiceRewarmCookie(t28: {[any]: any}, s10: string) -- line: 2211
	-- upvalues: v31 (copy), Constants (copy)
	v31:debug("Setting voice re-warm cookie to {}", s10)
	pcall(function() -- line: 2213
		-- upvalues: t28 (copy), Constants (copy), s10 (copy)
		t28.AppStorageService:SetItem(Constants.VOICE_REWARM_KEY, (tostring(s10)))
		t28.AppStorageService:Flush()
	end)
end
function t2.ShouldRewarmUser(p122) -- line: 2219
	return p122:GetVoiceRewarmCookie() == ""
end
function t2.RewarmUser(p123) -- line: 2223
	p123:SetVoiceRewarmCookie("true")
end
function t2.SetNewUserFTUXCookieValue(t29: {[any]: any}, b7: boolean) -- line: 2227
	-- upvalues: Constants (copy)
	return (pcall(function() -- line: 2228
		-- upvalues: t29 (copy), Constants (copy), b7 (copy)
		t29.AppStorageService:SetItem(Constants.SEAMLESS_VOICE_FTUX_KEY, (tostring(b7)))
		t29.AppStorageService:Flush()
	end))
end
function t2.SetAndSyncActive(t30: {[any]: any}, p124, b8: boolean) -- line: 2235
	-- upvalues: Players (copy)
	p124.Active = b8

	local SendMuteEvent = t30:GetSendMuteEvent()

	if SendMuteEvent and p124.Player == Players.LocalPlayer then
		SendMuteEvent:FireServer(b8)
	end
end
function t2.CreateAudioDeviceData(t31: {[any]: any}, p125) -- line: 2244
	-- upvalues: Players (copy), EngineFeature2 (copy), v31 (copy), v32 (copy), v59 (copy), v64 (copy), VoiceChatService (copy)
	local t32 = {}
	local u367 = p125.Player == Players.LocalPlayer

	if EngineFeature2 then
		if not p125.MutedByLocalUser then
			if t31.muteAll and not u367 then
				p125.MutedByLocalUser = true
			end

			if p125.Player and t31.mutedPlayers[p125.Player.UserId] then
				p125.MutedByLocalUser = true
			end
		end
	elseif p125.Active then
		if t31.muteAll and not u367 then
			p125.Active = false
		end

		if p125.Player and t31.mutedPlayers[p125.Player.UserId] then
			p125.Active = false
		end
	end

	if p125.Active and u367 and t31.localMuted == nil then
		t31:SetAndSyncActive(p125, false)
	end

	if u367 and t31.localMuted ~= nil and t31.localMuted ~= not p125.Active and not t31.isInCall then
		v31:debug("Mismatch between LocalMuted and device.Active")

		local v368 = not t31.localMuted

		p125.Active = v368

		local SendMuteEvent = t31:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v368)
		end
	elseif t31.isInCall and u367 then
		local v370 = not t31.callMutedState

		v31:debug("Overwriting Active State to match Iris call. .Active = {}", v370)
		p125.Active = v370

		local SendMuteEvent = t31:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v370)
		end
	end

	t32.onPlayerChanged = p125:GetPropertyChangedSignal("Player"):Connect(function() -- line: 2294
		-- upvalues: v32 (copy), u367 (ref), p125 (copy), Players (copy), t31 (copy), v31 (copy), EngineFeature2 (copy)
		if v32 then
			u367 = p125.Player == Players.LocalPlayer

			if u367 then
				if p125.Active and t31.localMuted == nil then
					v31:debug("Player is still in connecting state, setting Active to false")
					t31:SetAndSyncActive(p125, false)
				elseif t31.localMuted ~= nil and t31.localMuted ~= not p125.Active then
					v31:debug("Mismatch between LocalMuted and device.Active")
					t31:SetAndSyncActive(p125, not t31.localMuted)
				end
			elseif t31.muteAll or p125.Player and t31.mutedPlayers[p125.Player.UserId] then
				if EngineFeature2 then
					p125.MutedByLocalUser = true
				else
					p125.Active = false
				end
			end
		end

		t31:emit("OnDevicePlayerChanged")
		t31:StartAnalysis(p125)
	end)
	t32.onMutedChanged = p125:GetPropertyChangedSignal("Muted"):Connect(function() -- line: 2320
		-- upvalues: t31 (copy)
		t31:emit("OnDeviceMuteChanged")
	end)

	if not EngineFeature2 then
		t32.onActiveChanged = p125:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2325
			-- upvalues: t31 (copy), u367 (ref), p125 (copy)
			t31:emit("OnDeviceActiveChanged")

			if t31.muteAll and not u367 then
				p125.Active = false
			end

			if p125.Player and t31.mutedPlayers[p125.Player.UserId] then
				p125.Active = false
			end
		end)
	elseif v59 then
		t32.onActiveChanged = p125:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2336
			-- upvalues: t31 (copy)
			t31:emit("OnDeviceActiveChanged")
		end)
		t32.onMutedByLocalUserChanged = p125:GetPropertyChangedSignal("MutedByLocalUser"):Connect(function() -- line: 2339
			-- upvalues: t31 (copy)
			t31:emit("OnDeviceMutedByLocalUserChanged")
		end)
	end

	if v64 and VoiceChatService.UseNewAudioApi then
		t32.onActiveChangedDisconnectGuard = p125:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2345
			-- upvalues: p125 (copy), Players (copy), t31 (copy)
			if p125.Active and (p125.Player == Players.LocalPlayer and t31.localMuted == nil) then
				t31:SetAndSyncActive(p125, false)
			end
		end)
	end

	return t32
end
function t2.onInstanceRemove(t33: {[any]: any}, p126) -- line: 2355
	-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), v31 (copy), EngineFeature2 (copy), v59 (copy), v62 (copy)
	if p126:IsA("AudioDeviceInput") then
		if FFlagExpChatDictation and p126:IsDescendantOf(CoreGui) then
			return
		end

		t33:StopAnalysis(p126)
		v31:trace("Removing AudioDeviceInput {} {} {}", p126, "for user", p126.Player and p126.Player.UserId)

		local v374 = t33.audioDevices[p126]

		if v374 then
			if not EngineFeature2 then
				v374.onActiveChanged:Disconnect()
			elseif v59 then
				if v374.onActiveChanged then
					v374.onActiveChanged:Disconnect()
				end

				if v374.onMutedByLocalUserChanged then
					v374.onMutedByLocalUserChanged:Disconnect()
				end
			end

			v374.onMutedChanged:Disconnect()
			v374.onPlayerChanged:Disconnect()

			if v374.onActiveChangedDisconnectGuard then
				v374.onActiveChangedDisconnectGuard:Disconnect()
			end
		end

		t33.audioDevices[p126] = nil
		t33:emit("OnAudioDeviceInputRemoved")

		if v62 and p126.Player then
			t33:GetAnalyzer(p126.Player):Destroy()
		end
	end
end
function t2.hookupAudioDeviceInputListener(p127) -- line: 2389
	-- upvalues: v31 (copy), Players (copy), SoundService (copy), VoiceChatService (copy), CollectionService (copy), Utils (copy)
	v31:debug("Hooking up audio device listeners")

	local LocalPlayer = Players.LocalPlayer

	SoundService.AudioInstanceAdded:Connect(function(p128) -- line: 2392
		-- upvalues: p127 (copy)
		p127:onInstanceAdded(p128)
	end)

	local AudioDeviceInput = LocalPlayer:FindFirstChildOfClass("AudioDeviceInput")

	v31:debug("Found local user audio device {}", AudioDeviceInput)

	if AudioDeviceInput then
		p127:onInstanceAdded(AudioDeviceInput)
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

		for _, v382 in CollectionService:GetTagged("RbxDefaultVoiceEmitter") do
			Utils.destroyDefaultEmitter(v382)
		end

		CollectionService:GetInstanceAddedSignal("RbxDefaultVoiceEmitter"):Connect(Utils.destroyDefaultEmitter)
		LocalPlayer.CharacterAdded:Connect(Utils.avoidEmitting)

		if LocalPlayer.Character then
			Utils.avoidEmitting(LocalPlayer.Character)
		end
	end

	game.DescendantRemoving:Connect(function(descendant) -- line: 2427
		-- upvalues: p127 (copy)
		p127:onInstanceRemove(descendant)
	end)

	for _, descendant in game:GetDescendants() do
		p127:onInstanceAdded(descendant)
	end

	Players.PlayerRemoving:Connect(function(player) -- line: 2436
		-- upvalues: p127 (copy)
		for v505 in p127.audioDevices do
			if v505.Player and player == v505.Player then
				p127:onInstanceRemove(v505)
			end
		end
	end)
end
function t2.RejoinCurrentChannel(p129) -- line: 2446
	-- upvalues: v31 (copy)
	pcall(function() -- line: 2447
		-- upvalues: p129 (copy), v31 (copy)
		local GroupId = p129.service:GetGroupId()

		if GroupId and GroupId ~= "" then
			local v507 = p129.service:IsPublishPaused()

			p129.service:Leave()
			v31:debug("Rejoining current channel {}", GroupId)
			p129.participants = {}
			p129.participantsUpdate:Fire(p129.participants)

			if not p129.service:JoinByGroupIdToken(GroupId, v507, true) then
				p129:emit("OnInitialJoinFailed")
			end
		end
	end)
end
function t2.RejoinChannel(p130, p131, p132) -- line: 2463
	-- upvalues: v31 (copy)
	v31:debug("Rejoining previous channel {} with mute status {}", p131, p132)

	if p131 and p131 ~= "" then
		pcall(function() -- line: 2467
			-- upvalues: p130 (copy), p131 (copy), p132 (copy)
			p130.service:Leave()
			p130.participants = {}
			p130.participantsUpdate:Fire(p130.participants)

			if not p130.service:JoinByGroupIdToken(p131, p132, true) then
				p130:emit("OnInitialJoinFailed")
			end
		end)
	end
end
function t2.RejoinVoice(p133) -- line: 2479
	-- upvalues: GetFFlagVoiceChatClientRewriteMasterLua (copy), v31 (copy), VoiceChatService (copy)
	if GetFFlagVoiceChatClientRewriteMasterLua() then
		v31:debug("Rejoining voice")
		p133.participants = {}
		p133.participantsUpdate:Fire(p133.participants)
		VoiceChatService:rejoinVoice()
	end
end
function t2.watchSignalR(p134) -- line: 2490
	-- upvalues: WATCHED_NAMESPACES (copy), Utils (copy), v31 (copy)
	p134.signalRConnection = p134.NotificationService.RobloxEventReceived:Connect(function(t34: {[any]: any}) -- line: 2491
		-- upvalues: WATCHED_NAMESPACES (copy), Utils (copy), p134 (copy), v31 (copy)
		local namespace = t34.namespace

		if not WATCHED_NAMESPACES[namespace] then
			return
		end

		local v510 = Utils.jsonDecode(t34.detail)
		local v511 = p134.SignalREventTable[v510.type]

		if v511 then
			v511:Fire(v510)
		end

		local SequenceNumber = v510.SequenceNumber

		v31:trace("SignalR message {}: {}", namespace, SequenceNumber)

		local v513 = p134:checkAndUpdateSequence(namespace, SequenceNumber)

		if v513 > 0 then
			p134.Analytics:reportReconnectDueToMissedSequence()

			return
		end

		if v513 < -1 then
			p134.Analytics:reportOutOfOrderSequence()
		end
	end)
	p134.signalRConnectionChanged = p134.NotificationService.RobloxConnectionChanged:Connect(function(p135, p136, _, p138) -- line: 2515
		-- upvalues: v31 (copy), Utils (copy), WATCHED_NAMESPACES (copy), p134 (copy)
		if p135 == "signalR" then
			if p136 ~= Enum.ConnectionState.Connected then
				v31:info("SignalR disconnected")

				return
			end

			for k, v in pairs(Utils.jsonDecode(p138)) do
				if WATCHED_NAMESPACES[k] then
					v31:trace("SignalR message {}: {}", k, v)

					local v520 = p134:checkAndUpdateSequence(k, v)

					if v520 > 0 then
						p134.Analytics:reportReconnectDueToMissedSequence()
					elseif v520 < -1 then
						p134.Analytics:reportOutOfOrderSequence()
					end
				end
			end
		end
	end)
end
function t2.StopSignalRConnection(p139) -- line: 2540
	if p139.signalRConnectionChanged then
		p139.signalRConnectionChanged:Disconnect()
		p139.signalRConnectionChanged = nil
	end

	if p139.signalRConnection then
		p139.signalRConnection:Disconnect()
		p139.signalRConnection = nil
	end
end
function t2.getService(p140) -- line: 2551
	return p140.service
end
function t2.ToggleMic(t35: {[any]: any}, s11: string?) -- line: 2555
	-- upvalues: v31 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PermissionsProtocol (copy), VoiceChatService (copy), Players (copy)
	t35:ensureInitialized("toggle mic")

	if t35.localMuted == nil then
		v31:trace("ToggleMic context: {} - Voice not connected yet", s11)

		return
	end

	v31:trace("ToggleMic context: {}", s11)

	if GetFFlagJoinWithoutMicPermissions() then
		if t35.permissionState == PERMISSION_STATE.PENDING_MIC then
			v31:debug("In pending mic mode, requesting permission")
			t35:emit("GetPermissions", function(p141) -- line: 2568
				-- upvalues: t35 (copy), PERMISSION_STATE (copy), v31 (copy), s11 (copy)
				t35.permissionState = if not p141.hasMicPermissions then PERMISSION_STATE.LISTEN_ONLY else PERMISSION_STATE.LISTEN_AND_TALK
				v31:debug("Got permissions, setting state to {}", t35.permissionState)
				t35:ToggleMic(s11)
			end, { PermissionsProtocol.Permissions.MICROPHONE_ACCESS }, false)

			return
		end

		if t35.permissionState == PERMISSION_STATE.LISTEN_ONLY then
			v31:debug("User tried to unmute despite being in listen only mode")
			t35:emit("OnPermissionRequested")

			return
		end
	end

	if t35.isPlayerWatchingAd then
		v31:trace("User is watching an ad, skipping toggling mic")

		return
	end

	if VoiceChatService.UseNewAudioApi then
		t35.localMuted = not t35.localMuted

		local v395 = not t35.localMuted

		v31:trace("Setting self mute to {} context: {}", v395, s11)

		local SendMuteEvent = t35:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v395)

			for v397 in t35.audioDevices do
				if v397.Player and v397.Player == Players.LocalPlayer then
					v397.Active = v395
				end
			end

			t35.muteChanged:Fire(t35.localMuted)
		else
			v31:error("Could not find SendMuteEvent")
		end
	else
		local v398 = not t35.service:IsPublishPaused()

		v31:trace("Setting self mute to {} context: {}", v398, s11)
		t35.service:PublishPause(v398)
		t35.localMuted = v398
		t35.muteChanged:Fire(v398)
	end

	if not t35.localMuted then
		t35.talkingChanged:Fire(t35.isTalking)
		t35:emit("OnShowDataConsentToast")
	end

	if s11 then
		t35.Analytics:reportVoiceMuteSelf((t35:JoinWithVoiceMuteData({
			context = s11,
			muted = t35.localMuted
		})))
	end
end
function t2.ToggleVoiceChanger(t36: {[any]: any}, _: string?) -- line: 2629
	-- upvalues: VoiceChatService (copy), v31 (copy)
	t36:ensureInitialized("toggle voice changer")

	if t36.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t36.isVoiceChangerActive = not t36.isVoiceChangerActive
		v31:trace("setting voice changer active to {}", t36.isVoiceChangerActive)

		local ToggleVoiceChangerEvent = t36:GetToggleVoiceChangerEvent()

		if ToggleVoiceChangerEvent then
			ToggleVoiceChangerEvent:FireServer(t36.isVoiceChangerActive)
			t36.voiceChangerChanged:Fire(t36.isVoiceChangerActive)

			return
		end

		v31:error("Could not find ToggleVoiceChangerEvent")

		return
	end

	t36.isVoiceChangerActive = false
	v31:trace("forcibly disabling voice changer since using old audio api", t36.isVoiceChangerActive)

	local ToggleVoiceChangerEvent = t36:GetToggleVoiceChangerEvent()

	if ToggleVoiceChangerEvent then
		ToggleVoiceChangerEvent:FireServer(t36.isVoiceChangerActive)
		t36.voiceChangerChanged:Fire(t36.isVoiceChangerActive)

		return
	end

	v31:error("Could not find ToggleVoiceChangerEvent")
end
function t2.ToggleVoiceChangerHearMyself(t37: {[any]: any}, _: string?) -- line: 2659
	-- upvalues: VoiceChatService (copy), v31 (copy)
	if t37.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t37.isVoiceChangerHearMyselfActive = not t37.isVoiceChangerHearMyselfActive

		local InputToModifierWire = t37:GetInputToModifierWire()
		local PartyVoiceDeviceInput = t37:GetPartyVoiceDeviceInput()

		if InputToModifierWire and PartyVoiceDeviceInput then
			v31:trace("setting voice changer hear myself active to {}", t37.isVoiceChangerHearMyselfActive)

			if t37.isVoiceChangerHearMyselfActive then
				InputToModifierWire.SourceInstance = PartyVoiceDeviceInput
			else
				InputToModifierWire.SourceInstance = nil
			end

			t37.voiceChangerHearMyselfChanged:Fire(t37.isVoiceChangerHearMyselfActive)

			return
		end

		v31:error("Could not find InputToModifierWire or PartyVoiceDeviceInput")
	end
end
function t2.SetVoicePack(t38: {[any]: any}, s14: string) -- line: 2684
	-- upvalues: VoiceChatService (copy), v31 (copy)
	t38:ensureInitialized("set voice pack")

	if t38.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t38.currentVoicePack = s14
		v31:trace("setting current voice pack to {}", t38.currentVoicePack)

		local SetVoicePackEvent = t38:GetSetVoicePackEvent()

		if SetVoicePackEvent then
			SetVoicePackEvent:FireServer("VoicePack_" .. t38.currentVoicePack)

			return
		end

		v31:error("Could not find SetVoicePackEvent")
	end
end
function t2.JoinWithVoiceMuteData(p142, p143) -- line: 2703
	-- upvalues: Players (copy), Cryo (copy)
	local LocalPlayer = Players.LocalPlayer

	return Cryo.Dictionary.join({
		userId = LocalPlayer.UserId,
		clientSessionId = p142:GetSessionId(),
		channelId = p142:GetChannelId()
	}, p143)
end
function t2._reportJoinFailed(p144, p145, p146) -- line: 2712
	p144.Analytics:reportVoiceChatJoinResult(false, p145, p146)
	p144:emit("OnReportJoinFailed", p145)
end
function t2._syncLocalAudioDeviceActive(p147) -- line: 2717
	-- upvalues: VoiceChatService (copy), Players (copy)
	if not VoiceChatService.UseNewAudioApi then
		return
	end

	local v417 = p147.localMuted ~= nil and not p147.localMuted

	for v418 in p147.audioDevices do
		if v418.Player and v418.Player == Players.LocalPlayer then
			v418.Active = v417
		end
	end
end
function t2._setupEarlyAudioDeviceGuard(p148) -- line: 2729
	-- upvalues: VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), SoundService (copy)
	local function shouldDeactivate(p149) -- line: 2730
		-- upvalues: VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p148 (copy)
		return VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and p149:IsDescendantOf(CoreGui)) and (p149.Player == Players.LocalPlayer and (p149.Active and p148.localMuted == nil)))
	end
	local function guardDevice(p150) -- line: 2738
		-- upvalues: VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p148 (copy)
		if VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and p150:IsDescendantOf(CoreGui)) and (p150.Player == Players.LocalPlayer and (p150.Active and p148.localMuted == nil))) then
			p150.Active = false
		end

		p150:GetPropertyChangedSignal("Player"):Connect(function() -- line: 2743
			-- upvalues: p150 (copy), VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p148 (copy)
			local v536 = p150

			if VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and v536:IsDescendantOf(CoreGui)) and (v536.Player == Players.LocalPlayer and (v536.Active and p148.localMuted == nil))) then
				p150.Active = false
			end
		end)
		p150:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2749
			-- upvalues: p150 (copy), VoiceChatService (copy), FFlagExpChatDictation (copy), CoreGui (copy), Players (copy), p148 (copy)
			local v537 = p150

			if VoiceChatService.UseNewAudioApi and (not (FFlagExpChatDictation and v537:IsDescendantOf(CoreGui)) and (v537.Player == Players.LocalPlayer and (v537.Active and p148.localMuted == nil))) then
				p150.Active = false
			end
		end)
	end

	SoundService.AudioInstanceAdded:Connect(function(p151) -- line: 2756
		-- upvalues: guardDevice (copy)
		if p151:IsA("AudioDeviceInput") then
			guardDevice(p151)
		end
	end)

	for _, descendant in game:GetDescendants() do
		if descendant:IsA("AudioDeviceInput") then
			guardDevice(descendant)
		end
	end
end
function t2._asyncInit(p152) -- line: 2769
	-- upvalues: v64 (copy), v31 (copy), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy), Analytics (copy), Promise (copy)
	p152:CheckCallState()

	if v64 then
		p152:_setupEarlyAudioDeviceGuard()
	end

	return p152:canUseServiceAsync():andThen(function(_) -- line: 2775
		-- upvalues: v31 (copy), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), p152 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy), Analytics (copy), Promise (copy)
		local s15 = "VoiceChatService"

		if game:GetEngineFeature("UseNewVoiceChatService") then
			s15 = "VoiceChatInternal"
			v31:debug("Using VoiceChatInternal")
		end

		local ok, result = pcall(function() -- line: 2781
			-- upvalues: s15 (ref), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), p152 (copy)
			local s15_2 = game:GetService(s15)

			if s15_2 and (s15_2:GetVoiceChatApiVersion() < MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED or s15_2:IsContextVoiceEnabled()) then
				p152.voiceEnabled = true
				p152.service = s15_2
				p152:SetupParticipantListeners()
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
			p152:_reportJoinFailed("getServiceFailed", Analytics.ERROR)

			if p152.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_GET_SERVICE_FAILED"
				})
			end

			return Promise.reject()
		end

		if not p152.service then
			v31:debug("VoiceChatService is not set after init")
			p152:_reportJoinFailed("contextNotEnabled")

			if p152.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_CONTEXT_NOT_ENABLED"
				})
			end

			return Promise.reject()
		end

		p152:emit("OnVoiceChatServiceInitialized")
		p152:watchSignalR()

		return Promise.resolve()
	end)
end
function t2.UpdateLocalMetering(p154) -- line: 2831
	-- upvalues: Players (copy), v39 (copy)
	p154.isTalking = p154:IsSignalActive(Players.LocalPlayer.UserId)

	if p154.localMuted == false then
		if v39 then
			p154:FireTalkingChangedDebounced(p154.isTalking)

			return
		end

		p154.talkingChanged:Fire(p154.isTalking)
	end
end
function t2.FireTalkingChangedDebounced(p155, p156) -- line: 2842
	-- upvalues: v40 (copy)
	local v428 = v40
	local v429 = tick() * 1000
	local v430 = p156 ~= p155._lastTalkingChangedFireValue
	local v431 = v428 < v429 - p155._lastTalkingChangedFireTime

	if v430 or v431 then
		p155._lastTalkingChangedFireTime = v429
		p155._lastTalkingChangedFireValue = p156
		p155.talkingChanged:Fire(p156)
	end
end
function t2.asyncInit(p157) -- line: 2857
	-- upvalues: v31 (copy), Promise (copy), Constants (copy), FFlagEnablePartyVoiceChangersInLua (copy), v33 (copy)
	if p157.service then
		v31:trace("Manager already initialized")

		return Promise.resolve()
	end

	if not p157.initPromise then
		p157.initPromise = p157:_asyncInit()

		if p157.AdService then
			local function setupRewardedAdMuting(p158) -- line: 2867
				-- upvalues: Constants (copy)
				local u531 = false

				p158.AdService.RewardedVideoAdStarted:Connect(function() -- line: 2869
					-- upvalues: p158 (copy), u531 (ref), Constants (copy)
					if p158.localMuted == nil then
						return
					end

					u531 = p158.localMuted

					if not p158.localMuted then
						p158:ToggleMic(Constants.REWARDED_VIDEO_AD_STARTED)
					end

					p158.isPlayerWatchingAd = true
				end)
				p158.AdService.RewardedVideoAdEnded:Connect(function() -- line: 2885
					-- upvalues: p158 (copy), u531 (ref), Constants (copy)
					if p158.localMuted == nil then
						return
					end

					p158.isPlayerWatchingAd = false

					if u531 ~= p158.localMuted then
						p158:ToggleMic(Constants.REWARDED_VIDEO_AD_ENDED)
					end
				end)
			end

			setupRewardedAdMuting(p157)
		end

		if FFlagEnablePartyVoiceChangersInLua and not p157.voiceChangerWasToggledEvent then
			task.spawn(function() -- line: 2905
				-- upvalues: p157 (copy), v33 (copy)
				local VoiceChangerWasToggledEvent = p157:GetVoiceChangerWasToggledEvent()

				if VoiceChangerWasToggledEvent then
					VoiceChangerWasToggledEvent.OnClientEvent:Connect(function(n8: number, b9: boolean) -- line: 2909
						-- upvalues: v33 (copy), p157 (copy)
						local v541 = if not v33 then p157.participants[n8] else p157.participants[tostring(n8)]

						if v541 then
							v541.isVoiceChangerActive = b9
							p157.voiceChangerActivePlayers[n8] = b9
							p157.participantsUpdate:Fire(p157.participants)
						end
					end)
				end
			end)
		end
	end

	return p157.initPromise
end
function t2.IsInitialized(p159) -- line: 2929
	if p159.service then
		return true
	end

	return false
end
function t2.ensureInitialized(p160, p161) -- line: 2933
	if not p160.service then
		error("[corescripts VCS Manager] " .. "Attempting to " .. p161 .. " before calling init")
	end
end
function t2.GetSessionId(p162) -- line: 2940
	p162:ensureInitialized("get session id")

	return p162.service:GetSessionId()
end
function t2.GetChannelId(p163) -- line: 2945
	p163:ensureInitialized("get channel id")

	return p163.service:GetChannelId()
end
function t2.Disconnect(p164) -- line: 2950
	-- upvalues: v73 (copy)
	if p164.participantConnection then
		p164.participantConnection:Disconnect()
		p164.participantConnection = nil
	end

	if p164.stateConnection then
		p164.stateConnection:Disconnect()
		p164.stateConnection = nil
	end

	if p164.micConnection then
		p164.micConnection:Disconnect()
		p164.micConnection = nil
	end

	if p164.blockConnection then
		p164.blockConnection:Disconnect()
		p164.blockConnection = nil
	end

	if p164.playerModeratedConnection then
		p164.playerModeratedConnection:Disconnect()
		p164.playerModeratedConnection = nil
	end

	if p164.voiceToxicityModalConnection then
		p164.voiceToxicityModalConnection:Disconnect()
		p164.voiceToxicityModalConnection = nil
	end

	if p164.VoiceToxicityToastConnection then
		p164.VoiceToxicityToastConnection:Disconnect()
		p164.VoiceToxicityToastConnection = nil
	end

	if p164.voiceReverseNudgeConnection then
		p164.voiceReverseNudgeConnection:Disconnect()
		p164.voiceReverseNudgeConnection = nil
	end

	if p164.tempSetMicMutedToggleMicConnection then
		p164.tempSetMicMutedToggleMicConnection:Disconnect()
		p164.tempSetMicMutedToggleMicConnection = nil
	end

	if v73 and p164.videoCaptureInProgressConnection then
		p164.videoCaptureInProgressConnection:Disconnect()
		p164.videoCaptureInProgressConnection = nil
	end
end
function t2.RequestHidePublicVoiceUI(p165) -- line: 3001
	task.defer(function() -- line: 3002
		-- upvalues: p165 (copy)
		p165.setVoiceUIVisibility:Fire(false)
	end)
end
function t2.RequestShowPublicVoiceUI(p166) -- line: 3007
	task.defer(function() -- line: 3008
		-- upvalues: p166 (copy)
		p166.setVoiceUIVisibility:Fire(true)
	end)
end

t2.default = t2.new(BlockingUtility:GetAfterBlockedStatusChangedEvent(), PermissionsProtocol.default, HttpRbxApiService, nil, nil, nil, nil, nil, ThirdPartyUserService, nil, AdService)

if v68 and EngineFeature then
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		LocalPlayer.AncestryChanged:Connect(function(_, parent) -- line: 3035
			-- upvalues: t2 (copy)
			if parent == nil then
				t2.default:ReportVoiceVolumeImpressionsIfNeeded()
			end
		end)
	end
end

return t2
