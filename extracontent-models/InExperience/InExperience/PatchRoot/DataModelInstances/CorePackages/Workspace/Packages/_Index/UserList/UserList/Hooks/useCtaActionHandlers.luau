local GuiService = game:GetService("GuiService")
local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local RoactUtils = require(UserListParent.RoactUtils)
local Localization = require(UserListParent.Localization)
local Enums = require(UserList.Common.Enums)
local FFlagUserListCtaAnalyticsEnabled = require(UserListParent.SharedFlags).FFlagUserListCtaAnalyticsEnabled
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local ButtonTypes = Enums.ButtonTypes
local TextKeys = require(UserList.Common.TextKeys)

require(UserList.Common.Types)

local friendingActions = require(UserList.Cta.friendingActions)
local NotificationTypeList = GuiService:GetNotificationTypeList()

local function useCtaActionHandlers(p1) -- line: 29
	-- upvalues: useDispatch (copy), React (copy), useLocalization (copy), TextKeys (copy), FFlagUserListCtaAnalyticsEnabled (copy), ButtonTypes (copy), GuiService (copy), NotificationTypeList (copy), friendingActions (copy)
	local v17 = useDispatch()
	local v18 = React.useRef({})
	local v19 = useLocalization({
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
	local v20 = if not p1 then nil else p1.friendshipOriginSourceType
	local u21 = nil

	if FFlagUserListCtaAnalyticsEnabled then
		u21 = if not p1 then nil else p1.onCtaActivated
	end

	return React.useMemo(function() -- line: 55
		-- upvalues: ButtonTypes (copy), FFlagUserListCtaAnalyticsEnabled (copy), u21 (ref), GuiService (copy), NotificationTypeList (copy), v18 (copy), friendingActions (copy), v17 (copy), v20 (copy), v19 (copy)
		return {
			[ButtonTypes.Chat] = function(s1: string) -- line: 57
				-- upvalues: FFlagUserListCtaAnalyticsEnabled (copy), u21 (ref), ButtonTypes (copy), GuiService (copy), NotificationTypeList (copy)
				if FFlagUserListCtaAnalyticsEnabled and u21 ~= nil then
					u21({
						buttonType = ButtonTypes.Chat,
						userId = s1
					})
				end

				GuiService:BroadcastNotification(s1, NotificationTypeList.LAUNCH_CONVERSATION)
			end,
			[ButtonTypes.Add] = function(s2: string) -- line: 64
				-- upvalues: v18 (copy), FFlagUserListCtaAnalyticsEnabled (copy), u21 (ref), ButtonTypes (copy), friendingActions (copy), v17 (copy), v20 (copy), v19 (copy)
				if v18.current[s2] then
					return
				end

				v18.current[s2] = true

				if FFlagUserListCtaAnalyticsEnabled and u21 ~= nil then
					u21({
						buttonType = ButtonTypes.Add,
						userId = s2
					})
				end

				friendingActions.executeAddFriend({
					dispatch = v17,
					targetUserId = s2,
					friendshipOriginSourceType = v20,
					localized = v19
				}):finally(function() -- line: 79
					-- upvalues: v18 (copy), s2 (copy)
					v18.current[s2] = nil
				end)
			end,
			[ButtonTypes.Accept] = function(s3: string) -- line: 84
				-- upvalues: v18 (copy), FFlagUserListCtaAnalyticsEnabled (copy), u21 (ref), ButtonTypes (copy), friendingActions (copy), v17 (copy), v19 (copy)
				if v18.current[s3] then
					return
				end

				v18.current[s3] = true

				if FFlagUserListCtaAnalyticsEnabled and u21 ~= nil then
					u21({
						buttonType = ButtonTypes.Accept,
						userId = s3
					})
				end

				friendingActions.executeAcceptFriendRequest({
					dispatch = v17,
					targetUserId = s3,
					localized = v19
				}):finally(function() -- line: 98
					-- upvalues: v18 (copy), s3 (copy)
					v18.current[s3] = nil
				end)
			end,
			[ButtonTypes.Dismiss] = function(s4: string) -- line: 103
				-- upvalues: v18 (copy), FFlagUserListCtaAnalyticsEnabled (copy), u21 (ref), ButtonTypes (copy), friendingActions (copy), v17 (copy), v19 (copy)
				if v18.current[s4] then
					return
				end

				v18.current[s4] = true

				if FFlagUserListCtaAnalyticsEnabled and u21 ~= nil then
					u21({
						buttonType = ButtonTypes.Dismiss,
						userId = s4
					})
				end

				friendingActions.executeDeclineFriendRequest({
					dispatch = v17,
					targetUserId = s4,
					localized = v19
				}):finally(function() -- line: 117
					-- upvalues: v18 (copy), s4 (copy)
					v18.current[s4] = nil
				end)
			end
		}
	end, {
		v17,
		v19,
		v20,
		u21
	})
end

return useCtaActionHandlers
