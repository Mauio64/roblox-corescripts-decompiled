local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums")

local buttonVariant = Foundation.Enums.ButtonVariant
local images = UIBlox.App.ImageSet.Images
local appPage = RobloxAppEnums.AppPage

local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local NetworkingCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingCatalog")
local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local profileTypes = Enums.ProfileTypes

local USER_BLOCKING_ERRORS = Constants.USER_BLOCKING_ERRORS

return {
	[Enums.ProfileActions.Block] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.Block],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonBlock, {
						buttonSurface = data.buttonSurface
					})

					data.navigation.push(appPage.BlockingModal, {
						navProps = {
							userId = data.profileId,
							onBlockSuccess = function()
								data.dispatch(setCurrentToastMessage({
									toastMessage = data.localized.userBlockedToast,
									toastIcon = images["icons/actions/block"],
									isLocalized = true
								}))

								data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
							end
						}
					})
				end
			}
		}
	end,
	[Enums.ProfileActions.Unblock] = function(data)
		return {
			variant = buttonVariant.Standard,
			text = data.localized[Enums.ProfileActions.Unblock],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonUnblock, {
						buttonSurface = data.buttonSurface
					})

					return data.dispatch(NetworkingCatalog.UnblockUserById.API({
						userId = data.profileId,
						currentUserId = data.localUserId
					})):andThen(function()
						return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
					end):catch(function(p2)
						if
							p2 ~= nil
							and tonumber(p2.Body) == USER_BLOCKING_ERRORS.PARENT_BLOCKED_TARGET_USER_ERROR
						then
							data.dispatch(setCurrentToastMessage({
								toastMessage = data.localized.unblockTargetParentManagedToast,
								isLocalized = true
							}))
						elseif
							p2 ~= nil
							and tonumber(p2.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_NOT_BLOCKED_ERROR
						then
							data.dispatch(setCurrentToastMessage({
								toastMessage = data.localized.unblockTargetNotBlockedToast,
								isLocalized = true
							}))
						elseif
							p2 == nil
							or tonumber(p2.Body) ~= USER_BLOCKING_ERRORS.UNBLOCK_TARGET_BLOCKED_ON_PLATFORM
						then
							data.dispatch(setCurrentToastMessage({
								toastMessage = data.localized.somethingIsWrongToast,
								isLocalized = true
							}))
						else
							data.dispatch(setCurrentToastMessage({
								toastMessage = data.localized.blockedOnPlatformToast,
								isLocalized = true
							}))
						end
					end)
				end
			}
		}
	end
}
