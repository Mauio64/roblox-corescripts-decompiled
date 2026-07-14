local getPlayersFromService = require(script.Parent.getPlayersFromService)

local function resolvePlayerTarget(s1: string?, s2: string, s3: string) -- line: 15
	-- upvalues: getPlayersFromService (copy)
	if not s1 or s1 == "" then
		return {
			key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
			args = {
				RBX_NAME = ""
			}
		}
	end

	local v6 = getPlayersFromService(s1)

	if #v6 == 0 then
		return {
			key = "CoreScripts.TextChat.Mute.Error.TargetDoesNotExist",
			args = {
				RBX_NAME = s1
			}
		}
	end

	if #v6 > 1 then
		return {
			key = "CoreScripts.TextChat.Mute.Error.MultipleMatches",
			args = {}
		}
	end

	local v7 = v6[1]

	if s2 == v7.userId then
		return {
			key = "CoreScripts.TextChat.Mute.Error.CannotMuteSelf",
			args = {}
		}
	end

	local v8 = if string.sub(string.lower(s1), 1, 1) ~= "@" then v7.displayName else "@" .. v7.username

	return {
		key = s3,
		args = {
			RBX_NAME = v8
		},
		playerInfo = v7
	}
end

return resolvePlayerTarget
