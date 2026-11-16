local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable

local Actions = require(UserLib.Actions)
local AddUser = Actions.AddUser
local Actions2 = require(UserLib.Actions)
local AddUsers = Actions2.AddUsers
local Actions3 = require(UserLib.Actions)
local ReceivedUserPresence = Actions3.ReceivedUserPresence
local Actions4 = require(UserLib.Actions)
local RemoveUser = Actions4.RemoveUser
local Actions5 = require(UserLib.Actions)
local SetUserIsFriend = Actions5.SetUserIsFriend
local Actions6 = require(UserLib.Actions)
local SetUserMembershipType = Actions6.SetUserMembershipType
local Actions7 = require(UserLib.Actions)
local SetUserHasRobloxSubscription = Actions7.SetUserHasRobloxSubscription
local Actions8 = require(UserLib.Actions)
local SetUserPresence = Actions8.SetUserPresence
local Actions9 = require(UserLib.Actions)
local ReceivedDisplayName = Actions9.ReceivedDisplayName

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

return function(options, data)
	options = options or {}
	assert(options, "")

	if data.type == AddUser.name then
		local user = data.user
		return (Immutable.Set(options, user.id, user))
	end

	if data.type == AddUsers.name then
		local users = data.users
		local v = {}

		for k, user in pairs(users) do
			local option = options[k]

			if option then
				v[k] = Immutable.JoinDictionaries(option, user)
			else
				v[k] = user
			end
		end

		return (Immutable.JoinDictionaries(options, v))
	elseif data.type == SetUserIsFriend.name then
		local option = options[data.userId]

		if option then
			local v = Immutable.Set(option, "isFriend", data.isFriend)
			return (Immutable.Set(options, option.id, v))
		end

		warn("Setting isFriend on user", data.userId, "who doesn't exist yet")
		return options
	elseif data.type == SetUserPresence.name then
		local option = options[data.userId]

		if option then
			local joinDictionaries = Immutable.JoinDictionaries(option, {
				presence = data.presence,
				lastLocation = data.lastLocation
			})

			return (Immutable.Set(options, option.id, joinDictionaries))
		end

		warn("Setting presence on user", data.userId, "who doesn't exist yet")
		return options
	elseif data.type == ReceivedUserPresence.name then
		local option = options[data.userId]

		if not option then
			return options
		end

		return (Immutable.JoinDictionaries(options, {
			[data.userId] = Immutable.JoinDictionaries(option, {
				presence = data.presence,
				lastLocation = data.lastLocation,
				placeId = data.placeId,
				rootPlaceId = data.rootPlaceId,
				gameInstanceId = data.gameInstanceId,
				lastOnline = data.lastOnline,
				universeId = data.universeId
			})
		}))
	elseif data.type == SetUserMembershipType.name then
		local option = options[data.userId]

		if not option then
			return options
		end

		return (Immutable.JoinDictionaries(options, {
			[data.userId] = Immutable.JoinDictionaries(option, { membership = data.membershipType })
		}))
	elseif FFlagEnableBlackbirdCheck and data.type == SetUserHasRobloxSubscription.name then
		local option = options[data.userId]

		if not option then
			return options
		end

		return (Immutable.JoinDictionaries(options, {
			[data.userId] = Immutable.JoinDictionaries(option, {
				hasRobloxSubscription = data.hasRobloxSubscription
			})
		}))
	else
		if data.type == RemoveUser.name then
			if options[data.userId] then
				return (Immutable.RemoveFromDictionary(options, data.userId))
			end
		elseif data.type == ReceivedDisplayName.name then
			local option = options[data.userId]

			if option then
				options = Immutable.JoinDictionaries(options, {
					[data.userId] = Immutable.JoinDictionaries(option, {
						displayName = data.displayName
					})
				})
			end
		end

		return options
	end
end
