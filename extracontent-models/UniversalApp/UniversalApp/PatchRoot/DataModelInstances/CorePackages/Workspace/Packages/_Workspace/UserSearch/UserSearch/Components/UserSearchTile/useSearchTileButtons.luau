local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local Dash = require(UserSearchParent.Dash)
local UIBlox = require(UserSearchParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle

require(UserSearch.Common.LocalTypes)

local useRelationshipSelector = require(script.Parent.useRelationshipSelector)
local EventNames = require(UserSearch.Analytics.EventNames)
local AppPage = require(UserSearchParent.RobloxAppEnums).AppPage
local NavigateDown = require(UserSearchParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(UserSearchParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(UserSearchParent.RobloxAppNavigation).NavigationCommands
local RoactUtils = require(UserSearchParent.RoactUtils)
local FriendsNetworking = require(UserSearch.Networking.FriendsNetworking)
local Enums = require(UserSearchParent.FriendsNetworking).Enums
local useJoinUserInExperience = require(UserSearchParent.SocialExperienceJoin).useJoinUserInExperience
local Contexts = require(UserSearchParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalUserId = require(UserSearchParent.RobloxAppHooks).useLocalUserId
local SetCurrentToastMessage = require(UserSearchParent.ToastRodux).Actions.SetCurrentToastMessage
local PresenceHelpers = require(UserSearch.Utils.PresenceHelpers)
local FocusNavigationEventNameEnum = require(UserSearchParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local FriendRequestNicknamesIXP = require(UserSearchParent.FriendRequestNicknames).FriendRequestNicknamesIXP
local FFlagUserSearchAddFocusActionsSupport = require(UserSearchParent.SharedFlags).FFlagUserSearchAddFocusActionsSupport
local FFlagConnectionsToFriendsRename = require(UserSearchParent.SharedFlags).FFlagConnectionsToFriendsRename

return function(p1, p2: ((...any) -> ...any)?) -- line: 56
	-- upvalues: useLocalUserId (copy), useDispatch (copy), useRelationshipSelector (copy), FriendRequestNicknamesIXP (copy), useStyle (copy), useJoinUserInExperience (copy), Contexts (copy), Images (copy), PresenceHelpers (copy), FFlagUserSearchAddFocusActionsSupport (copy), FocusNavigationEventNameEnum (copy), FriendsNetworking (copy), SetCurrentToastMessage (copy), FFlagConnectionsToFriendsRename (copy), EventNames (copy), Dash (copy), AppPage (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy)
	local v28 = useLocalUserId()
	local v29 = useDispatch()
	local v30 = useRelationshipSelector(p1.userId)
	local v31 = FriendRequestNicknamesIXP.useFriendRequestNicknames()
	local v32 = useStyle()
	local v33 = useJoinUserInExperience(p1.userId, {
		analyticProps = {
			context = Contexts.PlayerSearch,
			subpage = p1.subpage
		}
	})
	local v34 = if not p1.shouldUseCompactTiles then Images["icons/actions/friends/friendAdd"] else Images["icons/common/plus_small"]
	local v35 = if not p1.shouldUseCompactTiles then Images["icons/actions/friends/friendpending"] else Images["icons/common/plus_small"]
	local v36 = Images["icons/common/play"]

	if v30.status == Enum.FriendStatus.Friend and (p1.shouldUseCompactTiles and PresenceHelpers.isUserInGame(p1.userPresence)) then
		return {{
			isSecondary = false,
			icon = v36,
			isDisabled = v33.isLoading,
			onActivated = function() -- line: 89
				-- upvalues: v33 (copy)
				v33.joinExperience()
			end,
			imageColor = v32.Theme.ContextualPrimaryContent.Color,
			backgroundColor = v32.Theme.OnlineStatus.Color,
			focusEventName = if not FFlagUserSearchAddFocusActionsSupport or not p1.shouldAddFocusEventName then nil else FocusNavigationEventNameEnum.HoldToPlay
		}}
	end

	if v30.isMyself or v30.status == Enum.FriendStatus.Friend then
		return nil
	end

	if v30.status == Enum.FriendStatus.FriendRequestReceived then
		return {{
			isSecondary = false,
			isDisabled = false,
			icon = v34,
			focusEventName = if not FFlagUserSearchAddFocusActionsSupport or not p1.shouldAddFocusEventName then nil else FocusNavigationEventNameEnum.HoldToAcceptFriendRequest,
			onActivated = function() -- line: 113
				-- upvalues: v29 (copy), FriendsNetworking (copy), p1 (copy), v28 (copy), SetCurrentToastMessage (copy), FFlagConnectionsToFriendsRename (copy), p2 (copy), EventNames (copy)
				v29(FriendsNetworking.AcceptFriendRequestFromUserId.API({
					targetUserId = p1.userId,
					currentUserId = v28
				})):andThen(function() -- line: 118
					-- upvalues: v29 (copy), SetCurrentToastMessage (copy), FFlagConnectionsToFriendsRename (copy)
					v29(SetCurrentToastMessage({
						toastMessage = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionAdded" or "Feature.Friends.Action.FriendAdded"
					}))
				end):catch(function() -- line: 125
					-- upvalues: v29 (copy), SetCurrentToastMessage (copy)
					v29(SetCurrentToastMessage({
						toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
					}))
				end)

				if p2 then
					p2(EventNames.PlayerFriendAccept)
				end
			end
		}}
	end

	if v30.status == Enum.FriendStatus.FriendRequestSent then
		return {{
			isSecondary = false,
			isDisabled = true,
			icon = v35,
			onActivated = Dash.noop()
		}}
	end

	if not v30.status or v30.status == Enum.FriendStatus.NotFriend then
		return {{
			isSecondary = false,
			isDisabled = false,
			icon = v34,
			focusEventName = if not FFlagUserSearchAddFocusActionsSupport or not p1.shouldAddFocusEventName then nil else FocusNavigationEventNameEnum.HoldToAcceptFriendRequest,
			onActivated = function() -- line: 154
				-- upvalues: FriendRequestNicknamesIXP (copy), v31 (copy), p2 (copy), EventNames (copy), AppPage (copy), p1 (copy), Enums (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), v29 (copy), NavigateDown (copy), FriendsNetworking (copy), v28 (copy), SetCurrentToastMessage (copy), FFlagConnectionsToFriendsRename (copy)
				if FriendRequestNicknamesIXP.FFlagFriendRequestNicknames and v31 then
					if p2 then
						p2(EventNames.PlayerFriendRequest)
					end

					local t1 = {
						name = AppPage.SetNicknameModal,
						extraProps = {
							friendRequestParams = {
								targetUserId = p1.userId,
								source = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()
							}
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v12.down(v12.fromLegacyPage(t1))

						return
					end

					v29(NavigateDown(t1))

					return
				end

				v29(FriendsNetworking.RequestFriendshipFromUserId.API({
					targetUserId = p1.userId,
					currentUserId = v28,
					friendshipOriginSourceType = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()
				})):andThen(function() -- line: 179
					-- upvalues: v29 (copy), SetCurrentToastMessage (copy), FFlagConnectionsToFriendsRename (copy)
					v29(SetCurrentToastMessage({
						toastMessage = not FFlagConnectionsToFriendsRename and "Feature.Friends.Action.ConnectionRequestSent" or "Feature.Friends.Action.FriendRequestSent"
					}))
				end):catch(function() -- line: 186
					-- upvalues: v29 (copy), SetCurrentToastMessage (copy)
					v29(SetCurrentToastMessage({
						toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
					}))
				end)

				if p2 then
					p2(EventNames.PlayerFriendRequest)
				end
			end
		}}
	end

	return nil
end
