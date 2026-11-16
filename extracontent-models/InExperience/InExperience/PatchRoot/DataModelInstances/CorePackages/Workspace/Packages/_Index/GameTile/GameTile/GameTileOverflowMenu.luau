local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local AppBlox = require(parent.AppBlox)
local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Loggers = require(parent.Loggers)
local LoggingProtocol = require(parent.LoggingProtocol)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SharedFlags = require(parent.SharedFlags)
local UserSignals = require(parent.UserSignals)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local NavigationRodux = require(parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors

local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local OverflowMenu = AppBlox.OverflowMenu
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)
local useLocalization = Localization.Hooks.useLocalization
local mutedError = Loggers.mutedError
local flaggedMutedError = Loggers.flaggedMutedError
local default = LoggingProtocol.default
local useLastInput = Responsive.useLastInput
local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local PostSendUserSignal = UserSignals.PostSendUserSignal
local UserSignalTypes = UserSignals.UserSignalTypes
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local NotInterestedUserSignalTelemetryEventConfigs = require(GameTile.NotInterestedUserSignalTelemetryEventConfigs)
local activateGameNotInterested = require(GameTile.activateGameNotInterested)
local sendNotInterestedFeedbackFormAnalytics = require(GameTile.sendNotInterestedFeedbackFormAnalytics)
local useGameTileActions = require(GameTile.useGameTileActions)
local useGameTileOverflowMenuFocusNavigation = require(GameTile.useGameTileOverflowMenuFocusNavigation)
local GameTileConstants = require(GameTile.GameTileConstants)
local TileOverflowMenuItems = GameTileConstants.TileOverflowMenuItems

local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if FFlagSignalsNavP3fGameDetails then
	local NavigationRodux2 = require(parent.NavigationRodux)
	getLegacyNavigationStore = NavigationRodux2.GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local FFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local FFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction
local FFlagLuaAppExtractNotInterestedHelper = SharedFlags.FFlagLuaAppExtractNotInterestedHelper

local function GameTileOverflowMenu(props)
	if FFlagLuaAppGameTileNotInterestedDirectAction then
		local v = useTokens()
		local v2 = useLastInput()
		local menuKey = props.menuKey
		local vector2 = Vector2.new(1, 0)
		local udim = UDim2.new(1, -v.Padding.Medium, 0, v.Padding.Medium)
		local overflowMenuSignalStore = getOverflowMenuSignalStore()
		local collectionId = props.collectionId or ""
		local v3 = {}

		for k, _ in props.availableMenuItems do
			table.insert(v3, k)
		end

		local joined = table.concat(v3, ",")

		local onMenuOpenChanged = React.useCallback(function(flag: boolean)
			if props.onMenuOpenChanged then
				props.onMenuOpenChanged(flag, joined)
			end
		end, { props.onMenuOpenChanged, joined })

		local useCallback = React.useCallback
		local function fn(menuItem: string)
			local v4 = {
				universeId = props.universeId,
				sortId = collectionId,
				actionType = "GameTileOverflowMenuItemActivated",
				menuItem = menuItem,
				availableMenuItems = joined,
				contentType = 0
			}
			local contentType

			if FFlagLuaAppEnableHomepageOneByTwoTile then
				contentType = props.contentType
			end

			v4.contentType = contentType

			gameTileOverflowMenuAction(v4, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId
		local v4

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			v4 = props.contentType
		end

		local v5 = useCallback(fn, { appPage, universeId, collectionId, joined, v4 })
		local setFocusRef

		if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			setFocusRef = useGameTileOverflowMenuFocusNavigation(menuKey, props.isSelected, props.parentRef)
		end

		local menuItems = useGameTileActions(props, v5)

		if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			setFocusRef = useGameTileOverflowMenuFocusNavigation(
				menuKey,
				props.isSelected,
				props.parentRef,
				onMenuOpenChanged
			)
		end

		local v6

		if FFlagSignalsNavP3fGameDetails then
			v6 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
		else
			v6 = useSelector(function(p)
				if FFlagUseNavigationSelectors then
					return Selectors.selectCurrentRoactNavigationRoute(p).key or ""
				end

				return p.Navigation.currentRoute.key or ""
			end)
		end

		local ref = React.useRef(v6)

		React.useEffect(function()
			if v6 ~= ref.current then
				overflowMenuSignalStore.closeMenu(menuKey)
			end
		end, { v6, menuKey, overflowMenuSignalStore.closeMenu })

		React.useEffect(function()
			local inputBeganConnection

			if props.menuOpen then
				inputBeganConnection = UserInputService.InputBegan:Connect(function(input, _: boolean)
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
		end, { props.menuOpen, props.isHovered, menuKey, overflowMenuSignalStore.closeMenu })

		return React.createElement(OverflowMenu, {
			anchorPoint = vector2,
			anchorPosition = udim,
			menuItems = menuItems,
			hasOverflowButton = v2 == Responsive.Input.Pointer,
			shouldShowAnchor = props.isHovered,
			buttonIconBackgroundStyle = v.Color.OverMedia.OverMedia_0,
			menuKey = menuKey,
			setFocusRef = setFocusRef,
			onMenuOpenChanged = onMenuOpenChanged,
			buttonIconSize = IconSize.Small
		})
	else
		local dispatch = useDispatch()
		local v = useTokens()
		local v2 = useLastInput()
		local networking = useRoactService(RoactNetworking)
		local localizedStrings = useLocalization({
			notInterested = "Feature.GameDetails.Action.NotInterested",
			whyThisAd = "Feature.GameDetails.Action.WhyThisAd",
			reportAd = "Feature.GameDetails.Action.ReportAd",
			gameDetails = FFlagLuaAppContinueSortInstantPlay and "Feature.GameDetails.Action.GameDetails" or nil,
			reportExperience = FFlagLuaAppEnableReportExperience and "Feature.GameDetails.Action.Report" or nil,
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
		local udim = UDim2.new(1, -v.Padding.Medium, 0, v.Padding.Medium)
		local overflowMenuSignalStore = getOverflowMenuSignalStore()
		local setFocusRef

		if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			setFocusRef = useGameTileOverflowMenuFocusNavigation(menuKey, props.isSelected, props.parentRef)
		end

		local checkboxItems = React.useMemo(function()
			return {
				{
					id = UserSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
					text = localizedStrings.tooRepetitive
				},
				{
					id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
					text = localizedStrings.dontLikeGame
				},
				{
					id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
					text = localizedStrings.dontLikeImage
				},
				{
					id = UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
					text = localizedStrings.inappropriateContent
				},
				{
					id = UserSignalTypes.NotInterestedFeedbackItem.SomethingElse,
					text = localizedStrings.somethingElse,
					triggersOtherTextbox = true
				}
			}
		end, { localizedStrings })

		local onSubmit = React.useCallback(function(p, textResponse: string)
			local items = {}
			local flag = false

			for _, v3 in checkboxItems do
				table.insert(items, {
					id = v3.id,
					selected = p[v3.id] or false
				})

				if v3.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and p[v3.id] then
					flag = true
				end
			end

			if flag then
				if props.placeId and props.placeId ~= "" then
					dispatch(OpenDynamicAbuseReport({
						abuseVector = AbuseVector.Place,
						targetId = props.placeId,
						onClose = function()
							dispatch(CloseCentralOverlay())
						end
					}))
				else
					flaggedMutedError("NotInterestedReportPlaceIdMissing", "Place report opened without a place id")
				end
			end

			if props.appPage then
				local success, result = pcall(function()
					local v3 = {
						stringValue = HttpService:JSONEncode({
							formId = UserSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
							titleId = UserSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
							textResponse = textResponse,
							items = items
						})
					}

					local v4 = { id = props.universeId, assetType = 0, signalOrigin = 0 }
					local assetType

					if props.isSponsored then
						assetType = UserSignalTypes.AssetType.SponsoredGame
					else
						assetType = UserSignalTypes.AssetType.Game
					end

					v4.assetType = assetType

					v4.signalOrigin = {
						productSurface = props.appPage,
						topicId = collectionId,
						subIds = { collectionId }
					}
					PostSendUserSignal(
						networking,
						v3,
						v4,
						UserSignalTypes.SignalValueType.String,
						UserSignalTypes.SignalType.NotInterestedFeedback
					):catch(function(p2)
						dispatch(SetNetworkingErrorToast(p2))
						default:logRobloxTelemetryCounter(
							NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed,
							1
						)
					end)
				end)

				if not success then
					mutedError(result)
				end

				if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
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
				default:logRobloxTelemetryCounter(
					NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage,
					1
				)

				dispatch(SetNetworkingErrorToast())
			end
		end, {
			networking,
			checkboxItems,
			localizedStrings,
			props.universeId,
			props.placeId,
			props.appPage,
			collectionId,
			dispatch,
			props.isSponsored
		})
		local v3, v4

		if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
			v3 = React.useCallback(function(flag: boolean?)
				if flag then
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

			v4 = React.useCallback(function()
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
			v3 = nil
			v4 = nil
		end

		local feedbackFormProps = React.useMemo(function()
			local v5 = {
				dialogTitle = localizedStrings.dialogTitle,
				dialogText = localizedStrings.dialogText,
				checkboxListTitle = localizedStrings.checkboxListTitle,
				checkboxItems = checkboxItems,
				onSubmit = onSubmit,
				onClose = 0,
				showTermsOfUseDisclaimer = 0
			}
			local onClose

			if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
				onClose = v3
			end

			v5.onClose = onClose
			v5.showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
			return v5
		end, { localizedStrings, checkboxItems, onSubmit })

		local v5 = {}

		for k, _ in props.availableMenuItems do
			table.insert(v5, k)
		end

		local joined = table.concat(v5, ",")

		local onMenuOpenChanged = React.useCallback(function(flag: boolean)
			if props.onMenuOpenChanged then
				props.onMenuOpenChanged(flag, joined)
			end
		end, { props.onMenuOpenChanged, joined })

		local useCallback = React.useCallback
		local function fn(menuItem: string)
			local v6 = {
				universeId = props.universeId,
				sortId = collectionId,
				actionType = "GameTileOverflowMenuItemActivated",
				menuItem = menuItem,
				availableMenuItems = joined,
				contentType = 0
			}
			local contentType

			if FFlagLuaAppEnableHomepageOneByTwoTile then
				contentType = props.contentType
			end

			v6.contentType = contentType

			gameTileOverflowMenuAction(v6, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId
		local v6

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			v6 = props.contentType
		end

		local v7 = useCallback(fn, { appPage, universeId, collectionId, joined, v6 })

		if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			setFocusRef = useGameTileOverflowMenuFocusNavigation(
				menuKey,
				props.isSelected,
				props.parentRef,
				onMenuOpenChanged
			)
		end

		local onActivated

		if FFlagLuaAppContinueSortInstantPlay then
			onActivated = React.useCallback(function()
				if props.onGameDetailsActivated then
					props.onGameDetailsActivated()
				end

				v7(TileOverflowMenuItems.GameDetails)
			end, { props.onGameDetailsActivated, v7 })
		else
			onActivated = nil
		end

		local onActivated2

		if FFlagLuaAppExtractNotInterestedHelper then
			onActivated2 = React.useCallback(function()
				if activateGameNotInterested({
					appPage = props.appPage,
					collectionId = collectionId,
					dispatch = dispatch,
					isSponsored = props.isSponsored,
					localizedStrings = localizedStrings,
					networking = networking,
					placeId = props.placeId,
					setGameHidden = props.setGameHidden,
					universeId = props.universeId
				}) then
					v7(TileOverflowMenuItems.NotInterested)
				end
			end, {
				collectionId,
				dispatch,
				localizedStrings,
				networking,
				v7,
				props.appPage,
				props.isSponsored,
				props.placeId,
				props.setGameHidden,
				props.universeId
			})
		else
			onActivated2 = React.useCallback(function()
				if props.appPage then
					props.setGameHidden(props.universeId, true)
					local provideFeedbackToast = CentralOverlayType.ProvideFeedbackToast
					local v8 = {
						feedbackFormProps = feedbackFormProps,
						toastIcon = IconName.CircleMinus,
						onToastActivated = 0
					}
					local onToastActivated

					if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
						onToastActivated = v4
					end

					v8.onToastActivated = onToastActivated
					dispatch(SetCentralOverlay(provideFeedbackToast, v8))

					local success, result = pcall(function()
						local v9 = { id = props.universeId, assetType = 0, signalOrigin = 0 }
						local assetType

						if props.isSponsored then
							assetType = UserSignalTypes.AssetType.SponsoredGame
						else
							assetType = UserSignalTypes.AssetType.Game
						end

						v9.assetType = assetType

						v9.signalOrigin = {
							productSurface = props.appPage,
							topicId = collectionId,
							subIds = { collectionId }
						}
						PostSendUserSignal(
							networking,
							{ boolValue = true },
							v9,
							UserSignalTypes.SignalValueType.Bool,
							UserSignalTypes.SignalType.NotInterested
						):catch(function(p)
							props.setGameHidden(props.universeId, false)
							dispatch(SetNetworkingErrorToast(p))
							default:logRobloxTelemetryCounter(
								NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed,
								1
							)
						end)
					end)

					if not success then
						props.setGameHidden(props.universeId, false)
						mutedError(result)
					end

					v7(TileOverflowMenuItems.NotInterested)
				else
					default:logRobloxTelemetryCounter(
						NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage,
						1
					)

					dispatch(SetNetworkingErrorToast())
				end
			end, {
				networking,
				props.setGameHidden,
				dispatch,
				feedbackFormProps,
				props.universeId,
				collectionId,
				props.appPage,
				v7,
				props.isSponsored
			})
		end

		local useCallback2 = React.useCallback
		local function fn2()
			local whyThisAdModal = CentralOverlayType.WhyThisAdModal
			local v8 = {
				universeId = props.universeId,
				payerName = props.payerName,
				sponsoredUserCohort = props.sponsoredUserCohort,
				contentType = 0
			}
			local contentType

			if FFlagLuaAppEnableHomepageOneByTwoTile then
				contentType = props.contentType
			end

			v8.contentType = contentType
			dispatch(SetCentralOverlay(whyThisAdModal, v8))

			v7(TileOverflowMenuItems.WhyThisAd)
		end

		local universeId2 = props.universeId
		local payerName = props.payerName
		local sponsoredUserCohort = props.sponsoredUserCohort
		local v8

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			v8 = props.contentType
		end

		local onActivated3 = useCallback2(fn2, {
			dispatch,
			universeId2,
			payerName,
			sponsoredUserCohort,
			v8,
			v7
		})

		local onActivated4 = React.useCallback(function()
			if not props.adId then
				flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")
				return
			end

			dispatch(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.AdV2,
				targetId = props.adId,
				onClose = function()
					dispatch(CloseCentralOverlay())
				end
			}))

			v7(TileOverflowMenuItems.ReportAd)
		end, { dispatch, props.adId, v7 })
		local onActivated5

		if FFlagLuaAppEnableReportExperience then
			onActivated5 = React.useCallback(function()
				if not props.placeId then
					flaggedMutedError(
						"ReportExperienceError",
						"Report experience clicked without valid target place id"
					)

					return
				end

				local abuseVector

				if FFlagEnableNewReportFlowGameTile then
					abuseVector = AbuseVector.GameTile
				else
					abuseVector = AbuseVector.Place
				end

				dispatch(OpenDynamicAbuseReport({
					abuseVector = abuseVector,
					targetId = props.placeId,
					custom = FFlagAddThumbnailSelectorReport and { universeId = props.universeId } or nil,
					onClose = function()
						dispatch(CloseCentralOverlay())
					end
				}))

				v7(TileOverflowMenuItems.ReportExperience)
			end, { dispatch, props.placeId, props.universeId, v7 })
		else
			onActivated5 = nil
		end

		local useMemo = React.useMemo
		local function fn3()
			local v9 = {}

			if FFlagLuaAppContinueSortInstantPlay and props.availableMenuItems[TileOverflowMenuItems.GameDetails] then
				table.insert(v9, {
					icon = "icons/actions/info",
					id = TileOverflowMenuItems.GameDetails,
					text = localizedStrings.gameDetails,
					onActivated = onActivated
				})
			end

			if props.availableMenuItems[TileOverflowMenuItems.NotInterested] then
				table.insert(v9, {
					icon = "icons/actions/block",
					id = TileOverflowMenuItems.NotInterested,
					text = localizedStrings.notInterested,
					onActivated = onActivated2
				})
			end

			if props.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
				table.insert(v9, {
					icon = "icons/actions/info",
					id = TileOverflowMenuItems.WhyThisAd,
					text = localizedStrings.whyThisAd,
					onActivated = onActivated3
				})
			end

			if props.availableMenuItems[TileOverflowMenuItems.ReportAd] then
				table.insert(v9, {
					icon = IconName.Flag,
					id = TileOverflowMenuItems.ReportAd,
					text = localizedStrings.reportAd,
					onActivated = onActivated4
				})
			end

			if
				FFlagLuaAppEnableReportExperience
				and props.availableMenuItems[TileOverflowMenuItems.ReportExperience]
			then
				table.insert(v9, {
					icon = IconName.Flag,
					id = TileOverflowMenuItems.ReportExperience,
					text = localizedStrings.reportExperience,
					onActivated = onActivated5
				})
			end

			return v9
		end

		local v9

		if FFlagLuaAppContinueSortInstantPlay then
			v9 = onActivated
		end

		local menuItems = useMemo(fn3, {
			v9,
			onActivated2,
			localizedStrings,
			onActivated3,
			FFlagLuaAppEnableReportExperience and onActivated4 or nil,
			FFlagLuaAppEnableReportExperience and onActivated5 or nil,
			props.isSponsored,
			props.availableMenuItems
		})
		local v10

		if FFlagSignalsNavP3fGameDetails then
			v10 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
		else
			v10 = useSelector(function(p)
				if FFlagUseNavigationSelectors then
					return Selectors.selectCurrentRoactNavigationRoute(p).key or ""
				end

				return p.Navigation.currentRoute.key or ""
			end)
		end

		local ref = React.useRef(v10)

		React.useEffect(function()
			if v10 ~= ref.current then
				overflowMenuSignalStore.closeMenu(menuKey)
			end
		end, { v10, menuKey })

		React.useEffect(function()
			local inputBeganConnection

			if props.menuOpen then
				inputBeganConnection = UserInputService.InputBegan:Connect(function(input, _: boolean)
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

		return React.createElement(OverflowMenu, {
			anchorPoint = vector2,
			anchorPosition = udim,
			menuItems = menuItems,
			hasOverflowButton = v2 == Responsive.Input.Pointer,
			shouldShowAnchor = props.isHovered,
			buttonIconBackgroundStyle = v.Color.OverMedia.OverMedia_0,
			menuKey = menuKey,
			setFocusRef = setFocusRef,
			onMenuOpenChanged = onMenuOpenChanged,
			buttonIconSize = IconSize.Small
		})
	end
end

return React.memo(GameTileOverflowMenu)
