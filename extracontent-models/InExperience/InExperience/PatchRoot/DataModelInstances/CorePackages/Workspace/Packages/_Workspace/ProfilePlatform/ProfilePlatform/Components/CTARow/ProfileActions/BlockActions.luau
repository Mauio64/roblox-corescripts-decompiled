local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local ButtonVariant = Foundation.Enums.ButtonVariant
local Images = UIBlox.App.ImageSet.Images
local AppPage = RobloxAppEnums.AppPage

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local myUserBlockingNetworking = require(ProfilePlatform.Networking.myUserBlockingNetworking)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Constants = require(ProfilePlatform.Common.Constants)
local ProfileTypes = Enums.ProfileTypes

local USER_BLOCKING_ERRORS = Constants.USER_BLOCKING_ERRORS

return {
	[Enums.ProfileActions.Block] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.Block],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonBlock, {
						buttonSurface = data.buttonSurface
					})

					data.navigation.push(AppPage.BlockingModal, {
						navProps = {
							userId = data.profileId,
							onBlockSuccess = function()
								data.dispatch(SetCurrentToastMessage({
									toastMessage = data.localized.userBlockedToast,
									toastIcon = Images["icons/actions/block"],
									isLocalized = true
								}))

								data.dispatch(refreshProfilePlatformActionInfo(
									data.profileId,
									data.actionsComponentRequest
								))
							end
						}
					})
				end
			}
		}
	end,
	[Enums.ProfileActions.Unblock] = function(data)
		return {
			variant = ButtonVariant.Standard,
			text = data.localized[Enums.ProfileActions.Unblock],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonUnblock, {
						buttonSurface = data.buttonSurface
					})

					return data.dispatch(myUserBlockingNetworking.UnblockUserById.API({
						userId = data.profileId,
						currentUserId = data.localUserId
					})):andThen(function()
						return data.dispatch(refreshProfilePlatformActionInfo(
							data.profileId,
							data.actionsComponentRequest
						))
					end):catch(function(p)
						if p ~= nil and tonumber(p.Body) == USER_BLOCKING_ERRORS.PARENT_BLOCKED_TARGET_USER_ERROR then
							data.dispatch(SetCurrentToastMessage({
								toastMessage = data.localized.unblockTargetParentManagedToast,
								isLocalized = true
							}))
						elseif
							p ~= nil
							and tonumber(p.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_NOT_BLOCKED_ERROR
						then
							data.dispatch(SetCurrentToastMessage({
								toastMessage = data.localized.unblockTargetNotBlockedToast,
								isLocalized = true
							}))
						elseif
							p == nil
							or tonumber(p.Body) ~= USER_BLOCKING_ERRORS.UNBLOCK_TARGET_BLOCKED_ON_PLATFORM
						then
							data.dispatch(SetCurrentToastMessage({
								toastMessage = data.localized.somethingIsWrongToast,
								isLocalized = true
							}))
						else
							data.dispatch(SetCurrentToastMessage({
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
