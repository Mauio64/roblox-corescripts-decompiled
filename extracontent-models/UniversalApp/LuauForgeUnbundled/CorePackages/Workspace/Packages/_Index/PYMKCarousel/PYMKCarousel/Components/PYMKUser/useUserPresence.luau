local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local react = dependencies.React
local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList")

local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local entityType = UserList.Enums.EntityType

local FFlagPymkCarouselPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPymkCarouselPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagPymkCarouselPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/DataHydration")

local presenceType = if FFlagPymkCarouselPresenceStoreMigration then DataHydration.Presence.PresenceEnums.PresenceType else nil

local v5 = if FFlagPymkCarouselPresenceStoreMigration then DataHydration.Presence.PresenceStore.get() else nil

local v6 = { skipFetch = true }

local function useUserPresence(data)
	if not FFlagPymkCarouselPresenceStoreMigration then
		local v7 = useSelector(function(p2)
			return getDeepValue(p2, string.format("PYMKCarousel.Presence.byUserId.%s", data.userId)) or {}
		end)

		return react.useMemo(function()
			if v7 and v7.userPresenceType then
				local userPresenceType = tostring(v7.userPresenceType)
				return (string.gsub(userPresenceType, "PresenceType%.", ""))
			end

			return "Offline"
		end, { v7 })
	end

	react.useEffect(function()
		if data.forceFetchUserPresence > 0 and data.entityType ~= entityType.Contact then
			v5.RefreshPresenceByUserId((tostring(data.userId)))
		end
	end, { data.forceFetchUserPresence, data.userId, data.entityType })

	local v7 = useGetPresenceByUserId(tostring(data.userId), v6)
	return v7 and v7.userPresenceType or presenceType.Offline
end

return useUserPresence
