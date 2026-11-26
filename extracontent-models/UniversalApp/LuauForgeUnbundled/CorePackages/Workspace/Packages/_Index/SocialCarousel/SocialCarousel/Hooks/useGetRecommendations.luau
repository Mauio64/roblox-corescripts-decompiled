local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Cryo")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/DataHydration")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SignalsReact")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/tutils")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Utils/getDeepValue")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local recommendationSourceEnum = SocialCommon.Enums.RecommendationSourceEnum
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local FriendsRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/DataHydration/FriendsRecommendations")
local friendsRecommendationsStore = FriendsRecommendations.FriendsRecommendationsStore
local dataSource = FriendsRecommendations.Enums.DataSource

local FFlagMigrateFriendshipStatusesSocialCarousel = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagMigrateFriendshipStatusesSocialCarousel")

local fFlagSocialCarouselMigrateRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselMigrateRecommendations
local FFlagSocialCarouselStableSelectors = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselStableSelectors")

local v5 = if FFlagMigrateFriendshipStatusesSocialCarousel then DataHydration.Friends.FriendsStore.get() else nil

local v6 = { skipFetch = true }

local frozen = table.freeze({})

local function fn(p2, p3): boolean
	return p2.rank < p3.rank
end

return function(value)
	local function fn2(p2)
		local v9 = if not fFlagSocialCarouselMigrateRecommendations then getDeepValue(
			p2,
			string.format("%s.Friends.recommendations.byUserId.%s", Constants.RODUX_KEY, value or "")
		) or not FFlagSocialCarouselStableSelectors and {} or frozen else nil

		local v10 = if not FFlagMigrateFriendshipStatusesSocialCarousel then getDeepValue(
			p2,
			string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY)
		) or not FFlagSocialCarouselStableSelectors and {} or frozen else nil

		local v11 = if not fFlagSocialCarouselMigrateRecommendations then getDeepValue(
			p2,
			string.format(
				"%s.Friends.recommendations.bySource.%s",
				Constants.RODUX_KEY,
				recommendationSourceEnum.HomepageFriendsCarousel
			)
		) or not FFlagSocialCarouselStableSelectors and {} or frozen else nil

		local v12 = if not fFlagSocialCarouselMigrateRecommendations then getDeepValue(
			p2,
			string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)
		) else nil
		return {
			recommendationsDict = v9,
			friendshipStatus = v10,
			friendsCarouselRecommendationIds = v11,
			hasIncomingFriendRequest = v12
		}
	end

	local v8 = if FFlagSocialCarouselStableSelectors then tutils.shallowEqual else nil
	local v9 = useSelector(fn2, v8)
	local v10

	if fFlagSocialCarouselMigrateRecommendations then
		v10 = nil
	else
		v10 = React.useMemo(function()
			return Cryo.List.filter(Cryo.Dictionary.keys(v9.recommendationsDict), function(p2)
				return v9.friendsCarouselRecommendationIds[p2]
			end)
		end, { v9.recommendationsDict, v9.friendsCarouselRecommendationIds })
	end

	local v11

	if FFlagMigrateFriendshipStatusesSocialCarousel and not fFlagSocialCarouselMigrateRecommendations then
		v11 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local result = {}

				for k, v12 in v10 do
					local friendshipStatus = v5.GetFriendshipStatus(v12, v6)

					local v13 = if friendshipStatus then friendshipStatus.data(p2) else nil
					result[v12] = v13
				end

				return result
			end)
		end, { table.concat(v10, ",") })
	end

	local v12

	if FFlagMigrateFriendshipStatusesSocialCarousel and not fFlagSocialCarouselMigrateRecommendations then
		v12 = SignalsReact.useSignalState(v11)
	else
		v12 = nil
	end

	local v13

	if fFlagSocialCarouselMigrateRecommendations then
		v13 = nil
	else
		local useCallback = React.useCallback
		local function fn3(p2)
			local recommendation = v9.recommendationsDict[p2]

			local v14 = if FFlagMigrateFriendshipStatusesSocialCarousel then v12 and v12[p2] else v9.friendshipStatus[p2]

			local join = Cryo.Dictionary.join

			local v17 = if v14 then v14 == Enum.FriendStatus.Friend else false

			local v18 = if v14 then v14 == Enum.FriendStatus.FriendRequestSent else false
			return join({}, recommendation, {
				isFriendWithUser = v17,
				hasPendingFriendRequest = v18,
				canSendFriendRequest = not v14 or v14 == Enum.FriendStatus.NotFriend,
				hasIncomingFriendRequest = v9.hasIncomingFriendRequest[p2]
			})
		end

		local recommendationsDict = v9.recommendationsDict
		local v15 = if FFlagMigrateFriendshipStatusesSocialCarousel then v12 else v9.friendshipStatus
		v13 = useCallback(fn3, { recommendationsDict, v15, v9.hasIncomingFriendRequest })
	end

	local v14

	if fFlagSocialCarouselMigrateRecommendations then
		local v15 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local data = friendsRecommendationsStore.get().getFriendsRecommendations(
					dataSource.HomepageFriendsCarousel,
					v6
				).data(p2)
				local data2 = data and data.data or {}

				return Cryo.List.map(data2, function(data3)
					local id = data3.id
					local v16

					if FFlagMigrateFriendshipStatusesSocialCarousel then
						local friendshipStatus = v5.GetFriendshipStatus(id, v6)

						if friendshipStatus then
							v16 = friendshipStatus.data(p2)
						end
					else
						v16 = v9.friendshipStatus[id]
					end

					local v17 = {
						id = id,
						mutualFriendsCount = data3.contextProps.mutualFriendsCount,
						contextType = data3.contextProps.contextType,
						rank = data3.rank,
						hasIncomingFriendRequest = data3.hasIncomingFriendRequest,
						isFriendWithUser = 0,
						hasPendingFriendRequest = 0,
						canSendFriendRequest = 0
					}

					local v18 = if v16 then v16 == Enum.FriendStatus.Friend else false
					v17.isFriendWithUser = v18

					local v19 = if v16 then v16 == Enum.FriendStatus.FriendRequestSent else false
					v17.hasPendingFriendRequest = v19

					v17.canSendFriendRequest = not v16 or v16 == Enum.FriendStatus.NotFriend
					return v17
				end)
			end)
		end, FFlagMigrateFriendshipStatusesSocialCarousel and {} or { v9.friendshipStatus })

		v14 = SignalsReact.useSignalState(v15)
	end

	local v15

	if not fFlagSocialCarouselMigrateRecommendations then
		v15 = React.useMemo(function()
			return Cryo.List.sort(Cryo.List.map(v10, v13), fn)
		end, { v10, v13 })
	end

	if fFlagSocialCarouselMigrateRecommendations then
		v15 = v14
	end

	return v15
end
