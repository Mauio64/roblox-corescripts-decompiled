local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventNames = require(script.Parent.EventNames)
local AnalyticsConstants = require(script.Parent.AnalyticsConstants)

local FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 = require(ProfilePlatform.Flags.FFlagSocialEnableProfileInspectAndBuyAnalyticsV2)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableStore = SharedFlags.FFlagProfilePlatformEnableStore

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePlatformProfileContextualMenuOption = SharedFlags2.FFlagEnablePlatformProfileContextualMenuOption

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags3.FFlagFriendsCallingClientGate_DEV

local SharedFlags4 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags4.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)
local FFlagProfileTradeItemsImpressionLogging = require(ProfilePlatform.Flags.FFlagProfileTradeItemsImpressionLogging)

local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)

local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("ProfilePlatformAnalyticsThrottlingThousandths", 1000),
		links = ""
	},
	[EventNames.ProfileLoadingStage] = {
		description = "Stage of loading profile",
		lastUpdated = { 24, 6, 6 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					status = function(p)
						return p
					end
				}
			},
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				overrideName = function(p)
					return EventNames.ProfileLoadingStage .. "Time" .. p.status
				end,
				dynamicCustomFields = {
					status = function(p)
						return p
					end,
					isProfilePlatform = function(p)
						return p or false
					end
				}
			}
		}
	},
	[EventNames.ProfilePlatformPageReloaded] = {
		description = "ReloadedProfilePlatform",
		lastUpdated = { 25, 4, 25 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					reloadCount = function(p)
						if p <= 10 then
							return `ReloadCount${p}`
						end

						return "ReloadCount5+"
					end
				}
			}
		}
	},
	[EventNames.ProfileInExperienceUserLoadingStage] = {
		description = "User in experience opened",
		lastUpdated = { 24, 6, 10 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					status = function(p)
						return p
					end,
					isInExperience = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.ProfilePageLoadedWithData] = {
		description = "Profile page loaded with data",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					friendStatus = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.ProfilePresenceLoaded] = {
		description = "Profile presence loaded",
		lastUpdated = { 25, 2, 19 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					presenceType = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.ContextualMenuButtonCall] = FFlagFriendsCallingClientGate_DEV and {
		description = "Call button clicked from contextual menu",
		lastUpdated = { 26, 9, 3 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.ContextualMenuButtonChat] = {
		description = "Chat button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonIgnoreFriendRequest] = {
		description = "Ignore friend request button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonReport] = {
		description = "Report button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonUnfriend] = {
		description = "Unfriend button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonBlock] = {
		description = "Block button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonSetAlias] = {
		description = "Set alias button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonCopyLink] = {
		description = "Copy Link button clicked",
		lastUpdated = { 25, 3, 4 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonLeaveCommunity] = {
		description = "Leave Community button clicked",
		lastUpdated = { 25, 3, 4 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonMakePrimaryCommunity] = {
		description = "Make Primary Community button clicked",
		lastUpdated = { 25, 3, 4 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonRemovePrimaryCommunity] = {
		description = "Remove Primary Community button clicked",
		lastUpdated = { 25, 3, 4 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonRemoveTrustedConnection] = {
		description = "Remove Trusted Connection button clicked",
		lastUpdated = { 25, 6, 16 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonAddTrustedConnection] = {
		description = "Add Trusted Connection button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					modalVariantOverride = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.ContextualMenuButtonAddIncomingTrustedConnection] = {
		description = "Accept Trusted Connection button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonOpenEditProfilePage] = {
		description = "Open edit profile page button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonCall] = FFlagFriendsCallingClientGate_DEV and {
		description = "Call CTA button clicked",
		lastUpdated = { 26, 9, 3 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.CTAButtonChat] = {
		description = "Chat button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonUnfriend] = {
		description = "Unfriend button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonUnblock] = {
		description = "Unblock button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonAddFriend] = {
		description = "Add friend button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonAddFriendFromContacts] = {
		description = "Add friend from contacts clicked",
		lastUpdated = { 24, 9, 12 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonAcceptFriendRequest] = {
		description = "Accept friend request button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonEditAvatar] = {
		description = "Edit avatar button clicked",
		lastUpdated = { 25, 9, 17 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonEditLook] = {
		description = "Edit look button clicked",
		lastUpdated = { 26, 3, 18 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonShareProfile] = {
		description = "Share profile button clicked",
		lastUpdated = { 25, 3, 12 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonShareProfileQRCode] = {
		description = "Share profile QR code button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonJoinCommunity] = {
		description = "Join Community button clicked",
		lastUpdated = { 25, 3, 4 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonViewCommunity] = {
		description = "View Community button clicked",
		lastUpdated = { 25, 3, 4 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CTAButtonCancelJoinCommunityRequest] = {
		description = "Cancel Join Community Request button clicked",
		lastUpdated = { 25, 3, 4 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SchoolButton] = {
		description = "School button clicked",
		lastUpdated = { 26, 7, 20 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.FriendsButton] = {
		description = "Friends button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.FollowersButton] = {
		description = "Followers button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.FollowingsButton] = {
		description = "Following button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.MutualFriendsButton] = {
		description = "Mutual friends button clicked",
		lastUpdated = { 25, 8, 19 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ViewPlayerProfileButton] = {
		description = "View player profile button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButton] = {
		description = "Contextual menu button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.GameDetailsButton] = {
		description = "Game details button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.EditDisplayNameButton] = {
		description = "Edit display name button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.SetAliasButton] = {
		description = "Set alias button clicked",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ProfileClosed] = {
		description = "Profile closed",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryStat }
		}
	},
	[EventNames.StoreHeaderButton] = {
		description = "Store header button clicked",
		lastUpdated = { 25, 4, 23 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.CatalogItemOpened] = {
		description = "Catalog item opened",
		lastUpdated = { 24, 7, 31 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = FFlagProfilePlatformEnableStore and (FFlagProfilePlatformUseCatalogItemOpenedNewFields and {
					btnContext = function(p)
						return p
					end
				} or {
					source = function(p)
						return p
					end
				}) or nil
			}
		}
	},
	[EventNames.ProfileImpressionsSent] = {
		description = "Impressions sent",
		lastUpdated = { 25, 2, 24 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					component = function(p)
						return p
					end
				}
			}
		}
	},
	[EventNames.UsernameCopied] = {
		description = "Username copied to clipboard",
		lastUpdated = { 25, 8, 5 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.ContextualMenuButtonViewPlatformProfile] = FFlagEnablePlatformProfileContextualMenuOption and {
		description = "View platform profile button clicked",
		lastUpdated = { 25, 9, 11 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.ContextualMenuButtonCurrencyTransfer] = FFlagProfilePlatformEnableCurrencyTransfer and {
		description = "Currency transfer button clicked from contextual menu",
		lastUpdated = { 26, 3, 24 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.CTAButtonCurrencyTransfer] = FFlagProfilePlatformEnableCurrencyTransfer and {
		description = "Currency transfer CTA button clicked",
		lastUpdated = { 26, 3, 24 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.ContextualMenuButtonTradeItems] = FFlagProfilePlatformEnableTradeItems and {
		description = "Trade Items button clicked from contextual menu",
		lastUpdated = { 26, 8, 13 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.ContextualMenuTradeItemsImpression] = FFlagProfilePlatformEnableTradeItems and FFlagProfileTradeItemsImpressionLogging and {
		description = "Trade Items row shown in the profile overflow menu",
		lastUpdated = { 26, 9, 3 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.CTAButtonTradeItems] = FFlagProfilePlatformEnableTradeItems and {
		description = "Trade Items CTA button clicked",
		lastUpdated = { 26, 8, 13 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.CTAButtonEditAppearance] = FFlagProfilePlatformEnableEditAppearanceMenu and {
		description = "Edit appearance menu opened",
		lastUpdated = { 26, 3, 30 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.EditAppearanceMenuEditAvatar] = FFlagProfilePlatformEnableEditAppearanceMenu and {
		description = "Edit avatar clicked from edit appearance menu",
		lastUpdated = { 26, 3, 30 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.EditAppearanceMenuEditEmote] = FFlagProfilePlatformEnableEditAppearanceMenu and {
		description = "Edit emote clicked from edit appearance menu",
		lastUpdated = { 26, 3, 30 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.EditAppearanceMenuSwitchAvatar] = FFlagProfilePlatformEnableEditAppearanceMenu and {
		description = "Switch avatar clicked from edit appearance menu",
		lastUpdated = { 26, 3, 30 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.EditAppearanceMenuEditBackground] = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem and {
		description = "Edit background clicked from edit appearance menu",
		lastUpdated = { 26, 5, 14 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.InspectAvatarInsufficientRobuxShown] = FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 and {
		description = "Insufficient Robux dialog shown from the Inspect Avatar sheet",
		lastUpdated = { 26, 7, 31 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.UserSeen
				end,
				staticCustomFields = {
					eventContext = Contexts.PlayerProfile,
					btn = AnalyticsConstants.Btns.InspectAvatarInsufficientRobux
				},
				dynamicCustomFields = {
					totalPrice = function(p)
						return p
					end
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.InspectAvatarBuyRobuxClicked] = FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 and {
		description = "Buy Robux clicked on the insufficient Robux dialog",
		lastUpdated = { 26, 7, 31 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.PlayerProfile,
					btn = AnalyticsConstants.Btns.InspectAvatarBuyRobux
				},
				dynamicCustomFields = {
					totalPrice = function(p)
						return p
					end
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil,
	[EventNames.CurrentlyWearingHeaderButton] = FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 and {
		description = "Currently Wearing header button clicked to open the Inspect Avatar sheet",
		lastUpdated = { 26, 8, 3 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.EventIngest,
				overrideName = function()
					return EventTypes.ButtonClick
				end,
				staticCustomFields = {
					eventContext = Contexts.PlayerProfile,
					btn = AnalyticsConstants.Btns.CurrentlyWearingHeader
				}
			},
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	} or nil
}
