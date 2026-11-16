local HttpService = game:GetService("HttpService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon")

local images = UIBlox.App.ImageSet.Images
local buttonVariant = Foundation.Enums.ButtonVariant
local contextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local GroupsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/GroupsNetworking")
local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local refreshProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatform")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local fFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagMigrateFriendshipStatusesRemainingActions
local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration").Friends.FriendsStore.get()

local USER_FRIENDING_ERRORS = Constants.USER_FRIENDING_ERRORS
local STATUS_CODES = Constants.STATUS_CODES

local function setErrorToast(data, p2, p3)
	local function getErrorToastMessage(statusCode, p4)
		if
			p2 ~= Enums.ProfileActions.AddFriend
			and p2 ~= Enums.ProfileActions.AddFriendFromContacts
		then
			return nil
		end

		if statusCode == STATUS_CODES.BAD_REQUEST then
			return ({
				[USER_FRIENDING_ERRORS.INVALID_TARGET_USER_ERROR] = data.localized.invalidTargetUserError,
				[USER_FRIENDING_ERRORS.ALREADY_FRIEND_ERROR] = data.localized.alreadyFriendError,
				[USER_FRIENDING_ERRORS.MAX_FRIENDS_ERROR] = data.localized.maxFriendsError,
				[USER_FRIENDING_ERRORS.INVALID_NICKNAME_ERROR] = data.localized.invalidNicknameError
			})[p4]
		elseif statusCode == STATUS_CODES.UNAUTHORIZED then
			local unauthorizedErrorsByUNAUTHORIZED_ERROR = {
				[USER_FRIENDING_ERRORS.UNAUTHORIZED_ERROR] = data.localized.unauthorizedError
			}
			return unauthorizedErrorsByUNAUTHORIZED_ERROR[p4]
		elseif statusCode == STATUS_CODES.FORBIDDEN then
			return ({
				[USER_FRIENDING_ERRORS.USER_BANNED_ERROR] = data.localized.userBannedError,
				[USER_FRIENDING_ERRORS.USER_BLOCKED_ERROR] = data.localized.userBlockedError,
				[USER_FRIENDING_ERRORS.USER_NOT_PASSED_CAPTCHA_ERROR] = data.localized.userNotPassedCaptchaError
			})[p4]
		elseif statusCode == STATUS_CODES.TOO_MANY_REQUESTS then
			local tooManyRequestsErrorsByTOO_MANY_REQUESTS_ERROR = {
				[USER_FRIENDING_ERRORS.TOO_MANY_REQUESTS_ERROR] = data.localized.tooManyRequestsError
			}
			return tooManyRequestsErrorsByTOO_MANY_REQUESTS_ERROR[p4]
		end

		return nil
	end

	if p3 == nil then
		data.dispatch(setCurrentToastMessage({
			toastMessage = data.localized.defaultFriendingError,
			isLocalized = true
		}))

		return
	end

	local statusCode = p3.StatusCode
	local v6 = if p3.Body then HttpService:JSONDecode(p3.Body) else nil

	local v7 = if v6 and v6.errors and v6.errors[1] and v6.errors[1].code then v6.errors[1].code else nil

	local v8 = getErrorToastMessage(statusCode, v7) or data.localized.defaultFriendingError
	data.dispatch(setCurrentToastMessage({ toastMessage = v8, isLocalized = true }))
end

return {
	[Enums.ProfileActions.AddFriend] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddFriend],
			variant = buttonVariant.Emphasis,
			onActivated = {
				[profileTypes.User] = function()
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

					data.dispatch(setCurrentToastMessage({
						toastMessage = data.localized.friendRequestSentToast,
						toastIcon = images["icons/actions/friends/friendAdd"],
						isLocalized = true
					}))
					local v9

					if fFlagMigrateFriendshipStatusesRemainingActions then
						local requestFriendship = v5.RequestFriendship
						local profileId = data.profileId
						local friendshipOriginSourceType = data.profileWrapperContext.sourceInfo.friendshipOriginSourceType
						local v11 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
						v9 = requestFriendship(profileId, friendshipOriginSourceType, nil, v11)
					else
						v9 = data.dispatch(GroupsNetworking.RequestFriendshipFromUserId.API({
							targetUserId = data.profileId,
							currentUserId = data.localUserId,
							friendshipOriginSourceType = data.profileWrapperContext.sourceInfo.friendshipOriginSourceType
						}))
					end

					return v9:andThen(function()
						return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
					end):catch(function(p2)
						setErrorToast(data, Enums.ProfileActions.AddFriend, p2)
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AddFriendFromContacts] = function(data)
		return {
			variant = buttonVariant.Emphasis,
			text = data.localized[Enums.ProfileActions.AddFriendFromContacts],
			onActivated = {
				[profileTypes.Contact] = function()
					data.dispatch(setCurrentToastMessage({
						toastMessage = data.localized.friendRequestSentToast,
						toastIcon = images["icons/actions/friends/friendAdd"],
						isLocalized = true
					}))
					local v9

					if fFlagMigrateFriendshipStatusesRemainingActions then
						local requestFriendship = v5.RequestFriendship
						local profileId = data.profileId
						local v12 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
						v9 = requestFriendship(profileId, nil, { isContact = true }, v12)
					else
						v9 = data.dispatch(GroupsNetworking.RequestFriendshipFromContactId.API({
							currentUserId = data.localUserId,
							contactId = data.profileId,
							contextType = contextualInfoTypes.Contacts
						}))
					end

					return v9:andThen(function()
						return data.dispatch(refreshProfilePlatform({
							profileType = data.profileType,
							profileId = data.profileId,
							components = {
								Enums.Components.ContactProfileHeader,
								Enums.Components.Actions,
								Enums.Components.ContactDescription
							}
						}))
					end):catch(function(p2)
						setErrorToast(data, Enums.ProfileActions.AddFriendFromContacts, p2)
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AddFriendFromContactsSent] = function(p2)
		return {
			variant = buttonVariant.Subtle,
			text = p2.localized[Enums.ProfileActions.AddFriendFromContactsSent],
			onActivated = {
				[profileTypes.Contact] = function() end
			},
			isDisabled = true
		}
	end,
	[Enums.ProfileActions.CannotAddFriend] = function(p2)
		return {
			text = p2.localized[Enums.ProfileActions.CannotAddFriend],
			onActivated = {
				[profileTypes.User] = function() end
			},
			isDisabled = true
		}
	end
}
