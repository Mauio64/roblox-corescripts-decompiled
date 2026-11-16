local HttpService = game:GetService("HttpService")
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local TextKeys = require(parent.Common.TextKeys)
local friendshipOriginSourceType = dependencies.NetworkingFriendsEnums.FriendshipOriginSourceType
local SocialCommon = require(parent2.SocialCommon)

local images = dependencies.UIBlox.App.ImageSet.Images
local react = dependencies.React

local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector

local networkingFriends = dependencies.NetworkingFriends
local networkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus

local roduxFriends = dependencies.RoduxFriends
local recommendationContextType = roduxFriends.Enums.RecommendationContextType
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local Analytics = require(parent.Analytics)
local EventNames = Analytics.EventNames
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
require(parent.Common.DirectRecommendationTypes)

local getFFlagPYMKDisableButtonsOnFetch = require(parent.Flags.getFFlagPYMKDisableButtonsOnFetch)
local FFlagMigrateFriendshipStatusesPYMK = require(parent.Flags.FFlagMigrateFriendshipStatusesPYMK)
local SharedFlags = require(parent2.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FriendsHydrationReact = require(parent2.FriendsHydrationReact)
local useGetFriendshipStatus = FriendsHydrationReact.useGetFriendshipStatus
local friendsStoreChallengeNetwork = require(parent.friendsStoreChallengeNetwork)

local SharedFlags2 = require(parent2.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags2.FFlagEnableFriendsStoreChallengeInterceptor
local DataHydration = require(parent2.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()
local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

require(parent2.UserList)

local v2 = { skipFetch = true }
local v3 = { isContact = true }

local function fn(p, p2, userId: string): boolean -- 2 equivalent calls inferred from this helper
	return p2.getStatus(p, userId) == networkStatus.Fetching
end

local function usePYMKCarouselUserButtons(data)
	local userId = tostring(data.userId)
	local v4 = useDispatch()

	local currentUserId = useSelector(function(p)
		return (tostring(p.LocalUserId))
	end)
	local v5

	if FFlagMigrateFriendshipStatusesPYMK then
		v5 = useGetFriendshipStatus(userId, v2)
	else
		v5 = useSelector(function(p)
			return roduxFriends.Selectors.selectFriendshipStatusesByUserIds(p)({ userId })[userId] or nil
		end)
	end

	local v6, v7

	if FFlagLuaAppEnableSduiHomePage then
		v6 = data.recommendation or {}

		v7 = data.recommendation and data.recommendation.hasIncomingFriendRequest == true
	else
		v6 = useSelector(function(p)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p)(currentUserId)[userId] or {}
		end)

		v7 = useSelector(function(p)
			return getDeepValue(
					p,
					string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", userId)
				)
				or false
		end)
	end

	local v8

	if getFFlagPYMKDisableButtonsOnFetch() then
		v8 = useSelector(function(p)
			return {
				RequestFriendshipFromUserId = fn(p, networkingFriends.RequestFriendshipFromUserId, userId), -- inferred equivalent call
				AcceptFriendRequestFromUserId = fn(p, networkingFriends.AcceptFriendRequestFromUserId, userId) -- inferred equivalent call
			}
		end)
	else
		v8 = nil
	end

	local v9 = react.useMemo(function()
		if v5 == Enum.FriendStatus.FriendRequestSent then
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

		if v7 or FFlagMigrateFriendshipStatusesPYMK and v5 == Enum.FriendStatus.FriendRequestReceived then
			local v9 = {
				icon = images["icons/actions/friends/friendAdd"],
				isSecondary = false,
				isDisabled = 0,
				onActivated = 0,
				isLoading = 0,
				buttonType = "Accept",
				focusEvent = 0
			}
			local isDisabled

			if getFFlagPYMKDisableButtonsOnFetch() and v8 then
				isDisabled = v8.AcceptFriendRequestFromUserId
			else
				isDisabled = false
			end

			v9.isDisabled = isDisabled

			function v9.onActivated()
				data.fireAnalyticsEvent(EventNames.AcceptFriendship, {
					recommendationContextType = v6.contextType,
					requestedId = userId,
					recommendationRank = v6.rank,
					absolutePosition = data.absolutePosition,
					presence = data.userPresenceType
				})
				local v10

				if FFlagMigrateFriendshipStatusesPYMK then
					v10 = v.AcceptFriendRequest(userId)
				else
					v10 = v4(networkingFriends.AcceptFriendRequestFromUserId.API({
						currentUserId = currentUserId,
						targetUserId = userId
					}))
				end

				v10:andThen(function()
					data.showToast(TextKeys.ConnectionAddedToast)
				end):catch(function()
					data.showToast(TextKeys.SomethingIsWrongToast)
				end)
			end

			local isLoading

			if v8 then
				isLoading = v8.AcceptFriendRequestFromUserId
			else
				isLoading = false
			end

			v9.isLoading = isLoading

			v9.focusEvent = FocusNavigationEventNameEnum.HoldToAcceptFriendRequest
			return { v9 }
		else
			if v5 and v5 ~= Enum.FriendStatus.NotFriend then
				return {}
			end

			local v9 = {
				icon = images["icons/actions/friends/friendAdd"],
				isSecondary = false,
				isDisabled = 0,
				onActivated = 0,
				isLoading = 0,
				buttonType = "Add",
				focusEvent = 0
			}
			local isDisabled

			if getFFlagPYMKDisableButtonsOnFetch() and v8 then
				isDisabled = v8.RequestFriendshipFromUserId
			else
				isDisabled = false
			end

			v9.isDisabled = isDisabled

			function v9.onActivated()
				data.fireAnalyticsEvent(EventNames.RequestFriendship, {
					recommendationContextType = v6.contextType,
					requestedId = userId,
					contactId = data.contactId,
					recommendationRank = v6.rank,
					absolutePosition = data.absolutePosition,
					positionInRow = data.absolutePosition,
					presence = data.userPresenceType,
					interactionUuid = HttpService:GenerateGUID(false)
				})
				local v10

				if not FFlagMigrateFriendshipStatusesPYMK then
					if data.contactId then
						v10 = networkingFriends.RequestFriendshipFromContactId.API({
							currentUserId = currentUserId,
							targetUserId = userId,
							contactId = data.contactId,
							contextType = ContextualInfoTypes.Contacts,
							friendshipOriginSourceType = friendshipOriginSourceType.FriendRecommendations.rawValue()
						})
					else
						v10 = networkingFriends.RequestFriendshipFromUserId.API({
							currentUserId = currentUserId,
							targetUserId = userId,
							friendshipOriginSourceType = friendshipOriginSourceType.FriendRecommendations.rawValue()
						})
					end
				end

				local v11

				if FFlagMigrateFriendshipStatusesPYMK then
					if data.contactId then
						local requestFriendship = v.RequestFriendship
						local contactId = data.contactId
						local rawValue = friendshipOriginSourceType.FriendRecommendations.rawValue()
						local v12

						if FFlagEnableFriendsStoreChallengeInterceptor then
							v12 = friendsStoreChallengeNetwork
						end

						v11 = requestFriendship(contactId, rawValue, v3, v12)
					else
						local requestFriendship = v.RequestFriendship

						local rawValue = friendshipOriginSourceType.FriendRecommendations.rawValue()
						local v12

						if FFlagEnableFriendsStoreChallengeInterceptor then
							v12 = friendsStoreChallengeNetwork
						end

						v11 = requestFriendship(userId, rawValue, nil, v12)
					end
				else
					v11 = v4(v10)
				end

				v11:andThen(function()
					data.showToast(TextKeys.ConnectionRequestSentToast)
				end):catch(function()
					data.showToast(TextKeys.SomethingIsWrongToast)
				end)
			end

			local isLoading

			if v8 then
				isLoading = v8.RequestFriendshipFromUserId
			else
				isLoading = false
			end

			v9.isLoading = isLoading

			v9.focusEvent = FocusNavigationEventNameEnum.HoldToAddFriend
			return { v9 }
		end
	end, { v5, userId, v7, v6, currentUserId, v4, data.userPresenceType })

	return react.useCallback(function()
		return v9
	end, { v9 })
end

return usePYMKCarouselUserButtons
