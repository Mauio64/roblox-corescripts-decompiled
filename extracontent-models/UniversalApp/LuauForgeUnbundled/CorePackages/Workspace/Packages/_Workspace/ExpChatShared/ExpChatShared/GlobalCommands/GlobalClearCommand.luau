require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/GlobalCommands/types")
local RBXClearCommand = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/RBXClearCommand")

return {
	name = "GlobalClearCommand",
	alias = RBXClearCommand.alias,
	clientRun = RBXClearCommand.clientRun
}
