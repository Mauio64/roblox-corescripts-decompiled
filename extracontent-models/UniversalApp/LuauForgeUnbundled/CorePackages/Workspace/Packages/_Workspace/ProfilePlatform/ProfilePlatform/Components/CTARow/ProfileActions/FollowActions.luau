local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local fFlagSocialFollowAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialFollowAttribution

local v5 = if fFlagSocialFollowAttribution then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon/FollowAttribution") else nil

local buttonVariant = Foundation.Enums.ButtonVariant

local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingFriends")
local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")
local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local getAvailableCommunityComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getAvailableCommunityComponents")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableUserFollow = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableUserFollow")
local Following = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/Following")
local followingStore = Following.FollowingStore
local followingUpdateErrorTypeEnum = Following.FollowingUpdateErrorTypeEnum
local createChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GenericChallenges").Middleware.createChallengeNetwork

local function handleUpdateUserFollowStatus(data, callback, p2, callback2)
	return callback(data.profileId, createChallengeNetwork()):andThen(function()
		if fFlagSocialFollowAttribution and callback2 then
			callback2()
		end

		data.dispatch(setCurrentToastMessage({ toastMessage = p2, isLocalized = true }))

		return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
	end, function(p3)
		local dispatch = data.dispatch
		local v8 = if p3 == nil or p3.errorType ~= followingUpdateErrorTypeEnum.Captcha then data.localized.somethingIsWrongToast else data.localized.userNotPassedCaptchaError
		dispatch(setCurrentToastMessage({ toastMessage = v8, isLocalized = true }))
	end)
end

return {
	[Enums.ProfileActions.Follow] = function(data)
		return {
			variant = buttonVariant.Standard,
			text = data.localized[Enums.ProfileActions.Follow],
			onActivated = {
				[profileTypes.User] = FFlagProfilePlatformEnableUserFollow and function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = data.buttonSurface
					})

					return handleUpdateUserFollowStatus(
						data,
						followingStore.get().Follow,
						data.localized.followedToast,
						fFlagSocialFollowAttribution and function()
							v5.reportFollowSuccess({
								surface = v5.Surface.Profile,
								source = data.profileWrapperContext.sourceInfo.source
							})
						end or nil
					)
				end or nil,
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = data.buttonSurface
					})

					return data.dispatch(NetworkingFriends.JoinGroup.API({
						groupId = data.profileId
					})):andThen(function()
						data.dispatch(getProfilePlatform.API({
							profileType = data.profileType,
							profileId = data.profileId,
							components = getAvailableCommunityComponents(),
							includeComponentOrdering = true
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.Unfollow] = function(data)
		if data.profileType == profileTypes.Community and data.viewerOwnsOpenCommunity then
			return nil
		end

		return {
			text = data.localized[Enums.ProfileActions.Unfollow],
			onActivated = {
				[profileTypes.User] = FFlagProfilePlatformEnableUserFollow and function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = data.buttonSurface
					})

					return handleUpdateUserFollowStatus(
						data,
						followingStore.get().Unfollow,
						data.localized.unfollowedToast
					)
				end or nil,
				[profileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = data.buttonSurface
					})

					return data.dispatch(NetworkingFriends.LeaveGroup.API({
						groupId = data.profileId,
						userId = data.localUserId
					})):andThen(function()
						data.dispatch(getProfilePlatform.API({
							profileType = data.profileType,
							profileId = data.profileId,
							components = getAvailableCommunityComponents(),
							includeComponentOrdering = true
						}))
					end)
				end
			}
		}
	end
}
