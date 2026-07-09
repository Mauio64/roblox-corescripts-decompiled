local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local installReducer = require(CorePackages.Workspace.Packages.AppChat.installReducer)
local Rodux = require(CorePackages.Packages.Rodux)
local EventNetworking = require(Modules.LuaApp.Components.EventReceivers.EventNetworking)
local ClearUserSpecificData = require(Modules.LuaApp.Actions.ClearUserSpecificData)
local api = require(Modules.LuaApp.Components.PYMKCarousel.api)
local api2 = require(Modules.LuaApp.Components.ContactImporter.api)
local api3 = require(Modules.LuaApp.Components.DiscoverabilityModal.api)
local api4 = require(Modules.LuaApp.Components.SetAlias.api)
local ProfileQRCode = require(CorePackages.Workspace.Packages.ProfileQRCode)
local SocialExperienceJoin = require(CorePackages.Workspace.Packages.SocialExperienceJoin)
local ProfileShareLinks = require(CorePackages.Workspace.Packages.ProfileShareLinks)
local Constants = require(CorePackages.Workspace.Packages.SquadsCore.Constants)
local installReducer2 = require(CorePackages.Workspace.Packages.SquadsCore.installReducer)
local SquadLocation = require(CorePackages.Workspace.Packages.SquadsCore.Enums).SquadLocation
local Constants2 = require(CorePackages.Workspace.Packages.EditProfile.Constants)
local ContactsToast = require(CorePackages.Workspace.Packages.ContactsToast)
local GameIconRodux = require(CorePackages.Workspace.Packages.GameIconRodux)
local GameIconReducer = GameIconRodux.GameIcons.GameIconReducer
local BigGameIconReducer = GameIconRodux.BigGameIcons.BigGameIconReducer
local GamesProductInfoReducer = require(CorePackages.Workspace.Packages.GameProductInfoRodux).GamesProductInfoReducer
local LaunchContext = require(CorePackages.Workspace.Packages.AppStartup).Reducers.LaunchContext
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local FriendRequestNicknames = require(CorePackages.Workspace.Packages.FriendRequestNicknames)
local UserSearch = require(CorePackages.Workspace.Packages.UserSearch)
local SocialBlockingModal = require(CorePackages.Workspace.Packages.SocialBlockingModal)
local SocialProof = require(CorePackages.Workspace.Packages.SocialProof)
local SocialTabsPage = require(CorePackages.Workspace.Packages.SocialTabsPage)
local UserList = require(CorePackages.Workspace.Packages.UserList)
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local GetFFlagEnableHomePageUpsellCard = Modules2.LuaApp.Flags.GetFFlagEnableHomePageUpsellCard
local GetFFlagLocalUserGameVoteCounterReducer = require(Modules.LuaApp.Flags.GetFFlagLocalUserGameVoteCounterReducer)
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagLuaAppEnableNativeRobuxProducts = require(Modules.LuaApp.Flags.GetFFlagLuaAppEnableNativeRobuxProducts)
local GetFFlagContactsToastEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagContactsToastEnabled
local FFlagUseSignalsForSearchBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseSignalsForSearchBar
local ContactsToastIXP = ContactsToast.ContactsToastIXP
local FFlagFriendRequestNicknames = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFriendRequestNicknames
local FFlagRemoveUnusedLoginResultRoduxSlice = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRemoveUnusedLoginResultRoduxSlice
local GetFFlagLuaAppEnableTopBanner = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableTopBanner
local FFlagEnableUserAccessServiceIntegration = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUserAccessServiceIntegration
local FFlagRobuxBadgeEnabled = require(Modules.LuaApp.Flags.FFlagRobuxBadgeEnabled)
local FFlagEnableSocialProofUserList = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSocialProofUserList
local FFlagEnablePlayWithRewardComponent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlayWithRewardComponent
local FFlagEnableUserListModule = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUserListModule
local FFlagEnableSocialTabsPage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSocialTabsPage
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local function globalActionReducer(p1, p2) -- line: 68
	-- upvalues: ClearUserSpecificData (copy)
	if p2.type == ClearUserSpecificData.name then
		p1 = {
			ScreenSize = p1.ScreenSize,
			DeviceOrientation = p1.DeviceOrientation,
			FormFactor = p1.FormFactor,
			GlobalGuiInset = p1.GlobalGuiInset,
			TopBar = p1.TopBar,
			AuthenticationStatus = p1.AuthenticationStatus
		}
	end

	return p1
end

local v53 = ((if not require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseSignalsRoduxStore then Rodux.combineReducers else require(CorePackages.Workspace.Packages.SignalsRodux).combineReducers))({
	DeviceOrientation = require(Modules.LuaApp.Reducers.DeviceOrientation),
	TopBar = require(Modules.LuaApp.Reducers.TopBar),
	SiteMessage = require(Modules.LuaApp.Reducers.SiteMessage),
	TabBarVisible = require(CorePackages.Workspace.Packages.AppTabBarRodux).Reducers.TabBarVisible,
	GamepadBottomBar = require(Modules.LuaApp.Reducers.GamepadBottomBar),
	FetchingStatus = require(Modules.LuaApp.Reducers.FetchingStatus),
	LaunchContext = LaunchContext,
	AppTopBanner = if not GetFFlagLuaAppEnableTopBanner() then nil else require(CorePackages.Workspace.Packages.AppTopBanner).Reducers.AppTopBannerReducer,
	Users = require(Modules.LuaApp.Reducers.Users),
	UsersAsync = require(Modules.LuaApp.Reducers.UsersAsync),
	UserStatuses = require(Modules.LuaApp.Reducers.UserStatuses),
	LocalUserId = require(CorePackages.Workspace.Packages.UserLib).Reducers.LocalUserIdReducer,
	InGameUsersByGame = require(Modules.LuaApp.Reducers.InGameUsersByGame),
	IsLocalUserSoothsayer = require(Modules.LuaApp.Reducers.IsLocalUserSoothsayer),
	SignUpInfo = require(Modules.LuaApp.Reducers.Authentication.SignUpInfo),
	CountryCodeList = AuthCommon.Reducers.CountryCodeList,
	CountryCode = require(CorePackages.Workspace.Packages.CountryCode).CountryCodeReducer,
	LoginResult = if not FFlagRemoveUnusedLoginResultRoduxSlice then require(Modules.LuaApp.Reducers.Authentication.LoginResult) else nil,
	GameSortGroups = Modules2.LuaApp.Reducers.Games.GameSortGroups,
	[GameIconReducer.key] = GameIconReducer.reducer,
	[BigGameIconReducer.key] = BigGameIconReducer.reducer,
	GameThumbnails = require(CorePackages.Workspace.Packages.GameThumbnailsRodux).GameThumbnailsReducer,
	GameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.GameDetailReducer,
	GameDetailsV2 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.GameDetailsV2Reducer,
	GameDetailErrors = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.GameDetailErrorReducer,
	GameSocialLinks = require(Modules.LuaApp.Reducers.Games.GameSocialLinks),
	GameFollowings = require(Modules.LuaApp.Reducers.GameFollowings),
	ExperienceNotificationsEnabled = require(Modules.LuaApp.Reducers.Games.ExperienceNotificationsEnabled),
	GamePasses = require(Modules.LuaApp.Reducers.Games.GamePasses),
	PassesThumbnails = require(Modules.LuaApp.Reducers.PassesThumbnails),
	GameSubscriptionProducts = require(Modules.LuaApp.Reducers.Subscription.GameSubscriptionProducts),
	SubscriptionProductsThumbnails = require(Modules.LuaApp.Reducers.Subscription.SubscriptionProductsThumbnails),
	SubscriptionStatuses = require(Modules.LuaApp.Reducers.Subscription.SubscriptionStatuses),
	GameDeveloperProducts = require(Modules.LuaApp.Reducers.DeveloperProduct.GameDeveloperProducts),
	DeveloperProductsThumbnails = require(Modules.LuaApp.Reducers.DeveloperProduct.DeveloperProductsThumbnails),
	DeveloperProductStatuses = require(Modules.LuaApp.Reducers.DeveloperProduct.DeveloperProductStatuses),
	GameBadges = require(Modules.LuaApp.Reducers.GameBadges),
	ShowAgeVerificationOverlay = require(CorePackages.Workspace.Packages.VoiceChat).AgeVerificationOverlay.ShowAgeVerificationOverlay,
	VoiceChatOptInStatus = require(CorePackages.Workspace.Packages.VoiceChat).OptInStatus.VoiceChatOptInStatus,
	UserRobux = require(Modules.LuaApp.Reducers.UserRobux),
	GameCoPlay = require(Modules.LuaApp.Reducers.GameCoPlay),
	GameVotes = require(CorePackages.Workspace.Packages.GameVotesRodux).GameVotes.GameVotes,
	UserGameVotes = require(CorePackages.Workspace.Packages.GameVotesRodux).UserGameVotes.UserGameVotes,
	LocalUserGameVoteCounter = if not GetFFlagLocalUserGameVoteCounterReducer() then nil else require(CorePackages.Workspace.Packages.Achievements).Reducers.LocalUserGameVoteCounter,
	GameFavorites = require(Modules.LuaApp.Reducers.Games.GameFavorites),
	GamePrivateServersEnabled = require(Modules.LuaApp.Reducers.Games.GamePrivateServersEnabled),
	[GamesProductInfoReducer.key] = GamesProductInfoReducer.reducer,
	OmniRecommendationsRefreshTime = Modules2.LuaApp.Reducers.Games.OmniRecommendationsRefreshTime,
	RecommendedGameEntries = require(Modules.LuaApp.Reducers.Games.RecommendedGameEntries),
	GameMedia = Modules2.LuaApp.Reducers.Games.GameMedia,
	GameDetailsPeekView = require(Modules.LuaApp.Reducers.Games.GameDetailsPeekView),
	SearchBar = if not FFlagUseSignalsForSearchBar then require(Modules.LuaApp.Reducers.SearchBar) else nil,
	OmniRecommendations = Modules2.LuaApp.Reducers.Games.OmniRecommendations,
	Personalization = require(Modules.Personalization.PersonalizationReducer),
	AgeRecommendations = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.AgeRecommendationsReducer,
	AgeRecommendationHeaders = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.AgeRecommendationHeaders,
	AssetTextFilterSettings = require(Modules.LuaApp.Reducers.AssetTextFilterSettings),
	CommunityLinks = require(CorePackages.Workspace.Packages.CommunityLinks).installReducer(),
	CatalogAssets = require(Modules.LuaApp.Reducers.CatalogAssets),
	CatalogBundles = require(Modules.LuaApp.Reducers.CatalogBundles),
	PlayabilityStatus = require(CorePackages.Workspace.Packages.PlayabilityRodux).PlayabilityStatus.PlayabilityStatusReducer,
	UniversePlaceInfos = require(CorePackages.Workspace.Packages.PlaceInfoRodux).Reducers.UniversePlaceInfos,
	AutocompleteSuggestions = require(Modules.LuaApp.Reducers.AutocompleteSuggestions),
	UsersSearchResults = require(Modules.LuaApp.Components.UserSearch.Reducers.UsersSearchResults),
	FriendStatuses = require(Modules.LuaApp.Reducers.FriendStatuses),
	CurrentToastMessages = require(Modules.LuaApp.Reducers.CurrentToastMessages),
	CentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Reducers.CentralOverlayReducer,
	RequestsStatus = Modules2.LuaApp.Reducers.RequestsStatus,
	Navigation = require(Modules.LuaApp.Reducers.Navigation),
	Search = require(Modules.LuaApp.Reducers.Search),
	SearchesParameters = require(Modules.LuaApp.Reducers.SearchesParameters),
	SearchTimes = require(Modules.LuaApp.Reducers.SearchTimes),
	SearchesTypes = require(Modules.LuaApp.Reducers.SearchesTypes),
	FriendCount = require(CorePackages.Workspace.Packages.LegacyFriendsRodux).Reducers.FriendCount,
	FriendPresenceCounts = require(CorePackages.Workspace.Packages.LegacyFriendsRodux).Reducers.FriendPresenceCounts,
	ConnectionState = require(Modules.LuaApp.Reducers.ConnectionState),
	HomePageUpsellCardVariation = GetFFlagEnableHomePageUpsellCard() and Modules2.LuaApp.Reducers.HomePageUpsellCardVariation or nil,
	GameInvitesStatus = require(CorePackages.Workspace.Packages.GameInvite).GameInvitesStatusReducer,
	GlobalGuiInset = require(Modules.LuaApp.Reducers.GlobalGuiInset),
	GlobalContextMenuInset = require(Modules.LuaApp.Reducers.GlobalContextMenuInset),
	ScreenSize = require(Modules.LuaApp.Reducers.ScreenSize),
	FormFactor = require(CorePackages.Workspace.Packages.FormFactor).FormFactorReducer,
	ScreenGuiBlur = require(Modules.LuaApp.Reducers.ScreenGuiBlur),
	Platform = require(Modules.LuaApp.Reducers.Platform),
	RoactChat = require(Modules.LuaApp.Reducers.RoactChat),
	ChatAppReducer = installReducer(),
	AvatarExperience = require(Modules.AvatarExperience.Common.Reducers.AvatarExperience),
	Luobu = require(Modules.Luobu.Reducers.Luobu),
	Startup = require(Modules.LuaApp.Reducers.Startup),
	NotificationBadgeCounts = require(Modules.LuaApp.Reducers.NotificationBadgeCounts),
	DevSubs = require(Modules.LuaApp.Reducers.DevSubs),
	IAPProducts = require(Modules.LuaApp.Reducers.IAPProducts),
	NativePurchase = require(Modules.LuaApp.Reducers.NativePurchase),
	NativeRobuxProducts = if not GetFFlagLuaAppEnableNativeRobuxProducts() then nil else require(Modules.LuaApp.Reducers.NativeRobuxProducts),
	AuthenticationStatus = require(CorePackages.Workspace.Packages.AuthenticationStatus).Reducers.AuthenticationStatusReducer,
	IsLocalUserUnder13 = require(CorePackages.Workspace.Packages.UserLib).Reducers.IsLocalUserUnder13Reducer,
	SocialTab = require(CorePackages.Workspace.Packages.SocialTabState).installReducer(),
	FriendsLanding = require(CorePackages.Workspace.Packages.FriendsLanding.installReducer)(),
	AddFriends = require(CorePackages.Workspace.Packages.AddFriendsState).installReducer(),
	ProfilePlatform = require(CorePackages.Workspace.Packages.ProfilePlatform.installReducer)(),
	[SocialExperienceJoin.RoduxKey] = SocialExperienceJoin.installReducer(),
	SocialProof = if not FFlagEnableSocialProofUserList then nil else SocialProof.installReducer(),
	[SocialTabsPage.RoduxKey] = if not FFlagEnableSocialTabsPage then nil else SocialTabsPage.installReducer(),
	UserList = if not FFlagEnableUserListModule then nil else UserList.installReducer(),
	ProfileShareLinks = ProfileShareLinks.Rodux.installReducer(),
	[api2.RoduxKey] = api2.installReducer(),
	InviteLinkExpiredModal = require(Modules.LuaApp.Components.InviteLinkExpiredModal.api).installReducer(),
	Moderation = require(Modules.LuaApp.Reducers.Moderation.UserModeration),
	AccountSecurityPrompt = require(Modules.LuaApp.Reducers.AccountSecurity.Prompt),
	FriendsCarousel = require(Modules.LuaApp.Components.FriendsCarousel.api).installReducer(),
	VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges).installReducer(),
	VirtualEvents = require(CorePackages.Workspace.Packages.VirtualEventsState).installReducer(),
	[EventNetworking.RoduxKey] = EventNetworking.installReducer(),
	[api.RoduxKey] = api.installReducer({
		contentType = DiscoveryTypes.OmniRecommendationsContentType.RecommendedFriend,
		treatmentType = OmniFeedTypes.FriendRecommendationCarousel
	}),
	[api3.RoduxKey] = api3.installReducer(),
	[api4.RoduxKey] = api4.installReducer(),
	[ProfileQRCode.RoduxKey] = ProfileQRCode.installReducer(),
	[Constants2.RODUX_KEY] = require(CorePackages.Workspace.Packages.EditProfile.installReducer)(),
	[Constants.RODUX_KEY] = if not GetFFlagIsSquadEnabled() then nil else installReducer2(SquadLocation.InApp),
	CrossPlaySettings = require(CorePackages.Workspace.Packages.CrossPlay).Reducers.CrossPlaySettings,
	PlayerContextualMenu = require(CorePackages.Workspace.Packages.PlayerContextualMenu).installReducer(),
	[ContactsToast.RoduxKey] = if not GetFFlagContactsToastEnabled() and not ContactsToastIXP.FFlagContactsToastExperimentEnabled then nil else ContactsToast.installReducer(),
	[FriendRequestNicknames.RoduxKey] = if not FFlagFriendRequestNicknames then nil else FriendRequestNicknames.installReducer(),
	[UserSearch.RoduxKey] = UserSearch.installReducer(),
	UserAccess = if not FFlagEnableUserAccessServiceIntegration then nil else require(Modules.LuaApp.Reducers.UserAccess.UserAccess),
	RobuxVirtualItem = if not FFlagRobuxBadgeEnabled then nil else require(Modules.LuaApp.Reducers.RobuxVirtualItem),
	[SocialBlockingModal.RoduxKey] = SocialBlockingModal.installReducer(),
	PlayWithRewardState = if not FFlagEnablePlayWithRewardComponent then nil else require(CorePackages.Workspace.Packages.PlayWithRewardState).PlayWithRewardState,
	TextSearchResults = require(Modules.LuaApp.Components.Search.Reducers.TextSearchResults)
})

return function(p3, p4, p5) -- line: 260
	-- upvalues: v53 (copy), ClearUserSpecificData (copy)
	local v59 = v53

	if p4.type == ClearUserSpecificData.name then
		p3 = {
			ScreenSize = p3.ScreenSize,
			DeviceOrientation = p3.DeviceOrientation,
			FormFactor = p3.FormFactor,
			GlobalGuiInset = p3.GlobalGuiInset,
			TopBar = p3.TopBar,
			AuthenticationStatus = p3.AuthenticationStatus
		}
	end

	return v59(p3, p4, p5)
end
