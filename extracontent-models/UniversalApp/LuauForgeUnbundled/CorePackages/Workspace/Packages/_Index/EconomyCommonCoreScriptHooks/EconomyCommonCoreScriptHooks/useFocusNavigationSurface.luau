local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EconomyCommonCoreScriptHooks/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/EconomyCommonCoreScriptHooks/FocusNavigationUtils")
local focusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local useLastInputMethod = FocusNavigationUtils.useLastInputMethod
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus

local function useFocusNavigationSurface(p2)
	local state, setState = React.useState(nil)
	local v5 = useRegisterFocusNavigableSurface()
	local v6 = useDeRegisterFocusNavigableSurface()
	local v7 = useAutoFocus({ state }, 0.1)
	local v8 = useDescendantHasFocus(state)
	local v9 = useLastInputMethod()
	local v10 = v9 == "Gamepad" or v9 == "Keyboard"

	React.useEffect(function()
		if state then
			v5(p2.focusNavigableSurfaceIdentifier, state)
			GuiService:AddSelectionParent(p2.selectionGroupName, state)
		else
			v6(p2.focusNavigableSurfaceIdentifier, state)

			GuiService:RemoveSelectionGroup(p2.selectionGroupName)
			GuiService.SelectedCoreObject = nil
		end

		return function()
			v6(p2.focusNavigableSurfaceIdentifier, state)

			GuiService:RemoveSelectionGroup(p2.selectionGroupName)
			GuiService.SelectedCoreObject = nil
		end
	end, { state, p2.focusNavigableSurfaceIdentifier, p2.selectionGroupName })
	local v11 = v10 and state and not v8
	React.useEffect(function()
		local v12 = if v11 then v7() else nil

		return function()
			if v12 then
				v12.cancel()
			end
		end
	end, { v11, v7 })

	return setState
end

return useFocusNavigationSurface
