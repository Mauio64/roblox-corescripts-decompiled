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
local FFlagLuaAppEnableWhyThisAdModal = SharedFlags.FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppEnableSponsoredReportAd = SharedFlags.FFlagLuaAppEnableSponsoredReportAd
local v62 = game:DefineFastFlag("LuaAppAdjustOverflowMenuVisual", false)
local FFlagLuaAppSupportSponsoredExplicitFeedback = SharedFlags.FFlagLuaAppSupportSponsoredExplicitFeedback
local FFlagLuaAppUseSnackbarForProvideFeedbackToast = SharedFlags.FFlagLuaAppUseSnackbarForProvideFeedbackToast
local FFlagLuaAppFixExplicitFeedbackConsoleTelemetry = SharedFlags.FFlagLuaAppFixExplicitFeedbackConsoleTelemetry

local function GameTileOverflowMenu(t1: {[any]: any}) -- line: 96
	-- upvalues: useDispatch (copy), useTokens (copy), useLastInput (copy), useRoactService (copy), RoactNetworking (copy), useLocalization (copy), FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppEnableSponsoredReportAd (copy), v62 (copy), getOverflowMenuSignalStore (copy), FFlagLuaAppFixExplicitFeedbackConsoleTelemetry (copy), useGameTileOverflowMenuFocusNavigation (copy), React (copy), UserSignalTypes (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), HttpService (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), gameTileOverflowMenuAction (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), TileOverflowMenuItems (copy), flaggedMutedError (copy), IconName (copy), FFlagSignalsNavP3hMisc (copy), v55 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), UserInputService (copy), OverflowMenu (copy), Responsive (copy), IconSize (copy)
	local v68 = useDispatch()
	local v69 = useTokens()
	local v70 = useLastInput()
	local v71 = useRoactService(RoactNetworking)
	local v72 = useLocalization({
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
	local v73 = t1.collectionId or ""
	local menuKey = t1.menuKey
	local vector2 = Vector2.new(1, 0)
	local uDim2 = UDim2.new(1, if not v62 then -v69.Padding.Small else -v69.Padding.Medium, 0, if not v62 then v69.Padding.Small else v69.Padding.Medium)
	local v77 = getOverflowMenuSignalStore()
	local v78 = nil

	if not FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
		v78 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef)
	end

	local v79 = React.useMemo(function() -- line: 131
		-- upvalues: UserSignalTypes (copy), v72 (copy)
		return {
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = v72.tooRepetitive
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = v72.dontLikeGame
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = v72.dontLikeImage
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = v72.inappropriateContent
			},
			{
				triggersOtherTextbox = true,
				id = UserSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = v72.somethingElse
			}
		}
	end, { v72 })
	local v80 = React.useCallback(function(t2: {[any]: any}, s1: string) -- line: 158
		-- upvalues: v79 (copy), UserSignalTypes (copy), v68 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), t1 (copy), CloseCentralOverlay (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), SetNetworkingErrorToast (copy), PostSendUserSignal (copy), v71 (copy), HttpService (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), v73 (copy), mutedError (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy)
		local v99 = false
		local t3 = {}

		for _, v102 in v79 do
			table.insert(t3, {
				id = v102.id,
				selected = t2[v102.id] or false
			})

			if v102.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and t2[v102.id] then
				v99 = true
			end
		end

		if v99 then
			v68(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Place,
				targetId = t1.universeId,
				onClose = function() -- line: 177
					-- upvalues: v68 (copy), CloseCentralOverlay (copy)
					v68(CloseCentralOverlay())
				end
			}))
		end

		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v68(SetNetworkingErrorToast())

			return
		end

		local ok, result = pcall(function() -- line: 192
			-- upvalues: PostSendUserSignal (copy), v71 (copy), HttpService (copy), UserSignalTypes (copy), s1 (copy), t3 (copy), t1 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), v73 (copy), v68 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v71, {
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
					topicId = v73,
					subIds = { v73 }
				}
			}, UserSignalTypes.SignalValueType.String, UserSignalTypes.SignalType.NotInterestedFeedback):catch(function(p1) -- line: 211
				-- upvalues: v68 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				v68(SetNetworkingErrorToast(p1))
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
				sortId = v73
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end
	end, {
		v71,
		v79,
		v72,
		t1.universeId,
		t1.appPage,
		v73,
		v68,
		if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.isSponsored
	})
	local u81 = nil
	local u82 = nil

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		u81 = React.useCallback(function(b1: boolean?) -- line: 248
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v73 (copy)
			if b1 then
				return
			end

			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormClosedWithoutSubmit",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v73
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v73
		})
		u82 = React.useCallback(function() -- line: 262
			-- upvalues: sendNotInterestedFeedbackFormAnalytics (copy), FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v73 (copy)
			sendNotInterestedFeedbackFormAnalytics({
				actionType = "NotInterestedFeedbackFormOpened",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v73
			}, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v73
		})
	end

	local v83 = React.useMemo(function() -- line: 272
		-- upvalues: v72 (copy), v79 (copy), v80 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u81 (ref), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy)
		return {
			dialogTitle = v72.dialogTitle,
			dialogText = v72.dialogText,
			checkboxListTitle = v72.checkboxListTitle,
			checkboxItems = v79,
			onSubmit = v80,
			onClose = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u81,
			showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
		}
	end, {
		v72,
		v79,
		v80
	})
	local v84 = nil
	local u85 = nil

	if FFlagLuaAppGameTileOverflowMenuTelemetry then
		local u89

		if FFlagLuaAppEnableWhyThisAdModal then
			local t4 = {}

			for v87, _ in t1.availableMenuItems do
				table.insert(t4, v87)
			end

			u89 = table.concat(t4, ",")
		else
			u89 = "NotInterested"
		end

		v84 = React.useCallback(function(b2: boolean) -- line: 297
			-- upvalues: t1 (copy), u89 (ref)
			if t1.onMenuOpenChanged then
				t1.onMenuOpenChanged(b2, u89)
			end
		end, {
			t1.onMenuOpenChanged,
			u89
		})
		u85 = React.useCallback(function(s2: string) -- line: 303
			-- upvalues: FFlagLuaAppFixExplicitFeedbackTelemetry (copy), t1 (copy), v73 (copy), u89 (ref), gameTileOverflowMenuAction (copy)
			local t5 = {
				actionType = "GameTileOverflowMenuItemActivated",
				ctx = if not FFlagLuaAppFixExplicitFeedbackTelemetry then t1.appPage else nil,
				universeId = t1.universeId,
				sortId = v73,
				menuItem = s2,
				availableMenuItems = u89
			}

			gameTileOverflowMenuAction(t5, if not FFlagLuaAppFixExplicitFeedbackTelemetry then nil else t1.appPage)
		end, {
			t1.appPage,
			t1.universeId,
			v73,
			u89
		})

		if FFlagLuaAppFixExplicitFeedbackConsoleTelemetry then
			v78 = useGameTileOverflowMenuFocusNavigation(menuKey, t1.isSelected, t1.parentRef, v84)
		end
	end

	local v90 = React.useCallback(function() -- line: 326
		-- upvalues: t1 (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy), v68 (copy), SetNetworkingErrorToast (copy), SetCentralOverlay (copy), CentralOverlayType (copy), v83 (copy), FFlagLuaAppUseSnackbarForProvideFeedbackToast (copy), Enums (copy), Images (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), u82 (ref), PostSendUserSignal (copy), v71 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), UserSignalTypes (copy), v73 (copy), mutedError (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u85 (ref), TileOverflowMenuItems (copy)
		if not t1.appPage then
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)
			v68(SetNetworkingErrorToast())

			return
		end

		t1.setGameHidden(t1.universeId, true)
		v68(SetCentralOverlay(CentralOverlayType.ProvideFeedbackToast, {
			feedbackFormProps = v83,
			toastIcon = if not FFlagLuaAppUseSnackbarForProvideFeedbackToast then Images["icons/actions/edit/remove"] else Enums.IconName.CircleMinus,
			onToastActivated = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else u82
		}))

		local ok, result = pcall(function() -- line: 345
			-- upvalues: PostSendUserSignal (copy), v71 (copy), t1 (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), UserSignalTypes (copy), v73 (copy), v68 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
			PostSendUserSignal(v71, {
				boolValue = true
			}, {
				id = t1.universeId,
				assetType = if not FFlagLuaAppSupportSponsoredExplicitFeedback or not t1.isSponsored then UserSignalTypes.AssetType.Game else UserSignalTypes.AssetType.SponsoredGame,
				signalOrigin = {
					productSurface = t1.appPage,
					topicId = v73,
					subIds = { v73 }
				}
			}, UserSignalTypes.SignalValueType.Bool, UserSignalTypes.SignalType.NotInterested):catch(function(p2) -- line: 359
				-- upvalues: t1 (copy), v68 (copy), SetNetworkingErrorToast (copy), default (copy), NotInterestedUserSignalTelemetryEventConfigs (copy)
				t1.setGameHidden(t1.universeId, false)
				v68(SetNetworkingErrorToast(p2))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not ok then
			t1.setGameHidden(t1.universeId, false)
			mutedError(result)
		end

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u85(TileOverflowMenuItems.NotInterested)
		end
	end, {
		v71,
		t1.setGameHidden,
		v68,
		v83,
		t1.universeId,
		v73,
		t1.appPage,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u85,
		if not FFlagLuaAppSupportSponsoredExplicitFeedback then nil else t1.isSponsored
	})
	local v91 = if not FFlagLuaAppEnableWhyThisAdModal then nil else React.useCallback(function() -- line: 394
		-- upvalues: v68 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), t1 (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u85 (ref), TileOverflowMenuItems (copy)
		v68(SetCentralOverlay(CentralOverlayType.WhyThisAdModal, {
			universeId = t1.universeId,
			payerName = t1.payerName,
			sponsoredUserCohort = t1.sponsoredUserCohort
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u85(TileOverflowMenuItems.WhyThisAd)
		end
	end, {
		v68,
		t1.universeId,
		t1.payerName,
		t1.sponsoredUserCohort,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u85
	})
	local v92 = if not FFlagLuaAppEnableSponsoredReportAd then nil else React.useCallback(function() -- line: 417
		-- upvalues: t1 (copy), flaggedMutedError (copy), v68 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), FFlagLuaAppGameTileOverflowMenuTelemetry (copy), u85 (ref), TileOverflowMenuItems (copy)
		if not t1.adId then
			flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")

			return
		end

		v68(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.AdV2,
			targetId = t1.adId,
			onClose = function() -- line: 426
				-- upvalues: v68 (copy), CloseCentralOverlay (copy)
				v68(CloseCentralOverlay())
			end
		}))

		if FFlagLuaAppGameTileOverflowMenuTelemetry then
			u85(TileOverflowMenuItems.ReportAd)
		end
	end, {
		v68,
		t1.adId,
		if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else u85
	})
	local v93 = React.useMemo(function() -- line: 444
		-- upvalues: FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppSupportSponsoredExplicitFeedback (copy), t1 (copy), TileOverflowMenuItems (copy), v72 (copy), v90 (copy), v91 (copy), FFlagLuaAppEnableSponsoredReportAd (copy), IconName (copy), v92 (copy)
		if FFlagLuaAppEnableWhyThisAdModal then
			local t6 = {}

			if FFlagLuaAppSupportSponsoredExplicitFeedback and t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
				table.insert(t6, {
					icon = "icons/actions/block",
					id = TileOverflowMenuItems.NotInterested,
					text = v72.notInterested,
					onActivated = v90
				})
			end

			if t1.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
				table.insert(t6, {
					icon = "icons/actions/info",
					id = TileOverflowMenuItems.WhyThisAd,
					text = v72.whyThisAd,
					onActivated = v91
				})
			end

			if FFlagLuaAppEnableSponsoredReportAd and t1.availableMenuItems[TileOverflowMenuItems.ReportAd] then
				table.insert(t6, {
					icon = IconName.Flag,
					id = TileOverflowMenuItems.ReportAd,
					text = v72.reportAd,
					onActivated = v92
				})
			end

			if not FFlagLuaAppSupportSponsoredExplicitFeedback and t1.availableMenuItems[TileOverflowMenuItems.NotInterested] then
				table.insert(t6, {
					icon = "icons/actions/block",
					id = TileOverflowMenuItems.NotInterested,
					text = v72.notInterested,
					onActivated = v90
				})
			end

			return t6
		end

		return {{
			icon = "icons/actions/block",
			id = TileOverflowMenuItems.NotInterested,
			text = v72.notInterested,
			onActivated = v90
		}}
	end, {
		v90,
		v72,
		if not FFlagLuaAppEnableWhyThisAdModal then nil else v91,
		if not FFlagLuaAppEnableWhyThisAdModal then nil else t1.isSponsored,
		t1.availableMenuItems
	})
	local u95

	if FFlagSignalsNavP3hMisc then
		local v94 = v55(false)

		u95 = useSignalState(v94.getCurrentRoute).key or ""
	else
		u95 = useSelector(function(p3) -- line: 517
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return Selectors.selectCurrentRoactNavigationRoute(p3).key or ""
			end

			return p3.Navigation.currentRoute.key or ""
		end)
	end

	local v96 = React.useRef(u95)

	React.useEffect(function() -- line: 526
		-- upvalues: u95 (ref), v96 (copy), v77 (copy), menuKey (copy)
		if u95 ~= v96.current then
			v77.closeMenu(menuKey)
		end
	end, {
		u95,
		menuKey
	})
	React.useEffect(function() -- line: 532
		-- upvalues: t1 (copy), UserInputService (copy), v77 (copy), menuKey (copy)
		local connection = nil

		if t1.menuOpen then
			connection = UserInputService.InputBegan:Connect(function(input, _: boolean) -- line: 535
				-- upvalues: t1 (copy), v77 (copy), menuKey (copy)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and not t1.isHovered then
					v77.closeMenu(menuKey)
				end
			end)
		end

		return function() -- line: 543
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
		menuItems = v93,
		hasOverflowButton = v70 == Responsive.Input.Pointer,
		shouldShowAnchor = t1.isHovered,
		buttonIconBackgroundStyle = v69.Color.OverMedia.OverMedia_0,
		menuKey = menuKey,
		setFocusRef = v78,
		onMenuOpenChanged = if not FFlagLuaAppGameTileOverflowMenuTelemetry then nil else v84,
		buttonIconSize = if not v62 then nil else IconSize.Small
	})
end

return React.memo(GameTileOverflowMenu)
