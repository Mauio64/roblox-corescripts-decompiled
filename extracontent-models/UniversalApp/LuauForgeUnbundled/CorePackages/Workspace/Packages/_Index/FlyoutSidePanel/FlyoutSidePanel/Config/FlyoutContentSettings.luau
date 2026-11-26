local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/BuilderIcons")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UrlBuilder").UrlBuilder
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedExperimentDefinition").FlyoutSidePanelIXP
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Constants")
local FAVORITES_URI = Constants.FAVORITES_URI
local CONTINUE_PLAYING_URI = Constants.CONTINUE_PLAYING_URI
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local getFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl

local defineFastString = game:DefineFastString(
	"FlyoutMomentsPlaceURI",
	"roblox://experiences/start?placeId=119524072047648"
)

local defineFastString2 = game:DefineFastString(
	"FlyoutLearnPlaceURI",
	"roblox://experiences/start?placeId=92498145666402"
)

local fFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local fFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local FFlagFlyoutAddAdjustScreen = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutAddAdjustScreen")
local FFlagFlyoutSidePanelTradesEntry = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutSidePanelTradesEntry")
local fFlagFlyoutFilterWebViewsAndBrowserLinks = SharedFlags.FFlagFlyoutFilterWebViewsAndBrowserLinks
local fFlagEnableLuaCommunityList = SharedFlags.FFlagEnableLuaCommunityList
local FFlagFlyoutResolveItemContextOnActivation = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutResolveItemContextOnActivation")
local fFlagEnableChartsInFlyout = SharedFlags.FFlagEnableChartsInFlyout
local fFlagUserLibrary = SharedFlags.FFlagUserLibrary
local communityListRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Groups").CommunityListRouting

local v5 = {
	Favorites = "Favorites",
	ContinuePlaying = "ContinuePlaying",
	Inventory = "Inventory",
	Connections = "Connections",
	Communities = "Communities",
	Messages = "Messages",
	Settings = "Settings",
	AdjustScreen = "AdjustScreen",
	HelpAndSafety = "HelpAndSafety",
	Moments = "Moments",
	Charts = "Charts",
	UserLibrary = "UserLibrary",
	Learn = "Learn",
	CreateGames = "CreateGames",
	Premium = "Premium",
	GiftCards = "GiftCards",
	Redeem = "Redeem",
	Trades = "Trades",
	Events = "Events",
	RobuxPill = "RobuxPill",
	QuickSignin = "QuickSignin",
	ReportLogs = "ReportLogs",
	Profile = "Profile",
	Terms = "Terms",
	Privacy = "Privacy"
}

local v6 = {
	[v5.Premium] = "BuildersClub",
	[v5.Connections] = "Friends",
	[v5.Moments] = "RM",
	[v5.Communities] = "Groups",
	[v5.HelpAndSafety] = "SafetySupport",
	[v5.Events] = "TheHunt",
	[v5.QuickSignin] = "Login Code"
}

local v7 = {
	[v5.Favorites] = "Feature.Catalog.Label.Favorites",
	[v5.ContinuePlaying] = "Feature.FlyoutSidePanel.Action.ContinuePlaying",
	[v5.Inventory] = "CommonUI.Features.Label.Inventory",
	[v5.Connections] = "CommonUI.Features.Label.Friends",
	[v5.Communities] = "CommonUI.Features.Label.Groups",
	[v5.Messages] = "CommonUI.Features.Label.Messages",
	[v5.Settings] = "CommonUI.Features.Label.Settings",
	[v5.AdjustScreen] = "CommonUI.Features.Label.AdjustScreen",
	[v5.HelpAndSafety] = "CommonUI.Features.Label.HelpAndSafety",
	[v5.Moments] = "CommonUI.Features.Label.RM",
	[v5.Charts] = "CommonUI.Features.Label.Charts",
	[v5.UserLibrary] = "Feature.UserLibrary.Label.MyLibrary",
	[v5.Learn] = "CommonUI.Features.Label.Learn",
	[v5.CreateGames] = "CommonUI.Features.Label.CreateGames",
	[v5.Premium] = "CommonUI.Features.Label.Premium",
	[v5.GiftCards] = "CommonUI.Features.Label.GiftCards",
	[v5.Redeem] = "CommonUI.Features.Label.Redeem",
	[v5.Trades] = "CommonUI.Features.Label.Trades",
	[v5.Events] = "CommonUI.Features.Label.TheHunt",
	[v5.Terms] = "CommonUI.Features.Label.Terms",
	[v5.Privacy] = "CommonUI.Features.Label.Privacy"
}

local v8 = {
	WebView = "WebView",
	WebLink = "WebLink",
	AppPage = "AppPage",
	GameSortDeeplink = "GameSortDeeplink",
	PlaceLaunch = "PlaceLaunch"
}

local function getCommunitiesContext()
	if communityListRouting.getShouldUseLuaCommunityList() then
		return { appPage = appPage.Groups, destinationType = v8.AppPage }
	end

	return { url = urlBuilder.static.groups(), destinationType = v8.WebView }
end

local function getResolvedItemContext(p2)
	if FFlagFlyoutResolveItemContextOnActivation and p2.getContext then
		return (p2.getContext())
	end

	return p2.context
end

local function getDestinationType(p2)
	local v9 = if FFlagFlyoutResolveItemContextOnActivation and p2.getContext then p2.getContext() else p2.context

	if v9 then
		return v9.destinationType
	end

	return nil
end

local function itemRequiresWebView(p2, p3)
	local v9 = if FFlagFlyoutResolveItemContextOnActivation and p2.getContext then p2.getContext() else p2.context

	local destinationType = if v9 then v9.destinationType else nil

	local v10 = destinationType == v8.WebView or destinationType == v8.WebLink and not p3
	return v10
end

local function itemIsGameSortDeeplink(p2): boolean
	local v9 = if FFlagFlyoutResolveItemContextOnActivation and p2.getContext then p2.getContext() else p2.context

	return (if v9 then v9.destinationType else nil) == v8.GameSortDeeplink
end

local v9 = fFlagEnableLuaCommunityList and FFlagFlyoutResolveItemContextOnActivation

local v10 = {
	[v5.Favorites] = {
		itemType = v5.Favorites,
		textKey = v7[v5.Favorites],
		icon = BuilderIcons.Icon.Bookmark,
		context = { appUri = FAVORITES_URI, destinationType = v8.GameSortDeeplink }
	},
	[v5.ContinuePlaying] = {
		itemType = v5.ContinuePlaying,
		textKey = v7[v5.ContinuePlaying],
		icon = BuilderIcons.Icon.ClockSpinReverse,
		context = {
			appUri = CONTINUE_PLAYING_URI,
			destinationType = v8.GameSortDeeplink
		}
	},
	[v5.Inventory] = {
		itemType = v5.Inventory,
		textKey = v7[v5.Inventory],
		icon = BuilderIcons.Icon.Backpack,
		context = {
			urlGenerator = function(p2)
				return p2 and urlBuilder.user.inventory({ userId = p2 }) or nil
			end,
			destinationType = v8.WebView
		}
	}
}

local connections = v5.Connections
local v11 = {
	itemType = v5.Connections,
	textKey = v7[v5.Connections],
	icon = BuilderIcons.Icon.TwoPeople,
	context = 0
}

local v13 = if fFlagCreateConnectionsHub then appPage.CoHubMyConnections else appPage.ViewFriends
v11.context = { appPage = v13, destinationType = v8.AppPage }
v10[connections] = v11

local communities = v5.Communities
local v14 = {
	itemType = v5.Communities,
	textKey = v7[v5.Communities],
	icon = BuilderIcons.Icon.ThreePeople,
	context = not v9 and {
		url = urlBuilder.static.groups(),
		destinationType = v8.WebView
	} or nil,
	getContext = 0
}

if not v9 then
	getCommunitiesContext = nil
end

v14.getContext = getCommunitiesContext
v10[communities] = v14

v10[v5.Messages] = {
	itemType = v5.Messages,
	textKey = v7[v5.Messages],
	icon = BuilderIcons.Icon.Envelope,
	context = { url = urlBuilder.static.messages(), destinationType = v8.WebView }
}

v10[v5.Settings] = {
	itemType = v5.Settings,
	textKey = v7[v5.Settings],
	icon = BuilderIcons.Icon.Gear,
	context = { appPage = appPage.Settings, destinationType = v8.AppPage }
}

v10[v5.AdjustScreen] = FFlagFlyoutAddAdjustScreen and {
	itemType = v5.AdjustScreen,
	textKey = v7[v5.AdjustScreen],
	icon = BuilderIcons.Icon.SquareDualArrowsToCorner,
	context = { appPage = appPage.AdjustScreen, destinationType = v8.AppPage }
} or nil

v10[v5.HelpAndSafety] = {
	itemType = v5.HelpAndSafety,
	textKey = v7[v5.HelpAndSafety],
	icon = BuilderIcons.Icon.ShieldLock,
	context = { appPage = appPage.SafetySupport, destinationType = v8.AppPage }
}

local moments = v5.Moments
local v15 = {
	itemType = v5.Moments,
	textKey = v7[v5.Moments],
	icon = BuilderIcons.Icon.Moments,
	context = 0
}

local v16 = if fFlagEnableArgus then {
	appPage = appPage.Moments,
	destinationType = v8.AppPage
} else { appUri = defineFastString, destinationType = v8.PlaceLaunch }
v15.context = v16
v10[moments] = v15

local charts = v5.Charts
local v17 = {
	itemType = v5.Charts,
	textKey = v7[v5.Charts],
	icon = BuilderIcons.Icon.ChartThreeVerticalBars,
	context = 0
}

local v19 = if fFlagEnableChartsInFlyout and flyoutSidePanelIXP.isChartsInFlyoutEnabled() then appPage.Games else nil
v17.context = { appPage = v19, destinationType = v8.AppPage }
v10[charts] = v17

local userLibrary = v5.UserLibrary
local v20 = {
	itemType = v5.UserLibrary,
	textKey = v7[v5.UserLibrary],
	icon = BuilderIcons.Icon.Bookmark,
	context = 0
}

local v22 = if fFlagUserLibrary then appPage.UserLibrary else nil
v20.context = { appPage = v22, destinationType = v8.AppPage }
v10[userLibrary] = v20

v10[v5.Learn] = {
	itemType = v5.Learn,
	textKey = v7[v5.Learn],
	icon = BuilderIcons.Icon.PersonGraduate,
	context = { appUri = defineFastString2, destinationType = v8.PlaceLaunch }
}

local createGames = v5.CreateGames
local v23 = {
	itemType = v5.CreateGames,
	textKey = v7[v5.CreateGames],
	icon = BuilderIcons.Icon.Studio,
	context = 0
}

local v25 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v8.WebLink else v8.WebView
v23.context = {
	urlGenerator = function(callback)
		return callback({ utm_content = "side_panel" })
	end,
	destinationType = v25
}
v10[createGames] = v23

v10[v5.Premium] = {
	itemType = v5.Premium,
	textKey = v7[v5.Premium],
	icon = BuilderIcons.Icon.Premium,
	context = { appPage = appPage.BuildersClub, destinationType = v8.WebView }
}

local giftCards = v5.GiftCards
local v26 = {
	itemType = v5.GiftCards,
	textKey = v7[v5.GiftCards],
	icon = BuilderIcons.Icon.GiftCard,
	context = 0
}
local v27 = {
	urlGenerator = function(p2)
		return urlBuilder.static.giftCards(p2)
	end,
	destinationType = 0
}

local v28 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v8.WebLink else v8.WebView
v27.destinationType = v28
v26.context = v27
v10[giftCards] = v26

v10[v5.Redeem] = {
	itemType = v5.Redeem,
	textKey = v7[v5.Redeem],
	icon = BuilderIcons.Icon.Wallet,
	context = { url = urlBuilder.static.redeem(), destinationType = v8.WebView }
}

v10[v5.Trades] = FFlagFlyoutSidePanelTradesEntry and {
	itemType = v5.Trades,
	textKey = v7[v5.Trades],
	icon = BuilderIcons.Icon.HandTwoArrowsHorizontal,
	context = { url = urlBuilder.static.trades(), destinationType = v8.WebView }
} or nil

local events = v5.Events
local v29 = {
	itemType = v5.Events,
	textKey = v7[v5.Events],
	icon = BuilderIcons.Icon.CalendarStar,
	context = 0
}

local v31 = if getFStringPlatformEventUrl() == "" then urlBuilder.static.help() else urlBuilder.fromString(getFStringPlatformEventUrl())()
v29.context = { url = v31, destinationType = v8.WebView }
v10[events] = v29

local terms = v5.Terms
local v32 = { itemType = v5.Terms, textKey = v7[v5.Terms], context = 0 }
local v33 = {
	urlGenerator = function(p2, p3)
		local v34 = if p3 then p3.getTermsOfUseLink() else nil

		if v34 == nil or v34 == "" then
			v34 = urlBuilder.static.about.terms({ useGameQQUrls = true })
		end

		return v34
	end,
	destinationType = 0
}

local v34 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v8.WebLink else v8.WebView
v33.destinationType = v34
v32.context = v33
v10[terms] = v32

local privacy = v5.Privacy
local v35 = { itemType = v5.Privacy, textKey = v7[v5.Privacy], context = 0 }
local v36 = {
	urlGenerator = function(p2, p3)
		local v37 = if p3 then p3.getPrivacyPolicyLink() else nil

		if v37 == nil or v37 == "" then
			v37 = urlBuilder.static.about.privacy({ useGameQQUrls = true })
		end

		return v37
	end,
	destinationType = 0
}

local v37 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v8.WebLink else v8.WebView
v36.destinationType = v37
v35.context = v36
v10[privacy] = v35

if fFlagEnableBlackbird and fFlagEnableBlackbirdOnFlyoutMenu then
	v5.Blackbird = "Blackbird"
	v6[v5.Blackbird] = "Blackbird"

	v7[v5.Blackbird] = "CommonUI.Features.Label.X"
	v10[v5.Blackbird] = {
		itemType = v5.Blackbird,
		textKey = v7[v5.Blackbird],
		icon = Foundation.Enums.IconName.RobloxPlus,
		context = { appPage = appPage.Blackbird, destinationType = v8.WebView }
	}
end

return {
	["ItemType"] = v5,
	ItemTextKey = v7,
	ItemInfo = v10,
	EventNameMappings = v6,
	MomentsExperienceUri = defineFastString,
	DestinationType = v8,
	itemRequiresWebView = itemRequiresWebView,
	itemIsGameSortDeeplink = itemIsGameSortDeeplink
}
