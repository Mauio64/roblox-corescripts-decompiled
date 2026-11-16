local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialFollowAttribution = SharedFlags.FFlagSocialFollowAttribution
local FollowAttribution

if FFlagSocialFollowAttribution then
	FollowAttribution = require(parent.SocialCommon.FollowAttribution)
else
	FollowAttribution = nil
end

local ButtonVariant = Foundation.Enums.ButtonVariant

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local GroupsNetworking = require(ProfilePlatform.Networking.GroupsNetworking)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableUserFollow = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUserFollow)
local Following = require(parent.DataHydration.Following)
local FollowingStore = Following.FollowingStore
local FollowingUpdateErrorTypeEnum = Following.FollowingUpdateErrorTypeEnum
local GenericChallenges = require(parent.GenericChallenges)
local createChallengeNetwork = GenericChallenges.Middleware.createChallengeNetwork

local function handleUpdateUserFollowStatus(data, callback, toastMessage: string, callback2)
	return callback(data.profileId, createChallengeNetwork()):andThen(function()
		if FFlagSocialFollowAttribution and callback2 then
			callback2()
		end

		data.dispatch(SetCurrentToastMessage({ toastMessage = toastMessage, isLocalized = true }))

		return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
	end, function(p)
		local dispatch = data.dispatch
		local toastMessage2

		if p == nil or p.errorType ~= FollowingUpdateErrorTypeEnum.Captcha then
			toastMessage2 = data.localized.somethingIsWrongToast
		else
			toastMessage2 = data.localized.userNotPassedCaptchaError
		end

		dispatch(SetCurrentToastMessage({ toastMessage = toastMessage2, isLocalized = true }))
	end)
end

return {
	[Enums.ProfileActions.Follow] = function(data)
		return {
			variant = ButtonVariant.Standard,
			text = data.localized[Enums.ProfileActions.Follow],
			onActivated = {
				[ProfileTypes.User] = FFlagProfilePlatformEnableUserFollow and function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = data.buttonSurface
					})

					return handleUpdateUserFollowStatus(
						data,
						FollowingStore.get().Follow,
						data.localized.followedToast,
						FFlagSocialFollowAttribution and function()
							FollowAttribution.reportFollowSuccess({
								surface = FollowAttribution.Surface.Profile,
								source = data.profileWrapperContext.sourceInfo.source
							})
						end or nil
					)
				end or nil,
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = data.buttonSurface
					})

					return data.dispatch(GroupsNetworking.JoinGroup.API({ groupId = data.profileId })):andThen(function()
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
		if data.profileType == ProfileTypes.Community and data.viewerOwnsOpenCommunity then
			return nil
		end

		return {
			text = data.localized[Enums.ProfileActions.Unfollow],
			onActivated = {
				[ProfileTypes.User] = FFlagProfilePlatformEnableUserFollow and function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = data.buttonSurface
					})

					return handleUpdateUserFollowStatus(
						data,
						FollowingStore.get().Unfollow,
						data.localized.unfollowedToast
					)
				end or nil,
				[ProfileTypes.Community] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = data.buttonSurface
					})

					return data.dispatch(GroupsNetworking.LeaveGroup.API({
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
