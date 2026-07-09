local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local PeekViewWithTopBar = require(CorePackages.Workspace.Packages.PeekView).PeekViewWithTopBar
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local peekViewDismissedEvent = require(CorePackages.Workspace.Packages.PeekView).analytics.peekViewDismissedEvent
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local EnumGameDetailErrorTypes = DiscoveryTypes.EnumGameDetailErrorTypes
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local SetTabBarVisible = require(CorePackages.Workspace.Packages.AppTabBarRodux).Actions.SetTabBarVisible
local gameDetailsPeekViewEvents = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Events.gameDetailsPeekViewEvents
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.LuaApp.Constants)
local SetGameDetailsPeekViewState = require(Modules.LuaApp.Actions.Games.SetGameDetailsPeekViewState)
local GameDetailsTopBar = require(Modules.LuaApp.Components.GameDetails.GameDetailsTopBar)
local ActionBar = require(Modules.LuaApp.Components.GameDetails.ActionBar)
local GameDetailsCard = require(Modules.LuaApp.Components.GameDetails.GameDetailsCard)
local ExperienceDetailsExperimentation = require(Modules.LuaApp.Components.ExperienceDetails.ExperienceDetailsExperimentation)
local useEdpPerUniverseVisibilityVariablesForUniverse = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useEdpPerUniverseVisibilityVariablesForUniverse)
local AgeCheckUpsellRenderedData = require(CorePackages.Workspace.Packages.GameDetail).AgeCheckUpsellRenderedData
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local v34 = game:DefineFastFlag("EnableGameDetailsFullViewIXP", false)
local v35 = game:DefineFastFlag("ForceEnableGameDetailsFullView", false)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local v37 = game:DefineFastFlag("SduiSocialProofRaisePeekViewBriefHeightIxp", false)
local v38 = game:DefineFastFlag("SduiSocialProofRaisePeekViewBriefHeightDefault", false)
local FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight
local FFlagLuaAppExpandableTextImpressionsEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExpandableTextImpressionsEnabled
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3fGameDetails
local FFlagUseSignalsForSearchBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseSignalsForSearchBar
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v45 = if not FFlagSignalsNavP3fGameDetails then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local GetSearchBarStore = require(CorePackages.Workspace.Packages.SearchBarStore).GetSearchBarStore
local FFlagEnablePlayWithRewardComponent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlayWithRewardComponent
local FFlagLuaAppEdpPeekViewReserveBottomDockHeight = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpPeekViewReserveBottomDockHeight
local FFlagLuaAppEdpHideSystemBarOnPeekViewMount = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpHideSystemBarOnPeekViewMount
local FFlagLuaAppExtendPlayWithRewardPeekView = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppExtendPlayWithRewardPeekView
local GAME_DETAILS_ACTION_BAR_HEIGHT = DiscoveryTypes.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT
local v52 = game:DefineFastInt("SduiAgeCheckUpsellRowHeight", 70)
local u53 = nil

if FFlagLuaAppEdpPeekViewReserveBottomDockHeight then
	u53 = GAME_DETAILS_ACTION_BAR_HEIGHT + 40 + 10
end

local function getInnerPaddingSize(p1) -- line: 85
	if p1 < 600 then
		return 20
	end

	return 40
end

local v55 = Roact.PureComponent:extend("GameDetailsPeekView")

function v55.init(p2) -- line: 91
	-- upvalues: Roact (copy), peekViewDismissedEvent (copy), AppPage (copy), SessionType (copy), PeekViewState (copy), gameDetailsPeekViewEvents (copy)
	p2.state = {
		topBarOpacity = 0
	}
	p2.actionBarRef = Roact.createRef()

	local v62, v63 = Roact.createBinding(0)

	p2.transitionPercent = v62
	p2.setTransitionPercent = v63

	function p2.briefToFullTransitionPercent(p3) -- line: 99
		-- upvalues: p2 (copy)
		p2:setState({
			topBarOpacity = p3
		})
	end
	function p2.getPeekViewEventMeta() -- line: 105
		-- upvalues: p2 (copy)
		return {
			universeId = p2.props.universeId,
			source = p2.props.source or "None",
			index = p2.props.index or -1
		}
	end
	function p2.eventTopBarClosePeekView() -- line: 113
		-- upvalues: p2 (copy), peekViewDismissedEvent (copy)
		local eventIngest = p2.props.eventIngest
		local routeName = p2.props.navigation.state.routeName
		local v105 = p2.getPeekViewEventMeta()

		peekViewDismissedEvent.logEvent(eventIngest, "ProfilePeekView", {
			dismissMethod = peekViewDismissedEvent.dismissMethodEnum.topBarTap,
			page = routeName,
			locale = v105.RobloxLocaleId,
			universeId = v105.universeId,
			source = v105.source or "None",
			index = v105.index or -1
		})
	end
	function p2.closeGameDetailsPeekViewInNavigation(p4) -- line: 128
		-- upvalues: p2 (copy), AppPage (copy), SessionType (copy)
		p2.props.navigation.clearAppScreens({ AppPage.GameDetail })

		if p2.props.onClose ~= nil then
			p2.props.onClose()
		end

		if p2.props.onPeekViewClosed and (not p4 or not p4.backButtonNavigation) then
			p2.props.onPeekViewClosed()
		end

		p2.props.sessionService:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
	end
	function p2.viewStateChanged(p5, p6) -- line: 144
		-- upvalues: PeekViewState (copy), p2 (copy)
		if p5 == PeekViewState.Brief then
			local gameDetailsPeekViewState = p2.props.gameDetailsPeekViewState

			if gameDetailsPeekViewState == PeekViewState.Brief then
				p2.eventSwitchGame()
			elseif gameDetailsPeekViewState == PeekViewState.Closed then
				p2.eventOpenPeekView()
			end
		end

		p2.props.setGameDetailsPeekViewState(p5)

		if p5 == PeekViewState.Closed then
			p2.closeGameDetailsPeekViewInNavigation()

			return
		end

		if p6 == PeekViewState.Brief and p5 == PeekViewState.Full then
			p2.eventGoToFullView()
		end
	end
	function p2.eventOpenPeekView() -- line: 163
		-- upvalues: p2 (copy), gameDetailsPeekViewEvents (copy)
		local eventIngest = p2.props.eventIngest
		local universeId = p2.props.universeId
		local v112 = p2.props.source or "None"
		local v113 = p2.props.index or -1

		gameDetailsPeekViewEvents(eventIngest, "OpenPeekView", universeId, v112, v113)
	end
	function p2.eventSwitchGame() -- line: 171
		-- upvalues: p2 (copy), gameDetailsPeekViewEvents (copy)
		local eventIngest = p2.props.eventIngest
		local universeId = p2.props.universeId
		local v116 = p2.props.source or "None"
		local v117 = p2.props.index or -1

		gameDetailsPeekViewEvents(eventIngest, "SwitchGame", universeId, v116, v117)
	end
	function p2.eventGoToFullView() -- line: 179
		-- upvalues: p2 (copy), gameDetailsPeekViewEvents (copy)
		local eventIngest = p2.props.eventIngest
		local universeId = p2.props.universeId
		local v120 = p2.props.source or "None"
		local v121 = p2.props.index or -1

		gameDetailsPeekViewEvents(eventIngest, "GoToFullView", universeId, v120, v121)
	end
end

if FFlagLuaAppEdpHideSystemBarOnPeekViewMount then
	function v55.didMount(p7) -- line: 189
		p7.props.setTabBarVisible(false)
	end
end

function v55.willUnmount(p8) -- line: 196
	-- upvalues: AppPage (copy), PeekViewState (copy)
	if (function(_) -- line: 197
		-- upvalues: p8 (copy), AppPage (copy)
		local history = p8.props.history
		local v124 = history[#history]
		local n1 = 0

		for i = 1, #v124 do
			if v124[i].name ~= AppPage.GameDetail then
				continue
			end

			n1 += 1

			if n1 > 1 then
				return false
			end
		end

		return true
	end)(p8.props.universeId) then
		p8.props.setGameDetailsPeekViewState(PeekViewState.Closed)
	end

	if p8.props.onClose ~= nil then
		p8.props.onClose()
	end
end
function v55.render(p10) -- line: 223
	-- upvalues: Constants (copy), getSafeAreaSize (copy), v34 (copy), v35 (copy), PeekViewState (copy), FFlagLuaAppEdpPeekViewReserveBottomDockHeight (copy), u53 (ref), GAME_DETAILS_ACTION_BAR_HEIGHT (copy), v37 (copy), ExperienceDetailsExperimentation (copy), v38 (copy), FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight (copy), v52 (copy), FFlagLuaAppExtendPlayWithRewardPeekView (copy), Roact (copy), PeekViewWithTopBar (copy), ActionBar (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), GameDetailsCard (copy), FFlagEnablePlayWithRewardComponent (copy), FFlagLuaAppExpandableTextImpressionsEnabled (copy), GameDetailsTopBar (copy)
	local universeId = p10.props.universeId
	local experienceJoinData = p10.props.experienceJoinData
	local v69 = p10.props.statusBarHeight + Constants.NAV_BAR_SIZE
	local gameDetailsPeekViewState = p10.props.gameDetailsPeekViewState
	local screenSize = p10.props.screenSize
	local globalGuiInset = p10.props.globalGuiInset
	local v73 = getSafeAreaSize(screenSize, globalGuiInset)
	local v74 = math.min(v73.X.Offset, 640)
	local v75 = not (v74 < 600) and 40 or 20
	local mountAsFullView = p10.props.mountAsFullView
	local isExperienceUnavailable = p10.props.isExperienceUnavailable

	if mountAsFullView == nil then
		mountAsFullView = not not v34 and p10.props.defaultMountAsFullView and true or (not not v35 or (gameDetailsPeekViewState == PeekViewState.Full or gameDetailsPeekViewState == PeekViewState.Extended))
	end

	local mountAnimation = p10.props.mountAnimation

	if mountAnimation == nil then
		mountAnimation = gameDetailsPeekViewState == PeekViewState.Closed
	end

	local v79 = nil

	if p10.props.showBackButton ~= nil then
		v79 = not p10.props.showBackButton
	end

	local v80 = p10.actionBarRef.current and p10.actionBarRef.current.AbsoluteSize.Y or if not FFlagLuaAppEdpPeekViewReserveBottomDockHeight then GAME_DETAILS_ACTION_BAR_HEIGHT else u53
	local v81 = not (not not v37 and ExperienceDetailsExperimentation.getShouldRaisePeekViewBriefHeight()) and not v38 and 0 or 24 + v75
	local v82 = (not FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight or not p10.props.isAgeCheckUpsellRendered) and 0 or v52 + v75
	local v83 = if not FFlagLuaAppExtendPlayWithRewardPeekView then nil else (not p10.props.playWithRewardPeekViewOffset or not (p10.props.playWithRewardPeekViewOffset > 0)) and 0 or p10.props.playWithRewardPeekViewOffset + v75
	local v84 = nil

	if FFlagLuaAppExtendPlayWithRewardPeekView then
		v84 = math.min(v74 + GAME_DETAILS_ACTION_BAR_HEIGHT + v81 + v82 + v83, (math.floor((v73.Y.Offset - v69) * 0.9)))
	end

	return Roact.createElement(PeekViewWithTopBar, {
		topBarHeight = v69,
		bottomDockedContainerHeight = v80,
		fullViewContentHeight = UDim.new(1, -v69),
		briefViewContentHeight = UDim.new(0, if not FFlagLuaAppExtendPlayWithRewardPeekView then v74 + GAME_DETAILS_ACTION_BAR_HEIGHT + v81 + v82 else v84),
		onViewStateChanged = p10.viewStateChanged,
		viewChangedEventMeta = p10.getPeekViewEventMeta(),
		mountAsFullView = mountAsFullView,
		mountAnimation = mountAnimation,
		transitionPercentCallback = p10.setTransitionPercent,
		bottomBarSlot = if not isExperienceUnavailable then Roact.createElement(ActionBar, {
			bottomPadding = 10,
			leftPadding = v75,
			rightPadding = v75,
			universeId = universeId,
			referralSource = p10.props.referralSource,
			experienceJoinData = experienceJoinData,
			placeIdOverride = p10.props.placeIdOverride,
			shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else ExperienceDetailsExperimentation.getShouldHydrateLegacy(),
			containerRef = p10.actionBarRef
		}) else nil,
		contentSlot = Roact.createElement(GameDetailsCard, {
			universeId = universeId,
			source = p10.props.source,
			index = p10.props.index,
			placeIdOverride = if not FFlagEnablePlayWithRewardComponent then nil else p10.props.placeIdOverride,
			experienceJoinData = if not FFlagEnablePlayWithRewardComponent then nil else experienceJoinData,
			viewportBoundsOffset = if not FFlagLuaAppExpandableTextImpressionsEnabled then nil else {
				min = Vector2.zero,
				max = Vector2.new(0, -v80)
			},
			onPeekViewClosed = p10.props.onPeekViewClosed
		}),
		topBarSlot = Roact.createElement(GameDetailsTopBar, {
			universeId = universeId,
			showCloseIcon = v79,
			onCloseButtonActivated = function(p11) -- line: 348
				-- upvalues: p10 (copy)
				p10.eventTopBarClosePeekView()
				p10.closeGameDetailsPeekViewInNavigation(p11)
			end,
			transitionPercentBinding = p10.transitionPercent
		})
	})
end
function v55.didUpdate(p12, p13) -- line: 357
	if p12.props.searchBarFocused ~= p13.searchBarFocused and p12.props.searchBarFocused then
		p12.closeGameDetailsPeekViewInNavigation()
	end
end

local v56 = RoactRodux.connect(function(p14, p15) -- line: 363
	-- upvalues: EnumGameDetailErrorTypes (copy), GetFFlagIsSquadEnabled (copy), FFlagSignalsNavP3fGameDetails (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), FFlagUseSignalsForSearchBar (copy)
	local v89 = p14.GameDetailErrors[p15.universeId] and p14.GameDetailErrors[p15.universeId].errorType == EnumGameDetailErrorTypes.ExperienceUnavailable

	return {
		currentSquad = if not GetFFlagIsSquadEnabled() then nil else p14.Squad and (p14.Squad.Squad and p14.Squad.Squad.currentSquad),
		history = if not FFlagSignalsNavP3fGameDetails then if not FFlagUseNavigationSelectors then p14.Navigation.history else Selectors.selectLegacyHistory(p14) else nil,
		gameDetailsPeekViewState = p14.GameDetailsPeekView.viewState,
		statusBarHeight = p14.TopBar.statusBarHeight,
		screenSize = p14.ScreenSize,
		globalGuiInset = p14.GlobalGuiInset,
		searchBarFocused = if not FFlagUseSignalsForSearchBar then p14.SearchBar.focused else nil,
		isExperienceUnavailable = v89
	}
end, function(p16) -- line: 381
	-- upvalues: SetGameDetailsPeekViewState (copy), FFlagLuaAppEdpHideSystemBarOnPeekViewMount (copy), SetTabBarVisible (copy)
	return {
		setGameDetailsPeekViewState = function(p17) -- line: 383
			-- upvalues: p16 (copy), SetGameDetailsPeekViewState (copy)
			return p16(SetGameDetailsPeekViewState(p17))
		end,
		setTabBarVisible = if not FFlagLuaAppEdpHideSystemBarOnPeekViewMount then nil else function(p18) -- line: 387
			-- upvalues: p16 (copy), SetTabBarVisible (copy)
			return p16(SetTabBarVisible(p18))
		end
	}
end)(v55)

if FFlagSignalsNavP3fGameDetails or FFlagUseSignalsForSearchBar then
	local v57 = v56

	function v56(p19) -- line: 396
		-- upvalues: FFlagSignalsNavP3fGameDetails (copy), useSignalState (copy), v45 (copy), FFlagUseSignalsForSearchBar (copy), GetSearchBarStore (copy), Roact (copy), v57 (copy), Cryo (copy)
		local v92 = if not FFlagSignalsNavP3fGameDetails then nil else useSignalState(v45(false).getHistory)
		local v93 = if not FFlagUseSignalsForSearchBar then nil else useSignalState(GetSearchBarStore(false).getFocused)

		return Roact.createElement(v57, Cryo.Dictionary.union(p19, {
			history = v92,
			searchBarFocused = v93
		}))
	end
end

if v34 then
	v56 = RoactAppExperiment.connectUserLayer({ AppUserLayers.ExperienceDetailsPageExposureLayer }, function(p20, _) -- line: 418
		-- upvalues: AppUserLayers (copy)
		return {
			defaultMountAsFullView = (p20[AppUserLayers.ExperienceDetailsPageExposureLayer] or {}).DefaultMountAsFullView
		}
	end)(v56)
end

local v58 = RoactServices.connect({
	eventIngest = AppEventIngestService,
	sessionService = AppSessionService
})(v56)

if FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight or FFlagLuaAppExtendPlayWithRewardPeekView then
	local v59 = v58

	function v58(p22) -- line: 433
		-- upvalues: FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight (copy), React (copy), AgeCheckUpsellRenderedData (copy), SignalsReact (copy), FFlagLuaAppExtendPlayWithRewardPeekView (copy), useEdpPerUniverseVisibilityVariablesForUniverse (copy), Roact (copy), v59 (copy), Cryo (copy)
		local v97 = if not p22.universeId then nil else tostring(p22.universeId)
		local v98 = nil

		if FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
			local v99 = React.useCallback(function(p23) -- line: 438
				-- upvalues: AgeCheckUpsellRenderedData (copy), v97 (copy)
				return AgeCheckUpsellRenderedData.getIsAgeCheckUpsellRendered(p23, v97)
			end, { v97 })

			v98 = SignalsReact.useSignalState(v99)
		end

		local v100 = nil

		if FFlagLuaAppExtendPlayWithRewardPeekView then
			local v101 = useEdpPerUniverseVisibilityVariablesForUniverse(v97 or "")

			v100 = v101 and v101.extendPlayWithRewardPeekViewOffset or nil
		end

		return Roact.createElement(v59, Cryo.Dictionary.join(p22, {
			isAgeCheckUpsellRendered = if not FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then nil else v98,
			playWithRewardPeekViewOffset = if not FFlagLuaAppExtendPlayWithRewardPeekView then nil else v100
		}))
	end
end

return (RoactNavigation.withNavigation(v58))
