local HttpService = game:GetService("HttpService")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/DataHydration")
local profileCTAStore = DataHydration.Profile.ProfileCTAStore
local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Networking/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor
local v5 = DataHydration.Friends.FriendsStore.get()

local FriendingErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Enums/FriendingErrorCodes")

local images = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/UIBlox").App.ImageSet.Images

local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/ToastRodux").Actions.SetCurrentToastMessage
local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Networking/NetworkingFriends")

local fFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagMigrateFriendshipStatusesRemainingActions

local iconsactionsfriendsfriendAdd = images["icons/actions/friends/friendAdd"]

local v6 = {
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
	local v7 = localized.defaultFriendingError

	if p2 ~= nil then
		local statusCode = p2.StatusCode
		local success, result = pcall(function()
			if p2.Body then
				return (HttpService:JSONDecode(p2.Body))
			end

			return nil
		end)
		local v8

		if success and result and result.errors and result.errors[1] and result.errors[1].code then
			v8 = result.errors[1].code
		end

		v7 = getErrorToastMessage(localized, statusCode, v8) or v7
	end

	dispatch(setCurrentToastMessage({ toastMessage = v7, isLocalized = true }))
end

return {
	executeAddFriend = function(data)
		local v7

		if fFlagMigrateFriendshipStatusesRemainingActions then
			local requestFriendship = v5.RequestFriendship
			local targetUserId = data.targetUserId
			local friendshipOriginSourceType = data.friendshipOriginSourceType
			local v9 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
			v7 = requestFriendship(targetUserId, friendshipOriginSourceType, nil, v9)
		else
			v7 = data.dispatch(NetworkingFriends.RequestFriendshipFromUserId.API({
				currentUserId = data.currentUserId,
				targetUserId = data.targetUserId,
				friendshipOriginSourceType = data.friendshipOriginSourceType
			}))
		end

		return v7:andThen(function()
			local targetUserId = data.targetUserId
			profileCTAStore.get().getCTA(targetUserId, true)

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
		local v7

		if fFlagMigrateFriendshipStatusesRemainingActions then
			v7 = v5.AcceptFriendRequest(data.targetUserId)
		else
			v7 = data.dispatch(NetworkingFriends.AcceptFriendRequestFromUserId.API({
				currentUserId = data.currentUserId,
				targetUserId = data.targetUserId
			}))
		end

		return v7:andThen(function()
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
	end
}
