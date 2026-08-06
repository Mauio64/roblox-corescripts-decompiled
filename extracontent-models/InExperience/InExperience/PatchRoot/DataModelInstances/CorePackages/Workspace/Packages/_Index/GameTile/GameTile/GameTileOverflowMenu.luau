local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local AppBlox = require(GameTileParent.AppBlox)
local CentralOverlay = require(GameTileParent.CentralOverlay)
local Foundation = require(GameTileParent.Foundation)
local Localization = require(GameTileParent.Localization)
local Loggers = require(GameTileParent.Loggers)
local LoggingProtocol = require(GameTileParent.LoggingProtocol)
local React = require(GameTileParent.React)
local Responsive = require(GameTileParent.Responsive)
local RoactServiceTags = require(GameTileParent.RoactServiceTags)
local RoactUtils = require(GameTileParent.RoactUtils)
local RobloxAppEnums = require(GameTileParent.RobloxAppEnums)
local RobloxAppHooks = require(GameTileParent.RobloxAppHooks)
local RobloxAppToastsRodux = require(GameTileParent.RobloxAppToastsRodux)
local SharedFlags = require(GameTileParent.SharedFlags)
local UIBlox = require(GameTileParent.UIBlox)
local UserSignals = require(GameTileParent.UserSignals)
local DiscoveryAnalytics = require(GameTileParent.DiscoveryAnalytics)
local Selectors = require(GameTileParent.NavigationRodux).Selectors
local getOverflowMenuSignalStore = AppBlox.getOverflowMenuSignalStore
local OverflowMenu = AppBlox.OverflowMenu
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local AbuseVector = require(GameTileParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(GameTileParent.GenericAbuseReporting.OpenDynamicAbuseReport)
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
local Images = UIBlox.App.ImageSet.Images
local PostSendUserSignal = UserSignals.PostSendUserSignal
local UserSignalTypes = UserSignals.UserSignalTypes
local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction
local NotInterestedUserSignalTelemetryEventConfigs = require(GameTile.NotInterestedUserSignalTelemetryEventConfigs)
local sendNotInterestedFeedbackFormAnalytics = require(GameTile.sendNotInterestedFeedbackFormAnalytics)
local useGameTileOverflowMenuFocusNavigation = require(GameTile.useGameTileOverflowMenuFocusNavigation)
local TileOverflowMenuItems = require(GameTile.GameTileConstants).TileOverflowMenuItems
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local useSignalState = require(GameTileParent.SignalsReact).useSignalState
local v55 = if not FFlagSignalsNavP3fGameDetails then nil else require(GameTileParent.NavigationRodux).GetLegacyNavigationStore
local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local FFlagLuaAppFixExplicitFeedbackTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackTelemetry
local FFlagLuaAppEnableSponsoredReportAd = SharedFlags.FFlagLuaAppEnableSponsoredReportAd
local v60 = game:DefineFastFlag("LuaAppAdjustOverflowMenuVisual", false)
local FFlagLuaAppUseSnackbarForProvideFeedbackToast = SharedFlags.FFlagLuaAppUseSnackbarForProvideFeedbackToast
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry

local function GameTileOverflowMenu(t1: {[any]: any}) -- line: 93
	-- upvalues: useDispatch (copy), useTokens (copy), useLastInput (copy), useRoactService (copy), RoactNetworking (copy), useLocalization (copy), FFlagLuaAppEnableSponsoredReportAd (copy), v60 (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), useGameTileOverflowMenuFocusNavigation (copy), React (copy), UserSignalTypes (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), HttpService (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy), gameTileOverflowMenuAction (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), TileOverflowMenuItems (copy), flaggedMutedError (copy), IconName (copy), FFlagSignalsNavP3fGameDetails (copy), useSignalState (copy), v55 (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), UserInputService (copy), OverflowMenu (copy), Responsive (copy), IconSize (copy)
	local v65 = useDispatch()
	local v66 = useTokens()
	local v67 = useLastInput()
	local v68 = useRoactService(RoactNetworking)
	local v69 = useLocalization({
		notInterested = "Feature.GameDetails.Action.NotInterested",
		whyThisAd = "Feature.GameDetails.Action.WhyThisAd",
		dialogTitle = "Feature.GameDetails.Label.ProvideFeedbackTitle",
		dialogText = "Feature.GameDetails.Message.HelpImproveExperience",
		checkboxListTitle = "Feature.GameDetails.Message.HidingExperienceQuestion",
		tooRepetitive = "Feature.GameDetails.Label.TooRepetitive",
		dontLikeGame = "Feature.GameDetails.Label.DontLikeGame",
		dontLikeImage = "Feature.GameDetails.Label.DontLikeImage",
		inappropriateContent = "Feature.GameDetails.Label.InappropriateContent",
		somethingElse = "Feature.GameDetails.Label.SomethingElse",
		reportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else "Feature.GameDetails.Action.ReportAd"
	})
	local v70 = t1.collectionId or ""
	local menuKey = t1.menuKey
	local vector2 = Vector2.new(1, 0)
	local uDim2 = UDim2.new(1, if not v60 then -v66.Padding.Small else -v66.Padding.Medium, 0, if not v60 then v66.Padding.Small else v66.Padding.Medium)
	local v74 = getOverflowMenuSignalStore()
	local v75 = nil

	if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
		v75 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef)
	end

	local v76 = React.useMemo(function() -- line: 128
		-- upvalues: UserSignalTypes (copy), v69 (copy)
		return {
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = v69.tooRepetitive
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = v69.dontLikeGame
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = v69.dontLikeImage
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = v69.inappropriateContent
			},
			{
				triggersOtherTextbox = true,
				id = UserSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = v69.somethingElse
			}
		}
	end, { v69 })
	local v77 = React.useCallback(function(t2: {[any]: any}, s1: string) -- line: 155
		-- upvalues: v76 (copy), UserSignalTypes (copy), v65 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), t1 (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), v68 (copy), HttpService (copy), v70 (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy)
		local v95 = false
		local t3 = {}

		for _, v98 in v76 do
			table.insert(t3, {
				id = v98.id,
				selected = t2[v98.id] or false
			})

			if v98.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and t2[v98.id] then
				v95 = true
			end
		end

		if v95 then
			v65(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Place,
				targetId = t1.universeId,
				onClose = function() -- line: 174
					-- upvalues: v65 (copy), CloseCentralOverlay (copy)
					v65(CloseCentralOverlay())
				end
			}))
		end

		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v65(SetNetworkingErrorToast())

			return
		end

		local ok, result = pcall(function() -- line: 189
			-- upvalues: PostSendUserSignal (copy), v68 (copy), HttpService (copy), UserSignalTypes (copy), s1 (copy), t3 (copy), t1 (copy), v70 (copy), v65 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v68, {
				stringValue = HttpService:JSONEncode({
					formId = UserSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
					titleId = UserSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
					textResponse = s1,
					items = t3
				})
			}, {
				id = t1.universeId,
				assetType = if not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = v70,
					subIds = { v70 }
				}
			}, UserSignalTypes.SignalValueType.String, UserSignalTypes.SignalType.NotInterestedFeedback):catch(function(p1) -- line: 208
				-- upvalues: v65 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				v65(SetNetworkingErrorToast(p1))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not ok then
			mutedError(result)
		end

		if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormSubmitted",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v70
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end
	end, {
		v68,
		v76,
		v69,
		t1.universeId,
		t1.appPage,
		v70,
		v65,
		t1.isSponsored
	})
	local u78 = nil
	local u79 = nil

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		u78 = React.useCallback(function(b1: boolean?) -- line: 245
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v70 (copy)
			if b1 then
				return
			end

			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormClosedWithoutSubmit",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v70
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v70
		})
		u79 = React.useCallback(function() -- line: 259
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v70 (copy)
			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormOpened",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v70
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v70
		})
	end

	local v80 = React.useMemo(function() -- line: 269
		-- upvalues: v69 (copy), v76 (copy), v77 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u78 (ref), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy)
		return {
			dialogTitle = v69.dialogTitle,
			dialogText = v69.dialogText,
			checkboxListTitle = v69.checkboxListTitle,
			checkboxItems = v76,
			onSubmit = v77,
			onClose = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u78,
			showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
		}
	end, {
		v69,
		v76,
		v77
	})
	local t4 = {}

	for v82, _ in t1.availableMenuItems do
		table.insert(t4, v82)
	end

	local v84 = table.concat(t4, ",")
	local v85 = React.useCallback(function(b2: boolean) -- line: 287
		-- upvalues: t1 (copy), v84 (copy)
		if t1.onMenuOpenChanged then
			t1.onMenuOpenChanged(b2, v84)
		end
	end, {
		t1.onMenuOpenChanged,
		v84
	})
	local v86 = React.useCallback(function(s2: string) -- line: 293
		-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v70 (copy), v84 (copy), gameTileOverflowMenuAction (copy)
		local t5 = {
			actionType = "GameTileOverflowMenuItemActivated",
			ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
			universeId = t1.universeId,
			sortId = v70,
			menuItem = s2,
			availableMenuItems = v84
		}

		gameTileOverflowMenuAction(t5, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
	end, {
		t1.appPage,
		t1.universeId,
		v70,
		v84
	})

	if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
		v75 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef, v85)
	end

	local v87 = React.useCallback(function() -- line: 315
		-- upvalues: t1 (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), v65 (copy), SetNetworkingErrorToast (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v80 (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u79 (ref), PostSendUserSignal (copy), v68 (copy), UserSignalTypes (copy), v70 (copy), mutedError (copy), v86 (copy), TileOverflowMenuItems (copy)
		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v65(SetNetworkingErrorToast())

			return
		end

		t1.setGameHidden(t1.universeId, true)
		v65(SetCentralOverlay(CentralOverlayType.ProvideFeedbackToast, {
			feedbackFormProps = v80,
			toastIcon = if not FFlagLuaAppUseSnackbarForProvideFeedbackToast then Images["icons/actions/edit/remove"] else Enums.IconName.CircleMinus,
			onToastActivated = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u79
		}))

		local ok, result = pcall(function() -- line: 334
			-- upvalues: PostSendUserSignal (copy), v68 (copy), t1 (copy), UserSignalTypes (copy), v70 (copy), v65 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v68, {
				boolValue = true
			}, {
				id = t1.universeId,
				assetType = if not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = v70,
					subIds = { v70 }
				}
			}, UserSignalTypes.SignalValueType.Bool, UserSignalTypes.SignalType.NotInterested):catch(function(p2) -- line: 348
				-- upvalues: t1 (copy), v65 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				t1.setGameHidden(t1.universeId, false)
				v65(SetNetworkingErrorToast(p2))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not ok then
			t1.setGameHidden(t1.universeId, false)
			mutedError(result)
		end

		v86(TileOverflowMenuItems.NotInterested)
	end, {
		v68,
		t1.setGameHidden,
		v65,
		v80,
		t1.universeId,
		v70,
		t1.appPage,
		v86,
		t1.isSponsored
	})
	local v88 = React.useCallback(function() -- line: 380
		-- upvalues: v65 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t1 (copy), v86 (copy), TileOverflowMenuItems (copy)
		v65(SetCentralOverlay(CentralOverlayType.WhyThisAdModal, {
			universeId = t1.universeId,
			payerName = t1.payerName,
			sponsoredUserCohort = t1.sponsoredUserCohort
		}))
		v86(TileOverflowMenuItems.WhyThisAd)
	end, {
		v65,
		t1.universeId,
		t1.payerName,
		t1.sponsoredUserCohort,
		v86
	})
	local v89 = if not FFlagLuaAppEnableSponsoredReportAd then nil else React.useCallback(function() -- line: 400
		-- upvalues: t1 (copy), flaggedMutedError (copy), v65 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), v86 (copy), TileOverflowMenuItems (copy)
		if not t1.adId then
			flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")

			return
		end

		v65(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.AdV2,
			targetId = t1.adId,
			onClose = function() -- line: 409
				-- upvalues: v65 (copy), CloseCentralOverlay (copy)
				v65(CloseCentralOverlay())
			end
		}))
		v86(TileOverflowMenuItems.ReportAd)
	end, {
		v65,
		t1.adId,
		v86
	})
	local v90 = React.useMemo(function() -- line: 425
		-- upvalues: t1 (copy), TileOverflowMenuItems (copy), v69 (copy), v87 (copy), v88 (copy), FFlagLuaAppEnableSponsoredReportAd (copy), IconName (copy), v89 (copy)
		local t6 = {}

		if t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
			table.insert(t6, {
				icon = "icons/actions/block",
				id = TileOverflowMenuItems.NotInterested,
				text = v69.notInterested,
				onActivated = v87
			})
		end

		if t1.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
			table.insert(t6, {
				icon = "icons/actions/info",
				id = TileOverflowMenuItems.WhyThisAd,
				text = v69.whyThisAd,
				onActivated = v88
			})
		end

		if FFlagLuaAppEnableSponsoredReportAd and t1.availableMenuItems[TileOverflowMenuItems.ReportAd] then
			table.insert(t6, {
				icon = IconName.Flag,
				id = TileOverflowMenuItems.ReportAd,
				text = v69.reportAd,
				onActivated = v89
			})
		end

		return t6
	end, {
		v87,
		v69,
		v88,
		t1.isSponsored,
		t1.availableMenuItems
	})
	local u91 = if not FFlagSignalsNavP3fGameDetails then useSelector(function(p3) -- line: 470
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
		if FFlagUseNavigationSelectors then
			return Selectors.selectCurrentRoactNavigationRoute(p3).key or ""
		end

		return p3.Navigation.currentRoute.key or ""
	end) else useSignalState(v55(false).getCurrentRouteKey)
	local v92 = React.useRef(u91)

	React.useEffect(function() -- line: 479
		-- upvalues: u91 (ref), v92 (copy), v74 (copy), menuKey (copy)
		if u91 ~= v92.current then
			v74.closeMenu(menuKey)
		end
	end, {
		u91,
		menuKey
	})
	React.useEffect(function() -- line: 485
		-- upvalues: t1 (copy), UserInputService (copy), v74 (copy), menuKey (copy)
		local connection = nil

		if t1.menuOpen then
			connection = UserInputService.InputBegan:Connect(function(input, _: boolean) -- line: 488
				-- upvalues: t1 (copy), v74 (copy), menuKey (copy)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not t1.isHovered then
					v74.closeMenu(menuKey)
				end
			end)
		end

		return function() -- line: 496
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		t1.menuOpen,
		t1.isHovered,
		menuKey
	})

	return React.createElement(OverflowMenu, {
		anchorPoint = vector2,
		anchorPosition = uDim2,
		menuItems = v90,
		hasOverflowButton = v67 == Responsive.Input.Pointer,
		shouldShowAnchor = t1.isHovered,
		buttonIconBackgroundStyle = v66.Color.OverMedia.OverMedia_0,
		menuKey = menuKey,
		setFocusRef = v75,
		onMenuOpenChanged = v85,
		buttonIconSize = if not v60 then nil else IconSize.Small
	})
end

return React.memo(GameTileOverflowMenu)
