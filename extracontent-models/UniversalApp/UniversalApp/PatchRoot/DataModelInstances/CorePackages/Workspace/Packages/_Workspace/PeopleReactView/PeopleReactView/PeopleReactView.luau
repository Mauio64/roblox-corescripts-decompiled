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
local Constants = require(scriptParent.Constants)
local GameSettings = UserSettings().GameSettings
local FFlagEnableSideSheet = require(scriptParentParent.SharedFlags).FFlagEnableSideSheet
local v21 = PeopleService.getService("Flags")
local GetFFlagAddPeoplePageCardLayout = v21.GetFFlagAddPeoplePageCardLayout
local GetFFlagPeoplePageLazyRenderCards = v21.GetFFlagPeoplePageLazyRenderCards
local GetFFlagPeoplePagePostponeInitialRender = v21.GetFFlagPeoplePagePostponeInitialRender
local FFlagEnablePeopleListLazyRender = v21.FFlagEnablePeopleListLazyRender
local FFlagPeoplePageRemoveUseMemoElements = v21.FFlagPeoplePageRemoveUseMemoElements
local FFlagPeopleCardsEnableVirtualizedGrid = v21.FFlagPeopleCardsEnableVirtualizedGrid
local FFlagFixVirtualizedGridNumItems = v21.FFlagFixVirtualizedGridNumItems
local FFlagShowSwitchServerButton = v21.FFlagShowSwitchServerButton

local function _createPageView(t1: {[any]: any}) -- line: 47
	-- upvalues: GetFFlagAddPeoplePageCardLayout (copy), useGetPeopleService (copy), React (copy), PeopleService (copy), useDeviceOrientation (copy), RobloxAppEnums (copy), GameSettings (copy), GetFFlagPeoplePagePostponeInitialRender (copy), GetFFlagPeoplePageLazyRenderCards (copy), FFlagEnablePeopleListLazyRender (copy), FFlagPeopleCardsEnableVirtualizedGrid (copy), useScrollingFrameStore (copy), FFlagFixVirtualizedGridNumItems (copy), FFlagPeoplePageRemoveUseMemoElements (copy), PeopleCards (copy), PeopleList (copy), FFlagShowSwitchServerButton (copy), FFlagEnableSideSheet (copy), MenuButtonsWrapper (copy), CoreButtonRow (copy), Constants (copy), TitleBar (copy), View (copy), SwitchServerConfirmation (copy)
	local v32 = if not GetFFlagAddPeoplePageCardLayout() then nil else useGetPeopleService("PeopleAnalyticsManager")
	local u33 = if not GetFFlagAddPeoplePageCardLayout() then React.useMemo(function() -- line: 68
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleBlockingModalManager")
	end, {}) else useGetPeopleService("PeopleBlockingModalManager")
	local v34 = React.useMemo(function() -- line: 74
		-- upvalues: u33 (ref), t1 (copy)
		return u33.getModalManager(t1.blockingModalScreen, t1.blockingFlags)
	end, {
		u33,
		t1.blockingModalScreen,
		t1.blockingFlags
	})
	local v35 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local u36 = nil
	local u37 = nil

	if GetFFlagAddPeoplePageCardLayout() then
		local v38, v39 = React.useState(GameSettings.PeoplePageLayout)

		u36 = v38
		u37 = v39
	end

	local v40 = nil
	local u41 = nil

	if GetFFlagPeoplePagePostponeInitialRender() then
		local v42

		v40, v42 = React.useState(false)
		u41 = v42
	end

	local v43 = if not GetFFlagPeoplePageLazyRenderCards() and (not FFlagEnablePeopleListLazyRender and not FFlagPeopleCardsEnableVirtualizedGrid) then nil else useScrollingFrameStore(t1.scrollingFrame)
	local v44 = if not FFlagFixVirtualizedGridNumItems then nil else React.useCallback(function(p1) -- line: 98
		-- upvalues: v43 (copy)
		if v43 then
			v43.setCanvasPositionYOffset(-p1.AbsoluteSize.Y)
		end
	end, { v43 })
	local v45 = if not GetFFlagAddPeoplePageCardLayout() then nil else React.useCallback(function(p2) -- line: 106
		-- upvalues: v32 (copy), u37 (ref)
		v32:trackPeoplePageLayoutChanged(p2)
		u37(p2)
	end, {})
	local v46 = if not FFlagPeoplePageRemoveUseMemoElements then if not GetFFlagAddPeoplePageCardLayout() then nil else React.useMemo(function() -- line: 132
		-- upvalues: u36 (ref), React (copy), PeopleCards (copy), t1 (copy), v43 (copy), PeopleList (copy), FFlagEnablePeopleListLazyRender (copy)
		if u36 == Enum.PeoplePageLayout.Card then
			return (React.createElement(PeopleCards, {
				LayoutOrder = 3,
				getUniversesExposedTo = t1.getUniversesExposedTo,
				addUniverseToExposureList = t1.addUniverseToExposureList,
				scrollingFrameStore = if not t1.scrollingFrame then nil else v43
			}))
		end

		return (React.createElement(PeopleList, {
			LayoutOrder = 3,
			scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v43
		}))
	end, {
		u36,
		v43,
		t1.scrollingFrame,
		t1.getUniversesExposedTo,
		t1.addUniverseToExposureList
	}) else if u36 ~= Enum.PeoplePageLayout.Card then React.createElement(PeopleList, {
		LayoutOrder = 3,
		scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v43
	}) else React.createElement(PeopleCards, {
		LayoutOrder = 3,
		getUniversesExposedTo = t1.getUniversesExposedTo,
		addUniverseToExposureList = t1.addUniverseToExposureList,
		scrollingFrameStore = if not t1.scrollingFrame then nil else v43
	})

	if GetFFlagPeoplePagePostponeInitialRender() then
		React.useEffect(function() -- line: 161
			-- upvalues: u41 (ref)
			u41(true)
		end, {})
	end

	local v47 = nil
	local u48 = nil

	if FFlagShowSwitchServerButton then
		local v49

		v47, v49 = React.useState(false)
		u48 = v49
	end

	local v50 = React.createElement(React.Fragment, {}, {
		MenuButtonsWrapper = if not FFlagEnableSideSheet then React.createElement(MenuButtonsWrapper) else nil,
		CoreButtonRow = React.createElement(CoreButtonRow, {
			chromeEnabled = t1.chromeEnabled,
			LayoutOrder = if not GetFFlagAddPeoplePageCardLayout() then nil else 1,
			buttonActivatedTable = if not FFlagShowSwitchServerButton then nil else {
				[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER] = function() -- line: 180
					-- upvalues: u48 (ref)
					u48(true)
				end
			}
		}),
		TitleBar = if not GetFFlagAddPeoplePageCardLayout() then nil else React.createElement(TitleBar, {
			LayoutOrder = 2,
			layout = u36,
			setLayout = v45
		})
	})

	if FFlagFixVirtualizedGridNumItems then
		v50 = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-large padding-bottom-large",
			LayoutOrder = 1,
			onAbsoluteSizeChanged = v44
		}, v50)
	end

	return React.createElement(View, {
		testId = "mainView",
		tag = {
			["size-full col padding-bottom-small"] = FFlagFixVirtualizedGridNumItems,
			["size-full col gap-large padding-bottom-small"] = not FFlagFixVirtualizedGridNumItems,
			["padding-x-medium"] = not v35
		}
	}, {
		PeopleHeader = v50,
		People = if not not GetFFlagPeoplePagePostponeInitialRender() and not v40 then nil else if not GetFFlagAddPeoplePageCardLayout() then React.createElement(PeopleList, {
			scrollingFrameStore = if not FFlagEnablePeopleListLazyRender or not t1.scrollingFrame then nil else v43
		}) else v46,
		BlockingModalManager = React.createElement(v34),
		SwitchServerConfirmation = if not FFlagShowSwitchServerButton or not v47 then nil else React.createElement(SwitchServerConfirmation, {
			onClose = function() -- line: 224
				-- upvalues: u48 (ref)
				u48(false)
			end
		})
	})
end

return _createPageView
