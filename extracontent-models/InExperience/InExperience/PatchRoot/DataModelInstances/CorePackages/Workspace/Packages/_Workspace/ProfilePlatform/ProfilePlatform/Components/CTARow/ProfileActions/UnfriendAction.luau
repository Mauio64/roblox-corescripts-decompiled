local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local UIBlox = require(parent.UIBlox)

local Images = UIBlox.App.ImageSet.Images

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
	[Enums.ProfileActions.Unfriend] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.Unfriend],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfriend, {
						buttonSurface = data.buttonSurface
					})
					local v2

					if FFlagMigrateFriendshipStatusesRemainingActions then
						v2 = v.Unfriend(data.profileId)
					else
						v2 = data.dispatch(NetworkingFriends.UnfriendTargetUserId.API({
							targetUserId = data.profileId,
							currentUserId = data.localUserId
						}))
					end

					return v2:andThen(function()
						data.dispatch(SetCurrentToastMessage({
							toastMessage = data.localized.friendRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"],
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
