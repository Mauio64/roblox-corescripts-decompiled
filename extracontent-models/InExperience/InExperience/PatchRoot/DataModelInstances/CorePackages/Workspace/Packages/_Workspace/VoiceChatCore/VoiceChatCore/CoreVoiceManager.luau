local ParentParent = script.Parent.Parent
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
local IXPServiceWrapper = require(ParentParent.IXPServiceWrapper).IXPServiceWrapper
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
local Promise = require(ParentParent.Promise)
local Cryo = require(ParentParent.Cryo)
local default = require(ParentParent.CallProtocol).CallProtocol.default
local Enums = require(ParentParent.CallProtocol).Enums
local PermissionsProtocol = require(ParentParent.PermissionsProtocol).PermissionsProtocol
local BlockingUtility = require(ParentParent.BlockingUtility)
local CoreGui = game:GetService("CoreGui")
local v30 = require(ParentParent.CoreScriptsInitializer).CoreLogger:new(script.Name)
local v31 = require(Flags.GetFFlagUpdateDeviceInputPlayerChanged)()
local v32 = game:DefineFastFlag("StringKeyFixForParticipantsTable", false)
local v33 = game:DefineFastFlag("ShowJoinVoiceRaceConditionFix", false)
local v34 = game:DefineFastFlag("ConsoleVoiceIXPEnabled", false)
local FFlagExpChatDictation = require(ParentParent.SharedFlags).FFlagExpChatDictation
local v36 = game:DefineFastString("ConsoleVoiceIXPLayerName", "User.Communication.ConsoleVoice")
local v37 = game:DefineFastString("ConsoleVoiceEnabledIXPLayerValue", "ConsoleVoiceEnabled")
local v38 = game:DefineFastFlag("TalkingChangedWithDebounceV2", false)
local v39 = game:DefineFastInt("TalkingChangedDebounceTime", 300)
local v40 = game:DefineFastFlag("SendVoiceCapturedDuringVideoCaptureEvent", false)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = require(ParentParent.SharedFlags).GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local GetFFlagLuaConsumePlayerModerated = require(Flags.GetFFlagLuaConsumePlayerModerated)
local GetFFlagLocalMutedNilFix = require(ParentParent.SharedFlags).GetFFlagLocalMutedNilFix
local GetFFlagEnableVoiceReverseNudge = require(Flags.GetFFlagEnableVoiceReverseNudge)
local GetFFlagClearUserFromRecentVoiceDataOnLeave = require(Flags.GetFFlagClearUserFromRecentVoiceDataOnLeave)
local GetFIntVoiceUsersInteractionExpiryTimeSeconds = require(Flags.GetFIntVoiceUsersInteractionExpiryTimeSeconds)
local GetFFlagAvatarChatServiceEnabled = require(ParentParent.SharedFlags).GetFFlagAvatarChatServiceEnabled
local GetFFlagVoiceChatServiceManagerUseAvatarChat = require(Flags.GetFFlagVoiceChatServiceManagerUseAvatarChat)
local GetFFlagJoinWithoutMicPermissions = require(ParentParent.SharedFlags).GetFFlagJoinWithoutMicPermissions
local GetFFlagBatchVoiceParticipantsUpdates = require(Flags.GetFFlagBatchVoiceParticipantsUpdates)
local GetFIntThrottleParticipantsUpdateMs = require(Flags.GetFIntThrottleParticipantsUpdateMs)
local GetFFlagSeamlessVoiceFTUX = require(ParentParent.SharedFlags).GetFFlagSeamlessVoiceFTUX
local GetFFlagNonVoiceFTUX = require(ParentParent.SharedFlags).GetFFlagNonVoiceFTUX
local GetFFlagEnableFtuxExitOnMuteToggle = require(Flags.GetFFlagEnableFtuxExitOnMuteToggle)
local GetFFlagEnableExpJoinMicPermAnalytics = require(Flags.GetFFlagEnableExpJoinMicPermAnalytics)
local GetFFlagEnableSeamlessVoiceFeature = require(Flags.GetFFlagEnableSeamlessVoiceFeature)
local GetFFlagFixGetPlayerByUserIdStringCast = require(Flags.GetFFlagFixGetPlayerByUserIdStringCast)
local v58 = require(ParentParent.SharedFlags).GetFFlagDebugShowAudioDeviceInputDebugger()
local v59 = game:DefineFastString("VoicePerformanceThrottlingIXPLayerName", "Voice.Performance")
local v60 = game:DefineFastString("ThrottleParticipantsUpdateIXPLayerValue", "ThrottleParticipantsUpdate")
local v61 = game:DefineFastFlag("UseAudioAnalyzerForLocalMetering2", false)
local v62 = game:DefineFastFlag("StopModerationConnectionOnLeave", false)
local v63 = game:DefineFastFlag("DisableRejoinGroupIdDoubleRead", false)
local EngineFeature = game:GetEngineFeature("EnableMutedByLocalUser")
local EngineFeature2 = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFFlagEnableVoiceChatMuteForVideoCaptures = require(ParentParent.SharedFlags).GetFFlagEnableVoiceChatMuteForVideoCaptures
local v67 = v40 and GetFFlagEnableVoiceChatMuteForVideoCaptures()
local GetFFlagEnableVoiceSignal = require(ParentParent.SharedFlags).GetFFlagEnableVoiceSignal
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = require(ParentParent.SharedFlags).GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints
local GetFFlagVoiceChatClientRewriteMasterLua = require(ParentParent.SharedFlags).GetFFlagVoiceChatClientRewriteMasterLua
local GetFFlagCheckUniversePlaceBeforeSuspending = require(ParentParent.SharedFlags).GetFFlagCheckUniversePlaceBeforeSuspending
local GetFFlagEnableSeamlessVoiceV2 = require(ParentParent.SharedFlags).GetFFlagEnableSeamlessVoiceV2
local GetFFlagDisconnectToastClientRewrite = require(ParentParent.SharedFlags).GetFFlagDisconnectToastClientRewrite
local FFlagEnablePartyVoiceChangersInLua = require(ParentParent.SharedFlags).FFlagEnablePartyVoiceChangersInLua
local GetFFlagEnableVoiceUxUpdates = require(ParentParent.SharedFlags).GetFFlagEnableVoiceUxUpdates
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
local v88 = if not GetFFlagAvatarChatServiceEnabled() then nil else game:GetService("AvatarChatService")
local v89 = if not GetFFlagEnableVoiceChatMuteForVideoCaptures() then nil else game:GetService("CaptureService")
local v90 = if not v67 then nil else game:GetService("TelemetryService")
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
	mutedPlayers = {},
	voiceChangerActivePlayers = {},
	BlockStatusChanged = nil,
	AvatarChatService = v88,
	HttpRbxApiService = HttpRbxApiService,
	ThirdPartyUserService = ThirdPartyUserService,
	CaptureService = v89,
	TelemetryService = v90,
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
	voiceCapturedDuringVideoCapture = false
}

t2.__index = t2

function t2.new(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) -- line: 298
	-- upvalues: Utils (copy), Analytics (copy), AppStorageService (copy), t2 (copy), WATCHED_MESSAGE_TYPES (copy), GetFIntThrottleParticipantsUpdateMs (copy), Players2 (copy), v30 (copy), IXPServiceWrapper (copy), v59 (copy), v60 (copy)
	local v108 = setmetatable({
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

	for _, v110 in WATCHED_MESSAGE_TYPES do
		v108.SignalREventTable[v110] = Instance.new("BindableEvent")
	end

	v108.shouldThrottleParticipantUpdate = false
	v108.participantsStateThrottleTime = 0
	v108.lastParticipantsStateUpdate = 0
	v108.lastStateUpdateCounter = 0

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		task.spawn(function() -- line: 340
			-- upvalues: Players2 (copy), p4 (copy), v30 (copy), IXPServiceWrapper (copy), v59 (copy)
			local ok, result = pcall(function() -- line: 341
				-- upvalues: Players2 (copy), p4 (copy)
				if Players2.LocalPlayer then
					return p4:IsVoiceEnabledForUserIdAsync(Players2.LocalPlayer.UserId)
				end

				return false
			end)

			if not ok then
				v30:debug("Unable to get voice enabled status: ", result)

				return
			end

			if result then
				IXPServiceWrapper:LogUserLayerExposure(v59)
			end
		end)
		v108.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000

		local ok, result = pcall(function() -- line: 357
			-- upvalues: IXPServiceWrapper (copy), v59 (copy)
			return IXPServiceWrapper:GetLayerData(v59)
		end)

		if ok and result and result[v60] then
			v108.shouldThrottleParticipantUpdate = true
		end
	end

	return v108
end
function t2.emit(t3: {[any]: any}, s1: string, ...) -- line: 368
	t3.eventEmitter:emit(s1, ...)
end
function t2.subscribe(t4: {[any]: any}, s2: string, p12) -- line: 372
	t4.eventEmitter:addListener(s2, p12)
end
function t2.unsubscribeAll(p13) -- line: 376
	p13.eventEmitter:removeAllListeners()
end
function t2.CheckCallStateWithPromise(p14) -- line: 380
	-- upvalues: default (copy), v30 (copy), Enums (copy)
	return default:getCallState():andThen(function(p15) -- line: 382
		-- upvalues: v30 (copy), Enums (copy), p14 (copy)
		v30:trace("Got user call state")

		if p15.status ~= Enums.CallStatus.Idle.rawValue() and p15.status ~= Enums.CallStatus.Ringing.rawValue() then
			p14.isInCall = true
			p14.callMutedState = p15.muted
			v30:trace("Changing call muted state to {}", p15.muted)
		end
	end):catch(function(p16) -- line: 394
		-- upvalues: v30 (copy)
		v30:trace("User not in call {}", p16)
	end)
end
function t2.CheckCallState(p17) -- line: 400
	-- upvalues: v30 (copy), default (copy), Enums (copy)
	v30:trace("Checking user call state")

	local ok, result = pcall(function() -- line: 402
		-- upvalues: default (copy), v30 (copy), Enums (copy), p17 (copy)
		default:getCallState():andThen(function(p18) -- line: 404
			-- upvalues: v30 (copy), Enums (copy), p17 (copy)
			v30:trace("Got user call state")

			if p18.status ~= Enums.CallStatus.Idle.rawValue() and p18.status ~= Enums.CallStatus.Ringing.rawValue() then
				p17.isInCall = true
				p17.callMutedState = p18.muted
				v30:trace("Changing call muted state to {}", p18.muted)
			end
		end):catch(function(p19) -- line: 416
			-- upvalues: v30 (copy)
			v30:trace("User not in call {}", p19)
		end)
	end)

	if not ok then
		v30:debug("Error checking user call state {}", result)
	end
end
function t2._GetShowAgeVerificationOverlay(p20, p21) -- line: 435
	-- upvalues: GetShowAgeVerificationOverlay (copy), Utils (copy)
	return GetShowAgeVerificationOverlay(Utils.bind(p20, "GetRequest"), tostring(game.GameId), tostring(game.PlaceId), p21)
end
function t2.FetchAgeVerificationOverlay(p22, p23) -- line: 444
	-- upvalues: Promise (copy)
	if not p22._getShowAgeVerificationOverlayResult then
		if not p22._getShowAgeVerificationOverlayPromise then
			p22._getShowAgeVerificationOverlayPromise = Promise.new(function(resolve, _) -- line: 447
				-- upvalues: p22 (copy), p23 (copy)
				p22._getShowAgeVerificationOverlayResult = p22:_GetShowAgeVerificationOverlay(p23)
				resolve(p22._getShowAgeVerificationOverlayResult)
			end)
		end

		p22._getShowAgeVerificationOverlayPromise:await()
	end

	return p22._getShowAgeVerificationOverlayResult
end
function t2._GetShowPhoneVerificationUpsell(t5: {[any]: any}, s3: string, n1: number?) -- line: 463
	-- upvalues: GetShowPhoneVerificationUpsell (copy), Utils (copy)
	return (GetShowPhoneVerificationUpsell(Utils.bind(t5, "GetRequest"), tostring(game.GameId), s3, n1))
end
function t2.FetchPhoneVerificationUpsell(t6: {[any]: any}, s4: string, n2: number?, b1: boolean?) -- line: 476
	-- upvalues: Promise (copy), Constants (copy)
	if not t6._getShowPhoneVerificationUpsellResult then
		t6._getShowPhoneVerificationUpsellResult = {}
		t6._getShowPhoneVerificationUpsellPromise = {}
	end

	if not t6._getShowPhoneVerificationUpsellResult[s4] or b1 then
		if not t6._getShowPhoneVerificationUpsellPromise[s4] or b1 then
			t6._getShowPhoneVerificationUpsellPromise[s4] = Promise.new(function(resolve, _) -- line: 487
				-- upvalues: t6 (copy), s4 (copy), n2 (copy), Constants (copy)
				local v430 = t6:_GetShowPhoneVerificationUpsell(s4, n2)

				t6._getShowPhoneVerificationUpsellResult[s4] = if type(v430) ~= "table" or v430.valueProp == nil then Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None else v430.valueProp
				resolve()
			end)
		end

		t6._getShowPhoneVerificationUpsellPromise[s4]:await()
	end

	return t6._getShowPhoneVerificationUpsellResult[s4]
end
function t2.DisablePhoneVerificationUpsell(p26) -- line: 501
	-- upvalues: Cryo (copy), Constants (copy)
	p26._getShowPhoneVerificationUpsellResult = Cryo.Dictionary.map(p26._getShowPhoneVerificationUpsellResult, function() -- line: 504
		-- upvalues: Constants (copy)
		return Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None
	end)
end
function t2.GetNudgeAnalyticsData(p27) -- line: 510
	-- upvalues: Players (copy)
	return Players.LocalPlayer.UserId, p27:GetSessionId()
end
function t2.avatarChatUserAndPlaceSettingsValueOfClientFeatures(p28, p29) -- line: 515
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
function t2.resolveAvatarChatUserAndPlaceSettings(p30) -- line: 562
	local ok, result = pcall(p30.AvatarChatService.GetClientFeaturesAsync, p30.AvatarChatService)

	if not ok then
		return nil
	end

	return p30:avatarChatUserAndPlaceSettingsValueOfClientFeatures(result)
end
function t2.GetRequest(p31, p32, _) -- line: 572
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 573
		-- upvalues: p31 (copy), p32 (copy), HttpService (copy)
		local AsyncFullUrl = p31.HttpRbxApiService:GetAsyncFullUrl(p32, Enum.ThrottlingPriority.Default, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(AsyncFullUrl)
	end)

	return ok and result
end
function t2.PostUserVoiceConnectionStatus(p34, p35) -- line: 581
	-- upvalues: HttpService (copy), Constants (copy)
	local ok, _ = pcall(function() -- line: 582
		-- upvalues: HttpService (copy), p35 (copy), p34 (copy), Constants (copy)
		local json = HttpService:JSONEncode({
			IsUserVoiceConnected = p35
		})
		local v433 = p34.HttpRbxApiService:PostAsyncFullUrl(Constants.VOICE_URL .. "/v1/user-voice-connection-state", json)

		return HttpService:JSONDecode(v433)
	end)

	return ok
end
function t2.GetVoiceAnalyticsData(p36) -- line: 591
	-- upvalues: EngineFeature2 (copy), RbxAnalyticsService (copy)
	return {
		micAvailability = "",
		universeId = game.GameId,
		placeId = game.PlaceId,
		playSessionId = not EngineFeature2 and "" or RbxAnalyticsService:GetPlaySessionId(),
		voiceSessionId = not p36.service and "" or p36:GetSessionId()
	}
end
function t2.RecordExperienceJoinMicPermissionStatus(p37, p38) -- line: 603
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
function t2.CheckCaptureMute(p39) -- line: 623
	-- upvalues: GetFFlagEnableVoiceChatMuteForVideoCaptures (copy)
	if GetFFlagEnableVoiceChatMuteForVideoCaptures() then
		return p39.CaptureService:IsCapturingVideo()
	end

	return false
end
function t2.ToggleMuteSome(t9: {[any]: any}, t10: {[any]: any}, b2: boolean, s5: string, s6: string) -- line: 632
	-- upvalues: VoiceChatService (copy), EngineFeature (copy), Players (copy)
	t9:ensureInitialized("mute some players")
	t9._mutedAnyone = true

	local t11 = {}
	local v163 = b2 or t9:CheckCaptureMute()

	for _, v165 in t10 do
		if VoiceChatService.UseNewAudioApi then
			t11[v165] = true
			t9.mutedPlayers[v165] = v163
		else
			t9.service:SubscribePause(v165, v163)
		end

		local v166 = t9.participants[tostring(v165)]

		if v166 then
			v166.isMutedLocally = v163
			t9.participantsUpdate:Fire(t9.participants)
		end
	end

	if VoiceChatService.UseNewAudioApi then
		for v167 in t9.audioDevices do
			if v167.Player and t11[v167.Player.UserId] then
				if EngineFeature and v167.Player ~= Players.LocalPlayer then
					v167.MutedByLocalUser = v163
				else
					if not EngineFeature then
					end

					v167.Active = not v163
				end
			end
		end
	end

	if s5 and s6 then
		t9.Analytics:reportVoiceMuteGroup((t9:JoinWithVoiceMuteData({
			groupType = s5,
			context = s6,
			muted = v163
		})))
	end
end
function t2.GetMutedAnyone(p40) -- line: 677
	return p40._mutedAnyone
end
function t2.ToggleMutePlayer(t12: {[any]: any}, n3: number, s7: string) -- line: 681
	-- upvalues: VoiceChatService (copy), v30 (copy), Utils (copy), GetFFlagEnableFtuxExitOnMuteToggle (copy), EngineFeature (copy), Players (copy)
	t12:ensureInitialized("mute player " .. n3)
	t12._mutedAnyone = true

	local v172 = ((if not VoiceChatService.UseNewAudioApi then not t12.service:IsSubscribePaused(n3) else not t12.mutedPlayers[n3])) or t12:CheckCaptureMute()

	v30:trace("Setting mute for {} to {}", Utils.shorten(n3), v172)

	if GetFFlagEnableFtuxExitOnMuteToggle() then
		t12.onPlayerMuteToggled:Fire()
	end

	if VoiceChatService.UseNewAudioApi then
		t12.mutedPlayers[n3] = v172

		for v173 in t12.audioDevices do
			if v173.Player and n3 == v173.Player.UserId then
				if EngineFeature and v173.Player ~= Players.LocalPlayer then
					v173.MutedByLocalUser = v172
				else
					if not EngineFeature then
					end

					local v174 = t12.participants[tostring(n3)]
					local v175 = v174 and not v174.isMuted

					v173.Active = not v172 and v175
				end
			end
		end

		t12:emit("OnPlayerMuted")
	else
		t12.service:SubscribePause(n3, v172)
	end

	for _, v in pairs(t12.participants) do
		if n3 == v.userId then
			v.isMutedLocally = v172
			t12.participantsUpdate:Fire(t12.participants)
		end
	end

	if s7 then
		t12.Analytics:reportVoiceMuteIndividual((t12:JoinWithVoiceMuteData({
			targetUserId = tonumber(n3),
			context = s7,
			muted = v172
		})))
	end
end
function t2.MuteAll(t13: {[any]: any}, b3: boolean, s8: string) -- line: 735
	-- upvalues: VoiceChatService (copy), v30 (copy), Players (copy), EngineFeature (copy), Constants (copy)
	t13:ensureInitialized("mute all")
	t13._mutedAnyone = true

	local v181 = b3 or t13:CheckCaptureMute()

	if VoiceChatService.UseNewAudioApi then
		t13.muteAll = v181
		v30:trace("Setting self mute all to {} context: {}", v181, s8)

		for v182 in t13.audioDevices do
			if v182.Player and v182.Player ~= Players.LocalPlayer then
				v30:debug("Local muting {} to '{} = {}'", v182.Player.Name, v182.Active, v181)

				if EngineFeature then
					v182.MutedByLocalUser = v181
				else
					local UserId = v182.Player.UserId

					t13.mutedPlayers[UserId] = v181

					local v184 = t13.participants[tostring(UserId)]
					local v185 = v184 and not v184.isMuted

					v182.Active = not v181 and v185
				end
			end
		end
	else
		t13.service:SubscribePauseAll(v181)
	end

	for _, v in pairs(t13.participants) do
		v.isMutedLocally = v181
		t13.participantsUpdate:Fire(t13.participants)
	end

	t13.muteAllChanged:Fire(v181)

	if s8 then
		t13.Analytics:reportVoiceMuteGroup((t13:JoinWithVoiceMuteData({
			groupType = Constants.VOICE_GROUP_TYPE.ALL,
			context = s8,
			muted = v181
		})))
	end
end
function t2.FetchVoicePermissions(p41) -- line: 778
	if not p41.communicationPermissionsResult then
		p41.communicationPermissionsResult = p41:resolveAvatarChatUserAndPlaceSettings()
	end

	return p41.communicationPermissionsResult
end
function t2.verifyUniverseAndPlaceCanUseVoice(p42) -- line: 786
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), Analytics (copy)
	local v190 = if not GetFFlagAvatarChatServiceEnabled() or not GetFFlagVoiceChatServiceManagerUseAvatarChat() then p42:FetchAgeVerificationOverlay() else p42:resolveAvatarChatUserAndPlaceSettings()

	if not v190 then
		p42:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	local universePlaceVoiceEnabledSettings = v190.universePlaceVoiceEnabledSettings

	return universePlaceVoiceEnabledSettings and (universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice and universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice)
end
function t2.IsUserInFTUX(p43) -- line: 806
	-- upvalues: GetFFlagSeamlessVoiceFTUX (copy), GetFFlagCheckUniversePlaceBeforeSuspending (copy), v30 (copy)
	if not GetFFlagSeamlessVoiceFTUX() then
		return false
	end

	if GetFFlagCheckUniversePlaceBeforeSuspending() and not p43:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local AppStorageService2 = game:GetService("AppStorageService")
	local u194 = nil

	if not pcall(function() -- line: 816
		-- upvalues: AppStorageService2 (copy), u194 (ref)
		u194 = AppStorageService2:GetItem("SeamlessVoiceFTUX") == "true"
	end) then
		v30:warning("Failed to read FTUX/STUX from AppStorage")

		return false
	end

	local v195 = p43:FetchAgeVerificationOverlay()

	if type(v195) == "table" and v195.voiceSettings and v195.voiceSettings.seamlessVoiceStatus ~= 3 then
		v30:debug("User not eligible for FTUX/STUX")

		return false
	end

	return not u194
end
function t2.isEnableDefaultVoiceOnForPlace(_) -- line: 839
	-- upvalues: VoiceChatService (copy)
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	return VoiceChatService.UseNewAudioApi or VoiceChatService.EnableDefaultVoice
end
function t2.verifyPlaceCanUseVoice(p45, p46, p47) -- line: 850
	-- upvalues: Analytics (copy)
	if not p46 or not p47 then
		p45:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	if not p46.isUniverseEnabledForVoice then
		p45:_reportJoinFailed("universeNotEnabled")

		return false
	end

	p45:emit("OnUserAndPlaceCanUseVoiceResolved", p47, p46)

	if not p46.isPlaceEnabledForVoice then
		p45:_reportJoinFailed("placeNotEnabled")

		return false
	end

	if not p45:isEnableDefaultVoiceOnForPlace() then
		return false
	end

	return true
end
function t2.EligibleForFaeUpsell(p48) -- line: 875
	-- upvalues: FAE_ENABLED (copy)
	local v201 = p48:FetchAgeVerificationOverlay()

	if not v201 or type(v201) ~= "table" then
		return false
	end

	local v202 = v201.inExperienceFaeUpsell == FAE_ENABLED
	local isPlaceEnabledForVoice = v201.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice

	return v202 and isPlaceEnabledForVoice
end
function t2.OptUserToJoinVoice(p49) -- line: 885
	-- upvalues: v30 (copy)
	v30:debug("Opting user to join voice on age verification")
	p49.hasOptedToJoinVoiceOnAgeVerification = true
end
function t2.SetupFAECompleteListener(p50) -- line: 890
	-- upvalues: v30 (copy)
	v30:debug("Setting up FAE complete listener")

	if game:GetEngineFeature("ChatReconcileAccess") then
		v30:debug("Using ChatService ReconcileCommunicationAccessCompleted event")
		p50.ChatService.ReconcileCommunicationAccessCompleted:Connect(function() -- line: 894
			-- upvalues: v30 (copy), p50 (copy)
			v30:debug("FAE complete listener triggered, re-fetching voice permissions")
			p50.communicationPermissionsResult = nil
			p50:FetchVoicePermissions()
			p50._getShowAgeVerificationOverlayResult = p50:_GetShowAgeVerificationOverlay()

			if p50.hasOptedToJoinVoiceOnAgeVerification then
				v30:debug("FAE complete listener triggered, attempting voice rejoin")

				if p50:IsSeamlessVoice() then
					v30:debug("Opting-in user to voice")
					p50.AvatarChatService:EnableVoice()
					p50.attemptVoiceRejoin:Fire()
				end
			end
		end)
	end
end
function t2.EligibleForAgeCheckToast(p51) -- line: 914
	-- upvalues: FAE_SETTINGS_TOAST (copy)
	local v207 = p51:FetchAgeVerificationOverlay()

	if not v207 or type(v207) ~= "table" then
		return false
	end

	local isPlaceEnabledForVoice = v207.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	local v209 = v207.inExperienceFaeUpsell == FAE_SETTINGS_TOAST

	return isPlaceEnabledForVoice and (p51:isEnableDefaultVoiceOnForPlace() and v209)
end
function t2.userAndPlaceCanUseVoice(p52) -- line: 924
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), GetShowAgeVerificationOverlay (copy), Utils (copy), Analytics (copy), v30 (copy), GetFFlagEnableVoiceSignal (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), Constants (copy), VOICE_JOIN_PROGRESS (copy), GetFFlagEnableVoiceUxUpdates (copy), GetFFlagNonVoiceFTUX (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if p52.ThirdPartyUserService ~= nil and (p52.ThirdPartyUserService:IsChatRestrictionSupported() and p52.ThirdPartyUserService:GetVoiceChatRestrictionStatus() ~= Enum.ChatRestrictionStatus.NotRestricted) then
		return false
	end

	local v211 = if not GetFFlagAvatarChatServiceEnabled() or not GetFFlagVoiceChatServiceManagerUseAvatarChat() then GetShowAgeVerificationOverlay(Utils.bind(p52, "GetRequest"), tostring(game.GameId), (tostring(game.PlaceId))) else p52:resolveAvatarChatUserAndPlaceSettings()

	if not v211 then
		p52:_reportJoinFailed("invalidResponse", Analytics.ERROR)

		return false
	end

	if p52.options.forceVoiceEnabled then
		v211.voiceSettings.isVoiceEnabled = true
		v30:debug("bypassing voice permissions check")
	end

	local universePlaceVoiceEnabledSettings = v211.universePlaceVoiceEnabledSettings
	local voiceSettings = v211.voiceSettings

	v30:trace("Voice settings endpoint returned {}", v211)

	if not p52:verifyPlaceCanUseVoice(universePlaceVoiceEnabledSettings, voiceSettings) then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		p52.communicationPermissionsResult = v211

		local v214 = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and os.time()
		local v215 = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and (not p52:UserVoiceEnabled() and (not voiceSettings.isUserVerifiedForVoice and (p52:FetchPhoneVerificationUpsell(Constants.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat or v214 and p52:FetchPhoneVerificationUpsell(Constants.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER, v214) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat)))

		if p52:UserEligibleForInExperienceUpsell() or v215 then
			p52:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
		end

		if GetFFlagEnableVoiceUxUpdates() then
			local VoiceConnectCookie = p52:GetVoiceConnectCookie()
			local v217 = p52:HasSeamlessVoiceFeature(Constants.SeamlessVoiceFeatures.DeferConnection) and VoiceConnectCookie == ""
			local v218 = p52:IsSeamlessVoice() and VoiceConnectCookie == "false"

			if v217 or v218 then
				p52:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif p52:EligibleForFaeUpsell() then
				v30:debug("Suspending voice join for FAE Eligible user")
				p52:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
				p52:SetupFAECompleteListener()
			end
		else
			if GetFFlagNonVoiceFTUX() and p52:IsUserInFTUX() then
				p52:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			end

			if p52:IsSeamlessVoice() and not p52:GetVoiceConnectCookieValue() then
				v30:debug("Suspending voice join due to voice connect cookie")
				p52:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif GetFFlagEnableSeamlessVoiceV2() and p52:IsNewSeamlessVoiceUserDisconnect() then
				v30:debug("Suspending voice join for new seamless voice user")
				p52:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			elseif p52:IsSeamlessVoice() and p52:UserOnlyEligibleForVoice() then
				v30:debug("Suspending voice join for opt-out user")
				p52:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			end
		end

		task.spawn(function() -- line: 1021
			-- upvalues: p52 (copy)
			p52:FetchAgeVerificationOverlay()
		end)
	end

	if not voiceSettings.isVoiceEnabled then
		p52:_reportJoinFailed("userNotEnabled")
	end

	return voiceSettings.isVoiceEnabled
end
function t2.voicePermissionGranted(_, p54) -- line: 1036
	-- upvalues: PermissionsProtocol (copy), Cryo (copy)
	if typeof(p54) == "table" then
		return p54.status == PermissionsProtocol.Status.AUTHORIZED or not Cryo.List.find(p54.missingPermissions, PermissionsProtocol.Permissions.MICROPHONE_ACCESS)
	end

	return p54 == PermissionsProtocol.Status.AUTHORIZED
end
function t2.RawGetPermissions(p55, p56) -- line: 1056
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 1057
		-- upvalues: p55 (copy), p56 (copy)
		p55:emit("GetPermissions", function(p58) -- line: 1058
			-- upvalues: resolve (copy)
			resolve(p58)
		end, p56, true, true)
	end)
end
function t2.requestMicPermission(p59) -- line: 1065
	-- upvalues: v30 (copy), PermissionsProtocol (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), Promise (copy), GetFFlagEnableExpJoinMicPermAnalytics (copy), Analytics (copy)
	if p59.permissionPromise then
		v30:trace("PermissionProtocol already invoked")

		return p59.permissionPromise
	end

	local t14 = { PermissionsProtocol.Permissions.MICROPHONE_ACCESS }
	local v228

	if not GetFFlagEnableSeamlessVoiceV2() and GetFFlagJoinWithoutMicPermissions(p59:IsSeamlessVoice()) then
		v30:debug("Requesting device permission")

		local ok, result, v227 = pcall(function() -- line: 1079
			-- upvalues: p59 (copy), t14 (copy)
			return p59:RawGetPermissions(t14):await()
		end)

		if ok and result then
			if v227.status == PermissionsProtocol.Status.AUTHORIZED then
				p59.permissionState = PERMISSION_STATE.LISTEN_AND_TALK
			elseif v227.missingPermissions then
				p59.permissionState = PERMISSION_STATE.PENDING_MIC
			elseif v227.deniedPermissions then
				p59.permissionState = PERMISSION_STATE.LISTEN_ONLY
			else
				v30:error("PermissionsService returned unknown permission state. Defaulting to listen only.")
				p59.permissionState = PERMISSION_STATE.LISTEN_ONLY
			end
		else
			v30:error("PermissionsService call failed.")
			p59.permissionState = PERMISSION_STATE.LISTEN_ONLY
		end

		v30:debug("Joining without mic permissions. Permission State: {}", p59.permissionState)
		v228 = Promise.resolve()
	else
		v228 = p59.PermissionsService:requestPermissions(t14)
	end

	p59.permissionPromise = v228:andThen(function(p60) -- line: 1108
		-- upvalues: GetFFlagEnableExpJoinMicPermAnalytics (copy), p59 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), Promise (copy), v30 (copy), Analytics (copy), PermissionsProtocol (copy)
		if GetFFlagEnableExpJoinMicPermAnalytics() then
			p59:RecordExperienceJoinMicPermissionStatus(p60)
		end

		if not GetFFlagEnableSeamlessVoiceV2() and GetFFlagJoinWithoutMicPermissions() then
			return Promise.resolve()
		end

		if not p60 and not p60.status then
			v30:debug("No permission response, rejecting access")
			p59:_reportJoinFailed("noPermissionResponse", Analytics.ERROR)

			if p59.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_NO_PERM_RESPONSE"
				})
			end

			return Promise.reject()
		end

		v30:debug("Permission status {}", p60.status)

		local v437 = p60.status == PermissionsProtocol.Status.AUTHORIZED

		if p59.options.passInitErrorInPromiseReject and not v437 then
			return Promise.reject({
				code = "INIT_ERROR_PERM_NOT_GRANTED"
			})
		end

		return v437 and Promise.resolve() or Promise.reject()
	end):andThen(function() -- line: 1132
		-- upvalues: p59 (copy), Promise (copy)
		p59:emit("OnRequestMicPermissionResolved")

		return Promise.resolve()
	end):catch(function() -- line: 1137
		-- upvalues: p59 (copy), Promise (copy)
		p59:emit("OnRequestMicPermissionRejected")

		if p59.options.passInitErrorInPromiseReject then
			return Promise.reject({
				code = "INIT_ERROR_MIC_PERM_REJECTED"
			})
		end

		return Promise.reject()
	end)

	return p59.permissionPromise
end
function t2.JoinByGroupIdToken(p61, p62, p63) -- line: 1147
	p61.previousGroupId = p62
	p61.previousMutedState = p63

	return p61.service:JoinByGroupIdToken(p62, p63)
end
function t2.EnableVoice(p64) -- line: 1153
	-- upvalues: v30 (copy)
	v30:trace("Enabling voice")
	p64.AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Once(function() -- line: 1156
		-- upvalues: p64 (copy)
		p64.attemptVoiceRejoin:Fire()
	end)
	p64.AvatarChatService:EnableVoice()
end
function t2.ChangeVoiceJoinProgress(p65, p66) -- line: 1162
	p65.VoiceJoinProgress = p66
	p65.VoiceJoinProgressChanged:Fire(p65.VoiceJoinProgress)
end
function t2.setOptions(t15: {[any]: any}, t16: {[any]: any}) -- line: 1167
	t15.options = t16
end
function t2.ShouldShowJoinVoiceOnDisconnect(p67) -- line: 1171
	-- upvalues: VOICE_JOIN_PROGRESS (copy)
	return p67:IsSeamlessVoice() and p67.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended
end
function t2.IsSeamlessVoice(p68) -- line: 1175
	-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagCheckUniversePlaceBeforeSuspending (copy), Constants (copy)
	if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and not p68.options.allowSeamlessVoice then
		return false
	end

	local v239 = p68:FetchAgeVerificationOverlay()

	if type(v239) ~= "table" or not v239 or not v239.voiceSettings then
		return false
	end

	if GetFFlagCheckUniversePlaceBeforeSuspending() and not p68:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local seamlessVoiceStatus = v239.voiceSettings.seamlessVoiceStatus

	return seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledExistingUser or seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledNewUser
end
function t2.HasSeamlessVoiceFeature(p69, p70) -- line: 1197
	-- upvalues: GetFFlagEnableSeamlessVoiceFeature (copy), Utils (copy), Constants (copy)
	if not p69.options.allowSeamlessVoice or not p69:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local v243 = p69:FetchAgeVerificationOverlay()

	if not p69:_isValidAgeVerificationOverlayData(v243) then
		return false
	end

	local seamlessVoiceVariant = v243.voiceSettings.seamlessVoiceVariant

	if not seamlessVoiceVariant then
		return false
	end

	if GetFFlagEnableSeamlessVoiceFeature() then
		if type(p70) == "string" then
			p70 = { p70 }
		end

		if GetFFlagEnableSeamlessVoiceFeature(p70) then
			local v245 = Utils.jsonDecode(seamlessVoiceVariant)
			local t17 = {}

			for _, v in pairs(v245) do
				t17[v] = true
			end

			if #p70 == 1 and p70[1] == Constants.SeamlessVoiceFeatures.ConnectDisconnect and seamlessVoiceVariant == Constants.SeamlessVoiceVariants.OnlyConnectDisconnect then
				return true
			end

			for _, v in pairs(p70) do
				if not t17[v] then
					return false
				end
			end

			return true
		end
	else
		local v251 = ({
			[Constants.SeamlessVoiceFeatures.ConnectDisconnect] = function(p71) -- line: 1242
				-- upvalues: Constants (copy)
				return p71 ~= Constants.SeamlessVoiceVariants.Control
			end,
			[Constants.SeamlessVoiceFeatures.HearingWithoutMicPermissions] = function(p72) -- line: 1245
				-- upvalues: Constants (copy)
				return p72 == Constants.SeamlessVoiceVariants.HearingWithoutMicPermissions
			end
		})[p70]

		if v251 then
			return v251(seamlessVoiceVariant)
		end
	end

	return false
end
function t2.IsNewSeamlessVoiceUserDisconnect(p73) -- line: 1259
	-- upvalues: Constants (copy)
	if not p73.options.allowSeamlessVoice or not p73:verifyUniverseAndPlaceCanUseVoice() then
		return false
	end

	local v253 = p73:FetchAgeVerificationOverlay()

	if not p73:_isValidAgeVerificationOverlayData(v253) then
		return false
	end

	if v253.voiceSettings.seamlessVoiceStatus ~= Constants.SeamlessVoiceStatus.EnabledNewUser then
		return false
	end

	local ok, result = pcall(function() -- line: 1278
		-- upvalues: p73 (copy), Constants (copy)
		return p73.AppStorageService:GetItem(Constants.SEAMLESS_VOICE_FTUX_KEY)
	end)

	return ok and result == "false"
end
function t2._isValidAgeVerificationOverlayData(_: {[any]: any}, t19: {[any]: any}?) -- line: 1286
	return type(t19) == "table" and (t19 and t19.voiceSettings)
end
function t2.UserInInExperienceUpsellTreatment(p74) -- line: 1290
	-- upvalues: Constants (copy)
	local v259 = p74:FetchAgeVerificationOverlay()

	if not v259 then
		return false
	end

	local showVoiceInExperienceUpsellVariant = v259.showVoiceInExperienceUpsellVariant

	return showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT1 or (showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT2 or showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT3)
end
function t2.UserOnlyEligibleForVoice(p75) -- line: 1302
	-- upvalues: v33 (copy)
	local communicationPermissionsResult = p75.communicationPermissionsResult

	if not communicationPermissionsResult or (not communicationPermissionsResult.voiceSettings or not communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		if not v33 then
			return false
		end

		p75:FetchVoicePermissions()
		communicationPermissionsResult = p75.communicationPermissionsResult
	end

	return communicationPermissionsResult.voiceSettings.isUserVerifiedForVoice and (not communicationPermissionsResult.voiceSettings.isVoiceEnabled and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice)
end
function t2.UserOnlyEligibleForVoiceViaOverlay(p76) -- line: 1318
	local v264 = p76:FetchAgeVerificationOverlay()

	if not p76:_isValidAgeVerificationOverlayData(v264) then
		return false
	end

	return v264.voiceSettings.isVerifiedForVoice and (not v264.voiceSettings.isVoiceEnabled and v264.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice)
end
function t2.UserVoiceEnabled(p77) -- line: 1331
	local communicationPermissionsResult = p77.communicationPermissionsResult

	if not communicationPermissionsResult or (not communicationPermissionsResult.voiceSettings or not communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		return false
	end

	return communicationPermissionsResult.voiceSettings.isVoiceEnabled and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
end
function t2.UserEligibleForInExperienceUpsell(p78) -- line: 1341
	-- upvalues: GetFFlagEnableVoiceSignal (copy)
	local v268 = p78:UserOnlyEligibleForVoice()

	if not v268 then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		local v269 = p78:UserInInExperienceUpsellTreatment()

		return v268 and v269
	end

	local v270 = p78:FetchAgeVerificationOverlay()

	return v268 and (v270 and v270.showVoiceInExperienceUpsell)
end
function t2.canUseServiceAsync(p79) -- line: 1362
	-- upvalues: v30 (copy), Promise (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), VOICE_CHAT_AVAILABILITY (copy), VoiceChatService (copy), v34 (copy), IXPServiceWrapper (copy), v36 (copy), v37 (copy)
	if p79.available ~= nil or not game:GetEngineFeature("VoiceChatSupported") then
		v30:debug("Voice Chat is not Available, rejecting canUseService promise")

		if p79.options.passInitErrorInPromiseReject then
			return Promise.reject({
				code = "INIT_ERROR_VOICE_NOT_SUPPORTED"
			})
		end

		return Promise.reject()
	end

	if not p79.canUseServicePromise then
		p79.canUseServicePromise = Promise.defer(function(p80, p81) -- line: 1372
			-- upvalues: p79 (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), v30 (copy), VOICE_CHAT_AVAILABILITY (copy), VoiceChatService (copy), v34 (copy), IXPServiceWrapper (copy), v36 (copy), v37 (copy)
			local v442 = p79:userAndPlaceCanUseVoice()

			if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
				p79.canUseServiceResult = v442
				p79:emit("OnCanUseServiceResult", v442)
			end

			if GetFFlagEnableVoiceSignal() and p79.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended then
				v30:debug("Place is voice enabled but user is not, delaying voice rejection")
				p79.attemptVoiceRejoin.Event:Wait()
				v30:debug("Attempting voice rejoin")
				p79.communicationPermissionsResult.voiceSettings.isVoiceEnabled = true
				p79.userEligible = true
				p79.initializedPostSuspension = true
				p80()
				p79:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joining)

				return
			end

			if not v442 then
				v30:info("Voice access denied")
				p79.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable

				if p79.options.passInitErrorInPromiseReject then
					p81({
						code = "INIT_ERROR_USER_NOT_AVAILABLE"
					})

					return
				end

				p81()

				return
			end

			if game:GetEngineFeature("VoiceChatEnabledRccProperties") and (not VoiceChatService.VoiceChatEnabledForUniverseOnRcc or not VoiceChatService.VoiceChatEnabledForPlaceOnRcc) then
				v30:debug("Disabling voice chat due to RCC Response. Universe: {}, Place: {}", VoiceChatService.VoiceChatEnabledForUniverseOnRcc, VoiceChatService.VoiceChatEnabledForPlaceOnRcc)

				if not VoiceChatService.VoiceChatEnabledForUniverseOnRcc then
					p79:_reportJoinFailed("universeNotEnabled")
				elseif not VoiceChatService.VoiceChatEnabledForPlaceOnRcc then
					p79:_reportJoinFailed("placeNotEnabled")
				end

				p79.available = VOICE_CHAT_AVAILABILITY.PlaceNotAvailable

				if p79.options.passInitErrorInPromiseReject then
					p81({
						code = "INIT_ERROR_PLACE_NOT_AVAILABLE"
					})

					return
				end

				p81()

				return
			end

			if v34 then
				IXPServiceWrapper:WaitForInitialization()

				local ok, result = pcall(function() -- line: 1432
					-- upvalues: IXPServiceWrapper (copy), v36 (copy)
					return IXPServiceWrapper:GetLayerData(v36)
				end)

				if ok and result and result[v37] ~= nil then
					p79.userEligible = result[v37]
					IXPServiceWrapper:LogUserLayerExposure(v36)
				end

				if p79.userEligible then
					p80()

					return
				end

				if p79.options.passInitErrorInPromiseReject then
					p81({
						code = "INIT_ERROR_IXP_NOT_ELIGIBLE"
					})

					return
				end

				p81()

				return
			end

			p79.userEligible = true
			p80()
		end):andThen(function() -- line: 1454
			-- upvalues: p79 (copy)
			return p79:requestMicPermission()
		end)
	end

	return p79.canUseServicePromise
end
function t2._setRecentUserState(p82, p83, p84) -- line: 1461
	-- upvalues: Cryo (copy)
	local v275 = p82.recentUsersInteractionData[tostring(p83)] or {}
	local v276 = Cryo.Dictionary.join(v275, p84)

	p82.recentUsersInteractionData = Cryo.Dictionary.join(p82.recentUsersInteractionData, {
		[tostring(p83)] = v276
	})
end
function t2.getRecentUsersInteractionData(p85) -- line: 1471
	p85:_updateRecentUsersInteractionData()

	return p85.recentUsersInteractionData
end
function t2.GetSignalREvent(p86, p87) -- line: 1476
	return p86.SignalREventTable[p87].Event
end
function t2.StartModerationSignal(p88) -- line: 1481
	-- upvalues: v30 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
	if not p88.playerModeratedConnection then
		p88.playerModeratedConnection = p88:GetSignalREvent("ParticipantModeratedFromVoice"):Connect(function() -- line: 1484
			-- upvalues: v30 (copy), p88 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
			v30:debug("User Moderated")
			p88.previousSessionId = p88.service:GetSessionId()
			p88:emit("OnPlayerModerated")

			if GetFFlagVoiceChatClientRewriteMasterLua() then
				VoiceChatService:notifyServerACSCleanup()
				VoiceChatService:leaveVoice()

				return
			end

			VoiceChatService:notifyServerACSCleanup()
			p88.service:Leave()
		end)
	end
end
function t2.StopModerationSignal(p89) -- line: 1499
	if p89.playerModeratedConnection then
		p89.playerModeratedConnection:Disconnect()
		p89.playerModeratedConnection = nil
	end
end
function t2._updateRecentUsersInteractionData(p90) -- line: 1506
	-- upvalues: v32 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), Players (copy), GetFIntVoiceUsersInteractionExpiryTimeSeconds (copy), Cryo (copy)
	local timestamp = os.time()
	local t20 = {}

	if p90.recentUsersInteractionData then
		for k, v in pairs(p90.recentUsersInteractionData) do
			local v287 = if not v32 then p90.participants[k] else p90.participants[tostring(k)]
			local v288 = GetFFlagClearUserFromRecentVoiceDataOnLeave() and not Players:GetPlayerByUserId((tonumber(k)))
			local v289 = timestamp - v.lastHeardTime >= GetFIntVoiceUsersInteractionExpiryTimeSeconds()
			local v290 = not v287 or v287.isMuted

			if v289 and v290 or v288 then
				t20[k] = Cryo.None
			end
		end

		p90.recentUsersInteractionData = Cryo.Dictionary.join(p90.recentUsersInteractionData, t20)
	end
end
function t2.SetupParticipantListeners(p91) -- line: 1530
	-- upvalues: v30 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), v32 (copy), GetFFlagFixGetPlayerByUserIdStringCast (copy), Players (copy), VoiceChatService (copy), FFlagEnablePartyVoiceChangersInLua (copy), GetFFlagBatchVoiceParticipantsUpdates (copy), v67 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v62 (copy), v63 (copy), GetFFlagDisconnectToastClientRewrite (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy), v61 (copy), MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY (copy), GetFFlagLocalMutedNilFix (copy), v38 (copy), GetFFlagLuaConsumePlayerModerated (copy), GetFFlagEnableVoiceReverseNudge (copy), Utils (copy), t1 (copy)
	p91:ensureInitialized("setup participant listeners")

	if not p91.participants then
		p91.participants = {}
		p91.recentUsersInteractionData = {}
		p91.updatedParticipants = {}
		p91.participantConnection = p91.service.ParticipantsStateChanged:Connect(function(p92, p93, p94) -- line: 1539
			-- upvalues: v30 (copy), GetFFlagClearUserFromRecentVoiceDataOnLeave (copy), p91 (copy), v32 (copy), GetFFlagFixGetPlayerByUserIdStringCast (copy), Players (copy), VoiceChatService (copy), FFlagEnablePartyVoiceChangersInLua (copy), GetFFlagBatchVoiceParticipantsUpdates (copy), v67 (copy)
			v30:trace("Participants state changed")

			for _, v in ipairs(p92) do
				if not GetFFlagClearUserFromRecentVoiceDataOnLeave() and not p91.participants[tostring(v)].isMuted then
					p91:_setRecentUserState(v, {
						lastHeardTime = os.time()
					})
				end

				p91.participants[tostring(v)] = nil
				p91.participantLeft:Fire(p91.participants, v)
				p91:emit("OnVoiceParticipantRemoved", v)
			end

			for _, v in ipairs(p93) do
				p91.participantJoined:Fire(p91.participants, v)
				p91:emit("OnVoiceParticipantAdded", v)
			end

			for _, v in pairs(p94) do
				local userId = v.userId
				local v455 = if not v32 then p91.participants[userId] else p91.participants[tostring(userId)]

				if not v.isMuted or v455 and not v455.isMuted then
					p91:_setRecentUserState(userId, {
						lastHeardTime = os.time(),
						player = if not GetFFlagFixGetPlayerByUserIdStringCast() then Players:GetPlayerByUserId(userId) else Players:GetPlayerByUserId((tonumber(userId)))
					})
				end

				if not v455 or v455.isMuted ~= v.isMuted then
					p91:emit("OnVoiceParticipantToggleMuted", userId, v.isMuted)
				end

				if VoiceChatService.UseNewAudioApi then
					v.isMutedLocally = not not p91.mutedPlayers[userId]
				end

				if VoiceChatService.UseNewAudioApi then
					v.isMutedLocally = if not p91.mutedPlayers[userId] then v.isMutedLocally else not not p91.mutedPlayers[userId]
				end

				if FFlagEnablePartyVoiceChangersInLua and VoiceChatService.UseNewAudioApi then
					v.isVoiceChangerActive = if not p91.voiceChangerActivePlayers[userId] then v.isVoiceChangerActive else p91.voiceChangerActivePlayers[userId]
				end

				if p91.muteAll then
					v.isMutedLocally = true
				end

				p91.participants[tostring(userId)] = v

				if GetFFlagBatchVoiceParticipantsUpdates() then
					p91.updatedParticipants[tostring(userId)] = v
				end

				if v67 and p91.CaptureService:IsCapturingVideo() then
					p91.voiceCapturedDuringVideoCapture = p91.voiceCapturedDuringVideoCapture or v.isSignalActive
				end
			end

			p91:_updateRecentUsersInteractionData()

			if p91.shouldThrottleParticipantUpdate then
				local timestamp = tick()

				if timestamp - p91.lastParticipantsStateUpdate >= p91.participantsStateThrottleTime and #p94 > 0 then
					p91.lastParticipantsStateUpdate = timestamp
					p91.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p91.participants else p91.updatedParticipants)
					p91.updatedParticipants = {}

					return
				end

				if #p94 > 0 then
					local v457 = p91.participantsStateThrottleTime - (timestamp - p91.lastParticipantsStateUpdate)

					p91.lastStateUpdateCounter = (p91.lastStateUpdateCounter + 1) % 100

					local lastStateUpdateCounter = p91.lastStateUpdateCounter

					task.wait(v457)

					if lastStateUpdateCounter == p91.lastStateUpdateCounter then
						p91.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p91.participants else p91.updatedParticipants)
						p91.updatedParticipants = {}

						return
					end
				end
			elseif #p94 > 0 then
				p91.participantsUpdate:Fire(if not GetFFlagBatchVoiceParticipantsUpdates() then p91.participants else p91.updatedParticipants)
				p91.updatedParticipants = {}
			end
		end)

		local function onStateChanged(p95, p96) -- line: 1657
			-- upvalues: p91 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v30 (copy), v62 (copy), v63 (copy), GetFFlagDisconnectToastClientRewrite (copy), GetFFlagEnableVoiceSignal (copy), VOICE_JOIN_PROGRESS (copy)
			p91:emit("OnStateChanged", p95, p96)

			local v461 = p96 == Enum.VoiceChatState.Failed
			local v462 = p96 == Enum.VoiceChatState.Joining
			local v463 = p96 == Enum.VoiceChatState.Leaving
			local v464 = p96 == Enum.VoiceChatState.Ended
			local v465 = p91.service:IsPublishPaused()

			if v465 ~= p91.localMuted and (not v461 and not v462 and not v463 and not v464) then
				p91.localMuted = v465
				p91.muteChanged:Fire(v465)
			elseif v462 or v463 or v464 then
				p91.localMuted = nil
			end

			if GetFFlagVoiceChatClientRewriteMasterLua() and p96 == Enum.VoiceChatState.Joined and p91.isInCall and v465 ~= p91.callMutedState then
				v30:debug("In call, setting local muted to call muted state {}", p91.callMutedState)
				p91:ToggleMic("InitInCall")
			end

			if v62 and p96 == Enum.VoiceChatState.Joined then
				p91:StartModerationSignal()
			end

			if p96 == Enum.VoiceChatState.Leaving then
				if not v63 or not p91.previousGroupId then
					p91.previousGroupId = p91.service:GetGroupId()
				end

				p91.previousMutedState = p91.service:IsPublishPaused()
			end

			if p96 == Enum.VoiceChatState.Ended or v461 then
				p91.participants = {}
				p91.localMuted = nil
				p91.participantsUpdate:Fire(p91.participants)

				if v62 then
					p91:StopModerationSignal()
				end

				if v461 then
					v30:debug("State Changed to Failed. Reason: {}", p91.service:GetAndClearCallFailureMessage())
				end

				if p95 == Enum.VoiceChatState.Joining or p95 == Enum.VoiceChatState.JoiningRetry or p95 == Enum.VoiceChatState.Joined then
					if p96 == Enum.VoiceChatState.Ended then
						v30:debug("State Changed to Ended from {}", p95)
					end

					if not GetFFlagDisconnectToastClientRewrite() or not p91:IsSeamlessVoice() or p91:GetVoiceConnectCookieValue() then
						p91:emit("OnRetryRequested")
					end
				end
			end

			if GetFFlagEnableVoiceSignal() and p91.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Joining and p96 == Enum.VoiceChatState.Joined then
				p91:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joined)
				p91:emit("OnVoiceJoin")
			end
		end

		if p91.service.VoiceChatState and p91.service.VoiceChatState == Enum.VoiceChatState.Joined then
			v30:debug("Joined voice chat {}", p91.service.VoiceChatState)
			onStateChanged(nil, Enum.VoiceChatState.Joined)
		end

		p91.stateConnection = p91.service.StateChanged:Connect(onStateChanged)

		if v61 and VoiceChatService.UseNewAudioApi then
			if not p91.localMeteringTask then
				p91.localMeteringTask = task.spawn(function() -- line: 1744
					-- upvalues: p91 (copy)
					while true do
						p91:UpdateLocalMetering()
						task.wait()
					end
				end)
			end
		elseif p91.service:GetVoiceChatApiVersion() >= MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY then
			p91.micConnection = p91.service.PlayerMicActivitySignalChange:Connect(function(p97) -- line: 1753
				-- upvalues: v67 (copy), p91 (copy), GetFFlagLocalMutedNilFix (copy), v38 (copy)
				if v67 and p91.CaptureService:IsCapturingVideo() then
					p91.voiceCapturedDuringVideoCapture = p91.voiceCapturedDuringVideoCapture or p97.isActive
				end

				p91.isTalking = p97.isActive

				if GetFFlagLocalMutedNilFix() then
					if p91.localMuted == false then
						if v38 then
							p91:FireTalkingChangedDebounced(p91.isTalking)

							return
						end

						p91.talkingChanged:Fire(p91.isTalking)

						return
					end
				elseif not p91.localMuted then
					if v38 then
						p91:FireTalkingChangedDebounced(p91.isTalking)

						return
					end

					p91.talkingChanged:Fire(p91.isTalking)
				end
			end)
		end

		if GetFFlagLuaConsumePlayerModerated() then
			p91:StartModerationSignal()
		elseif game:GetEngineFeature("VoiceChatServicePlayerModeratedEvent") then
			p91.playerModeratedConnection = p91.service.LocalPlayerModerated:connect(function() -- line: 1786
				-- upvalues: v30 (copy), p91 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy)
				v30:debug("User Moderated old")
				p91.previousSessionId = p91.service:GetSessionId()
				p91:emit("OnPlayerModerated")

				if GetFFlagVoiceChatClientRewriteMasterLua() then
					VoiceChatService:leaveVoice()

					return
				end

				p91.service:Leave()
			end)
		end

		v30:trace("Setting up voice nudge handlers")
		p91.voiceToxicityModalConnection = p91:GetSignalREvent("VoiceToxicityModal"):Connect(function(p98) -- line: 1799
			-- upvalues: p91 (copy)
			p91.Analytics:reportReceivedNudge(p98, p91:GetNudgeAnalyticsData())
			p91:emit("OnVoiceToxicityModal")
		end)
		p91.VoiceToxicityToastConnection = p91:GetSignalREvent("VoiceToxicityToast"):Connect(function(p99) -- line: 1805
			-- upvalues: p91 (copy)
			p91.Analytics:reportReceivedNudge(p99, p91:GetNudgeAnalyticsData())
			p91:emit("OnVoiceToxicityToast")
		end)

		if GetFFlagEnableVoiceReverseNudge() then
			v30:trace("Setting up voice reverse nudge handlers")
			p91.voiceReverseNudgeConnection = p91:GetSignalREvent("VoiceReverseNudgeIconColorChange"):Connect(function(p100) -- line: 1812
				-- upvalues: p91 (copy)
				p91:emit("OnVoiceReverseNudgeIconColorChange", p100)
			end)
		end

		p91.blockConnection = p91.BlockStatusChanged:Connect(function(n4: number, b4: boolean) -- line: 1817
			-- upvalues: p91 (copy), v30 (copy), Utils (copy)
			if b4 then
				if p91.participants[tostring(n4)] then
					v30:debug("Blocking {}", Utils.shorten(n4))
					p91.service:SubscribeBlock(n4)

					return
				end
			else
				v30:debug("UnBlocking {}", Utils.shorten(n4))
				p91.service:SubscribeUnblock(n4)
			end
		end)

		if VoiceChatService.UseNewAudioApi then
			p91:hookupAudioDeviceInputListener()
		end

		if p91.service.TempSetMicMutedToggleMic then
			p91.tempSetMicMutedToggleMicConnection = p91.service.TempSetMicMutedToggleMic:connect(function() -- line: 1835
				-- upvalues: p91 (copy)
				p91:ToggleMic("TempSetMicMutedToggleMic")
			end)
		end

		if v67 then
			p91.videoCaptureInProgressConnection = p91.CaptureService.VideoCaptureInProgress:connect(function(b5: boolean) -- line: 1842
				-- upvalues: p91 (copy), t1 (copy)
				if b5 then
					p91.voiceCapturedDuringVideoCapture = false

					return
				end

				p91.TelemetryService:LogEvent(t1, {
					customFields = {
						voiceCaptured = p91.voiceCapturedDuringVideoCapture
					}
				})
			end)
		end
	end
end

local u92 = nil

function t2.CheckAudioInputExists(p101) -- line: 1857
	-- upvalues: v30 (copy), u92 (ref), Promise (copy), Cryo (copy)
	v30:trace("Checking for AudioDeviceInput")

	if not u92 then
		u92 = Promise.new(function(resolve, _) -- line: 1860
			-- upvalues: Cryo (copy), p101 (copy), v30 (copy)
			if #Cryo.Dictionary.keys(p101.audioDevices) > 0 then
				v30:trace("Found existing AudioDeviceInput")
				resolve()

				return
			end

			p101.audioDeviceInputAdded.Event:Connect(function() -- line: 1865
				-- upvalues: v30 (copy), resolve (copy)
				v30:trace("Found new AudioDeviceInput")
				resolve()
			end)
		end)
	end

	return u92
end
function t2.checkAndUpdateSequence(t21: {[any]: any}, s9: string, n5: number) -- line: 1875
	if not n5 then
		return 0
	end

	if not t21.SequenceNumbers[s9] then
		t21.SequenceNumbers[s9] = n5

		return 0
	end

	local v297 = n5 - t21.SequenceNumbers[s9]

	if v297 > 0 then
		t21.SequenceNumbers[s9] = n5
	end

	return v297 - 1
end

local function isIgnoredAudioInput(p103) -- line: 1902
	-- upvalues: CoreGui (copy)
	return p103:IsDescendantOf(CoreGui)
end

function t2.onInstanceAdded(t22: {[any]: any}, p104) -- line: 1906
	-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), v30 (copy)
	if p104:IsA("AudioDeviceInput") then
		if FFlagExpChatDictation and p104:IsDescendantOf(CoreGui) then
			return
		end

		v30:debug("Found new audio device instance for {}", p104.Player and p104.Player.Name)
		t22.audioDevices[p104] = t22:CreateAudioDeviceData(p104)
		t22:emit("OnAudioDeviceInputAdded")
		t22:StartAnalysis(p104)
	end
end
function t2.GetSendMuteEvent(p105) -- line: 1919
	-- upvalues: RobloxReplicatedStorage (copy)
	if not p105.SendMuteEvent then
		p105.SendMuteEvent = RobloxReplicatedStorage:WaitForChild("SetUserActive", 10)
	end

	return p105.SendMuteEvent
end
function t2.GetToggleVoiceChangerEvent(p106) -- line: 1926
	-- upvalues: ReplicatedStorage (copy)
	if not p106.SendVoiceChangerEvent then
		p106.SendVoiceChangerEvent = ReplicatedStorage:WaitForChild("ToggleUserVoiceChanger", 10)
	end

	return p106.SendVoiceChangerEvent
end
function t2.GetInputToModifierWire(p107) -- line: 1933
	-- upvalues: Players (copy)
	if not p107.InputToModifierWire then
		p107.InputToModifierWire = Players.LocalPlayer:FindFirstChild("InputToModifier")
	end

	return p107.InputToModifierWire
end
function t2.GetPartyVoiceDeviceInput(p108) -- line: 1940
	-- upvalues: Players (copy)
	if not p108.PartyVoiceDeviceInput then
		p108.PartyVoiceDeviceInput = Players.LocalPlayer:FindFirstChild("PartyVoiceDeviceInput")
	end

	return p108.PartyVoiceDeviceInput
end
function t2.GetSetVoicePackEvent(p109) -- line: 1948
	-- upvalues: ReplicatedStorage (copy)
	if not p109.SetVoicePackEvent then
		p109.SetVoicePackEvent = ReplicatedStorage:WaitForChild("SetVoicePack", 10)
	end

	return p109.SetVoicePackEvent
end
function t2.GetVoiceChangerWasToggledEvent(p110) -- line: 1955
	-- upvalues: ReplicatedStorage (copy)
	if not p110.VoiceChangerWasToggledEvent then
		p110.VoiceChangerWasToggledEvent = ReplicatedStorage:WaitForChild("VoiceChangerWasToggled", 3)
	end

	return p110.VoiceChangerWasToggledEvent
end

local function WireUp(p111, p112) -- line: 1963
	local Wire = Instance.new("Wire")

	Wire.SourceInstance = p111
	Wire.TargetInstance = p112
	Wire.Parent = p112

	return Wire
end
local function GetAnalysisHost() -- line: 1972
	-- upvalues: RobloxReplicatedStorage (copy)
	return RobloxReplicatedStorage
end

function t2.GetAnalyzer(_: {[any]: any}, p113) -- line: 1976
	-- upvalues: RobloxReplicatedStorage (copy)
	local v312 = p113.Name .. "_Analyzer"
	local v313 = RobloxReplicatedStorage
	local v314 = v313:FindFirstChild(v312)

	if not v314 then
		v314 = Instance.new("AudioAnalyzer")
		v314.SpectrumEnabled = false
		v314.Name = v312
		v314.Parent = v313
	end

	return v314
end

local function toDecibels(n6: number) -- line: 1989
	return math.log10(n6) * 20
end

function t2.IsSignalActive(t24: {[any]: any}, n7: number) -- line: 1993
	-- upvalues: v61 (copy), Players (copy)
	if not v61 then
		return false
	end

	local PlayerByUserId = Players:GetPlayerByUserId(n7)

	if not PlayerByUserId then
		return false
	end

	return math.log10(t24:GetAnalyzer(PlayerByUserId).PeakLevel) * 20 > -36
end
function t2.StopAnalysis(_: {[any]: any}, p114) -- line: 2007
	-- upvalues: v61 (copy), RobloxReplicatedStorage (copy)
	if not v61 then
		return
	end

	for _, v322 in p114:GetConnectedWires("Output") do
		local TargetInstance = v322.TargetInstance

		if TargetInstance and TargetInstance:IsDescendantOf(RobloxReplicatedStorage) then
			v322:Destroy()
		end
	end
end
function t2.StartAnalysis(t26: {[any]: any}, p115) -- line: 2023
	-- upvalues: v61 (copy)
	if not v61 then
		return
	end

	t26:StopAnalysis(p115)

	local Player = p115.Player

	if not Player then
		return
	end

	local Analyzer = t26:GetAnalyzer(Player)
	local Wire = Instance.new("Wire")

	Wire.SourceInstance = p115
	Wire.TargetInstance = Analyzer
	Wire.Parent = Analyzer
end
function t2.GetVoiceConnectCookie(p116) -- line: 2037
	-- upvalues: Constants (copy)
	local ok, result = pcall(function() -- line: 2038
		-- upvalues: p116 (copy), Constants (copy)
		return p116.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
	end)

	if ok and result then
		return result
	end

	return ""
end
function t2.GetVoiceConnectCookieValue(p117) -- line: 2049
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), Constants (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		local ok, result = pcall(function() -- line: 2051
			-- upvalues: p117 (copy), Constants (copy)
			return p117.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
		end)

		if ok then
			return result == "true"
		end

		return true
	end

	local ok, result = pcall(function() -- line: 2057
		-- upvalues: p117 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), Constants (copy)
		return p117.AppStorageService:GetItem(if not GetFFlagEnableSeamlessVoiceV2() then Constants.VOICE_CONNECT_DISCONNECT_KEY else Constants.VOICE_CONNECT_DISCONNECT_KEY_V2)
	end)

	if ok then
		return result == "true"
	end

	return true
end
function t2.SetVoiceConnectCookieValue(t27: {[any]: any}, b6: boolean) -- line: 2069
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), Constants (copy), GetFFlagEnableSeamlessVoiceV2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		return (pcall(function() -- line: 2071
			-- upvalues: t27 (copy), Constants (copy), b6 (copy)
			t27.AppStorageService:SetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3, (tostring(b6)))
			t27.AppStorageService:Flush()
		end))
	end

	return (pcall(function() -- line: 2077
		-- upvalues: t27 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), Constants (copy), b6 (copy)
		t27.AppStorageService:SetItem(if not GetFFlagEnableSeamlessVoiceV2() then Constants.VOICE_CONNECT_DISCONNECT_KEY else Constants.VOICE_CONNECT_DISCONNECT_KEY_V2, (tostring(b6)))
		t27.AppStorageService:Flush()
	end))
end
function t2.GetVoiceRewarmCookie(p118) -- line: 2090
	-- upvalues: Constants (copy), v30 (copy)
	local ok, result = pcall(function() -- line: 2091
		-- upvalues: p118 (copy), Constants (copy)
		return p118.AppStorageService:GetItem(Constants.VOICE_REWARM_KEY)
	end)

	if ok and result then
		v30:debug("Got voice re-warm cookie: {}", result)

		return result
	end

	v30:debug("Voice re-warm cookie not set, returning empty string")

	return ""
end
function t2.SetVoiceRewarmCookie(t28: {[any]: any}, s10: string) -- line: 2104
	-- upvalues: v30 (copy), Constants (copy)
	v30:debug("Setting voice re-warm cookie to {}", s10)
	pcall(function() -- line: 2106
		-- upvalues: t28 (copy), Constants (copy), s10 (copy)
		t28.AppStorageService:SetItem(Constants.VOICE_REWARM_KEY, (tostring(s10)))
		t28.AppStorageService:Flush()
	end)
end
function t2.ShouldRewarmUser(p119) -- line: 2112
	return p119:GetVoiceRewarmCookie() == ""
end
function t2.RewarmUser(p120) -- line: 2116
	p120:SetVoiceRewarmCookie("true")
end
function t2.SetNewUserFTUXCookieValue(t29: {[any]: any}, b7: boolean) -- line: 2120
	-- upvalues: Constants (copy)
	return (pcall(function() -- line: 2121
		-- upvalues: t29 (copy), Constants (copy), b7 (copy)
		t29.AppStorageService:SetItem(Constants.SEAMLESS_VOICE_FTUX_KEY, (tostring(b7)))
		t29.AppStorageService:Flush()
	end))
end
function t2.SetAndSyncActive(t30: {[any]: any}, p121, b8: boolean) -- line: 2128
	-- upvalues: Players (copy)
	p121.Active = b8

	local SendMuteEvent = t30:GetSendMuteEvent()

	if SendMuteEvent and p121.Player == Players.LocalPlayer then
		SendMuteEvent:FireServer(b8)
	end
end
function t2.CreateAudioDeviceData(t31: {[any]: any}, p122) -- line: 2137
	-- upvalues: Players (copy), EngineFeature (copy), v30 (copy), v31 (copy), v58 (copy)
	local t32 = {}
	local u355 = p122.Player == Players.LocalPlayer

	if EngineFeature then
		if not p122.MutedByLocalUser then
			if t31.muteAll and not u355 then
				p122.MutedByLocalUser = true
			end

			if p122.Player and t31.mutedPlayers[p122.Player.UserId] then
				p122.MutedByLocalUser = true
			end
		end
	elseif p122.Active then
		if t31.muteAll and not u355 then
			p122.Active = false
		end

		if p122.Player and t31.mutedPlayers[p122.Player.UserId] then
			p122.Active = false
		end
	end

	if p122.Active and u355 and t31.localMuted == nil then
		t31:SetAndSyncActive(p122, false)
	end

	if u355 and t31.localMuted ~= nil and t31.localMuted ~= not p122.Active and not t31.isInCall then
		v30:debug("Mismatch between LocalMuted and device.Active")

		local v356 = not t31.localMuted

		p122.Active = v356

		local SendMuteEvent = t31:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v356)
		end
	elseif t31.isInCall and u355 then
		local v358 = not t31.callMutedState

		v30:debug("Overwriting Active State to match Iris call. .Active = {}", v358)
		p122.Active = v358

		local SendMuteEvent = t31:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v358)
		end
	end

	t32.onPlayerChanged = p122:GetPropertyChangedSignal("Player"):Connect(function() -- line: 2187
		-- upvalues: v31 (copy), u355 (ref), p122 (copy), Players (copy), t31 (copy), v30 (copy), EngineFeature (copy)
		if v31 then
			u355 = p122.Player == Players.LocalPlayer

			if u355 then
				if p122.Active and t31.localMuted == nil then
					v30:debug("Player is still in connecting state, setting Active to false")
					t31:SetAndSyncActive(p122, false)
				elseif t31.localMuted ~= nil and t31.localMuted ~= not p122.Active then
					v30:debug("Mismatch between LocalMuted and device.Active")
					t31:SetAndSyncActive(p122, not t31.localMuted)
				end
			elseif t31.muteAll or p122.Player and t31.mutedPlayers[p122.Player.UserId] then
				if EngineFeature then
					p122.MutedByLocalUser = true
				else
					p122.Active = false
				end
			end
		end

		t31:emit("OnDevicePlayerChanged")
		t31:StartAnalysis(p122)
	end)
	t32.onMutedChanged = p122:GetPropertyChangedSignal("Muted"):Connect(function() -- line: 2213
		-- upvalues: t31 (copy)
		t31:emit("OnDeviceMuteChanged")
	end)

	if not EngineFeature then
		t32.onActiveChanged = p122:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2218
			-- upvalues: t31 (copy), u355 (ref), p122 (copy)
			t31:emit("OnDeviceActiveChanged")

			if t31.muteAll and not u355 then
				p122.Active = false
			end

			if p122.Player and t31.mutedPlayers[p122.Player.UserId] then
				p122.Active = false
			end
		end)
	elseif v58 then
		t32.onActiveChanged = p122:GetPropertyChangedSignal("Active"):Connect(function() -- line: 2229
			-- upvalues: t31 (copy)
			t31:emit("OnDeviceActiveChanged")
		end)
		t32.onMutedByLocalUserChanged = p122:GetPropertyChangedSignal("MutedByLocalUser"):Connect(function() -- line: 2232
			-- upvalues: t31 (copy)
			t31:emit("OnDeviceMutedByLocalUserChanged")
		end)
	end

	return t32
end
function t2.onInstanceRemove(t33: {[any]: any}, p123) -- line: 2240
	-- upvalues: FFlagExpChatDictation (copy), CoreGui (copy), v30 (copy), EngineFeature (copy), v58 (copy), v61 (copy)
	if p123:IsA("AudioDeviceInput") then
		if FFlagExpChatDictation and p123:IsDescendantOf(CoreGui) then
			return
		end

		t33:StopAnalysis(p123)
		v30:trace("Removing AudioDeviceInput {} {} {}", p123, "for user", p123.Player and p123.Player.UserId)

		local v362 = t33.audioDevices[p123]

		if v362 then
			if not EngineFeature then
				v362.onActiveChanged:Disconnect()
			elseif v58 then
				if v362.onActiveChanged then
					v362.onActiveChanged:Disconnect()
				end

				if v362.onMutedByLocalUserChanged then
					v362.onMutedByLocalUserChanged:Disconnect()
				end
			end

			v362.onMutedChanged:Disconnect()
			v362.onPlayerChanged:Disconnect()
		end

		t33.audioDevices[p123] = nil
		t33:emit("OnAudioDeviceInputRemoved")

		if v61 and p123.Player then
			t33:GetAnalyzer(p123.Player):Destroy()
		end
	end
end
function t2.hookupAudioDeviceInputListener(p124) -- line: 2271
	-- upvalues: v30 (copy), Players (copy), SoundService (copy), VoiceChatService (copy), CollectionService (copy), Utils (copy)
	v30:debug("Hooking up audio device listeners")

	local LocalPlayer = Players.LocalPlayer

	SoundService.AudioInstanceAdded:Connect(function(p125) -- line: 2274
		-- upvalues: p124 (copy)
		p124:onInstanceAdded(p125)
	end)

	local AudioDeviceInput = LocalPlayer:FindFirstChildOfClass("AudioDeviceInput")

	v30:debug("Found local user audio device {}", AudioDeviceInput)

	if AudioDeviceInput then
		p124:onInstanceAdded(AudioDeviceInput)
	end

	if VoiceChatService.EnableDefaultVoice then
		v30:debug("Creating default voice listener")

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

		for _, v370 in CollectionService:GetTagged("RbxDefaultVoiceEmitter") do
			Utils.destroyDefaultEmitter(v370)
		end

		CollectionService:GetInstanceAddedSignal("RbxDefaultVoiceEmitter"):Connect(Utils.destroyDefaultEmitter)
		LocalPlayer.CharacterAdded:Connect(Utils.avoidEmitting)

		if LocalPlayer.Character then
			Utils.avoidEmitting(LocalPlayer.Character)
		end
	end

	game.DescendantRemoving:Connect(function(descendant) -- line: 2309
		-- upvalues: p124 (copy)
		p124:onInstanceRemove(descendant)
	end)

	for _, descendant in game:GetDescendants() do
		p124:onInstanceAdded(descendant)
	end

	Players.PlayerRemoving:Connect(function(player) -- line: 2318
		-- upvalues: p124 (copy)
		for v478 in p124.audioDevices do
			if v478.Player and player == v478.Player then
				p124:onInstanceRemove(v478)
			end
		end
	end)
end
function t2.RejoinCurrentChannel(p126) -- line: 2328
	-- upvalues: v30 (copy)
	pcall(function() -- line: 2329
		-- upvalues: p126 (copy), v30 (copy)
		local GroupId = p126.service:GetGroupId()

		if GroupId and GroupId ~= "" then
			local v480 = p126.service:IsPublishPaused()

			p126.service:Leave()
			v30:debug("Rejoining current channel {}", GroupId)
			p126.participants = {}
			p126.participantsUpdate:Fire(p126.participants)

			if not p126.service:JoinByGroupIdToken(GroupId, v480, true) then
				p126:emit("OnInitialJoinFailed")
			end
		end
	end)
end
function t2.RejoinChannel(p127, p128, p129) -- line: 2345
	-- upvalues: v30 (copy)
	v30:debug("Rejoining previous channel {} with mute status {}", p128, p129)

	if p128 and p128 ~= "" then
		pcall(function() -- line: 2349
			-- upvalues: p127 (copy), p128 (copy), p129 (copy)
			p127.service:Leave()
			p127.participants = {}
			p127.participantsUpdate:Fire(p127.participants)

			if not p127.service:JoinByGroupIdToken(p128, p129, true) then
				p127:emit("OnInitialJoinFailed")
			end
		end)
	end
end
function t2.RejoinVoice(p130) -- line: 2361
	-- upvalues: GetFFlagVoiceChatClientRewriteMasterLua (copy), v30 (copy), VoiceChatService (copy)
	if GetFFlagVoiceChatClientRewriteMasterLua() then
		v30:debug("Rejoining voice")
		p130.participants = {}
		p130.participantsUpdate:Fire(p130.participants)
		VoiceChatService:rejoinVoice()
	end
end
function t2.watchSignalR(p131) -- line: 2372
	-- upvalues: WATCHED_NAMESPACES (copy), Utils (copy), v30 (copy)
	p131.signalRConnection = p131.NotificationService.RobloxEventReceived:Connect(function(t34: {[any]: any}) -- line: 2373
		-- upvalues: WATCHED_NAMESPACES (copy), Utils (copy), p131 (copy), v30 (copy)
		local namespace = t34.namespace

		if not WATCHED_NAMESPACES[namespace] then
			return
		end

		local v483 = Utils.jsonDecode(t34.detail)
		local v484 = p131.SignalREventTable[v483.type]

		if v484 then
			v484:Fire(v483)
		end

		local SequenceNumber = v483.SequenceNumber

		v30:trace("SignalR message {}: {}", namespace, SequenceNumber)

		local v486 = p131:checkAndUpdateSequence(namespace, SequenceNumber)

		if v486 > 0 then
			p131.Analytics:reportReconnectDueToMissedSequence()

			return
		end

		if v486 < -1 then
			p131.Analytics:reportOutOfOrderSequence()
		end
	end)
	p131.signalRConnectionChanged = p131.NotificationService.RobloxConnectionChanged:Connect(function(p132, p133, _, p135) -- line: 2397
		-- upvalues: v30 (copy), Utils (copy), WATCHED_NAMESPACES (copy), p131 (copy)
		if p132 == "signalR" then
			if p133 ~= Enum.ConnectionState.Connected then
				v30:info("SignalR disconnected")

				return
			end

			for k, v in pairs(Utils.jsonDecode(p135)) do
				if WATCHED_NAMESPACES[k] then
					v30:trace("SignalR message {}: {}", k, v)

					local v493 = p131:checkAndUpdateSequence(k, v)

					if v493 > 0 then
						p131.Analytics:reportReconnectDueToMissedSequence()
					elseif v493 < -1 then
						p131.Analytics:reportOutOfOrderSequence()
					end
				end
			end
		end
	end)
end
function t2.StopSignalRConnection(p136) -- line: 2422
	if p136.signalRConnectionChanged then
		p136.signalRConnectionChanged:Disconnect()
		p136.signalRConnectionChanged = nil
	end

	if p136.signalRConnection then
		p136.signalRConnection:Disconnect()
		p136.signalRConnection = nil
	end
end
function t2.getService(p137) -- line: 2433
	return p137.service
end
function t2.ToggleMic(t35: {[any]: any}, s11: string?) -- line: 2437
	-- upvalues: v30 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PermissionsProtocol (copy), VoiceChatService (copy), Players (copy)
	t35:ensureInitialized("toggle mic")

	if t35.localMuted == nil then
		v30:trace("ToggleMic context: {} - Voice not connected yet", s11)

		return
	end

	v30:trace("ToggleMic context: {}", s11)

	if GetFFlagJoinWithoutMicPermissions() then
		if t35.permissionState == PERMISSION_STATE.PENDING_MIC then
			v30:debug("In pending mic mode, requesting permission")
			t35:emit("GetPermissions", function(p138) -- line: 2450
				-- upvalues: t35 (copy), PERMISSION_STATE (copy), v30 (copy), s11 (copy)
				t35.permissionState = if not p138.hasMicPermissions then PERMISSION_STATE.LISTEN_ONLY else PERMISSION_STATE.LISTEN_AND_TALK
				v30:debug("Got permissions, setting state to {}", t35.permissionState)
				t35:ToggleMic(s11)
			end, { PermissionsProtocol.Permissions.MICROPHONE_ACCESS }, false)

			return
		end

		if t35.permissionState == PERMISSION_STATE.LISTEN_ONLY then
			v30:debug("User tried to unmute despite being in listen only mode")
			t35:emit("OnPermissionRequested")

			return
		end
	end

	if t35.isPlayerWatchingAd then
		v30:trace("User is watching an ad, skipping toggling mic")

		return
	end

	if VoiceChatService.UseNewAudioApi then
		t35.localMuted = not t35.localMuted

		local v383 = not t35.localMuted

		v30:trace("Setting self mute to {} context: {}", v383, s11)

		local SendMuteEvent = t35:GetSendMuteEvent()

		if SendMuteEvent then
			SendMuteEvent:FireServer(v383)

			for v385 in t35.audioDevices do
				if v385.Player and v385.Player == Players.LocalPlayer then
					v385.Active = v383
				end
			end

			t35.muteChanged:Fire(t35.localMuted)
		else
			v30:error("Could not find SendMuteEvent")
		end
	else
		local v386 = not t35.service:IsPublishPaused()

		v30:trace("Setting self mute to {} context: {}", v386, s11)
		t35.service:PublishPause(v386)
		t35.localMuted = v386
		t35.muteChanged:Fire(v386)
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
function t2.ToggleVoiceChanger(t36: {[any]: any}, _: string?) -- line: 2511
	-- upvalues: VoiceChatService (copy), v30 (copy)
	t36:ensureInitialized("toggle voice changer")

	if t36.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t36.isVoiceChangerActive = not t36.isVoiceChangerActive
		v30:trace("setting voice changer active to {}", t36.isVoiceChangerActive)

		local ToggleVoiceChangerEvent = t36:GetToggleVoiceChangerEvent()

		if ToggleVoiceChangerEvent then
			ToggleVoiceChangerEvent:FireServer(t36.isVoiceChangerActive)
			t36.voiceChangerChanged:Fire(t36.isVoiceChangerActive)

			return
		end

		v30:error("Could not find ToggleVoiceChangerEvent")

		return
	end

	t36.isVoiceChangerActive = false
	v30:trace("forcibly disabling voice changer since using old audio api", t36.isVoiceChangerActive)

	local ToggleVoiceChangerEvent = t36:GetToggleVoiceChangerEvent()

	if ToggleVoiceChangerEvent then
		ToggleVoiceChangerEvent:FireServer(t36.isVoiceChangerActive)
		t36.voiceChangerChanged:Fire(t36.isVoiceChangerActive)

		return
	end

	v30:error("Could not find ToggleVoiceChangerEvent")
end
function t2.ToggleVoiceChangerHearMyself(t37: {[any]: any}, _: string?) -- line: 2541
	-- upvalues: VoiceChatService (copy), v30 (copy)
	if t37.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t37.isVoiceChangerHearMyselfActive = not t37.isVoiceChangerHearMyselfActive

		local InputToModifierWire = t37:GetInputToModifierWire()
		local PartyVoiceDeviceInput = t37:GetPartyVoiceDeviceInput()

		if InputToModifierWire and PartyVoiceDeviceInput then
			v30:trace("setting voice changer hear myself active to {}", t37.isVoiceChangerHearMyselfActive)

			if t37.isVoiceChangerHearMyselfActive then
				InputToModifierWire.SourceInstance = PartyVoiceDeviceInput
			else
				InputToModifierWire.SourceInstance = nil
			end

			t37.voiceChangerHearMyselfChanged:Fire(t37.isVoiceChangerHearMyselfActive)

			return
		end

		v30:error("Could not find InputToModifierWire or PartyVoiceDeviceInput")
	end
end
function t2.SetVoicePack(t38: {[any]: any}, s14: string) -- line: 2566
	-- upvalues: VoiceChatService (copy), v30 (copy)
	t38:ensureInitialized("set voice pack")

	if t38.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		t38.currentVoicePack = s14
		v30:trace("setting current voice pack to {}", t38.currentVoicePack)

		local SetVoicePackEvent = t38:GetSetVoicePackEvent()

		if SetVoicePackEvent then
			SetVoicePackEvent:FireServer("VoicePack_" .. t38.currentVoicePack)

			return
		end

		v30:error("Could not find SetVoicePackEvent")
	end
end
function t2.JoinWithVoiceMuteData(p139, p140) -- line: 2585
	-- upvalues: Players (copy), Cryo (copy)
	local LocalPlayer = Players.LocalPlayer

	return Cryo.Dictionary.join({
		userId = LocalPlayer.UserId,
		clientSessionId = p139:GetSessionId(),
		channelId = p139:GetChannelId()
	}, p140)
end
function t2._reportJoinFailed(p141, p142, p143) -- line: 2594
	p141.Analytics:reportVoiceChatJoinResult(false, p142, p143)
	p141:emit("OnReportJoinFailed", p142)
end
function t2._asyncInit(p144) -- line: 2599
	-- upvalues: v30 (copy), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy), Analytics (copy), Promise (copy)
	p144:CheckCallState()

	return p144:canUseServiceAsync():andThen(function(_) -- line: 2602
		-- upvalues: v30 (copy), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), p144 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), VoiceChatService (copy), Analytics (copy), Promise (copy)
		local s15 = "VoiceChatService"

		if game:GetEngineFeature("UseNewVoiceChatService") then
			s15 = "VoiceChatInternal"
			v30:debug("Using VoiceChatInternal")
		end

		local ok, result = pcall(function() -- line: 2608
			-- upvalues: s15 (ref), MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED (copy), p144 (copy)
			local s15_2 = game:GetService(s15)

			if s15_2 and (s15_2:GetVoiceChatApiVersion() < MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED or s15_2:IsContextVoiceEnabled()) then
				p144.voiceEnabled = true
				p144.service = s15_2
				p144:SetupParticipantListeners()
			end
		end)

		if GetFFlagVoiceChatClientRewriteMasterLua() then
			VoiceChatService:joinVoice()
			v30:debug("Starting Voice Chat Client Join Operation")
		else
			local VoiceChatService2 = game:GetService("VoiceChatService")

			if VoiceChatService2 then
				VoiceChatService2:joinVoice()
				v30:debug("Starting Voice Chat Client Join Operation")
			end
		end

		if not ok then
			v30:warning("EnableVoiceChat flag is enabled but GetService panicked {}", result)
			p144:_reportJoinFailed("getServiceFailed", Analytics.ERROR)

			if p144.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_GET_SERVICE_FAILED"
				})
			end

			return Promise.reject()
		end

		if not p144.service then
			v30:debug("VoiceChatService is not set after init")
			p144:_reportJoinFailed("contextNotEnabled")

			if p144.options.passInitErrorInPromiseReject then
				return Promise.reject({
					code = "INIT_ERROR_CONTEXT_NOT_ENABLED"
				})
			end

			return Promise.reject()
		end

		p144:emit("OnVoiceChatServiceInitialized")
		p144:watchSignalR()

		return Promise.resolve()
	end)
end
function t2.UpdateLocalMetering(p146) -- line: 2658
	-- upvalues: Players (copy), v38 (copy)
	p146.isTalking = p146:IsSignalActive(Players.LocalPlayer.UserId)

	if p146.localMuted == false then
		if v38 then
			p146:FireTalkingChangedDebounced(p146.isTalking)

			return
		end

		p146.talkingChanged:Fire(p146.isTalking)
	end
end
function t2.FireTalkingChangedDebounced(p147, p148) -- line: 2669
	-- upvalues: v39 (copy)
	local v408 = v39
	local v409 = tick() * 1000
	local v410 = p148 ~= p147._lastTalkingChangedFireValue
	local v411 = v408 < v409 - p147._lastTalkingChangedFireTime

	if v410 or v411 then
		p147._lastTalkingChangedFireTime = v409
		p147._lastTalkingChangedFireValue = p148
		p147.talkingChanged:Fire(p148)
	end
end
function t2.asyncInit(p149) -- line: 2684
	-- upvalues: v30 (copy), Promise (copy), Constants (copy), FFlagEnablePartyVoiceChangersInLua (copy), v32 (copy)
	if p149.service then
		v30:trace("Manager already initialized")

		return Promise.resolve()
	end

	if not p149.initPromise then
		p149.initPromise = p149:_asyncInit()

		if p149.AdService then
			local function setupRewardedAdMuting(p150) -- line: 2694
				-- upvalues: Constants (copy)
				local u501 = false

				p150.AdService.RewardedVideoAdStarted:Connect(function() -- line: 2696
					-- upvalues: p150 (copy), u501 (ref), Constants (copy)
					if p150.localMuted == nil then
						return
					end

					u501 = p150.localMuted

					if not p150.localMuted then
						p150:ToggleMic(Constants.REWARDED_VIDEO_AD_STARTED)
					end

					p150.isPlayerWatchingAd = true
				end)
				p150.AdService.RewardedVideoAdEnded:Connect(function() -- line: 2712
					-- upvalues: p150 (copy), u501 (ref), Constants (copy)
					if p150.localMuted == nil then
						return
					end

					p150.isPlayerWatchingAd = false

					if u501 ~= p150.localMuted then
						p150:ToggleMic(Constants.REWARDED_VIDEO_AD_ENDED)
					end
				end)
			end

			setupRewardedAdMuting(p149)
		end

		if FFlagEnablePartyVoiceChangersInLua and not p149.voiceChangerWasToggledEvent then
			task.spawn(function() -- line: 2732
				-- upvalues: p149 (copy), v32 (copy)
				local VoiceChangerWasToggledEvent = p149:GetVoiceChangerWasToggledEvent()

				if VoiceChangerWasToggledEvent then
					VoiceChangerWasToggledEvent.OnClientEvent:Connect(function(n8: number, b9: boolean) -- line: 2736
						-- upvalues: v32 (copy), p149 (copy)
						local v509 = if not v32 then p149.participants[n8] else p149.participants[tostring(n8)]

						if v509 then
							v509.isVoiceChangerActive = b9
							p149.voiceChangerActivePlayers[n8] = b9
							p149.participantsUpdate:Fire(p149.participants)
						end
					end)
				end
			end)
		end
	end

	return p149.initPromise
end
function t2.IsInitialized(p151) -- line: 2756
	if p151.service then
		return true
	end

	return false
end
function t2.ensureInitialized(p152, p153) -- line: 2760
	if not p152.service then
		error("[corescripts VCS Manager] " .. "Attempting to " .. p153 .. " before calling init")
	end
end
function t2.GetSessionId(p154) -- line: 2767
	p154:ensureInitialized("get session id")

	return p154.service:GetSessionId()
end
function t2.GetChannelId(p155) -- line: 2772
	p155:ensureInitialized("get channel id")

	return p155.service:GetChannelId()
end
function t2.Disconnect(p156) -- line: 2777
	-- upvalues: v67 (copy)
	if p156.participantConnection then
		p156.participantConnection:Disconnect()
		p156.participantConnection = nil
	end

	if p156.stateConnection then
		p156.stateConnection:Disconnect()
		p156.stateConnection = nil
	end

	if p156.micConnection then
		p156.micConnection:Disconnect()
		p156.micConnection = nil
	end

	if p156.blockConnection then
		p156.blockConnection:Disconnect()
		p156.blockConnection = nil
	end

	if p156.playerModeratedConnection then
		p156.playerModeratedConnection:Disconnect()
		p156.playerModeratedConnection = nil
	end

	if p156.voiceToxicityModalConnection then
		p156.voiceToxicityModalConnection:Disconnect()
		p156.voiceToxicityModalConnection = nil
	end

	if p156.VoiceToxicityToastConnection then
		p156.VoiceToxicityToastConnection:Disconnect()
		p156.VoiceToxicityToastConnection = nil
	end

	if p156.voiceReverseNudgeConnection then
		p156.voiceReverseNudgeConnection:Disconnect()
		p156.voiceReverseNudgeConnection = nil
	end

	if p156.tempSetMicMutedToggleMicConnection then
		p156.tempSetMicMutedToggleMicConnection:Disconnect()
		p156.tempSetMicMutedToggleMicConnection = nil
	end

	if v67 and p156.videoCaptureInProgressConnection then
		p156.videoCaptureInProgressConnection:Disconnect()
		p156.videoCaptureInProgressConnection = nil
	end
end
function t2.RequestHidePublicVoiceUI(p157) -- line: 2828
	task.defer(function() -- line: 2829
		-- upvalues: p157 (copy)
		p157.setVoiceUIVisibility:Fire(false)
	end)
end
function t2.RequestShowPublicVoiceUI(p158) -- line: 2834
	task.defer(function() -- line: 2835
		-- upvalues: p158 (copy)
		p158.setVoiceUIVisibility:Fire(true)
	end)
end

t2.default = t2.new(BlockingUtility:GetAfterBlockedStatusChangedEvent(), PermissionsProtocol.default, HttpRbxApiService, nil, nil, nil, nil, nil, ThirdPartyUserService, nil, AdService)

return t2
