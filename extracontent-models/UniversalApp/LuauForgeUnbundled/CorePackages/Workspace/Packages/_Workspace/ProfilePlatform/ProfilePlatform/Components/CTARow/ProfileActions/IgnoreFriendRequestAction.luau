local images = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.ImageSet.Images

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
	[Enums.ProfileActions.IgnoreFriendRequest] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.IgnoreFriendRequest],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonIgnoreFriendRequest, {
						buttonSurface = data.buttonSurface
					})
					local v9

					if fFlagMigrateFriendshipStatusesRemainingActions then
						v9 = v5.DeclineFriendRequest(data.profileId)
					else
						v9 = data.dispatch(GroupsNetworking.DeclineFriendRequestFromUserId.API({
							targetUserId = data.profileId,
							currentUserId = data.localUserId
						}))
					end

					return v9:andThen(function()
						data.dispatch(setCurrentToastMessage({
							toastMessage = data.localized.friendRequestIgnoredToast,
							toastIcon = images["icons/actions/reject"],
							isLocalized = true
						}))

						return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
					end)
				end
			}
		}
	end
}
