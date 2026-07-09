local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local Foundation = require(Parent.Foundation)
local BuilderIcons = require(Parent.BuilderIcons)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local AppPage = require(Parent.RobloxAppEnums).AppPage
local Constants = require(script.Parent.Parent.Constants)
local FAVORITES_URI = Constants.FAVORITES_URI
local CONTINUE_PLAYING_URI = Constants.CONTINUE_PLAYING_URI
local SharedFlags = require(Parent.SharedFlags)
local GetFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local v11 = game:DefineFastString("FlyoutMomentsPlaceURI", "roblox://experiences/start?placeId=119524072047648")
local v12 = game:DefineFastString("FlyoutLearnPlaceURI", "roblox://experiences/start?placeId=92498145666402")
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusFlyoutEntry = SharedFlags.FFlagEnableArgusFlyoutEntry
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagFlyoutTermsPrivacyFooter = require(script.Parent.Parent.Flags.FFlagFlyoutTermsPrivacyFooter)
local GetFFlagEnableCommunityListExperimentation = SharedFlags.GetFFlagEnableCommunityListExperimentation
local CommunityListExperimentation = require(Parent.Groups).Experiments.CommunityListExperimentation
local t1 = {
	Favorites = "Favorites",
	ContinuePlaying = "ContinuePlaying",
	Inventory = "Inventory",
	Connections = "Connections",
	Communities = "Communities",
	Messages = "Messages",
	Settings = "Settings",
	HelpAndSafety = "HelpAndSafety",
	Moments = "Moments",
	Charts = "Charts",
	Learn = "Learn",
	CreateGames = "CreateGames",
	Premium = "Premium",
	GiftCards = "GiftCards",
	Redeem = "Redeem",
	Events = "Events",
	RobuxPill = "RobuxPill",
	QuickSignin = "QuickSignin",
	ReportLogs = "ReportLogs",
	Profile = "Profile",
	Terms = "Terms",
	Privacy = "Privacy"
}
local t2 = {
	[t1.Premium] = "BuildersClub",
	[t1.Connections] = "Friends",
	[t1.Moments] = "RM",
	[t1.Communities] = "Groups",
	[t1.HelpAndSafety] = "SafetySupport",
	[t1.Events] = "TheHunt",
	[t1.QuickSignin] = "Login Code"
}
local t3 = {
	[t1.Favorites] = "Feature.Catalog.Label.Favorites",
	[t1.ContinuePlaying] = "Feature.FlyoutSidePanel.Action.ContinuePlaying",
	[t1.Inventory] = "CommonUI.Features.Label.Inventory",
	[t1.Connections] = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.Connections" or "CommonUI.Features.Label.Friends",
	[t1.Communities] = "CommonUI.Features.Label.Groups",
	[t1.Messages] = "CommonUI.Features.Label.Messages",
	[t1.Settings] = "CommonUI.Features.Label.Settings",
	[t1.HelpAndSafety] = "CommonUI.Features.Label.HelpAndSafety",
	[t1.Moments] = "CommonUI.Features.Label.RM",
	[t1.Charts] = "CommonUI.Features.Label.Charts",
	[t1.Learn] = "CommonUI.Features.Label.Learn",
	[t1.CreateGames] = "CommonUI.Features.Label.CreateGames",
	[t1.Premium] = "CommonUI.Features.Label.Premium",
	[t1.GiftCards] = "CommonUI.Features.Label.GiftCards",
	[t1.Redeem] = "CommonUI.Features.Label.Redeem",
	[t1.Events] = "CommonUI.Features.Label.TheHunt",
	[t1.Terms] = if not FFlagFlyoutTermsPrivacyFooter then nil else "CommonUI.Features.Label.Terms",
	[t1.Privacy] = if not FFlagFlyoutTermsPrivacyFooter then nil else "CommonUI.Features.Label.Privacy"
}
local t4 = {
	[t1.Favorites] = {
		itemType = t1.Favorites,
		textKey = t3[t1.Favorites],
		icon = BuilderIcons.Icon.Bookmark,
		context = {
			appUri = FAVORITES_URI
		}
	},
	[t1.ContinuePlaying] = {
		itemType = t1.ContinuePlaying,
		textKey = t3[t1.ContinuePlaying],
		icon = BuilderIcons.Icon.ClockSpinReverse,
		context = {
			appUri = CONTINUE_PLAYING_URI
		}
	},
	[t1.Inventory] = {
		itemType = t1.Inventory,
		textKey = t3[t1.Inventory],
		icon = BuilderIcons.Icon.Backpack,
		context = {
			urlGenerator = function(p1) -- line: 120
				-- upvalues: UrlBuilder (copy)
				return p1 and UrlBuilder.user.inventory({
					userId = p1
				}) or nil
			end
		}
	},
	[t1.Connections] = {
		itemType = t1.Connections,
		textKey = t3[t1.Connections],
		icon = BuilderIcons.Icon.TwoPeople,
		context = {
			appPage = if not FFlagCreateConnectionsHub then AppPage.ViewFriends else AppPage.CoHubMyConnections
		}
	},
	[t1.Communities] = {
		itemType = t1.Communities,
		textKey = t3[t1.Communities],
		icon = BuilderIcons.Icon.ThreePeople,
		context = if not GetFFlagEnableCommunityListExperimentation() or not CommunityListExperimentation.getCommunityListEnabled() then {
			url = UrlBuilder.static.groups()
		} else {
			appPage = AppPage.Groups
		}
	},
	[t1.Messages] = {
		itemType = t1.Messages,
		textKey = t3[t1.Messages],
		icon = BuilderIcons.Icon.Envelope,
		context = {
			url = UrlBuilder.static.messages()
		}
	},
	[t1.Settings] = {
		itemType = t1.Settings,
		textKey = t3[t1.Settings],
		icon = BuilderIcons.Icon.Gear,
		context = {
			appPage = AppPage.Settings
		}
	},
	[t1.HelpAndSafety] = {
		itemType = t1.HelpAndSafety,
		textKey = t3[t1.HelpAndSafety],
		icon = BuilderIcons.Icon.ShieldLock,
		context = {
			appPage = AppPage.SafetySupport
		}
	},
	[t1.Moments] = {
		itemType = t1.Moments,
		textKey = t3[t1.Moments],
		icon = BuilderIcons.Icon.Moments,
		context = if not FFlagEnableArgusFlyoutEntry or not FFlagEnableArgus then {
			appUri = v11
		} else {
			appPage = AppPage.Moments
		}
	},
	[t1.Charts] = {
		itemType = t1.Charts,
		textKey = t3[t1.Charts],
		icon = BuilderIcons.Icon.ChartThreeVerticalBars,
		context = {}
	},
	[t1.Learn] = {
		itemType = t1.Learn,
		textKey = t3[t1.Learn],
		icon = BuilderIcons.Icon.PersonGraduate,
		context = {
			appUri = v12
		}
	},
	[t1.CreateGames] = {
		itemType = t1.CreateGames,
		textKey = t3[t1.CreateGames],
		icon = BuilderIcons.Icon.Studio,
		context = {
			urlGenerator = function(p2) -- line: 193
				return p2({
					utm_content = "side_panel"
				})
			end
		}
	},
	[t1.Premium] = {
		itemType = t1.Premium,
		textKey = t3[t1.Premium],
		icon = BuilderIcons.Icon.Premium,
		context = {
			appPage = AppPage.BuildersClub
		}
	},
	[t1.GiftCards] = {
		itemType = t1.GiftCards,
		textKey = t3[t1.GiftCards],
		icon = BuilderIcons.Icon.GiftCard,
		context = {
			urlGenerator = function(p3) -- line: 211
				-- upvalues: UrlBuilder (copy)
				return UrlBuilder.static.giftCards(p3)
			end
		}
	},
	[t1.Redeem] = {
		itemType = t1.Redeem,
		textKey = t3[t1.Redeem],
		icon = BuilderIcons.Icon.Wallet,
		context = {
			url = UrlBuilder.static.redeem()
		}
	},
	[t1.Events] = {
		itemType = t1.Events,
		textKey = t3[t1.Events],
		icon = BuilderIcons.Icon.CalendarStar,
		context = {
			url = if GetFStringPlatformEventUrl() == "" then UrlBuilder.static.help() else UrlBuilder.fromString(GetFStringPlatformEventUrl())()
		}
	},
	[t1.Terms] = if not FFlagFlyoutTermsPrivacyFooter then nil else {
		itemType = t1.Terms,
		textKey = t3[t1.Terms],
		context = {
			urlGenerator = function(_, p5) -- line: 239
				-- upvalues: UrlBuilder (copy)
				local v31 = nil

				if p5 then
					v31 = p5.getTermsOfUseLink()
				end

				if v31 == nil or v31 == "" then
					v31 = UrlBuilder.static.about.terms({
						useGameQQUrls = true
					})
				end

				return v31
			end
		}
	},
	[t1.Privacy] = if not FFlagFlyoutTermsPrivacyFooter then nil else {
		itemType = t1.Privacy,
		textKey = t3[t1.Privacy],
		context = {
			urlGenerator = function(_, p7) -- line: 257
				-- upvalues: UrlBuilder (copy)
				local v34 = nil

				if p7 then
					v34 = p7.getPrivacyPolicyLink()
				end

				if v34 == nil or v34 == "" then
					v34 = UrlBuilder.static.about.privacy({
						useGameQQUrls = true
					})
				end

				return v34
			end
		}
	}
}

if FFlagEnableBlackbird and FFlagEnableBlackbirdOnFlyoutMenu then
	t1.Blackbird = "Blackbird"
	t2[t1.Blackbird] = "Blackbird"
	t3[t1.Blackbird] = "CommonUI.Features.Label.X"
	t4[t1.Blackbird] = {
		itemType = t1.Blackbird,
		textKey = t3[t1.Blackbird],
		icon = Foundation.Enums.IconName.RobloxPlus,
		context = {
			appPage = AppPage.Blackbird
		}
	}
end

return {
	ItemType = t1,
	ItemTextKey = t3,
	ItemInfo = t4,
	EventNameMappings = t2
}
