local GuiService = game:GetService("GuiService")

local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SocialCommon = require(parent.SocialCommon)
local Localization = require(parent.Localization)
local FriendsNetworking = require(parent.FriendsNetworking)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useLocalization = Localization.Hooks.useLocalization
local EnteredChatFromEntryPoint = require(parent.AppChat.EnteredChatFromEntryPoint)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local FriendshipOriginSourceType = FriendsNetworking.Enums.FriendshipOriginSourceType

local UserList = require(parent.UserList)
local ButtonTypes = UserList.Enums.ButtonTypes

local TextKeys = require(SocialTabsPage.Common.TextKeys)
require(SocialTabsPage.Common.Types)
local friendingActions = require(SocialTabsPage.Utils.friendingActions)

local notificationTypeList = GuiService:GetNotificationTypeList()

local function useCTAActionHandlers()
	local dispatch = useDispatch()
	local currentUserId = useLocalUserId()
	local ref = React.useRef({})

	local localized = useLocalization({
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

	return React.useMemo(function()
		return {
			[ButtonTypes.Chat] = function(p: string)
				dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.SocialTab))
				GuiService:BroadcastNotification(p, notificationTypeList.LAUNCH_CONVERSATION)
			end,
			[ButtonTypes.Add] = function(targetUserId: string)
				if ref.current[targetUserId] then
					return
				end

				ref.current[targetUserId] = true

				friendingActions.executeAddFriend({
					dispatch = dispatch,
					currentUserId = currentUserId,
					targetUserId = targetUserId,
					friendshipOriginSourceType = FriendshipOriginSourceType.UserProfile.rawValue(),
					localized = localized
				}):finally(function()
					ref.current[targetUserId] = nil
				end)
			end,
			[ButtonTypes.Accept] = function(targetUserId: string)
				if ref.current[targetUserId] then
					return
				end

				ref.current[targetUserId] = true

				friendingActions.executeAcceptFriendRequest({
					dispatch = dispatch,
					currentUserId = currentUserId,
					targetUserId = targetUserId,
					localized = localized
				}):finally(function()
					ref.current[targetUserId] = nil
				end)
			end
		}
	end, { dispatch, currentUserId, localized })
end

return useCTAActionHandlers
