local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local SocialCarouselParent = SocialCarousel.Parent
local FriendsCommon = require(SocialCarouselParent.FriendsCommon)
local GameJoinCard = require(SocialCarouselParent.GameJoinCard)
local useLocalUserId = require(SocialCarouselParent.RobloxAppHooks).useLocalUserId
local Cryo = require(SocialCarouselParent.Cryo)
local React = require(SocialCarouselParent.React)
local RoactUtils = require(SocialCarouselParent.RoactUtils)
local Responsive = require(SocialCarouselParent.Responsive)
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local usePrefetchInGameFriendsMedia = GameJoinCard.usePrefetchInGameFriendsMedia
local useGetRecommendations = require(SocialCarousel.Hooks.useGetRecommendations)
local getDeepValue = require(SocialCarousel.Utils.getDeepValue)
local Enums = require(SocialCarousel.Common.Enums)
local Constants = require(SocialCarousel.Common.Constants)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local FIntSocialCarouselShowRecsLimit = require(SocialCarousel.Flags).FIntSocialCarouselShowRecsLimit
local FFlagSocialCarouselShowLoadingSkeleton = require(SocialCarousel.Flags.FFlagSocialCarouselShowLoadingSkeleton)
local FFlagSocialCarouselShareQREnabled = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQREnabled
local FIntFriendsCarouselInitialFetchSize = require(SocialCarouselParent.SharedFlags).FIntFriendsCarouselInitialFetchSize
local FFlagEnableRecommendationsForPCGDK = require(SocialCarouselParent.SharedFlags).FFlagEnableRecommendationsForPCGDK
local FFlagFixIsConsoleCheckForSocialCarousel = require(SocialCarouselParent.SharedFlags).FFlagFixIsConsoleCheckForSocialCarousel
local v26 = game:DefineFastFlag("PrefetchFriendGameMedia", false)
local Tile = Enums.Tile
local TileGroup = Enums.TileGroup
local t1 = {
	{
		tileGroup = TileGroup.AddFriends
	},
	{
		tileGroup = TileGroup.FriendsListWithRecommendations
	}
}

return function(s1: string?, p1) -- line: 46
	-- upvalues: t1 (copy), useLocalUserId (copy), useGetRecommendations (copy), useFriendsListOrderedByPresence (copy), FIntFriendsCarouselInitialFetchSize (copy), v26 (copy), usePrefetchInGameFriendsMedia (copy), FFlagFixIsConsoleCheckForSocialCarousel (copy), usePreferredInput (copy), Responsive (copy), FFlagEnableRecommendationsForPCGDK (copy), ThirdPartyUserService (copy), FFlagSocialCarouselShareQREnabled (copy), useIsSpatial (copy), useSelector (copy), getDeepValue (copy), Constants (copy), FIntSocialCarouselShowRecsLimit (copy), React (copy), TileGroup (copy), Tile (copy), Cryo (copy), FFlagSocialCarouselShowLoadingSkeleton (copy)
	local v32 = p1 or t1
	local v33 = useLocalUserId()
	local v34 = useGetRecommendations(v33)
	local v35 = useFriendsListOrderedByPresence({
		userId = v33,
		pageSize = FIntFriendsCarouselInitialFetchSize
	})

	if v26 then
		usePrefetchInGameFriendsMedia(v35.onlineFriends)
	end

	local v36 = if not FFlagFixIsConsoleCheckForSocialCarousel then if not FFlagEnableRecommendationsForPCGDK or not ThirdPartyUserService then usePreferredInput() == Responsive.Input.Directional else ThirdPartyUserService:HaveActiveUser() else usePreferredInput() == Responsive.Input.Directional
	local v37 = not not FFlagSocialCarouselShareQREnabled and useIsSpatial()
	local v38 = useSelector(function(p2) -- line: 65
		-- upvalues: getDeepValue (copy), s1 (copy), Constants (copy), v33 (copy)
		return {
			friendCount = getDeepValue(p2, string.format("%s.Friends.countsByUserId.%s", s1 or Constants.RODUX_KEY, v33 or "")) or 0,
			friendRequestCount = getDeepValue(p2, string.format("%s.Friends.requests.receivedCount", s1 or Constants.RODUX_KEY)) or 0
		}
	end)
	local v39 = v36 and v38.friendCount <= FIntSocialCarouselShowRecsLimit
	local v40 = v38.friendCount == 0 and not v36
	local v41 = FFlagSocialCarouselShareQREnabled and (v38.friendCount == 0 and (not v36 and not v37))
	local v42 = React.useMemo(function() -- line: 84
		-- upvalues: TileGroup (copy), v35 (copy), Tile (copy), v39 (copy), v34 (copy), v41 (copy), v40 (copy)
		return {
			[TileGroup.FriendsList] = {
				{
					tiles = v35.onlineFriends,
					tileType = Tile.Friend
				},
				{
					tiles = v35.offlineFriends,
					tileType = Tile.Friend
				}
			},
			[TileGroup.FriendsListWithRecommendations] = {
				{
					tiles = v35.onlineFriends,
					tileType = Tile.Friend
				},
				if not v39 then nil else {
					tiles = v34,
					tileType = Tile.Recommendation
				},
				{
					tiles = v35.offlineFriends,
					tileType = Tile.Friend
				}
			},
			[TileGroup.AddFriends] = {
				{
					tileType = Tile.AddFriends
				},
				if not v41 then nil else {
					tileType = Tile.ShareQR
				},
				if not v40 then nil else {
					tileType = Tile.FriendsHint
				}
			},
			[TileGroup.StartSquad] = {{
				tileType = Tile.StartSquad
			}}
		}
	end, {
		v35.onlineFriends,
		v35.offlineFriends,
		v34,
		v39,
		v40,
		if not FFlagSocialCarouselShareQREnabled then nil else v41
	})

	return {
		tiles = React.useMemo(function() -- line: 117
			-- upvalues: v32 (copy), v42 (copy), Cryo (copy)
			local t2 = {}

			for _, v46 in v32 do
				for _, v48 in v42[v46.tileGroup] do
					if v48 then
						if v48.tiles then
							for _, v50 in v48.tiles do
								table.insert(t2, Cryo.Dictionary.join(v50, {
									tileType = v48.tileType,
									onActivated = v46.onActivated
								}))
							end
						else
							table.insert(t2, {
								tileType = v48.tileType,
								onActivated = v46.onActivated
							})
						end
					end
				end
			end

			return t2
		end, {
			v42,
			v32
		}),
		friendCount = v38.friendCount,
		friendRequestCount = v38.friendRequestCount,
		recommendationCount = #v34,
		refreshFriendsList = v35.refreshFriendsData,
		isLoading = FFlagSocialCarouselShowLoadingSkeleton and v35.isLoading
	}
end
