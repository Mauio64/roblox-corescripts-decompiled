local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local ButtonVariant = Foundation.Enums.ButtonVariant

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local NetworkingFriends = require(ProfilePlatform.Networking.NetworkingFriends)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags.FFlagMigrateFriendshipStatusesRemainingActions
local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()

return {
	[Enums.ProfileActions.AcceptFriendRequest] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.AcceptFriendRequest],
			variant = ButtonVariant.Emphasis,
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonAcceptFriendRequest, {
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
					local v2

					if FFlagMigrateFriendshipStatusesRemainingActions then
						v2 = v.AcceptFriendRequest(data.profileId)
					else
						v2 = data.dispatch(NetworkingFriends.AcceptFriendRequestFromUserId.API({
							targetUserId = data.profileId,
							currentUserId = data.localUserId
						}))
					end

					return v2:andThen(function()
						data.dispatch(SetCurrentToastMessage({
							toastMessage = data.localized.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"],
							isLocalized = true
						}))

						return data.dispatch(refreshProfilePlatformActionInfo(
							data.profileId,
							data.actionsComponentRequest
						))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.AcceptOffNetworkFriendRequest],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonAddFriendFromContacts, {
						shareLinkId = data.profileWrapperContext.sourceInfo.shareLinkId
					})

					return data.dispatch(NetworkingFriends.AcceptFriendRequestWithToken.API({
						targetUserId = data.profileId,
						currentUserId = data.localUserId,
						friendingToken = data.profileWrapperContext.offNetworkFriendRequestToken
					})):andThen(function()
						data.dispatch(SetCurrentToastMessage({
							toastMessage = data.localized.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"],
							isLocalized = true
						}))

						return data.dispatch(refreshProfilePlatformActionInfo(
							data.profileId,
							data.actionsComponentRequest
						))
					end)
				end
			}
		}
	end
}
