local GuiService = game:GetService("GuiService")
local parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local useLastInputMethod = FocusNavigationUtils.useLastInputMethod
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus

local function useFocusNavigationSurface(p)
	local state, setState = React.useState(nil)
	local v = useRegisterFocusNavigableSurface()
	local v2 = useDeRegisterFocusNavigableSurface()
	local v3 = useAutoFocus({ state }, 0.1)
	local v4 = useDescendantHasFocus(state)
	local v5 = useLastInputMethod()
	local v6 = v5 == "Gamepad" or v5 == "Keyboard"

	React.useEffect(function()
		if state then
			v(p.focusNavigableSurfaceIdentifier, state)
			GuiService:AddSelectionParent(p.selectionGroupName, state)
		else
			v2(p.focusNavigableSurfaceIdentifier, state)

			GuiService:RemoveSelectionGroup(p.selectionGroupName)
			GuiService.SelectedCoreObject = nil
		end

		return function()
			v2(p.focusNavigableSurfaceIdentifier, state)

			GuiService:RemoveSelectionGroup(p.selectionGroupName)
			GuiService.SelectedCoreObject = nil
		end
	end, { state, p.focusNavigableSurfaceIdentifier, p.selectionGroupName })
	local v7 = v6 and state and not v4
	React.useEffect(function()
		local v8

		if v7 then
			v8 = v3()
		else
			v8 = nil
		end

		return function()
			if v8 then
				v8.cancel()
			end
		end
	end, { v7, v3 })

	return setState
end

return useFocusNavigationSurface
