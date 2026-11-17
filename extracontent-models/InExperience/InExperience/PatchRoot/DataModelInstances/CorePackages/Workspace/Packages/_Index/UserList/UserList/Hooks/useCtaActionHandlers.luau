local GuiService = game:GetService("GuiService")

local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Localization = require(parent.Localization)
local SocialCommon = require(parent.SocialCommon)
local Enums = require(UserList.Common.Enums)

local EnteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListCtaAnalyticsEnabled = SharedFlags.FFlagUserListCtaAnalyticsEnabled
local FFlagUserListCanonicalCtaAnalytics = require(UserList.Flags.FFlagUserListCanonicalCtaAnalytics)
local reportCtaActivated = require(UserList.Analytics.reportCtaActivated)
local FFlagUserListRowViewCta = require(UserList.Flags.FFlagUserListRowViewCta)
local useEntitySelectionHandler = require(UserList.Hooks.useEntitySelectionHandler)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local ButtonTypes = Enums.ButtonTypes

local TextKeys = require(UserList.Common.TextKeys)
require(UserList.Common.Types)
local friendingActions = require(UserList.Cta.friendingActions)

local notificationTypeList = GuiService:GetNotificationTypeList()

local function useCtaActionHandlers(data)
	local dispatch = useDispatch()
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
	local friendshipOriginSourceType

	if data then
		friendshipOriginSourceType = data.friendshipOriginSourceType
	else
		friendshipOriginSourceType = nil
	end

	local chatEntryPoint

	if data then
		chatEntryPoint = data.chatEntryPoint
	else
		chatEntryPoint = nil
	end

	local onCtaActivated

	if FFlagUserListCtaAnalyticsEnabled and data then
		onCtaActivated = data.onCtaActivated
	else
		onCtaActivated = nil
	end

	local analytics

	if FFlagUserListCanonicalCtaAnalytics and data then
		analytics = data.analytics
	else
		analytics = nil
	end

	local v

	if FFlagUserListRowViewCta then
		v = useEntitySelectionHandler(nil, (React.useMemo(function()
			return { friendshipOriginSourceType = friendshipOriginSourceType }
		end, { friendshipOriginSourceType or false })))
	else
		v = nil
	end

	return React.useMemo(function()
		return {
			[ButtonTypes.Chat] = function(userId: string, p: number?)
				if FFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = ButtonTypes.Chat, userId = userId })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, ButtonTypes.Chat, userId, p)
				end

				if chatEntryPoint ~= nil then
					dispatch(EnteredChatFromEntryPoint(chatEntryPoint))
				end

				GuiService:BroadcastNotification(userId, notificationTypeList.LAUNCH_CONVERSATION)
			end,
			[ButtonTypes.Add] = function(p: string, p2: number?)
				if ref.current[p] then
					return
				end

				ref.current[p] = true

				if FFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = ButtonTypes.Add, userId = p })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, ButtonTypes.Add, p, p2)
				end

				friendingActions.executeAddFriend({
					dispatch = dispatch,
					targetUserId = p,
					friendshipOriginSourceType = friendshipOriginSourceType,
					localized = localized
				}):finally(function()
					ref.current[p] = nil
				end)
			end,
			[ButtonTypes.Accept] = function(p: string, p2: number?)
				if ref.current[p] then
					return
				end

				ref.current[p] = true

				if FFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = ButtonTypes.Accept, userId = p })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, ButtonTypes.Accept, p, p2)
				end

				friendingActions.executeAcceptFriendRequest({
					dispatch = dispatch,
					targetUserId = p,
					localized = localized
				}):finally(function()
					ref.current[p] = nil
				end)
			end,
			[ButtonTypes.Dismiss] = function(p: string, p2: number?)
				if ref.current[p] then
					return
				end

				ref.current[p] = true

				if FFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = ButtonTypes.Dismiss, userId = p })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, ButtonTypes.Dismiss, p, p2)
				end

				friendingActions.executeDeclineFriendRequest({
					dispatch = dispatch,
					targetUserId = p,
					localized = localized
				}):finally(function()
					ref.current[p] = nil
				end)
			end,
			[ButtonTypes.View] = FFlagUserListRowViewCta and function(userId: string, p: number?)
				if FFlagUserListCtaAnalyticsEnabled and onCtaActivated ~= nil then
					onCtaActivated({ buttonType = ButtonTypes.View, userId = userId })
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, ButtonTypes.View, userId, p)
				end

				v(userId, Enums.EntityType.User)
			end or nil
		}
	end, {
		dispatch,
		localized,
		friendshipOriginSourceType,
		onCtaActivated,
		chatEntryPoint,
		analytics,
		v
	})
end

return useCtaActionHandlers
