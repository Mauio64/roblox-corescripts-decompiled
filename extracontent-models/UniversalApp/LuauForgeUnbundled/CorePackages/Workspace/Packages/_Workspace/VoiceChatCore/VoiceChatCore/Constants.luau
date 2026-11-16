local ContentProvider = game:GetService("ContentProvider")

local function parseBaseUrlInformation()
	local v5 = ContentProvider.BaseUrl

	if v5:sub(#v5) ~= "/" then
		v5 ..= "/"
	end

	local v6, v7 = v5:find("://")

	local v8, v9 = v5:find("%.", v7 + 1)
	return v5, v5:sub(v7 + 1, v8 - 1), (v5:sub(v9 + 1))
end

local v5, v6, v7 = parseBaseUrlInformation()
return {
	MIN_VOICE_CHAT_API_VERSION = 3,
	VOICE_JOIN_PROGRESS = {
		Idle = "Idle",
		Joining = "Joining",
		Suspended = "Suspended",
		Joined = "Joined",
		Left = "Left"
	},
	MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY = 9,
	MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED = 10,
	VOICE_CHAT_AVAILABILITY = {
		PlaceNotAvailable = -1,
		UserNotAvailable = 0,
		Checking = 1,
		Available = 2
	},
	WATCHED_NAMESPACES = { VoiceNotifications = true, VoiceModeration = true },
	VOICE_GROUP_TYPE = { ALL = "all", FRIENDS = "friends", NONFRIENDS = "nonfriends" },
	WATCHED_MESSAGE_TYPES = {
		"ParticipantModeratedFromVoice",
		"VoiceToxicityModal",
		"VoiceToxicityToast",
		"VoiceReverseNudgeIconColorChange"
	},
	PERMISSION_STATE = {
		IDLE = "Idle",
		VOICE_DISABLED = "Voice Disabled",
		LISTEN_AND_TALK = "Listen and Talk",
		LISTEN_ONLY = "Listen Only",
		PENDING_MIC = "Pending Mic"
	},
	VOICE_URL = string.format("https://voice.%s", v7),
	UPSELL_CARD_URL = string.format("https://apis.%supsellcard", v7),
	IN_EXP_UPSELL_VARIANT = {
		CONTROL = "control",
		VARIANT1 = "variant1",
		VARIANT2 = "variant2",
		VARIANT3 = "variant3"
	},
	IN_EXP_PHONE_UPSELL_IXP_LAYER = "InExperience.UpsellCard",
	EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER = "ExitConfirmation.UpsellCard",
	PHONE_UPSELL_VOICE_CHAT_PROP = { None = 0, VoiceChat = 1, AccountSecurity = 2 },
	VOICE_CONNECT_DISCONNECT_KEY_V2 = "SeamlessConnectToVoice",
	VOICE_CONNECT_DISCONNECT_KEY_V3 = "ConnectToVoice",
	SEAMLESS_VOICE_FTUX_KEY = "SeamlessVoiceFTUX",
	VOICE_REWARM_KEY = "VoiceRewarmOffered",
	SeamlessVoiceStatus = {
		Invalid = 0,
		Disabled = 1,
		EnabledExistingUser = 2,
		EnabledNewUser = 3
	},
	SeamlessVoiceVariants = {
		Control = "Control",
		OnlyConnectDisconnect = "V2-Variant-1",
		HearingWithoutMicPermissions = "V2-Variant-2"
	},
	SeamlessVoiceFeatures = {
		Control = "Control",
		ConnectDisconnect = "ConnectDisconnect",
		HearingWithoutMicPermissions = "HearingWithoutMicPermissions",
		JoinVoiceIsMutedMic = "JoinVoiceIsMutedMic",
		JoinVoiceTooltip = "JoinVoiceTooltip",
		InitialJoinVoice = "InitialJoinVoice",
		DeferConnection = "DeferConnection",
		HideJoinToastSubtitle = "HideJoinToastSubtitle"
	},
	REWARDED_VIDEO_AD_STARTED = "RewardedVideoAdStarted",
	REWARDED_VIDEO_AD_ENDED = "RewardedVideoAdEnded",
	FAE_ENABLED = "Enabled",
	FAE_SETTINGS_TOAST = "SettingsToast"
}
