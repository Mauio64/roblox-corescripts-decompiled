local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/DataHydration")
local profileCTAStore = DataHydration.Profile.ProfileCTAStore
local requests = DataHydration.Friends.Requests
local friendsStore = DataHydration.Friends.FriendsStore
local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Networking/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor

local images = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/UIBlox").App.ImageSet.Images

local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/UserList/ToastRodux").Actions.SetCurrentToastMessage

local FriendingErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/FriendingErrorCodes")

local iconsactionsfriendsfriendAdd = images["icons/actions/friends/friendAdd"]

local v5 = {
	BAD_REQUEST = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN = 403,
	TOO_MANY_REQUESTS = 429
}

local function refreshCTA(p2)
	profileCTAStore.get().getCTA(p2, true)
end

local function getErrorToastMessage(data, statusCode, p2)
	if statusCode == 400 then
		return ({
			[FriendingErrorCodes.INVALID_TARGET_USER] = data.invalidTargetUserError,
			[FriendingErrorCodes.ALREADY_FRIEND] = data.alreadyFriendError,
			[FriendingErrorCodes.MAX_FRIENDS] = data.maxFriendsError,
			[FriendingErrorCodes.INVALID_NICKNAME] = data.invalidNicknameError
		})[p2]
	elseif statusCode == 401 then
		local unauthorizedErrorsByUnauthorized = {
			[FriendingErrorCodes.UNAUTHORIZED] = data.unauthorizedError
		}
		return unauthorizedErrorsByUnauthorized[p2]
	elseif statusCode == 403 then
		return ({
			[FriendingErrorCodes.USER_BANNED] = data.userBannedError,
			[FriendingErrorCodes.USER_BLOCKED] = data.userBlockedError,
			[FriendingErrorCodes.USER_NOT_PASSED_CAPTCHA] = data.userNotPassedCaptchaError
		})[p2]
	else
		if statusCode ~= 429 then
			return nil
		end

		local tooManyRequestsErrorsByTOO_MANY_REQUESTS = {
			[FriendingErrorCodes.TOO_MANY_REQUESTS] = data.tooManyRequestsError
		}
		return tooManyRequestsErrorsByTOO_MANY_REQUESTS[p2]
	end
end

local function showErrorToast(dispatch, localized, p2)
	local statusCode = if type(p2) == "table" then p2.statusCode else nil
	local v6 = if type(p2) == "table" then p2.firstErrorCode else nil
	dispatch(setCurrentToastMessage({
		toastMessage = getErrorToastMessage(localized, statusCode, v6) or localized.defaultFriendingError,
		isLocalized = true
	}))
end

return {
	executeAddFriend = function(data)
		local requestFriendshipFromUserId = requests.RequestFriendshipFromUserId
		local targetUserId = data.targetUserId
		local friendshipOriginSourceType = data.friendshipOriginSourceType
		local v6 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
		return requestFriendshipFromUserId(targetUserId, friendshipOriginSourceType, v6):andThen(function()
			local targetUserId2 = data.targetUserId
			profileCTAStore.get().getCTA(targetUserId2, true)

			data.dispatch(setCurrentToastMessage({
				toastMessage = data.localized.friendRequestSent,
				toastIcon = iconsactionsfriendsfriendAdd,
				isLocalized = true
			}))
		end):catch(function(p2)
			showErrorToast(data.dispatch, data.localized, p2)
		end)
	end,
	executeAcceptFriendRequest = function(data)
		return friendsStore.get().AcceptFriendRequest(data.targetUserId):andThen(function()
			local targetUserId = data.targetUserId
			profileCTAStore.get().getCTA(targetUserId, true)

			data.dispatch(setCurrentToastMessage({
				toastMessage = data.localized.friendAdded,
				toastIcon = iconsactionsfriendsfriendAdd,
				isLocalized = true
			}))
		end):catch(function(p2)
			showErrorToast(data.dispatch, data.localized, p2)
		end)
	end,
	executeDeclineFriendRequest = function(data)
		return friendsStore.get().DeclineFriendRequest(data.targetUserId):andThen(function()
			local targetUserId = data.targetUserId
			profileCTAStore.get().getCTA(targetUserId, true)
		end):catch(function(p2)
			showErrorToast(data.dispatch, data.localized, p2)
		end)
	end
}
