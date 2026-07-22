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
local FFlagFixVirtualizedGridNumItems = v22.FFlagFixVirtualizedGridNumItems
local FFlagShowSwitchServerButton = v22.FFlagShowSwitchServerButton

local function _createPageView(t1: {[any]: any}) -- line: 48
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), useGetPeopleService (copy), React (copy), PeopleService (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), GameSettings (copy), GetFFlagPeoplePagePostponeInitialRender (copy), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), useScrollingFrameStore (copy), FFlagFixVirtualizedGridNumItems (copy), FFlagPeoplePageRemoveUseMemoElements (copy), PeopleCards (copy), PeopleList (copy), FFlagShowSwitchServerButton (copy), FFlagEnableSideSheet (copy), MenuButtonsWrapper (copy), CoreButtonRow (copy), Constants (copy), SwitchServerTelemetry (copy), TitleBar (copy), View (copy), SwitchServerConfirmation (copy)
	local v33 = if not GetFFlagAddPeoplePageCardLayout() then nil else useGetPeopleService("PeopleAnalyticsManager")
	local u34 = if not GetFFlagAddPeoplePageCardLayout() then React.useMemo(function() -- line: 69
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleBlockingModalManager")
	end, {}) else useGetPeopleService("PeopleBlockingModalManager")
	local v35 = React.useMemo(function() -- line: 75
		-- upvalues: u34 (ref), t1 (copy)
		return u34.getModalManager(t1.blockingModalScreen, t1.blockingFlags)
	end, {
		u34,
		t1.blockingModalScreen,
		t1.blockingFlags
	})
	local v36 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local u37 = nil
	local u38 = nil

	if GetFFlagAddPeoplePageCardLayout() then
		local v39, v40 = React.useState(GameSettings.PeoplePageLayout)

		u37 = v39
		u38 = v40
	end

	local v41 = nil
	local u42 = nil

	if GetFFlagPeoplePagePostponeInitialRender() then
		local v43

		v41, v43 = React.useState(false)
		u42 = v43
	end

	local v44 = if not GetFFlagPeoplePageLazyRenderCards() and (not FFlagEnablePeopleListLazyRender and not FFlagPeopleCardsEnableVirtualizedGrid) then nil else useScrollingFrameStore(t1.scrollingFrame)
	local v45 = if not FFlagFixVirtualizedGridNumItems then nil else React.useCallback(function(p1) -- line: 99
		-- upvalues: v44 (copy)
		if v44 then
			v44.setCanvasPositionYOffset(-p1.AbsoluteSize.Y)
		end
	end, { v44 })
	local v46 = if not GetFFlagAddPeoplePageCardLayout() then nil else React.useCallback(function(p2) -- line: 107
		-- upvalues: v33 (copy), u38 (ref)
		v33:trackPeoplePageLayoutChanged(p2)
		u38(p2)
	end, {})
	local v47 = if not FFlagPeoplePageRemoveUseMemoElements then if not GetFFlagAddPeoplePageCardLayout() then nil else React.useMemo(function() -- line: 133
		-- upvalues: u37 (ref), React (copy), PeopleCards (copy), t1 (copy), v44 (copy), PeopleList (copy), FFlagEnablePeopleListLazyRender (copy)
		if u37 == Enum.PeoplePageLayout.Card then
			return (React.createElement(PeopleCards, {
				LayoutOrder = 3,
				getUniversesExposedTo = t1.getUniversesExposedTo,
				addUniverseToExposureList = t1.addUniverseToExposureList,
				scrollingFrameStore = if not t1.scrollingFrame then nil else v44
			}))
		end

		return (React.createElement(PeopleList, {
			LayoutOrder = 3,
			scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v44
		}))
	end, {
		u37,
		v44,
		t1.scrollingFrame,
		t1.getUniversesExposedTo,
		t1.addUniverseToExposureList
	}) else if u37 ~= Enum.PeoplePageLayout.Card then React.createElement(PeopleList, {
		LayoutOrder = 3,
		scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v44
	}) else React.createElement(PeopleCards, {
		LayoutOrder = 3,
		getUniversesExposedTo = t1.getUniversesExposedTo,
		addUniverseToExposureList = t1.addUniverseToExposureList,
		scrollingFrameStore = if not t1.scrollingFrame then nil else v44
	})

	if GetFFlagPeoplePagePostponeInitialRender() then
		React.useEffect(function() -- line: 162
			-- upvalues: u42 (ref)
			u42(true)
		end, {})
	end

	local v48 = nil
	local u49 = nil

	if FFlagShowSwitchServerButton then
		local v50

		v48, v50 = React.useState(false)
		u49 = v50
	end

	local v51 = React.createElement(React.Fragment, {}, {
		MenuButtonsWrapper = if not FFlagEnableSideSheet then React.createElement(MenuButtonsWrapper) else nil,
		CoreButtonRow = React.createElement(CoreButtonRow, {
			chromeEnabled = t1.chromeEnabled,
			LayoutOrder = if not GetFFlagAddPeoplePageCardLayout() then nil else 1,
			buttonActivatedTable = if not FFlagShowSwitchServerButton then nil else {
				[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER] = function() -- line: 181
					-- upvalues: SwitchServerTelemetry (copy), u49 (ref)
					SwitchServerTelemetry.sendSwitchServerButtonActions({
						event_type = "click"
					})
					u49(true)
				end
			}
		}),
		TitleBar = if not GetFFlagAddPeoplePageCardLayout() then nil else React.createElement(TitleBar, {
			LayoutOrder = 2,
			layout = u37,
			setLayout = v46
		})
	})

	if FFlagFixVirtualizedGridNumItems then
		v51 = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-large padding-bottom-large",
			LayoutOrder = 1,
			onAbsoluteSizeChanged = v45
		}, v51)
	end

	return React.createElement(View, {
		testId = "mainView",
		tag = {
			["size-full col padding-bottom-small"] = FFlagFixVirtualizedGridNumItems,
			["size-full col gap-large padding-bottom-small"] = not FFlagFixVirtualizedGridNumItems,
			["padding-x-medium"] = not v36
		}
	}, {
		PeopleHeader = v51,
		People = if not not GetFFlagPeoplePagePostponeInitialRender() and not v41 then nil else if not GetFFlagAddPeoplePageCardLayout() then React.createElement(PeopleList, {
			scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v44
		}) else v47,
		BlockingModalManager = React.createElement(v35),
		SwitchServerConfirmation = if not FFlagShowSwitchServerButton or not v48 then nil else React.createElement(SwitchServerConfirmation, {
			setSwitchServerConfirmationOpen = u49
		})
	})
end

return _createPageView
