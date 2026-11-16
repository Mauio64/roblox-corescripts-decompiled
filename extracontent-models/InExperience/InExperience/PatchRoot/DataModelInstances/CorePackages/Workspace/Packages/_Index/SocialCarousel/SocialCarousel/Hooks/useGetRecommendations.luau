local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local SocialCommon = require(parent.SocialCommon)
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local RoactUtils = require(parent.RoactUtils)
local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local tutils = require(parent.tutils)
local getDeepValue = require(SocialCarousel.Utils.getDeepValue)
local Constants = require(SocialCarousel.Common.Constants)
local RecommendationSourceEnum = SocialCommon.Enums.RecommendationSourceEnum
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local FriendsRecommendations = require(parent.DataHydration.FriendsRecommendations)
local FriendsRecommendationsStore = FriendsRecommendations.FriendsRecommendationsStore
local DataSource = FriendsRecommendations.Enums.DataSource

local FFlagMigrateFriendshipStatusesSocialCarousel = require(SocialCarousel.Flags.FFlagMigrateFriendshipStatusesSocialCarousel)

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselMigrateRecommendations = SharedFlags.FFlagSocialCarouselMigrateRecommendations
local FFlagSocialCarouselStableSelectors = require(SocialCarousel.Flags.FFlagSocialCarouselStableSelectors)
local v

if FFlagMigrateFriendshipStatusesSocialCarousel then
	v = DataHydration.Friends.FriendsStore.get()
else
	v = nil
end

local v2 = { skipFetch = true }

local frozen = table.freeze({})

local function fn(p, p2): boolean
	return p.rank < p2.rank
end

return function(value: string)
	local function fn2(p)
		local recommendationsDict

		if not FFlagSocialCarouselMigrateRecommendations then
			recommendationsDict = getDeepValue(
					p,
					string.format("%s.Friends.recommendations.byUserId.%s", Constants.RODUX_KEY, value or "")
				)
				or not FFlagSocialCarouselStableSelectors and {}
				or frozen
		end

		local friendshipStatus

		if not FFlagMigrateFriendshipStatusesSocialCarousel then
			friendshipStatus = getDeepValue(p, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY))
				or not FFlagSocialCarouselStableSelectors and {}
				or frozen
		end

		local friendsCarouselRecommendationIds

		if not FFlagSocialCarouselMigrateRecommendations then
			friendsCarouselRecommendationIds = getDeepValue(
					p,
					string.format(
						"%s.Friends.recommendations.bySource.%s",
						Constants.RODUX_KEY,
						RecommendationSourceEnum.HomepageFriendsCarousel
					)
				)
				or not FFlagSocialCarouselStableSelectors and {}
				or frozen
		end

		local hasIncomingFriendRequest

		if not FFlagSocialCarouselMigrateRecommendations then
			hasIncomingFriendRequest = getDeepValue(
				p,
				string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)
			)
		end

		return {
			recommendationsDict = recommendationsDict,
			friendshipStatus = friendshipStatus,
			friendsCarouselRecommendationIds = friendsCarouselRecommendationIds,
			hasIncomingFriendRequest = hasIncomingFriendRequest
		}
	end

	local v3

	if FFlagSocialCarouselStableSelectors then
		v3 = tutils.shallowEqual
	end

	local v4 = useSelector(fn2, v3)
	local v5

	if FFlagSocialCarouselMigrateRecommendations then
		v5 = nil
	else
		v5 = React.useMemo(function()
			return Cryo.List.filter(Cryo.Dictionary.keys(v4.recommendationsDict), function(p)
				return v4.friendsCarouselRecommendationIds[p]
			end)
		end, { v4.recommendationsDict, v4.friendsCarouselRecommendationIds })
	end

	local v6

	if FFlagMigrateFriendshipStatusesSocialCarousel and not FFlagSocialCarouselMigrateRecommendations then
		v6 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local result = {}

				for _, v7 in v5 do
					local friendshipStatus = v.GetFriendshipStatus(v7, v2)
					local v8

					if friendshipStatus then
						v8 = friendshipStatus.data(p)
					end

					result[v7] = v8
				end

				return result
			end)
		end, { table.concat(v5, ",") })
	end

	local v7

	if FFlagMigrateFriendshipStatusesSocialCarousel and not FFlagSocialCarouselMigrateRecommendations then
		v7 = SignalsReact.useSignalState(v6)
	else
		v7 = nil
	end

	local v8

	if FFlagSocialCarouselMigrateRecommendations then
		v8 = nil
	else
		local useCallback = React.useCallback
		local function fn3(p: string)
			local recommendation = v4.recommendationsDict[p]
			local v9

			if FFlagMigrateFriendshipStatusesSocialCarousel then
				v9 = v7 and v7[p]
			else
				v9 = v4.friendshipStatus[p]
			end

			local join = Cryo.Dictionary.join
			local isFriendWithUser

			if v9 then
				isFriendWithUser = v9 == Enum.FriendStatus.Friend
			else
				isFriendWithUser = false
			end

			local hasPendingFriendRequest

			if v9 then
				hasPendingFriendRequest = v9 == Enum.FriendStatus.FriendRequestSent
			else
				hasPendingFriendRequest = false
			end

			return join({}, recommendation, {
				isFriendWithUser = isFriendWithUser,
				hasPendingFriendRequest = hasPendingFriendRequest,
				canSendFriendRequest = not v9 or v9 == Enum.FriendStatus.NotFriend,
				hasIncomingFriendRequest = v4.hasIncomingFriendRequest[p]
			})
		end

		local recommendationsDict = v4.recommendationsDict
		local v9

		if FFlagMigrateFriendshipStatusesSocialCarousel then
			v9 = v7
		else
			v9 = v4.friendshipStatus
		end

		v8 = useCallback(fn3, { recommendationsDict, v9, v4.hasIncomingFriendRequest })
	end

	local v9

	if FFlagSocialCarouselMigrateRecommendations then
		local v10 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local data = FriendsRecommendationsStore.get().getFriendsRecommendations(
					DataSource.HomepageFriendsCarousel,
					v2
				).data(p)
				local data2 = data and data.data or {}

				return Cryo.List.map(data2, function(data3)
					local id = data3.id
					local v10

					if FFlagMigrateFriendshipStatusesSocialCarousel then
						local friendshipStatus = v.GetFriendshipStatus(id, v2)

						if friendshipStatus then
							v10 = friendshipStatus.data(p)
						end
					else
						v10 = v4.friendshipStatus[id]
					end

					local v11 = {
						id = id,
						mutualFriendsCount = data3.contextProps.mutualFriendsCount,
						contextType = data3.contextProps.contextType,
						rank = data3.rank,
						hasIncomingFriendRequest = data3.hasIncomingFriendRequest,
						isFriendWithUser = 0,
						hasPendingFriendRequest = 0,
						canSendFriendRequest = 0
					}
					local isFriendWithUser

					if v10 then
						isFriendWithUser = v10 == Enum.FriendStatus.Friend
					else
						isFriendWithUser = false
					end

					v11.isFriendWithUser = isFriendWithUser
					local hasPendingFriendRequest

					if v10 then
						hasPendingFriendRequest = v10 == Enum.FriendStatus.FriendRequestSent
					else
						hasPendingFriendRequest = false
					end

					v11.hasPendingFriendRequest = hasPendingFriendRequest

					v11.canSendFriendRequest = not v10 or v10 == Enum.FriendStatus.NotFriend
					return v11
				end)
			end)
		end, FFlagMigrateFriendshipStatusesSocialCarousel and {} or { v4.friendshipStatus })

		v9 = SignalsReact.useSignalState(v10)
	end

	local v10

	if not FFlagSocialCarouselMigrateRecommendations then
		v10 = React.useMemo(function()
			return Cryo.List.sort(Cryo.List.map(v5, v8), fn)
		end, { v5, v8 })
	end

	return if FFlagSocialCarouselMigrateRecommendations then v9 else v10
end
