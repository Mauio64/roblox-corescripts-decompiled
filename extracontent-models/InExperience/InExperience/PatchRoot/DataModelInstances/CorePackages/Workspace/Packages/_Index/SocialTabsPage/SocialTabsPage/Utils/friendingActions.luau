local HttpService = game:GetService("HttpService")

local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local DataHydration = require(parent.DataHydration)
local ProfileCTAStore = DataHydration.Profile.ProfileCTAStore
local friendsStoreChallengeNetwork = require(SocialTabsPage.Networking.friendsStoreChallengeNetwork)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags.FFlagEnableFriendsStoreChallengeInterceptor
local v = DataHydration.Friends.FriendsStore.get()

local FriendingErrorCodes = require(SocialTabsPage.Enums.FriendingErrorCodes)

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local NetworkingFriends = require(SocialTabsPage.Networking.NetworkingFriends)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags2.FFlagMigrateFriendshipStatusesRemainingActions

local iconsactionsfriendsfriendAdd = Images["icons/actions/friends/friendAdd"]

local _ = { BAD_REQUEST = 400, UNAUTHORIZED = 401, FORBIDDEN = 403, TOO_MANY_REQUESTS = 429 }

local function refreshCTA(targetUserId: string) -- 2 equivalent calls inferred from this helper
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
	local toastMessage = localized.defaultFriendingError

	if p ~= nil then
		local statusCode = p.StatusCode
		local success, result = pcall(function()
			if p.Body then
				return (HttpService:JSONDecode(p.Body))
			end

			return nil
		end)
		local v2

		if success and result and result.errors and result.errors[1] and result.errors[1].code then
			v2 = result.errors[1].code
		end

		toastMessage = getErrorToastMessage(localized, statusCode, v2) or toastMessage
	end

	dispatch(SetCurrentToastMessage({ toastMessage = toastMessage, isLocalized = true }))
end

local FriendingActions = {}

function FriendingActions.executeAddFriend(data)
	local v2

	if FFlagMigrateFriendshipStatusesRemainingActions then
		local requestFriendship = v.RequestFriendship
		local targetUserId = data.targetUserId
		local friendshipOriginSourceType = data.friendshipOriginSourceType
		local v3

		if FFlagEnableFriendsStoreChallengeInterceptor then
			v3 = friendsStoreChallengeNetwork
		end

		v2 = requestFriendship(targetUserId, friendshipOriginSourceType, nil, v3)
	else
		v2 = data.dispatch(NetworkingFriends.RequestFriendshipFromUserId.API({
			currentUserId = data.currentUserId,
			targetUserId = data.targetUserId,
			friendshipOriginSourceType = data.friendshipOriginSourceType
		}))
	end

	return v2:andThen(function()
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
	local v2

	if FFlagMigrateFriendshipStatusesRemainingActions then
		v2 = v.AcceptFriendRequest(data.targetUserId)
	else
		v2 = data.dispatch(NetworkingFriends.AcceptFriendRequestFromUserId.API({
			currentUserId = data.currentUserId,
			targetUserId = data.targetUserId
		}))
	end

	return v2:andThen(function()
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

return FriendingActions
