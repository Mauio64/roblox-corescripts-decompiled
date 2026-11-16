local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics")
local AnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/AnalyticsConstants")

local enums = SocialLuaAnalytics.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")

local FFlagProfilePlatformUseProfileTypeContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformUseProfileTypeContext")

local fFlagEnablePlatformProfileContextualMenuOption = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnablePlatformProfileContextualMenuOption

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformUseCatalogItemOpenedNewFields")
local fFlagFriendsCallingClientGate_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagFriendsCallingClientGate_DEV

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableTradeItems")
local FFlagProfileTradeItemsImpressionLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileTradeItemsImpressionLogging")

local FFlagProfilePlatformEnableEditAppearanceMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditAppearanceMenu")

local FFlagProfilePlatformEditBackgroundMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEditBackgroundMenuItem")

local fFlagSocialEnableProfileInspectAndBuyAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuyAnalytics

local function fn(p2)
	return p2
end

local v5 = {
	[EventNames.ProfilePageLoadedWithData] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			friendStatus = fn,
			playerPresence = fn,
			absolutePosition = fn,
			isHomePageCarousel = fn,
			isRecommendation = fn,
			recommendationContextType = fn,
			recommendationRank = fn,
			recommendationSessionId = fn,
			source = fn,
			profileType = fn,
			shareLinkId = fn,
			primaryAction = fn
		}
	},
	[EventNames.ProfilePresenceLoaded] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.PresenceLoaded,
		formatRulesForAdditionalInfo = { presenceType = fn, universeId = fn }
	},
	[EventNames.ContextualMenuButtonCall] = fFlagFriendsCallingClientGate_DEV and {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Call,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	} or nil,
	[EventNames.ContextualMenuButtonChat] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Chat,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonIgnoreFriendRequest] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.IgnoreFriendRequest,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonReport] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Report,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonUnfriend] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Unfriend,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonBlock] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Block,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonSetAlias] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.SetAlias,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonCopyLink] = {
		context = contexts.PlayerProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.CopyLink,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	}
}

local contextualMenuButtonLeaveCommunity = EventNames.ContextualMenuButtonLeaveCommunity

local v7 = if FFlagProfilePlatformUseProfileTypeContext then contexts.CommunityProfile else contexts.PlayerProfile
v5[contextualMenuButtonLeaveCommunity] = {
	context = v7,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.LeaveCommunity,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

v5[EventNames.ContextualMenuButtonUnfollow] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.Unfollow,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.ContextualMenuButtonRemoveTrustedConnection] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.RemoveTrustedConnection,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.ContextualMenuButtonAddTrustedConnection] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.AddTrustedConnection,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, modalVariantOverride = fn }
}

v5[EventNames.ContextualMenuButtonAddIncomingTrustedConnection] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.AddIncomingTrustedConnection,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

local contextualMenuButtonMakePrimaryCommunity = EventNames.ContextualMenuButtonMakePrimaryCommunity

local v9 = if FFlagProfilePlatformUseProfileTypeContext then contexts.CommunityProfile else contexts.PlayerProfile
v5[contextualMenuButtonMakePrimaryCommunity] = {
	context = v9,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.MakePrimaryCommunity,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

local contextualMenuButtonRemovePrimaryCommunity = EventNames.ContextualMenuButtonRemovePrimaryCommunity

local v11 = if FFlagProfilePlatformUseProfileTypeContext then contexts.CommunityProfile else contexts.PlayerProfile
v5[contextualMenuButtonRemovePrimaryCommunity] = {
	context = v11,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.RemovePrimaryCommunity,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

v5[EventNames.ContextualMenuButtonCurrencyTransfer] = fFlagProfilePlatformEnableCurrencyTransfer and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.CurrencyTransfer,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.ContextualMenuButtonTradeItems] = FFlagProfilePlatformEnableTradeItems and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.TradeItems,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.ContextualMenuTradeItemsImpression] = FFlagProfilePlatformEnableTradeItems and FFlagProfileTradeItemsImpressionLogging and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.UserSeen,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.TradeItems,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.CTAButtonOpenEditProfilePage] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.OpenEditProfilePage },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonCall] = fFlagFriendsCallingClientGate_DEV and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Call },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.CTAButtonChat] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Chat },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonUnlockChat] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.UnlockChat },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonUnfriend] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Unfriend },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonUnblock] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Unblock },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonAddFriend] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.AddFriend },
	formatRulesForAdditionalInfo = {
		absolutePosition = fn,
		isHomePageCarousel = fn,
		isRecommendation = fn,
		recommendationContextType = fn,
		recommendationRank = fn,
		recommendationSessionId = fn,
		source = fn,
		contextualInfoType = fn,
		shareLinkId = fn,
		profileType = fn
	}
}

v5[EventNames.CTAButtonAddFriendFromContacts] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.AddFriendFromContacts },
	formatRulesForAdditionalInfo = { shareLinkId = fn }
}

v5[EventNames.CTAButtonAcceptFriendRequest] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.AcceptFriendRequest },
	formatRulesForAdditionalInfo = {
		absolutePosition = fn,
		contextualInfoType = fn,
		isHomePageCarousel = fn,
		isRecommendation = fn,
		recommendationContextType = fn,
		recommendationRank = fn,
		recommendationSessionId = fn,
		source = fn,
		buttonSurface = fn,
		shareLinkId = fn,
		profileType = fn
	}
}

v5[EventNames.CTAButtonEditAvatar] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.EditAvatar },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonEditLook] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.EditLook },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonShareProfile] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.ShareProfile },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

v5[EventNames.CTAButtonShareProfileQRCode] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.ShareProfileQRCode },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

local ctaButtonJoinCommunity = EventNames.CTAButtonJoinCommunity

local v13 = if FFlagProfilePlatformUseProfileTypeContext then contexts.CommunityProfile else contexts.PlayerProfile
v5[ctaButtonJoinCommunity] = {
	context = v13,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.JoinCommunity, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

v5[EventNames.CTAButtonFollow] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Follow, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

local ctaButtonViewCommunity = EventNames.CTAButtonViewCommunity

local v15 = if FFlagProfilePlatformUseProfileTypeContext then contexts.CommunityProfile else contexts.PlayerProfile
v5[ctaButtonViewCommunity] = {
	context = v15,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.ViewCommunity, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

v5[EventNames.CTAButtonViewFullProfile] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.CTAButtons.ViewFullProfile,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

v5[EventNames.CTAButtonCurrencyTransfer] = fFlagProfilePlatformEnableCurrencyTransfer and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.CTAButtons.CurrencyTransfer,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.CTAButtonTradeItems] = FFlagProfilePlatformEnableTradeItems and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.TradeItems, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

local ctaButtonCancelJoinCommunityRequest = EventNames.CTAButtonCancelJoinCommunityRequest

local v17 = if FFlagProfilePlatformUseProfileTypeContext then contexts.CommunityProfile else contexts.PlayerProfile
v5[ctaButtonCancelJoinCommunityRequest] = {
	context = v17,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.CTAButtons.CancelJoinCommunityRequest,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

v5[EventNames.SchoolButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.School }
}

v5[EventNames.FriendsButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Friends }
}

v5[EventNames.FollowersButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Followers }
}

v5[EventNames.FollowingsButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Following }
}

v5[EventNames.MutualFriendsButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.MutualFriends }
}

v5[EventNames.ViewPlayerProfileButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.ViewPlayerProfile },
	formatRulesForAdditionalInfo = {
		absolutePosition = fn,
		friendStatus = fn,
		isHomePageCarousel = fn,
		isRecommendation = fn,
		recommendationContextType = fn,
		recommendationRank = fn,
		recommendationSessionId = fn,
		source = fn,
		buttonSurface = fn
	}
}

v5[EventNames.ContextualMenuButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.ContextualMenu }
}

v5[EventNames.GameDetailsButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.GameDetails }
}

v5[EventNames.EditDisplayNameButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditDisplayName },
	formatRulesForAdditionalInfo = { canSetDisplayName = fn }
}

v5[EventNames.SetAliasButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.SetAlias }
}

v5[EventNames.ProfileClosed] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.Dismissed
}

v5[EventNames.StoreHeaderButton] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.StoreHeader }
}

v5[EventNames.FavoriteExperienceOpened] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.FavoriteExperience },
	formatRulesForAdditionalInfo = { experienceId = fn, positionInComponent = fn }
}

v5[EventNames.FavoriteExperienceSeeAll] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.FavoriteExperienceSeeAll }
}

local experienceOpened = EventNames.ExperienceOpened

local v19 = if FFlagProfilePlatformUseProfileTypeContext then contexts.CommunityProfile else contexts.PlayerProfile
v5[experienceOpened] = {
	context = v19,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Experience },
	formatRulesForAdditionalInfo = { experienceId = fn, positionInComponent = fn }
}

v5[EventNames.EventOpened] = {
	context = contexts.CommunityProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Event },
	formatRulesForAdditionalInfo = { virtualEventId = fn }
}

v5[EventNames.EventRSVP] = {
	context = contexts.CommunityProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EventRSVP },
	formatRulesForAdditionalInfo = { virtualEventId = fn, status = fn }
}

v5[EventNames.EventJoined] = {
	context = contexts.CommunityProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EventJoin },
	formatRulesForAdditionalInfo = { virtualEventId = fn }
}

v5[EventNames.CatalogItemOpened] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.ViewCatalogItem },
	formatRulesForAdditionalInfo = FFlagProfilePlatformUseCatalogItemOpenedNewFields and {
		btnContext = fn,
		btnUnitId = fn,
		btnSortPosition = fn
	} or { itemId = fn, positionInComponent = fn, component = fn }
}

v5[EventNames.UsernameCopied] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Username }
}

v5[EventNames.ContextualMenuButtonViewPlatformProfile] = fFlagEnablePlatformProfileContextualMenuOption and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.ViewPlatformProfile,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.CTAButtonEditAppearance] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.EditAppearance },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.EditAppearanceMenuEditAvatar] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceEditAvatar },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.EditAppearanceMenuEditEmote] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceEditEmote },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.EditAppearanceMenuSwitchAvatar] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceSwitchAvatar },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.EditAppearanceMenuEditBackground] = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceEditBackground },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

v5[EventNames.InspectAvatarOpened] = fFlagSocialEnableProfileInspectAndBuyAnalytics and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.InspectAvatar },
	formatRulesForAdditionalInfo = { profileSessionId = fn }
} or nil

v5[EventNames.InspectAvatarBuyClicked] = fFlagSocialEnableProfileInspectAndBuyAnalytics and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.InspectAvatarBuyItems },
	formatRulesForAdditionalInfo = {
		profileSessionId = fn,
		itemIds = fn,
		totalPrice = fn
	}
} or nil

v5[EventNames.InspectAvatarPurchaseConfirmed] = fFlagSocialEnableProfileInspectAndBuyAnalytics and {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.InspectAvatarConfirmBuy },
	formatRulesForAdditionalInfo = { profileSessionId = fn }
} or nil

v5[EventNames.MomentsSeeAll] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.MomentsSeeAll }
}

v5[EventNames.MomentOpened] = {
	context = contexts.PlayerProfile,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Moment }
}

return v5
