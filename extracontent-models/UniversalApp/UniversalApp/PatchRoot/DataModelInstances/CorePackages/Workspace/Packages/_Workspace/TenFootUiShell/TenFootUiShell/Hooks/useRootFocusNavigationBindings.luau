local Parent = script:FindFirstAncestor("TenFootUiShell").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local InputHandlers = require(Parent.InputHandlers)
local TenFootUiCommon = require(Parent.TenFootUiCommon)
local TenFootUiGlobalNav = require(Parent.TenFootUiGlobalNav)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local Navigation = require(Parent.Navigation)
local useNavigation = Navigation.useNavigation
local Dash = require(Parent.Dash)
local useGlobalNavDisplayOptions = TenFootUiGlobalNav.useGlobalNavDisplayOptions
local getActiveChildNavigationOptionsRecursively = Navigation.getActiveChildNavigationOptionsRecursively
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local TenFootUiContext = TenFootUiCommon.TenFootUiContext
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local useFocusRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useFocusRegistryEntry
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus
local useRegistryEntry = FocusNavigationUtils.FocusNavigableSurfaceRegistry.useRegistryEntry
local getCurrentTabName = require(Parent.NavigationRodux).Utils.getCurrentTabName

local function forwardRefValue(p1, p2) -- line: 29
	if type(p1) == "function" then
		p1(p2)

		return
	end

	if type(p1) == "table" then
		p1.current = p2
	end
end
local function getNextTabFromRouteName(s1: string, p3) -- line: 37
	for v33, v34 in p3 do
		if s1 ~= v34.page then
			continue
		end

		local v35 = p3[v33 + 1]

		if v35 ~= nil then
			return v35.page
		end
	end

	return nil
end
local function getPrevTabFromRouteName(s2: string, p4) -- line: 49
	for v38, v39 in p4 do
		if s2 ~= v39.page then
			continue
		end

		local v40 = p4[v38 - 1]

		if v40 ~= nil then
			return v40.page
		end
	end

	return nil
end
local function createNavigationBindingEventContext(s3: string) -- line: 61
	return `TenFootUiNavBinding{ s3 }`
end

local v25 = `TenFootUiNavBinding{ FocusNavigationEventNameEnum.Search }`
local v26 = `TenFootUiNavBinding{ FocusNavigationEventNameEnum.TabForward }`
local v27 = `TenFootUiNavBinding{ FocusNavigationEventNameEnum.TabBackward }`
local v28 = `TenFootUiNavBinding{ FocusNavigationEventNameEnum.NavigateBack }`

function useRootFocusNavigationBindings(p5) -- line: 75
	-- upvalues: React (copy), TenFootUiContext (copy), useNavigation (copy), useFocusRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), useRegistryEntry (copy), useDescendantHasFocus (copy), useGlobalNavDisplayOptions (copy), getActiveChildNavigationOptionsRecursively (copy), GlobalNavDisplayOption (copy), Dash (copy), getCurrentTabName (copy), FocusNavigationEventNameEnum (copy), ReactFocusNavigation (copy), InputHandlers (copy), v25 (copy), v26 (copy), v27 (copy), v28 (copy)
	local v43 = React.useCallback(function(p6) -- line: 76
		-- upvalues: p5 (copy)
		if p5 then
			local v72 = p5

			if type(v72) == "function" then
				v72(p6)

				return
			end

			if type(v72) == "table" then
				v72.current = p6
			end
		end
	end, { p5 })
	local v44 = React.useContext(TenFootUiContext)
	local v45 = useNavigation()
	local v46 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v47 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v48 = useDescendantHasFocus(v47)
	local v49 = useGlobalNavDisplayOptions(v45, getActiveChildNavigationOptionsRecursively)
	local v50 = v49 == GlobalNavDisplayOption.TabGroupOnly or v49 == GlobalNavDisplayOption.ShowAll
	local v51 = v45.state.key or v45.state.routes[v45.state.index].key
	local v52 = if not v44 then {} else v44.globalNavConfig.tabs
	local v53 = if not v44 then nil else v44.useRoactService(v44.RoactAnalytics).EventStream
	local v54 = if not v44 then Dash.noop else v44.buttonClick
	local v55 = getCurrentTabName(v45.state)
	local g60 = nil
	local page = nil
	local g66 = nil
	local page2 = nil

	for v56, v57 in v52 do
		if v55 ~= v57.page then
			continue
		end

		local v58 = v52[v56 - 1]

		if v58 ~= nil then
			page = v58.page
			g60 = true
		end

		if g60 then
			break
		end
	end

	if not g60 then
		page = nil
	end

	g60 = false

	local v61 = page

	for v62, v63 in v52 do
		if v55 ~= v63.page then
			continue
		end

		local v64 = v52[v62 + 1]

		if v64 ~= nil then
			page2 = v64.page
			g66 = true
		end

		if g66 then
			break
		end
	end

	if not g66 then
		page2 = nil
	end

	g66 = false

	local v67 = page2
	local v68 = React.useMemo(function() -- line: 99
		-- upvalues: FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
			[Enum.KeyCode.ButtonR1] = FocusNavigationEventNameEnum.TabForward,
			[Enum.KeyCode.ButtonL1] = FocusNavigationEventNameEnum.TabBackward,
			[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.Search
		}
	end, {})
	local v69 = ReactFocusNavigation.useEventMap(v68, v43)
	local v70 = React.useMemo(function() -- line: 113
		-- upvalues: v50 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), v45 (copy), v54 (copy), v53 (copy), v25 (copy), v51 (copy), v67 (copy), v26 (copy), v61 (copy), v27 (copy), v48 (copy), v46 (copy), v28 (copy)
		local t1 = {}

		if v50 then
			t1[FocusNavigationEventNameEnum.Search] = {
				handler = InputHandlers.onRelease(function(_) -- line: 118
					-- upvalues: v45 (copy), v54 (copy), v53 (copy), v25 (copy), v51 (copy)
					v45.navigate("SearchPage")
					v54(v53, v25, "SearchPage", v51)
				end)
			}
			t1[FocusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(function(_) -- line: 124
					-- upvalues: v67 (copy), v45 (copy), v54 (copy), v53 (copy), v26 (copy), v51 (copy)
					if v67 then
						v45.navigate(v67)
						v54(v53, v26, v67, v51)
					end
				end)
			}
			t1[FocusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(function(_) -- line: 132
					-- upvalues: v61 (copy), v45 (copy), v54 (copy), v53 (copy), v27 (copy), v51 (copy)
					if v61 then
						v45.navigate(v61)
						v54(v53, v27, v61, v51)
					end
				end)
			}
			t1[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(_) -- line: 140
					-- upvalues: v48 (copy), v46 (copy)
					if not v48 then
						v46()
					end
				end)
			}

			return t1
		end

		t1[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function() -- line: 148
				-- upvalues: v45 (copy), v54 (copy), v53 (copy), v28 (copy), v51 (copy)
				if v45.pop ~= nil then
					v45.pop()
				else
					v45.goBack()
				end

				v54(v53, v28, "unknown", v51)
			end)
		}

		return t1
	end, {
		v45,
		v53,
		v54,
		v67,
		v61,
		v51,
		v46,
		v48,
		v50
	})

	return (ReactFocusNavigation.useEventHandlerMap(v70, v69))
end

return useRootFocusNavigationBindings
