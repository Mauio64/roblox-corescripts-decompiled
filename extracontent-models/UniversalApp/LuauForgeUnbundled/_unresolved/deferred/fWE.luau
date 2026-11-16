local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local peekViewWithTopBar = require("@luauforge/bundled/dzD").PeekViewWithTopBar
local sessionType = require("@luauforge/bundled/foF").SessionType
local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local peekViewDismissedEvent = require("@luauforge/bundled/dzD").analytics.peekViewDismissedEvent
local module = require("@luauforge/bundled/cyO")
local enumGameDetailErrorTypes = module.EnumGameDetailErrorTypes
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local setTabBarVisible = require("@luauforge/bundled/dwN").Actions.SetTabBarVisible

local gameDetailsPeekViewEvents = require("@luauforge/bundled/dwD").Events.gameDetailsPeekViewEvents

local module2 = require("@luauforge/bundled/dwA")
local module3 = require("@luauforge/bundled/dzE")
local module4 = require("@luauforge/deferred/fWF")
local module5 = require("@luauforge/deferred/fWG")
local module6 = require("@luauforge/deferred/fXa")

local module7 = require("@luauforge/deferred/fXb")

local module8 = require("@luauforge/deferred/fXf")
local ageCheckUpsellRenderedData = require("@luauforge/bundled/dzF").AgeCheckUpsellRenderedData

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled
local defineFastFlag = game:DefineFastFlag("EnableGameDetailsFullViewIXP", false)
local defineFastFlag2 = game:DefineFastFlag("ForceEnableGameDetailsFullView", false)

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local defineFastFlag3 = game:DefineFastFlag("SduiSocialProofRaisePeekViewBriefHeightIxp", false)

local defineFastFlag4 = game:DefineFastFlag("SduiSocialProofRaisePeekViewBriefHeightDefault", false)

local fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight

local fFlagLuaAppExpandableTextImpressionsEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExpandableTextImpressionsEnabled
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails
local fFlagUseSignalsForSearchBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForSearchBar
local SignalsReact2 = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact2.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local getSearchBarStore = require("@luauforge/bundled/frm").GetSearchBarStore

local fFlagEnablePlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlayWithRewardComponent

local fFlagLuaAppEdpPeekViewReserveBottomDockHeight = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpPeekViewReserveBottomDockHeight

local fFlagLuaAppEdpHideSystemBarOnPeekViewMount = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpHideSystemBarOnPeekViewMount

local fFlagLuaAppExtendPlayWithRewardPeekView = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppExtendPlayWithRewardPeekView

local GAME_DETAILS_ACTION_BAR_HEIGHT = module.Constants.GAME_DETAILS_ACTION_BAR_HEIGHT

local defineFastInt = game:DefineFastInt("SduiAgeCheckUpsellRowHeight", 70)
local v5

if fFlagLuaAppEdpPeekViewReserveBottomDockHeight then
	v5 = GAME_DETAILS_ACTION_BAR_HEIGHT + 40 + 10
else
	v5 = nil
end

local function getInnerPaddingSize(p2): number
	if p2 < 600 then
		return 20
	end

	return 40
end

local extended = Roact.PureComponent:extend("GameDetailsPeekView")

function extended:init()
	self.state = { topBarOpacity = 0 }

	self.actionBarRef = Roact.createRef()
	local binding, v6 = Roact.createBinding(0)
	self.transitionPercent = binding
	self.setTransitionPercent = v6

	function self.briefToFullTransitionPercent(p2)
		self:setState({ topBarOpacity = p2 })
	end

	function self.getPeekViewEventMeta()
		return {
			universeId = self.props.universeId,
			source = self.props.source or "None",
			index = self.props.index or -1
		}
	end

	function self.eventTopBarClosePeekView()
		local eventIngest = self.props.eventIngest
		local routeName = self.props.navigation.state.routeName
		local peekViewEventMeta = self.getPeekViewEventMeta()

		peekViewDismissedEvent.logEvent(eventIngest, "ProfilePeekView", {
			dismissMethod = peekViewDismissedEvent.dismissMethodEnum.topBarTap,
			page = routeName,
			locale = peekViewEventMeta.RobloxLocaleId,
			universeId = peekViewEventMeta.universeId,
			source = peekViewEventMeta.source or "None",
			index = peekViewEventMeta.index or -1
		})
	end

	function self.closeGameDetailsPeekViewInNavigation(p2)
		self.props.navigation.clearAppScreens({ appPage.GameDetail })

		if self.props.onClose ~= nil then
			self.props.onClose()
		end

		if self.props.onPeekViewClosed and not (p2 and p2.backButtonNavigation) then
			self.props.onPeekViewClosed()
		end

		self.props.sessionService:RemoveSession(sessionType.StructuralIdentifier.GameDetailSource)
	end

	function self.viewStateChanged(p2, p3)
		if p2 == peekViewState.Brief then
			local gameDetailsPeekViewState = self.props.gameDetailsPeekViewState

			if gameDetailsPeekViewState == peekViewState.Brief then
				self.eventSwitchGame()
			elseif gameDetailsPeekViewState == peekViewState.Closed then
				self.eventOpenPeekView()
			end
		end

		self.props.setGameDetailsPeekViewState(p2)

		if p2 == peekViewState.Closed then
			self.closeGameDetailsPeekViewInNavigation()
		elseif p3 == peekViewState.Brief and p2 == peekViewState.Full then
			self.eventGoToFullView()
		end
	end

	function self.eventOpenPeekView()
		gameDetailsPeekViewEvents(
			self.props.eventIngest,
			"OpenPeekView",
			self.props.universeId,
			self.props.source or "None",
			self.props.index or -1
		)
	end

	function self.eventSwitchGame()
		gameDetailsPeekViewEvents(
			self.props.eventIngest,
			"SwitchGame",
			self.props.universeId,
			self.props.source or "None",
			self.props.index or -1
		)
	end

	function self.eventGoToFullView()
		gameDetailsPeekViewEvents(
			self.props.eventIngest,
			"GoToFullView",
			self.props.universeId,
			self.props.source or "None",
			self.props.index or -1
		)
	end
end

if fFlagLuaAppEdpHideSystemBarOnPeekViewMount then
	function extended.didMount(p2)
		p2.props.setTabBarVisible(false)
	end
end

function extended.willUnmount(p2)
	local v6

	if fFlagSignalsNavP3fGameDetails then
		v6 = p2.props.isLastGameDetailPeekView
	else
		v6 = (function(p3): boolean
			local history = p2.props.history
			local v7 = history[#history]
			local count = 0

			for i = 1, #v7 do
				if v7[i].name ~= appPage.GameDetail then
					continue
				end

				count += 1

				if count > 1 then
					return false
				end
			end

			return true
		end)(p2.props.universeId)
	end

	if v6 then
		p2.props.setGameDetailsPeekViewState(peekViewState.Closed)
	end

	if p2.props.onClose ~= nil then
		p2.props.onClose()
	end
end

function extended.render(props)
	local universeId = props.props.universeId
	local experienceJoinData = props.props.experienceJoinData

	local v6 = props.props.statusBarHeight + module2.NAV_BAR_SIZE

	local gameDetailsPeekViewState = props.props.gameDetailsPeekViewState
	local safeAreaSize = getSafeAreaSize(props.props.screenSize, props.props.globalGuiInset)
	local v7 = math.min(safeAreaSize.X.Offset, 640)
	local v8 = v7 < 600 and 20 or 40

	local v9 = props.props.mountAsFullView

	local isExperienceUnavailable = props.props.isExperienceUnavailable

	if v9 == nil then
		v9 = (defineFastFlag and props.props.defaultMountAsFullView or defineFastFlag2) and true
			or gameDetailsPeekViewState == peekViewState.Full
			or gameDetailsPeekViewState == peekViewState.Extended
	end

	local v10 = props.props.mountAnimation

	if v10 == nil then
		v10 = gameDetailsPeekViewState == peekViewState.Closed
	end

	local v11 = if props.props.showBackButton ~= nil then not props.props.showBackButton else nil

	local v12 = props.actionBarRef.current and props.actionBarRef.current.AbsoluteSize.Y

	if not v12 then
		if fFlagLuaAppEdpPeekViewReserveBottomDockHeight then
			v12 = v5
		else
			v12 = GAME_DETAILS_ACTION_BAR_HEIGHT
		end
	end

	local v13 = not (defineFastFlag3 and module7.getShouldRaisePeekViewBriefHeight() or defineFastFlag4)
		and 0
		or 24 + v8

	local v14 = not (fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight and props.props.isAgeCheckUpsellRendered)
		and 0
		or defineFastInt + v8
	local v15

	if fFlagLuaAppExtendPlayWithRewardPeekView then
		v15 = not (props.props.playWithRewardPeekViewOffset and props.props.playWithRewardPeekViewOffset > 0)
			and 0
			or props.props.playWithRewardPeekViewOffset + v8
	end

	local v16

	if fFlagLuaAppExtendPlayWithRewardPeekView then
		v16 = math.min(
			v7 + GAME_DETAILS_ACTION_BAR_HEIGHT + v13 + v14 + v15,
			(math.floor((safeAreaSize.Y.Offset - v6) * 0.9))
		)
	end

	local createElement = Roact.createElement
	local children = {
		topBarHeight = v6,
		bottomDockedContainerHeight = v12,
		fullViewContentHeight = UDim.new(1, -v6),
		briefViewContentHeight = 0,
		onViewStateChanged = 0,
		viewChangedEventMeta = 0,
		mountAsFullView = 0,
		mountAnimation = 0,
		transitionPercentCallback = 0,
		bottomBarSlot = 0,
		contentSlot = 0,
		topBarSlot = 0
	}
	local newUDim = UDim.new

	if not fFlagLuaAppExtendPlayWithRewardPeekView then
		v16 = v7 + GAME_DETAILS_ACTION_BAR_HEIGHT + v13 + v14
	end

	children.briefViewContentHeight = newUDim(0, v16)

	children.onViewStateChanged = props.viewStateChanged
	children.viewChangedEventMeta = props.getPeekViewEventMeta()
	children.mountAsFullView = v9
	children.mountAnimation = v10
	children.transitionPercentCallback = props.setTransitionPercent
	local v19

	if not isExperienceUnavailable then
		local createElement2 = Roact.createElement
		local v21 = {
			leftPadding = v8,
			rightPadding = v8,
			bottomPadding = 10,
			universeId = universeId,
			referralSource = props.props.referralSource,
			experienceJoinData = experienceJoinData,
			placeIdOverride = props.props.placeIdOverride,
			shouldHydrateLegacyIxp = 0,
			containerRef = 0
		}

		local v22 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then module7.getShouldHydrateLegacy() else nil
		v21.shouldHydrateLegacyIxp = v22

		v21.containerRef = props.actionBarRef
		v19 = createElement2(module5, v21)
	end

	children.bottomBarSlot = v19

	local createElement2 = Roact.createElement
	local v21 = {
		universeId = universeId,
		source = props.props.source,
		index = props.props.index,
		placeIdOverride = 0,
		experienceJoinData = 0,
		viewportBoundsOffset = 0,
		onPeekViewClosed = 0
	}
	local v22 = if fFlagEnablePlayWithRewardComponent then props.props.placeIdOverride else nil
	v21.placeIdOverride = v22

	if not fFlagEnablePlayWithRewardComponent then
		experienceJoinData = nil
	end

	v21.experienceJoinData = experienceJoinData

	v21.viewportBoundsOffset = fFlagLuaAppExpandableTextImpressionsEnabled and {
		min = Vector2.zero,
		max = Vector2.new(0, -v12)
	} or nil

	v21.onPeekViewClosed = props.props.onPeekViewClosed
	children.contentSlot = createElement2(module6, v21)

	children.topBarSlot = Roact.createElement(module4, {
		universeId = universeId,
		showCloseIcon = v11,
		onCloseButtonActivated = function(p2)
			props.eventTopBarClosePeekView()
			props.closeGameDetailsPeekViewInNavigation(p2)
		end,
		transitionPercentBinding = props.transitionPercent
	})
	return createElement(peekViewWithTopBar, children)
end

function extended.didUpdate(p2, p3)
	if p2.props.searchBarFocused ~= p3.searchBarFocused and p2.props.searchBarFocused then
		p2.closeGameDetailsPeekViewInNavigation()
	end
end

local v6 = RoactRodux.connect(function(data, p2)
	local v7 = data.GameDetailErrors[p2.universeId]
		and data.GameDetailErrors[p2.universeId].errorType == enumGameDetailErrorTypes.ExperienceUnavailable

	local v9 = if getFFlagIsSquadEnabled() then data.Squad and data.Squad.Squad and data.Squad.Squad.currentSquad else nil
	local v10

	if not fFlagSignalsNavP3fGameDetails then
		if fFlagUseNavigationSelectors then
			v10 = selectors.selectLegacyHistory(data)
		else
			v10 = data.Navigation.history
		end
	end

	local v8 = {
		currentSquad = v9,
		history = v10,
		gameDetailsPeekViewState = data.GameDetailsPeekView.viewState,
		statusBarHeight = data.TopBar.statusBarHeight,
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset,
		searchBarFocused = 0,
		isExperienceUnavailable = 0
	}
	local v11 = if not fFlagUseSignalsForSearchBar then data.SearchBar.focused else nil
	v8.searchBarFocused = v11
	v8.isExperienceUnavailable = v7
	return v8
end, function(callback)
	return {
		setGameDetailsPeekViewState = function(p2)
			return callback(module3(p2))
		end,
		setTabBarVisible = fFlagLuaAppEdpHideSystemBarOnPeekViewMount and function(p2)
			return callback(setTabBarVisible(p2))
		end or nil
	}
end)(extended)

local fn = (fFlagSignalsNavP3fGameDetails or fFlagUseSignalsForSearchBar) and function(p2)
	local v7

	if fFlagUseSignalsForSearchBar then
		v7 = useSignalState(getSearchBarStore(false).getFocused)
	end

	local v8

	if fFlagSignalsNavP3fGameDetails then
		v8 = React.useMemo(function(): boolean
			local currentLegacyRoute = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
			local count = 0

			for i = 1, #currentLegacyRoute do
				if currentLegacyRoute[i].name ~= appPage.GameDetail then
					continue
				end

				count += 1

				if count > 1 then
					return false
				end
			end

			return true
		end, {})
	end

	return Roact.createElement(
		v6,
		Cryo.Dictionary.union(p2, {
			searchBarFocused = v7,
			isLastGameDetailPeekView = v8
		})
	)
end or v6

if defineFastFlag then
	fn = RoactAppExperiment.connectUserLayer(
		{ appUserLayers.ExperienceDetailsPageExposureLayer },
		function(p2, p3)
			return {
				defaultMountAsFullView = (p2[appUserLayers.ExperienceDetailsPageExposureLayer] or {}).DefaultMountAsFullView
			}
		end
	)(fn)
end

local v7 = roactServices.connect({
	eventIngest = appEventIngestService,
	sessionService = appSessionService
})(fn)

return (RoactNavigation.withNavigation((fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight or fFlagLuaAppExtendPlayWithRewardPeekView) and function(p2)
	local universeId = if p2.universeId then tostring(p2.universeId) else nil
	local v8

	if fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
		local v9 = React.useCallback(function(p3)
			return ageCheckUpsellRenderedData.getIsAgeCheckUpsellRendered(p3, universeId)
		end, { universeId })
		v8 = SignalsReact.useSignalState(v9)
	end

	local extendPlayWithRewardPeekViewOffset

	if fFlagLuaAppExtendPlayWithRewardPeekView then
		local v9 = module8(universeId or "")

		extendPlayWithRewardPeekViewOffset = v9 and v9.extendPlayWithRewardPeekViewOffset or nil
	end

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if not fFlagSduiAgeCheckUpsellRaisePeekViewBriefHeight then
		v8 = nil
	end

	if not fFlagLuaAppExtendPlayWithRewardPeekView then
		extendPlayWithRewardPeekViewOffset = nil
	end

	return createElement(
		v7,
		join(p2, {
			isAgeCheckUpsellRendered = v8,
			playWithRewardPeekViewOffset = extendPlayWithRewardPeekViewOffset
		})
	)
end or v7))
