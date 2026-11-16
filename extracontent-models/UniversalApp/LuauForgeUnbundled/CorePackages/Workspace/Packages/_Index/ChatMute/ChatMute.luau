local GetMutedUsersStore = require("@game/CorePackages/Workspace/Packages/_Index/ChatMute/ChatMute/GetMutedUsersStore")

local function store()
	return GetMutedUsersStore(false)
end

return {
	mutePlayer = function(data)
		if data.userId then
			GetMutedUsersStore(false).muteGlobalUserId(data.userId)
		end

		if data.username then
			GetMutedUsersStore(false).muteGlobalUsername(data.username)
		end

		if data.displayName then
			GetMutedUsersStore(false).muteGlobalDisplayName(data.displayName)
		end
	end,
	unmutePlayer = function(data)
		if data.userId then
			GetMutedUsersStore(false).unmuteGlobalUserId(data.userId)
		end

		if data.username then
			GetMutedUsersStore(false).unmuteGlobalUsername(data.username)
		end

		if data.displayName then
			GetMutedUsersStore(false).unmuteGlobalDisplayName(data.displayName)
		end
	end,
	isUserIdMuted = function(p2)
		return GetMutedUsersStore(false).isUserIdMuted(p2)
	end,
	isUsernameMuted = function(p2)
		return GetMutedUsersStore(false).isUsernameMuted(p2)
	end,
	isDisplayNameMuted = function(p2)
		return GetMutedUsersStore(false).isDisplayNameMuted(p2)
	end,
	getMutedUserIds = function()
		return GetMutedUsersStore(false).getMutedUserIds
	end,
	getMutedUsernames = function()
		return GetMutedUsersStore(false).getMutedUsernames
	end,
	getMutedDisplayNames = function()
		return GetMutedUsersStore(false).getMutedDisplayNames
	end,
	resolveMuteTarget = require("@game/CorePackages/Workspace/Packages/_Index/ChatMute/ChatMute/resolveMuteTarget"),
	resolveUnmuteTarget = require("@game/CorePackages/Workspace/Packages/_Index/ChatMute/ChatMute/resolveUnmuteTarget"),
	getPlayersFromService = require("@game/CorePackages/Workspace/Packages/_Index/ChatMute/ChatMute/getPlayersFromService")
}
