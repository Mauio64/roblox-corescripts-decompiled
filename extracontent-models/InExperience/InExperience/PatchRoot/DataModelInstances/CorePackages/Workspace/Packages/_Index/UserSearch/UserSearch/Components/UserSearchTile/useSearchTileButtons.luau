local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local Dash = require(parent.Dash)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

require(UserSearch.Common.LocalTypes)
local useRelationshipSelector = require(script.Parent.useRelationshipSelector)
local EventNames = require(UserSearch.Analytics.EventNames)
local RoactUtils = require(parent.RoactUtils)
local FriendsNetworking = require(UserSearch.Networking.FriendsNetworking)
local FriendsNetworking2 = require(parent.FriendsNetworking)
local Enums = FriendsNetworking2.Enums
local SocialExperienceJoin = require(parent.SocialExperienceJoin)
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local PresenceHelpers = require(UserSearch.Utils.PresenceHelpers)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local SharedFlags = require(parent.SharedFlags)
local FFlagUserSearchAddFocusActionsSupport = SharedFlags.FFlagUserSearchAddFocusActionsSupport
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiUserSearchTile = SharedFlags2.FFlagSduiUserSearchTile

local FFlagUserSearchHideFriendActionsForBlockedUsers = require(UserSearch.Flags.FFlagUserSearchHideFriendActionsForBlockedUsers)
local FFlagMigrateFriendshipStatusesUserSearch = require(UserSearch.Flags.FFlagMigrateFriendshipStatusesUserSearch)
local FFlagUserSearchJoinPassStorePresence = require(UserSearch.Flags.FFlagUserSearchJoinPassStorePresence)
local useIsUserBlocked

if FFlagUserSearchHideFriendActionsForBlockedUsers then
	useIsUserBlocked = require(script.Parent.useIsUserBlocked)
else
	useIsUserBlocked = nil
end

local friendsStoreChallengeNetwork = require(UserSearch.Networking.friendsStoreChallengeNetwork)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags3.FFlagEnableFriendsStoreChallengeInterceptor
local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()
local DataHydration2 = require(parent.DataHydration)
local enums = DataHydration2.Friends.Enums

local v2 = FFlagMigrateFriendshipStatusesUserSearch or FFlagSduiUserSearchTile

return function(data, callback)
	local currentUserId = useLocalUserId()
	local v3 = useDispatch()
	local v4 = useRelationshipSelector(data.userId)
	local v5 = useStyle()
	local v6

	if FFlagUserSearchHideFriendActionsForBlockedUsers then
		v6 = useIsUserBlocked(data.userId)
	else
		v6 = false
	end

	local userId = data.userId
	local v7 = {
		analyticProps = { context = Contexts.PlayerSearch, subpage = data.subpage },
		presence = 0
	}
	local presence

	if FFlagUserSearchJoinPassStorePresence then
		presence = data.userPresence
	end

	v7.presence = presence
	local v8 = useJoinUserInExperience(userId, v7)
	local icon

	if data.shouldUseCompactTiles then
		icon = Images["icons/common/plus_small"]
	else
		icon = Images["icons/actions/friends/friendAdd"]
	end

	local icon2

	if data.shouldUseCompactTiles then
		icon2 = Images["icons/common/plus_small"]
	else
		icon2 = Images["icons/actions/friends/friendpending"]
	end

	local iconscommonplay = Images["icons/common/play"]

	if FFlagUserSearchHideFriendActionsForBlockedUsers and v6 then
		return nil
	end

	if
		v4.status == Enum.FriendStatus.Friend
		and data.shouldUseCompactTiles
		and PresenceHelpers.isUserInGame(data.userPresence)
	then
		local v9 = {
			icon = iconscommonplay,
			isSecondary = false,
			isDisabled = v8.isLoading,
			onActivated = function()
				v8.joinExperience()
			end,
			imageColor = v5.Theme.ContextualPrimaryContent.Color,
			backgroundColor = v5.Theme.OnlineStatus.Color,
			focusEventName = 0
		}
		local focusEventName

		if FFlagUserSearchAddFocusActionsSupport and data.shouldAddFocusEventName then
			focusEventName = FocusNavigationEventNameEnum.HoldToPlay
		end

		v9.focusEventName = focusEventName
		return { v9 }
	end

	if v4.isMyself or v4.status == Enum.FriendStatus.Friend then
		return nil
	end

	if v4.status == Enum.FriendStatus.FriendRequestReceived then
		local focusEventName

		if FFlagUserSearchAddFocusActionsSupport and data.shouldAddFocusEventName then
			focusEventName = FocusNavigationEventNameEnum.HoldToAcceptFriendRequest
		end

		return {
			{
				icon = icon,
				isSecondary = false,
				isDisabled = false,
				focusEventName = focusEventName,
				onActivated = function()
					local v9

					if v2 then
						v9 = v.AcceptFriendRequest(data.userId)
					else
						v9 = v3(FriendsNetworking.AcceptFriendRequestFromUserId.API({
							targetUserId = data.userId,
							currentUserId = currentUserId
						}))
					end

					v9:andThen(function()
						v3(SetCurrentToastMessage({
							toastMessage = "Feature.Friends.Action.FriendAdded"
						}))
					end):catch(function()
						v3(SetCurrentToastMessage({
							toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
						}))
					end)

					if callback then
						callback(EventNames.PlayerFriendAccept)
					end
				end
			}
		}
	else
		if v4.status == Enum.FriendStatus.FriendRequestSent then
			return {
				{ icon = icon2, isSecondary = false, isDisabled = true, onActivated = Dash.noop() }
			}
		end

		if v4.status and v4.status ~= Enum.FriendStatus.NotFriend then
			return nil
		end

		local focusEventName

		if FFlagUserSearchAddFocusActionsSupport and data.shouldAddFocusEventName then
			focusEventName = FocusNavigationEventNameEnum.HoldToAddFriend
		end

		return {
			{
				icon = icon,
				isSecondary = false,
				isDisabled = false,
				focusEventName = focusEventName,
				onActivated = function()
					local v9

					if v2 then
						local requestFriendship = v.RequestFriendship
						local userId2 = data.userId
						local playerSearch = enums.FriendshipOriginSourceType.PlayerSearch
						local v10

						if FFlagEnableFriendsStoreChallengeInterceptor then
							v10 = friendsStoreChallengeNetwork
						end

						v9 = requestFriendship(userId2, playerSearch, nil, v10)
					else
						v9 = v3(FriendsNetworking.RequestFriendshipFromUserId.API({
							targetUserId = data.userId,
							currentUserId = currentUserId,
							friendshipOriginSourceType = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()
						}))
					end

					v9:andThen(function()
						v3(SetCurrentToastMessage({
							toastMessage = "Feature.Friends.Action.FriendRequestSent"
						}))
					end):catch(function()
						v3(SetCurrentToastMessage({
							toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
						}))
					end)

					if callback then
						callback(EventNames.PlayerFriendRequest)
					end
				end
			}
		}
	end
end
