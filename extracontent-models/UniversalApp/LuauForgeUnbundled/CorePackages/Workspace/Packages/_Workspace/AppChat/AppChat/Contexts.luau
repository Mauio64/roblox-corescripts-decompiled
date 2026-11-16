local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer")

return {
	ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext"),
	ParentContainer = module,
	UnreadMessagesProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/UnreadMessages/UnreadMessagesProvider")
}
