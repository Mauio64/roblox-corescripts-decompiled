local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Logger = require(ExpChatShared.Logger)
local v = Logger:new("ExpChat/Command/Team")

local Actions = ExpChatShared.Actions
local ChatInputBarActivatedTeamMode = require(Actions.ChatInputBarActivatedTeamMode)

require(script.Parent.types)

return {
	name = script.Name,
	alias = { "/team", "/t", "%%" },
	clientRun = function(object, _, _)
		if object:getState().LocalTeam then
			object:dispatch(ChatInputBarActivatedTeamMode())

			return { key = "", metadata = "Roblox.Team.Info.Success" }
		end

		v:debug("Could not team chat because not in team")
		return {
			key = "CoreScripts.TextChat.TeamChat.Error.NotOnTeam",
			metadata = "Roblox.Team.Error.CannotTeamChatIfNotInTeam"
		}
	end
}
