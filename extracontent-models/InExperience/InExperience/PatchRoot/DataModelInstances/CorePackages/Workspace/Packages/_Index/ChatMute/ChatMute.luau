local GetMutedUsersStore = require(script.GetMutedUsersStore)

local function store() -- line: 3
	-- upvalues: GetMutedUsersStore (copy)
	return GetMutedUsersStore(false)
end

return {
	mutePlayer = function(t1: {[any]: any}) -- line: 16
		-- upvalues: GetMutedUsersStore (copy)
		if t1.userId then
			GetMutedUsersStore(false).muteGlobalUserId(t1.userId)
		end

		if t1.username then
			GetMutedUsersStore(false).muteGlobalUsername(t1.username)
		end

		if t1.displayName then
			GetMutedUsersStore(false).muteGlobalDisplayName(t1.displayName)
		end
	end,
	unmutePlayer = function(t2: {[any]: any}) -- line: 28
		-- upvalues: GetMutedUsersStore (copy)
		if t2.userId then
			GetMutedUsersStore(false).unmuteGlobalUserId(t2.userId)
		end

		if t2.username then
			GetMutedUsersStore(false).unmuteGlobalUsername(t2.username)
		end

		if t2.displayName then
			GetMutedUsersStore(false).unmuteGlobalDisplayName(t2.displayName)
		end
	end,
	isUserIdMuted = function(p1) -- line: 41
		-- upvalues: GetMutedUsersStore (copy)
		return GetMutedUsersStore(false).isUserIdMuted(p1)
	end,
	isUsernameMuted = function(s1: string) -- line: 44
		-- upvalues: GetMutedUsersStore (copy)
		return GetMutedUsersStore(false).isUsernameMuted(s1)
	end,
	isDisplayNameMuted = function(s2: string) -- line: 47
		-- upvalues: GetMutedUsersStore (copy)
		return GetMutedUsersStore(false).isDisplayNameMuted(s2)
	end,
	getMutedUserIds = function() -- line: 52
		-- upvalues: GetMutedUsersStore (copy)
		return GetMutedUsersStore(false).getMutedUserIds
	end,
	getMutedUsernames = function() -- line: 55
		-- upvalues: GetMutedUsersStore (copy)
		return GetMutedUsersStore(false).getMutedUsernames
	end,
	getMutedDisplayNames = function() -- line: 58
		-- upvalues: GetMutedUsersStore (copy)
		return GetMutedUsersStore(false).getMutedDisplayNames
	end,
	resolveMuteTarget = require(script.resolveMuteTarget),
	resolveUnmuteTarget = require(script.resolveUnmuteTarget),
	getPlayersFromService = require(script.getPlayersFromService),
	["jest.config"] = script["jest.config"]
}
