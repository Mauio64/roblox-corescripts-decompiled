local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Localization")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialCommon")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")

local enteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint

local fFlagUserListCtaAnalyticsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaAnalyticsEnabled
local FFlagUserListCanonicalCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListCanonicalCtaAnalytics")
local reportCtaActivated = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Analytics/reportCtaActivated")
local fFlagSharedChatEntryPointAction = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagSharedChatEntryPointAction
local FFlagUserListRowViewCta = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListRowViewCta")
local useEntitySelectionHandler = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useEntitySelectionHandler")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local buttonTypes = Enums.ButtonTypes

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/TextKeys")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local friendingActions = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/friendingActions")

local notificationTypeList = GuiService:GetNotificationTypeList()

local function useCtaActionHandlers(data)
	local v5 = useDispatch()
	local ref = React.useRef({})

	local v6 = useLocalization({
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

	local friendshipOriginSourceType = if data then data.friendshipOriginSourceType else nil

	local chatEntryPoint = if fFlagSharedChatEntryPointAction and data then data.chatEntryPoint else nil

	local onCtaActivated = if fFlagUserListCtaAnalyticsEnabled and data then data.onCtaActivated else nil

	local analytics = if FFlagUserListCanonicalCtaAnalytics and data then data.analytics else nil
	local v7

	if FFlagUserListRowViewCta then
		v7 = useEntitySelectionHandler(nil, (React.useMemo(function()
			return { friendshipOriginSourceType = friendshipOriginSourceType }
		end, { friendshipOriginSourceType or false })))
	else
		v7 = nil
	end

	return React.useMemo(function()
		return {
			[buttonTypes.Chat] = function(p2, p3)
				if fFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = buttonTypes.Chat, userId = p2 })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, buttonTypes.Chat, p2, p3)
				end

				if fFlagSharedChatEntryPointAction and chatEntryPoint ~= nil then
					v5(enteredChatFromEntryPoint(chatEntryPoint))
				end

				GuiService:BroadcastNotification(p2, notificationTypeList.LAUNCH_CONVERSATION)
			end,
			[buttonTypes.Add] = function(p2, p3)
				if ref.current[p2] then
					return
				end

				ref.current[p2] = true

				if fFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = buttonTypes.Add, userId = p2 })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, buttonTypes.Add, p2, p3)
				end

				friendingActions.executeAddFriend({
					dispatch = v5,
					targetUserId = p2,
					friendshipOriginSourceType = friendshipOriginSourceType,
					localized = v6
				}):finally(function()
					ref.current[p2] = nil
				end)
			end,
			[buttonTypes.Accept] = function(p2, p3)
				if ref.current[p2] then
					return
				end

				ref.current[p2] = true

				if fFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = buttonTypes.Accept, userId = p2 })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, buttonTypes.Accept, p2, p3)
				end

				friendingActions.executeAcceptFriendRequest({
					dispatch = v5,
					targetUserId = p2,
					localized = v6
				}):finally(function()
					ref.current[p2] = nil
				end)
			end,
			[buttonTypes.Dismiss] = function(p2, p3)
				if ref.current[p2] then
					return
				end

				ref.current[p2] = true

				if fFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = buttonTypes.Dismiss, userId = p2 })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, buttonTypes.Dismiss, p2, p3)
				end

				friendingActions.executeDeclineFriendRequest({
					dispatch = v5,
					targetUserId = p2,
					localized = v6
				}):finally(function()
					ref.current[p2] = nil
				end)
			end,
			[buttonTypes.View] = FFlagUserListRowViewCta and function(p2, p3)
				if fFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = buttonTypes.View, userId = p2 })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, buttonTypes.View, p2, p3)
				end

				v7(p2, Enums.EntityType.User)
			end or nil
		}
	end, {
		v5,
		v6,
		friendshipOriginSourceType,
		onCtaActivated,
		chatEntryPoint,
		analytics,
		v7
	})
end

return useCtaActionHandlers
