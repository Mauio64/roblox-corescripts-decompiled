local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Dash")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UIBlox")
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/LocalTypes")
local useRelationshipSelector = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchTile/useRelationshipSelector")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics/EventNames")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RoactUtils")
local FriendsNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Networking/FriendsNetworking")
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/NetworkingFriends").Enums
local useJoinUserInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialExperienceJoin").useJoinUserInExperience
local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialLuaAnalytics").Analytics.Enums.Contexts
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RobloxAppHooks").useLocalUserId
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/ToastRodux").Actions.SetCurrentToastMessage
local PresenceHelpers = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Utils/PresenceHelpers")

local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/FocusNavigationUtils").FocusNavigationEventNameEnum

local fFlagUserSearchAddFocusActionsSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchAddFocusActionsSupport
local fFlagSduiUserSearchTile = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagSduiUserSearchTile

local FFlagUserSearchHideFriendActionsForBlockedUsers = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchHideFriendActionsForBlockedUsers")
local FFlagMigrateFriendshipStatusesUserSearch = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagMigrateFriendshipStatusesUserSearch")
local FFlagUserSearchJoinPassStorePresence = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchJoinPassStorePresence")

local v5 = if FFlagUserSearchHideFriendActionsForBlockedUsers then require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchTile/useIsUserBlocked") else nil

local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Networking/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/DataHydration").Friends.FriendsStore.get()
local enums2 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/DataHydration").Friends.Enums

local v7 = FFlagMigrateFriendshipStatusesUserSearch or fFlagSduiUserSearchTile

return function(data, callback)
	local v8 = useLocalUserId()
	local v9 = useDispatch()
	local v10 = useRelationshipSelector(data.userId)
	local v11 = useStyle()
	local v12 = if FFlagUserSearchHideFriendActionsForBlockedUsers then v5(data.userId) else false

	local userId = data.userId
	local v14 = {
		analyticProps = { context = contexts.PlayerSearch, subpage = data.subpage },
		presence = 0
	}

	local v15 = if FFlagUserSearchJoinPassStorePresence then data.userPresence else nil
	v14.presence = v15
	local v16 = useJoinUserInExperience(userId, v14)
	local v17

	if data.shouldUseCompactTiles then
		v17 = images["icons/common/plus_small"]
	else
		v17 = images["icons/actions/friends/friendAdd"]
	end

	local v18

	if data.shouldUseCompactTiles then
		v18 = images["icons/common/plus_small"]
	else
		v18 = images["icons/actions/friends/friendpending"]
	end

	local iconscommonplay = images["icons/common/play"]

	if FFlagUserSearchHideFriendActionsForBlockedUsers and v12 then
		return nil
	end

	if
		v10.status == Enum.FriendStatus.Friend
		and data.shouldUseCompactTiles
		and PresenceHelpers.isUserInGame(data.userPresence)
	then
		local v20 = {
			icon = iconscommonplay,
			isSecondary = false,
			isDisabled = v16.isLoading,
			onActivated = function()
				v16.joinExperience()
			end,
			imageColor = v11.Theme.ContextualPrimaryContent.Color,
			backgroundColor = v11.Theme.OnlineStatus.Color,
			focusEventName = 0
		}
		local v21 = if fFlagUserSearchAddFocusActionsSupport and data.shouldAddFocusEventName then focusNavigationEventNameEnum.HoldToPlay else nil
		v20.focusEventName = v21
		return { v20 }
	end

	if v10.isMyself or v10.status == Enum.FriendStatus.Friend then
		return nil
	end

	if v10.status == Enum.FriendStatus.FriendRequestReceived then
		local v21 = if fFlagUserSearchAddFocusActionsSupport and data.shouldAddFocusEventName then focusNavigationEventNameEnum.HoldToAcceptFriendRequest else nil
		return {
			{
				icon = v17,
				isSecondary = false,
				isDisabled = false,
				focusEventName = v21,
				onActivated = function()
					local v22

					if v7 then
						v22 = v6.AcceptFriendRequest(data.userId)
					else
						v22 = v9(FriendsNetworking.AcceptFriendRequestFromUserId.API({
							targetUserId = data.userId,
							currentUserId = v8
						}))
					end

					v22:andThen(function()
						v9(setCurrentToastMessage({
							toastMessage = "Feature.Friends.Action.FriendAdded"
						}))
					end):catch(function()
						v9(setCurrentToastMessage({
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
		if v10.status == Enum.FriendStatus.FriendRequestSent then
			return {
				{
					icon = v18,
					isSecondary = false,
					isDisabled = true,
					onActivated = Dash.noop()
				}
			}
		end

		if v10.status and v10.status ~= Enum.FriendStatus.NotFriend then
			return nil
		end

		local v21 = if fFlagUserSearchAddFocusActionsSupport and data.shouldAddFocusEventName then focusNavigationEventNameEnum.HoldToAddFriend else nil
		return {
			{
				icon = v17,
				isSecondary = false,
				isDisabled = false,
				focusEventName = v21,
				onActivated = function()
					local v22

					if v7 then
						local requestFriendship = v6.RequestFriendship
						local userId2 = data.userId
						local playerSearch = enums2.FriendshipOriginSourceType.PlayerSearch
						local v24 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
						v22 = requestFriendship(userId2, playerSearch, nil, v24)
					else
						v22 = v9(FriendsNetworking.RequestFriendshipFromUserId.API({
							targetUserId = data.userId,
							currentUserId = v8,
							friendshipOriginSourceType = enums.FriendshipOriginSourceType.PlayerSearch.rawValue()
						}))
					end

					v22:andThen(function()
						v9(setCurrentToastMessage({
							toastMessage = "Feature.Friends.Action.FriendRequestSent"
						}))
					end):catch(function()
						v9(setCurrentToastMessage({
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
