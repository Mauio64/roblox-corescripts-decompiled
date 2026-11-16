local GuiService = game:GetService("GuiService")

local module = require("@luauforge/bundled/fCW")
local module2 = require("@luauforge/bundled/fCT")
local focusNavigableSurfaceIdentifierEnum = module2.FocusNavigableSurfaceIdentifierEnum
local useAutoFocus = module2.useAutoFocus
local useDescendantHasFocus = module2.useDescendantHasFocus
local useFocusNavigableSurfaceRegistryConnection = module2.useFocusNavigableSurfaceRegistryConnection
local useLastInputMode = module2.useLastInputMode

local function findSelectableAncestor(guiObject, state)
	while guiObject do
		if guiObject:IsA("GuiObject") and guiObject.Selectable then
			return guiObject
		end

		if guiObject == state then
			break
		end

		guiObject = guiObject.Parent
	end

	return nil
end

local function useModalFocus(p2)
	local state, setState = module.useState(nil)
	local v5 = p2 ~= false
	useFocusNavigableSurfaceRegistryConnection(state, focusNavigableSurfaceIdentifierEnum.PopUp, v5)

	local state2, setState2 = module.useState(nil)

	module.useEffect(function()
		if not state then
			setState2(nil)
			return
		end

		local function resolve()
			local textBox = state:FindFirstChildWhichIsA("TextBox", true)
			local v7 = if textBox then findSelectableAncestor(textBox, state) else nil
			setState2(v7)
		end

		local textBox = state:FindFirstChildWhichIsA("TextBox", true)
		local v7 = if textBox then findSelectableAncestor(textBox, state) else nil
		setState2(v7)

		local descendantAddedConnection = state.DescendantAdded:Connect(function(textBox2)
			if textBox2:IsA("TextBox") then
				local textBox3 = state:FindFirstChildWhichIsA("TextBox", true)
				local v9 = if textBox3 then findSelectableAncestor(textBox3, state) else nil
				setState2(v9)
			end
		end)

		return function()
			descendantAddedConnection:Disconnect()
		end
	end, { state, setState2 })

	local v6 = module.useMemo(function()
		return { state2 or state }
	end, { state2, state })

	local v7 = useDescendantHasFocus(state)
	local v8 = useAutoFocus(v6, 0.1)

	local v9 = useLastInputMode()

	if v5 then
		v5 = v9 == "Focus" and state ~= nil and not v7
	end

	module.useEffect(function()
		local v10 = if v5 then v8() else nil

		return function()
			if v10 then
				v10.cancel()
			end
		end
	end, { v5, v8 })

	local ref = module.useRef(state)
	module.useEffect(function()
		if state then
			ref.current = state
		end
	end, { state })

	module.useEffect(function()
		return function()
			local current = ref.current

			if not current then
				return
			end

			local selectedCoreObject = GuiService.SelectedCoreObject

			if not selectedCoreObject then
				return
			end

			if
				selectedCoreObject:IsDescendantOf(current)
				or not selectedCoreObject:IsDescendantOf(game)
			then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, {})

	return setState
end

return useModalFocus
