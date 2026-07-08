local ContentProvider = game:GetService("ContentProvider")
local t1 = {
	PlaceNotAvailable = -1,
	UserNotAvailable = 0,
	Checking = 1,
	Available = 2
}
local t2 = {
	VoiceNotifications = true,
	VoiceModeration = true
}
local t3 = {
	IDLE = "Idle",
	VOICE_DISABLED = "Voice Disabled",
	LISTEN_AND_TALK = "Listen and Talk",
	LISTEN_ONLY = "Listen Only",
	PENDING_MIC = "Pending Mic"
}
local t4 = {
	Idle = "Idle",
	Joining = "Joining",
	Suspended = "Suspended",
	Joined = "Joined",
	Left = "Left"
}
local t5 = {
	ALL = "all",
	FRIENDS = "friends",
	NONFRIENDS = "nonfriends"
}

local function parseBaseUrlInformation() -- line: 54
	-- upvalues: ContentProvider (copy)
	local BaseUrl = ContentProvider.BaseUrl

	if BaseUrl:sub(#BaseUrl) ~= "/" then
		BaseUrl ..= "/"
	end

	local _, stop = BaseUrl:find("://")
	local start, stop2 = BaseUrl:find("%.", stop + 1)

	return BaseUrl, BaseUrl:sub(stop + 1, start - 1), (BaseUrl:sub(stop2 + 1))
end

local _, _, v10 = parseBaseUrlInformation()
local v11 = string.format("https://voice.%s", v10)
local v12 = string.format("https://apis.%supsellcard", v10)
local t6 = {
	CONTROL = "control",
	VARIANT1 = "variant1",
	VARIANT2 = "variant2",
	VARIANT3 = "variant3"
}
local t7 = {
	None = 0,
	VoiceChat = 1,
	AccountSecurity = 2
}
local t8 = {
	Invalid = 0,
	Disabled = 1,
	EnabledExistingUser = 2,
	EnabledNewUser = 3
}
local t9 = {
	Control = "Control",
	OnlyConnectDisconnect = "V2-Variant-1",
	HearingWithoutMicPermissions = "V2-Variant-2"
}
local t10 = {
	Control = "Control",
	ConnectDisconnect = "ConnectDisconnect",
	HearingWithoutMicPermissions = "HearingWithoutMicPermissions",
	JoinVoiceIsMutedMic = "JoinVoiceIsMutedMic",
	JoinVoiceTooltip = "JoinVoiceTooltip",
	InitialJoinVoice = "InitialJoinVoice",
	DeferConnection = "DeferConnection",
	HideJoinToastSubtitle = "HideJoinToastSubtitle"
}

return {
	MIN_VOICE_CHAT_API_VERSION = 3,
	MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY = 9,
	MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED = 10,
	IN_EXP_PHONE_UPSELL_IXP_LAYER = "InExperience.UpsellCard",
	EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER = "ExitConfirmation.UpsellCard",
	VOICE_CONNECT_DISCONNECT_KEY = "InExpVoiceUIVisibility",
	VOICE_CONNECT_DISCONNECT_KEY_V2 = "SeamlessConnectToVoice",
	VOICE_CONNECT_DISCONNECT_KEY_V3 = "ConnectToVoice",
	SEAMLESS_VOICE_FTUX_KEY = "SeamlessVoiceFTUX",
	VOICE_REWARM_KEY = "VoiceRewarmOffered",
	REWARDED_VIDEO_AD_STARTED = "RewardedVideoAdStarted",
	REWARDED_VIDEO_AD_ENDED = "RewardedVideoAdEnded",
	FAE_ENABLED = "Enabled",
	FAE_SETTINGS_TOAST = "SettingsToast",
	VOICE_JOIN_PROGRESS = t4,
	VOICE_CHAT_AVAILABILITY = t1,
	WATCHED_NAMESPACES = t2,
	VOICE_GROUP_TYPE = t5,
	WATCHED_MESSAGE_TYPES = {
		"ParticipantModeratedFromVoice",
		"VoiceToxicityModal",
		"VoiceToxicityToast",
		"VoiceReverseNudgeIconColorChange"
	},
	PERMISSION_STATE = t3,
	VOICE_URL = v11,
	UPSELL_CARD_URL = v12,
	IN_EXP_UPSELL_VARIANT = t6,
	PHONE_UPSELL_VOICE_CHAT_PROP = t7,
	SeamlessVoiceStatus = t8,
	SeamlessVoiceVariants = t9,
	SeamlessVoiceFeatures = t10
}
