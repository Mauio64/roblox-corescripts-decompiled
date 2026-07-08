local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local Immutable = require(UserLibParent.AppCommonLib).Immutable
local AddUser = require(UserLib.Actions).AddUser
local AddUsers = require(UserLib.Actions).AddUsers
local ReceivedUserPresence = require(UserLib.Actions).ReceivedUserPresence
local RemoveUser = require(UserLib.Actions).RemoveUser
local SetUserIsFriend = require(UserLib.Actions).SetUserIsFriend
local SetUserMembershipType = require(UserLib.Actions).SetUserMembershipType
local SetUserHasRobloxSubscription = require(UserLib.Actions).SetUserHasRobloxSubscription
local SetUserPresence = require(UserLib.Actions).SetUserPresence
local ReceivedDisplayName = require(UserLib.Actions).ReceivedDisplayName
local FFlagEnableBlackbirdCheck = require(UserLibParent.SharedFlags).FFlagEnableBlackbirdCheck

return function(p1, p2) -- line: 20
	-- upvalues: AddUser (copy), Immutable (copy), AddUsers (copy), SetUserIsFriend (copy), SetUserPresence (copy), ReceivedUserPresence (copy), SetUserMembershipType (copy), FFlagEnableBlackbirdCheck (copy), SetUserHasRobloxSubscription (copy), RemoveUser (copy), ReceivedDisplayName (copy)
	local v16 = p1 or {}

	assert(v16, "")

	if p2.type == AddUser.name then
		local user = p2.user

		return (Immutable.Set(v16, user.id, user))
	end

	if p2.type == AddUsers.name then
		local users = p2.users
		local t1 = {}

		for k, v in pairs(users) do
			local v22 = v16[k]

			if v22 then
				t1[k] = Immutable.JoinDictionaries(v22, v)
			else
				t1[k] = v
			end
		end

		return (Immutable.JoinDictionaries(v16, t1))
	end

	if p2.type == SetUserIsFriend.name then
		local v23 = v16[p2.userId]

		if v23 then
			local v24 = Immutable.Set(v23, "isFriend", p2.isFriend)

			return (Immutable.Set(v16, v23.id, v24))
		end

		warn("Setting isFriend on user", p2.userId, "who doesn't exist yet")

		return v16
	end

	if p2.type == SetUserPresence.name then
		local v25 = v16[p2.userId]

		if v25 then
			local v26 = Immutable.JoinDictionaries(v25, {
				presence = p2.presence,
				lastLocation = p2.lastLocation
			})

			return (Immutable.Set(v16, v25.id, v26))
		end

		warn("Setting presence on user", p2.userId, "who doesn't exist yet")

		return v16
	end

	if p2.type == ReceivedUserPresence.name then
		local v27 = v16[p2.userId]

		if v27 then
			return (Immutable.JoinDictionaries(v16, {
				[p2.userId] = Immutable.JoinDictionaries(v27, {
					presence = p2.presence,
					lastLocation = p2.lastLocation,
					placeId = p2.placeId,
					rootPlaceId = p2.rootPlaceId,
					gameInstanceId = p2.gameInstanceId,
					lastOnline = p2.lastOnline,
					universeId = p2.universeId
				})
			}))
		end
	elseif p2.type == SetUserMembershipType.name then
		local v28 = v16[p2.userId]

		if v28 then
			return (Immutable.JoinDictionaries(v16, {
				[p2.userId] = Immutable.JoinDictionaries(v28, {
					membership = p2.membershipType
				})
			}))
		end
	elseif FFlagEnableBlackbirdCheck and p2.type == SetUserHasRobloxSubscription.name then
		local v29 = v16[p2.userId]

		if v29 then
			return (Immutable.JoinDictionaries(v16, {
				[p2.userId] = Immutable.JoinDictionaries(v29, {
					hasRobloxSubscription = p2.hasRobloxSubscription
				})
			}))
		end
	elseif p2.type == RemoveUser.name then
		if v16[p2.userId] then
			return (Immutable.RemoveFromDictionary(v16, p2.userId))
		end
	elseif p2.type == ReceivedDisplayName.name then
		local v30 = v16[p2.userId]

		if v30 then
			v16 = Immutable.JoinDictionaries(v16, {
				[p2.userId] = Immutable.JoinDictionaries(v30, {
					displayName = p2.displayName
				})
			})
		end
	end

	return v16
end
