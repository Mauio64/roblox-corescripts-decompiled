local Parent = script:FindFirstAncestor("AppChat").Parent
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useLocalUserId = require(Parent.RobloxAppHooks).useLocalUserId
local useFriendsListOrderedByPresence = require(Parent.FriendsCommon).Hooks.useFriendsListOrderedByPresence
local UserModel = require(Parent.UserLib).Models.UserModel
local convertPresenceTypeToUserPresence = require(script.Parent.Utils.convertPresenceTypeToUserPresence)

function useFetchPaginatedFriends() -- line: 14
	-- upvalues: useLocalUserId (copy), useLocalization (copy), useFriendsListOrderedByPresence (copy), convertPresenceTypeToUserPresence (copy), UserModel (copy)
	local v7 = useLocalUserId()
	local v8 = useLocalization({
		offlinePresenceText = "Common.Presence.Label.Offline",
		onlinePresenceText = "Common.Presence.Label.Online"
	})
	local v9 = useFriendsListOrderedByPresence({
		pageSize = 50,
		userId = v7
	})
	local t1 = {}

	if v9.onlineFriends and v9.offlineFriends then
		for _, v12 in v9.onlineFriends do
			local id = v12.id
			local v14 = if not v12.presence then nil else v12.presence.userPresenceType
			local v15 = convertPresenceTypeToUserPresence(v14)
			local onlinePresenceText = nil

			if v15 == UserModel.PresenceType.ONLINE then
				onlinePresenceText = v8.onlinePresenceText
			elseif v15 == UserModel.PresenceType.IN_GAME then
				onlinePresenceText = not v12.presence and "" or v12.presence.lastLocation
			elseif v15 == UserModel.PresenceType.IN_STUDIO then
				onlinePresenceText = "Studio"
			end

			table.insert(t1, {
				id = id,
				presence = v15,
				presenceText = onlinePresenceText,
				thumbnail = `rbxthumb://type=AvatarHeadShot&id={ id }&w=150&h=150`
			})
		end

		for _, v18 in v9.offlineFriends do
			local OFFLINE = UserModel.PresenceType.OFFLINE
			local offlinePresenceText = v8.offlinePresenceText
			local id = v18.id

			table.insert(t1, {
				id = id,
				presence = OFFLINE,
				presenceText = offlinePresenceText,
				thumbnail = `rbxthumb://type=AvatarHeadShot&id={ id }&w=150&h=150`
			})
		end
	end

	return t1, v9.fetchMoreFriends, v9.isEndOfList
end

return useFetchPaginatedFriends
