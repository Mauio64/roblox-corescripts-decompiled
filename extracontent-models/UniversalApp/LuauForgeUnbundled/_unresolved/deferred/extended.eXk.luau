local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectors = NavigationRodux.Selectors
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/Navigation").useEarlyIsFocused
local module2 = require("@luauforge/bundled/dYV")
local module3 = require("@luauforge/bundled/dzD")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local module5 = require("@luauforge/deferred/eXl")
local module6 = require("@luauforge/deferred/eXm")
local module7 = require("@luauforge/deferred/fom")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local module8 = require("@luauforge/deferred/fon")
local module9 = require("@luauforge/deferred/fou")
local module10 = require("@luauforge/bundled/eee")
local module11 = require("@luauforge/bundled/eeD")
local module12 = require("@luauforge/bundled/dCp")
local module13 = require("@luauforge/deferred/fov")
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local enums = require("@game/CorePackages/Workspace/Packages/NetworkingFriends").Enums
local profileTypes = require("@luauforge/bundled/eef").ProfileTypes

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local contexts = module2.Analytics.Enums.Contexts
local useNavigationProps = require("@luauforge/bundled/dCu").useNavigationProps
local navigateBack = NavigationRodux.Thunks.NavigateBack
local defaultAnalyticsService = module2.Analytics.DefaultAnalyticsService
local peekViewDismissedEvent = module3.analytics.peekViewDismissedEvent
local module14 = require("@luauforge/bundled/dMx")
local module15 = require("@luauforge/deferred/fuy")
local module16 = require("@luauforge/deferred/fuz")
local module17 = require("@luauforge/deferred/fuA")

local module18 = require("@luauforge/deferred/fuB")
local module19 = require("@luauforge/deferred/fvt")
local module20 = require("@luauforge/deferred/fvy")

local module21 = require("@luauforge/deferred/fvA")
local module22 = require("@luauforge/bundled/dOx")
local module23 = require("@luauforge/bundled/eda")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local module24 = require("@luauforge/bundled/ftp")
local module25 = require("@luauforge/bundled/fvl")
local module26 = require("@luauforge/bundled/fwo")

local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local fFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableStore

local fFlagProfilePlatformEnableImpressions = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableImpressions
local module27 = require("@luauforge/deferred/fwp")
local module28 = require("@luauforge/bundled/dSE")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane

local fFlagAddSocialLinksToCommunityProfile = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddSocialLinksToCommunityProfile

local fFlagEnablePlatformProfileContextualMenuOption = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlatformProfileContextualMenuOption
local fFlagAddIEMProfilePage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddIEMProfilePage

local module30 = require("@luauforge/deferred/fwq")

local module31 = require("@luauforge/deferred/fwr")

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer

local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSocialEnableProfileInspectAndBuy
local fFlagEditProfileImageV2Enabled = SharedFlags.FFlagEditProfileImageV2Enabled
local fFlagEditProfileImageR15UpgradePrompt = SharedFlags.FFlagEditProfileImageR15UpgradePrompt

local defineFastFlag = game:DefineFastFlag("ProfilePlatformItemDetailsMountAnimation", false)
local module32 = require("@luauforge/bundled/fvF")
local module33 = require("@luauforge/deferred/fws")
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local module34 = require("@luauforge/bundled/fuD")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors

local avatarEditorCategories = require("@luauforge/bundled/dMd").Enums.AvatarEditorCategories

local fFlagEnableMobileGameJoinCard = SharedFlags.FFlagEnableMobileGameJoinCard
local fFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
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
	local profileType = v12.profileType or profileTypes.User
	local v17

	if fFlagProfilePlatformEnableImpressions then
		v17 = React.useMemo(function()
			return v12.sessionIdOverride or HttpService:GenerateGUID(false)
		end, { v12.sessionIdOverride })
	else
		v17 = nil
	end

	local v18

	if fFlagEditProfileImageV2Enabled then
		v18 = React.useCallback(function(p3)
			local v19 = {
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
				avatarRoute = v19,
				onOpenCatalogContextMenu = function()
					v5(module17(p3, module14.ItemType.Asset))
				end
			})
		end, { v5 })
	else
		v18 = nil
	end

	local useMemo = React.useMemo
	local function fn2()
		local v19 = {
			navigateTo = {
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

					local v20 = not p3 or nil

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back(v20)
					else
						v5(navigateBack(v20))
					end
				end,
				itemDetails = function(p3, p4)
					if fFlagAXEnableProfileTab and v11 then
						local v23 = {
							itemId = p3,
							itemType = module14.ItemType.Asset,
							showFullWithNoPeekView = v12.itemDetailsFullView,
							mountAnimation = 0,
							fromProfile = false,
							fromSurface = 0,
							itemDetailsPeekViewRefs = 0,
							isFirstItemDetails = true
						}

						local v24 = if defineFastFlag and p4 then p4.mountAnimation else false
						v23.mountAnimation = v24

						local v25 = if fFlagAXFixPurchaseSurfaceLogging then impressionEnums.MarketplaceSurfaceType.USER_PROFILE else nil
						v23.fromSurface = v25

						v23.itemDetailsPeekViewRefs = {}
						v5(module16(v6, v23))
					else
						local asset = module14.ItemType.Asset
						local USER_PROFILE

						if fFlagAXFixPurchaseSurfaceLogging then
							USER_PROFILE = impressionEnums.MarketplaceSurfaceType.USER_PROFILE
						end

						local v24 = if p4 then p4.mountAnimation else nil
						v5(module15(
							p3,
							asset,
							nil,
							fFlagAXFixPurchaseSurfaceLogging and true or nil,
							USER_PROFILE,
							v24
						))
					end
				end,
				itemOrBundleDetails = fFlagProfilePlatformEnableStore and function(p3, p4, p5)
					if fFlagAXEnableProfileTab and v11 then
						local v23 = {
							itemId = p3,
							itemType = p4,
							showFullWithNoPeekView = v12.itemDetailsFullView,
							mountAnimation = 0,
							fromProfile = false,
							fromSurface = 0,
							itemDetailsPeekViewRefs = 0,
							isFirstItemDetails = true
						}

						local v24 = if defineFastFlag and p5 then p5.mountAnimation else false
						v23.mountAnimation = v24

						local v25 = if fFlagAXFixPurchaseSurfaceLogging then impressionEnums.MarketplaceSurfaceType.USER_PROFILE else nil
						v23.fromSurface = v25

						v23.itemDetailsPeekViewRefs = {}
						v5(module16(v6, v23))
					else
						local USER_PROFILE

						if fFlagAXFixPurchaseSurfaceLogging then
							USER_PROFILE = impressionEnums.MarketplaceSurfaceType.USER_PROFILE
						end

						local v24 = if p5 then p5.mountAnimation else nil
						v5(module15(
							p3,
							p4,
							nil,
							fFlagAXFixPurchaseSurfaceLogging and true or nil,
							USER_PROFILE,
							v24
						))
					end
				end or nil,
				preparePurchaseItem = fFlagEditProfileImageV2Enabled and function(p3, p4)
					v5(module18(v9, v8, v6, nil, p3, nil, true, false))
				end or nil,
				shopForMoreEmotes = fFlagEditProfileImageV2Enabled and function()
					local v24 = if ref then ref.current else nil
					v5(module19(v6, v8, v24))
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
					local v20 = {
						name = module12.EditUsername,
						extraProps = {
							BrowserWrapperComponent = module13,
							showToast = p3.showToast,
							onUsernameChanged = p3.onUsernameChanged
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v20))
					else
						v5(module10(v20))
					end
				end,
				openLeaveRobloxAlertUIBlox = fFlagAddSocialLinksToCommunityProfile and function(p3)
					v5(module24(p3))
				end or nil,
				closeLeaveRobloxAlert = fFlagAddSocialLinksToCommunityProfile and function()
					v5(module25())
				end or nil,
				navigateToTransfer = fFlagProfilePlatformEnableCurrencyTransfer and function(data)
					local v20 = {
						name = module12.TransferRobuxFlow,
						extraProps = {
							direction = data.direction,
							recipientUserId = data.recipientUserId,
							transferId = data.transferId,
							transferOrigination = data.transferOrigination
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v20))
					else
						v5(module10(v20))
					end
				end or nil
			},
			externalAnalytics = { catalogAnalytics = v8 },
			renderRecommendedEmotePurchaseFooter = if fFlagEditProfileImageV2Enabled then v18 else nil,
			accountRigType = if fFlagEditProfileImageR15UpgradePrompt then v10 else nil,
			postPurchase = fFlagSocialEnableProfileInspectAndBuy and {
				wearAfterPurchase = function(items)
					local v22 = {}

					for k, item in items do
						table.insert(v22, {
							assetTypeId = item.assetTypeId,
							assetId = item.assetId
						})
					end

					if #v22 > 0 then
						v5(module22({ assets = v22 }))
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
			profileSessionId = if fFlagProfilePlatformEnableImpressions then v17 else nil,
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

		local v23 = if not fFlagProfilePlatformEnableImpressions then v12.sessionIdOverride else nil
		v19.sessionIdOverride = v23

		v19.offNetworkFriendRequestToken = v12.offNetworkFriendRequestToken
		v19.initialPresence = v12.initialPresence
		local v24 = if fFlagEnableMobileGameJoinCard then v12.mountAsFullView else nil
		v19.mountAsFullView = v24

		local v25 = if fFlagAXEnableProfileTab then v12.forceFullView else nil
		v19.forceFullView = v25

		local v26 = if fFlagAXEnableProfileTab then v12.headerVariant else nil
		v19.headerVariant = v26
		local v27 = if fFlagAXEnableProfileTab then v12.currentlyWearingVariant else nil
		v19.currentlyWearingVariant = v27
		return v19
	end

	local absolutePosition = v12.absolutePosition
	local source = v12.source
	local v20 = if fFlagEditProfileImageV2Enabled then v18 else nil
	local v21 = if fFlagEditProfileImageR15UpgradePrompt then v10 else nil
	local v22 = if fFlagAXEnableProfileTab then v11 else nil
	local forceFullView = if fFlagAXEnableProfileTab then v12.forceFullView else nil
	local headerVariant = if fFlagAXEnableProfileTab then v12.headerVariant else nil
	local currentlyWearingVariant = if fFlagAXEnableProfileTab then v12.currentlyWearingVariant else nil
	local itemDetailsFullView = if fFlagAXEnableProfileTab then v12.itemDetailsFullView else nil
	local v23 = if fFlagSocialEnableProfileInspectAndBuy or fFlagEditProfileImageV2Enabled then v9 else nil
	local v24 = useMemo(fn2, {
		profileId,
		v5,
		v14,
		absolutePosition,
		source,
		v8,
		v20,
		v21,
		v6,
		v22,
		forceFullView,
		headerVariant,
		currentlyWearingVariant,
		itemDetailsFullView,
		v23
	})

	local createElement = React.createElement
	local provider = module7.Provider

	local v26 = {
		ProfilePlatformNavigator = React.createElement(module6, p2),
		androidBackButtonNavigationHandler = 0
	}
	local v27

	if not (fFlagAXEnableProfileTab and v11) then
		v27 = React.createElement(module8, {
			disabled = if fFlagEnableGroupOverviewPane then not v7 else nil,
			canGoBackInRN = not module9(v6.state),
			navigateBackInRN = v6.pop
		})
	end

	v26.androidBackButtonNavigationHandler = v27
	return createElement(provider, { value = v24 }, v26)
end

local extended = React.PureComponent:extend("classWrapper")
function extended.render(p2)
	return React.createElement(fn, p2.props)
end

extended.router = module6.router

return extended
