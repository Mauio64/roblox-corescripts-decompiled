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
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSignalState = require(GameTileParent.SignalsReact).useSignalState
local v55 = if not FFlagSignalsNavP3hMisc then nil else require(GameTileParent.NavigationRodux).GetLegacyNavigationStore
local FFlagLuaAppGameTileOverflowMenuTelemetry = SharedFlags.FFlagLuaAppGameTileOverflowMenuTelemetry
local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local FFlagLuaAppFixExplicitFeedbackTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackTelemetry
local FFlagLuaAppEnableSponsoredReportAd = SharedFlags.FFlagLuaAppEnableSponsoredReportAd
local v61 = game:DefineFastFlag("LuaAppAdjustOverflowMenuVisual", false)
local FFlagLuaAppUseSnackbarForProvideFeedbackToast = SharedFlags.FFlagLuaAppUseSnackbarForProvideFeedbackToast
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry

local function GameTileOverflowMenu(t1: {[any]: any}) -- line: 94
	-- upvalues: useDispatch (copy), useTokens (copy), useLastInput (copy), useRoactService (copy), RoactNetworking (copy), useLocalization (copy), FFlagLuaAppEnableSponsoredReportAd (copy), v61 (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), useGameTileOverflowMenuFocusNavigation (copy), React (copy), UserSignalTypes (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), HttpService (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), gameTileOverflowMenuAction (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), TileOverflowMenuItems (copy), flaggedMutedError (copy), IconName (copy), FFlagSignalsNavP3hMisc (copy), v55 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), UserInputService (copy), OverflowMenu (copy), Responsive (copy), IconSize (copy)
	local v66 = useDispatch()
	local v67 = useTokens()
	local v68 = useLastInput()
	local v69 = useRoactService(RoactNetworking)
	local v70 = useLocalization({
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
	local v71 = t1.collectionId or ""
	local menuKey = t1.menuKey
	local vector2 = Vector2.new(1, 0)
	local uDim2 = UDim2.new(1, if not v61 then -v67.Padding.Small else -v67.Padding.Medium, 0, if not v61 then v67.Padding.Small else v67.Padding.Medium)
	local v75 = getOverflowMenuSignalStore()
	local v76 = nil

	if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
		v76 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef)
	end

	local v77 = React.useMemo(function() -- line: 129
		-- upvalues: UserSignalTypes (copy), v70 (copy)
		return {
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = v70.tooRepetitive
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = v70.dontLikeGame
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = v70.dontLikeImage
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = v70.inappropriateContent
			},
			{
				triggersOtherTextbox = true,
				id = UserSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = v70.somethingElse
			}
		}
	end, { v70 })
	local v78 = React.useCallback(function(t2: {[any]: any}, s1: string) -- line: 156
		-- upvalues: v77 (copy), UserSignalTypes (copy), v66 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), t1 (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), v69 (copy), HttpService (copy), v71 (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy)
		local v97 = false
		local t3 = {}

		for _, v100 in v77 do
			table.insert(t3, {
				id = v100.id,
				selected = t2[v100.id] or false
			})

			if v100.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and t2[v100.id] then
				v97 = true
			end
		end

		if v97 then
			v66(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Place,
				targetId = t1.universeId,
				onClose = function() -- line: 175
					-- upvalues: v66 (copy), CloseCentralOverlay (copy)
					v66(CloseCentralOverlay())
				end
			}))
		end

		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v66(SetNetworkingErrorToast())

			return
		end

		local ok, result = pcall(function() -- line: 190
			-- upvalues: PostSendUserSignal (copy), v69 (copy), HttpService (copy), UserSignalTypes (copy), s1 (copy), t3 (copy), t1 (copy), v71 (copy), v66 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v69, {
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
					topicId = v71,
					subIds = { v71 }
				}
			}, UserSignalTypes.SignalValueType.String, UserSignalTypes.SignalType.NotInterestedFeedback):catch(function(p1) -- line: 209
				-- upvalues: v66 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				v66(SetNetworkingErrorToast(p1))
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
				sortId = v71
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end
	end, {
		v69,
		v77,
		v70,
		t1.universeId,
		t1.appPage,
		v71,
		v66,
		t1.isSponsored
	})
	local u79 = nil
	local u80 = nil

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		u79 = React.useCallback(function(b1: boolean?) -- line: 246
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v71 (copy)
			if b1 then
				return
			end

			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormClosedWithoutSubmit",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v71
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v71
		})
		u80 = React.useCallback(function() -- line: 260
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v71 (copy)
			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormOpened",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v71
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v71
		})
	end

	local v81 = React.useMemo(function() -- line: 270
		-- upvalues: v70 (copy), v77 (copy), v78 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u79 (ref), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy)
		return {
			dialogTitle = v70.dialogTitle,
			dialogText = v70.dialogText,
			checkboxListTitle = v70.checkboxListTitle,
			checkboxItems = v77,
			onSubmit = v78,
			onClose = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u79,
			showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
		}
	end, {
		v70,
		v77,
		v78
	})
	local v82 = nil
	local u83 = nil

	if FFlagLuaAppGameTileOverflowMenuTelemetry then
		local t4 = {}

		for v85, _ in t1.availableMenuItems do
			table.insert(t4, v85)
		end

		local v87 = table.concat(t4, ",")

		v82 = React.useCallback(function(b2: boolean) -- line: 290
			-- upvalues: t1 (copy), v87 (copy)
			if t1.onMenuOpenChanged then
				t1.onMenuOpenChanged(b2, v87)
			end
		end, {
			t1.onMenuOpenChanged,
			v87
		})
		u83 = React.useCallback(function(s2: string) -- line: 296
			-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v71 (copy), v87 (copy), gameTileOverflowMenuAction (copy)
			local t5 = {
				actionType = "GameTileOverflowMenuItemActivated",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v71,
				menuItem = s2,
				availableMenuItems = v87
			}

			gameTileOverflowMenuAction(t5, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v71,
			v87
		})

		if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v76 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef, v82)
		end
	end

	local v88 = React.useCallback(function() -- line: 319
		-- upvalues: t1 (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), v66 (copy), SetNetworkingErrorToast (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v81 (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u80 (ref), PostSendUserSignal (copy), v69 (copy), UserSignalTypes (copy), v71 (copy), mutedError (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u83 (ref), TileOverflowMenuItems (copy)
		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v66(SetNetworkingErrorToast())

			return
		end

		t1.setGameHidden(t1.universeId, true)
		v66(SetCentralOverlay(CentralOverlayType.ProvideFeedbackToast, {
			feedbackFormProps = v81,
			toastIcon = if not FFlagLuaAppUseSnackbarForProvideFeedbackToast then Images["icons/actions/edit/remove"] else Enums.IconName.CircleMinus,
			onToastActivated = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u80
		}))

		local ok, result = pcall(function() -- line: 338
			-- upvalues: PostSendUserSignal (copy), v69 (copy), t1 (copy), UserSignalTypes (copy), v71 (copy), v66 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v69, {
				boolValue = true
			}, {
				id = t1.universeId,
				assetType = if not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = v71,
					subIds = { v71 }
				}
			}, UserSignalTypes.SignalValueType.Bool, UserSignalTypes.SignalType.NotInterested):catch(function(p2) -- line: 352
				-- upvalues: t1 (copy), v66 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				t1.setGameHidden(t1.universeId, false)
				v66(SetNetworkingErrorToast(p2))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not ok then
			t1.setGameHidden(t1.universeId, false)
			mutedError(result)
		end

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u83(TileOverflowMenuItems.NotInterested)
		end
	end, {
		v69,
		t1.setGameHidden,
		v66,
		v81,
		t1.universeId,
		v71,
		t1.appPage,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u83,
		t1.isSponsored
	})
	local v89 = React.useCallback(function() -- line: 386
		-- upvalues: v66 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t1 (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u83 (ref), TileOverflowMenuItems (copy)
		v66(SetCentralOverlay(CentralOverlayType.WhyThisAdModal, {
			universeId = t1.universeId,
			payerName = t1.payerName,
			sponsoredUserCohort = t1.sponsoredUserCohort
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u83(TileOverflowMenuItems.WhyThisAd)
		end
	end, {
		v66,
		t1.universeId,
		t1.payerName,
		t1.sponsoredUserCohort,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u83
	})
	local v90 = if not FFlagLuaAppEnableSponsoredReportAd then nil else React.useCallback(function() -- line: 408
		-- upvalues: t1 (copy), flaggedMutedError (copy), v66 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u83 (ref), TileOverflowMenuItems (copy)
		if not t1.adId then
			flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")

			return
		end

		v66(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.AdV2,
			targetId = t1.adId,
			onClose = function() -- line: 417
				-- upvalues: v66 (copy), CloseCentralOverlay (copy)
				v66(CloseCentralOverlay())
			end
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u83(TileOverflowMenuItems.ReportAd)
		end
	end, {
		v66,
		t1.adId,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u83
	})
	local v91 = React.useMemo(function() -- line: 435
		-- upvalues: t1 (copy), TileOverflowMenuItems (copy), v70 (copy), v88 (copy), v89 (copy), FFlagLuaAppEnableSponsoredReportAd (copy), IconName (copy), v90 (copy)
		local t6 = {}

		if t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
			table.insert(t6, {
				icon = "icons/actions/block",
				id = TileOverflowMenuItems.NotInterested,
				text = v70.notInterested,
				onActivated = v88
			})
		end

		if t1.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
			table.insert(t6, {
				icon = "icons/actions/info",
				id = TileOverflowMenuItems.WhyThisAd,
				text = v70.whyThisAd,
				onActivated = v89
			})
		end

		if FFlagLuaAppEnableSponsoredReportAd and t1.availableMenuItems[TileOverflowMenuItems.ReportAd] then
			table.insert(t6, {
				icon = IconName.Flag,
				id = TileOverflowMenuItems.ReportAd,
				text = v70.reportAd,
				onActivated = v90
			})
		end

		return t6
	end, {
		v88,
		v70,
		v89,
		t1.isSponsored,
		t1.availableMenuItems
	})
	local u93

	if FFlagSignalsNavP3hMisc then
		local v92 = v55(false)

		u93 = useSignalState(v92.getCurrentRoute).key or ""
	else
		u93 = useSelector(function(p3) -- line: 482
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return Selectors.selectCurrentRoactNavigationRoute(p3).key or ""
			end

			return p3.Navigation.currentRoute.key or ""
		end)
	end

	local v94 = React.useRef(u93)

	React.useEffect(function() -- line: 491
		-- upvalues: u93 (ref), v94 (copy), v75 (copy), menuKey (copy)
		if u93 ~= v94.current then
			v75.closeMenu(menuKey)
		end
	end, {
		u93,
		menuKey
	})
	React.useEffect(function() -- line: 497
		-- upvalues: t1 (copy), UserInputService (copy), v75 (copy), menuKey (copy)
		local connection = nil

		if t1.menuOpen then
			connection = UserInputService.InputBegan:Connect(function(input, _: boolean) -- line: 500
				-- upvalues: t1 (copy), v75 (copy), menuKey (copy)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not t1.isHovered then
					v75.closeMenu(menuKey)
				end
			end)
		end

		return function() -- line: 508
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
		menuItems = v91,
		hasOverflowButton = v68 == Responsive.Input.Pointer,
		shouldShowAnchor = t1.isHovered,
		buttonIconBackgroundStyle = v67.Color.OverMedia.OverMedia_0,
		menuKey = menuKey,
		setFocusRef = v76,
		onMenuOpenChanged = if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else v82,
		buttonIconSize = if not v61 then nil else IconSize.Small
	})
end

return React.memo(GameTileOverflowMenu)
