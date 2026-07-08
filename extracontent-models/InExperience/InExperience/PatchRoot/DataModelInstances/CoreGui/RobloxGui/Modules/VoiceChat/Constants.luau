local t1 = {
	USER_AGENCY = "useragency",
	BUBBLE_CHAT = "bubblechat",
	IN_GAME_MENU = "ingamemenu",
	MUTE_TOGGLES = "mutetoggles",
	REPORT_MENU = "reportmenu",
	EASIER_UNMUTING = "easierunmuting",
	UNKNOWN = "unknown"
}
local t2 = {
	ALL = "all",
	FRIENDS = "friends",
	NONFRIENDS = "nonfriends"
}
local t3 = {
	INACTIVE = "Inactive",
	TALKING = "Talking",
	CONNECTING = "Connecting",
	MUTED = "Muted",
	LOCAL_MUTED = "LOCAL_MUTED",
	ERROR = "Error",
	HIDDEN = "Hidden"
}
local t4 = {
	NUDGE_V3 = 7
}
local t5 = {
	AUTO_CONNECT = 1,
	IN_EXPERIENCE = 2,
	SETTINGS_TOGGLE_ON = 3
}
local t6 = {
	USER_DISCONNECT = 1,
	MODERATED = 2,
	SYSTEM = 3
}
local t7 = {
	Idle = "Idle",
	Joining = "Joining",
	Suspended = "Suspended",
	Joined = "Joined",
	Left = "Left"
}
local t8 = {
	CONTROL = "control",
	VARIANT1 = "variant1",
	VARIANT2 = "variant2",
	VARIANT3 = "variant3"
}
local t9 = {
	IN_EXP_UPSELL = "in-experience-voice-upsell",
	DATA_CONSENT_TOAST = "data-consent-toast",
	IN_EXP_JOIN_VOICE_UPSELL = "join-voice-upsell-tooltip"
}
local t10 = {
	JOIN_VOICE = "joinVoiceButton"
}
local t11 = {
	None = 0,
	VoiceChat = 1,
	AccountSecurity = 2
}

return {
	IN_EXP_PHONE_UPSELL_IXP_LAYER = "InExperience.UpsellCard",
	EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER = "ExitConfirmation.UpsellCard",
	SEAMLESS_VOICE_FTUX_KEY = "SeamlessVoiceFTUX",
	SEAMLESS_VOICE_STUX_KEY = "SeamlessVoiceSTUXCount",
	SEAMLESS_VOICE_STATUS_ENABLED_NEW_USER = 3,
	VOICE_WITH_TC_TOAST_KEY = "VoiceWithTcToast",
	VOICE_CONTEXT_TYPE = t1,
	VOICE_CONNECTION_SOURCE = t5,
	VOICE_DISCONNECT_REASON = t6,
	VOICE_JOIN_PROGRESS = t7,
	VOICE_GROUP_TYPE = t2,
	VOICE_STATE = t3,
	BAN_REASON = t4,
	IN_EXP_UPSELL_VARIANT = t8,
	MODAL_IDS = t9,
	IN_EXP_UPSELL_ENTRYPOINTS = t10,
	PHONE_UPSELL_VALUE_PROP = t11
}
