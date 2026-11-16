local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/TabTypes")

return {
	ActionBindableEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/ActionBindableEvent"),
	Actions = module,
	Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Analytics"),
	ChannelTabDisplayLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/ChannelTabDisplayLabel"),
	Commands = module2,
	Config = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Config"),
	GlobalCommands = module3,
	Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags"),
	FriendsSurfaceVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/FriendsSurfaceVisibility"),
	Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Logger"),
	RaiseActionAsEventMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/RaiseActionAsEventMiddleware"),
	Reducers = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Reducers"),
	TabTypes = module4,
	Version = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Version"),
	context = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/context"),
	countParticipantsInTextChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/countParticipantsInTextChannel"),
	getOtherDisplayNameInWhisperChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/getOtherDisplayNameInWhisperChannel"),
	getPresetIconRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/getPresetIconRichText"),
	getPresetIconSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/getPresetIconSize"),
	getTextChannelDisplayMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/getTextChannelDisplayMode"),
	isPresetMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/isPresetMessage"),
	markTextChannelAsDefault = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/markTextChannelAsDefault"),
	shouldRenderTextChannelInDefaultWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/shouldRenderTextChannelInDefaultWindow"),
	watchForErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/watchForErrors")
}
