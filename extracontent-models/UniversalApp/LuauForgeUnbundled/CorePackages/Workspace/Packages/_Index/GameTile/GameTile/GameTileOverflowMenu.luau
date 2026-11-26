local UserInputService = game:GetService("UserInputService")

local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppBlox")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization")
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
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
local flaggedMutedError = Loggers.flaggedMutedError
local useLastInput = Responsive.useLastInput
local roactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local activateGameNotInterested = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/activateGameNotInterested")
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

local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local fFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local fFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry
local fFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local fFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction

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

			local v10 = if fFlagLuaAppEnableNxMRoduxApportioning then props.contentType else nil
			v9.contentType = v10

			gameTileOverflowMenuAction(v9, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId

		local v10 = if fFlagLuaAppEnableNxMRoduxApportioning then props.contentType else nil
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

		local v11 = {}

		for k, availableMenuItem in props.availableMenuItems do
			table.insert(v11, k)
		end

		local joined = table.concat(v11, ",")

		local v12 = React.useCallback(function(p2)
			if props.onMenuOpenChanged then
				props.onMenuOpenChanged(p2, joined)
			end
		end, { props.onMenuOpenChanged, joined })

		local useCallback = React.useCallback
		local function fn(p2)
			local v13 = {
				universeId = props.universeId,
				sortId = collectionId,
				actionType = "GameTileOverflowMenuItemActivated",
				menuItem = p2,
				availableMenuItems = joined,
				contentType = 0
			}

			local v14 = if fFlagLuaAppEnableNxMRoduxApportioning then props.contentType else nil
			v13.contentType = v14

			gameTileOverflowMenuAction(v13, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId

		local v14 = if fFlagLuaAppEnableNxMRoduxApportioning then props.contentType else nil
		local v15 = useCallback(fn, { appPage, universeId, collectionId, joined, v14 })

		if fFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v10 = useGameTileOverflowMenuFocusNavigation(menuKey, props.isSelected, props.parentRef, v12)
		end

		local v16

		if fFlagLuaAppContinueSortInstantPlay then
			v16 = React.useCallback(function()
				if props.onGameDetailsActivated then
					props.onGameDetailsActivated()
				end

				v15(tileOverflowMenuItems.GameDetails)
			end, { props.onGameDetailsActivated, v15 })
		else
			v16 = nil
		end

		local v17 = React.useCallback(function()
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
				v15(tileOverflowMenuItems.NotInterested)
			end
		end, {
			collectionId,
			v5,
			v9,
			v8,
			v15,
			props.appPage,
			props.isSponsored,
			props.placeId,
			props.setGameHidden,
			props.universeId
		})

		local useCallback2 = React.useCallback
		local function fn2()
			local whyThisAdModal = centralOverlayType.WhyThisAdModal
			local v20 = {
				universeId = props.universeId,
				payerName = props.payerName,
				sponsoredUserCohort = props.sponsoredUserCohort,
				contentType = 0
			}
			local v21 = if fFlagLuaAppEnableNxMRoduxApportioning then props.contentType else nil
			v20.contentType = v21
			v5(setCentralOverlay(whyThisAdModal, v20))

			v15(tileOverflowMenuItems.WhyThisAd)
		end

		local universeId2 = props.universeId
		local payerName = props.payerName
		local sponsoredUserCohort = props.sponsoredUserCohort
		local v19 = if fFlagLuaAppEnableNxMRoduxApportioning then props.contentType else nil
		local v20 = useCallback2(fn2, {
			v5,
			universeId2,
			payerName,
			sponsoredUserCohort,
			v19,
			v15
		})

		local v21 = React.useCallback(function()
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

			v15(tileOverflowMenuItems.ReportAd)
		end, { v5, props.adId, v15 })
		local v22

		if fFlagLuaAppEnableReportExperience then
			v22 = React.useCallback(function()
				if not props.placeId then
					flaggedMutedError(
						"ReportExperienceError",
						"Report experience clicked without valid target place id"
					)

					return
				end

				local v26 = if fFlagEnableNewReportFlowGameTile then AbuseVector.GameTile else AbuseVector.Place
				v5(OpenDynamicAbuseReport({
					abuseVector = v26,
					targetId = props.placeId,
					custom = fFlagAddThumbnailSelectorReport and {
						universeId = props.universeId
					} or nil,
					onClose = function()
						v5(closeCentralOverlay())
					end
				}))

				v15(tileOverflowMenuItems.ReportExperience)
			end, { v5, props.placeId, props.universeId, v15 })
		else
			v22 = nil
		end

		local function fn3()
			local v23 = {}

			if
				fFlagLuaAppContinueSortInstantPlay
				and props.availableMenuItems[tileOverflowMenuItems.GameDetails]
			then
				table.insert(v23, {
					icon = "icons/actions/info",
					id = tileOverflowMenuItems.GameDetails,
					text = v9.gameDetails,
					onActivated = v16
				})
			end

			if props.availableMenuItems[tileOverflowMenuItems.NotInterested] then
				table.insert(v23, {
					icon = "icons/actions/block",
					id = tileOverflowMenuItems.NotInterested,
					text = v9.notInterested,
					onActivated = v17
				})
			end

			if props.availableMenuItems[tileOverflowMenuItems.WhyThisAd] then
				table.insert(v23, {
					icon = "icons/actions/info",
					id = tileOverflowMenuItems.WhyThisAd,
					text = v9.whyThisAd,
					onActivated = v20
				})
			end

			if props.availableMenuItems[tileOverflowMenuItems.ReportAd] then
				table.insert(v23, {
					icon = iconName.Flag,
					id = tileOverflowMenuItems.ReportAd,
					text = v9.reportAd,
					onActivated = v21
				})
			end

			if
				fFlagLuaAppEnableReportExperience
				and props.availableMenuItems[tileOverflowMenuItems.ReportExperience]
			then
				table.insert(v23, {
					icon = iconName.Flag,
					id = tileOverflowMenuItems.ReportExperience,
					text = v9.reportExperience,
					onActivated = v22
				})
			end

			return v23
		end

		local v25 = React.useMemo(fn3, {
			if fFlagLuaAppContinueSortInstantPlay then v16 else nil,
			v17,
			v9,
			v20,
			fFlagLuaAppEnableReportExperience and v21 or nil,
			fFlagLuaAppEnableReportExperience and v22 or nil,
			props.isSponsored,
			props.availableMenuItems
		})
		local v26

		if fFlagSignalsNavP3fGameDetails then
			v26 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
		else
			v26 = useSelector(function(p2)
				if fFlagUseNavigationSelectors then
					return selectors.selectCurrentRoactNavigationRoute(p2).key or ""
				end

				return p2.Navigation.currentRoute.key or ""
			end)
		end

		local ref = React.useRef(v26)

		React.useEffect(function()
			if v26 ~= ref.current then
				overflowMenuSignalStore.closeMenu(menuKey)
			end
		end, { v26, menuKey })

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
			menuItems = v25,
			hasOverflowButton = v7 == Responsive.Input.Pointer,
			shouldShowAnchor = props.isHovered,
			buttonIconBackgroundStyle = v6.Color.OverMedia.OverMedia_0,
			menuKey = menuKey,
			setFocusRef = v10,
			onMenuOpenChanged = v12,
			buttonIconSize = iconSize.Small
		})
	end
end

return React.memo(GameTileOverflowMenu)
