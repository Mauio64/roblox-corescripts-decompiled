local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/FriendsCommon")
local GameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/GameJoinCard")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks").useLocalUserId
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Responsive")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/tutils")

local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local usePrefetchInGameFriendsMedia = GameJoinCard.usePrefetchInGameFriendsMedia
local useGetFriendRequests = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useGetFriendRequests")
local useGetRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useGetRecommendations")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Utils/getDeepValue")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial

local useGetFriendsCountByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/FriendsHydrationReact").useGetFriendsCountByUserId

local fIntSocialCarouselShowRecsLimit = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags").FIntSocialCarouselShowRecsLimit
local FFlagSocialCarouselShowLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselShowLoadingSkeleton")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags")
local fFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers
local fFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local fIntFriendsCarouselInitialFetchSize = SharedFlags.FIntFriendsCarouselInitialFetchSize

local fFlagEnableRecommendationsForPCGDK = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagEnableRecommendationsForPCGDK
local fFlagFixIsConsoleCheckForSocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagFixIsConsoleCheckForSocialCarousel
local defineFastFlag = game:DefineFastFlag("PrefetchFriendGameMedia", false)
local FFlagSocialCarouselStableSelectors = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselStableSelectors")

local tile = Enums.Tile
local tileGroup = Enums.TileGroup

local v5 = {
	{ tileGroup = tileGroup.AddFriends },
	{ tileGroup = tileGroup.FriendsListWithRecommendations }
}

if fFlagShowRequestsInCarouselForAllUsers then
	table.insert(v5, { tileGroup = tileGroup.FriendRequests })
end

local v6 = { skipFetch = true }

return function(p2, p3)
	local v7 = p3 or v5
	local v8 = useLocalUserId()
	local v9 = useGetRecommendations(v8)

	local v10 = useFriendsListOrderedByPresence({
		userId = v8,
		pageSize = fIntFriendsCarouselInitialFetchSize
	})

	if defineFastFlag then
		usePrefetchInGameFriendsMedia(v10.onlineFriends)
	end

	local v11

	if fFlagFixIsConsoleCheckForSocialCarousel then
		v11 = usePreferredInput() == Responsive.Input.Directional
	elseif fFlagEnableRecommendationsForPCGDK and ThirdPartyUserService then
		v11 = ThirdPartyUserService:HaveActiveUser()
	else
		v11 = usePreferredInput() == Responsive.Input.Directional
	end

	local v12 = if fFlagSocialCarouselShareQREnabled then useIsSpatial() else false

	local function fn(p4)
		return {
			friendRequestCount = getDeepValue(
				p4,
				string.format("%s.Friends.requests.receivedCount", p2 or Constants.RODUX_KEY)
			) or 0
		}
	end

	local v14 = if FFlagSocialCarouselStableSelectors then tutils.shallowEqual else nil
	local v15 = useSelector(fn, v14)

	local v17 = useGetFriendsCountByUserId(tostring(v8 or ""), v6) or 0
	local v18

	if fFlagShowRequestsInCarouselForAllUsers then
		v18 = React.useMemo(function(): boolean
			for k, v19 in v7 do
				if v19.tileGroup == tileGroup.FriendRequests then
					return true
				end
			end

			return false
		end, { v7 })
	else
		v18 = false
	end

	local v19

	if fFlagShowRequestsInCarouselForAllUsers then
		v19 = useGetFriendRequests(v18 and v17 < fIntFriendsCarouselInitialFetchSize)
	else
		v19 = nil
	end

	local v20 = v11 and v17 <= fIntSocialCarouselShowRecsLimit
	local v21

	if fFlagShowRequestsInCarouselForAllUsers then
		v21 = React.useMemo(function()
			if #v19 == 0 then
				return v19
			end

			local idSet = {}

			for k, onlineFriend in v10.onlineFriends do
				idSet[tostring(onlineFriend.id)] = true
			end

			for k, offlineFriend in v10.offlineFriends do
				idSet[tostring(offlineFriend.id)] = true
			end

			if v20 then
				for k, v22 in v9 do
					idSet[tostring(v22.id)] = true
				end
			end

			local result = {}

			for k, v22 in v19 do
				if not idSet[tostring(v22.id)] then
					table.insert(result, v22)
				end
			end

			return result
		end, { v10.onlineFriends, v10.offlineFriends, v9, v19, v20 })
	else
		v21 = v19
	end

	local v22 = v17 == 0 and not v11
	local v23 = fFlagSocialCarouselShareQREnabled

	if v23 then
		v23 = v17 == 0 and not (v11 or v12)
	end

	local v24

	if fFlagShowRequestsInCarouselForAllUsers then
		v24 = v17 < fIntFriendsCarouselInitialFetchSize and #v21 > 0
		v23 = v23 and not v24
		v22 = v22 and not v24
	else
		v24 = false
	end

	local useMemo = React.useMemo
	local function fn2()
		local v25 = {
			[tileGroup.FriendsList] = {
				{ tiles = v10.onlineFriends, tileType = tile.Friend },
				{ tiles = v10.offlineFriends, tileType = tile.Friend }
			},
			[tileGroup.FriendsListWithRecommendations] = {
				{ tiles = v10.onlineFriends, tileType = tile.Friend },
				v20 and { tiles = v9, tileType = tile.Recommendation } or nil,
				{ tiles = v10.offlineFriends, tileType = tile.Friend }
			},
			[tileGroup.AddFriends] = {
				{ tileType = tile.AddFriends },
				v23 and { tileType = tile.ShareQR } or nil,
				v22 and { tileType = tile.FriendsHint } or nil
			},
			[tileGroup.StartSquad] = {
				{ tileType = tile.StartSquad }
			}
		}

		if fFlagShowRequestsInCarouselForAllUsers then
			v25[tileGroup.FriendRequests] = { v24 and {
					tiles = v21,
					tileType = tile.FriendRequest
				} or nil }
		end

		return v25
	end

	local onlineFriends = v10.onlineFriends
	local offlineFriends = v10.offlineFriends
	local v26 = if fFlagShowRequestsInCarouselForAllUsers then v21 else nil
	local v27 = if fFlagShowRequestsInCarouselForAllUsers then v24 else nil
	local v30 = useMemo(fn2, {
		onlineFriends,
		offlineFriends,
		v9,
		v26,
		v27,
		v20,
		v22,
		if fFlagSocialCarouselShareQREnabled then v23 else nil
	})

	return {
		tiles = React.useMemo(function()
			local result = {}

			for k, v31 in v7 do
				for k2, v32 in v30[v31.tileGroup] do
					if not v32 then
						continue
					end

					if v32.tiles then
						for k3, tile2 in v32.tiles do
							table.insert(
								result,
								Cryo.Dictionary.join(tile2, {
									tileType = v32.tileType,
									onActivated = v31.onActivated
								})
							)
						end
					else
						table.insert(result, {
							tileType = v32.tileType,
							onActivated = v31.onActivated
						})
					end
				end
			end

			return result
		end, { v30, v7 }),
		friendCount = v17,
		friendRequestCount = v15.friendRequestCount,
		recommendationCount = #v9,
		refreshFriendsList = v10.refreshFriendsData,
		isLoading = FFlagSocialCarouselShowLoadingSkeleton and v10.isLoading
	}
end
