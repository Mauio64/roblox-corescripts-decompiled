local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local parent = FocusNavigationUtils.Parent

local GuiService = game:GetService("GuiService")

local React = require(parent.React)

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)

local useFocusNavigableSurfaceRegistryConnection = require(FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection)
local useAutoFocus = require(FocusNavigationUtils.useAutoFocus)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local useLastInputMode = require(FocusNavigationUtils.useLastInputMode)

local v = {}

local function useFocusRoot(data)
	local state, setState = React.useState(nil)

	local eventMap = data.eventMap or v
	local v2 = ReactFocusNavigation.useEventMap(eventMap, setState)
	local eventHandlers = data.eventHandlers or v
	local v3 = ReactFocusNavigation.useEventHandlerMap(eventHandlers, v2)

	local v4 = data.isFocusable == nil or data.isFocusable
	local v5 = data.shouldRestoreFocus == nil or data.shouldRestoreFocus
	local v6 = ReactFocusNavigation.useMostRecentFocusBehavior(v3)

	if v5 then
		v3 = v6
	end

	useFocusNavigableSurfaceRegistryConnection(state, data.surfaceIdentifier, v4)

	local v7 = useDescendantHasFocus(state)
	local v8 = useAutoFocus({ state }, 0.1)
	local v9 = useLastInputMode() == "Focus"
	local v10 = data.isAutoFocusRoot and v4 and v9 and state and not v7

	React.useEffect(function()
		local v11

		if v10 then
			v11 = v8()
		else
			v11 = nil
		end

		return function()
			if v11 then
				v11.cancel()
			end
		end
	end, { v10, v8 })

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

			if selectedCoreObject:IsDescendantOf(ref.current) or not selectedCoreObject:IsDescendantOf(game) then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, {})

	return v3
end

return useFocusRoot
