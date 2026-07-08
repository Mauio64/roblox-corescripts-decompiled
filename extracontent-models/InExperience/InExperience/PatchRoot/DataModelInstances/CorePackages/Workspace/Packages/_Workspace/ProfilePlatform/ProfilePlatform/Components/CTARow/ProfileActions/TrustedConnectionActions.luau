local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local UIBlox = require(ProfilePlatformParent.UIBlox)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local RobloxAppEnums = require(ProfilePlatformParent.RobloxAppEnums)
local DataHydration = require(ProfilePlatformParent.DataHydration)
local SocialLuaAnalytics = require(ProfilePlatformParent.SocialLuaAnalytics)
local Images = UIBlox.App.ImageSet.Images
local AppPage = RobloxAppEnums.AppPage
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local refreshProfilePlatformActionInfo = require(ProfilePlatform.Networking.refreshProfilePlatformActionInfo)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes
local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local FFlagPendingIncomingTrustedConnection = require(ProfilePlatform.Flags.FFlagPendingIncomingTrustedConnection)
local v18 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

return {
	[Enums.ProfileActions.RemoveTrustedConnection] = function(p1) -- line: 27
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), v18 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p1.localized[Enums.ProfileActions.RemoveTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 31
					-- upvalues: p1 (copy), EventNames (copy), v18 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonRemoveTrustedConnection, {
						buttonSurface = p1.buttonSurface
					})

					return v18.removeTrustedConnectionRequest(p1.profileId):andThen(function() -- line: 35
						-- upvalues: p1 (copy), SetCurrentToastMessage (copy), Images (copy), refreshProfilePlatformActionInfo (copy)
						p1.dispatch(SetCurrentToastMessage({
							isLocalized = true,
							toastMessage = p1.localized.trustedConnectionRemovedToast,
							toastIcon = Images["icons/actions/friends/friendRemove"]
						}))

						return p1.dispatch(refreshProfilePlatformActionInfo(p1.profileId, p1.actionsComponentRequest))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.AddTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else function(p2) -- line: 51
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), AppPage (copy), Sources (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p2.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 55
					-- upvalues: p2 (copy), EventNames (copy), AppPage (copy), Sources (copy), refreshProfilePlatformActionInfo (copy)
					p2.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p2.buttonSurface
					})
					p2.navigation.push(AppPage.TrustedContactsModal, {
						props = {
							userId = p2.profileId,
							source = Sources.ProfilePlatform,
							onRequestSent = function() -- line: 63
								-- upvalues: p2 (copy), refreshProfilePlatformActionInfo (copy)
								return p2.dispatch(refreshProfilePlatformActionInfo(p2.profileId, p2.actionsComponentRequest))
							end
						}
					})
				end
			}
		}
	end,
	[Enums.ProfileActions.AddTrustedConnectionViaLink] = function(p3) -- line: 79
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), Sources (copy), AppPage (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p3.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 83
					-- upvalues: p3 (copy), EventNames (copy), Sources (copy), AppPage (copy), refreshProfilePlatformActionInfo (copy)
					p3.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddTrustedConnection, {
						buttonSurface = p3.buttonSurface,
						modalVariantOverride = Sources.ShareLinkSender
					})
					p3.navigation.push(AppPage.TrustedContactsModal, {
						props = {
							userId = p3.profileId,
							source = Sources.ProfilePlatform,
							modalVariantOverride = Sources.ShareLinkSender,
							onRequestSent = function() -- line: 93
								-- upvalues: p3 (copy), refreshProfilePlatformActionInfo (copy)
								return p3.dispatch(refreshProfilePlatformActionInfo(p3.profileId, p3.actionsComponentRequest))
							end
						}
					})
				end
			}
		}
	end,
	[Enums.ProfileActions.AddIncomingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else function(p4) -- line: 106
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), AppPage (copy), refreshProfilePlatformActionInfo (copy)
		return {
			text = p4.localized[Enums.ProfileActions.AddIncomingTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 110
					-- upvalues: p4 (copy), EventNames (copy), AppPage (copy), refreshProfilePlatformActionInfo (copy)
					p4.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonAddIncomingTrustedConnection, {
						buttonSurface = p4.buttonSurface
					})
					p4.navigation.push(AppPage.TrustedContactsModal, {
						props = {
							userId = p4.profileId,
							onRequestAccepted = function() -- line: 120
								-- upvalues: p4 (copy), refreshProfilePlatformActionInfo (copy)
								return p4.dispatch(refreshProfilePlatformActionInfo(p4.profileId, p4.actionsComponentRequest))
							end
						}
					})
				end
			}
		}
	end,
	[Enums.ProfileActions.PendingTrustedConnection] = if not FFlagProfilePlatformAddTC then nil else function(p5) -- line: 137
		-- upvalues: Enums (copy), ProfileTypes (copy)
		return {
			isDisabled = true,
			text = p5.localized[Enums.ProfileActions.AddTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 142
				end
			}
		}
	end,
	[Enums.ProfileActions.PendingIncomingTrustedConnection] = if not FFlagPendingIncomingTrustedConnection then nil else function(p6) -- line: 149
		-- upvalues: Enums (copy), ProfileTypes (copy)
		return {
			isDisabled = true,
			text = p6.localized[Enums.ProfileActions.AddIncomingTrustedConnection],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 154
				end
			}
		}
	end
}
