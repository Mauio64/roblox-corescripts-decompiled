local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts")

return {
	Actions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions"),
	Analytics = module,
	App = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App"),
	Components = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components"),
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants"),
	Contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts"),
	Contracts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contracts"),
	Conversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations"),
	EntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatEntryPoint"),
	EntryPointUA = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatEntryPointUA"),
	Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags"),
	Hooks = {
		useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible"),
		useConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useConversationList"),
		useTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useTopBar")
	},
	Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer"),
	Middleware = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Middleware"),
	Models = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models"),
	Screens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens"),
	Stores = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores"),
	Users = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users"),
	Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils"),
	LegacyAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics")
}
