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
local v56 = game:DefineFastFlag("LuaAppMitigatePopoverPressedOutsideBug", false)
local FFlagLuaAppGameTileOverflowMenuTelemetry = SharedFlags.FFlagLuaAppGameTileOverflowMenuTelemetry
local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local FFlagLuaAppFixExplicitFeedbackTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackTelemetry
local FFlagLuaAppEnableWhyThisAdModal = SharedFlags.FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppEnableSponsoredReportAd = SharedFlags.FFlagLuaAppEnableSponsoredReportAd
local v63 = game:DefineFastFlag("LuaAppAdjustOverflowMenuVisual", false)
local FFlagLuaAppSupportSponsoredExplicitFeedback = SharedFlags.FFlagLuaAppSupportSponsoredExplicitFeedback
local FFlagLuaAppUseSnackbarForProvideFeedbackToast = SharedFlags.FFlagLuaAppUseSnackbarForProvideFeedbackToast
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry

local function GameTileOverflowMenu(t1: {[any]: any}) -- line: 97
	-- upvalues: useDispatch (copy), useTokens (copy), useLastInput (copy), useRoactService (copy), RoactNetworking (copy), useLocalization (copy), FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppEnableSponsoredReportAd (copy), v63 (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), useGameTileOverflowMenuFocusNavigation (copy), React (copy), UserSignalTypes (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), HttpService (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), gameTileOverflowMenuAction (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), TileOverflowMenuItems (copy), flaggedMutedError (copy), IconName (copy), FFlagSignalsNavP3hMisc (copy), v55 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), v56 (copy), UserInputService (copy), OverflowMenu (copy), Responsive (copy), IconSize (copy)
	local v69 = useDispatch()
	local v70 = useTokens()
	local v71 = useLastInput()
	local v72 = useRoactService(RoactNetworking)
	local v73 = useLocalization({
		notInterested = "Feature.GameDetails.Action.NotInterested",
		dialogTitle = "Feature.GameDetails.Label.ProvideFeedbackTitle",
		dialogText = "Feature.GameDetails.Message.HelpImproveExperience",
		checkboxListTitle = "Feature.GameDetails.Message.HidingExperienceQuestion",
		tooRepetitive = "Feature.GameDetails.Label.TooRepetitive",
		dontLikeGame = "Feature.GameDetails.Label.DontLikeGame",
		dontLikeImage = "Feature.GameDetails.Label.DontLikeImage",
		inappropriateContent = "Feature.GameDetails.Label.InappropriateContent",
		somethingElse = "Feature.GameDetails.Label.SomethingElse",
		whyThisAd = if not FFlagLuaAppEnableWhyThisAdModal then nil else "Feature.GameDetails.Action.WhyThisAd",
		reportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else "Feature.GameDetails.Action.ReportAd"
	})
	local v74 = t1.collectionId or ""
	local menuKey = t1.menuKey
	local vector2 = Vector2.new(1, 0)
	local uDim2 = UDim2.new(1, if not v63 then -v70.Padding.Small else -v70.Padding.Medium, 0, if not v63 then v70.Padding.Small else v70.Padding.Medium)
	local v78 = getOverflowMenuSignalStore()
	local v79 = nil

	if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
		v79 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef)
	end

	local v80 = React.useMemo(function() -- line: 132
		-- upvalues: UserSignalTypes (copy), v73 (copy)
		return {
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = v73.tooRepetitive
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = v73.dontLikeGame
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = v73.dontLikeImage
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = v73.inappropriateContent
			},
			{
				triggersOtherTextbox = true,
				id = UserSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = v73.somethingElse
			}
		}
	end, { v73 })
	local v81 = React.useCallback(function(t2: {[any]: any}, s1: string) -- line: 159
		-- upvalues: v80 (copy), UserSignalTypes (copy), v69 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), t1 (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), v72 (copy), HttpService (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), v74 (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy)
		local v100 = false
		local t3 = {}

		for _, v103 in v80 do
			table.insert(t3, {
				id = v103.id,
				selected = t2[v103.id] or false
			})

			if v103.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and t2[v103.id] then
				v100 = true
			end
		end

		if v100 then
			v69(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Place,
				targetId = t1.universeId,
				onClose = function() -- line: 178
					-- upvalues: v69 (copy), CloseCentralOverlay (copy)
					v69(CloseCentralOverlay())
				end
			}))
		end

		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v69(SetNetworkingErrorToast())

			return
		end

		local ok, result = pcall(function() -- line: 193
			-- upvalues: PostSendUserSignal (copy), v72 (copy), HttpService (copy), UserSignalTypes (copy), s1 (copy), t3 (copy), t1 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), v74 (copy), v69 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v72, {
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
					topicId = v74,
					subIds = { v74 }
				}
			}, UserSignalTypes.SignalValueType.String, UserSignalTypes.SignalType.NotInterestedFeedback):catch(function(p1) -- line: 212
				-- upvalues: v69 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				v69(SetNetworkingErrorToast(p1))
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
				sortId = v74
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end
	end, {
		v72,
		v80,
		v73,
		t1.universeId,
		t1.appPage,
		v74,
		v69,
		if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.isSponsored
	})
	local u82 = nil
	local u83 = nil

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		u82 = React.useCallback(function(b1: boolean?) -- line: 249
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v74 (copy)
			if b1 then
				return
			end

			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormClosedWithoutSubmit",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v74
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v74
		})
		u83 = React.useCallback(function() -- line: 263
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v74 (copy)
			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormOpened",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v74
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v74
		})
	end

	local v84 = React.useMemo(function() -- line: 273
		-- upvalues: v73 (copy), v80 (copy), v81 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u82 (ref), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy)
		return {
			dialogTitle = v73.dialogTitle,
			dialogText = v73.dialogText,
			checkboxListTitle = v73.checkboxListTitle,
			checkboxItems = v80,
			onSubmit = v81,
			onClose = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u82,
			showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
		}
	end, {
		v73,
		v80,
		v81
	})
	local v85 = nil
	local u86 = nil

	if FFlagLuaAppGameTileOverflowMenuTelemetry then
		local u90

		if FFlagLuaAppEnableWhyThisAdModal then
			local t4 = {}

			for v88, _ in t1.availableMenuItems do
				table.insert(t4, v88)
			end

			u90 = table.concat(t4, ",")
		else
			u90 = "NotInterested"
		end

		v85 = React.useCallback(function(b2: boolean) -- line: 298
			-- upvalues: t1 (copy), u90 (ref)
			if t1.onMenuOpenChanged then
				t1.onMenuOpenChanged(b2, u90)
			end
		end, {
			t1.onMenuOpenChanged,
			u90
		})
		u86 = React.useCallback(function(s2: string) -- line: 304
			-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v74 (copy), u90 (ref), gameTileOverflowMenuAction (copy)
			local t5 = {
				actionType = "GameTileOverflowMenuItemActivated",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v74,
				menuItem = s2,
				availableMenuItems = u90
			}

			gameTileOverflowMenuAction(t5, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v74,
			u90
		})

		if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v79 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef, v85)
		end
	end

	local v91 = React.useCallback(function() -- line: 327
		-- upvalues: t1 (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), v69 (copy), SetNetworkingErrorToast (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v84 (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u83 (ref), PostSendUserSignal (copy), v72 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), UserSignalTypes (copy), v74 (copy), mutedError (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u86 (ref), TileOverflowMenuItems (copy)
		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v69(SetNetworkingErrorToast())

			return
		end

		t1.setGameHidden(t1.universeId, true)
		v69(SetCentralOverlay(CentralOverlayType.ProvideFeedbackToast, {
			feedbackFormProps = v84,
			toastIcon = if not FFlagLuaAppUseSnackbarForProvideFeedbackToast then Images["icons/actions/edit/remove"] else Enums.IconName.CircleMinus,
			onToastActivated = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u83
		}))

		local ok, result = pcall(function() -- line: 346
			-- upvalues: PostSendUserSignal (copy), v72 (copy), t1 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), UserSignalTypes (copy), v74 (copy), v69 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v72, {
				boolValue = true
			}, {
				id = t1.universeId,
				assetType = if not FFlagLuaAppSupportSponsoredExplicitFeedback or not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = v74,
					subIds = { v74 }
				}
			}, UserSignalTypes.SignalValueType.Bool, UserSignalTypes.SignalType.NotInterested):catch(function(p2) -- line: 360
				-- upvalues: t1 (copy), v69 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				t1.setGameHidden(t1.universeId, false)
				v69(SetNetworkingErrorToast(p2))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not ok then
			t1.setGameHidden(t1.universeId, false)
			mutedError(result)
		end

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u86(TileOverflowMenuItems.NotInterested)
		end
	end, {
		v72,
		t1.setGameHidden,
		v69,
		v84,
		t1.universeId,
		v74,
		t1.appPage,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u86,
		if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.isSponsored
	})
	local v92 = if not FFlagLuaAppEnableWhyThisAdModal then nil else React.useCallback(function() -- line: 395
		-- upvalues: v69 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t1 (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u86 (ref), TileOverflowMenuItems (copy)
		v69(SetCentralOverlay(CentralOverlayType.WhyThisAdModal, {
			universeId = t1.universeId,
			payerName = t1.payerName,
			sponsoredUserCohort = t1.sponsoredUserCohort
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u86(TileOverflowMenuItems.WhyThisAd)
		end
	end, {
		v69,
		t1.universeId,
		t1.payerName,
		t1.sponsoredUserCohort,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u86
	})
	local v93 = if not FFlagLuaAppEnableSponsoredReportAd then nil else React.useCallback(function() -- line: 418
		-- upvalues: t1 (copy), flaggedMutedError (copy), v69 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u86 (ref), TileOverflowMenuItems (copy)
		if not t1.adId then
			flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")

			return
		end

		v69(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.AdV2,
			targetId = t1.adId,
			onClose = function() -- line: 427
				-- upvalues: v69 (copy), CloseCentralOverlay (copy)
				v69(CloseCentralOverlay())
			end
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u86(TileOverflowMenuItems.ReportAd)
		end
	end, {
		v69,
		t1.adId,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u86
	})
	local v94 = React.useMemo(function() -- line: 445
		-- upvalues: FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), t1 (copy), TileOverflowMenuItems (copy), v73 (copy), v91 (copy), v92 (copy), FFlagLuaAppEnableSponsoredReportAd (copy), IconName (copy), v93 (copy)
		if FFlagLuaAppEnableWhyThisAdModal then
			local t6 = {}

			if FFlagLuaAppSupportSponsoredExplicitFeedback and t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
				table.insert(t6, {
					icon = "icons/actions/block",
					id = TileOverflowMenuItems.NotInterested,
					text = v73.notInterested,
					onActivated = v91
				})
			end

			if t1.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
				table.insert(t6, {
					icon = "icons/actions/info",
					id = TileOverflowMenuItems.WhyThisAd,
					text = v73.whyThisAd,
					onActivated = v92
				})
			end

			if FFlagLuaAppEnableSponsoredReportAd and t1.availableMenuItems[TileOverflowMenuItems.ReportAd] then
				table.insert(t6, {
					icon = IconName.Flag,
					id = TileOverflowMenuItems.ReportAd,
					text = v73.reportAd,
					onActivated = v93
				})
			end

			if not FFlagLuaAppSupportSponsoredExplicitFeedback and t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
				table.insert(t6, {
					icon = "icons/actions/block",
					id = TileOverflowMenuItems.NotInterested,
					text = v73.notInterested,
					onActivated = v91
				})
			end

			return t6
		end

		return {{
			icon = "icons/actions/block",
			id = TileOverflowMenuItems.NotInterested,
			text = v73.notInterested,
			onActivated = v91
		}}
	end, {
		v91,
		v73,
		if not FFlagLuaAppEnableWhyThisAdModal then nil else v92,
		if not FFlagLuaAppEnableWhyThisAdModal then nil else t1.isSponsored,
		t1.availableMenuItems
	})
	local u96

	if FFlagSignalsNavP3hMisc then
		local v95 = v55(false)

		u96 = useSignalState(v95.getCurrentRoute).key or ""
	else
		u96 = useSelector(function(p3) -- line: 518
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return Selectors.selectCurrentRoactNavigationRoute(p3).key or ""
			end

			return p3.Navigation.currentRoute.key or ""
		end)
	end

	local v97 = React.useRef(u96)

	React.useEffect(function() -- line: 527
		-- upvalues: u96 (ref), v97 (copy), v78 (copy), menuKey (copy)
		if u96 ~= v97.current then
			v78.closeMenu(menuKey)
		end
	end, {
		u96,
		menuKey
	})

	if v56 then
		React.useEffect(function() -- line: 534
			-- upvalues: t1 (copy), UserInputService (copy), v78 (copy), menuKey (copy)
			local connection = nil

			if t1.menuOpen then
				connection = UserInputService.InputBegan:Connect(function(input, _: boolean) -- line: 538
					-- upvalues: t1 (copy), v78 (copy), menuKey (copy)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and not t1.isHovered then
						v78.closeMenu(menuKey)
					end
				end)
			end

			return function() -- line: 547
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
	end

	return React.createElement(OverflowMenu, {
		anchorPoint = vector2,
		anchorPosition = uDim2,
		menuItems = v94,
		hasOverflowButton = v71 == Responsive.Input.Pointer,
		shouldShowAnchor = t1.isHovered,
		buttonIconBackgroundStyle = v70.Color.OverMedia.OverMedia_0,
		menuKey = menuKey,
		setFocusRef = v79,
		onMenuOpenChanged = if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else v85,
		buttonIconSize = if not v63 then nil else IconSize.Small
	})
end

return React.memo(GameTileOverflowMenu)
