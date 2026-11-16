local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent
local Foundation = require(parent.Foundation)
local BuilderIcons = require(parent.BuilderIcons)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP
local Constants = require(script.Parent.Parent.Constants)
local FAVORITES_URI = Constants.FAVORITES_URI
local CONTINUE_PLAYING_URI = Constants.CONTINUE_PLAYING_URI
local SharedFlags = require(parent.SharedFlags)
local GetFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl

local defineFastString = game:DefineFastString(
	"FlyoutMomentsPlaceURI",
	"roblox://experiences/start?placeId=119524072047648"
)

local defineFastString2 = game:DefineFastString(
	"FlyoutLearnPlaceURI",
	"roblox://experiences/start?placeId=92498145666402"
)

local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local FFlagFlyoutSidePanelTradesEntry = require(script.Parent.Parent.Flags.FFlagFlyoutSidePanelTradesEntry)
local FFlagFlyoutFilterWebViewsAndBrowserLinks = SharedFlags.FFlagFlyoutFilterWebViewsAndBrowserLinks
local FFlagEnableLuaCommunityList = SharedFlags.FFlagEnableLuaCommunityList
local FFlagFlyoutResolveItemContextOnActivation = require(FlyoutSidePanel.Flags.FFlagFlyoutResolveItemContextOnActivation)
local FFlagEnableChartsInFlyout = SharedFlags.FFlagEnableChartsInFlyout
local FFlagUserLibrary = SharedFlags.FFlagUserLibrary
local Groups = require(parent.Groups)
local CommunityListRouting = Groups.CommunityListRouting

local itemType = {
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

local eventNameMappings = {
	[itemType.Premium] = "BuildersClub",
	[itemType.Connections] = "Friends",
	[itemType.Moments] = "RM",
	[itemType.Communities] = "Groups",
	[itemType.HelpAndSafety] = "SafetySupport",
	[itemType.Events] = "TheHunt",
	[itemType.QuickSignin] = "Login Code"
}

local itemTextKey = {
	[itemType.Favorites] = "Feature.Catalog.Label.Favorites",
	[itemType.ContinuePlaying] = "Feature.FlyoutSidePanel.Action.ContinuePlaying",
	[itemType.Inventory] = "CommonUI.Features.Label.Inventory",
	[itemType.Connections] = "CommonUI.Features.Label.Friends",
	[itemType.Communities] = "CommonUI.Features.Label.Groups",
	[itemType.Messages] = "CommonUI.Features.Label.Messages",
	[itemType.Settings] = "CommonUI.Features.Label.Settings",
	[itemType.HelpAndSafety] = "CommonUI.Features.Label.HelpAndSafety",
	[itemType.Moments] = "CommonUI.Features.Label.RM",
	[itemType.Charts] = "CommonUI.Features.Label.Charts",
	[itemType.UserLibrary] = "Feature.UserLibrary.Label.MyLibrary",
	[itemType.Learn] = "CommonUI.Features.Label.Learn",
	[itemType.CreateGames] = "CommonUI.Features.Label.CreateGames",
	[itemType.Premium] = "CommonUI.Features.Label.Premium",
	[itemType.GiftCards] = "CommonUI.Features.Label.GiftCards",
	[itemType.Redeem] = "CommonUI.Features.Label.Redeem",
	[itemType.Trades] = "CommonUI.Features.Label.Trades",
	[itemType.Events] = "CommonUI.Features.Label.TheHunt",
	[itemType.Terms] = "CommonUI.Features.Label.Terms",
	[itemType.Privacy] = "CommonUI.Features.Label.Privacy"
}

local destinationType2 = {
	WebView = "WebView",
	WebLink = "WebLink",
	AppPage = "AppPage",
	GameSortDeeplink = "GameSortDeeplink",
	PlaceLaunch = "PlaceLaunch"
}

local function getCommunitiesContext()
	if CommunityListRouting.getShouldUseLuaCommunityList() then
		return { appPage = AppPage.Groups, destinationType = destinationType2.AppPage }
	end

	return { url = urlBuilder.static.groups(), destinationType = destinationType2.WebView }
end

local function getResolvedItemContext(p) -- 1 equivalent call inferred from this helper
	if FFlagFlyoutResolveItemContextOnActivation and p.getContext then
		return (p.getContext())
	end

	return p.context
end

local function getDestinationType(p) -- 2 equivalent calls inferred from this helper
	local resolvedItemContext = getResolvedItemContext(p) -- inferred equivalent call

	if resolvedItemContext then
		return resolvedItemContext.destinationType
	end

	return nil
end

local function itemRequiresWebView(p, flag: boolean?): boolean
	local destinationType = getDestinationType(p) -- inferred equivalent call

	if destinationType == destinationType2.WebView then
		return true
	elseif destinationType == destinationType2.WebLink then
		return not flag
	else
		return false
	end
end

local function itemIsGameSortDeeplink(p): boolean
	return getDestinationType(p) == destinationType2.GameSortDeeplink -- inferred equivalent call
end

local v = FFlagEnableLuaCommunityList and FFlagFlyoutResolveItemContextOnActivation

local itemInfo = {
	[itemType.Favorites] = {
		itemType = itemType.Favorites,
		textKey = itemTextKey[itemType.Favorites],
		icon = BuilderIcons.Icon.Bookmark,
		context = { appUri = FAVORITES_URI, destinationType = destinationType2.GameSortDeeplink }
	},
	[itemType.ContinuePlaying] = {
		itemType = itemType.ContinuePlaying,
		textKey = itemTextKey[itemType.ContinuePlaying],
		icon = BuilderIcons.Icon.ClockSpinReverse,
		context = {
			appUri = CONTINUE_PLAYING_URI,
			destinationType = destinationType2.GameSortDeeplink
		}
	},
	[itemType.Inventory] = {
		itemType = itemType.Inventory,
		textKey = itemTextKey[itemType.Inventory],
		icon = BuilderIcons.Icon.Backpack,
		context = {
			urlGenerator = function(userId)
				return userId and urlBuilder.user.inventory({ userId = userId }) or nil
			end,
			destinationType = destinationType2.WebView
		}
	}
}

local connections = itemType.Connections
local v2 = {
	itemType = itemType.Connections,
	textKey = itemTextKey[itemType.Connections],
	icon = BuilderIcons.Icon.TwoPeople,
	context = 0
}
local appPage

if FFlagCreateConnectionsHub then
	appPage = AppPage.CoHubMyConnections
else
	appPage = AppPage.ViewFriends
end

v2.context = { appPage = appPage, destinationType = destinationType2.AppPage }
itemInfo[connections] = v2

local communities = itemType.Communities
local v3 = {
	itemType = itemType.Communities,
	textKey = itemTextKey[itemType.Communities],
	icon = BuilderIcons.Icon.ThreePeople,
	context = not v and {
		url = urlBuilder.static.groups(),
		destinationType = destinationType2.WebView
	} or nil,
	getContext = 0
}

if not v then
	getCommunitiesContext = nil
end

v3.getContext = getCommunitiesContext
itemInfo[communities] = v3

itemInfo[itemType.Messages] = {
	itemType = itemType.Messages,
	textKey = itemTextKey[itemType.Messages],
	icon = BuilderIcons.Icon.Envelope,
	context = { url = urlBuilder.static.messages(), destinationType = destinationType2.WebView }
}

itemInfo[itemType.Settings] = {
	itemType = itemType.Settings,
	textKey = itemTextKey[itemType.Settings],
	icon = BuilderIcons.Icon.Gear,
	context = { appPage = AppPage.Settings, destinationType = destinationType2.AppPage }
}

itemInfo[itemType.HelpAndSafety] = {
	itemType = itemType.HelpAndSafety,
	textKey = itemTextKey[itemType.HelpAndSafety],
	icon = BuilderIcons.Icon.ShieldLock,
	context = { appPage = AppPage.SafetySupport, destinationType = destinationType2.AppPage }
}

local moments = itemType.Moments
local v4 = {
	itemType = itemType.Moments,
	textKey = itemTextKey[itemType.Moments],
	icon = BuilderIcons.Icon.Moments,
	context = 0
}
local context

if FFlagEnableArgus then
	context = { appPage = AppPage.Moments, destinationType = destinationType2.AppPage }
else
	context = { appUri = defineFastString, destinationType = destinationType2.PlaceLaunch }
end

v4.context = context
itemInfo[moments] = v4

local charts = itemType.Charts
local v5 = {
	itemType = itemType.Charts,
	textKey = itemTextKey[itemType.Charts],
	icon = BuilderIcons.Icon.ChartThreeVerticalBars,
	context = 0
}
local appPage2

if FFlagEnableChartsInFlyout and FlyoutSidePanelIXP.isChartsInFlyoutEnabled() then
	appPage2 = AppPage.Games
end

v5.context = { appPage = appPage2, destinationType = destinationType2.AppPage }
itemInfo[charts] = v5

local userLibrary = itemType.UserLibrary
local v6 = {
	itemType = itemType.UserLibrary,
	textKey = itemTextKey[itemType.UserLibrary],
	icon = BuilderIcons.Icon.Bookmark,
	context = 0
}
local appPage3

if FFlagUserLibrary then
	appPage3 = AppPage.UserLibrary
end

v6.context = { appPage = appPage3, destinationType = destinationType2.AppPage }
itemInfo[userLibrary] = v6

itemInfo[itemType.Learn] = {
	itemType = itemType.Learn,
	textKey = itemTextKey[itemType.Learn],
	icon = BuilderIcons.Icon.PersonGraduate,
	context = { appUri = defineFastString2, destinationType = destinationType2.PlaceLaunch }
}

local createGames = itemType.CreateGames
local v7 = {
	itemType = itemType.CreateGames,
	textKey = itemTextKey[itemType.CreateGames],
	icon = BuilderIcons.Icon.Studio,
	context = 0
}
local context2 = {
	urlGenerator = function(callback)
		return callback({ utm_content = "side_panel" })
	end,
	destinationType = 0
}
local destinationType

if FFlagFlyoutFilterWebViewsAndBrowserLinks then
	destinationType = destinationType2.WebLink
else
	destinationType = destinationType2.WebView
end

context2.destinationType = destinationType
v7.context = context2
itemInfo[createGames] = v7

itemInfo[itemType.Premium] = {
	itemType = itemType.Premium,
	textKey = itemTextKey[itemType.Premium],
	icon = BuilderIcons.Icon.Premium,
	context = { appPage = AppPage.BuildersClub, destinationType = destinationType2.WebView }
}

local giftCards = itemType.GiftCards
local v8 = {
	itemType = itemType.GiftCards,
	textKey = itemTextKey[itemType.GiftCards],
	icon = BuilderIcons.Icon.GiftCard,
	context = 0
}
local context3 = {
	urlGenerator = function(p)
		return urlBuilder.static.giftCards(p)
	end,
	destinationType = 0
}
local destinationType3

if FFlagFlyoutFilterWebViewsAndBrowserLinks then
	destinationType3 = destinationType2.WebLink
else
	destinationType3 = destinationType2.WebView
end

context3.destinationType = destinationType3
v8.context = context3
itemInfo[giftCards] = v8

itemInfo[itemType.Redeem] = {
	itemType = itemType.Redeem,
	textKey = itemTextKey[itemType.Redeem],
	icon = BuilderIcons.Icon.Wallet,
	context = { url = urlBuilder.static.redeem(), destinationType = destinationType2.WebView }
}

itemInfo[itemType.Trades] = FFlagFlyoutSidePanelTradesEntry and {
	itemType = itemType.Trades,
	textKey = itemTextKey[itemType.Trades],
	icon = BuilderIcons.Icon.HandTwoArrowsHorizontal,
	context = { url = urlBuilder.static.trades(), destinationType = destinationType2.WebView }
} or nil

local events = itemType.Events
local v9 = {
	itemType = itemType.Events,
	textKey = itemTextKey[itemType.Events],
	icon = BuilderIcons.Icon.CalendarStar,
	context = 0
}
local url

if GetFStringPlatformEventUrl() == "" then
	url = urlBuilder.static.help()
else
	url = urlBuilder.fromString(GetFStringPlatformEventUrl())()
end

v9.context = { url = url, destinationType = destinationType2.WebView }
itemInfo[events] = v9

local terms = itemType.Terms
local v10 = { itemType = itemType.Terms, textKey = itemTextKey[itemType.Terms], context = 0 }
local context4 = {
	urlGenerator = function(_, p)
		local v11

		if p then
			v11 = p.getTermsOfUseLink()
		end

		if v11 == nil or v11 == "" then
			return (urlBuilder.static.about.terms({ useGameQQUrls = true }))
		end

		return v11
	end,
	destinationType = 0
}
local destinationType4

if FFlagFlyoutFilterWebViewsAndBrowserLinks then
	destinationType4 = destinationType2.WebLink
else
	destinationType4 = destinationType2.WebView
end

context4.destinationType = destinationType4
v10.context = context4
itemInfo[terms] = v10

local privacy = itemType.Privacy
local v11 = { itemType = itemType.Privacy, textKey = itemTextKey[itemType.Privacy], context = 0 }
local context5 = {
	urlGenerator = function(_, p)
		local v12

		if p then
			v12 = p.getPrivacyPolicyLink()
		end

		if v12 == nil or v12 == "" then
			return (urlBuilder.static.about.privacy({ useGameQQUrls = true }))
		end

		return v12
	end,
	destinationType = 0
}
local destinationType5

if FFlagFlyoutFilterWebViewsAndBrowserLinks then
	destinationType5 = destinationType2.WebLink
else
	destinationType5 = destinationType2.WebView
end

context5.destinationType = destinationType5
v11.context = context5
itemInfo[privacy] = v11

if FFlagEnableBlackbird and FFlagEnableBlackbirdOnFlyoutMenu then
	itemType.Blackbird = "Blackbird"
	eventNameMappings[itemType.Blackbird] = "Blackbird"

	itemTextKey[itemType.Blackbird] = "CommonUI.Features.Label.X"
	itemInfo[itemType.Blackbird] = {
		itemType = itemType.Blackbird,
		textKey = itemTextKey[itemType.Blackbird],
		icon = Foundation.Enums.IconName.RobloxPlus,
		context = { appPage = AppPage.Blackbird, destinationType = destinationType2.WebView }
	}
end

return {
	["ItemType"] = itemType,
	ItemTextKey = itemTextKey,
	ItemInfo = itemInfo,
	EventNameMappings = eventNameMappings,
	MomentsExperienceUri = defineFastString,
	DestinationType = destinationType2,
	itemRequiresWebView = itemRequiresWebView,
	itemIsGameSortDeeplink = itemIsGameSortDeeplink
}
