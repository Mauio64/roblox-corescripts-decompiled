local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.ImageSet.Images
local buttonVariant = Foundation.Enums.ButtonVariant

local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local GroupsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/GroupsNetworking")
local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local fFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagMigrateFriendshipStatusesRemainingActions
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration").Friends.FriendsStore.get()

return {
	[Enums.ProfileActions.AcceptFriendRequest] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.AcceptFriendRequest],
			variant = buttonVariant.Emphasis,
			onActivated = {
				[profileTypes.User] = function()
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
					local v9

					if fFlagMigrateFriendshipStatusesRemainingActions then
						v9 = v5.AcceptFriendRequest(data.profileId)
					else
						v9 = data.dispatch(GroupsNetworking.AcceptFriendRequestFromUserId.API({
							targetUserId = data.profileId,
							currentUserId = data.localUserId
						}))
					end

					return v9:andThen(function()
						data.dispatch(setCurrentToastMessage({
							toastMessage = data.localized.friendAcceptedToast,
							toastIcon = images["icons/actions/friends/friendAdd"],
							isLocalized = true
						}))

						return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.AcceptOffNetworkFriendRequest],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonAddFriendFromContacts, {
						shareLinkId = data.profileWrapperContext.sourceInfo.shareLinkId
					})

					return data.dispatch(GroupsNetworking.AcceptFriendRequestWithToken.API({
						targetUserId = data.profileId,
						currentUserId = data.localUserId,
						friendingToken = data.profileWrapperContext.offNetworkFriendRequestToken
					})):andThen(function()
						data.dispatch(setCurrentToastMessage({
							toastMessage = data.localized.friendAcceptedToast,
							toastIcon = images["icons/actions/friends/friendAdd"],
							isLocalized = true
						}))

						return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
					end)
				end
			}
		}
	end
}
