local CorePackages = game:GetService("CorePackages")
local module = require("@luauforge/bundled/bXy")
local Rodux = require(CorePackages.Packages.Rodux)

local module2 = require("@luauforge/bundled/cga")
local module3 = require("@luauforge/bundled/cgq")
local module4 = require("@luauforge/bundled/cgs")
local module5 = require("@luauforge/bundled/coP")
local module6 = require("@luauforge/bundled/cuU")
local module7 = require("@luauforge/bundled/cuW")
local module8 = require("@luauforge/bundled/cvS")
local module9 = require("@luauforge/bundled/cyw")
local module10 = require("@luauforge/bundled/cyx")
local module11 = require("@luauforge/bundled/cyy")
local module12 = require("@luauforge/bundled/cyz")
local squadLocation = require("@luauforge/bundled/cyI").SquadLocation
local module13 = require("@luauforge/bundled/cyJ")
local gamesProductInfoReducer = require("@luauforge/bundled/cyL").GamesProductInfoReducer
local launchContext = require("@luauforge/bundled/cyM").Reducers.LaunchContext
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local module15 = require("@luauforge/bundled/cyO")
local omniFeedTypes = module15.OmniFeedTypes
local module16 = require("@luauforge/bundled/cyP")
local module17 = require("@luauforge/bundled/cBj")
local module18 = require("@luauforge/bundled/cBW")
local module19 = require("@luauforge/bundled/cCI")
local module20 = require("@luauforge/bundled/dpY")
local modules = require("@luauforge/bundled/dpZ").Modules
local getFFlagEnableHomePageUpsellCard = modules.LuaApp.Flags.GetFFlagEnableHomePageUpsellCard
local module21 = require("@luauforge/bundled/dwe")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled
local module22 = require("@luauforge/bundled/dwf")
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
local module23 = require("@luauforge/bundled/dwg")

local fFlagEnableSocialProofUserList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialProofUserList

local fFlagEnablePlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardComponent
local fFlagEnableUserListModule = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableUserListModule
local fFlagEnableSocialTabsPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialTabsPage

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagUseSignalsRoduxStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsRoduxStore

local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForCountryCodeList

local fFlagUseSignalsForIsLocalUserSoothsayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserSoothsayer
local fFlagUseSignalsForModeration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForModeration
local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForUserAccess

local fFlagUseSignalsForGameInvitesStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForGameInvitesStatus

local fFlagUseSignalsForRobuxVirtualItem = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForRobuxVirtualItem
local combineReducers

if fFlagUseSignalsRoduxStore then
	combineReducers = require("@luauforge/bundled/dwh").combineReducers
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
v5.DeviceOrientation = require("@luauforge/bundled/dwo")
v5.TopBar = require("@luauforge/bundled/dwv")
local v6 = if not fFlagUseSignalsForSiteMessage then require("@luauforge/bundled/dwG") else nil
v5.SiteMessage = v6
v5.TabBarVisible = require("@luauforge/bundled/dwN").Reducers.TabBarVisible
v5.GamepadBottomBar = require("@luauforge/bundled/dwO")
v5.FetchingStatus = require("@game/CoreGui/RobloxGui/Modules/Feedback/Reducers")
v5.LaunchContext = launchContext

local v7 = if not (fFlagUseSignalsForAppTopBanner or not getFFlagLuaAppEnableTopBanner()) then require("@luauforge/bundled/dwT").Reducers.AppTopBannerReducer else nil
v5.AppTopBanner = v7

v5.Users = require("@luauforge/bundled/dxs")
local v8 = if not fFlagRemoveUnusedUsersAsyncRoduxSlice then require("@luauforge/bundled/dxt") else nil
v5.UsersAsync = v8

local v9 = if not fFlagRemoveUnusedUserStatusesRoduxSlice then require("@luauforge/bundled/dxx") else nil
v5.UserStatuses = v9

v5.LocalUserId = require("@luauforge/bundled/cgr").Reducers.LocalUserIdReducer
v5.InGameUsersByGame = require("@luauforge/bundled/dxB")

local v10 = if not fFlagUseSignalsForIsLocalUserSoothsayer then require("@luauforge/bundled/dxD") else nil
v5.IsLocalUserSoothsayer = v10

local v11 = if not fFlagRemoveUnusedSignUpInfoRoduxSlice then require("@luauforge/bundled/dxF") else nil
v5.SignUpInfo = v11

local v12 = if not fFlagUseSignalsForCountryCodeList then AuthCommon.Reducers.CountryCodeList else nil
v5.CountryCodeList = v12

local v13 = if not fFlagUseSignalsForCountryCode then require("@luauforge/bundled/dxT").CountryCodeReducer else nil
v5.CountryCode = v13

v5.GameSortGroups = modules.LuaApp.Reducers.Games.GameSortGroups

local v14 = if not fFlagRemoveUnusedGameThumbnailsRoduxSlice then require("@luauforge/bundled/dyc").GameThumbnailsReducer else nil
v5.GameThumbnails = v14

v5.GameDetails = require("@luauforge/bundled/dyi").GameDetails.GameDetailReducer

local v15 = if fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp then require("@luauforge/bundled/dyi").GameDetails.GameDetailsV2Reducer else nil
v5.GameDetailsV2 = v15

v5.GameDetailErrors = require("@luauforge/bundled/dyi").GameDetails.GameDetailErrorReducer
v5.GameSocialLinks = require("@luauforge/bundled/dyj")
v5.GameFollowings = require("@luauforge/bundled/dyl")
v5.ExperienceNotificationsEnabled = require("@luauforge/bundled/dyo")
v5.GamePasses = require("@luauforge/bundled/dyr")
v5.PassesThumbnails = require("@luauforge/bundled/dyt")
v5.GameSubscriptionProducts = require("@luauforge/bundled/dyv")
v5.SubscriptionProductsThumbnails = require("@luauforge/bundled/dyx")
v5.SubscriptionStatuses = require("@luauforge/bundled/dyz")
v5.GameDeveloperProducts = require("@luauforge/bundled/dyC")
v5.DeveloperProductsThumbnails = require("@luauforge/bundled/dyE")
v5.DeveloperProductStatuses = require("@luauforge/bundled/dyG")
v5.GameBadges = require("@luauforge/bundled/dyI")
v5.ShowAgeVerificationOverlay = require("@luauforge/bundled/dyK").AgeVerificationOverlay.ShowAgeVerificationOverlay
v5.VoiceChatOptInStatus = require("@luauforge/bundled/dyK").OptInStatus.VoiceChatOptInStatus
v5.UserRobux = require("@luauforge/bundled/dyL")
v5.GameCoPlay = require("@luauforge/bundled/dyN")
v5.GameVotes = require("@luauforge/bundled/dyO").GameVotes.GameVotes
v5.UserGameVotes = require("@luauforge/bundled/dyO").UserGameVotes.UserGameVotes
local v16 = if module21() then require("@luauforge/bundled/dyP").Reducers.LocalUserGameVoteCounter else nil
v5.LocalUserGameVoteCounter = v16

v5.GameFavorites = require("@luauforge/bundled/dzw")
v5.GamePrivateServersEnabled = require("@luauforge/bundled/dzy")
v5[gamesProductInfoReducer.key] = gamesProductInfoReducer.reducer
v5.OmniRecommendationsRefreshTime = modules.LuaApp.Reducers.Games.OmniRecommendationsRefreshTime
v5.RecommendedGameEntries = require("@luauforge/bundled/dzA")
v5.GameMedia = modules.LuaApp.Reducers.Games.GameMedia
v5.GameDetailsPeekView = require("@luauforge/bundled/dzC")
local v17 = if not fFlagUseSignalsForSearchBar then require("@luauforge/bundled/dzG") else nil
v5.SearchBar = v17
v5.OmniRecommendations = modules.LuaApp.Reducers.Games.OmniRecommendations
v5.Personalization = require("@luauforge/bundled/dzI")
v5.AgeRecommendations = require("@luauforge/bundled/dyi").AgeRecommendations.AgeRecommendationsReducer
v5.AgeRecommendationHeaders = require("@luauforge/bundled/dyi").AgeRecommendations.AgeRecommendationHeaders
v5.AssetTextFilterSettings = require("@luauforge/bundled/dBc")
v5.CommunityLinks = require("@luauforge/bundled/dBe").installReducer()

v5.CatalogAssets = require("@luauforge/bundled/dBS")
v5.CatalogBundles = require("@luauforge/bundled/dBT")

v5.PlayabilityStatus = require("@luauforge/bundled/dBU").PlayabilityStatus.PlayabilityStatusReducer
v5.UniversePlaceInfos = require("@luauforge/bundled/dBV").Reducers.UniversePlaceInfos
v5.AutocompleteSuggestions = require("@luauforge/bundled/dBW")
v5.UsersSearchResults = require("@luauforge/bundled/dCa")

local v18 = if not fFlagRemoveUnusedFriendStatusesRoduxSlice then require("@game/CorePackages/Packages/_Index/RoduxFriends/RoduxFriends/Reducers/Friends/friendshipStatus") else nil
v5.FriendStatuses = v18

v5.CurrentToastMessages = require("@luauforge/bundled/dCg")
v5.CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Reducers.CentralOverlayReducer

v5.RequestsStatus = modules.LuaApp.Reducers.RequestsStatus

v5.Navigation = require("@luauforge/bundled/dCl")

v5.Search = require("@luauforge/bundled/hJi")
v5.SearchesParameters = require("@luauforge/bundled/hJm")
v5.SearchTimes = require("@luauforge/bundled/hJn")
v5.SearchesTypes = require("@luauforge/bundled/hJo")

local v19 = if not fFlagRemoveUnusedFriendCountRoduxSlice then require("@luauforge/bundled/hJp").Reducers.FriendCount else nil
v5.FriendCount = v19

v5.FriendPresenceCounts = require("@luauforge/bundled/hJp").Reducers.FriendPresenceCounts

local v20 = if not fFlagRemoveUnusedConnectionStateRoduxSlice then require("@luauforge/bundled/hJq") else nil
v5.ConnectionState = v20

v5.HomePageUpsellCardVariation = getFFlagEnableHomePageUpsellCard()
	and modules.LuaApp.Reducers.HomePageUpsellCardVariation
	or nil

local v21 = if not fFlagUseSignalsForGameInvitesStatus then require("@luauforge/bundled/hJs").GameInvitesStatusReducer else nil
v5.GameInvitesStatus = v21

v5.GlobalGuiInset = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/Core/Layout/LayerCollector/LayerCollectorContext")

local v22 = if not fFlagUseSignalsForGlobalContextMenuInset then require("@luauforge/bundled/hJv") else nil
v5.GlobalContextMenuInset = v22

v5.ScreenSize = require("@luauforge/bundled/hJx")
v5.FormFactor = require("@luauforge/bundled/dDI").FormFactorReducer
local v23 = if not fFlagUseSignalsForScreenGuiBlur then require("@luauforge/bundled/hJz") else nil
v5.ScreenGuiBlur = v23
local v24 = if not fFlagUseSignalsForPlatform then require("@luauforge/bundled/hJB") else nil
v5.Platform = v24

v5.ChatAppReducer = module()
v5.AvatarExperience = require("@luauforge/bundled/dHM")
v5.Luobu = require("@luauforge/bundled/hJD")

local v25 = if not fFlagUseSignalsForStartup then require("@luauforge/bundled/hJM") else nil
v5.Startup = v25
v5.NotificationBadgeCounts = require("@luauforge/bundled/hJO")

v5.DevSubs = require("@luauforge/bundled/hJQ")

v5.IAPProducts = require("@luauforge/bundled/hJS")
v5.NativePurchase = require("@luauforge/bundled/hJT")
local v26 = if module22() then require("@luauforge/bundled/hJU") else nil
v5.NativeRobuxProducts = v26

v5.AuthenticationStatus = require("@luauforge/bundled/fBO").Reducers.AuthenticationStatusReducer

local v27 = if not fFlagUseSignalsForIsLocalUserUnder13 then require("@luauforge/bundled/cgr").Reducers.IsLocalUserUnder13Reducer else nil
v5.IsLocalUserUnder13 = v27

v5.SocialTab = require("@luauforge/bundled/hvh").installReducer()
v5.FriendsLanding = require("@luauforge/bundled/hJV")()
v5.AddFriends = require("@luauforge/bundled/hKa").installReducer()
v5.ProfilePlatform = require("@luauforge/bundled/hKb")()
v5[module9.RoduxKey] = module9.installReducer()
local v28 = if fFlagEnableSocialProofUserList then module18.installReducer() else nil
v5.SocialProof = v28
local roduxKey = module19.RoduxKey
local v29 = if fFlagEnableSocialTabsPage then module19.installReducer() else nil
v5[roduxKey] = v29
local v30 = if fFlagEnableUserListModule then module20.installReducer() else nil
v5.UserList = v30
v5.ProfileShareLinks = module10.Rodux.installReducer()
v5[module5.RoduxKey] = module5.installReducer()
v5.InviteLinkExpiredModal = require("@luauforge/bundled/gaU").installReducer()

local v31 = if not fFlagUseSignalsForModeration then require("@luauforge/bundled/hKc") else nil
v5.Moderation = v31

local v32 = if not fFlagUseSignalsForAccountSecurityPrompt then require("@luauforge/bundled/hKd") else nil
v5.AccountSecurityPrompt = v32

v5.FriendsCarousel = require("@luauforge/bundled/hKf").installReducer()
v5.VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges").installReducer()
v5.VirtualEvents = require("@luauforge/bundled/hKh").installReducer()
v5[module2.RoduxKey] = module2.installReducer()
v5[module4.RoduxKey] = module4.installReducer({
	contentType = module15.OmniRecommendationsContentType.RecommendedFriend,
	treatmentType = omniFeedTypes.FriendRecommendationCarousel
})

v5[module6.RoduxKey] = module6.installReducer()
v5[module7.RoduxKey] = module7.installReducer()
v5[module8.RoduxKey] = module8.installReducer()
v5[module13.RODUX_KEY] = require("@luauforge/bundled/hKi")()
local RODUX_KEY = module11.RODUX_KEY
local v33 = if getFFlagIsSquadEnabled() then module12(squadLocation.InApp) else nil
v5[RODUX_KEY] = v33

v5.CrossPlaySettings = require("@luauforge/bundled/hHU").Reducers.CrossPlaySettings
v5.PlayerContextualMenu = require("@luauforge/bundled/eeC").installReducer()
v5[module16.RoduxKey] = module16.installReducer()

local v34 = if fFlagEnableUserAccessServiceIntegration and not fFlagUseSignalsForUserAccess then require("@luauforge/bundled/hKj") else nil
v5.UserAccess = v34

local v35 = if not (fFlagUseSignalsForRobuxVirtualItem or not module23) then require("@luauforge/bundled/hKk") else nil
v5.RobuxVirtualItem = v35

v5[module17.RoduxKey] = module17.installReducer()

local v36 = if fFlagEnablePlayWithRewardComponent then require("@luauforge/bundled/fXd").PlayWithRewardState else nil
v5.PlayWithRewardState = v36

v5.TextSearchResults = require("@luauforge/bundled/hKl")
local v37 = combineReducers(v5)

return function(data, p2, p3)
	return v37(p2.type == module3.name and {
		ScreenSize = data.ScreenSize,
		DeviceOrientation = data.DeviceOrientation,
		FormFactor = data.FormFactor,
		GlobalGuiInset = data.GlobalGuiInset,
		TopBar = data.TopBar,
		AuthenticationStatus = data.AuthenticationStatus
	} or data, p2, p3)
end
