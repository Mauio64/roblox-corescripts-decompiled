local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local TextKeys = require(ParentParent.Common.TextKeys)
local FriendshipOriginSourceType = dependencies.NetworkingFriendsEnums.FriendshipOriginSourceType
local SocialCommon = require(ParentParentParent.SocialCommon)
local Images = dependencies.UIBlox.App.ImageSet.Images
local React = dependencies.React
local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector
local NetworkingFriends = dependencies.NetworkingFriends
local NetworkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local RoduxFriends = dependencies.RoduxFriends
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local EventNames = require(ParentParent.Analytics).EventNames
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local getFFlagPYMKDisableButtonsOnFetch = require(ParentParent.Flags.getFFlagPYMKDisableButtonsOnFetch)
local FriendRequestNicknamesIXP = require(ParentParentParent.FriendRequestNicknames).FriendRequestNicknamesIXP
local AppPage = require(ParentParentParent.RobloxAppEnums).AppPage
local NavigateDown = require(ParentParentParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ParentParentParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v23 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local FocusNavigationEventNameEnum = require(ParentParentParent.FocusNavigationUtils).FocusNavigationEventNameEnum

require(ParentParentParent.UserList)

local FFlagHomepagePYMKPresenceAnalytics = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKPresenceAnalytics
local FFlagHomepagePYMKUseHorizontalUserList = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKUseHorizontalUserList

local function usePYMKCarouselUserButtons(t1: {[any]: any}) -- line: 64
	-- upvalues: useDispatch (copy), useSelector (copy), RoduxFriends (copy), getDeepValue (copy), FriendRequestNicknamesIXP (copy), getFFlagPYMKDisableButtonsOnFetch (copy), NetworkingFriends (copy), NetworkStatus (copy), React (copy), Images (copy), FFlagHomepagePYMKUseHorizontalUserList (copy), EventNames (copy), FFlagHomepagePYMKPresenceAnalytics (copy), TextKeys (copy), FocusNavigationEventNameEnum (copy), HttpService (copy), ContextualInfoTypes (copy), FriendshipOriginSourceType (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateDown (copy)
	local str = tostring(t1.userId)
	local v33 = useDispatch()
	local v34 = useSelector(function(p1) -- line: 68
		return (tostring(p1.LocalUserId))
	end)
	local v35 = useSelector(function(p2) -- line: 71
		-- upvalues: RoduxFriends (copy), str (copy)
		return RoduxFriends.Selectors.selectFriendshipStatusesByUserIds(p2)({ str })[str] or nil
	end)
	local v36 = useSelector(function(p3) -- line: 75
		-- upvalues: RoduxFriends (copy), v34 (copy), str (copy)
		return RoduxFriends.Selectors.selectRecommendationsForUserId(p3)(v34)[str] or {}
	end)
	local v37 = useSelector(function(p4) -- line: 79
		-- upvalues: getDeepValue (copy), str (copy)
		return getDeepValue(p4, string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", str)) or false
	end)
	local v38 = FriendRequestNicknamesIXP.useFriendRequestNicknames()
	local v39 = if not getFFlagPYMKDisableButtonsOnFetch() then nil else useSelector(function(p5) -- line: 89
		-- upvalues: NetworkingFriends (copy), str (copy), NetworkStatus (copy)
		local t2 = {}
		local RequestFriendshipFromUserId = NetworkingFriends.RequestFriendshipFromUserId
		local v48 = str

		t2.RequestFriendshipFromUserId = RequestFriendshipFromUserId.getStatus(p5, v48) == NetworkStatus.Fetching

		local AcceptFriendRequestFromUserId = NetworkingFriends.AcceptFriendRequestFromUserId
		local v50 = str

		t2.AcceptFriendRequestFromUserId = AcceptFriendRequestFromUserId.getStatus(p5, v50) == NetworkStatus.Fetching

		return t2
	end)
	local v40 = React.useMemo(function() -- line: 106
		-- upvalues: v35 (copy), Images (copy), FFlagHomepagePYMKUseHorizontalUserList (copy), v37 (copy), getFFlagPYMKDisableButtonsOnFetch (copy), v39 (copy), t1 (copy), EventNames (copy), v36 (copy), str (copy), FFlagHomepagePYMKPresenceAnalytics (copy), v33 (copy), NetworkingFriends (copy), v34 (copy), TextKeys (copy), FocusNavigationEventNameEnum (copy), HttpService (copy), ContextualInfoTypes (copy), FriendshipOriginSourceType (copy), FriendRequestNicknamesIXP (copy), v38 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateDown (copy)
		if v35 == Enum.FriendStatus.FriendRequestSent then
			return {{
				isSecondary = true,
				isDisabled = true,
				focusEvent = nil,
				icon = Images["icons/actions/friends/friendpending"],
				onActivated = if not FFlagHomepagePYMKUseHorizontalUserList then nil else function() -- line: 113
				end,
				isLoading = not FFlagHomepagePYMKUseHorizontalUserList and nil,
				buttonType = if not FFlagHomepagePYMKUseHorizontalUserList then nil else "Pending"
			}}
		end

		if v37 then
			return {{
				isSecondary = false,
				icon = Images["icons/actions/friends/friendAdd"],
				isDisabled = not not getFFlagPYMKDisableButtonsOnFetch() and (not not v39 and v39.AcceptFriendRequestFromUserId),
				onActivated = function() -- line: 127
					-- upvalues: t1 (copy), EventNames (copy), v36 (copy), str (copy), FFlagHomepagePYMKPresenceAnalytics (copy), v33 (copy), NetworkingFriends (copy), v34 (copy), TextKeys (copy)
					t1.fireAnalyticsEvent(EventNames.AcceptFriendship, {
						recommendationContextType = v36.contextType,
						requestedId = str,
						recommendationRank = v36.rank,
						absolutePosition = t1.absolutePosition,
						presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else t1.userPresenceType
					})
					v33(NetworkingFriends.AcceptFriendRequestFromUserId.API({
						currentUserId = v34,
						targetUserId = str
					})):andThen(function() -- line: 139
						-- upvalues: t1 (copy), TextKeys (copy)
						t1.showToast(TextKeys.ConnectionAddedToast)
					end):catch(function() -- line: 142
						-- upvalues: t1 (copy), TextKeys (copy)
						t1.showToast(TextKeys.SomethingIsWrongToast)
					end)
				end,
				isLoading = if not FFlagHomepagePYMKUseHorizontalUserList then nil else not not v39 and v39.AcceptFriendRequestFromUserId,
				buttonType = if not FFlagHomepagePYMKUseHorizontalUserList then nil else "Accept",
				focusEvent = if not FFlagHomepagePYMKUseHorizontalUserList then nil else FocusNavigationEventNameEnum.HoldToAcceptFriendRequest
			}}
		end

		if not v35 or v35 == Enum.FriendStatus.NotFriend then
			return {{
				isSecondary = false,
				icon = Images["icons/actions/friends/friendAdd"],
				isDisabled = not not getFFlagPYMKDisableButtonsOnFetch() and (not not v39 and v39.RequestFriendshipFromUserId),
				onActivated = function() -- line: 163
					-- upvalues: t1 (copy), EventNames (copy), v36 (copy), str (copy), FFlagHomepagePYMKPresenceAnalytics (copy), HttpService (copy), NetworkingFriends (copy), v34 (copy), ContextualInfoTypes (copy), FriendshipOriginSourceType (copy), FriendRequestNicknamesIXP (copy), v38 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), v33 (copy), NavigateDown (copy), TextKeys (copy)
					t1.fireAnalyticsEvent(EventNames.RequestFriendship, {
						recommendationContextType = v36.contextType,
						requestedId = str,
						contactId = t1.contactId,
						recommendationRank = v36.rank,
						absolutePosition = t1.absolutePosition,
						positionInRow = t1.absolutePosition,
						presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else t1.userPresenceType,
						interactionUuid = HttpService:GenerateGUID(false)
					})

					local v51 = if not t1.contactId then NetworkingFriends.RequestFriendshipFromUserId.API({
						currentUserId = v34,
						targetUserId = str,
						friendshipOriginSourceType = FriendshipOriginSourceType.FriendRecommendations.rawValue()
					}) else NetworkingFriends.RequestFriendshipFromContactId.API({
						currentUserId = v34,
						targetUserId = str,
						contactId = t1.contactId,
						contextType = ContextualInfoTypes.Contacts,
						friendshipOriginSourceType = FriendshipOriginSourceType.FriendRecommendations.rawValue()
					})

					if FriendRequestNicknamesIXP.FFlagFriendRequestNicknames and (v38 and not t1.contactId) then
						local t3 = {
							name = AppPage.SetNicknameModal,
							extraProps = {
								friendRequestParams = {
									targetUserId = str,
									source = FriendshipOriginSourceType.FriendRecommendations.rawValue()
								}
							}
						}

						if FFlagSignalsNavP3Dispatch then
							v23.down(v23.fromLegacyPage(t3))

							return
						end

						v33(NavigateDown(t3))

						return
					end

					v33(v51):andThen(function() -- line: 209
						-- upvalues: t1 (copy), TextKeys (copy)
						t1.showToast(TextKeys.ConnectionRequestSentToast)
					end):catch(function() -- line: 212
						-- upvalues: t1 (copy), TextKeys (copy)
						t1.showToast(TextKeys.SomethingIsWrongToast)
					end)
				end,
				isLoading = if not FFlagHomepagePYMKUseHorizontalUserList then nil else not not v39 and v39.RequestFriendshipFromUserId,
				buttonType = if not FFlagHomepagePYMKUseHorizontalUserList then nil else "Add",
				focusEvent = if not FFlagHomepagePYMKUseHorizontalUserList then nil else FocusNavigationEventNameEnum.HoldToAddFriend
			}}
		end

		return {}
	end, {
		v35,
		str,
		v38,
		v37,
		v36,
		v34,
		v33,
		if not FFlagHomepagePYMKPresenceAnalytics then nil else t1.userPresenceType
	})

	return React.useCallback(function() -- line: 242
		-- upvalues: v40 (copy)
		return v40
	end, { v40 })
end

return usePYMKCarouselUserButtons
