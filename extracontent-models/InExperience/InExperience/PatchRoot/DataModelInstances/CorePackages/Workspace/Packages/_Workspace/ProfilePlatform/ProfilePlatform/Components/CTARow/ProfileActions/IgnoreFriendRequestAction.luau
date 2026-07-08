local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Images = require(ProfilePlatformParent.UIBlox).App.ImageSet.Images
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local NetworkingFriends = require(ProfilePlatform.Networking.NetworkingFriends)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.IgnoreFriendRequest] = function(p1) -- line: 17
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), NetworkingFriends (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p1.localized[Enums.ProfileActions.IgnoreFriendRequest],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 21
					-- upvalues: p1 (copy), EventNames (copy), NetworkingFriends (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonIgnoreFriendRequest, {
						buttonSurface = p1.buttonSurface
					})

					return p1.dispatch(NetworkingFriends.DeclineFriendRequestFromUserId.API({
						targetUserId = p1.profileId,
						currentUserId = p1.localUserId
					})):andThen(function() -- line: 30
						-- upvalues: p1 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
						p1.dispatch(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = p1.localized.friendRequestIgnoredToast,
							toastIcon = Images["icons/actions/reject"]
						}))

						return p1.dispatch(refreshProfilePlatformActionInfo(p1.profileId, p1.actionsComponentRequest))
					end)
				end
			}
		}
	end
}
