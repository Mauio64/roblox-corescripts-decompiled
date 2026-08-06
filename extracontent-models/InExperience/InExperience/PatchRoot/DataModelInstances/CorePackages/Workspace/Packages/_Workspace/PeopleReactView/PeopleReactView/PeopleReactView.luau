local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local RobloxAppEnums = require(scriptParentParent.RobloxAppEnums)
local RobloxAppHooks = require(scriptParentParent.RobloxAppHooks)
local Foundation = require(scriptParentParent.Foundation)
local PeopleService = require(scriptParentParent.PeopleService)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useGetPeopleService = require(scriptParent.Hooks.useGetPeopleService)
local useScrollingFrameStore = require(scriptParent.Hooks.useScrollingFrameStore)
local View = Foundation.View
local PeopleList = require(scriptParent.Components.PeopleList)
local PeopleCards = require(scriptParent.Components.PeopleCards)
local CoreButtonRow = require(scriptParent.Components.CoreButtonRow)
local MenuButtonsWrapper = require(scriptParent.Components.MenuButtonsWrapper)
local TitleBar = require(scriptParent.Components.TitleBar)
local SwitchServerConfirmation = require(scriptParent.Components.SwitchServerConfirmation)
local SwitchServerTelemetry = require(scriptParent.Telemetry.SwitchServerTelemetry)
local Constants = require(scriptParent.Constants)
local GameSettings = UserSettings().GameSettings
local FFlagEnableSideSheet = require(scriptParentParent.SharedFlags).FFlagEnableSideSheet
local v22 = PeopleService.getService("Flags")
local GetFFlagAddPeoplePageCardLayout = v22.GetFFlagAddPeoplePageCardLayout
local GetFFlagPeoplePageLazyRenderCards = v22.GetFFlagPeoplePageLazyRenderCards
local GetFFlagPeoplePagePostponeInitialRender = v22.GetFFlagPeoplePagePostponeInitialRender
local FFlagEnablePeopleListLazyRender = v22.FFlagEnablePeopleListLazyRender
local FFlagPeoplePageRemoveUseMemoElements = v22.FFlagPeoplePageRemoveUseMemoElements
local FFlagPeopleCardsEnableVirtualizedGrid = v22.FFlagPeopleCardsEnableVirtualizedGrid
local FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView = v22.FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
local FFlagPeoplePageFlipVolumePopoverToFitViewport = v22.FFlagPeoplePageFlipVolumePopoverToFitViewport
local FFlagPeoplePageDismissCardMenuOnScrollOutOfView = v22.FFlagPeoplePageDismissCardMenuOnScrollOutOfView
local FFlagFixVirtualizedGridNumItems = v22.FFlagFixVirtualizedGridNumItems
local FFlagShowSwitchServerButton = v22.FFlagShowSwitchServerButton

local function _createPageView(t1: {[any]: any}) -- line: 52
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), useGetPeopleService (copy), React (copy), PeopleService (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), GameSettings (copy), GetFFlagPeoplePagePostponeInitialRender (copy), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView (copy), FFlagPeoplePageFlipVolumePopoverToFitViewport (copy), FFlagPeoplePageDismissCardMenuOnScrollOutOfView (copy), useScrollingFrameStore (copy), FFlagFixVirtualizedGridNumItems (copy), FFlagPeoplePageRemoveUseMemoElements (copy), PeopleCards (copy), PeopleList (copy), FFlagShowSwitchServerButton (copy), FFlagEnableSideSheet (copy), MenuButtonsWrapper (copy), CoreButtonRow (copy), Constants (copy), SwitchServerTelemetry (copy), TitleBar (copy), View (copy), SwitchServerConfirmation (copy)
	local v36 = if not GetFFlagAddPeoplePageCardLayout() then nil else useGetPeopleService("PeopleAnalyticsManager")
	local u37 = if not GetFFlagAddPeoplePageCardLayout() then React.useMemo(function() -- line: 73
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleBlockingModalManager")
	end, {}) else useGetPeopleService("PeopleBlockingModalManager")
	local v38 = React.useMemo(function() -- line: 79
		-- upvalues: u37 (ref), t1 (copy)
		return u37.getModalManager(t1.blockingModalScreen, t1.blockingFlags)
	end, {
		u37,
		t1.blockingModalScreen,
		t1.blockingFlags
	})
	local v39 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local u40 = nil
	local u41 = nil

	if GetFFlagAddPeoplePageCardLayout() then
		local v42, v43 = React.useState(GameSettings.PeoplePageLayout)

		u40 = v42
		u41 = v43
	end

	local v44 = nil
	local u45 = nil

	if GetFFlagPeoplePagePostponeInitialRender() then
		local v46

		v44, v46 = React.useState(false)
		u45 = v46
	end

	local v47 = if not GetFFlagPeoplePageLazyRenderCards() and (not FFlagEnablePeopleListLazyRender and (not FFlagPeopleCardsEnableVirtualizedGrid and (not FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView and (not FFlagPeoplePageFlipVolumePopoverToFitViewport and not FFlagPeoplePageDismissCardMenuOnScrollOutOfView)))) then nil else useScrollingFrameStore(t1.scrollingFrame)
	local v48 = if not FFlagFixVirtualizedGridNumItems then nil else React.useCallback(function(p1) -- line: 106
		-- upvalues: v47 (copy)
		if v47 then
			v47.setCanvasPositionYOffset(-p1.AbsoluteSize.Y)
		end
	end, { v47 })
	local v49 = if not GetFFlagAddPeoplePageCardLayout() then nil else React.useCallback(function(p2) -- line: 114
		-- upvalues: v36 (copy), u41 (ref)
		v36:trackPeoplePageLayoutChanged(p2)
		u41(p2)
	end, {})
	local v50 = if not FFlagPeoplePageRemoveUseMemoElements then if not GetFFlagAddPeoplePageCardLayout() then nil else React.useMemo(function() -- line: 140
		-- upvalues: u40 (ref), React (copy), PeopleCards (copy), t1 (copy), v47 (copy), PeopleList (copy), FFlagEnablePeopleListLazyRender (copy)
		if u40 == Enum.PeoplePageLayout.Card then
			return (React.createElement(PeopleCards, {
				LayoutOrder = 3,
				getUniversesExposedTo = t1.getUniversesExposedTo,
				addUniverseToExposureList = t1.addUniverseToExposureList,
				scrollingFrameStore = if not t1.scrollingFrame then nil else v47
			}))
		end

		return (React.createElement(PeopleList, {
			LayoutOrder = 3,
			scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v47
		}))
	end, {
		u40,
		v47,
		t1.scrollingFrame,
		t1.getUniversesExposedTo,
		t1.addUniverseToExposureList
	}) else if u40 ~= Enum.PeoplePageLayout.Card then React.createElement(PeopleList, {
		LayoutOrder = 3,
		scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v47
	}) else React.createElement(PeopleCards, {
		LayoutOrder = 3,
		getUniversesExposedTo = t1.getUniversesExposedTo,
		addUniverseToExposureList = t1.addUniverseToExposureList,
		scrollingFrameStore = if not t1.scrollingFrame then nil else v47
	})

	if GetFFlagPeoplePagePostponeInitialRender() then
		React.useEffect(function() -- line: 169
			-- upvalues: u45 (ref)
			u45(true)
		end, {})
	end

	local v51 = nil
	local u52 = nil

	if FFlagShowSwitchServerButton then
		local v53

		v51, v53 = React.useState(false)
		u52 = v53
	end

	local v54 = React.createElement(React.Fragment, {}, {
		MenuButtonsWrapper = if not FFlagEnableSideSheet then React.createElement(MenuButtonsWrapper) else nil,
		CoreButtonRow = React.createElement(CoreButtonRow, {
			chromeEnabled = t1.chromeEnabled,
			LayoutOrder = if not GetFFlagAddPeoplePageCardLayout() then nil else 1,
			buttonActivatedTable = if not FFlagShowSwitchServerButton then nil else {
				[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER] = function() -- line: 188
					-- upvalues: SwitchServerTelemetry (copy), u52 (ref)
					SwitchServerTelemetry.sendSwitchServerButtonActions({
						event_type = "click"
					})
					u52(true)
				end
			}
		}),
		TitleBar = if not GetFFlagAddPeoplePageCardLayout() then nil else React.createElement(TitleBar, {
			LayoutOrder = 2,
			layout = u40,
			setLayout = v49
		})
	})

	if FFlagFixVirtualizedGridNumItems then
		v54 = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-large padding-bottom-large",
			LayoutOrder = 1,
			onAbsoluteSizeChanged = v48
		}, v54)
	end

	return React.createElement(View, {
		testId = "mainView",
		tag = {
			["size-full col padding-bottom-small"] = FFlagFixVirtualizedGridNumItems,
			["size-full col gap-large padding-bottom-small"] = not FFlagFixVirtualizedGridNumItems,
			["padding-x-medium"] = not v39
		}
	}, {
		PeopleHeader = v54,
		People = if not not GetFFlagPeoplePagePostponeInitialRender() and not v44 then nil else if not GetFFlagAddPeoplePageCardLayout() then React.createElement(PeopleList, {
			scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v47
		}) else v50,
		BlockingModalManager = React.createElement(v38),
		SwitchServerConfirmation = if not FFlagShowSwitchServerButton or not v51 then nil else React.createElement(SwitchServerConfirmation, {
			setSwitchServerConfirmationOpen = u52
		})
	})
end

return _createPageView
