local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Logger"):new("ExpChat/Command/Team")

local ChatInputBarActivatedTeamMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/ChatInputBarActivatedTeamMode")

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

return {
	name = "RBXTeamCommand",
	alias = { "/team", "/t", "%%" },
	clientRun = function(object, p2, p3)
		if object:getState().LocalTeam then
			object:dispatch(ChatInputBarActivatedTeamMode())

			return { key = "", metadata = "Roblox.Team.Info.Success" }
		end

		v5:debug("Could not team chat because not in team")
		return {
			key = "CoreScripts.TextChat.TeamChat.Error.NotOnTeam",
			metadata = "Roblox.Team.Error.CannotTeamChatIfNotInTeam"
		}
	end
}
