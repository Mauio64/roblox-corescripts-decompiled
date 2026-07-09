local Parent = script:FindFirstAncestor("BumperNavigation").Parent
local SharedFlags = require(Parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local useSignalState = require(Parent.SignalsReact).useSignalState
local v6 = if not FFlagSignalsNavP3hMisc then nil else require(Parent.NavigationRodux).GetLegacyNavigationStore
local React = require(Parent.React)

require(Parent.ReactFocusNavigation)

local InputHandlers = require(Parent.InputHandlers)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local useNavigation = require(Parent.Navigation).useNavigation
local Selectors = require(Parent.NavigationRodux).Selectors
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactAnalytics = require(Parent.RoactServiceTags).RoactAnalytics
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input
local useIsSpatial = Responsive.useIsSpatial
local AppNavBar = require(Parent.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local Placement = AppNavBar.Placement

local function selectTopLevelRouteName(p1) -- line: 33
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v32 = if not FFlagUseNavigationSelectors then p1.Navigation.history else Selectors.selectLegacyHistory(p1)
	local v33 = v32[#v32][1]

	return v33 and v33.name or "None"
end
local function getNextTabFromRouteName(s1: string, p2) -- line: 42
	for v36, v37 in p2 do
		if s1 ~= v37.page then
			continue
		end

		local v38 = v36 + 1

		if v38 > #p2 then
			v38 = 1
		end

		local v39 = p2[v38]

		if v39 ~= nil then
			return v39.page
		end
	end

	return nil
end
local function getPrevTabFromRouteName(s2: string, p3) -- line: 58
	for v42, v43 in p3 do
		if s2 ~= v43.page then
			continue
		end

		local v44 = v42 - 1

		if v44 < 1 then
			v44 = #p3
		end

		local v45 = p3[v44]

		if v45 ~= nil then
			return v45.page
		end
	end

	return nil
end
local function buttonClick(p4, s3: string, s4: string, s5: string?) -- line: 74
	assert(type(s3) == "string", "Expected eventContext to be a string")
	assert(type(s4) == "string", "Expected buttonName to be a string")

	local t1 = {
		btn = s4
	}

	if s5 ~= nil then
		assert(type(s5) == "string", "Expected extraData to be a string")
		t1.cstm = s5
	end

	p4:setRBXEventStream(s3, "buttonClick", t1)
end
local function createNavigationBindingEventContext(s6: string) -- line: 91
	return `GamepadBumperNavBinding{ s6 }`
end

local v28 = `GamepadBumperNavBinding{ FocusNavigationEventNameEnum.TabForward }`
local v29 = `GamepadBumperNavBinding{ FocusNavigationEventNameEnum.TabBackward }`
local t2 = {}

function useGamepadBumperNavigationBindings(p5) -- line: 98
	-- upvalues: useNavigation (copy), useRoactService (copy), RoactAnalytics (copy), FFlagSignalsNavP3hMisc (copy), v6 (copy), useSignalState (copy), useSelector (copy), selectTopLevelRouteName (copy), getPrevTabFromRouteName (copy), getNextTabFromRouteName (copy), usePreferredInput (copy), Input (copy), useNavBarPlacement (copy), Placement (copy), useIsSpatial (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), buttonClick (copy), v28 (copy), v29 (copy), t2 (copy)
	local v53 = useNavigation()
	local v54 = v53.state.key or v53.state.routes[v53.state.index].key
	local EventStream = useRoactService(RoactAnalytics).EventStream
	local v58

	if FFlagSignalsNavP3hMisc then
		local v56 = v6(false)
		local v57 = useSignalState(v56.getCurrentLegacyRoute)[1]

		v58 = v57 and v57.name or "None"
	else
		v58 = useSelector(selectTopLevelRouteName)
	end

	local v59 = getPrevTabFromRouteName(v58, p5)
	local v60 = getNextTabFromRouteName(v58, p5)
	local v61 = useSelector(function(p6) -- line: 113
		return p6.TabBarVisible
	end)
	local v62 = usePreferredInput() == Input.Directional
	local v63 = useNavBarPlacement() == Placement.Left
	local v64 = useIsSpatial()
	local v65 = v61 and (v62 and (v63 and not v64))
	local v66 = React.useMemo(function() -- line: 121
		-- upvalues: FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonR1] = FocusNavigationEventNameEnum.TabForward,
			[Enum.KeyCode.ButtonL1] = FocusNavigationEventNameEnum.TabBackward
		}
	end, {})
	local v67 = React.useMemo(function() -- line: 130
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v60 (copy), v53 (copy), buttonClick (copy), EventStream (copy), v28 (copy), v54 (copy), v59 (copy), v29 (copy)
		return {
			[FocusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(function(_) -- line: 134
					-- upvalues: v60 (copy), v53 (copy), buttonClick (copy), EventStream (copy), v28 (copy), v54 (copy)
					if v60 then
						v53.navigate(v60)
						buttonClick(EventStream, v28, v60, v54)
					end
				end)
			},
			[FocusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(function(_) -- line: 142
					-- upvalues: v59 (copy), v53 (copy), buttonClick (copy), EventStream (copy), v29 (copy), v54 (copy)
					if v59 then
						v53.navigate(v59)
						buttonClick(EventStream, v29, v59, v54)
					end
				end)
			}
		}
	end, {
		v53,
		EventStream,
		v60,
		v59,
		v54
	})
	local v68 = if not v65 then t2 else v66
	local v69 = if not v65 then t2 else v67

	return {
		isBumperNavigationEnabled = v65,
		eventMap = v68,
		eventHandlerMap = v69
	}
end

return useGamepadBumperNavigationBindings
