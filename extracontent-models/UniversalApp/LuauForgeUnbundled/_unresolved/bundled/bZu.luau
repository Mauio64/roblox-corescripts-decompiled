local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/bZv")
local Rodux = require(CorePackages.Packages.Rodux)

local module2 = require("@luauforge/bundled/cio")
local module3 = require("@luauforge/bundled/ciD")
local module4 = require("@luauforge/bundled/ciF")
local module5 = require("@luauforge/bundled/cqV")
local module6 = require("@luauforge/bundled/cxg")
local module7 = require("@luauforge/bundled/cxi")
local module8 = require("@luauforge/bundled/cye")
local module9 = require("@luauforge/bundled/cAK")
local module10 = require("@luauforge/bundled/cAL")
local module11 = require("@luauforge/bundled/cAM")
local module12 = require("@luauforge/bundled/cAN")
local squadLocation = require("@luauforge/bundled/cAW").SquadLocation
local module13 = require("@luauforge/bundled/cAX")
local gamesProductInfoReducer = require("@luauforge/bundled/cAZ").GamesProductInfoReducer
local launchContext = require("@luauforge/bundled/cBa").Reducers.LaunchContext
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local module15 = require("@luauforge/bundled/cBc")
local omniFeedTypes = module15.OmniFeedTypes
local module16 = require("@luauforge/bundled/cBd")
local module17 = require("@luauforge/bundled/cDA")
local module18 = require("@luauforge/bundled/cEn")
local module19 = require("@luauforge/bundled/cEZ")
local module20 = require("@luauforge/bundled/dta")
local modules = require("@luauforge/bundled/dtb").Modules
local getFFlagEnableHomePageUpsellCard = modules.LuaApp.Flags.GetFFlagEnableHomePageUpsellCard
local module21 = require("@luauforge/bundled/dzh")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled
local module22 = require("@luauforge/bundled/dzi")
local fFlagUseSignalsForSearchBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSearchBar

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt

local fFlagUseSignalsForGlobalContextMenuInset = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForGlobalContextMenuInset
local fFlagUseSignalsForCountryCode = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForCountryCode
local fFlagUseSignalsForSiteMessage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSiteMessage

local fFlagUseSignalsForScreenGuiBlur = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForScreenGuiBlur

local fFlagUseSignalsForIsLocalUserUnder13 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserUnder13
local fFlagUseSignalsForPlatform = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForPlatform
local fFlagUseSignalsForStartup = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForStartup

local fFlagUseSignalsForAppTopBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAppTopBanner

local fFlagRemoveUnusedConnectionStateRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedConnectionStateRoduxSlice

local fFlagRemoveUnusedFriendCountRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedFriendCountRoduxSlice

local fFlagRemoveUnusedFriendStatusesRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedFriendStatusesRoduxSlice

local fFlagRemoveUnusedSignUpInfoRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedSignUpInfoRoduxSlice

local fFlagRemoveUnusedGameThumbnailsRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedGameThumbnailsRoduxSlice

local fFlagRemoveUnusedUsersAsyncRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedUsersAsyncRoduxSlice

local fFlagRemoveUnusedUserStatusesRoduxSlice = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagRemoveUnusedUserStatusesRoduxSlice
local getFFlagLuaAppEnableTopBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableTopBanner

local fFlagEnableUserAccessServiceIntegration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableUserAccessServiceIntegration
local module23 = require("@luauforge/bundled/dzj")

local fFlagEnableSocialProofUserList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialProofUserList

local fFlagEnablePlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardComponent
local fFlagEnableUserListModule = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableUserListModule
local fFlagEnableSocialTabsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialTabsPage
local fFlagUseSignalsRoduxStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsRoduxStore

local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForCountryCodeList

local fFlagUseSignalsForIsLocalUserSoothsayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserSoothsayer
local fFlagUseSignalsForModeration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForModeration
local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForUserAccess

local fFlagUseSignalsForGameInvitesStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForGameInvitesStatus

local fFlagUseSignalsForRobuxVirtualItem = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForRobuxVirtualItem
local combineReducers

if fFlagUseSignalsRoduxStore then
	combineReducers = require("@luauforge/bundled/dzk").combineReducers
else
	combineReducers = Rodux.combineReducers
end

local function globalActionReducer(data, p2)
	return p2.type == module3.name and {
		ScreenSize = data.ScreenSize,
		DeviceOrientation = data.DeviceOrientation,
		FormFactor = data.FormFactor,
		GlobalGuiInset = data.GlobalGuiInset,
		TopBar = data.TopBar,
		AuthenticationStatus = data.AuthenticationStatus
	} or data
end

local v5 = {}
v5.DeviceOrientation = require("@luauforge/bundled/dzr")
v5.TopBar = require("@luauforge/bundled/dzy")
local v6 = if not fFlagUseSignalsForSiteMessage then require("@luauforge/bundled/dzJ") else nil
v5.SiteMessage = v6
v5.TabBarVisible = require("@luauforge/bundled/dzQ").Reducers.TabBarVisible
v5.GamepadBottomBar = require("@luauforge/bundled/dzR")
v5.FetchingStatus = require("@game/CoreGui/RobloxGui/Modules/Feedback/Reducers")
v5.LaunchContext = launchContext

local v7 = if not (fFlagUseSignalsForAppTopBanner or not getFFlagLuaAppEnableTopBanner()) then require("@luauforge/bundled/dzW").Reducers.AppTopBannerReducer else nil
v5.AppTopBanner = v7

v5.Users = require("@luauforge/bundled/dAv")
local v8 = if not fFlagRemoveUnusedUsersAsyncRoduxSlice then require("@luauforge/bundled/dAw") else nil
v5.UsersAsync = v8

local v9 = if not fFlagRemoveUnusedUserStatusesRoduxSlice then require("@luauforge/bundled/dAA") else nil
v5.UserStatuses = v9

v5.LocalUserId = require("@luauforge/bundled/ciE").Reducers.LocalUserIdReducer
v5.InGameUsersByGame = require("@luauforge/bundled/dAE")

local v10 = if not fFlagUseSignalsForIsLocalUserSoothsayer then require("@luauforge/bundled/dAG") else nil
v5.IsLocalUserSoothsayer = v10

local v11 = if not fFlagRemoveUnusedSignUpInfoRoduxSlice then require("@luauforge/bundled/dAI") else nil
v5.SignUpInfo = v11

local v12 = if not fFlagUseSignalsForCountryCodeList then AuthCommon.Reducers.CountryCodeList else nil
v5.CountryCodeList = v12

local v13 = if not fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dAW").CountryCodeReducer else nil
v5.CountryCode = v13

v5.GameSortGroups = modules.LuaApp.Reducers.Games.GameSortGroups

local v14 = if not fFlagRemoveUnusedGameThumbnailsRoduxSlice then require("@luauforge/bundled/dBf").GameThumbnailsReducer else nil
v5.GameThumbnails = v14

v5.GameDetails = require("@luauforge/bundled/dBl").GameDetails.GameDetailReducer
v5.GameDetailsV2 = require("@luauforge/bundled/dBl").GameDetails.GameDetailsV2Reducer
v5.GameDetailErrors = require("@luauforge/bundled/dBl").GameDetails.GameDetailErrorReducer
v5.GameSocialLinks = require("@luauforge/bundled/dBm")
v5.GameFollowings = require("@luauforge/bundled/dBo")
v5.ExperienceNotificationsEnabled = require("@luauforge/bundled/dBr")
v5.GamePasses = require("@luauforge/bundled/dBu")
v5.PassesThumbnails = require("@luauforge/bundled/dBw")
v5.GameSubscriptionProducts = require("@luauforge/bundled/dBy")
v5.SubscriptionProductsThumbnails = require("@luauforge/bundled/dBA")
v5.SubscriptionStatuses = require("@luauforge/bundled/dBC")
v5.GameDeveloperProducts = require("@luauforge/bundled/dBF")
v5.DeveloperProductsThumbnails = require("@luauforge/bundled/dBH")
v5.DeveloperProductStatuses = require("@luauforge/bundled/dBJ")
v5.GameBadges = require("@luauforge/bundled/dBL")
v5.ShowAgeVerificationOverlay = require("@luauforge/bundled/dBN").AgeVerificationOverlay.ShowAgeVerificationOverlay
v5.VoiceChatOptInStatus = require("@luauforge/bundled/dBN").OptInStatus.VoiceChatOptInStatus
v5.UserRobux = require("@luauforge/bundled/dBO")
v5.GameCoPlay = require("@luauforge/bundled/dBQ")
v5.GameVotes = require("@luauforge/bundled/dBR").GameVotes.GameVotes
v5.UserGameVotes = require("@luauforge/bundled/dBR").UserGameVotes.UserGameVotes
local v15 = if module21() then require("@luauforge/bundled/dBS").Reducers.LocalUserGameVoteCounter else nil
v5.LocalUserGameVoteCounter = v15

v5.GameFavorites = require("@luauforge/bundled/dCB")
v5.GamePrivateServersEnabled = require("@luauforge/bundled/dCD")
v5[gamesProductInfoReducer.key] = gamesProductInfoReducer.reducer
v5.OmniRecommendationsRefreshTime = modules.LuaApp.Reducers.Games.OmniRecommendationsRefreshTime
v5.RecommendedGameEntries = require("@luauforge/bundled/dCF")
v5.GameMedia = modules.LuaApp.Reducers.Games.GameMedia
v5.GameDetailsPeekView = require("@luauforge/bundled/dCH")
local v16 = if not fFlagUseSignalsForSearchBar then require("@luauforge/bundled/dCL") else nil
v5.SearchBar = v16
v5.OmniRecommendations = modules.LuaApp.Reducers.Games.OmniRecommendations
v5.Personalization = require("@luauforge/bundled/dCN")
v5.AgeRecommendations = require("@luauforge/bundled/dBl").AgeRecommendations.AgeRecommendationsReducer
v5.AgeRecommendationHeaders = require("@luauforge/bundled/dBl").AgeRecommendations.AgeRecommendationHeaders
v5.AssetTextFilterSettings = require("@luauforge/bundled/dEh")
v5.CommunityLinks = require("@luauforge/bundled/dEj").installReducer()

v5.CatalogAssets = require("@luauforge/bundled/dEX")
v5.CatalogBundles = require("@luauforge/bundled/dEY")

v5.PlayabilityStatus = require("@luauforge/bundled/dEZ").PlayabilityStatus.PlayabilityStatusReducer
v5.UniversePlaceInfos = require("@luauforge/bundled/dFa").Reducers.UniversePlaceInfos
v5.AutocompleteSuggestions = require("@luauforge/bundled/dFb")
v5.UsersSearchResults = require("@luauforge/bundled/dFf")

local v17 = if not fFlagRemoveUnusedFriendStatusesRoduxSlice then require("@game/CorePackages/Packages/_Index/RoduxFriends/RoduxFriends/Reducers/Friends/friendshipStatus") else nil
v5.FriendStatuses = v17

v5.CurrentToastMessages = require("@luauforge/bundled/dFl")
v5.CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Reducers.CentralOverlayReducer

v5.RequestsStatus = modules.LuaApp.Reducers.RequestsStatus

v5.Navigation = require("@luauforge/bundled/dFq")

v5.Search = require("@luauforge/bundled/hTQ")
v5.SearchesParameters = require("@luauforge/bundled/hTU")
v5.SearchTimes = require("@luauforge/bundled/hTV")
v5.SearchesTypes = require("@luauforge/bundled/hTW")

local v18 = if not fFlagRemoveUnusedFriendCountRoduxSlice then require("@luauforge/bundled/hTX").Reducers.FriendCount else nil
v5.FriendCount = v18

v5.FriendPresenceCounts = require("@luauforge/bundled/hTX").Reducers.FriendPresenceCounts

local v19 = if not fFlagRemoveUnusedConnectionStateRoduxSlice then require("@luauforge/bundled/hTY") else nil
v5.ConnectionState = v19

v5.HomePageUpsellCardVariation = getFFlagEnableHomePageUpsellCard()
	and modules.LuaApp.Reducers.HomePageUpsellCardVariation
	or nil

local v20 = if not fFlagUseSignalsForGameInvitesStatus then require("@luauforge/bundled/hUa").GameInvitesStatusReducer else nil
v5.GameInvitesStatus = v20

v5.GlobalGuiInset = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/Core/Layout/LayerCollector/LayerCollectorContext")

local v21 = if not fFlagUseSignalsForGlobalContextMenuInset then require("@luauforge/bundled/hUd") else nil
v5.GlobalContextMenuInset = v21

v5.ScreenSize = require("@luauforge/bundled/hUf")
v5.FormFactor = require("@luauforge/bundled/dGN").FormFactorReducer
local v22 = if not fFlagUseSignalsForScreenGuiBlur then require("@luauforge/bundled/hUh") else nil
v5.ScreenGuiBlur = v22
local v23 = if not fFlagUseSignalsForPlatform then require("@luauforge/bundled/hUj") else nil
v5.Platform = v23

v5.ChatAppReducer = module()
v5.AvatarExperience = require("@luauforge/bundled/dKV")
v5.Luobu = require("@luauforge/bundled/hUl")

local v24 = if not fFlagUseSignalsForStartup then require("@luauforge/bundled/hUu") else nil
v5.Startup = v24
v5.NotificationBadgeCounts = require("@luauforge/bundled/hUw")

v5.DevSubs = require("@luauforge/bundled/hUy")

v5.IAPProducts = require("@luauforge/bundled/hUA")
v5.NativePurchase = require("@luauforge/bundled/hUB")
local v25 = if module22() then require("@luauforge/bundled/hUC") else nil
v5.NativeRobuxProducts = v25

v5.AuthenticationStatus = require("@luauforge/bundled/ggh").Reducers.AuthenticationStatusReducer

local v26 = if not fFlagUseSignalsForIsLocalUserUnder13 then require("@luauforge/bundled/ciE").Reducers.IsLocalUserUnder13Reducer else nil
v5.IsLocalUserUnder13 = v26

v5.SocialTab = require("@luauforge/bundled/hGn").installReducer()
v5.FriendsLanding = require("@luauforge/bundled/hUD")()
v5.AddFriends = require("@luauforge/bundled/hUI").installReducer()
v5.ProfilePlatform = require("@luauforge/bundled/hUJ")()
v5[module9.RoduxKey] = module9.installReducer()
local v27 = if fFlagEnableSocialProofUserList then module18.installReducer() else nil
v5.SocialProof = v27
local roduxKey = module19.RoduxKey
local v28 = if fFlagEnableSocialTabsPage then module19.installReducer() else nil
v5[roduxKey] = v28
local v29 = if fFlagEnableUserListModule then module20.installReducer() else nil
v5.UserList = v29
v5.ProfileShareLinks = module10.Rodux.installReducer()
v5[module5.RoduxKey] = module5.installReducer()
v5.InviteLinkExpiredModal = require("@luauforge/bundled/gFD").installReducer()

local v30 = if not fFlagUseSignalsForModeration then require("@luauforge/bundled/hUK") else nil
v5.Moderation = v30

local v31 = if not fFlagUseSignalsForAccountSecurityPrompt then require("@luauforge/bundled/hUL") else nil
v5.AccountSecurityPrompt = v31

v5.FriendsCarousel = require("@luauforge/bundled/hUN").installReducer()
v5.VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges").installReducer()
v5.VirtualEvents = require("@luauforge/bundled/hUP").installReducer()
v5[module2.RoduxKey] = module2.installReducer()
v5[module4.RoduxKey] = module4.installReducer({
	contentType = module15.OmniRecommendationsContentType.RecommendedFriend,
	treatmentType = omniFeedTypes.FriendRecommendationCarousel
})

v5[module6.RoduxKey] = module6.installReducer()
v5[module7.RoduxKey] = module7.installReducer()
v5[module8.RoduxKey] = module8.installReducer()
v5[module13.RODUX_KEY] = require("@luauforge/bundled/hUQ")()
local RODUX_KEY = module11.RODUX_KEY
local v32 = if getFFlagIsSquadEnabled() then module12(squadLocation.InApp) else nil
v5[RODUX_KEY] = v32

v5.CrossPlaySettings = require("@luauforge/bundled/hSB").Reducers.CrossPlaySettings
v5.PlayerContextualMenu = require("@luauforge/bundled/ehZ").installReducer()
v5[module16.RoduxKey] = module16.installReducer()

local v33 = if fFlagEnableUserAccessServiceIntegration and not fFlagUseSignalsForUserAccess then require("@luauforge/bundled/hUR") else nil
v5.UserAccess = v33

local v34 = if not (fFlagUseSignalsForRobuxVirtualItem or not module23) then require("@luauforge/bundled/hUS") else nil
v5.RobuxVirtualItem = v34

v5[module17.RoduxKey] = module17.installReducer()

local v35 = if fFlagEnablePlayWithRewardComponent then require("@luauforge/bundled/gBZ").PlayWithRewardState else nil
v5.PlayWithRewardState = v35

v5.TextSearchResults = require("@luauforge/bundled/hUT")
local v36 = combineReducers(v5)

return function(data, p2, p3)
	return v36(p2.type == module3.name and {
		ScreenSize = data.ScreenSize,
		DeviceOrientation = data.DeviceOrientation,
		FormFactor = data.FormFactor,
		GlobalGuiInset = data.GlobalGuiInset,
		TopBar = data.TopBar,
		AuthenticationStatus = data.AuthenticationStatus
	} or data, p2, p3)
end
