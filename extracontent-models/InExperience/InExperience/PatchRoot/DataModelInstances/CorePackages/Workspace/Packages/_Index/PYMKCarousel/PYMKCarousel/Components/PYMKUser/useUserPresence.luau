local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local react = dependencies.React
local UserList = require(parent2.UserList)

local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local EntityType = UserList.Enums.EntityType

local FFlagPymkCarouselPresenceStoreMigration = require(parent.Flags.FFlagPymkCarouselPresenceStoreMigration)
local useGetPresenceByUserId

if FFlagPymkCarouselPresenceStoreMigration then
	local FriendsCommon = require(parent2.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local DataHydration = require(parent2.DataHydration)
local presenceType

if FFlagPymkCarouselPresenceStoreMigration then
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType = nil
end

local v

if FFlagPymkCarouselPresenceStoreMigration then
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local v2 = { skipFetch = true }

local function useUserPresence(data)
	if not FFlagPymkCarouselPresenceStoreMigration then
		local v3 = useSelector(function(p)
			return getDeepValue(p, string.format("PYMKCarousel.Presence.byUserId.%s", data.userId)) or {}
		end)

		return (react.useMemo(function()
			if v3 and v3.userPresenceType then
				local userPresenceType = tostring(v3.userPresenceType)
				return (string.gsub(userPresenceType, "PresenceType%.", ""))
			end

			return "Offline"
		end, { v3 }))
	end

	react.useEffect(function()
		if data.forceFetchUserPresence > 0 and data.entityType ~= EntityType.Contact then
			v.RefreshPresenceByUserId((tostring(data.userId)))
		end
	end, { data.forceFetchUserPresence, data.userId, data.entityType })

	local v3 = useGetPresenceByUserId(tostring(data.userId), v2)
	return v3 and v3.userPresenceType or presenceType.Offline
end

return useUserPresence
