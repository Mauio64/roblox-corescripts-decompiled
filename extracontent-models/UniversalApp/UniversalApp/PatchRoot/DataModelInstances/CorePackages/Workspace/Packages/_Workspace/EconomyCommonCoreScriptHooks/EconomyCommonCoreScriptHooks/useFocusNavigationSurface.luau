local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(Parent.React)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local useLastInputMethod = FocusNavigationUtils.useLastInputMethod
local useAutoFocus = FocusNavigationUtils.useAutoFocus
local useDescendantHasFocus = FocusNavigationUtils.useDescendantHasFocus

local function useFocusNavigationSurface(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), useRegisterFocusNavigableSurface (copy), useDeRegisterFocusNavigableSurface (copy), useAutoFocus (copy), useDescendantHasFocus (copy), useLastInputMethod (copy), GuiService (copy)
	local v13, v14 = React.useState(nil)
	local v15 = useRegisterFocusNavigableSurface()
	local v16 = useDeRegisterFocusNavigableSurface()
	local v17 = useAutoFocus({ v13 }, 0.1)
	local v18 = useDescendantHasFocus(v13)
	local v19 = useLastInputMethod()
	local v20 = v19 == "Gamepad" or v19 == "Keyboard"

	React.useEffect(function() -- line: 31
		-- upvalues: v13 (copy), v15 (copy), t1 (copy), GuiService (copy), v16 (copy)
		if v13 then
			v15(t1.focusNavigableSurfaceIdentifier, v13)
			GuiService:AddSelectionParent(t1.selectionGroupName, v13)
		else
			v16(t1.focusNavigableSurfaceIdentifier, v13)
			GuiService:RemoveSelectionGroup(t1.selectionGroupName)
			GuiService.SelectedCoreObject = nil
		end

		return function() -- line: 42
			-- upvalues: v16 (copy), t1 (copy), v13 (copy), GuiService (copy)
			v16(t1.focusNavigableSurfaceIdentifier, v13)
			GuiService:RemoveSelectionGroup(t1.selectionGroupName)
			GuiService.SelectedCoreObject = nil
		end
	end, {
		v13,
		t1.focusNavigableSurfaceIdentifier,
		t1.selectionGroupName
	})

	local v21 = v20 and (v13 and not v18)

	React.useEffect(function() -- line: 52
		-- upvalues: v21 (copy), v17 (copy)
		local u22 = nil

		if v21 then
			u22 = v17()
		end

		return function() -- line: 57
			-- upvalues: u22 (ref)
			if u22 then
				u22.cancel()
			end
		end
	end, {
		v21,
		v17
	})

	return v14
end

return useFocusNavigationSurface
