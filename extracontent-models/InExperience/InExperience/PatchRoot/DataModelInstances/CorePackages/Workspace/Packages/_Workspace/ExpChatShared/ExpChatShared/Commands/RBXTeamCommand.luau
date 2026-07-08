local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local v2 = require(ExpChatShared.Logger):new("ExpChat/Command/Team")
local Actions = ExpChatShared.Actions
local ChatInputBarActivatedTeamMode = require(Actions.ChatInputBarActivatedTeamMode)

require(script.Parent.types)

return {
	name = script.Name,
	alias = {
		"/team",
		"/t",
		"%%"
	},
	clientRun = function(p1, _, _) -- line: 12
		-- upvalues: ChatInputBarActivatedTeamMode (copy), v2 (copy)
		if p1:getState().LocalTeam then
			p1:dispatch(ChatInputBarActivatedTeamMode())

			return {
				key = "",
				metadata = "Roblox.Team.Info.Success"
			}
		end

		v2:debug("Could not team chat because not in team")

		return {
			key = "CoreScripts.TextChat.TeamChat.Error.NotOnTeam",
			metadata = "Roblox.Team.Error.CannotTeamChatIfNotInTeam"
		}
	end
}
