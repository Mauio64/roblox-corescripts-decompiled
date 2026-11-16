local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local parent = SocialCarousel.Parent
local FriendsCommon = require(parent.FriendsCommon)
local GameJoinCard = require(parent.GameJoinCard)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Responsive = require(parent.Responsive)
local tutils = require(parent.tutils)

local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local usePrefetchInGameFriendsMedia = GameJoinCard.usePrefetchInGameFriendsMedia
local useGetFriendRequests = require(SocialCarousel.Hooks.useGetFriendRequests)
local useGetRecommendations = require(SocialCarousel.Hooks.useGetRecommendations)
local getDeepValue = require(SocialCarousel.Utils.getDeepValue)
local Enums = require(SocialCarousel.Common.Enums)
local Constants = require(SocialCarousel.Common.Constants)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial

local FriendsHydrationReact = require(parent.FriendsHydrationReact)
local useGetFriendsCountByUserId = FriendsHydrationReact.useGetFriendsCountByUserId

local Flags = require(SocialCarousel.Flags)
local FIntSocialCarouselShowRecsLimit = Flags.FIntSocialCarouselShowRecsLimit
local FFlagSocialCarouselShowLoadingSkeleton = require(SocialCarousel.Flags.FFlagSocialCarouselShowLoadingSkeleton)
local SharedFlags = require(parent.SharedFlags)
local FFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local FIntFriendsCarouselInitialFetchSize = SharedFlags.FIntFriendsCarouselInitialFetchSize

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableRecommendationsForPCGDK = SharedFlags2.FFlagEnableRecommendationsForPCGDK
local SharedFlags3 = require(parent.SharedFlags)
local FFlagFixIsConsoleCheckForSocialCarousel = SharedFlags3.FFlagFixIsConsoleCheckForSocialCarousel
local defineFastFlag = game:DefineFastFlag("PrefetchFriendGameMedia", false)
local FFlagSocialCarouselStableSelectors = require(SocialCarousel.Flags.FFlagSocialCarouselStableSelectors)

local Tile = Enums.Tile
local TileGroup = Enums.TileGroup

local v = {
	{ tileGroup = TileGroup.AddFriends },
	{ tileGroup = TileGroup.FriendsListWithRecommendations }
}

if FFlagShowRequestsInCarouselForAllUsers then
	table.insert(v, { tileGroup = TileGroup.FriendRequests })
end

local v2 = { skipFetch = true }

return function(p: string?, p2)
	local v3 = p2 or v
	local userId = useLocalUserId()
	local tiles = useGetRecommendations(userId)

	local v4 = useFriendsListOrderedByPresence({
		userId = userId,
		pageSize = FIntFriendsCarouselInitialFetchSize
	})

	if defineFastFlag then
		usePrefetchInGameFriendsMedia(v4.onlineFriends)
	end

	local v5

	if FFlagFixIsConsoleCheckForSocialCarousel then
		v5 = usePreferredInput() == Responsive.Input.Directional
	elseif FFlagEnableRecommendationsForPCGDK and ThirdPartyUserService then
		v5 = ThirdPartyUserService:HaveActiveUser()
	else
		v5 = usePreferredInput() == Responsive.Input.Directional
	end

	local v6

	if FFlagSocialCarouselShareQREnabled then
		v6 = useIsSpatial()
	else
		v6 = false
	end

	local function fn(p3)
		return {
			friendRequestCount = getDeepValue(
				p3,
				string.format("%s.Friends.requests.receivedCount", p or Constants.RODUX_KEY)
			) or 0
		}
	end

	local v7

	if FFlagSocialCarouselStableSelectors then
		v7 = tutils.shallowEqual
	end

	local v8 = useSelector(fn, v7)

	local friendCount = useGetFriendsCountByUserId(tostring(userId or ""), v2) or 0
	local v9

	if FFlagShowRequestsInCarouselForAllUsers then
		v9 = React.useMemo(function(): boolean
			for _, v10 in v3 do
				if v10.tileGroup == TileGroup.FriendRequests then
					return true
				end
			end

			return false
		end, { v3 })
	else
		v9 = false
	end

	local v10

	if FFlagShowRequestsInCarouselForAllUsers then
		v10 = useGetFriendRequests(v9 and friendCount < FIntFriendsCarouselInitialFetchSize)
	else
		v10 = nil
	end

	local v11 = v5 and friendCount <= FIntSocialCarouselShowRecsLimit
	local tiles2

	if FFlagShowRequestsInCarouselForAllUsers then
		tiles2 = React.useMemo(function()
			if #v10 == 0 then
				return v10
			end

			local idSet = {}

			for _, onlineFriend in v4.onlineFriends do
				idSet[tostring(onlineFriend.id)] = true
			end

			for _, offlineFriend in v4.offlineFriends do
				idSet[tostring(offlineFriend.id)] = true
			end

			if v11 then
				for _, v12 in tiles do
					idSet[tostring(v12.id)] = true
				end
			end

			local result = {}

			for _, v12 in v10 do
				if not idSet[tostring(v12.id)] then
					table.insert(result, v12)
				end
			end

			return result
		end, { v4.onlineFriends, v4.offlineFriends, tiles, v10, v11 })
	else
		tiles2 = v10
	end

	local v12

	if friendCount == 0 then
		v12 = not v5
	else
		v12 = false
	end

	local v13 = FFlagSocialCarouselShareQREnabled

	if v13 then
		if friendCount == 0 then
			v13 = not (v5 or v6)
		else
			v13 = false
		end
	end

	local v14

	if FFlagShowRequestsInCarouselForAllUsers then
		if friendCount < FIntFriendsCarouselInitialFetchSize then
			v14 = #tiles2 > 0
		else
			v14 = false
		end

		v13 = v13 and not v14
		v12 = v12 and not v14
	else
		v14 = false
	end

	local useMemo = React.useMemo
	local function fn2()
		local v15 = {
			[TileGroup.FriendsList] = {
				{ tiles = v4.onlineFriends, tileType = Tile.Friend },
				{ tiles = v4.offlineFriends, tileType = Tile.Friend }
			},
			[TileGroup.FriendsListWithRecommendations] = {
				{ tiles = v4.onlineFriends, tileType = Tile.Friend },
				v11 and { tiles = tiles, tileType = Tile.Recommendation } or nil,
				{ tiles = v4.offlineFriends, tileType = Tile.Friend }
			},
			[TileGroup.AddFriends] = {
				{ tileType = Tile.AddFriends },
				v13 and { tileType = Tile.ShareQR } or nil,
				v12 and { tileType = Tile.FriendsHint } or nil
			},
			[TileGroup.StartSquad] = {
				{ tileType = Tile.StartSquad }
			}
		}

		if FFlagShowRequestsInCarouselForAllUsers then
			v15[TileGroup.FriendRequests] = { v14 and {
					tiles = tiles2,
					tileType = Tile.FriendRequest
				} or nil }
		end

		return v15
	end

	local onlineFriends = v4.onlineFriends
	local offlineFriends = v4.offlineFriends
	local v15

	if FFlagShowRequestsInCarouselForAllUsers then
		v15 = tiles2
	end

	local v16

	if FFlagShowRequestsInCarouselForAllUsers then
		v16 = v14
	end

	local v17

	if FFlagSocialCarouselShareQREnabled then
		v17 = v13
	end

	local v18 = useMemo(fn2, { onlineFriends, offlineFriends, tiles, v15, v16, v11, v12, v17 })

	return {
		tiles = React.useMemo(function()
			local result = {}

			for _, v19 in v3 do
				for _, v20 in v18[v19.tileGroup] do
					if not v20 then
						continue
					end

					if v20.tiles then
						for _, tile in v20.tiles do
							table.insert(
								result,
								Cryo.Dictionary.join(tile, {
									tileType = v20.tileType,
									onActivated = v19.onActivated
								})
							)
						end
					else
						table.insert(result, {
							tileType = v20.tileType,
							onActivated = v19.onActivated
						})
					end
				end
			end

			return result
		end, { v18, v3 }),
		friendCount = friendCount,
		friendRequestCount = v8.friendRequestCount,
		recommendationCount = #tiles,
		refreshFriendsList = v4.refreshFriendsData,
		isLoading = FFlagSocialCarouselShowLoadingSkeleton and v4.isLoading
	}
end
