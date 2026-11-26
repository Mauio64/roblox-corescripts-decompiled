local module = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Constants")

require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Utils/GetIcon")

return {
	AgeVerificationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/AgeVerificationOverlay"),
	Constants = module,
	OptInStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/OptInStatus"),
	Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Flags"),
	GetInformedOfBan = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Requests/GetInformedOfBan"),
	GetUserSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Requests/GetUserSettings"),
	PostInformedOfBan = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Requests/PostInformedOfBan"),
	PostSeenAvatarVideoModal = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Requests/PostSeenAvatarVideoModal"),
	PostUserOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Requests/PostUserOptIn"),
	Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/Utils"),
	GlobalVoiceManager = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/GlobalVoiceManager")
}
