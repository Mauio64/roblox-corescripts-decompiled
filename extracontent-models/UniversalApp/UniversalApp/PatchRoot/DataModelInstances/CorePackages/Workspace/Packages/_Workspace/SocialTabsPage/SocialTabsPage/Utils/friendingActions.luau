local HttpService = game:GetService("HttpService")
local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local ProfileCTAStore = require(SocialTabsPageParent.DataHydration).Profile.ProfileCTAStore
local FriendingErrorCodes = require(SocialTabsPage.Enums.FriendingErrorCodes)
local Images = require(SocialTabsPageParent.UIBlox).App.ImageSet.Images
local SetCurrentToastMessage = require(SocialTabsPageParent.ToastRodux).Actions.SetCurrentToastMessage
local NetworkingFriends = require(SocialTabsPage.Networking.NetworkingFriends)
local v9 = Images["icons/actions/friends/friendAdd"]
local _ = {
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN = 403,
	TOO_MANY_REQUESTS = 429
}

local function refreshCTA(s1: string) -- line: 59
	-- upvalues: ProfileCTAStore (copy)
	ProfileCTAStore.get().getCTA(s1, true)
end
local function getErrorToastMessage(t1: {[any]: any}, n1: number?, n2: number?) -- line: 64
	-- upvalues: FriendingErrorCodes (copy)
	if n1 == 400 then
		return ({
			[FriendingErrorCodes.INVALID_TARGET_USER] = t1.invalidTargetUserError,
			[FriendingErrorCodes.ALREADY_FRIEND] = t1.alreadyFriendError,
			[FriendingErrorCodes.MAX_FRIENDS] = t1.maxFriendsError,
			[FriendingErrorCodes.INVALID_NICKNAME] = t1.invalidNicknameError
		})[n2]
	end

	if n1 == 401 then
		return ({
			[FriendingErrorCodes.UNAUTHORIZED] = t1.unauthorizedError
		})[n2]
	end

	if n1 == 403 then
		return ({
			[FriendingErrorCodes.USER_BANNED] = t1.userBannedError,
			[FriendingErrorCodes.USER_BLOCKED] = t1.userBlockedError,
			[FriendingErrorCodes.USER_NOT_PASSED_CAPTCHA] = t1.userNotPassedCaptchaError
		})[n2]
	end

	if n1 == 429 then
		return ({
			[FriendingErrorCodes.TOO_MANY_REQUESTS] = t1.tooManyRequestsError
		})[n2]
	end

	return nil
end
local function showErrorToast(p1: ((...any) -> ...any), t2: {[any]: any}, p2) -- line: 90
	-- upvalues: HttpService (copy), getErrorToastMessage (copy), SetCurrentToastMessage (copy)
	local defaultFriendingError = t2.defaultFriendingError

	if p2 ~= nil then
		local StatusCode = p2.StatusCode
		local ok, result = pcall(function() -- line: 95
			-- upvalues: p2 (copy), HttpService (copy)
			if p2.Body then
				return (HttpService:JSONDecode(p2.Body))
			end

			return nil
		end)
		local v25 = if not ok or (not result or (not result.errors or (not result.errors[1] or not result.errors[1].code))) then nil else result.errors[1].code

		defaultFriendingError = getErrorToastMessage(t2, StatusCode, v25) or defaultFriendingError
	end

	p1(SetCurrentToastMessage({
		isLocalized = true,
		toastMessage = defaultFriendingError
	}))
end

return {
	executeAddFriend = function(t3: {[any]: any}) -- line: 114
		-- upvalues: NetworkingFriends (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy), showErrorToast (copy)
		return t3.dispatch(NetworkingFriends.RequestFriendshipFromUserId.API({
			currentUserId = t3.currentUserId,
			targetUserId = t3.targetUserId,
			friendshipOriginSourceType = t3.friendshipOriginSourceType
		})):andThen(function() -- line: 121
			-- upvalues: t3 (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy)
			local targetUserId = t3.targetUserId

			ProfileCTAStore.get().getCTA(targetUserId, true)
			t3.dispatch(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = t3.localized.friendRequestSent,
				toastIcon = v9
			}))
		end):catch(function(p3) -- line: 129
			-- upvalues: showErrorToast (copy), t3 (copy)
			showErrorToast(t3.dispatch, t3.localized, p3)
		end)
	end,
	executeAcceptFriendRequest = function(t4: {[any]: any}) -- line: 134
		-- upvalues: NetworkingFriends (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy), showErrorToast (copy)
		return t4.dispatch(NetworkingFriends.AcceptFriendRequestFromUserId.API({
			currentUserId = t4.currentUserId,
			targetUserId = t4.targetUserId
		})):andThen(function() -- line: 140
			-- upvalues: t4 (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy)
			local targetUserId = t4.targetUserId

			ProfileCTAStore.get().getCTA(targetUserId, true)
			t4.dispatch(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = t4.localized.friendAdded,
				toastIcon = v9
			}))
		end):catch(function(p4) -- line: 148
			-- upvalues: showErrorToast (copy), t4 (copy)
			showErrorToast(t4.dispatch, t4.localized, p4)
		end)
	end
}
