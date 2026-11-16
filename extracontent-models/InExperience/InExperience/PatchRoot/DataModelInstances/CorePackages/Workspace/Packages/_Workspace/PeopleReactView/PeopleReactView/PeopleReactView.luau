local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local RobloxAppEnums = require(parent2.RobloxAppEnums)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local Foundation = require(parent2.Foundation)
local PeopleService = require(parent2.PeopleService)
local SwitchServer = require(parent2.SwitchServer)

local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useGetPeopleService = require(parent.Hooks.useGetPeopleService)
local useScrollingFrameStore = require(parent.Hooks.useScrollingFrameStore)
local usePeopleWindowWidth = require(parent.Hooks.usePeopleWindowWidth)

local View = Foundation.View

local PeopleList = require(parent.Components.PeopleList)
local PeopleCards = require(parent.Components.PeopleCards)
local CoreButtonRow = require(parent.Components.CoreButtonRow)
local MenuButtonsWrapper = require(parent.Components.MenuButtonsWrapper)
local TitleBar = require(parent.Components.TitleBar)

local Constants = require(parent.Constants)
local isPeoplePageCompact = require(parent.Utils.isPeoplePageCompact)
local PeoplePageLayoutContext = require(parent.PeoplePageLayoutContext)

local gameSettings = UserSettings().GameSettings

local SwitchServerConfirmation = SwitchServer.SwitchServerConfirmation
local SwitchServerTelemetry = SwitchServer.SwitchServerTelemetry

local SharedFlags = require(parent2.SharedFlags)
local isSideSheetEnabled = require(parent2.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage
local FFlagPeopleListButtonOverflow = require(parent.Flags.FFlagPeopleListButtonOverflow)
local service = PeopleService.getService("Flags")
local getFFlagAddPeoplePageCardLayout = service.GetFFlagAddPeoplePageCardLayout
local getFFlagPeoplePageLazyRenderCards = service.GetFFlagPeoplePageLazyRenderCards
local getFFlagPeoplePagePostponeInitialRender = service.GetFFlagPeoplePagePostponeInitialRender
local fFlagEnablePeopleListLazyRender = service.FFlagEnablePeopleListLazyRender
local fFlagPeoplePageRemoveUseMemoElements = service.FFlagPeoplePageRemoveUseMemoElements
local fFlagPeopleCardsEnableVirtualizedGrid = service.FFlagPeopleCardsEnableVirtualizedGrid

local fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView = service.FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
local fFlagPeoplePageFlipVolumePopoverToFitViewport = service.FFlagPeoplePageFlipVolumePopoverToFitViewport
local fFlagPeoplePageDismissCardMenuOnScrollOutOfView = service.FFlagPeoplePageDismissCardMenuOnScrollOutOfView
local fFlagFixVirtualizedGridNumItems = service.FFlagFixVirtualizedGridNumItems

local function _createPageView(props)
	local v

	if getFFlagAddPeoplePageCardLayout() then
		v = useGetPeopleService("PeopleAnalyticsManager")
	else
		v = nil
	end

	local v2

	if getFFlagAddPeoplePageCardLayout() then
		v2 = useGetPeopleService("PeopleBlockingModalManager")
	else
		v2 = React.useMemo(function()
			return PeopleService.getService("PeopleBlockingModalManager")
		end, {})
	end

	local v3 = React.useMemo(function()
		return v2.getModalManager(props.blockingModalScreen, props.blockingFlags)
	end, { v2, props.blockingModalScreen, props.blockingFlags })

	local v4 = useDeviceOrientation() == RobloxAppEnums.DeviceOrientationMode.Portrait
	local ref, isCompact

	if FFlagPeopleListButtonOverflow then
		local v5
		v5, ref = usePeopleWindowWidth()

		isCompact = isPeoplePageCompact(v5)
	else
		isCompact = false
	end

	local v5

	if FFlagPeopleListButtonOverflow then
		v5 = React.useMemo(function()
			return { isCompact = isCompact }
		end, { isCompact })
	end

	local state, setState

	if getFFlagAddPeoplePageCardLayout() then
		state, setState = React.useState(gameSettings.PeoplePageLayout)
	else
		setState = nil
		state = nil
	end

	local state2, setState2

	if getFFlagPeoplePagePostponeInitialRender() then
		state2, setState2 = React.useState(false)
	else
		setState2 = nil
	end

	local v6

	if
		getFFlagPeoplePageLazyRenderCards()
		or fFlagEnablePeopleListLazyRender
		or fFlagPeopleCardsEnableVirtualizedGrid
		or fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
		or fFlagPeoplePageFlipVolumePopoverToFitViewport
		or fFlagPeoplePageDismissCardMenuOnScrollOutOfView
	then
		v6 = useScrollingFrameStore(props.scrollingFrame)
	else
		v6 = nil
	end

	local onAbsoluteSizeChanged

	if fFlagFixVirtualizedGridNumItems then
		onAbsoluteSizeChanged = React.useCallback(function(p)
			if v6 then
				v6.setCanvasPositionYOffset(-p.AbsoluteSize.Y)
			end
		end, { v6 })
	end

	local setLayout

	if getFFlagAddPeoplePageCardLayout() then
		setLayout = React.useCallback(function(p)
			v:trackPeoplePageLayoutChanged(p)
			setState(p)
		end, {})
	end

	local people

	if fFlagPeoplePageRemoveUseMemoElements then
		if state == Enum.PeoplePageLayout.Card then
			local createElement = React.createElement
			local v7 = {
				getUniversesExposedTo = props.getUniversesExposedTo,
				addUniverseToExposureList = props.addUniverseToExposureList,
				minimumCardWidth = 0,
				scrollingFrameStore = 0,
				LayoutOrder = 3
			}
			local minimumCardWidth

			if FFlagSideSheetOpenPeoplePage then
				minimumCardWidth = props.minimumCardWidth
			end

			v7.minimumCardWidth = minimumCardWidth
			local scrollingFrameStore

			if props.scrollingFrame then
				scrollingFrameStore = v6
			end

			v7.scrollingFrameStore = scrollingFrameStore
			people = createElement(PeopleCards, v7)
		else
			local createElement = React.createElement
			local scrollingFrameStore

			if fFlagEnablePeopleListLazyRender and props.scrollingFrame then
				scrollingFrameStore = v6
			end

			people = createElement(PeopleList, {
				scrollingFrameStore = scrollingFrameStore,
				LayoutOrder = 3
			})
		end
	elseif getFFlagAddPeoplePageCardLayout() then
		people = React.useMemo(function()
			if state == Enum.PeoplePageLayout.Card then
				local createElement = React.createElement
				local v7 = {
					getUniversesExposedTo = props.getUniversesExposedTo,
					addUniverseToExposureList = props.addUniverseToExposureList,
					minimumCardWidth = 0,
					scrollingFrameStore = 0,
					LayoutOrder = 3
				}
				local minimumCardWidth

				if FFlagSideSheetOpenPeoplePage then
					minimumCardWidth = props.minimumCardWidth
				end

				v7.minimumCardWidth = minimumCardWidth
				local scrollingFrameStore

				if props.scrollingFrame then
					scrollingFrameStore = v6
				end

				v7.scrollingFrameStore = scrollingFrameStore
				return (createElement(PeopleCards, v7))
			else
				local createElement = React.createElement
				local scrollingFrameStore

				if fFlagEnablePeopleListLazyRender and props.scrollingFrame then
					scrollingFrameStore = v6
				end

				return (createElement(PeopleList, {
					scrollingFrameStore = scrollingFrameStore,
					LayoutOrder = 3
				}))
			end
		end, {
			state,
			v6,
			props.scrollingFrame,
			props.getUniversesExposedTo,
			props.addUniverseToExposureList,
			props.minimumCardWidth or 0
		})
	end

	if getFFlagPeoplePagePostponeInitialRender() then
		React.useEffect(function()
			setState2(true)
		end, {})
	end

	local state3, setState3

	if FFlagShowSwitchServerButton then
		state3, setState3 = React.useState(false)
	else
		setState3 = nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local menuButtonsWrapper

	if not isSideSheetEnabled then
		menuButtonsWrapper = React.createElement(MenuButtonsWrapper)
	end

	local createElement2 = React.createElement
	local v7 = {
		chromeEnabled = props.chromeEnabled,
		LayoutOrder = getFFlagAddPeoplePageCardLayout() and 1 or nil,
		buttonActivatedTable = 0
	}
	local buttonActivatedTable

	if FFlagShowSwitchServerButton then
		buttonActivatedTable = {}
		buttonActivatedTable[Constants.PEOPLEPAGE.BUTTON_ACTIVATED_TABLE_KEYS.SWITCH_SERVER] = function()
			SwitchServerTelemetry.sendSwitchServerButtonActions({ event_type = "click" })

			setState3(true)
		end
	end

	v7.buttonActivatedTable = buttonActivatedTable
	local v8 = {
		MenuButtonsWrapper = menuButtonsWrapper,
		CoreButtonRow = createElement2(CoreButtonRow, v7),
		TitleBar = 0
	}
	local titleBar

	if getFFlagAddPeoplePageCardLayout() then
		titleBar = React.createElement(TitleBar, {
			layout = state,
			setLayout = setLayout,
			LayoutOrder = 2
		})
	end

	v8.TitleBar = titleBar
	local element = createElement(fragment, {}, v8)

	if fFlagFixVirtualizedGridNumItems then
		element = React.createElement(
			View,
			{
				tag = "size-full-0 auto-y col gap-large padding-bottom-large",
				onAbsoluteSizeChanged = onAbsoluteSizeChanged,
				LayoutOrder = 1
			},
			element
		)
	end

	local createElement3 = React.createElement
	local v9 = {
		tag = {
			["size-full col padding-bottom-small"] = fFlagFixVirtualizedGridNumItems,
			["size-full col gap-large padding-bottom-small"] = not fFlagFixVirtualizedGridNumItems,
			["padding-x-medium"] = not v4
		},
		ref = 0,
		testId = "mainView"
	}

	if not FFlagPeopleListButtonOverflow then
		ref = nil
	end

	v9.ref = ref

	if getFFlagPeoplePagePostponeInitialRender() and not state2 then
		people = nil
	elseif not getFFlagAddPeoplePageCardLayout() then
		local createElement4 = React.createElement
		local scrollingFrameStore

		if fFlagEnablePeopleListLazyRender and props.scrollingFrame then
			scrollingFrameStore = v6
		end

		people = createElement4(PeopleList, { scrollingFrameStore = scrollingFrameStore })
	end

	local v10 = {
		PeopleHeader = element,
		People = people,
		BlockingModalManager = React.createElement(v3),
		SwitchServerConfirmation = 0
	}
	local switchServerConfirmation

	if FFlagShowSwitchServerButton and state3 then
		switchServerConfirmation = React.createElement(SwitchServerConfirmation, {
			setSwitchServerConfirmationOpen = setState3
		})
	end

	v10.SwitchServerConfirmation = switchServerConfirmation
	local element2 = createElement3(View, v9, v10)

	if FFlagPeopleListButtonOverflow then
		return React.createElement(PeoplePageLayoutContext.Provider, { value = v5 }, {
			Page = element2
		})
	end

	return element2
end

return _createPageView
