local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local RobloxAppEnums = require(ProfilePlatformParent.RobloxAppEnums)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Images = UIBlox.App.ImageSet.Images
local AppPage = RobloxAppEnums.AppPage
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local myUserBlockingNetworking = require(ProfilePlatform.Networking.myUserBlockingNetworking)
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local Constants = require(ProfilePlatform.Common.Constants)
local ProfileTypes = Enums.ProfileTypes
local USER_BLOCKING_ERRORS = Constants.USER_BLOCKING_ERRORS

return {
	[Enums.ProfileActions.Block] = function(p1) -- line: 24
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), AppPage (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p1.localized[Enums.ProfileActions.Block],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 28
					-- upvalues: p1 (copy), EventNames (copy), AppPage (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonBlock, {
						buttonSurface = p1.buttonSurface
					})
					p1.navigation.push(AppPage.BlockingModal, {
						navProps = {
							userId = p1.profileId,
							onBlockSuccess = function() -- line: 35
								-- upvalues: p1 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
								p1.dispatch(SetCurrentToastMessage({
									isLocalized = true,
									toastMessage = p1.localized.userBlockedToast,
									toastIcon = Images["icons/actions/block"]
								}))
								p1.dispatch(refreshProfilePlatformActionInfo(p1.profileId, p1.actionsComponentRequest))
							end
						}
					})
				end
			}
		}
	end,
	[Enums.ProfileActions.Unblock] = function(p2) -- line: 53
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), myUserBlockingNetworking (copy), refreshProfilePlatformActionInfo (copy), USER_BLOCKING_ERRORS (copy), SetCurrentToastMessage (copy)
		return {
			variant = ButtonVariant.Standard,
			text = p2.localized[Enums.ProfileActions.Unblock],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 58
					-- upvalues: p2 (copy), EventNames (copy), myUserBlockingNetworking (copy), refreshProfilePlatformActionInfo (copy), USER_BLOCKING_ERRORS (copy), SetCurrentToastMessage (copy)
					p2.analytics.fireAnalyticsEvent(EventNames.CTAButtonUnblock, {
						buttonSurface = p2.buttonSurface
					})

					return p2.dispatch(myUserBlockingNetworking.UnblockUserById.API({
						userId = p2.profileId,
						currentUserId = p2.localUserId
					})):andThen(function() -- line: 67
						-- upvalues: p2 (copy), refreshProfilePlatformActionInfo (copy)
						return p2.dispatch(refreshProfilePlatformActionInfo(p2.profileId, p2.actionsComponentRequest))
					end):catch(function(p3) -- line: 72
						-- upvalues: USER_BLOCKING_ERRORS (copy), p2 (copy), SetCurrentToastMessage (copy)
						if p3 ~= nil and tonumber(p3.Body) == USER_BLOCKING_ERRORS.PARENT_BLOCKED_TARGET_USER_ERROR then
							p2.dispatch(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = p2.localized.unblockTargetParentManagedToast
							}))

							return
						end

						if p3 ~= nil and tonumber(p3.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_NOT_BLOCKED_ERROR then
							p2.dispatch(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = p2.localized.unblockTargetNotBlockedToast
							}))

							return
						end

						if p3 ~= nil and tonumber(p3.Body) == USER_BLOCKING_ERRORS.UNBLOCK_TARGET_BLOCKED_ON_PLATFORM then
							p2.dispatch(SetCurrentToastMessage({
								isLocalized = true,
								toastMessage = p2.localized.blockedOnPlatformToast
							}))

							return
						end

						p2.dispatch(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = p2.localized.somethingIsWrongToast
						}))
					end)
				end
			}
		}
	end
}
