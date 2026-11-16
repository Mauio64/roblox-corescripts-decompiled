local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local AnalyticsConstants = require(script.Parent.AnalyticsConstants)

local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.EventNames)

local FFlagProfilePlatformUseProfileTypeContext = require(ProfilePlatform.Flags.FFlagProfilePlatformUseProfileTypeContext)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlatformProfileContextualMenuOption = SharedFlags.FFlagEnablePlatformProfileContextualMenuOption

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags2.FFlagFriendsCallingClientGate_DEV

local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags3.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)
local FFlagProfileTradeItemsImpressionLogging = require(ProfilePlatform.Flags.FFlagProfileTradeItemsImpressionLogging)

local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)

local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)

local SharedFlags4 = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuyAnalytics = SharedFlags4.FFlagSocialEnableProfileInspectAndBuyAnalytics

local function fn(p)
	return p
end

local EventStreamActionList = {
	[EventNames.ProfilePageLoadedWithData] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.PageLoad,
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
		context = Contexts.PlayerProfile,
		eventType = EventTypes.PresenceLoaded,
		formatRulesForAdditionalInfo = { presenceType = fn, universeId = fn }
	},
	[EventNames.ContextualMenuButtonCall] = FFlagFriendsCallingClientGate_DEV and {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Call,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	} or nil,
	[EventNames.ContextualMenuButtonChat] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Chat,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonIgnoreFriendRequest] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.IgnoreFriendRequest,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonReport] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Report,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonUnfriend] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Unfriend,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonBlock] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.Block,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonSetAlias] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.SetAlias,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	},
	[EventNames.ContextualMenuButtonCopyLink] = {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.CopyLink,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	}
}

local ContextualMenuButtonLeaveCommunity = EventNames.ContextualMenuButtonLeaveCommunity
local context

if FFlagProfilePlatformUseProfileTypeContext then
	context = Contexts.CommunityProfile
else
	context = Contexts.PlayerProfile
end

EventStreamActionList[ContextualMenuButtonLeaveCommunity] = {
	context = context,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.LeaveCommunity,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

EventStreamActionList[EventNames.ContextualMenuButtonUnfollow] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.Unfollow,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.ContextualMenuButtonRemoveTrustedConnection] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.RemoveTrustedConnection,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.ContextualMenuButtonAddTrustedConnection] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.AddTrustedConnection,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, modalVariantOverride = fn }
}

EventStreamActionList[EventNames.ContextualMenuButtonAddIncomingTrustedConnection] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.AddIncomingTrustedConnection,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

local ContextualMenuButtonMakePrimaryCommunity = EventNames.ContextualMenuButtonMakePrimaryCommunity
local context2

if FFlagProfilePlatformUseProfileTypeContext then
	context2 = Contexts.CommunityProfile
else
	context2 = Contexts.PlayerProfile
end

EventStreamActionList[ContextualMenuButtonMakePrimaryCommunity] = {
	context = context2,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.MakePrimaryCommunity,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

local ContextualMenuButtonRemovePrimaryCommunity = EventNames.ContextualMenuButtonRemovePrimaryCommunity
local context3

if FFlagProfilePlatformUseProfileTypeContext then
	context3 = Contexts.CommunityProfile
else
	context3 = Contexts.PlayerProfile
end

EventStreamActionList[ContextualMenuButtonRemovePrimaryCommunity] = {
	context = context3,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.RemovePrimaryCommunity,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

EventStreamActionList[EventNames.ContextualMenuButtonCurrencyTransfer] = FFlagProfilePlatformEnableCurrencyTransfer
	and {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.CurrencyTransfer,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	}
	or nil

EventStreamActionList[EventNames.ContextualMenuButtonTradeItems] = FFlagProfilePlatformEnableTradeItems and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.ContextualMenuButtons.TradeItems,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

EventStreamActionList[EventNames.ContextualMenuTradeItemsImpression] = FFlagProfilePlatformEnableTradeItems
	and FFlagProfileTradeItemsImpressionLogging
	and {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.TradeItems,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	}
	or nil

EventStreamActionList[EventNames.CTAButtonOpenEditProfilePage] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.OpenEditProfilePage },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonCall] = FFlagFriendsCallingClientGate_DEV and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Call },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

EventStreamActionList[EventNames.CTAButtonChat] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Chat },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonUnlockChat] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.UnlockChat },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonUnfriend] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Unfriend },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonUnblock] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Unblock },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonAddFriend] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
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

EventStreamActionList[EventNames.CTAButtonAddFriendFromContacts] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.AddFriendFromContacts },
	formatRulesForAdditionalInfo = { shareLinkId = fn }
}

EventStreamActionList[EventNames.CTAButtonAcceptFriendRequest] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
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

EventStreamActionList[EventNames.CTAButtonEditAvatar] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.EditAvatar },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonEditLook] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.EditLook },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonShareProfile] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.ShareProfile },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

EventStreamActionList[EventNames.CTAButtonShareProfileQRCode] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.ShareProfileQRCode },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

local CTAButtonJoinCommunity = EventNames.CTAButtonJoinCommunity
local context4

if FFlagProfilePlatformUseProfileTypeContext then
	context4 = Contexts.CommunityProfile
else
	context4 = Contexts.PlayerProfile
end

EventStreamActionList[CTAButtonJoinCommunity] = {
	context = context4,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.JoinCommunity, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

EventStreamActionList[EventNames.CTAButtonFollow] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.Follow, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
}

local CTAButtonViewCommunity = EventNames.CTAButtonViewCommunity
local context5

if FFlagProfilePlatformUseProfileTypeContext then
	context5 = Contexts.CommunityProfile
else
	context5 = Contexts.PlayerProfile
end

EventStreamActionList[CTAButtonViewCommunity] = {
	context = context5,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.ViewCommunity, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

EventStreamActionList[EventNames.CTAButtonViewFullProfile] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.ViewFullProfile, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

EventStreamActionList[EventNames.CTAButtonCurrencyTransfer] = FFlagProfilePlatformEnableCurrencyTransfer and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.CTAButtons.CurrencyTransfer,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

EventStreamActionList[EventNames.CTAButtonTradeItems] = FFlagProfilePlatformEnableTradeItems and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.TradeItems, optionType = "CTAType" },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

local CTAButtonCancelJoinCommunityRequest = EventNames.CTAButtonCancelJoinCommunityRequest
local context6

if FFlagProfilePlatformUseProfileTypeContext then
	context6 = Contexts.CommunityProfile
else
	context6 = Contexts.PlayerProfile
end

EventStreamActionList[CTAButtonCancelJoinCommunityRequest] = {
	context = context6,
	eventType = EventTypes.ButtonClick,
	additionalInfo = {
		btn = AnalyticsConstants.CTAButtons.CancelJoinCommunityRequest,
		optionType = "CTAType"
	},
	formatRulesForAdditionalInfo = { buttonSurface = fn, btnContext = fn }
}

EventStreamActionList[EventNames.SchoolButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.School }
}

EventStreamActionList[EventNames.FriendsButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Friends }
}

EventStreamActionList[EventNames.FollowersButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Followers }
}

EventStreamActionList[EventNames.FollowingsButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Following }
}

EventStreamActionList[EventNames.MutualFriendsButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.MutualFriends }
}

EventStreamActionList[EventNames.ViewPlayerProfileButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
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

EventStreamActionList[EventNames.ContextualMenuButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.ContextualMenu }
}

EventStreamActionList[EventNames.GameDetailsButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.GameDetails }
}

EventStreamActionList[EventNames.EditDisplayNameButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditDisplayName },
	formatRulesForAdditionalInfo = { canSetDisplayName = fn }
}

EventStreamActionList[EventNames.SetAliasButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.SetAlias }
}

EventStreamActionList[EventNames.ProfileClosed] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.Dismissed
}

EventStreamActionList[EventNames.StoreHeaderButton] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.StoreHeader }
}

EventStreamActionList[EventNames.FavoriteExperienceOpened] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.FavoriteExperience },
	formatRulesForAdditionalInfo = { experienceId = fn, positionInComponent = fn }
}

EventStreamActionList[EventNames.FavoriteExperienceSeeAll] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.FavoriteExperienceSeeAll }
}

local ExperienceOpened = EventNames.ExperienceOpened
local context7

if FFlagProfilePlatformUseProfileTypeContext then
	context7 = Contexts.CommunityProfile
else
	context7 = Contexts.PlayerProfile
end

EventStreamActionList[ExperienceOpened] = {
	context = context7,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Experience },
	formatRulesForAdditionalInfo = { experienceId = fn, positionInComponent = fn }
}

EventStreamActionList[EventNames.EventOpened] = {
	context = Contexts.CommunityProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Event },
	formatRulesForAdditionalInfo = { virtualEventId = fn }
}

EventStreamActionList[EventNames.EventRSVP] = {
	context = Contexts.CommunityProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EventRSVP },
	formatRulesForAdditionalInfo = { virtualEventId = fn, status = fn }
}

EventStreamActionList[EventNames.EventJoined] = {
	context = Contexts.CommunityProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EventJoin },
	formatRulesForAdditionalInfo = { virtualEventId = fn }
}

EventStreamActionList[EventNames.CatalogItemOpened] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.ViewCatalogItem },
	formatRulesForAdditionalInfo = FFlagProfilePlatformUseCatalogItemOpenedNewFields and {
		btnContext = fn,
		btnUnitId = fn,
		btnSortPosition = fn
	} or { itemId = fn, positionInComponent = fn, component = fn }
}

EventStreamActionList[EventNames.UsernameCopied] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Username }
}

EventStreamActionList[EventNames.ContextualMenuButtonViewPlatformProfile] = FFlagEnablePlatformProfileContextualMenuOption
	and {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = AnalyticsConstants.ContextualMenuButtons.ViewPlatformProfile,
			optionType = "CTAType"
		},
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	}
	or nil

EventStreamActionList[EventNames.CTAButtonEditAppearance] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.CTAButtons.EditAppearance },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

EventStreamActionList[EventNames.EditAppearanceMenuEditAvatar] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceEditAvatar },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

EventStreamActionList[EventNames.EditAppearanceMenuEditEmote] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceEditEmote },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

EventStreamActionList[EventNames.EditAppearanceMenuSwitchAvatar] = FFlagProfilePlatformEnableEditAppearanceMenu and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceSwitchAvatar },
	formatRulesForAdditionalInfo = { buttonSurface = fn }
} or nil

EventStreamActionList[EventNames.EditAppearanceMenuEditBackground] = FFlagProfilePlatformEnableEditAppearanceMenu
	and FFlagProfilePlatformEditBackgroundMenuItem
	and {
		context = Contexts.PlayerProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = AnalyticsConstants.Btns.EditAppearanceEditBackground },
		formatRulesForAdditionalInfo = { buttonSurface = fn }
	}
	or nil

EventStreamActionList[EventNames.InspectAvatarOpened] = FFlagSocialEnableProfileInspectAndBuyAnalytics and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.InspectAvatar },
	formatRulesForAdditionalInfo = { profileSessionId = fn }
} or nil

EventStreamActionList[EventNames.InspectAvatarBuyClicked] = FFlagSocialEnableProfileInspectAndBuyAnalytics and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.InspectAvatarBuyItems },
	formatRulesForAdditionalInfo = { profileSessionId = fn, itemIds = fn, totalPrice = fn }
} or nil

EventStreamActionList[EventNames.InspectAvatarPurchaseConfirmed] = FFlagSocialEnableProfileInspectAndBuyAnalytics and {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.InspectAvatarConfirmBuy },
	formatRulesForAdditionalInfo = { profileSessionId = fn }
} or nil

EventStreamActionList[EventNames.MomentsSeeAll] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.MomentsSeeAll }
}

EventStreamActionList[EventNames.MomentOpened] = {
	context = Contexts.PlayerProfile,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = AnalyticsConstants.Btns.Moment }
}

return EventStreamActionList
