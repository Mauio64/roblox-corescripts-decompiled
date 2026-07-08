local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Version = require(ExpChatShared.Version)

require(script.Parent.types)

return {
	name = script.Name,
	alias = {
		"/version",
		"/v"
	},
	clientRun = function() -- line: 8
		-- upvalues: Version (copy)
		return {
			key = "CoreScripts.TextChat.Version.Success",
			metadata = "Roblox.Version.Info.Success",
			args = {
				RBX_VERSION = string.format("%s (%s)", Version[1], Version[2])
			}
		}
	end
}
