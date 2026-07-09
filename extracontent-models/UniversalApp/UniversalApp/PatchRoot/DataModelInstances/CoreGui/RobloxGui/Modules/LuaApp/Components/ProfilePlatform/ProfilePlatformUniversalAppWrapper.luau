local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local React = require(CorePackages.Packages.React)
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local PeekView = require(CorePackages.Workspace.Packages.PeekView)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local ProfilePlatformNavigator = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfilePlatformNavigator)
local ProfileWrapperContext = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfileWrapperContext)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Container = require(Modules.LuaApp.Navigation.AndroidBackButtonNavigationHandler.Container)
local isRootRouteInRN = require(Modules.LuaApp.Navigation.isRootRouteInRN)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateDownTo3DQRCodePage = require(Modules.LuaApp.Thunks.NavigateDownTo3DQRCodePage)
local AppPage = require(Modules.LuaApp.AppPage)
local BrowserServiceWrapper = require(Modules.LuaApp.Components.BrowserServiceWrapper)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local HttpService = game:GetService("HttpService")
local Enums = require(CorePackages.Workspace.Packages.FriendsNetworking).Enums
local ProfileTypes = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums).ProfileTypes
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local peekViewDismissedEvent = PeekView.analytics.peekViewDismissedEvent
local Constants = require(Modules.AvatarExperience.Common.Constants)
local OpenAppItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenAppItemDetails)
local NavigateIntoItemDetailsPage = require(Modules.AvatarExperience.Common.Thunks.NavigateIntoItemDetailsPage)
local UpdateAvatarEquips = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateAvatarEquips)
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local FFlagProfilePlatformEnableStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagProfilePlatformEnableStore
local FFlagProfilePlatformEnableImpressions = require(CorePackages.Workspace.Packages.SharedFlags).FFlagProfilePlatformEnableImpressions
local NavigateToSearch = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToSearch)
local SetCreatorFilter = require(Modules.AvatarExperience.Catalog.Actions.SetCreatorFilter)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAddSocialLinksToCommunityProfile = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddSocialLinksToCommunityProfile
local FFlagEnablePlatformProfileContextualMenuOption = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlatformProfileContextualMenuOption
local FFlagAddIEMProfilePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddIEMProfilePage
local FFlagProfilePlatformEnableEditAppearanceMenu = require(CorePackages.Workspace.Packages.ProfilePlatform.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(CorePackages.Workspace.Packages.ProfilePlatform.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableCurrencyTransfer = require(CorePackages.Workspace.Packages.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagSocialEnableProfileInspectAndBuy = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSocialEnableProfileInspectAndBuy
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local AvatarEditorCategories = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.AvatarEditorCategories
local FFlagEnableMobileGameJoinCard = SharedFlags.FFlagEnableMobileGameJoinCard
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v60 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

local function v61(p1) -- line: 80
	-- upvalues: useDispatch (copy), useNavigation (copy), useRoactService (copy), Analytics (copy), FFlagAXEnableProfileTab (copy), useNavigationProps (copy), FFlagEnableMobileGameJoinCard (copy), Enums (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), getDeepValue (copy), FFlagEnablePlatformProfileContextualMenuOption (copy), UserProfiles (copy), ProfileTypes (copy), FFlagProfilePlatformEnableImpressions (copy), React (copy), HttpService (copy), NavigateDownTo3DQRCodePage (copy), Contexts (copy), peekViewDismissedEvent (copy), DefaultAnalyticsService (copy), FFlagSignalsNavP3Dispatch (copy), v60 (copy), NavigateBack (copy), NavigateIntoItemDetailsPage (copy), Constants (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ImpressionEnums (copy), OpenAppItemDetails (copy), FFlagProfilePlatformEnableStore (copy), SetCreatorFilter (copy), NavigateToSearch (copy), FFlagAddIEMProfilePage (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), AvatarScreen (copy), Utils (copy), AvatarEditorCategories (copy), FFlagProfilePlatformEditBackgroundMenuItem (copy), AppPage (copy), BrowserServiceWrapper (copy), NavigateDown (copy), FFlagAddSocialLinksToCommunityProfile (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), CloseCentralOverlay (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), FFlagSocialEnableProfileInspectAndBuy (copy), UpdateAvatarEquips (copy), ProfileWrapperContext (copy), ProfilePlatformNavigator (copy), Container (copy), isRootRouteInRN (copy)
	local v64 = useDispatch()
	local v65 = useNavigation()
	local v66 = useRoactService(Analytics)
	local v67 = if not FFlagAXEnableProfileTab then nil else p1.embedded == true
	local v68 = useNavigationProps(function(p2, p3) -- line: 90
		-- upvalues: FFlagEnableMobileGameJoinCard (copy)
		return {
			forceFullView = nil,
			headerVariant = nil,
			currentlyWearingVariant = nil,
			itemDetailsFullView = nil,
			profileId = p2,
			profileType = p3.profileType,
			absolutePosition = p3.absolutePosition,
			source = p3.source,
			contextualInfoType = p3.contextualInfoType,
			contextualInfoDisplay = p3.contextualInfoDisplay,
			profileUserNickname = p3.profileUserNickname,
			sessionIdOverride = p3.sessionIdOverride,
			isRecommendation = p3.isRecommendation,
			recommendationContextType = p3.recommendationContextType,
			recommendationSessionId = p3.recommendationSessionId,
			recommendationRank = p3.recommendationRank,
			offNetworkFriendRequestToken = p3.offNetworkFriendRequestToken,
			shareLinkId = p3.shareLinkId,
			friendshipOriginSourceType = p3.friendshipOriginSourceType,
			initialPresence = p3.initialPresence,
			mountAsFullView = if not FFlagEnableMobileGameJoinCard then nil else p3.mountAsFullView
		}
	end)
	local v69 = if not FFlagAXEnableProfileTab or not v67 then v68 else p1.embedNavigationProps
	local u70 = Enums.FriendshipOriginSourceType.UserProfile.rawValue()

	if v69.source == "playerSearch" then
		u70 = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()
	elseif v69.isRecommendation then
		u70 = Enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
	elseif v69.friendshipOriginSourceType then
		u70 = v69.friendshipOriginSourceType
	end

	local v71 = useSelector(function(p4) -- line: 131
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), getDeepValue (copy)
		if FFlagUseNavigationSelectors then
			return Selectors.selectCurrentPageName(p4)
		end

		local v82 = getDeepValue(p4, "Navigation.history") or {}

		return ((v82[#v82] or {})[#v82] or {}).name
	end)
	local v72 = if not FFlagEnablePlatformProfileContextualMenuOption then nil else UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v69.profileId },
		query = UserProfiles.Queries.userProfilesPlatformProfileIdsByUserIds
	})
	local v73 = if not FFlagEnablePlatformProfileContextualMenuOption or not v72.data then nil else UserProfiles.Selectors.getPlatformProfileIdFromId(v72.data, v69.profileId)
	local str = tostring(v69.profileId)
	local v75 = v69.profileType or ProfileTypes.User
	local v76 = if not FFlagProfilePlatformEnableImpressions then nil else React.useMemo(function() -- line: 156
		-- upvalues: v69 (copy), HttpService (copy)
		return v69.sessionIdOverride or HttpService:GenerateGUID(false)
	end, { v69.sessionIdOverride })
	local v77 = React.useMemo(function() -- line: 163
		-- upvalues: v64 (copy), NavigateDownTo3DQRCodePage (copy), Contexts (copy), FFlagAXEnableProfileTab (copy), v67 (copy), peekViewDismissedEvent (copy), DefaultAnalyticsService (copy), v71 (copy), FFlagSignalsNavP3Dispatch (copy), v60 (copy), NavigateBack (copy), NavigateIntoItemDetailsPage (copy), v65 (copy), Constants (copy), v69 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ImpressionEnums (copy), OpenAppItemDetails (copy), FFlagProfilePlatformEnableStore (copy), SetCreatorFilter (copy), NavigateToSearch (copy), FFlagAddIEMProfilePage (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), AvatarScreen (copy), Utils (copy), AvatarEditorCategories (copy), FFlagProfilePlatformEditBackgroundMenuItem (copy), AppPage (copy), BrowserServiceWrapper (copy), NavigateDown (copy), FFlagAddSocialLinksToCommunityProfile (copy), OpenCentralOverlayForLeaveRobloxAlert (copy), CloseCentralOverlay (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), v66 (copy), FFlagSocialEnableProfileInspectAndBuy (copy), UpdateAvatarEquips (copy), u70 (ref), FFlagProfilePlatformEnableImpressions (copy), v76 (copy), str (copy), v73 (copy), v75 (copy), FFlagEnableMobileGameJoinCard (copy)
		return {
			navigateTo = {
				qRCodePage = function() -- line: 166
					-- upvalues: v64 (copy), NavigateDownTo3DQRCodePage (copy), Contexts (copy)
					v64(NavigateDownTo3DQRCodePage({
						source = Contexts.ProfileCard
					}))
				end,
				previousView = function(b1: boolean?) -- line: 171
					-- upvalues: FFlagAXEnableProfileTab (copy), v67 (copy), peekViewDismissedEvent (copy), DefaultAnalyticsService (copy), v71 (copy), FFlagSignalsNavP3Dispatch (copy), v60 (copy), v64 (copy), NavigateBack (copy)
					if FFlagAXEnableProfileTab and v67 then
						return
					end

					if b1 then
						peekViewDismissedEvent.logEvent(DefaultAnalyticsService.EventStream, "ProfilePeekView", {
							dismissMethod = peekViewDismissedEvent.dismissMethodEnum.topBarTap,
							page = v71
						})
					end

					local v84 = not b1 or nil

					if FFlagSignalsNavP3Dispatch then
						v60.back(v84)

						return
					end

					v64(NavigateBack(v84))
				end,
				itemDetails = function(s1: string) -- line: 193
					-- upvalues: FFlagAXEnableProfileTab (copy), v67 (copy), v64 (copy), NavigateIntoItemDetailsPage (copy), v65 (copy), Constants (copy), v69 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ImpressionEnums (copy), OpenAppItemDetails (copy)
					if FFlagAXEnableProfileTab and v67 then
						v64(NavigateIntoItemDetailsPage(v65, {
							mountAnimation = false,
							fromProfile = false,
							isFirstItemDetails = true,
							itemId = s1,
							itemType = Constants.ItemType.Asset,
							showFullWithNoPeekView = v69.itemDetailsFullView,
							fromSurface = if not FFlagAXFixPurchaseSurfaceLogging then nil else ImpressionEnums.MarketplaceSurfaceType.USER_PROFILE,
							itemDetailsPeekViewRefs = {}
						}))

						return
					end

					v64(OpenAppItemDetails(s1, Constants.ItemType.Asset, nil, not not FFlagAXFixPurchaseSurfaceLogging or nil, if not FFlagAXFixPurchaseSurfaceLogging then nil else ImpressionEnums.MarketplaceSurfaceType.USER_PROFILE))
				end,
				itemOrBundleDetails = if not FFlagProfilePlatformEnableStore then nil else function(s2: string, s3: string) -- line: 231
					-- upvalues: FFlagAXEnableProfileTab (copy), v67 (copy), v64 (copy), NavigateIntoItemDetailsPage (copy), v65 (copy), v69 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ImpressionEnums (copy), OpenAppItemDetails (copy)
					if FFlagAXEnableProfileTab and v67 then
						v64(NavigateIntoItemDetailsPage(v65, {
							mountAnimation = false,
							fromProfile = false,
							isFirstItemDetails = true,
							itemId = s2,
							itemType = s3,
							showFullWithNoPeekView = v69.itemDetailsFullView,
							fromSurface = if not FFlagAXFixPurchaseSurfaceLogging then nil else ImpressionEnums.MarketplaceSurfaceType.USER_PROFILE,
							itemDetailsPeekViewRefs = {}
						}))

						return
					end

					v64(OpenAppItemDetails(s2, s3, nil, not not FFlagAXFixPurchaseSurfaceLogging or nil, if not FFlagAXFixPurchaseSurfaceLogging then nil else ImpressionEnums.MarketplaceSurfaceType.USER_PROFILE))
				end,
				catalogSearch = if not FFlagProfilePlatformEnableStore then nil else function(s4: string) -- line: 263
					-- upvalues: v64 (copy), SetCreatorFilter (copy), NavigateToSearch (copy), v65 (copy)
					v64(SetCreatorFilter(s4))
					v64(NavigateToSearch(v65, {}))
				end,
				inspectAvatar = if not FFlagAddIEMProfilePage then nil else function() -- line: 268
				end,
				editAvatar = function() -- line: 269
					-- upvalues: FFlagProfilePlatformEnableEditAppearanceMenu (copy), v65 (copy), AvatarScreen (copy)
					if FFlagProfilePlatformEnableEditAppearanceMenu then
						v65.navigate(AvatarScreen.Catalog)

						return
					end

					v65.navigate(AvatarScreen.AvatarEditor)
				end,
				editEmotes = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else function() -- line: 277
					-- upvalues: Utils (copy), AvatarEditorCategories (copy), v65 (copy), AvatarScreen (copy)
					local v89 = Utils.resolveEditorCategory(AvatarEditorCategories.Emotes)

					v65.navigate(AvatarScreen.AvatarEditor, {
						category = v89
					})
				end,
				switchAvatar = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else function() -- line: 283
					-- upvalues: Utils (copy), AvatarEditorCategories (copy), v65 (copy), AvatarScreen (copy)
					local v90 = Utils.resolveEditorCategory(AvatarEditorCategories.Avatars)

					v65.navigate(AvatarScreen.AvatarEditor, {
						category = v90
					})
				end,
				editBackground = if not FFlagProfilePlatformEditBackgroundMenuItem then nil else function() -- line: 290
					-- upvalues: Utils (copy), AvatarEditorCategories (copy), v65 (copy), AvatarScreen (copy)
					local v91 = Utils.resolveEditorCategory(AvatarEditorCategories.Backgrounds)

					v65.navigate(AvatarScreen.AvatarEditor, {
						category = v91
					})
				end,
				editUsername = function(t1: {[any]: any}) -- line: 296
					-- upvalues: AppPage (copy), BrowserServiceWrapper (copy), FFlagSignalsNavP3Dispatch (copy), v60 (copy), v64 (copy), NavigateDown (copy)
					local t2 = {
						name = AppPage.EditUsername,
						extraProps = {
							BrowserWrapperComponent = BrowserServiceWrapper,
							showToast = t1.showToast,
							onUsernameChanged = t1.onUsernameChanged
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v60.down(v60.fromLegacyPage(t2))

						return
					end

					v64(NavigateDown(t2))
				end,
				openLeaveRobloxAlertUIBlox = if not FFlagAddSocialLinksToCommunityProfile then nil else function(p5) -- line: 315
					-- upvalues: v64 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
					v64(OpenCentralOverlayForLeaveRobloxAlert(p5))
				end,
				closeLeaveRobloxAlert = if not FFlagAddSocialLinksToCommunityProfile then nil else function() -- line: 320
					-- upvalues: v64 (copy), CloseCentralOverlay (copy)
					v64(CloseCentralOverlay())
				end,
				navigateToTransfer = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else function(p6) -- line: 325
					-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v60 (copy), v64 (copy), NavigateDown (copy)
					local t3 = {
						name = AppPage.TransferRobuxFlow,
						extraProps = {
							direction = p6.direction,
							recipientUserId = p6.recipientUserId,
							transferId = p6.transferId,
							transferOrigination = p6.transferOrigination
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v60.down(v60.fromLegacyPage(t3))

						return
					end

					v64(NavigateDown(t3))
				end
			},
			externalAnalytics = {
				catalogAnalytics = v66
			},
			postPurchase = if not FFlagSocialEnableProfileInspectAndBuy then nil else {
				wearAfterPurchase = function(p7) -- line: 355
					-- upvalues: v64 (copy), UpdateAvatarEquips (copy)
					local t4 = {}

					for _, v100 in p7 do
						table.insert(t4, {
							assetTypeId = v100.assetTypeId,
							assetId = v100.assetId
						})
					end

					if #t4 > 0 then
						v64(UpdateAvatarEquips({
							assets = t4
						}))
					end
				end
			},
			sourceInfo = {
				homepageCarouselAbsolutePosition = v69.absolutePosition,
				source = v69.source,
				contextualInfoType = v69.contextualInfoType,
				contextualOverride = v69.contextualInfoDisplay,
				isRecommendation = v69.isRecommendation,
				recommendationContextType = v69.recommendationContextType,
				recommendationSessionId = v69.recommendationSessionId,
				recommendationRank = v69.recommendationRank,
				friendshipOriginSourceType = u70,
				shareLinkId = v69.shareLinkId
			},
			profileSessionId = if not FFlagProfilePlatformEnableImpressions then nil else v76,
			profileId = str,
			profilePlatformId = v73,
			profileType = v75,
			profileUserNickname = v69.profileUserNickname,
			sessionIdOverride = if not FFlagProfilePlatformEnableImpressions then v69.sessionIdOverride else nil,
			offNetworkFriendRequestToken = v69.offNetworkFriendRequestToken,
			initialPresence = v69.initialPresence,
			mountAsFullView = if not FFlagEnableMobileGameJoinCard then nil else v69.mountAsFullView,
			forceFullView = if not FFlagAXEnableProfileTab then nil else v69.forceFullView,
			headerVariant = if not FFlagAXEnableProfileTab then nil else v69.headerVariant,
			currentlyWearingVariant = if not FFlagAXEnableProfileTab then nil else v69.currentlyWearingVariant
		}
	end, {
		str,
		v64,
		v71,
		v69.absolutePosition,
		v69.source,
		v66,
		v65,
		if not FFlagAXEnableProfileTab then nil else v67,
		if not FFlagAXEnableProfileTab then nil else v69.forceFullView,
		if not FFlagAXEnableProfileTab then nil else v69.headerVariant,
		if not FFlagAXEnableProfileTab then nil else v69.currentlyWearingVariant,
		if not FFlagAXEnableProfileTab then nil else v69.itemDetailsFullView
	})

	return React.createElement(ProfileWrapperContext.Provider, {
		value = v77
	}, {
		ProfilePlatformNavigator = React.createElement(ProfilePlatformNavigator, p1),
		androidBackButtonNavigationHandler = if not FFlagAXEnableProfileTab or not v67 then React.createElement(Container, {
			canGoBackInRN = not isRootRouteInRN(v65.state),
			navigateBackInRN = v65.pop
		}) else nil
	})
end

local v62 = React.PureComponent:extend("classWrapper")

function v62.render(p8) -- line: 436
	-- upvalues: React (copy), v61 (copy)
	return React.createElement(v61, p8.props)
end

v62.router = ProfilePlatformNavigator.router

return v62
