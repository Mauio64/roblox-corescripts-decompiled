local Parent = script:FindFirstAncestor("UserList").Parent
local DataHydration = require(Parent.DataHydration)
local ProfileCTAStore = DataHydration.Profile.ProfileCTAStore
local Requests = DataHydration.Friends.Requests
local FriendsStore = DataHydration.Friends.FriendsStore
local Images = require(Parent.UIBlox).App.ImageSet.Images
local SetCurrentToastMessage = require(Parent.ToastRodux).Actions.SetCurrentToastMessage
local FriendingErrorCodes = require(script.Parent.FriendingErrorCodes)
local v9 = Images["icons/actions/friends/friendAdd"]
local _ = {
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN = 403,
	TOO_MANY_REQUESTS = 429
}

local function refreshCTA(s1: string) -- line: 61
	-- upvalues: ProfileCTAStore (copy)
	ProfileCTAStore.get().getCTA(s1, true)
end
local function getErrorToastMessage(t1: {[any]: any}, n1: number?, n2: number?) -- line: 66
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
local function showErrorToast(p1: ((...any) -> ...any), t2: {[any]: any}, p2) -- line: 92
	-- upvalues: getErrorToastMessage (copy), SetCurrentToastMessage (copy)
	local v21 = if type(p2) ~= "table" then nil else p2.statusCode
	local v22 = if type(p2) ~= "table" then nil else p2.firstErrorCode
	local v23 = getErrorToastMessage(t2, v21, v22) or t2.defaultFriendingError

	p1(SetCurrentToastMessage({
		isLocalized = true,
		toastMessage = v23
	}))
end

return {
	executeAddFriend = function(t3: {[any]: any}) -- line: 103
		-- upvalues: Requests (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy), showErrorToast (copy)
		return Requests.RequestFriendshipFromUserId(t3.targetUserId, t3.friendshipOriginSourceType):andThen(function() -- line: 105
			-- upvalues: t3 (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy)
			local targetUserId = t3.targetUserId

			ProfileCTAStore.get().getCTA(targetUserId, true)
			t3.dispatch(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = t3.localized.friendRequestSent,
				toastIcon = v9
			}))
		end):catch(function(p3) -- line: 113
			-- upvalues: showErrorToast (copy), t3 (copy)
			showErrorToast(t3.dispatch, t3.localized, p3)
		end)
	end,
	executeAcceptFriendRequest = function(t4: {[any]: any}) -- line: 118
		-- upvalues: FriendsStore (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy), showErrorToast (copy)
		return FriendsStore.get().AcceptFriendRequest(t4.targetUserId):andThen(function() -- line: 121
			-- upvalues: t4 (copy), ProfileCTAStore (copy), SetCurrentToastMessage (copy), v9 (copy)
			local targetUserId = t4.targetUserId

			ProfileCTAStore.get().getCTA(targetUserId, true)
			t4.dispatch(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = t4.localized.friendAdded,
				toastIcon = v9
			}))
		end):catch(function(p4) -- line: 129
			-- upvalues: showErrorToast (copy), t4 (copy)
			showErrorToast(t4.dispatch, t4.localized, p4)
		end)
	end,
	executeDeclineFriendRequest = function(t5: {[any]: any}) -- line: 134
		-- upvalues: FriendsStore (copy), ProfileCTAStore (copy), showErrorToast (copy)
		return FriendsStore.get().DeclineFriendRequest(t5.targetUserId):andThen(function() -- line: 137
			-- upvalues: t5 (copy), ProfileCTAStore (copy)
			local targetUserId = t5.targetUserId

			ProfileCTAStore.get().getCTA(targetUserId, true)
		end):catch(function(p5) -- line: 140
			-- upvalues: showErrorToast (copy), t5 (copy)
			showErrorToast(t5.dispatch, t5.localized, p5)
		end)
	end
}
