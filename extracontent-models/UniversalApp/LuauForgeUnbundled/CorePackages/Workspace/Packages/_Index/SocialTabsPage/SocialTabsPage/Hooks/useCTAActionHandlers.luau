local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RobloxAppHooks")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SocialCommon")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Localization")
local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/NetworkingFriends")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useLocalization = Localization.Hooks.useLocalization
local EnteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/AppChat/EnteredChatFromEntryPoint")
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local friendshipOriginSourceType = NetworkingFriends.Enums.FriendshipOriginSourceType

local buttonTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/UserList").Enums.ButtonTypes

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/TextKeys")
require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/Types")
local friendingActions = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Utils/friendingActions")

local notificationTypeList = GuiService:GetNotificationTypeList()

local function useCTAActionHandlers()
	local v5 = useDispatch()
	local v6 = useLocalUserId()
	local ref = React.useRef({})

	local v7 = useLocalization({
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
			[buttonTypes.Chat] = function(p2)
				v5(EnteredChatFromEntryPoint(chatEntryPointNames.SocialTab))
				GuiService:BroadcastNotification(p2, notificationTypeList.LAUNCH_CONVERSATION)
			end,
			[buttonTypes.Add] = function(p2)
				if ref.current[p2] then
					return
				end

				ref.current[p2] = true

				friendingActions.executeAddFriend({
					dispatch = v5,
					currentUserId = v6,
					targetUserId = p2,
					friendshipOriginSourceType = friendshipOriginSourceType.UserProfile.rawValue(),
					localized = v7
				}):finally(function()
					ref.current[p2] = nil
				end)
			end,
			[buttonTypes.Accept] = function(p2)
				if ref.current[p2] then
					return
				end

				ref.current[p2] = true

				friendingActions.executeAcceptFriendRequest({
					dispatch = v5,
					currentUserId = v6,
					targetUserId = p2,
					localized = v7
				}):finally(function()
					ref.current[p2] = nil
				end)
			end
		}
	end, { v5, v6, v7 })
end

return useCTAActionHandlers
