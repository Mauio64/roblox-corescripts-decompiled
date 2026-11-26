local Version = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Version")
require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

return {
	name = "RBXVersionCommand",
	alias = { "/version", "/v" },
	clientRun = function()
		return {
			key = "CoreScripts.TextChat.Version.Success",
			metadata = "Roblox.Version.Info.Success",
			args = {
				RBX_VERSION = string.format("%s (%s)", Version[1], Version[2])
			}
		}
	end
}
