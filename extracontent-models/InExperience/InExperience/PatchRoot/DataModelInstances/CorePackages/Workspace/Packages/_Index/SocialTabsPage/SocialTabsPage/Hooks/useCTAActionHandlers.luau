local GuiService = game:GetService("GuiService")
local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local RoactUtils = require(SocialTabsPageParent.RoactUtils)
local RobloxAppHooks = require(SocialTabsPageParent.RobloxAppHooks)
local SocialCommon = require(SocialTabsPageParent.SocialCommon)
local Localization = require(SocialTabsPageParent.Localization)
local FriendsNetworking = require(SocialTabsPageParent.FriendsNetworking)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useLocalization = Localization.Hooks.useLocalization
local EnteredChatFromEntryPoint = require(SocialTabsPageParent.AppChat.EnteredChatFromEntryPoint)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local FriendshipOriginSourceType = FriendsNetworking.Enums.FriendshipOriginSourceType
local ButtonTypes = require(SocialTabsPageParent.UserList).Enums.ButtonTypes
local TextKeys = require(SocialTabsPage.Common.TextKeys)

require(SocialTabsPage.Common.Types)

local friendingActions = require(SocialTabsPage.Utils.friendingActions)
local NotificationTypeList = GuiService:GetNotificationTypeList()

local function useCTAActionHandlers() -- line: 31
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), useLocalization (copy), TextKeys (copy), ButtonTypes (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), friendingActions (copy), FriendshipOriginSourceType (copy)
	local v21 = useDispatch()
	local v22 = useLocalUserId()
	local v23 = React.useRef({})
	local v24 = useLocalization({
		friendRequestSent = TextKeys.FriendRequestSent,
		friendAdded = TextKeys.FriendAdded,
		invalidTargetUserError = TextKeys.InvalidTargetUserError,
		alreadyFriendError = TextKeys.AlreadyFriendError,
		maxFriendsError = TextKeys.MaxFriendsError,
		invalidNicknameError = TextKeys.InvalidNicknameError,
		unauthorizedError = TextKeys.UnauthorizedError,
		userBannedError = TextKeys.UserBannedError,
		userBlockedError = TextKeys.UserBlockedError,
		userNotPassedCaptchaError = TextKeys.UserNotPassedCaptchaError,
		tooManyRequestsError = TextKeys.TooManyRequestsError,
		defaultFriendingError = TextKeys.DefaultFriendingError
	})

	return React.useMemo(function() -- line: 51
		-- upvalues: ButtonTypes (copy), v21 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy), v23 (copy), friendingActions (copy), v22 (copy), FriendshipOriginSourceType (copy), v24 (copy)
		return {
			[ButtonTypes.Chat] = function(s1: string) -- line: 53
				-- upvalues: v21 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy)
				v21(EnteredChatFromEntryPoint(ChatEntryPointNames.SocialTab))
				GuiService:BroadcastNotification(s1, NotificationTypeList.LAUNCH_CONVERSATION)
			end,
			[ButtonTypes.Add] = function(s2: string) -- line: 58
				-- upvalues: v23 (copy), friendingActions (copy), v21 (copy), v22 (copy), FriendshipOriginSourceType (copy), v24 (copy)
				if v23.current[s2] then
					return
				end

				v23.current[s2] = true
				friendingActions.executeAddFriend({
					dispatch = v21,
					currentUserId = v22,
					targetUserId = s2,
					friendshipOriginSourceType = FriendshipOriginSourceType.UserProfile.rawValue(),
					localized = v24
				}):finally(function() -- line: 71
					-- upvalues: v23 (copy), s2 (copy)
					v23.current[s2] = nil
				end)
			end,
			[ButtonTypes.Accept] = function(s3: string) -- line: 76
				-- upvalues: v23 (copy), friendingActions (copy), v21 (copy), v22 (copy), v24 (copy)
				if v23.current[s3] then
					return
				end

				v23.current[s3] = true
				friendingActions.executeAcceptFriendRequest({
					dispatch = v21,
					currentUserId = v22,
					targetUserId = s3,
					localized = v24
				}):finally(function() -- line: 88
					-- upvalues: v23 (copy), s3 (copy)
					v23.current[s3] = nil
				end)
			end
		}
	end, {
		v21,
		v22,
		v24
	})
end

return useCTAActionHandlers
