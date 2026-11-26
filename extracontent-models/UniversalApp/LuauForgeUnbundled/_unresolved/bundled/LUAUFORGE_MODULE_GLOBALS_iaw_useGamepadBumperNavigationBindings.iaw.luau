local module = require("@luauforge/bundled/iax")
local fFlagUseNavigationSelectors = module.FFlagUseNavigationSelectors
local fFlagSignalsNavP3aWrapAppPage = module.FFlagSignalsNavP3aWrapAppPage
local fFlagSubTabUseHomeContainerOnConsole = module.FFlagSubTabUseHomeContainerOnConsole
local fFlagEnableFlyoutNavRailBumperNavigation = module.FFlagEnableFlyoutNavRailBumperNavigation

local v5 = if fFlagEnableFlyoutNavRailBumperNavigation then require("@luauforge/bundled/iay") else nil

local v6 = if fFlagEnableFlyoutNavRailBumperNavigation then require("@luauforge/bundled/iaz") else nil

local useOpenFlyoutSidePanel = if fFlagEnableFlyoutNavRailBumperNavigation then v5.Hooks.useOpenFlyoutSidePanel else nil

local flyoutSidePanelIXP = if fFlagEnableFlyoutNavRailBumperNavigation then v6.FlyoutSidePanelIXP else nil
local getLegacyNavigationStore

if fFlagSignalsNavP3aWrapAppPage then
	getLegacyNavigationStore = require("@luauforge/bundled/iaA").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local module2 = require("@luauforge/bundled/ias")
require("@luauforge/bundled/iaB")
local module3 = require("@luauforge/bundled/iaC")
local module4 = require("@luauforge/bundled/iaD")
local useNavigation = require("@luauforge/bundled/iaE").useNavigation
local selectors = require("@luauforge/bundled/iaA").Selectors
local focusNavigationEventNameEnum = module4.FocusNavigationEventNameEnum
local useRoactService = require("@luauforge/bundled/iaF").useRoactService
local roactAnalytics = require("@luauforge/bundled/iaG").RoactAnalytics
local useSelector = require("@luauforge/bundled/iaH").Hooks.RoactRodux.useSelector
local module5 = require("@luauforge/bundled/iav")
local usePreferredInput = module5.usePreferredInput
local input = module5.Input
local useIsSpatial = module5.useIsSpatial
local module6 = require("@luauforge/bundled/iaI")
local useNavBarPlacement = module6.useNavBarPlacement
local placement = module6.Placement

local function selectTopLevelRouteName(p2)
	local v7

	if fFlagUseNavigationSelectors then
		v7 = selectors.selectLegacyHistory(p2)
	else
		v7 = p2.Navigation.history
	end

	local v8 = v7[#v7][1]
	return v8 and v8.name or "None"
end

local function tabContainsRoute(p2, p3): boolean
	if
		p2.page == p3
		or fFlagSubTabUseHomeContainerOnConsole
		and p2.subTabPages ~= nil
		and table.find(p2.subTabPages, p3) ~= nil
	then
		return true
	end

	return false
end

local function getNextTabFromRouteName(p2, list)
	for k, item in list do
		if not (item.page == p2 or fFlagSubTabUseHomeContainerOnConsole and item.subTabPages ~= nil and table.find(item.subTabPages, p2) ~= nil) then
			continue
		end

		local v7 = k + 1
		local v8 = #list < v7 and 1 or v7

		local item2 = list[v8]

		if item2 ~= nil then
			return item2.page, v8
		end
	end

	return nil, nil
end

local function getPrevTabFromRouteName(p2, list)
	for k, item in list do
		if not (item.page == p2 or fFlagSubTabUseHomeContainerOnConsole and item.subTabPages ~= nil and table.find(item.subTabPages, p2) ~= nil) then
			continue
		end

		local v7 = k - 1
		local v8 = v7 < 1 and #list or v7

		local item2 = list[v8]

		if item2 ~= nil then
			return item2.page, v8
		end
	end

	return nil, nil
end

local function buttonClick(eventStream, value, value2, cstm)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert((type)(value2) == "string", "Expected buttonName to be a string")

	local v7 = { btn = value2 }

	if cstm ~= nil then
		assert(type(cstm) == "string", "Expected extraData to be a string")
		v7.cstm = cstm
	end

	eventStream:setRBXEventStream(value, "buttonClick", v7)
end

local function createNavigationBindingEventContext(p2)
	return `GamepadBumperNavBinding{p2}`
end
local formatted = `GamepadBumperNavBinding{focusNavigationEventNameEnum.TabForward}`
local formatted2 = `GamepadBumperNavBinding{focusNavigationEventNameEnum.TabBackward}`

local v7 = {}

function LUAUFORGE_MODULE_GLOBALS_iaw_useGamepadBumperNavigationBindings(list)
	local v8 = useNavigation()
	local key = v8.state.key or v8.state.routes[v8.state.index].key
	local eventStream = useRoactService(roactAnalytics).EventStream
	local v9

	if fFlagSignalsNavP3aWrapAppPage then
		v9 = getLegacyNavigationStore(false).getCurrentTabName(false)
	else
		v9 = useSelector(selectTopLevelRouteName)
	end

	local v10 = useSelector(function(p2)
		return p2.TabBarVisible
	end)

	local v11 = usePreferredInput() == input.Directional
	local v12 = useNavBarPlacement() == placement.Left
	local v13 = useIsSpatial()
	local v14

	if fFlagEnableFlyoutNavRailBumperNavigation then
		v14 = useOpenFlyoutSidePanel("AppNavRailBumper")
	else
		v14 = nil
	end

	local v15 = v10 and v11 and v12 and not v13
	local v16 = module2.useMemo(function()
		return {
			[Enum.KeyCode.ButtonR1] = focusNavigationEventNameEnum.TabForward,
			[Enum.KeyCode.ButtonL1] = focusNavigationEventNameEnum.TabBackward
		}
	end, {})

	local prevTabFromRouteName, v17 = getPrevTabFromRouteName(v9, list)
	local nextTabFromRouteName, v18 = getNextTabFromRouteName(v9, list)

	local useMemo = module2.useMemo
	local function fn()
		local v19 = {}

		v19[focusNavigationEventNameEnum.TabForward] = {
			handler = module3.onRelease(function(p2)
				local v20

				if fFlagSignalsNavP3aWrapAppPage then
					v20 = getLegacyNavigationStore(false).getCurrentTabName(false)
				else
					v20 = key
				end

				local v21, v22

				if fFlagSignalsNavP3aWrapAppPage then
					v21, v22 = getNextTabFromRouteName(v20, list)
				else
					v21 = nextTabFromRouteName
					v22 = v18
				end

				if v21 then
					v8.navigate(v21)
					buttonClick(eventStream, formatted, v21, v20)

					if
						fFlagEnableFlyoutNavRailBumperNavigation
						and flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
						and v22 == 1
					then
						v14()
					end
				end
			end)
		}

		v19[focusNavigationEventNameEnum.TabBackward] = {
			handler = module3.onRelease(function(p2)
				local v20

				if fFlagSignalsNavP3aWrapAppPage then
					v20 = getLegacyNavigationStore(false).getCurrentTabName(false)
				else
					v20 = key
				end

				local v21, v22

				if fFlagSignalsNavP3aWrapAppPage then
					v21, v22 = getPrevTabFromRouteName(v20, list)
				else
					v21 = prevTabFromRouteName
					v22 = v17
				end

				if
					fFlagEnableFlyoutNavRailBumperNavigation
					and flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
					and v22 == #list
				then
					v14()
					buttonClick(eventStream, formatted2, "FlyoutSidePanel", v20)
				elseif v21 then
					v8.navigate(v21)
					buttonClick(eventStream, formatted2, v21, v20)
				end
			end)
		}

		return v19
	end

	local v20 = if fFlagSignalsNavP3aWrapAppPage then list else nextTabFromRouteName
	local v21 = if not fFlagSignalsNavP3aWrapAppPage then prevTabFromRouteName else nil
	local v22 = if not fFlagSignalsNavP3aWrapAppPage then v18 else nil
	local v23 = if not fFlagSignalsNavP3aWrapAppPage then v17 else nil
	local v24 = if fFlagEnableFlyoutNavRailBumperNavigation then v14 else nil
	local v26 = useMemo(fn, {
		v8,
		eventStream,
		v20,
		v21,
		v22,
		v23,
		key,
		v24,
		if fFlagEnableFlyoutNavRailBumperNavigation then list else nil
	})

	if not v15 then
		v16 = v7
	end

	if not v15 then
		v26 = v7
	end

	return { isBumperNavigationEnabled = v15, eventMap = v16, eventHandlerMap = v26 }
end

return LUAUFORGE_MODULE_GLOBALS_iaw_useGamepadBumperNavigationBindings
