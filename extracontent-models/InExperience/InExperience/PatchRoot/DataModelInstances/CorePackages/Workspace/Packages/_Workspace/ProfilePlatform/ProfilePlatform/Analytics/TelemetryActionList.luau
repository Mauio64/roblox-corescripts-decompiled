local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SupportedTelemetryBackends = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)
local FFlagProfilePlatformEnableStore = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableStore
local FFlagEnablePlatformProfileContextualMenuOption = require(ProfilePlatformParent.SharedFlags).FFlagEnablePlatformProfileContextualMenuOption
local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("ProfilePlatformAnalyticsThrottlingThousandths", 1000)
	},
	[EventNames.ProfileLoadingStage] = {
		description = "Stage of loading profile",
		lastUpdated = {
			24,
			6,
			6
		},
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p1) -- line: 33
						return p1
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				overrideName = function(p2) -- line: 40
					-- upvalues: EventNames (copy)
					return EventNames.ProfileLoadingStage .. "Time" .. p2.status
				end,
				dynamicCustomFields = {
					status = function(p3) -- line: 44
						return p3
					end,
					isProfilePlatform = function(p4) -- line: 47
						return p4 or false
					end
				}
			}
		}
	},
	[EventNames.ProfilePlatformPageReloaded] = {
		description = "ReloadedProfilePlatform",
		lastUpdated = {
			25,
			4,
			25
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				reloadCount = function(p5) -- line: 61
					if p5 <= 10 then
						return `ReloadCount${ p5 }`
					end

					return "ReloadCount5+"
				end
			}
		}}
	},
	[EventNames.ProfileInExperienceUserLoadingStage] = {
		description = "User in experience opened",
		lastUpdated = {
			24,
			6,
			10
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				status = function(p6) -- line: 81
					return p6
				end,
				isInExperience = function(p7) -- line: 84
					return p7
				end
			}
		}}
	},
	[EventNames.ProfilePageLoadedWithData] = {
		description = "Profile page loaded with data",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				friendStatus = function(p8) -- line: 98
					return p8
				end
			}
		}}
	},
	[EventNames.ProfilePresenceLoaded] = {
		description = "Profile presence loaded",
		lastUpdated = {
			25,
			2,
			19
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				presenceType = function(p9) -- line: 112
					return p9
				end
			}
		}}
	},
	[EventNames.ContextualMenuButtonChat] = {
		description = "Chat button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonIgnoreFriendRequest] = {
		description = "Ignore friend request button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonReport] = {
		description = "Report button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonUnfriend] = {
		description = "Unfriend button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonBlock] = {
		description = "Block button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonSetAlias] = {
		description = "Set alias button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonCopyLink] = {
		description = "Copy Link button clicked",
		lastUpdated = {
			25,
			3,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonLeaveCommunity] = {
		description = "Leave Community button clicked",
		lastUpdated = {
			25,
			3,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonMakePrimaryCommunity] = {
		description = "Make Primary Community button clicked",
		lastUpdated = {
			25,
			3,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonRemovePrimaryCommunity] = {
		description = "Remove Primary Community button clicked",
		lastUpdated = {
			25,
			3,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonRemoveTrustedConnection] = {
		description = "Remove Trusted Connection button clicked",
		lastUpdated = {
			25,
			6,
			16
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonAddTrustedConnection] = {
		description = "Add Trusted Connection button clicked",
		lastUpdated = {
			25,
			9,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				modalVariantOverride = function(p10) -- line: 225
					return p10
				end
			}
		}}
	},
	[EventNames.ContextualMenuButtonAddIncomingTrustedConnection] = {
		description = "Accept Trusted Connection button clicked",
		lastUpdated = {
			25,
			9,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonOpenEditProfilePage] = {
		description = "Open edit profile page button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonChat] = {
		description = "Chat button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonUnfriend] = {
		description = "Unfriend button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonUnblock] = {
		description = "Unblock button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonAddFriend] = {
		description = "Add friend button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonAddFriendFromContacts] = {
		description = "Add friend from contacts clicked",
		lastUpdated = {
			24,
			9,
			12
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonAcceptFriendRequest] = {
		description = "Accept friend request button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonEditAvatar] = {
		description = "Edit avatar button clicked",
		lastUpdated = {
			25,
			9,
			17
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonEditLook] = {
		description = "Edit look button clicked",
		lastUpdated = {
			26,
			3,
			18
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonShareProfile] = {
		description = "Share profile button clicked",
		lastUpdated = {
			25,
			3,
			12
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonShareProfileQRCode] = {
		description = "Share profile QR code button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonJoinCommunity] = {
		description = "Join Community button clicked",
		lastUpdated = {
			25,
			3,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonViewCommunity] = {
		description = "View Community button clicked",
		lastUpdated = {
			25,
			3,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonCancelJoinCommunityRequest] = {
		description = "Cancel Join Community Request button clicked",
		lastUpdated = {
			25,
			3,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.FriendsButton] = {
		description = "Friends button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.FollowersButton] = {
		description = "Followers button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.FollowingsButton] = {
		description = "Following button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.MutualFriendsButton] = {
		description = "Mutual friends button clicked",
		lastUpdated = {
			25,
			8,
			19
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ViewPlayerProfileButton] = {
		description = "View player profile button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButton] = {
		description = "Contextual menu button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.GameDetailsButton] = {
		description = "Game details button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.EditDisplayNameButton] = {
		description = "Edit display name button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.SetAliasButton] = {
		description = "Set alias button clicked",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ProfileClosed] = {
		description = "Profile closed",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat
		}}
	},
	[EventNames.StoreHeaderButton] = {
		description = "Store header button clicked",
		lastUpdated = {
			25,
			4,
			23
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CatalogItemOpened] = {
		description = "Catalog item opened",
		lastUpdated = {
			24,
			7,
			31
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = if not FFlagProfilePlatformEnableStore then nil else if not FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
				source = function(p11) -- line: 480
					return p11
				end
			} else {
				btnContext = function(p12) -- line: 475
					return p12
				end
			}
		}}
	},
	[EventNames.ProfileImpressionsSent] = {
		description = "Impressions sent",
		lastUpdated = {
			25,
			2,
			24
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				component = function(p13) -- line: 495
					return p13
				end
			}
		}}
	},
	[EventNames.UsernameCopied] = {
		description = "Username copied to clipboard",
		lastUpdated = {
			25,
			8,
			5
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonViewPlatformProfile] = if not FFlagEnablePlatformProfileContextualMenuOption then nil else {
		description = "View platform profile button clicked",
		lastUpdated = {
			25,
			9,
			11
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContextualMenuButtonCurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else {
		description = "Currency transfer button clicked from contextual menu",
		lastUpdated = {
			26,
			3,
			24
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonCurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else {
		description = "Currency transfer CTA button clicked",
		lastUpdated = {
			26,
			3,
			24
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.CTAButtonEditAppearance] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
		description = "Edit appearance menu opened",
		lastUpdated = {
			26,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.EditAppearanceMenuEditAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
		description = "Edit avatar clicked from edit appearance menu",
		lastUpdated = {
			26,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.EditAppearanceMenuEditEmote] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
		description = "Edit emote clicked from edit appearance menu",
		lastUpdated = {
			26,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.EditAppearanceMenuSwitchAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else {
		description = "Switch avatar clicked from edit appearance menu",
		lastUpdated = {
			26,
			3,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.EditAppearanceMenuEditBackground] = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEditBackgroundMenuItem then nil else {
		description = "Edit background clicked from edit appearance menu",
		lastUpdated = {
			26,
			5,
			14
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	}
}
