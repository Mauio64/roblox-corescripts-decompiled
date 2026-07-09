local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SocialLuaAnalytics = require(ProfilePlatformParent.SocialLuaAnalytics)
local AnalyticsConstants = require(script.Parent.AnalyticsConstants)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.EventNames)
local FFlagProfilePlatformUseProfileTypeContext = require(ProfilePlatform.Flags.FFlagProfilePlatformUseProfileTypeContext)
local FFlagEnablePlatformProfileContextualMenuOption = require(ProfilePlatformParent.SharedFlags).FFlagEnablePlatformProfileContextualMenuOption
local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditAppearanceAnalytics = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceAnalytics)
local FFlagSocialEnableProfileInspectAndBuyAnalytics = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuyAnalytics

local function v17(p1) -- line: 29
	return p1
end

return {
	[EventNames.ProfilePageLoadedWithData] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			friendStatus = v17,
			playerPresence = v17,
			absolutePosition = v17,
			isHomePageCarousel = v17,
			isRecommendation = v17,
			recommendationContextType = v17,
			recommendationRank = v17,
			recommendationSessionId = v17,
			source = v17,
			profileType = v17,
			shareLinkId = v17,
			primaryAction = v17
		}
	},
	[EventNames.ProfilePresenceLoaded] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.PresenceLoaded,
		formatRulesForAdditionalInfo = {
			presenceType = v17,
			universeId = v17
		}
	},
	[EventNames.ContextualMenuButtonChat] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.Chat
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonIgnoreFriendRequest] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.IgnoreFriendRequest
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonReport] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.Report
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonUnfriend] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.Unfriend
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonBlock] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.Block
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonSetAlias] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.SetAlias
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonCopyLink] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.CopyLink
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonLeaveCommunity] = {
		context = if not FFlagProfilePlatformUseProfileTypeContext then Contexts.PlayerProfile else Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.LeaveCommunity
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			btnContext = v17
		}
	},
	[EventNames.ContextualMenuButtonUnfollow] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.Unfollow
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonRemoveTrustedConnection] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.RemoveTrustedConnection
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonAddTrustedConnection] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.AddTrustedConnection
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			modalVariantOverride = v17
		}
	},
	[EventNames.ContextualMenuButtonAddIncomingTrustedConnection] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.AddIncomingTrustedConnection
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButtonMakePrimaryCommunity] = {
		context = if not FFlagProfilePlatformUseProfileTypeContext then Contexts.PlayerProfile else Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.MakePrimaryCommunity
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			btnContext = v17
		}
	},
	[EventNames.ContextualMenuButtonRemovePrimaryCommunity] = {
		context = if not FFlagProfilePlatformUseProfileTypeContext then Contexts.PlayerProfile else Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.RemovePrimaryCommunity
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			btnContext = v17
		}
	},
	[EventNames.ContextualMenuButtonCurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.CurrencyTransfer
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonOpenEditProfilePage] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.OpenEditProfilePage
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonChat] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.Chat
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonUnlockChat] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.UnlockChat
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonUnfriend] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.Unfriend
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonUnblock] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.Unblock
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonAddFriend] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.AddFriend
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v17,
			isHomePageCarousel = v17,
			isRecommendation = v17,
			recommendationContextType = v17,
			recommendationRank = v17,
			recommendationSessionId = v17,
			source = v17,
			contextualInfoType = v17,
			shareLinkId = v17,
			profileType = v17
		}
	},
	[EventNames.CTAButtonAddFriendFromContacts] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.AddFriendFromContacts
		},
		formatRulesForAdditionalInfo = {
			shareLinkId = v17
		}
	},
	[EventNames.CTAButtonAcceptFriendRequest] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.AcceptFriendRequest
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v17,
			contextualInfoType = v17,
			isHomePageCarousel = v17,
			isRecommendation = v17,
			recommendationContextType = v17,
			recommendationRank = v17,
			recommendationSessionId = v17,
			source = v17,
			buttonSurface = v17,
			shareLinkId = v17,
			profileType = v17
		}
	},
	[EventNames.CTAButtonEditAvatar] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.EditAvatar
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonEditLook] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.EditLook
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonShareProfile] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.ShareProfile
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonShareProfileQRCode] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.ShareProfileQRCode
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonJoinCommunity] = {
		context = if not FFlagProfilePlatformUseProfileTypeContext then Contexts.PlayerProfile else Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.CTAButtons.JoinCommunity
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			btnContext = v17
		}
	},
	[EventNames.CTAButtonFollow] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.CTAButtons.Follow
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonViewCommunity] = {
		context = if not FFlagProfilePlatformUseProfileTypeContext then Contexts.PlayerProfile else Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.CTAButtons.ViewCommunity
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			btnContext = v17
		}
	},
	[EventNames.CTAButtonViewFullProfile] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.CTAButtons.ViewFullProfile
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			btnContext = v17
		}
	},
	[EventNames.CTAButtonCurrencyTransfer] = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.CTAButtons.CurrencyTransfer
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonCancelJoinCommunityRequest] = {
		context = if not FFlagProfilePlatformUseProfileTypeContext then Contexts.PlayerProfile else Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.CTAButtons.CancelJoinCommunityRequest
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17,
			btnContext = v17
		}
	},
	[EventNames.FriendsButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.Friends
		}
	},
	[EventNames.FollowersButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.Followers
		}
	},
	[EventNames.FollowingsButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.Following
		}
	},
	[EventNames.MutualFriendsButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.MutualFriends
		}
	},
	[EventNames.ViewPlayerProfileButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.ViewPlayerProfile
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v17,
			friendStatus = v17,
			isHomePageCarousel = v17,
			isRecommendation = v17,
			recommendationContextType = v17,
			recommendationRank = v17,
			recommendationSessionId = v17,
			source = v17,
			buttonSurface = v17
		}
	},
	[EventNames.ContextualMenuButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.ContextualMenu
		}
	},
	[EventNames.GameDetailsButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.GameDetails
		}
	},
	[EventNames.EditDisplayNameButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.EditDisplayName
		},
		formatRulesForAdditionalInfo = {
			canSetDisplayName = v17
		}
	},
	[EventNames.SetAliasButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.SetAlias
		}
	},
	[EventNames.ProfileClosed] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.Dismissed
	},
	[EventNames.StoreHeaderButton] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.StoreHeader
		}
	},
	[EventNames.FavoriteExperienceOpened] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.FavoriteExperience
		},
		formatRulesForAdditionalInfo = {
			experienceId = v17,
			positionInComponent = v17
		}
	},
	[EventNames.FavoriteExperienceSeeAll] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.FavoriteExperienceSeeAll
		}
	},
	[EventNames.ExperienceOpened] = {
		context = if not FFlagProfilePlatformUseProfileTypeContext then Contexts.PlayerProfile else Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.Experience
		},
		formatRulesForAdditionalInfo = {
			experienceId = v17,
			positionInComponent = v17
		}
	},
	[EventNames.EventOpened] = {
		context = Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.Event
		},
		formatRulesForAdditionalInfo = {
			virtualEventId = v17
		}
	},
	[EventNames.EventRSVP] = {
		context = Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.EventRSVP
		},
		formatRulesForAdditionalInfo = {
			virtualEventId = v17,
			status = v17
		}
	},
	[EventNames.EventJoined] = {
		context = Contexts.CommunityProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.EventJoin
		},
		formatRulesForAdditionalInfo = {
			virtualEventId = v17
		}
	},
	[EventNames.CatalogItemOpened] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.ViewCatalogItem
		},
		formatRulesForAdditionalInfo = if not FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
			itemId = v17,
			positionInComponent = v17,
			component = v17
		} else {
			btnContext = v17,
			btnUnitId = v17,
			btnSortPosition = v17
		}
	},
	[EventNames.UsernameCopied] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.Username
		}
	},
	[EventNames.ContextualMenuButtonViewPlatformProfile] = if not FFlagEnablePlatformProfileContextualMenuOption then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			optionType = "CTAType",
			btn = AnalyticsConstants.ContextualMenuButtons.ViewPlatformProfile
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.CTAButtonEditAppearance] = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEnableEditAppearanceAnalytics then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.CTAButtons.EditAppearance
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.EditAppearanceMenuEditAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEnableEditAppearanceAnalytics then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.EditAppearanceEditAvatar
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.EditAppearanceMenuEditEmote] = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEnableEditAppearanceAnalytics then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.EditAppearanceEditEmote
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.EditAppearanceMenuSwitchAvatar] = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEnableEditAppearanceAnalytics then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.EditAppearanceSwitchAvatar
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.EditAppearanceMenuEditBackground] = if not FFlagProfilePlatformEnableEditAppearanceMenu or (not FFlagProfilePlatformEnableEditAppearanceAnalytics or not FFlagProfilePlatformEditBackgroundMenuItem) then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.EditAppearanceEditBackground
		},
		formatRulesForAdditionalInfo = {
			buttonSurface = v17
		}
	},
	[EventNames.InspectAvatarOpened] = if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.InspectAvatar
		},
		formatRulesForAdditionalInfo = {
			profileSessionId = v17
		}
	},
	[EventNames.InspectAvatarBuyClicked] = if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.InspectAvatarBuyItems
		},
		formatRulesForAdditionalInfo = {
			profileSessionId = v17,
			itemIds = v17,
			totalPrice = v17
		}
	},
	[EventNames.InspectAvatarPurchaseConfirmed] = if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.InspectAvatarConfirmBuy
		},
		formatRulesForAdditionalInfo = {
			profileSessionId = v17
		}
	},
	[EventNames.MomentsSeeAll] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.MomentsSeeAll
		}
	},
	[EventNames.MomentOpened] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.Btns.Moment
		}
	}
}
