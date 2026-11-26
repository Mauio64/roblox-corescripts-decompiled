local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation")
require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceIdentifierEnum")

local useFocusNavigableSurfaceRegistryConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useFocusNavigableSurfaceRegistryConnection")
local useAutoFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useAutoFocus")
local useDescendantHasFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useDescendantHasFocus")
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useLastInputMode")

local v5 = {}

local function useFocusRoot(data)
	local state, setState = React.useState(nil)

	local eventMap = data.eventMap or v5
	local v7 = ReactFocusNavigation.useEventMap(eventMap, setState)
	local eventHandlers = data.eventHandlers or v5
	local v8 = ReactFocusNavigation.useEventHandlerMap(eventHandlers, v7)

	local v9 = data.isFocusable == nil or data.isFocusable
	local v10 = data.shouldRestoreFocus == nil or data.shouldRestoreFocus
	local v11 = ReactFocusNavigation.useMostRecentFocusBehavior(v8)

	if v10 then
		v8 = v11
	end

	useFocusNavigableSurfaceRegistryConnection(state, data.surfaceIdentifier, v9)

	local v12 = useDescendantHasFocus(state)
	local v13 = useAutoFocus({ state }, 0.1)
	local v14 = useLastInputMode() == "Focus"
	local v15 = data.isAutoFocusRoot and v9 and v14 and state and not v12

	React.useEffect(function()
		local v16 = if v15 then v13() else nil

		return function()
			if v16 then
				v16.cancel()
			end
		end
	end, { v15, v13 })

	local ref = React.useRef(state)
	React.useEffect(function()
		if state then
			ref.current = state
		end
	end, { state })

	React.useEffect(function()
		return function()
			if not ref.current then
				return
			end

			local selectedCoreObject = GuiService.SelectedCoreObject

			if not selectedCoreObject then
				return
			end

			if
				selectedCoreObject:IsDescendantOf(ref.current)
				or not selectedCoreObject:IsDescendantOf(game)
			then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, {})

	return v8
end

return useFocusRoot
