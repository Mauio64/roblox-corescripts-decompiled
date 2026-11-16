local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppBlox")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization")
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/LoggingProtocol")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/RobloxAppToastsRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
local UserSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserSignals")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryAnalytics")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/NavigationRodux").Selectors

local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local overflowMenu = AppBlox.OverflowMenu
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useTokens = Foundation.Hooks.useTokens
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/OpenDynamicAbuseReport")
local useLocalization = Localization.Hooks.useLocalization
local mutedError = Loggers.mutedError
local flaggedMutedError = Loggers.flaggedMutedError
local default = LoggingProtocol.default
local useLastInput = Responsive.useLastInput
local roactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService
local setNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local postSendUserSignal = UserSignals.PostSendUserSignal
local userSignalTypes = UserSignals.UserSignalTypes
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local NotInterestedUserSignalTelemetryEventConfigs = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/NotInterestedUserSignalTelemetryEventConfigs")
local activateGameNotInterested = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/activateGameNotInterested")
local sendNotInterestedFeedbackFormAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/sendNotInterestedFeedbackFormAnalytics")
local useGameTileActions = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/useGameTileActions")
local useGameTileOverflowMenuFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/useGameTileOverflowMenuFocusNavigation")
local tileOverflowMenuItems = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants").TileOverflowMenuItems

local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SignalsReact").useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local fFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local fFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local fFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local fFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry
local fFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local fFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction
local fFlagLuaAppExtractNotInterestedHelper = SharedFlags.FFlagLuaAppExtractNotInterestedHelper

local function GameTileOverflowMenu(props)
	if fFlagLuaAppGameTileNotInterestedDirectAction then
		local v5 = useTokens()
		local v6 = useLastInput()
		local menuKey = props.menuKey
		local vector2 = Vector2.new(1, 0)
		local udim = UDim2.new(1, -v5.Padding.Medium, 0, v5.Padding.Medium)
		local overflowMenuSignalStore = getOverflowMenuSignalStore()
		local collectionId = props.collectionId or ""
		local v7 = {}

		for k, availableMenuItem in props.availableMenuItems do
			table.insert(v7, k)
		end

		local joined = table.concat(v7, ",")

		local v8 = React.useCallback(function(p2)
			if props.onMenuOpenChanged then
				props.onMenuOpenChanged(p2, joined)
			end
		end, { props.onMenuOpenChanged, joined })

		local useCallback = React.useCallback
		local function fn(p2)
			local v9 = {
				universeId = props.universeId,
				sortId = collectionId,
				actionType = "GameTileOverflowMenuItemActivated",
				menuItem = p2,
				availableMenuItems = joined,
				contentType = 0
			}

			local v10 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
			v9.contentType = v10

			gameTileOverflowMenuAction(v9, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId

		local v10 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
		local v11 = useCallback(fn, { appPage, universeId, collectionId, joined, v10 })
		local v12

		if not fFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v12 = useGameTileOverflowMenuFocusNavigation(menuKey, props.isSelected, props.parentRef)
		end

		local v13 = useGameTileActions(props, v11)

		if fFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v12 = useGameTileOverflowMenuFocusNavigation(menuKey, props.isSelected, props.parentRef, v8)
		end

		local v14

		if fFlagSignalsNavP3fGameDetails then
			v14 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
		else
			v14 = useSelector(function(p2)
				if fFlagUseNavigationSelectors then
					return selectors.selectCurrentRoactNavigationRoute(p2).key or ""
				end

				return p2.Navigation.currentRoute.key or ""
			end)
		end

		local ref = React.useRef(v14)

		React.useEffect(function()
			if v14 ~= ref.current then
				overflowMenuSignalStore.closeMenu(menuKey)
			end
		end, { v14, menuKey, overflowMenuSignalStore.closeMenu })

		React.useEffect(function()
			local inputBeganConnection

			if props.menuOpen then
				inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and not props.isHovered then
						overflowMenuSignalStore.closeMenu(menuKey)
					end
				end)
			else
				inputBeganConnection = nil
			end

			return function()
				if inputBeganConnection then
					inputBeganConnection:Disconnect()
				end
			end
		end, {
			props.menuOpen,
			props.isHovered,
			menuKey,
			overflowMenuSignalStore.closeMenu
		})

		return React.createElement(overflowMenu, {
			anchorPoint = vector2,
			anchorPosition = udim,
			menuItems = v13,
			hasOverflowButton = v6 == Responsive.Input.Pointer,
			shouldShowAnchor = props.isHovered,
			buttonIconBackgroundStyle = v5.Color.OverMedia.OverMedia_0,
			menuKey = menuKey,
			setFocusRef = v12,
			onMenuOpenChanged = v8,
			buttonIconSize = iconSize.Small
		})
	else
		local v5 = useDispatch()
		local v6 = useTokens()
		local v7 = useLastInput()
		local v8 = useRoactService(roactNetworking)
		local v9 = useLocalization({
			notInterested = "Feature.GameDetails.Action.NotInterested",
			whyThisAd = "Feature.GameDetails.Action.WhyThisAd",
			reportAd = "Feature.GameDetails.Action.ReportAd",
			gameDetails = fFlagLuaAppContinueSortInstantPlay and "Feature.GameDetails.Action.GameDetails" or nil,
			reportExperience = fFlagLuaAppEnableReportExperience and "Feature.GameDetails.Action.Report" or nil,
			dialogTitle = "Feature.GameDetails.Label.ProvideFeedbackTitle",
			dialogText = "Feature.GameDetails.Message.HelpImproveExperience",
			checkboxListTitle = "Feature.GameDetails.Message.HidingExperienceQuestion",
			tooRepetitive = "Feature.GameDetails.Label.TooRepetitive",
			dontLikeGame = "Feature.GameDetails.Label.DontLikeGame",
			dontLikeImage = "Feature.GameDetails.Label.DontLikeImage",
			inappropriateContent = "Feature.GameDetails.Label.InappropriateContent",
			somethingElse = "Feature.GameDetails.Label.SomethingElse"
		})

		local collectionId = props.collectionId or ""
		local menuKey = props.menuKey
		local vector2 = Vector2.new(1, 0)
		local udim = UDim2.new(1, -v6.Padding.Medium, 0, v6.Padding.Medium)
		local overflowMenuSignalStore = getOverflowMenuSignalStore()
		local v10

		if not fFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v10 = useGameTileOverflowMenuFocusNavigation(menuKey, props.isSelected, props.parentRef)
		end

		local v11 = React.useMemo(function()
			return {
				{
					id = userSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
					text = v9.tooRepetitive
				},
				{
					id = userSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
					text = v9.dontLikeGame
				},
				{
					id = userSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
					text = v9.dontLikeImage
				},
				{
					id = userSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
					text = v9.inappropriateContent
				},
				{
					id = userSignalTypes.NotInterestedFeedbackItem.SomethingElse,
					text = v9.somethingElse,
					triggersOtherTextbox = true
				}
			}
		end, { v9 })

		local v12 = React.useCallback(function(p2, p3)
			local v13 = {}
			local flag = false

			for k, v14 in v11 do
				table.insert(v13, {
					id = v14.id,
					selected = p2[v14.id] or false
				})

				if
					v14.id == userSignalTypes.NotInterestedFeedbackItem.InappropriateContent
					and p2[v14.id]
				then
					flag = true
				end
			end

			if flag then
				if props.placeId and props.placeId ~= "" then
					v5(OpenDynamicAbuseReport({
						abuseVector = AbuseVector.Place,
						targetId = props.placeId,
						onClose = function()
							v5(closeCentralOverlay())
						end
					}))
				else
					flaggedMutedError(
						"NotInterestedReportPlaceIdMissing",
						"Place report opened without a place id"
					)
				end
			end

			if props.appPage then
				local success, result = pcall(function()
					local v16 = {
						stringValue = HttpService:JSONEncode({
							formId = userSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
							titleId = userSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
							textResponse = p3,
							items = v13
						})
					}

					local v17 = {
						id = props.universeId,
						assetType = 0,
						signalOrigin = 0
					}
					local v18 = if props.isSponsored then userSignalTypes.AssetType.SponsoredGame else userSignalTypes.AssetType.Game
					v17.assetType = v18

					v17.signalOrigin = {
						productSurface = props.appPage,
						topicId = collectionId,
						subIds = { collectionId }
					}
					postSendUserSignal(
						v8,
						v16,
						v17,
						userSignalTypes.SignalValueType.String,
						userSignalTypes.SignalType.NotInterestedFeedback
					):catch(function(p4)
						v5(setNetworkingErrorToast(p4))
						default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
					end)
				end)

				if not success then
					mutedError(result)
				end

				if fFlagLuaAppNotInterestedFeedbackFormTelemetry then
					sendNotInterestedFeedbackFormAnalytics(
						{
							universeId = props.universeId,
							sortId = collectionId,
							actionType = "NotInterestedFeedbackFormSubmitted"
						},
						props.appPage
					)
				end
			else
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

				v5(setNetworkingErrorToast())
			end
		end, {
			v8,
			v11,
			v9,
			props.universeId,
			props.placeId,
			props.appPage,
			collectionId,
			v5,
			props.isSponsored
		})
		local v13, v14

		if fFlagLuaAppNotInterestedFeedbackFormTelemetry then
			v13 = React.useCallback(function(p2)
				if p2 then
					return
				end

				sendNotInterestedFeedbackFormAnalytics(
					{
						universeId = props.universeId,
						sortId = collectionId,
						actionType = "NotInterestedFeedbackFormClosedWithoutSubmit"
					},
					props.appPage
				)
			end, { props.appPage, props.universeId, collectionId })

			v14 = React.useCallback(function()
				sendNotInterestedFeedbackFormAnalytics(
					{
						universeId = props.universeId,
						sortId = collectionId,
						actionType = "NotInterestedFeedbackFormOpened"
					},
					props.appPage
				)
			end, { props.appPage, props.universeId, collectionId })
		else
			v13 = nil
			v14 = nil
		end

		local v15 = React.useMemo(function()
			return {
				dialogTitle = v9.dialogTitle,
				dialogText = v9.dialogText,
				checkboxListTitle = v9.checkboxListTitle,
				checkboxItems = v11,
				onSubmit = v12,
				onClose = if fFlagLuaAppNotInterestedFeedbackFormTelemetry then v13 else nil,
				showTermsOfUseDisclaimer = if fFlagLuaAppMakeDisclaimerOptInForFeedbackForm then false else nil
			}
		end, { v9, v11, v12 })

		local v16 = {}

		for k, availableMenuItem in props.availableMenuItems do
			table.insert(v16, k)
		end

		local joined = table.concat(v16, ",")

		local v17 = React.useCallback(function(p2)
			if props.onMenuOpenChanged then
				props.onMenuOpenChanged(p2, joined)
			end
		end, { props.onMenuOpenChanged, joined })

		local useCallback = React.useCallback
		local function fn(p2)
			local v18 = {
				universeId = props.universeId,
				sortId = collectionId,
				actionType = "GameTileOverflowMenuItemActivated",
				menuItem = p2,
				availableMenuItems = joined,
				contentType = 0
			}

			local v19 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
			v18.contentType = v19

			gameTileOverflowMenuAction(v18, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId

		local v19 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
		local v20 = useCallback(fn, { appPage, universeId, collectionId, joined, v19 })

		if fFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v10 = useGameTileOverflowMenuFocusNavigation(menuKey, props.isSelected, props.parentRef, v17)
		end

		local v21

		if fFlagLuaAppContinueSortInstantPlay then
			v21 = React.useCallback(function()
				if props.onGameDetailsActivated then
					props.onGameDetailsActivated()
				end

				v20(tileOverflowMenuItems.GameDetails)
			end, { props.onGameDetailsActivated, v20 })
		else
			v21 = nil
		end

		local v22

		if fFlagLuaAppExtractNotInterestedHelper then
			v22 = React.useCallback(function()
				if activateGameNotInterested({
					appPage = props.appPage,
					collectionId = collectionId,
					dispatch = v5,
					isSponsored = props.isSponsored,
					localizedStrings = v9,
					networking = v8,
					placeId = props.placeId,
					setGameHidden = props.setGameHidden,
					universeId = props.universeId
				}) then
					v20(tileOverflowMenuItems.NotInterested)
				end
			end, {
				collectionId,
				v5,
				v9,
				v8,
				v20,
				props.appPage,
				props.isSponsored,
				props.placeId,
				props.setGameHidden,
				props.universeId
			})
		else
			v22 = React.useCallback(function()
				if props.appPage then
					props.setGameHidden(props.universeId, true)
					v5(setCentralOverlay(centralOverlayType.ProvideFeedbackToast, {
						feedbackFormProps = v15,
						toastIcon = iconName.CircleMinus,
						onToastActivated = if fFlagLuaAppNotInterestedFeedbackFormTelemetry then v14 else nil
					}))

					local success, result = pcall(function()
						local v30 = {
							id = props.universeId,
							assetType = 0,
							signalOrigin = 0
						}
						local v31 = if props.isSponsored then userSignalTypes.AssetType.SponsoredGame else userSignalTypes.AssetType.Game
						v30.assetType = v31

						v30.signalOrigin = {
							productSurface = props.appPage,
							topicId = collectionId,
							subIds = { collectionId }
						}
						postSendUserSignal(
							v8,
							{ boolValue = true },
							v30,
							userSignalTypes.SignalValueType.Bool,
							userSignalTypes.SignalType.NotInterested
						):catch(function(p2)
							props.setGameHidden(props.universeId, false)
							v5(setNetworkingErrorToast(p2))
							default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
						end)
					end)

					if not success then
						props.setGameHidden(props.universeId, false)
						mutedError(result)
					end

					v20(tileOverflowMenuItems.NotInterested)
				else
					default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

					v5(setNetworkingErrorToast())
				end
			end, {
				v8,
				props.setGameHidden,
				v5,
				v15,
				props.universeId,
				collectionId,
				props.appPage,
				v20,
				props.isSponsored
			})
		end

		local useCallback2 = React.useCallback
		local function fn2()
			local whyThisAdModal = centralOverlayType.WhyThisAdModal
			local v25 = {
				universeId = props.universeId,
				payerName = props.payerName,
				sponsoredUserCohort = props.sponsoredUserCohort,
				contentType = 0
			}
			local v26 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
			v25.contentType = v26
			v5(setCentralOverlay(whyThisAdModal, v25))

			v20(tileOverflowMenuItems.WhyThisAd)
		end

		local universeId2 = props.universeId
		local payerName = props.payerName
		local sponsoredUserCohort = props.sponsoredUserCohort
		local v24 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
		local v25 = useCallback2(fn2, {
			v5,
			universeId2,
			payerName,
			sponsoredUserCohort,
			v24,
			v20
		})

		local v26 = React.useCallback(function()
			if not props.adId then
				flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")
				return
			end

			v5(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.AdV2,
				targetId = props.adId,
				onClose = function()
					v5(closeCentralOverlay())
				end
			}))

			v20(tileOverflowMenuItems.ReportAd)
		end, { v5, props.adId, v20 })
		local v27

		if fFlagLuaAppEnableReportExperience then
			v27 = React.useCallback(function()
				if not props.placeId then
					flaggedMutedError(
						"ReportExperienceError",
						"Report experience clicked without valid target place id"
					)

					return
				end

				local v31 = if fFlagEnableNewReportFlowGameTile then AbuseVector.GameTile else AbuseVector.Place
				v5(OpenDynamicAbuseReport({
					abuseVector = v31,
					targetId = props.placeId,
					custom = fFlagAddThumbnailSelectorReport and {
						universeId = props.universeId
					} or nil,
					onClose = function()
						v5(closeCentralOverlay())
					end
				}))

				v20(tileOverflowMenuItems.ReportExperience)
			end, { v5, props.placeId, props.universeId, v20 })
		else
			v27 = nil
		end

		local function fn3()
			local v28 = {}

			if
				fFlagLuaAppContinueSortInstantPlay
				and props.availableMenuItems[tileOverflowMenuItems.GameDetails]
			then
				table.insert(v28, {
					icon = "icons/actions/info",
					id = tileOverflowMenuItems.GameDetails,
					text = v9.gameDetails,
					onActivated = v21
				})
			end

			if props.availableMenuItems[tileOverflowMenuItems.NotInterested] then
				table.insert(v28, {
					icon = "icons/actions/block",
					id = tileOverflowMenuItems.NotInterested,
					text = v9.notInterested,
					onActivated = v22
				})
			end

			if props.availableMenuItems[tileOverflowMenuItems.WhyThisAd] then
				table.insert(v28, {
					icon = "icons/actions/info",
					id = tileOverflowMenuItems.WhyThisAd,
					text = v9.whyThisAd,
					onActivated = v25
				})
			end

			if props.availableMenuItems[tileOverflowMenuItems.ReportAd] then
				table.insert(v28, {
					icon = iconName.Flag,
					id = tileOverflowMenuItems.ReportAd,
					text = v9.reportAd,
					onActivated = v26
				})
			end

			if
				fFlagLuaAppEnableReportExperience
				and props.availableMenuItems[tileOverflowMenuItems.ReportExperience]
			then
				table.insert(v28, {
					icon = iconName.Flag,
					id = tileOverflowMenuItems.ReportExperience,
					text = v9.reportExperience,
					onActivated = v27
				})
			end

			return v28
		end

		local v30 = React.useMemo(fn3, {
			if fFlagLuaAppContinueSortInstantPlay then v21 else nil,
			v22,
			v9,
			v25,
			fFlagLuaAppEnableReportExperience and v26 or nil,
			fFlagLuaAppEnableReportExperience and v27 or nil,
			props.isSponsored,
			props.availableMenuItems
		})
		local v31

		if fFlagSignalsNavP3fGameDetails then
			v31 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
		else
			v31 = useSelector(function(p2)
				if fFlagUseNavigationSelectors then
					return selectors.selectCurrentRoactNavigationRoute(p2).key or ""
				end

				return p2.Navigation.currentRoute.key or ""
			end)
		end

		local ref = React.useRef(v31)

		React.useEffect(function()
			if v31 ~= ref.current then
				overflowMenuSignalStore.closeMenu(menuKey)
			end
		end, { v31, menuKey })

		React.useEffect(function()
			local inputBeganConnection

			if props.menuOpen then
				inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and not props.isHovered then
						overflowMenuSignalStore.closeMenu(menuKey)
					end
				end)
			else
				inputBeganConnection = nil
			end

			return function()
				if inputBeganConnection then
					inputBeganConnection:Disconnect()
				end
			end
		end, { props.menuOpen, props.isHovered, menuKey })

		return React.createElement(overflowMenu, {
			anchorPoint = vector2,
			anchorPosition = udim,
			menuItems = v30,
			hasOverflowButton = v7 == Responsive.Input.Pointer,
			shouldShowAnchor = props.isHovered,
			buttonIconBackgroundStyle = v6.Color.OverMedia.OverMedia_0,
			menuKey = menuKey,
			setFocusRef = v10,
			onMenuOpenChanged = v17,
			buttonIconSize = iconSize.Small
		})
	end
end

return React.memo(GameTileOverflowMenu)
