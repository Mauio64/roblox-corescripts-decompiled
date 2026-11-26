local getPlayersFromService = require("@game/CorePackages/Workspace/Packages/_Index/ChatMute/ChatMute/getPlayersFromService")

local function resolvePlayerTarget(value, p2, p3)
	if not value or value == "" then
		return {
			key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
			args = { RBX_NAME = "" }
		}
	end

	local v5 = getPlayersFromService(value)

	if #v5 == 0 then
		return {
			key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
			args = { RBX_NAME = value }
		}
	end

	if #v5 > 1 then
		return { key = "CoreScripts.TextChat.Mute.Error.MultipleMatches", args = {} }
	end

	local v6 = v5[1]

	if v6.userId == p2 then
		return { key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf", args = {} }
	end

	local v7 = if string.sub(string.lower(value), 1, 1) == "@" then "@" .. v6.username else v6.displayName

	return {
		key = p3,
		args = { RBX_NAME = v7 },
		playerInfo = v6
	}
end

return resolvePlayerTarget
