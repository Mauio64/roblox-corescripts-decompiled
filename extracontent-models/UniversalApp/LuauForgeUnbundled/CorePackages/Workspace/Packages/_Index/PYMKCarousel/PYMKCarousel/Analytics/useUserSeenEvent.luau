local Constants = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local llama = dependencies.llama
local react = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/EventNames")
local getFriendStatus = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/getFriendStatus")
local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

local FFlagMigrateFriendshipStatusesPYMK = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagMigrateFriendshipStatusesPYMK")
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppEnableSduiHomePage
local FFlagPYMKCarouselStableSelectors = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPYMKCarouselStableSelectors")

local frozen = table.freeze({})

local v5 = if FFlagMigrateFriendshipStatusesPYMK then require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/DataHydration").Friends.FriendsStore.get() else nil

local function getHydratedFriendshipStatus(p2)
	local friendshipStatus = v5.GetFriendshipStatus(p2, { skipFetch = true })

	if friendshipStatus then
		return (friendshipStatus.data(false))
	end

	return nil
end

return function(p2)
	local ref = react.useRef({})
	local v6

	if FFlagMigrateFriendshipStatusesPYMK then
		v6 = nil
	else
		v6 = useSelector(function(p3)
			local v7 = getDeepValue(p3, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY))

			if v7 then
				return v7
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			v7 = {}
			return v7
		end)
	end

	local v7

	if fFlagLuaAppEnableSduiHomePage then
		v7 = nil
	else
		v7 = useSelector(function(p3)
			return getDeepValue(
				p3,
				string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)
			)
		end) or not FFlagPYMKCarouselStableSelectors and {} or frozen
	end

	local v8 = useSelector(function(p3)
		local v9 = getDeepValue(p3, "PYMKCarousel.Presence.byUserId")

		if v9 then
			return v9
		end

		if FFlagPYMKCarouselStableSelectors then
			return frozen
		end

		v9 = {}
		return v9
	end)

	return react.useMemo(function()
		return {
			{
				viewabilityConfig = {
					itemVisiblePercentThreshold = 50,
					waitForInteraction = false
				},
				onViewableItemsChanged = function(p3)
					for k, v10 in pairs(p3.changed) do
						local item = v10.item
						local current = ref.current or {}

						local v11 = not current[item.id]

						if getFFlagPYMKAddFriendsEntry() then
							v11 = not (current[item.id] or item.isTooltip or item.isButtonTile)
						end

						if not v11 then
							continue
						end

						local userSeen = EventNames.UserSeen
						local v13 = {
							userId = item.id,
							contactId = 0,
							friendStatus = 0,
							recommendationContextType = 0,
							recommendationRank = 0,
							absolutePosition = 0,
							presence = 0
						}
						local v14 = if item.recommendationContextType == recommendationContextType.Contacts then item.id else nil
						v13.contactId = v14
						local v16

						if FFlagMigrateFriendshipStatusesPYMK then
							local id = item.id
							local friendshipStatus = v5.GetFriendshipStatus(id, {
								skipFetch = true
							})

							if friendshipStatus then
								v16 = friendshipStatus.data(false)
							end
						else
							v16 = v6[item.id]
						end

						local v17 = if fFlagLuaAppEnableSduiHomePage then item.hasIncomingFriendRequest else v7[item.id]
						v13.friendStatus = getFriendStatus(v16, v17)

						v13.recommendationContextType = item.recommendationContextType
						v13.recommendationRank = item.recommendationRank
						v13.absolutePosition = item.absolutePosition
						v13.presence = (v8[item.id] or {}).userPresenceType
						p2(userSeen, v13)

						ref.current = llama.Dictionary.join(ref.current, {
							[item.id] = true
						})
					end
				end
			}
		}
	end, FFlagPYMKCarouselStableSelectors and { v8, v6, v7, p2 } or { v8 })
end
