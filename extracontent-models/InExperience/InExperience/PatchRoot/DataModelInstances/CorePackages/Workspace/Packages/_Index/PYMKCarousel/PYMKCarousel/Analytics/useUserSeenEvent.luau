local parent = script.Parent.Parent
local parent2 = parent.Parent
local Constants = require(parent.Common.Constants)
local dependencies = require(parent.dependencies)

local llama = dependencies.llama
local react = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local EventNames = require(script.Parent.EventNames)
local getFriendStatus = require(script.Parent.getFriendStatus)
local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

local FFlagMigrateFriendshipStatusesPYMK = require(parent.Flags.FFlagMigrateFriendshipStatusesPYMK)
local SharedFlags = require(parent2.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagPYMKCarouselStableSelectors = require(parent.Flags.FFlagPYMKCarouselStableSelectors)
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags2.FFlagPymkCarouselExtendProps

local frozen = table.freeze({})
local v

if FFlagMigrateFriendshipStatusesPYMK then
	local DataHydration = require(parent2.DataHydration)
	v = DataHydration.Friends.FriendsStore.get()
else
	v = nil
end

local function getHydratedFriendshipStatus(id: string) -- 1 equivalent call inferred from this helper
	local friendshipStatus = v.GetFriendshipStatus(id, { skipFetch = true })

	if friendshipStatus then
		return (friendshipStatus.data(false))
	end

	return nil
end

return function(callback)
	local ref = react.useRef({})
	local v2

	if FFlagMigrateFriendshipStatusesPYMK then
		v2 = nil
	else
		v2 = useSelector(function(p)
			local v3 = getDeepValue(p, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY))

			if v3 then
				return v3
			end

			if FFlagPYMKCarouselStableSelectors then
				return frozen
			end

			return {}
		end)
	end

	local v3

	if FFlagLuaAppEnableSduiHomePage then
		v3 = nil
	else
		v3 = useSelector(function(p)
			return getDeepValue(
				p,
				string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)
			)
		end) or not FFlagPYMKCarouselStableSelectors and {} or frozen
	end

	local v4 = useSelector(function(p)
		local v4 = getDeepValue(p, "PYMKCarousel.Presence.byUserId")

		if v4 then
			return v4
		end

		if FFlagPYMKCarouselStableSelectors then
			return frozen
		end

		return {}
	end)

	return react.useMemo(function()
		return {
			{
				viewabilityConfig = { itemVisiblePercentThreshold = 50, waitForInteraction = false },
				onViewableItemsChanged = function(p)
					for _, v5 in pairs(p.changed) do
						local item = v5.item
						local current = ref.current or {}

						local v6 = not current[item.id]

						if getFFlagPYMKAddFriendsEntry() then
							v6 = not (current[item.id] or item.isTooltip or item.isButtonTile)
						end

						if not v6 then
							continue
						end

						local userSeen = EventNames.UserSeen
						local v7 = {
							userId = item.id,
							contactId = 0,
							friendStatus = 0,
							recommendationContextType = 0,
							recommendationRank = 0,
							absolutePosition = 0,
							presence = 0
						}
						local contactId

						if item.recommendationContextType == recommendationContextType.Contacts then
							contactId = item.id
						end

						v7.contactId = contactId
						local v8

						if FFlagMigrateFriendshipStatusesPYMK then
							v8 = getHydratedFriendshipStatus(item.id) -- inferred equivalent call
						else
							v8 = v2[item.id]
						end

						local v9

						if FFlagPymkCarouselExtendProps then
							if FFlagLuaAppEnableSduiHomePage or item.hasIncomingFriendRequest ~= nil then
								v9 = item.hasIncomingFriendRequest
							else
								v9 = v3[item.id]
							end
						elseif FFlagLuaAppEnableSduiHomePage then
							v9 = item.hasIncomingFriendRequest
						else
							v9 = v3[item.id]
						end

						v7.friendStatus = getFriendStatus(v8, v9)

						v7.recommendationContextType = item.recommendationContextType
						v7.recommendationRank = item.recommendationRank
						v7.absolutePosition = item.absolutePosition
						v7.presence = (v4[item.id] or {}).userPresenceType
						callback(userSeen, v7)

						ref.current = llama.Dictionary.join(ref.current, { [item.id] = true })
					end
				end
			}
		}
	end, FFlagPYMKCarouselStableSelectors and { v4, v2, v3, callback } or { v4 })
end
