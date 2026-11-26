local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/AppCommonLib").Immutable

local addUser = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").AddUser
local addUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").AddUsers
local receivedUserPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").ReceivedUserPresence
local removeUser = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").RemoveUser
local setUserIsFriend = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").SetUserIsFriend
local setUserMembershipType = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").SetUserMembershipType
local setUserHasRobloxSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").SetUserHasRobloxSubscription
local setUserPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").SetUserPresence
local receivedDisplayName = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions").ReceivedDisplayName

local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SharedFlags").FFlagEnableBlackbirdCheck

return function(options, data)
	local v5 = options or {}
	assert(v5, "")

	if data.type == addUser.name then
		local user = data.user
		return (immutable.Set(v5, user.id, user))
	end

	if data.type == addUsers.name then
		local users = data.users
		local v6 = {}

		for k, user in pairs(users) do
			local v7 = v5[k]

			if v7 then
				v6[k] = immutable.JoinDictionaries(v7, user)
			else
				v6[k] = user
			end
		end

		return (immutable.JoinDictionaries(v5, v6))
	elseif data.type == setUserIsFriend.name then
		local v6 = v5[data.userId]

		if v6 then
			local v7 = immutable.Set(v6, "isFriend", data.isFriend)
			return (immutable.Set(v5, v6.id, v7))
		end

		warn("Setting isFriend on user", data.userId, "who doesn't exist yet")
		return v5
	elseif data.type == setUserPresence.name then
		local v6 = v5[data.userId]

		if v6 then
			local joinDictionaries = immutable.JoinDictionaries(v6, {
				presence = data.presence,
				lastLocation = data.lastLocation
			})

			return (immutable.Set(v5, v6.id, joinDictionaries))
		end

		warn("Setting presence on user", data.userId, "who doesn't exist yet")
		return v5
	elseif data.type == receivedUserPresence.name then
		local v6 = v5[data.userId]

		if not v6 then
			return v5
		end

		return (immutable.JoinDictionaries(v5, {
			[data.userId] = immutable.JoinDictionaries(v6, {
				presence = data.presence,
				lastLocation = data.lastLocation,
				placeId = data.placeId,
				rootPlaceId = data.rootPlaceId,
				gameInstanceId = data.gameInstanceId,
				lastOnline = data.lastOnline,
				universeId = data.universeId
			})
		}))
	elseif data.type == setUserMembershipType.name then
		local v6 = v5[data.userId]

		if not v6 then
			return v5
		end

		return (immutable.JoinDictionaries(v5, {
			[data.userId] = immutable.JoinDictionaries(v6, {
				membership = data.membershipType
			})
		}))
	elseif fFlagEnableBlackbirdCheck and data.type == setUserHasRobloxSubscription.name then
		local v6 = v5[data.userId]

		if not v6 then
			return v5
		end

		return (immutable.JoinDictionaries(v5, {
			[data.userId] = immutable.JoinDictionaries(v6, {
				hasRobloxSubscription = data.hasRobloxSubscription
			})
		}))
	else
		if data.type == removeUser.name then
			if v5[data.userId] then
				return (immutable.RemoveFromDictionary(v5, data.userId))
			end
		elseif data.type == receivedDisplayName.name then
			local v6 = v5[data.userId]

			if v6 then
				v5 = immutable.JoinDictionaries(v5, {
					[data.userId] = immutable.JoinDictionaries(v6, {
						displayName = data.displayName
					})
				})
			end
		end

		return v5
	end
end
