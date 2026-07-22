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
local FFlagLuaAppSupportSponsoredExplicitFeedback = SharedFlags.FFlagLuaAppSupportSponsoredExplicitFeedback
local FFlagLuaAppUseSnackbarForProvideFeedbackToast = SharedFlags.FFlagLuaAppUseSnackbarForProvideFeedbackToast
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry

local function GameTileOverflowMenu(t1: {[any]: any}) -- line: 95
	-- upvalues: useDispatch (copy), useTokens (copy), useLastInput (copy), useRoactService (copy), RoactNetworking (copy), useLocalization (copy), FFlagLuaAppEnableSponsoredReportAd (copy), v61 (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), useGameTileOverflowMenuFocusNavigation (copy), React (copy), UserSignalTypes (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), HttpService (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), gameTileOverflowMenuAction (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), TileOverflowMenuItems (copy), flaggedMutedError (copy), IconName (copy), FFlagSignalsNavP3hMisc (copy), v55 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), UserInputService (copy), OverflowMenu (copy), Responsive (copy), IconSize (copy)
	local v67 = useDispatch()
	local v68 = useTokens()
	local v69 = useLastInput()
	local v70 = useRoactService(RoactNetworking)
	local v71 = useLocalization({
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
	local v72 = t1.collectionId or ""
	local menuKey = t1.menuKey
	local vector2 = Vector2.new(1, 0)
	local uDim2 = UDim2.new(1, if not v61 then -v68.Padding.Small else -v68.Padding.Medium, 0, if not v61 then v68.Padding.Small else v68.Padding.Medium)
	local v76 = getOverflowMenuSignalStore()
	local v77 = nil

	if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
		v77 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef)
	end

	local v78 = React.useMemo(function() -- line: 130
		-- upvalues: UserSignalTypes (copy), v71 (copy)
		return {
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = v71.tooRepetitive
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = v71.dontLikeGame
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = v71.dontLikeImage
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = v71.inappropriateContent
			},
			{
				triggersOtherTextbox = true,
				id = UserSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = v71.somethingElse
			}
		}
	end, { v71 })
	local v79 = React.useCallback(function(t2: {[any]: any}, s1: string) -- line: 157
		-- upvalues: v78 (copy), UserSignalTypes (copy), v67 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), t1 (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), v70 (copy), HttpService (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), v72 (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy)
		local v98 = false
		local t3 = {}

		for _, v101 in v78 do
			table.insert(t3, {
				id = v101.id,
				selected = t2[v101.id] or false
			})

			if v101.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and t2[v101.id] then
				v98 = true
			end
		end

		if v98 then
			v67(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Place,
				targetId = t1.universeId,
				onClose = function() -- line: 176
					-- upvalues: v67 (copy), CloseCentralOverlay (copy)
					v67(CloseCentralOverlay())
				end
			}))
		end

		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v67(SetNetworkingErrorToast())

			return
		end

		local ok, result = pcall(function() -- line: 191
			-- upvalues: PostSendUserSignal (copy), v70 (copy), HttpService (copy), UserSignalTypes (copy), s1 (copy), t3 (copy), t1 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), v72 (copy), v67 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v70, {
				stringValue = HttpService:JSONEncode({
					formId = UserSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
					titleId = UserSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
					textResponse = s1,
					items = t3
				})
			}, {
				id = t1.universeId,
				assetType = if not FFlagLuaAppSupportSponsoredExplicitFeedback or not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = v72,
					subIds = { v72 }
				}
			}, UserSignalTypes.SignalValueType.String, UserSignalTypes.SignalType.NotInterestedFeedback):catch(function(p1) -- line: 210
				-- upvalues: v67 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				v67(SetNetworkingErrorToast(p1))
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
				sortId = v72
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end
	end, {
		v70,
		v78,
		v71,
		t1.universeId,
		t1.appPage,
		v72,
		v67,
		if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.isSponsored
	})
	local u80 = nil
	local u81 = nil

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		u80 = React.useCallback(function(b1: boolean?) -- line: 247
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v72 (copy)
			if b1 then
				return
			end

			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormClosedWithoutSubmit",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v72
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v72
		})
		u81 = React.useCallback(function() -- line: 261
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v72 (copy)
			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormOpened",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v72
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v72
		})
	end

	local v82 = React.useMemo(function() -- line: 271
		-- upvalues: v71 (copy), v78 (copy), v79 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u80 (ref), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy)
		return {
			dialogTitle = v71.dialogTitle,
			dialogText = v71.dialogText,
			checkboxListTitle = v71.checkboxListTitle,
			checkboxItems = v78,
			onSubmit = v79,
			onClose = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u80,
			showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
		}
	end, {
		v71,
		v78,
		v79
	})
	local v83 = nil
	local u84 = nil

	if FFlagLuaAppGameTileOverflowMenuTelemetry then
		local t4 = {}

		for v86, _ in t1.availableMenuItems do
			table.insert(t4, v86)
		end

		local v88 = table.concat(t4, ",")

		v83 = React.useCallback(function(b2: boolean) -- line: 291
			-- upvalues: t1 (copy), v88 (copy)
			if t1.onMenuOpenChanged then
				t1.onMenuOpenChanged(b2, v88)
			end
		end, {
			t1.onMenuOpenChanged,
			v88
		})
		u84 = React.useCallback(function(s2: string) -- line: 297
			-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v72 (copy), v88 (copy), gameTileOverflowMenuAction (copy)
			local t5 = {
				actionType = "GameTileOverflowMenuItemActivated",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v72,
				menuItem = s2,
				availableMenuItems = v88
			}

			gameTileOverflowMenuAction(t5, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v72,
			v88
		})

		if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v77 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef, v83)
		end
	end

	local v89 = React.useCallback(function() -- line: 320
		-- upvalues: t1 (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), v67 (copy), SetNetworkingErrorToast (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v82 (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u81 (ref), PostSendUserSignal (copy), v70 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), UserSignalTypes (copy), v72 (copy), mutedError (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u84 (ref), TileOverflowMenuItems (copy)
		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v67(SetNetworkingErrorToast())

			return
		end

		t1.setGameHidden(t1.universeId, true)
		v67(SetCentralOverlay(CentralOverlayType.ProvideFeedbackToast, {
			feedbackFormProps = v82,
			toastIcon = if not FFlagLuaAppUseSnackbarForProvideFeedbackToast then Images["icons/actions/edit/remove"] else Enums.IconName.CircleMinus,
			onToastActivated = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u81
		}))

		local ok, result = pcall(function() -- line: 339
			-- upvalues: PostSendUserSignal (copy), v70 (copy), t1 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), UserSignalTypes (copy), v72 (copy), v67 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v70, {
				boolValue = true
			}, {
				id = t1.universeId,
				assetType = if not FFlagLuaAppSupportSponsoredExplicitFeedback or not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = v72,
					subIds = { v72 }
				}
			}, UserSignalTypes.SignalValueType.Bool, UserSignalTypes.SignalType.NotInterested):catch(function(p2) -- line: 353
				-- upvalues: t1 (copy), v67 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				t1.setGameHidden(t1.universeId, false)
				v67(SetNetworkingErrorToast(p2))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not ok then
			t1.setGameHidden(t1.universeId, false)
			mutedError(result)
		end

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u84(TileOverflowMenuItems.NotInterested)
		end
	end, {
		v70,
		t1.setGameHidden,
		v67,
		v82,
		t1.universeId,
		v72,
		t1.appPage,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u84,
		if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.isSponsored
	})
	local v90 = React.useCallback(function() -- line: 387
		-- upvalues: v67 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t1 (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u84 (ref), TileOverflowMenuItems (copy)
		v67(SetCentralOverlay(CentralOverlayType.WhyThisAdModal, {
			universeId = t1.universeId,
			payerName = t1.payerName,
			sponsoredUserCohort = t1.sponsoredUserCohort
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u84(TileOverflowMenuItems.WhyThisAd)
		end
	end, {
		v67,
		t1.universeId,
		t1.payerName,
		t1.sponsoredUserCohort,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u84
	})
	local v91 = if not FFlagLuaAppEnableSponsoredReportAd then nil else React.useCallback(function() -- line: 409
		-- upvalues: t1 (copy), flaggedMutedError (copy), v67 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u84 (ref), TileOverflowMenuItems (copy)
		if not t1.adId then
			flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")

			return
		end

		v67(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.AdV2,
			targetId = t1.adId,
			onClose = function() -- line: 418
				-- upvalues: v67 (copy), CloseCentralOverlay (copy)
				v67(CloseCentralOverlay())
			end
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u84(TileOverflowMenuItems.ReportAd)
		end
	end, {
		v67,
		t1.adId,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u84
	})
	local v92 = React.useMemo(function() -- line: 436
		-- upvalues: FFlagLuaAppSupportSponsoredExplicitFeedback (copy), t1 (copy), TileOverflowMenuItems (copy), v71 (copy), v89 (copy), v90 (copy), FFlagLuaAppEnableSponsoredReportAd (copy), IconName (copy), v91 (copy)
		local t6 = {}

		if FFlagLuaAppSupportSponsoredExplicitFeedback and t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
			table.insert(t6, {
				icon = "icons/actions/block",
				id = TileOverflowMenuItems.NotInterested,
				text = v71.notInterested,
				onActivated = v89
			})
		end

		if t1.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
			table.insert(t6, {
				icon = "icons/actions/info",
				id = TileOverflowMenuItems.WhyThisAd,
				text = v71.whyThisAd,
				onActivated = v90
			})
		end

		if FFlagLuaAppEnableSponsoredReportAd and t1.availableMenuItems[TileOverflowMenuItems.ReportAd] then
			table.insert(t6, {
				icon = IconName.Flag,
				id = TileOverflowMenuItems.ReportAd,
				text = v71.reportAd,
				onActivated = v91
			})
		end

		if not FFlagLuaAppSupportSponsoredExplicitFeedback and t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
			table.insert(t6, {
				icon = "icons/actions/block",
				id = TileOverflowMenuItems.NotInterested,
				text = v71.notInterested,
				onActivated = v89
			})
		end

		return t6
	end, {
		v89,
		v71,
		v90,
		t1.isSponsored,
		t1.availableMenuItems
	})
	local u94

	if FFlagSignalsNavP3hMisc then
		local v93 = v55(false)

		u94 = useSignalState(v93.getCurrentRoute).key or ""
	else
		u94 = useSelector(function(p3) -- line: 498
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return Selectors.selectCurrentRoactNavigationRoute(p3).key or ""
			end

			return p3.Navigation.currentRoute.key or ""
		end)
	end

	local v95 = React.useRef(u94)

	React.useEffect(function() -- line: 507
		-- upvalues: u94 (ref), v95 (copy), v76 (copy), menuKey (copy)
		if u94 ~= v95.current then
			v76.closeMenu(menuKey)
		end
	end, {
		u94,
		menuKey
	})
	React.useEffect(function() -- line: 513
		-- upvalues: t1 (copy), UserInputService (copy), v76 (copy), menuKey (copy)
		local connection = nil

		if t1.menuOpen then
			connection = UserInputService.InputBegan:Connect(function(input, _: boolean) -- line: 516
				-- upvalues: t1 (copy), v76 (copy), menuKey (copy)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not t1.isHovered then
					v76.closeMenu(menuKey)
				end
			end)
		end

		return function() -- line: 524
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
		menuItems = v92,
		hasOverflowButton = v69 == Responsive.Input.Pointer,
		shouldShowAnchor = t1.isHovered,
		buttonIconBackgroundStyle = v68.Color.OverMedia.OverMedia_0,
		menuKey = menuKey,
		setFocusRef = v77,
		onMenuOpenChanged = if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else v83,
		buttonIconSize = if not v61 then nil else IconSize.Small
	})
end

return React.memo(GameTileOverflowMenu)
