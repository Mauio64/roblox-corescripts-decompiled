local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local GuiService = game:GetService("GuiService")
local React = require(FocusNavigationUtilsParent.React)
local ReactFocusNavigation = require(FocusNavigationUtilsParent.ReactFocusNavigation)

require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)

local useFocusNavigableSurfaceRegistryConnection = require(FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection)
local useAutoFocus = require(FocusNavigationUtils.useAutoFocus)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local useLastInputMode = require(FocusNavigationUtils.useLastInputMode)
local t1 = {}

local function useFocusRoot(t2: {[any]: any}) -- line: 44
	-- upvalues: React (copy), t1 (copy), ReactFocusNavigation (copy), useFocusNavigableSurfaceRegistryConnection (copy), useDescendantHasFocus (copy), useAutoFocus (copy), useLastInputMode (copy), GuiService (copy)
	local v13, v14 = React.useState(nil)
	local u15 = v13
	local v16 = t2.eventMap or t1
	local v17 = ReactFocusNavigation.useEventMap(v16, v14)
	local v18 = t2.eventHandlers or t1
	local v19 = ReactFocusNavigation.useEventHandlerMap(v18, v17)
	local v20 = t2.isFocusable == nil or t2.isFocusable
	local v21 = t2.shouldRestoreFocus == nil or t2.shouldRestoreFocus
	local v22 = ReactFocusNavigation.useMostRecentFocusBehavior(v19)

	useFocusNavigableSurfaceRegistryConnection(u15, t2.surfaceIdentifier, v20)

	local v23 = useDescendantHasFocus(u15)
	local v24 = useAutoFocus({ u15 }, 0.1)
	local v25 = useLastInputMode() == "Focus"
	local v26 = t2.isAutoFocusRoot and (v20 and (v25 and (u15 and not v23)))

	React.useEffect(function() -- line: 73
		-- upvalues: v26 (copy), v24 (copy)
		local u28 = nil

		if v26 then
			u28 = v24()
		end

		return function() -- line: 78
			-- upvalues: u28 (ref)
			if u28 then
				u28.cancel()
			end
		end
	end, {
		v26,
		v24
	})

	local v27 = React.useRef(u15)

	React.useEffect(function() -- line: 86
		-- upvalues: u15 (ref), v27 (copy)
		if u15 then
			v27.current = u15
		end
	end, { u15 })
	React.useEffect(function() -- line: 92
		-- upvalues: v27 (copy), GuiService (copy)
		return function() -- line: 93
			-- upvalues: v27 (copy), GuiService (copy)
			if not v27.current then
				return
			end

			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject then
				return
			end

			if SelectedCoreObject:IsDescendantOf(v27.current) or not SelectedCoreObject:IsDescendantOf(game) then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, {})

	return if not v21 then v19 else v22
end

return useFocusRoot
