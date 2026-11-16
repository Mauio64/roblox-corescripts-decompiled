local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local UIBlox = require(parent.UIBlox)
local SharedFlags = require(parent.SharedFlags)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local DataHydration = require(parent.DataHydration)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local Images = UIBlox.App.ImageSet.Images
local AppPage = RobloxAppEnums.AppPage
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local FFlagFixTFLinksVRGating = require(ProfilePlatform.Flags.FFlagFixTFLinksVRGating)
local FFlagProfileTFCardUseQrScanContext = SharedFlags.FFlagProfileTFCardUseQrScanContext

local v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

return {
	[Enums.ProfileActions.RemoveTrustedConnection] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.RemoveTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemoveTrustedConnection, {
						buttonSurface = data.buttonSurface
					})

					return v.removeTrustedConnectionRequest(data.profileId):andThen(function()
						data.dispatch(SetCurrentToastMessage({
							toastMessage = data.localized.trustedConnectionRemovedToast,
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
	end,
	[Enums.ProfileActions.AddTrustedConnection] = FFlagProfilePlatformAddTC and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = data.buttonSurface
					})

					local props = {
						userId = data.profileId,
						source = Sources.ProfilePlatform,
						onRequestSent = function()
							return data.dispatch(refreshProfilePlatformActionInfo(
								data.profileId,
								data.actionsComponentRequest
							))
						end
					}

					if
						FFlagProfileTFCardUseQrScanContext
						and data.profileWrapperContext.sourceInfo.source == Enums.Sources.QrCode
					then
						props.sentFromQrCode = true
					end

					data.navigation.push(AppPage.TrustedContactsModal, { props = props })
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.AddTrustedConnectionViaLink] = not FFlagFixTFLinksVRGating and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = data.buttonSurface,
						modalVariantOverride = Sources.ShareLinkSender
					})

					data.navigation.push(AppPage.TrustedContactsModal, {
						props = {
							userId = data.profileId,
							source = Sources.ProfilePlatform,
							modalVariantOverride = Sources.ShareLinkSender,
							onRequestSent = function()
								return data.dispatch(refreshProfilePlatformActionInfo(
									data.profileId,
									data.actionsComponentRequest
								))
							end
						}
					})
				end
			}
		}
	end or FFlagProfilePlatformAddTC and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = data.buttonSurface,
						modalVariantOverride = Sources.ShareLinkSender
					})

					local props = {
						userId = data.profileId,
						source = Sources.ProfilePlatform,
						modalVariantOverride = Sources.ShareLinkSender,
						onRequestSent = function()
							return data.dispatch(refreshProfilePlatformActionInfo(
								data.profileId,
								data.actionsComponentRequest
							))
						end
					}

					if
						FFlagProfileTFCardUseQrScanContext
						and data.profileWrapperContext.sourceInfo.source == Enums.Sources.QrCode
					then
						props.sentFromQrCode = true
					end

					data.navigation.push(AppPage.TrustedContactsModal, { props = props })
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.AddIncomingTrustedConnection] = FFlagProfilePlatformAddTC and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddIncomingTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddIncomingTrustedConnection, {
						buttonSurface = data.buttonSurface
					})

					data.navigation.push(AppPage.TrustedContactsModal, {
						props = {
							userId = data.profileId,
							onRequestAccepted = function()
								return data.dispatch(refreshProfilePlatformActionInfo(
									data.profileId,
									data.actionsComponentRequest
								))
							end
						}
					})
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.PendingTrustedConnection] = FFlagProfilePlatformAddTC and function(p)
		return {
			text = p.localized[Enums.ProfileActions.AddTrustedConnection],
			isDisabled = true,
			onActivated = {
				[ProfileTypes.User] = function() end
			}
		}
	end or nil,
	[Enums.ProfileActions.PendingIncomingTrustedConnection] = function(p)
		return {
			text = p.localized[Enums.ProfileActions.AddIncomingTrustedConnection],
			isDisabled = true,
			onActivated = {
				[ProfileTypes.User] = function() end
			}
		}
	end
}
