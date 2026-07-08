local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
local Images = require(ProfilePlatformParent.UIBlox).App.ImageSet.Images
local ButtonVariant = Foundation.Enums.ButtonVariant
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local NetworkingFriends = require(ProfilePlatform.Networking.NetworkingFriends)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.AcceptFriendRequest] = function(p1) -- line: 19
		-- upvalues: Enums (copy), ButtonVariant (copy), ProfileTypes (copy), EventNames (copy), NetworkingFriends (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p1.localized[Enums.ProfileActions.AcceptFriendRequest],
			variant = ButtonVariant.Emphasis,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 24
					-- upvalues: p1 (copy), EventNames (copy), Enums (copy), NetworkingFriends (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonAcceptFriendRequest, {
						buttonSurface = p1.buttonSurface,
						absolutePosition = p1.profileWrapperContext.sourceInfo.homepageCarouselAbsolutePosition,
						isHomePageCarousel = p1.profileWrapperContext.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
						isRecommendation = p1.profileWrapperContext.sourceInfo.isRecommendation,
						source = p1.profileWrapperContext.sourceInfo.source,
						contextualInfoType = p1.profileWrapperContext.sourceInfo.contextualInfoType,
						recommendationContextType = p1.profileWrapperContext.sourceInfo.recommendationContextType,
						recommendationRank = p1.profileWrapperContext.sourceInfo.recommendationRank,
						recommendationSessionId = p1.profileWrapperContext.sourceInfo.recommendationSessionId
					})

					return p1.dispatch(NetworkingFriends.AcceptFriendRequestFromUserId.API({
						targetUserId = p1.profileId,
						currentUserId = p1.localUserId
					})):andThen(function() -- line: 42
						-- upvalues: p1 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
						p1.dispatch(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = p1.localized.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return p1.dispatch(refreshProfilePlatformActionInfo(p1.profileId, p1.actionsComponentRequest))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = function(p2) -- line: 57
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), NetworkingFriends (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p2.localized[Enums.ProfileActions.AcceptOffNetworkFriendRequest],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 61
					-- upvalues: p2 (copy), EventNames (copy), NetworkingFriends (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
					p2.analytics.fireAnalyticsEvent(EventNames.CTAButtonAddFriendFromContacts, {
						shareLinkId = p2.profileWrapperContext.sourceInfo.shareLinkId
					})

					return p2.dispatch(NetworkingFriends.AcceptFriendRequestWithToken.API({
						targetUserId = p2.profileId,
						currentUserId = p2.localUserId,
						friendingToken = p2.profileWrapperContext.offNetworkFriendRequestToken
					})):andThen(function() -- line: 71
						-- upvalues: p2 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
						p2.dispatch(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = p2.localized.friendAcceptedToast,
							toastIcon = Images["icons/actions/friends/friendAdd"]
						}))

						return p2.dispatch(refreshProfilePlatformActionInfo(p2.profileId, p2.actionsComponentRequest))
					end)
				end
			}
		}
	end
}
