local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local DataHydration = require(parent.DataHydration)
local ProfileCTAStore = DataHydration.Profile.ProfileCTAStore
local Requests = DataHydration.Friends.Requests
local FriendsStore = DataHydration.Friends.FriendsStore
local friendsStoreChallengeNetwork = require(UserList.Networking.friendsStoreChallengeNetwork)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags.FFlagEnableFriendsStoreChallengeInterceptor

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local FriendingErrorCodes = require(script.Parent.FriendingErrorCodes)

local iconsactionsfriendsfriendAdd = Images["icons/actions/friends/friendAdd"]

local _ = { BAD_REQUEST = 400, UNAUTHORIZED = 401, FORBIDDEN = 403, TOO_MANY_REQUESTS = 429 }

local function refreshCTA(targetUserId: string) -- 3 equivalent calls inferred from this helper
	ProfileCTAStore.get().getCTA(targetUserId, true)
end

local function getErrorToastMessage(data, statusCode: number?, p: number?)
	if statusCode == 400 then
		return ({
			[FriendingErrorCodes.INVALID_TARGET_USER] = data.invalidTargetUserError,
			[FriendingErrorCodes.ALREADY_FRIEND] = data.alreadyFriendError,
			[FriendingErrorCodes.MAX_FRIENDS] = data.maxFriendsError,
			[FriendingErrorCodes.INVALID_NICKNAME] = data.invalidNicknameError
		})[p]
	elseif statusCode == 401 then
		local unauthorizedErrorsByUnauthorized = {
			[FriendingErrorCodes.UNAUTHORIZED] = data.unauthorizedError
		}
		return unauthorizedErrorsByUnauthorized[p]
	elseif statusCode == 403 then
		return ({
			[FriendingErrorCodes.USER_BANNED] = data.userBannedError,
			[FriendingErrorCodes.USER_BLOCKED] = data.userBlockedError,
			[FriendingErrorCodes.USER_NOT_PASSED_CAPTCHA] = data.userNotPassedCaptchaError
		})[p]
	else
		if statusCode ~= 429 then
			return nil
		end

		local tooManyRequestsErrorsByTOO_MANY_REQUESTS = {
			[FriendingErrorCodes.TOO_MANY_REQUESTS] = data.tooManyRequestsError
		}
		return tooManyRequestsErrorsByTOO_MANY_REQUESTS[p]
	end
end

local function showErrorToast(dispatch, localized, p)
	local statusCode

	if type(p) == "table" then
		statusCode = p.statusCode
	end

	local v

	if type(p) == "table" then
		v = p.firstErrorCode
	end

	dispatch(SetCurrentToastMessage({
		toastMessage = getErrorToastMessage(localized, statusCode, v) or localized.defaultFriendingError,
		isLocalized = true
	}))
end

local FriendingActions = {}

function FriendingActions.executeAddFriend(data)
	local requestFriendshipFromUserId = Requests.RequestFriendshipFromUserId
	local targetUserId = data.targetUserId
	local friendshipOriginSourceType = data.friendshipOriginSourceType
	local v

	if FFlagEnableFriendsStoreChallengeInterceptor then
		v = friendsStoreChallengeNetwork
	end

	return requestFriendshipFromUserId(targetUserId, friendshipOriginSourceType, v):andThen(function()
		refreshCTA(data.targetUserId) -- inferred equivalent call
		data.dispatch(SetCurrentToastMessage({
			toastMessage = data.localized.friendRequestSent,
			toastIcon = iconsactionsfriendsfriendAdd,
			isLocalized = true
		}))
	end):catch(function(p)
		showErrorToast(data.dispatch, data.localized, p)
	end)
end

function FriendingActions.executeAcceptFriendRequest(data)
	return FriendsStore.get().AcceptFriendRequest(data.targetUserId):andThen(function()
		refreshCTA(data.targetUserId) -- inferred equivalent call
		data.dispatch(SetCurrentToastMessage({
			toastMessage = data.localized.friendAdded,
			toastIcon = iconsactionsfriendsfriendAdd,
			isLocalized = true
		}))
	end):catch(function(p)
		showErrorToast(data.dispatch, data.localized, p)
	end)
end

function FriendingActions.executeDeclineFriendRequest(data)
	return FriendsStore.get().DeclineFriendRequest(data.targetUserId):andThen(function()
		refreshCTA(data.targetUserId) -- inferred equivalent call
	end):catch(function(p)
		showErrorToast(data.dispatch, data.localized, p)
	end)
end

return FriendingActions
