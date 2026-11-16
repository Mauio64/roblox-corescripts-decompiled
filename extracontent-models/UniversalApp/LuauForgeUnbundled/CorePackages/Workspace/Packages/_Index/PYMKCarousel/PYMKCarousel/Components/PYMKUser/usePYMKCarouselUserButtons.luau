local HttpService = game:GetService("HttpService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/TextKeys")
local friendshipOriginSourceType = dependencies.NetworkingFriendsEnums.FriendshipOriginSourceType
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialCommon")

local images = dependencies.UIBlox.App.ImageSet.Images
local react = dependencies.React

local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector

local networkingFriends = dependencies.NetworkingFriends
local networkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus

local roduxFriends = dependencies.RoduxFriends
local recommendationContextType = roduxFriends.Enums.RecommendationContextType
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local eventNames = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics").EventNames
local contextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local getFFlagPYMKDisableButtonsOnFetch = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/getFFlagPYMKDisableButtonsOnFetch")
local FFlagMigrateFriendshipStatusesPYMK = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagMigrateFriendshipStatusesPYMK")
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppEnableSduiHomePage
local useGetFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/FriendsHydrationReact").useGetFriendshipStatus
local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/DataHydration").Friends.FriendsStore.get()
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/FocusNavigationUtils").FocusNavigationEventNameEnum

require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList")

local v6 = { skipFetch = true }
local v7 = { isContact = true }

local function usePYMKCarouselUserButtons(data)
	local userId = tostring(data.userId)
	local v8 = useDispatch()

	local v9 = useSelector(function(p2)
		return (tostring(p2.LocalUserId))
	end)
	local v10

	if FFlagMigrateFriendshipStatusesPYMK then
		v10 = useGetFriendshipStatus(userId, v6)
	else
		v10 = useSelector(function(p2)
			return roduxFriends.Selectors.selectFriendshipStatusesByUserIds(p2)({ userId })[userId] or nil
		end)
	end

	local v11, v12

	if fFlagLuaAppEnableSduiHomePage then
		v11 = data.recommendation or {}

		v12 = data.recommendation and data.recommendation.hasIncomingFriendRequest == true
	else
		v11 = useSelector(function(p2)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p2)(v9)[userId] or {}
		end)

		v12 = useSelector(function(p2)
			return getDeepValue(
					p2,
					string.format(
						"PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s",
						userId
					)
				)
				or false
		end)
	end

	local v13

	if getFFlagPYMKDisableButtonsOnFetch() then
		v13 = useSelector(function(p2)
			return {
				RequestFriendshipFromUserId = networkingFriends.RequestFriendshipFromUserId.getStatus(
					p2,
					userId
				) == networkStatus.Fetching,
				AcceptFriendRequestFromUserId = networkingFriends.AcceptFriendRequestFromUserId.getStatus(
					p2,
					userId
				) == networkStatus.Fetching
			}
		end)
	else
		v13 = nil
	end

	local v14 = react.useMemo(function()
		if v10 == Enum.FriendStatus.FriendRequestSent then
			return {
				{
					icon = images["icons/actions/friends/friendpending"],
					isSecondary = true,
					isDisabled = true,
					onActivated = function() end,
					isLoading = false,
					buttonType = "Pending",
					focusEvent = nil
				}
			}
		end

		if v12 or FFlagMigrateFriendshipStatusesPYMK and v10 == Enum.FriendStatus.FriendRequestReceived then
			local v16 = {
				icon = images["icons/actions/friends/friendAdd"],
				isSecondary = false,
				isDisabled = 0,
				onActivated = 0,
				isLoading = 0,
				buttonType = "Accept",
				focusEvent = 0
			}

			local v17 = if getFFlagPYMKDisableButtonsOnFetch() and v13 then v13.AcceptFriendRequestFromUserId else false
			v16.isDisabled = v17

			function v16.onActivated()
				data.fireAnalyticsEvent(eventNames.AcceptFriendship, {
					recommendationContextType = v11.contextType,
					requestedId = userId,
					recommendationRank = v11.rank,
					absolutePosition = data.absolutePosition,
					presence = data.userPresenceType
				})
				local v18

				if FFlagMigrateFriendshipStatusesPYMK then
					v18 = v5.AcceptFriendRequest(userId)
				else
					v18 = v8(networkingFriends.AcceptFriendRequestFromUserId.API({
						currentUserId = v9,
						targetUserId = userId
					}))
				end

				v18:andThen(function()
					data.showToast(TextKeys.ConnectionAddedToast)
				end):catch(function()
					data.showToast(TextKeys.SomethingIsWrongToast)
				end)
			end
			local v18 = if v13 then v13.AcceptFriendRequestFromUserId else false
			v16.isLoading = v18

			v16.focusEvent = focusNavigationEventNameEnum.HoldToAcceptFriendRequest
			return { v16 }
		else
			if v10 and v10 ~= Enum.FriendStatus.NotFriend then
				return {}
			end

			local v16 = {
				icon = images["icons/actions/friends/friendAdd"],
				isSecondary = false,
				isDisabled = 0,
				onActivated = 0,
				isLoading = 0,
				buttonType = "Add",
				focusEvent = 0
			}

			local v17 = if getFFlagPYMKDisableButtonsOnFetch() and v13 then v13.RequestFriendshipFromUserId else false
			v16.isDisabled = v17

			function v16.onActivated()
				data.fireAnalyticsEvent(eventNames.RequestFriendship, {
					recommendationContextType = v11.contextType,
					requestedId = userId,
					contactId = data.contactId,
					recommendationRank = v11.rank,
					absolutePosition = data.absolutePosition,
					positionInRow = data.absolutePosition,
					presence = data.userPresenceType,
					interactionUuid = HttpService:GenerateGUID(false)
				})
				local v18

				if not FFlagMigrateFriendshipStatusesPYMK then
					if data.contactId then
						v18 = networkingFriends.RequestFriendshipFromContactId.API({
							currentUserId = v9,
							targetUserId = userId,
							contactId = data.contactId,
							contextType = contextualInfoTypes.Contacts,
							friendshipOriginSourceType = friendshipOriginSourceType.FriendRecommendations.rawValue()
						})
					else
						v18 = networkingFriends.RequestFriendshipFromUserId.API({
							currentUserId = v9,
							targetUserId = userId,
							friendshipOriginSourceType = friendshipOriginSourceType.FriendRecommendations.rawValue()
						})
					end
				end

				local v19

				if FFlagMigrateFriendshipStatusesPYMK then
					if data.contactId then
						local requestFriendship = v5.RequestFriendship
						local contactId = data.contactId
						local rawValue = friendshipOriginSourceType.FriendRecommendations.rawValue()
						local v21 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
						v19 = requestFriendship(contactId, rawValue, v7, v21)
					else
						local requestFriendship = v5.RequestFriendship

						local rawValue = friendshipOriginSourceType.FriendRecommendations.rawValue()
						local v22 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
						v19 = requestFriendship(userId, rawValue, nil, v22)
					end
				else
					v19 = v8(v18)
				end

				v19:andThen(function()
					data.showToast(TextKeys.ConnectionRequestSentToast)
				end):catch(function()
					data.showToast(TextKeys.SomethingIsWrongToast)
				end)
			end
			local v18 = if v13 then v13.RequestFriendshipFromUserId else false
			v16.isLoading = v18

			v16.focusEvent = focusNavigationEventNameEnum.HoldToAddFriend
			return { v16 }
		end
	end, { v10, userId, v12, v11, v9, v8, data.userPresenceType })

	return react.useCallback(function()
		return v14
	end, { v14 })
end

return usePYMKCarouselUserButtons
