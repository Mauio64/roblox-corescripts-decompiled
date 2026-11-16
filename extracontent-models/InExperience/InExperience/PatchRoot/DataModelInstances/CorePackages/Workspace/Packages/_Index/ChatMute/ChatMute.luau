local GetMutedUsersStore = require(script.GetMutedUsersStore)

local function store() -- 12 equivalent calls inferred from this helper
	return GetMutedUsersStore(false)
end

return {
	mutePlayer = function(data)
		if data.userId then
			store().muteGlobalUserId(data.userId) -- inferred equivalent call
		end

		if data.username then
			store().muteGlobalUsername(data.username) -- inferred equivalent call
		end

		if data.displayName then
			store().muteGlobalDisplayName(data.displayName) -- inferred equivalent call
		end
	end,
	unmutePlayer = function(data)
		if data.userId then
			store().unmuteGlobalUserId(data.userId) -- inferred equivalent call
		end

		if data.username then
			store().unmuteGlobalUsername(data.username) -- inferred equivalent call
		end

		if data.displayName then
			store().unmuteGlobalDisplayName(data.displayName) -- inferred equivalent call
		end
	end,
	isUserIdMuted = function(p)
		return store().isUserIdMuted(p) -- inferred equivalent call
	end,
	isUsernameMuted = function(p: string)
		return store().isUsernameMuted(p) -- inferred equivalent call
	end,
	isDisplayNameMuted = function(p: string)
		return store().isDisplayNameMuted(p) -- inferred equivalent call
	end,
	getMutedUserIds = function()
		return store().getMutedUserIds -- inferred equivalent call
	end,
	getMutedUsernames = function()
		return store().getMutedUsernames -- inferred equivalent call
	end,
	getMutedDisplayNames = function()
		return store().getMutedDisplayNames -- inferred equivalent call
	end,
	resolveMuteTarget = require(script.resolveMuteTarget),
	resolveUnmuteTarget = require(script.resolveUnmuteTarget),
	getPlayersFromService = require(script.getPlayersFromService),
	["jest.config"] = script["jest.config"]
}
