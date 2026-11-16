local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local HttpService = game:GetService("HttpService")

local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local SocialCommon = require(parent.SocialCommon)

local Images = UIBlox.App.ImageSet.Images
local ButtonVariant = Foundation.Enums.ButtonVariant
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local NetworkingFriends = require(ProfilePlatform.Networking.NetworkingFriends)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local refreshProfilePlatform = require(ProfilePlatform.Networking.refreshProfilePlatform)
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags.FFlagMigrateFriendshipStatusesRemainingActions
local friendsStoreChallengeNetwork = require(ProfilePlatform.Networking.friendsStoreChallengeNetwork)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags2.FFlagEnableFriendsStoreChallengeInterceptor
local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()

local USER_FRIENDING_ERRORS = Constants.USER_FRIENDING_ERRORS
local STATUS_CODES = Constants.STATUS_CODES

local function setErrorToast(data, p: string, p2)
	local function getErrorToastMessage(statusCode, p3)
		if p ~= Enums.ProfileActions.AddFriend and p ~= Enums.ProfileActions.AddFriendFromContacts then
			return nil
		end

		if statusCode == STATUS_CODES.BAD_REQUEST then
			return ({
				[USER_FRIENDING_ERRORS.INVALID_TARGET_USER_ERROR] = data.localized.invalidTargetUserError,
				[USER_FRIENDING_ERRORS.ALREADY_FRIEND_ERROR] = data.localized.alreadyFriendError,
				[USER_FRIENDING_ERRORS.MAX_FRIENDS_ERROR] = data.localized.maxFriendsError,
				[USER_FRIENDING_ERRORS.INVALID_NICKNAME_ERROR] = data.localized.invalidNicknameError
			})[p3]
		elseif statusCode == STATUS_CODES.UNAUTHORIZED then
			local unauthorizedErrorsByUNAUTHORIZED_ERROR = {
				[USER_FRIENDING_ERRORS.UNAUTHORIZED_ERROR] = data.localized.unauthorizedError
			}
			return unauthorizedErrorsByUNAUTHORIZED_ERROR[p3]
		elseif statusCode == STATUS_CODES.FORBIDDEN then
			return ({
				[USER_FRIENDING_ERRORS.USER_BANNED_ERROR] = data.localized.userBannedError,
				[USER_FRIENDING_ERRORS.USER_BLOCKED_ERROR] = data.localized.userBlockedError,
				[USER_FRIENDING_ERRORS.USER_NOT_PASSED_CAPTCHA_ERROR] = data.localized.userNotPassedCaptchaError
			})[p3]
		elseif statusCode == STATUS_CODES.TOO_MANY_REQUESTS then
			local tooManyRequestsErrorsByTOO_MANY_REQUESTS_ERROR = {
				[USER_FRIENDING_ERRORS.TOO_MANY_REQUESTS_ERROR] = data.localized.tooManyRequestsError
			}
			return tooManyRequestsErrorsByTOO_MANY_REQUESTS_ERROR[p3]
		end

		return nil
	end

	if p2 == nil then
		data.dispatch(SetCurrentToastMessage({
			toastMessage = data.localized.defaultFriendingError,
			isLocalized = true
		}))

		return
	end

	local statusCode = p2.StatusCode
	local v2

	if p2.Body then
		v2 = HttpService:JSONDecode(p2.Body)
	end

	local v3

	if v2 and v2.errors and v2.errors[1] and v2.errors[1].code then
		v3 = v2.errors[1].code
	end

	local toastMessage = getErrorToastMessage(statusCode, v3) or data.localized.defaultFriendingError
	data.dispatch(SetCurrentToastMessage({ toastMessage = toastMessage, isLocalized = true }))
end

return {
	[Enums.ProfileActions.AddFriend] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddFriend],
			variant = ButtonVariant.Emphasis,
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonAddFriend, {
						buttonSurface = data.buttonSurface,
						absolutePosition = data.profileWrapperContext.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = data.profileWrapperContext.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = data.profileWrapperContext.sourceInfo.isRecommendation,
						source = data.profileWrapperContext.sourceInfo.source,
						contextualInfoType = data.profileWrapperContext.sourceInfo.contextualInfoType,
						recommendationContextType = data.profileWrapperContext.sourceInfo.recommendationContextType,
						recommendationRank = data.profileWrapperContext.sourceInfo.recommendationRank,
						recommendationSessionId = data.profileWrapperContext.sourceInfo.recommendationSessionId
					})

					data.dispatch(SetCurrentToastMessage({
						toastMessage = data.localized.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"],
						isLocalized = true
					}))
					local v2

					if FFlagMigrateFriendshipStatusesRemainingActions then
						local requestFriendship = v.RequestFriendship
						local profileId = data.profileId
						local friendshipOriginSourceType = data.profileWrapperContext.sourceInfo.friendshipOriginSourceType
						local v3

						if FFlagEnableFriendsStoreChallengeInterceptor then
							v3 = friendsStoreChallengeNetwork
						end

						v2 = requestFriendship(profileId, friendshipOriginSourceType, nil, v3)
					else
						v2 = data.dispatch(NetworkingFriends.RequestFriendshipFromUserId.API({
							targetUserId = data.profileId,
							currentUserId = data.localUserId,
							friendshipOriginSourceType = data.profileWrapperContext.sourceInfo.friendshipOriginSourceType
						}))
					end

					return v2:andThen(function()
						return data.dispatch(refreshProfilePlatformActionInfo(
							data.profileId,
							data.actionsComponentRequest
						))
					end):catch(function(p)
						setErrorToast(data, Enums.ProfileActions.AddFriend, p)
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AddFriendFromContacts] = function(data)
		return {
			variant = ButtonVariant.Emphasis,
			text = data.localized[Enums.ProfileActions.AddFriendFromContacts],
			onActivated = {
				[ProfileTypes.Contact] = function()
					data.dispatch(SetCurrentToastMessage({
						toastMessage = data.localized.friendRequestSentToast,
						toastIcon = Images["icons/actions/friends/friendAdd"],
						isLocalized = true
					}))
					local v2

					if FFlagMigrateFriendshipStatusesRemainingActions then
						local requestFriendship = v.RequestFriendship
						local profileId = data.profileId
						local v3

						if FFlagEnableFriendsStoreChallengeInterceptor then
							v3 = friendsStoreChallengeNetwork
						end

						v2 = requestFriendship(profileId, nil, { isContact = true }, v3)
					else
						v2 = data.dispatch(NetworkingFriends.RequestFriendshipFromContactId.API({
							currentUserId = data.localUserId,
							contactId = data.profileId,
							contextType = ContextualInfoTypes.Contacts
						}))
					end

					return v2:andThen(function()
						return data.dispatch(refreshProfilePlatform({
							profileType = data.profileType,
							profileId = data.profileId,
							components = {
								Enums.Components.ContactProfileHeader,
								Enums.Components.Actions,
								Enums.Components.ContactDescription
							}
						}))
					end):catch(function(p)
						setErrorToast(data, Enums.ProfileActions.AddFriendFromContacts, p)
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AddFriendFromContactsSent] = function(p)
		return {
			variant = ButtonVariant.Subtle,
			text = p.localized[Enums.ProfileActions.AddFriendFromContactsSent],
			onActivated = {
				[ProfileTypes.Contact] = function() end
			},
			isDisabled = true
		}
	end,
	[Enums.ProfileActions.CannotAddFriend] = function(p)
		return {
			text = p.localized[Enums.ProfileActions.CannotAddFriend],
			onActivated = {
				[ProfileTypes.User] = function() end
			},
			isDisabled = true
		}
	end
}
