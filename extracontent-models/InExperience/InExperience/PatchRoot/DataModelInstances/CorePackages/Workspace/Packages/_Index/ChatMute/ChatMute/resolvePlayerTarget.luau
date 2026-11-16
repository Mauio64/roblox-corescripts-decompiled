local getPlayersFromService = require(script.Parent.getPlayersFromService)

local function resolvePlayerTarget(value: string?, p: string, p2: string)
	if not value or value == "" then
		return {
			key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
			args = { RBX_NAME = "" }
		}
	end

	local playersFromService = getPlayersFromService(value)

	if #playersFromService == 0 then
		return {
			key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
			args = { RBX_NAME = value }
		}
	end

	if #playersFromService > 1 then
		return { key = "CoreScripts.TextChat.Mute.Error.MultipleMatches", args = {} }
	end

	local playerInfo = playersFromService[1]

	if playerInfo.userId == p then
		return { key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf", args = {} }
	end

	local v

	if string.sub(string.lower(value), 1, 1) == "@" then
		v = "@" .. playerInfo.username
	else
		v = playerInfo.displayName
	end

	return {
		key = p2,
		args = { RBX_NAME = v },
		playerInfo = playerInfo
	}
end

return resolvePlayerTarget
