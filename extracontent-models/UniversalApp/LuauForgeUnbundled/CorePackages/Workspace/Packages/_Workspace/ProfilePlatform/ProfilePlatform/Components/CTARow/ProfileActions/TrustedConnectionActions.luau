local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics")

local images = UIBlox.App.ImageSet.Images
local appPage = RobloxAppEnums.AppPage
local sources = SocialLuaAnalytics.Analytics.Enums.Sources

local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local refreshProfilePlatformActionInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local fFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local FFlagFixTFLinksVRGating = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagFixTFLinksVRGating")
local fFlagProfileTFCardUseQrScanContext = SharedFlags.FFlagProfileTFCardUseQrScanContext

local v5 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

return {
	[Enums.ProfileActions.RemoveTrustedConnection] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.RemoveTrustedConnection],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemoveTrustedConnection, {
						buttonSurface = data.buttonSurface
					})

					return v5.removeTrustedConnectionRequest(data.profileId):andThen(function()
						data.dispatch(setCurrentToastMessage({
							toastMessage = data.localized.trustedConnectionRemovedToast,
							toastIcon = images["icons/actions/friends/friendRemove"],
							isLocalized = true
						}))

						return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AddTrustedConnection] = fFlagProfilePlatformAddTC and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = data.buttonSurface
					})

					local v9 = {
						userId = data.profileId,
						source = sources.ProfilePlatform,
						onRequestSent = function()
							return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
						end
					}

					if
						fFlagProfileTFCardUseQrScanContext
						and data.profileWrapperContext.sourceInfo.source == Enums.Sources.QrCode
					then
						v9.sentFromQrCode = true
					end

					data.navigation.push(appPage.TrustedContactsModal, { props = v9 })
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.AddTrustedConnectionViaLink] = not FFlagFixTFLinksVRGating and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = data.buttonSurface,
						modalVariantOverride = sources.ShareLinkSender
					})

					data.navigation.push(appPage.TrustedContactsModal, {
						props = {
							userId = data.profileId,
							source = sources.ProfilePlatform,
							modalVariantOverride = sources.ShareLinkSender,
							onRequestSent = function()
								return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
							end
						}
					})
				end
			}
		}
	end or fFlagProfilePlatformAddTC and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = data.buttonSurface,
						modalVariantOverride = sources.ShareLinkSender
					})

					local v9 = {
						userId = data.profileId,
						source = sources.ProfilePlatform,
						modalVariantOverride = sources.ShareLinkSender,
						onRequestSent = function()
							return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
						end
					}

					if
						fFlagProfileTFCardUseQrScanContext
						and data.profileWrapperContext.sourceInfo.source == Enums.Sources.QrCode
					then
						v9.sentFromQrCode = true
					end

					data.navigation.push(appPage.TrustedContactsModal, { props = v9 })
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.AddIncomingTrustedConnection] = fFlagProfilePlatformAddTC and function(data)
		return {
			text = data.localized[Enums.ProfileActions.AddIncomingTrustedConnection],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(
						EventNames.ContextualMenuButtonAddIncomingTrustedConnection,
						{ buttonSurface = data.buttonSurface }
					)

					data.navigation.push(appPage.TrustedContactsModal, {
						props = {
							userId = data.profileId,
							onRequestAccepted = function()
								return data.dispatch(refreshProfilePlatformActionInfo(data.profileId, data.actionsComponentRequest))
							end
						}
					})
				end
			}
		}
	end or nil,
	[Enums.ProfileActions.PendingTrustedConnection] = fFlagProfilePlatformAddTC and function(p2)
		return {
			text = p2.localized[Enums.ProfileActions.AddTrustedConnection],
			isDisabled = true,
			onActivated = {
				[profileTypes.User] = function() end
			}
		}
	end or nil,
	[Enums.ProfileActions.PendingIncomingTrustedConnection] = function(p2)
		return {
			text = p2.localized[Enums.ProfileActions.AddIncomingTrustedConnection],
			isDisabled = true,
			onActivated = {
				[profileTypes.User] = function() end
			}
		}
	end
}
