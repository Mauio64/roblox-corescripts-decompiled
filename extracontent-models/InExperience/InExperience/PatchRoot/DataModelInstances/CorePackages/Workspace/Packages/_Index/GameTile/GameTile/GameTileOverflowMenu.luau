local UserInputService = game:GetService("UserInputService")

local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local AppBlox = require(parent.AppBlox)
local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Loggers = require(parent.Loggers)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SharedFlags = require(parent.SharedFlags)
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
local flaggedMutedError = Loggers.flaggedMutedError
local useLastInput = Responsive.useLastInput
local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local activateGameNotInterested = require(GameTile.activateGameNotInterested)
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

local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local FFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppGameTileNotInterestedDirectAction = SharedFlags.FFlagLuaAppGameTileNotInterestedDirectAction

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

			if FFlagLuaAppEnableNxMRoduxApportioning then
				contentType = props.contentType
			end

			v4.contentType = contentType

			gameTileOverflowMenuAction(v4, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId
		local v4

		if FFlagLuaAppEnableNxMRoduxApportioning then
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

			if FFlagLuaAppEnableNxMRoduxApportioning then
				contentType = props.contentType
			end

			v4.contentType = contentType

			gameTileOverflowMenuAction(v4, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId
		local v4

		if FFlagLuaAppEnableNxMRoduxApportioning then
			v4 = props.contentType
		end

		local v5 = useCallback(fn, { appPage, universeId, collectionId, joined, v4 })

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

				v5(TileOverflowMenuItems.GameDetails)
			end, { props.onGameDetailsActivated, v5 })
		else
			onActivated = nil
		end

		local onActivated2 = React.useCallback(function()
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
				v5(TileOverflowMenuItems.NotInterested)
			end
		end, {
			collectionId,
			dispatch,
			localizedStrings,
			networking,
			v5,
			props.appPage,
			props.isSponsored,
			props.placeId,
			props.setGameHidden,
			props.universeId
		})

		local useCallback2 = React.useCallback
		local function fn2()
			local whyThisAdModal = CentralOverlayType.WhyThisAdModal
			local v6 = {
				universeId = props.universeId,
				payerName = props.payerName,
				sponsoredUserCohort = props.sponsoredUserCohort,
				contentType = 0
			}
			local contentType

			if FFlagLuaAppEnableNxMRoduxApportioning then
				contentType = props.contentType
			end

			v6.contentType = contentType
			dispatch(SetCentralOverlay(whyThisAdModal, v6))

			v5(TileOverflowMenuItems.WhyThisAd)
		end

		local universeId2 = props.universeId
		local payerName = props.payerName
		local sponsoredUserCohort = props.sponsoredUserCohort
		local v6

		if FFlagLuaAppEnableNxMRoduxApportioning then
			v6 = props.contentType
		end

		local onActivated3 = useCallback2(fn2, {
			dispatch,
			universeId2,
			payerName,
			sponsoredUserCohort,
			v6,
			v5
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

			v5(TileOverflowMenuItems.ReportAd)
		end, { dispatch, props.adId, v5 })
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

				v5(TileOverflowMenuItems.ReportExperience)
			end, { dispatch, props.placeId, props.universeId, v5 })
		else
			onActivated5 = nil
		end

		local useMemo = React.useMemo
		local function fn3()
			local v7 = {}

			if FFlagLuaAppContinueSortInstantPlay and props.availableMenuItems[TileOverflowMenuItems.GameDetails] then
				table.insert(v7, {
					icon = "icons/actions/info",
					id = TileOverflowMenuItems.GameDetails,
					text = localizedStrings.gameDetails,
					onActivated = onActivated
				})
			end

			if props.availableMenuItems[TileOverflowMenuItems.NotInterested] then
				table.insert(v7, {
					icon = "icons/actions/block",
					id = TileOverflowMenuItems.NotInterested,
					text = localizedStrings.notInterested,
					onActivated = onActivated2
				})
			end

			if props.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
				table.insert(v7, {
					icon = "icons/actions/info",
					id = TileOverflowMenuItems.WhyThisAd,
					text = localizedStrings.whyThisAd,
					onActivated = onActivated3
				})
			end

			if props.availableMenuItems[TileOverflowMenuItems.ReportAd] then
				table.insert(v7, {
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
				table.insert(v7, {
					icon = IconName.Flag,
					id = TileOverflowMenuItems.ReportExperience,
					text = localizedStrings.reportExperience,
					onActivated = onActivated5
				})
			end

			return v7
		end

		local v7

		if FFlagLuaAppContinueSortInstantPlay then
			v7 = onActivated
		end

		local menuItems = useMemo(fn3, {
			v7,
			onActivated2,
			localizedStrings,
			onActivated3,
			FFlagLuaAppEnableReportExperience and onActivated4 or nil,
			FFlagLuaAppEnableReportExperience and onActivated5 or nil,
			props.isSponsored,
			props.availableMenuItems
		})
		local v8

		if FFlagSignalsNavP3fGameDetails then
			v8 = useSignalState(getLegacyNavigationStore(false).getCurrentRouteKey)
		else
			v8 = useSelector(function(p)
				if FFlagUseNavigationSelectors then
					return Selectors.selectCurrentRoactNavigationRoute(p).key or ""
				end

				return p.Navigation.currentRoute.key or ""
			end)
		end

		local ref = React.useRef(v8)

		React.useEffect(function()
			if v8 ~= ref.current then
				overflowMenuSignalStore.closeMenu(menuKey)
			end
		end, { v8, menuKey })

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
