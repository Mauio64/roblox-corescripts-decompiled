local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectors = NavigationRodux.Selectors
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/Navigation").useEarlyIsFocused
local module2 = require("@luauforge/bundled/ecs")
local module3 = require("@luauforge/bundled/dCI")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local module5 = require("@luauforge/deferred/fel")
local module6 = require("@luauforge/deferred/fem")
local module7 = require("@luauforge/deferred/fvH")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local module8 = require("@luauforge/deferred/fvI")
local module9 = require("@luauforge/deferred/fvO")
local module10 = require("@luauforge/bundled/ehB")
local module11 = require("@luauforge/bundled/eia")
local module12 = require("@luauforge/bundled/dFu")
local module13 = require("@luauforge/deferred/fvP")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local enums = require("@game/CorePackages/Workspace/Packages/NetworkingFriends").Enums
local profileTypes = require("@luauforge/bundled/ehC").ProfileTypes

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local contexts = module2.Analytics.Enums.Contexts
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps
local navigateBack = NavigationRodux.Thunks.NavigateBack
local defaultAnalyticsService = module2.Analytics.DefaultAnalyticsService
local peekViewDismissedEvent = module3.analytics.peekViewDismissedEvent
local module14 = require("@luauforge/bundled/dPN")
local module15 = require("@luauforge/deferred/fBZ")
local module16 = require("@luauforge/deferred/fCa")
local module17 = require("@luauforge/deferred/fCb")

local module18 = require("@luauforge/deferred/fCc")
local module19 = require("@luauforge/deferred/fCU")
local module20 = require("@luauforge/deferred/fCY")

local module21 = require("@luauforge/deferred/fDa")
local module22 = require("@luauforge/bundled/dRN")
local module23 = require("@luauforge/bundled/egx")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local module24 = require("@luauforge/bundled/fAJ")
local module25 = require("@luauforge/bundled/fCM")
local module26 = require("@luauforge/bundled/fDO")

local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local fFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableStore

local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableImpressions
local module27 = require("@luauforge/deferred/fDP")
local module28 = require("@luauforge/bundled/dVZ")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane

local fFlagAddSocialLinksToCommunityProfile = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddSocialLinksToCommunityProfile

local fFlagEnablePlatformProfileContextualMenuOption = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlatformProfileContextualMenuOption
local fFlagAddIEMProfilePage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddIEMProfilePage

local module30 = require("@luauforge/deferred/fDQ")

local module31 = require("@luauforge/deferred/fDR")

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer

local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSocialEnableProfileInspectAndBuy
local fFlagEditProfileImageV2Enabled = SharedFlags.FFlagEditProfileImageV2Enabled
local fFlagEditProfileImageR15UpgradePrompt = SharedFlags.FFlagEditProfileImageR15UpgradePrompt

local defineFastFlag = game:DefineFastFlag("ProfilePlatformItemDetailsMountAnimation", false)
local module32 = require("@luauforge/bundled/fDf")
local module33 = require("@luauforge/deferred/fDS")
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local module34 = require("@luauforge/bundled/fCe")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors

local avatarEditorCategories = require("@luauforge/bundled/dPt").Enums.AvatarEditorCategories

local fFlagEnableMobileGameJoinCard = SharedFlags.FFlagEnableMobileGameJoinCard
local fFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local fFlagProfilePlatformExitStandaloneEditor = SharedFlags.FFlagProfilePlatformExitStandaloneEditor
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function selectAvatarType(p2)
	if getDeepValue(p2, "AvatarExperience.AvatarEditor.HasAvatarData") then
		return getDeepValue(p2, "AvatarExperience.AvatarEditor.Character.AvatarType")
	end

	return nil
end

local function fn(p2)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = if fFlagEnableGroupOverviewPane then useEarlyIsFocused() else nil
	local v8 = useRoactService(module32)
	local v9

	if fFlagSocialEnableProfileInspectAndBuy or fFlagEditProfileImageV2Enabled then
		v9 = useRoactService(module23)
	else
		v9 = nil
	end

	local ref

	if fFlagEditProfileImageV2Enabled then
		local v10 = useRoactService(module33)
		ref = React.useRef(v10)
		ref.current = v10
	else
		ref = nil
	end

	local ref2, v10

	if fFlagEditProfileImageR15UpgradePrompt then
		local v11 = useLocalization({
			title = "Feature.Avatar.Label.SwitchToR15",
			body = "Feature.Avatar.Label.PPEEmoteR15Warning",
			confirm = "Feature.Avatar.Action.Switch",
			cancel = "Feature.Avatar.Action.Cancel"
		})

		ref2 = React.useRef(v11)
		ref2.current = v11

		local v12 = useSelector(selectAvatarType)
		v10 = module34.resolveHumanoidRigType(v12)
	else
		ref2 = nil
		v10 = nil
	end

	local v11 = if fFlagAXEnableProfileTab then p2.embedded == true else nil

	local v12 = useNavigationProps(function(p3, data)
		local v13 = {
			profileId = p3,
			profileType = data.profileType,
			absolutePosition = data.absolutePosition,
			source = data.source,
			contextualInfoType = data.contextualInfoType,
			contextualInfoDisplay = data.contextualInfoDisplay,
			profileUserNickname = data.profileUserNickname,
			sessionIdOverride = data.sessionIdOverride,
			isRecommendation = data.isRecommendation,
			recommendationContextType = data.recommendationContextType,
			recommendationSessionId = data.recommendationSessionId,
			recommendationRank = data.recommendationRank,
			offNetworkFriendRequestToken = data.offNetworkFriendRequestToken,
			shareLinkId = data.shareLinkId,
			friendshipOriginSourceType = data.friendshipOriginSourceType,
			initialPresence = data.initialPresence,
			mountAsFullView = 0,
			forceFullView = nil,
			headerVariant = nil,
			currentlyWearingVariant = nil,
			itemDetailsFullView = nil
		}
		local v14 = if fFlagEnableMobileGameJoinCard then data.mountAsFullView else nil
		v13.mountAsFullView = v14
		return v13
	end)

	if fFlagAXEnableProfileTab and v11 then
		v12 = p2.embedNavigationProps
	end

	local v13 = enums.FriendshipOriginSourceType.UserProfile.rawValue()

	if v12.source == "playerSearch" then
		v13 = enums.FriendshipOriginSourceType.PlayerSearch.rawValue()
	elseif v12.isRecommendation then
		v13 = enums.FriendshipOriginSourceType.FriendRecommendations.rawValue()
	elseif v12.friendshipOriginSourceType then
		v13 = v12.friendshipOriginSourceType
	end

	local v14

	if fFlagSignalsNavP3hMisc then
		v14 = useSignalState(getLegacyNavigationStore(false).getCurrentPageName)
	else
		v14 = useSelector(function(p3)
			if fFlagUseNavigationSelectors then
				return selectors.selectCurrentPageName(p3)
			end

			local v15 = getDeepValue(p3, "Navigation.history") or {}
			return ((v15[#v15] or {})[#v15] or {}).name
		end)
	end

	local v15

	if fFlagEnablePlatformProfileContextualMenuOption then
		v15 = module5.Hooks.useUserProfilesFetch({
			userIds = { v12.profileId },
			query = module5.Queries.userProfilesPlatformProfileIdsByUserIds
		})
	end

	local v16

	if fFlagEnablePlatformProfileContextualMenuOption and v15.data then
		v16 = module5.Selectors.getPlatformProfileIdFromId(v15.data, v12.profileId)
	else
		v16 = nil
	end

	local profileId = tostring(v12.profileId)

	local v17 = fFlagProfilePlatformExitStandaloneEditor and v12.profileId == nil
	local profileType = v12.profileType or profileTypes.User
	local v18

	if fFlagProfilePlatformEnableImpressions then
		v18 = React.useMemo(function()
			return v12.sessionIdOverride or HttpService:GenerateGUID(false)
		end, { v12.sessionIdOverride })
	else
		v18 = nil
	end

	local v19

	if fFlagEditProfileImageV2Enabled then
		v19 = React.useCallback(function(p3)
			local v20 = {
				current = {
					name = avatarScreen.EditProfileImage,
					key = avatarScreen.EditProfileImage,
					params = { fromProfile = true }
				},
				opaque = {
					name = avatarScreen.EditProfileImage,
					key = avatarScreen.EditProfileImage,
					params = { fromProfile = true }
				},
				previousPages = {},
				isVisible = true,
				isOverlayVisible = false
			}

			return React.createElement(module21, {
				emoteAssetId = p3,
				avatarRoute = v20,
				onOpenCatalogContextMenu = function()
					v5(module17(p3, module14.ItemType.Asset))
				end
			})
		end, { v5 })
	else
		v19 = nil
	end

	local useMemo = React.useMemo
	local function fn2()
		local v21 = {
			qRCodePage = function()
				v5(module11({ source = contexts.ProfileCard }))
			end,
			previousView = function(p3)
				if fFlagAXEnableProfileTab and v11 then
					return
				end

				if p3 then
					peekViewDismissedEvent.logEvent(
						defaultAnalyticsService.EventStream,
						"ProfilePeekView",
						{
							dismissMethod = peekViewDismissedEvent.dismissMethodEnum.topBarTap,
							page = v14
						}
					)
				end

				local v22 = not p3 or nil

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.back(v22)
				else
					v5(navigateBack(v22))
				end
			end,
			itemDetails = function(p3, p4)
				if fFlagAXEnableProfileTab and v11 then
					local v25 = {
						itemId = p3,
						itemType = module14.ItemType.Asset,
						showFullWithNoPeekView = v12.itemDetailsFullView,
						mountAnimation = 0,
						fromProfile = false,
						fromSurface = 0,
						itemDetailsPeekViewRefs = 0,
						isFirstItemDetails = true
					}

					local v26 = if defineFastFlag and p4 then p4.mountAnimation else false
					v25.mountAnimation = v26

					local v27 = if fFlagAXFixPurchaseSurfaceLogging then impressionEnums.MarketplaceSurfaceType.USER_PROFILE else nil
					v25.fromSurface = v27

					v25.itemDetailsPeekViewRefs = {}
					v5(module16(v6, v25))
				else
					local asset = module14.ItemType.Asset
					local USER_PROFILE

					if fFlagAXFixPurchaseSurfaceLogging then
						USER_PROFILE = impressionEnums.MarketplaceSurfaceType.USER_PROFILE
					end

					local v26 = if p4 then p4.mountAnimation else nil
					v5(module15(
						p3,
						asset,
						nil,
						fFlagAXFixPurchaseSurfaceLogging and true or nil,
						USER_PROFILE,
						v26
					))
				end
			end,
			itemOrBundleDetails = fFlagProfilePlatformEnableStore and function(p3, p4, p5)
				if fFlagAXEnableProfileTab and v11 then
					local v25 = {
						itemId = p3,
						itemType = p4,
						showFullWithNoPeekView = v12.itemDetailsFullView,
						mountAnimation = 0,
						fromProfile = false,
						fromSurface = 0,
						itemDetailsPeekViewRefs = 0,
						isFirstItemDetails = true
					}

					local v26 = if defineFastFlag and p5 then p5.mountAnimation else false
					v25.mountAnimation = v26

					local v27 = if fFlagAXFixPurchaseSurfaceLogging then impressionEnums.MarketplaceSurfaceType.USER_PROFILE else nil
					v25.fromSurface = v27

					v25.itemDetailsPeekViewRefs = {}
					v5(module16(v6, v25))
				else
					local USER_PROFILE

					if fFlagAXFixPurchaseSurfaceLogging then
						USER_PROFILE = impressionEnums.MarketplaceSurfaceType.USER_PROFILE
					end

					local v26 = if p5 then p5.mountAnimation else nil
					v5(module15(
						p3,
						p4,
						nil,
						fFlagAXFixPurchaseSurfaceLogging and true or nil,
						USER_PROFILE,
						v26
					))
				end
			end or nil,
			preparePurchaseItem = fFlagEditProfileImageV2Enabled and function(p3, p4)
				v5(module18(v9, v8, v6, nil, p3, nil, true, false))
			end or nil,
			shopForMoreEmotes = fFlagEditProfileImageV2Enabled and function()
				local v26 = if ref then ref.current else nil
				v5(module19(v6, v8, v26))
			end or nil,
			promptR15Upgrade = fFlagEditProfileImageR15UpgradePrompt and function(p3)
				v5(module20(ref2.current, p3))
			end or nil,
			catalogSearch = fFlagProfilePlatformEnableStore and function(p3)
				v5(module28(p3))
				v5(module27(v6, {}))
			end or nil,
			inspectAvatar = fFlagAddIEMProfilePage and function() end or nil,
			editAvatar = function()
				if module30 then
					v6.navigate(avatarScreen.Catalog)
				else
					v6.navigate(avatarScreen.AvatarEditor)
				end
			end,
			editEmotes = module30 and function()
				local editorCategory = module34.resolveEditorCategory(avatarEditorCategories.Emotes)
				v6.navigate(avatarScreen.AvatarEditor, { category = editorCategory })
			end or nil,
			switchAvatar = module30 and function()
				local editorCategory = module34.resolveEditorCategory(avatarEditorCategories.Avatars)
				v6.navigate(avatarScreen.AvatarEditor, { category = editorCategory })
			end or nil,
			editBackground = module31 and function()
				local editorCategory = module34.resolveEditorCategory(avatarEditorCategories.Backgrounds)
				v6.navigate(avatarScreen.AvatarEditor, { category = editorCategory })
			end or nil,
			editUsername = function(p3)
				local v22 = {
					name = module12.EditUsername,
					extraProps = {
						BrowserWrapperComponent = module13,
						showToast = p3.showToast,
						onUsernameChanged = p3.onUsernameChanged
					}
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v22))
				else
					v5(module10(v22))
				end
			end,
			openLeaveRobloxAlertUIBlox = fFlagAddSocialLinksToCommunityProfile and function(p3)
				v5(module24(p3))
			end or nil,
			closeLeaveRobloxAlert = fFlagAddSocialLinksToCommunityProfile and function()
				v5(module25())
			end or nil,
			navigateToTransfer = fFlagProfilePlatformEnableCurrencyTransfer and function(data)
				local v22 = {
					name = module12.TransferRobuxFlow,
					extraProps = {
						direction = data.direction,
						recipientUserId = data.recipientUserId,
						transferId = data.transferId,
						transferOrigination = data.transferOrigination
					}
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v22))
				else
					v5(module10(v22))
				end
			end or nil,
			closeProfileRoute = 0
		}

		local v22 = if v17 then v6.goBack else nil
		v21.closeProfileRoute = v22
		local v20 = {
			navigateTo = v21,
			externalAnalytics = { catalogAnalytics = v8 },
			renderRecommendedEmotePurchaseFooter = if fFlagEditProfileImageV2Enabled then v19 else nil,
			accountRigType = if fFlagEditProfileImageR15UpgradePrompt then v10 else nil,
			postPurchase = fFlagSocialEnableProfileInspectAndBuy and {
				wearAfterPurchase = function(items)
					local v25 = {}

					for k, item in items do
						table.insert(v25, {
							assetTypeId = item.assetTypeId,
							assetId = item.assetId
						})
					end

					if #v25 > 0 then
						v5(module22({ assets = v25 }))
					end
				end,
				refreshRobuxBalance = function()
					local localPlayer = Players.LocalPlayer

					if localPlayer then
						local userId = tostring(localPlayer.UserId)
						v5(function(object)
							return object:dispatch(module26(
								v9,
								userId,
								object:getState().UserRobux[userId] or 0,
								function(): nil
									return nil
								end
							))
						end)
					end
				end
			} or nil,
			sourceInfo = {
				homepageCarouselAbsolutePosition = v12.absolutePosition,
				source = v12.source,
				contextualInfoType = v12.contextualInfoType,
				contextualOverride = v12.contextualInfoDisplay,
				isRecommendation = v12.isRecommendation,
				recommendationContextType = v12.recommendationContextType,
				recommendationSessionId = v12.recommendationSessionId,
				recommendationRank = v12.recommendationRank,
				friendshipOriginSourceType = v13,
				shareLinkId = v12.shareLinkId
			},
			profileSessionId = if fFlagProfilePlatformEnableImpressions then v18 else nil,
			profileId = profileId,
			profilePlatformId = v16,
			profileType = profileType,
			profileUserNickname = v12.profileUserNickname,
			sessionIdOverride = 0,
			offNetworkFriendRequestToken = 0,
			initialPresence = 0,
			mountAsFullView = 0,
			forceFullView = 0,
			headerVariant = 0,
			currentlyWearingVariant = 0
		}

		local v26 = if not fFlagProfilePlatformEnableImpressions then v12.sessionIdOverride else nil
		v20.sessionIdOverride = v26

		v20.offNetworkFriendRequestToken = v12.offNetworkFriendRequestToken
		v20.initialPresence = v12.initialPresence
		local v27 = if fFlagEnableMobileGameJoinCard then v12.mountAsFullView else nil
		v20.mountAsFullView = v27

		local v28 = if fFlagAXEnableProfileTab then v12.forceFullView else nil
		v20.forceFullView = v28

		local v29 = if fFlagAXEnableProfileTab then v12.headerVariant else nil
		v20.headerVariant = v29
		local v30 = if fFlagAXEnableProfileTab then v12.currentlyWearingVariant else nil
		v20.currentlyWearingVariant = v30
		return v20
	end

	local absolutePosition = v12.absolutePosition
	local source = v12.source
	local v22 = if fFlagEditProfileImageV2Enabled then v19 else nil
	local v23 = if fFlagEditProfileImageR15UpgradePrompt then v10 else nil
	local v24 = if fFlagAXEnableProfileTab then v11 else nil
	local forceFullView = if fFlagAXEnableProfileTab then v12.forceFullView else nil
	local headerVariant = if fFlagAXEnableProfileTab then v12.headerVariant else nil
	local currentlyWearingVariant = if fFlagAXEnableProfileTab then v12.currentlyWearingVariant else nil
	local itemDetailsFullView = if fFlagAXEnableProfileTab then v12.itemDetailsFullView else nil
	local v25

	if fFlagSocialEnableProfileInspectAndBuy or fFlagEditProfileImageV2Enabled then
		v25 = v9
	end

	local v27 = useMemo(fn2, {
		profileId,
		v5,
		v14,
		absolutePosition,
		source,
		v8,
		v22,
		v23,
		v6,
		v24,
		forceFullView,
		headerVariant,
		currentlyWearingVariant,
		itemDetailsFullView,
		v25,
		if fFlagProfilePlatformExitStandaloneEditor then v17 else nil
	})

	local createElement = React.createElement
	local provider = module7.Provider

	local v29 = {
		ProfilePlatformNavigator = React.createElement(module6, p2),
		androidBackButtonNavigationHandler = 0
	}
	local v30

	if not (fFlagAXEnableProfileTab and v11) then
		local createElement2 = React.createElement
		local v32 = {
			disabled = if fFlagEnableGroupOverviewPane then not v7 else nil,
			canGoBackInRN = not module9(v6.state),
			navigateBackInRN = 0
		}
		local v34 = if v17 then v6.goBack else v6.pop
		v32.navigateBackInRN = v34
		v30 = createElement2(module8, v32)
	end

	v29.androidBackButtonNavigationHandler = v30
	return createElement(provider, { value = v27 }, v29)
end

local extended = React.PureComponent:extend("classWrapper")
function extended.render(p2)
	return React.createElement(fn, p2.props)
end

extended.router = module6.router

return extended
