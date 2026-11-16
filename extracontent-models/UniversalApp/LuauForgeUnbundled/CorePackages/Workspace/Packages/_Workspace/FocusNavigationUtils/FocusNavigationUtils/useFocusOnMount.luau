local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation").useFocusGuiObject
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Responsive")
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local input = Responsive.Input
local useDescendantHasFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useDescendantHasFocus")

local function useFocusOnMount(callback, p2)
	local v5 = p2 == nil or p2

	local v6 = useFocusGuiObject()
	local state, setState = React.useState(nil)

	local v7 = React.useCallback(function(guiObject)
		if callback then
			if type(callback) == "function" then
				callback(guiObject)
			elseif type(callback) == "table" then
				callback.current = guiObject
			end
		end

		if guiObject == nil then
			setState(nil)
		elseif guiObject:IsA("GuiObject") then
			setState(guiObject)
		else
			warn("useFocusOnMount: ref is not a GuiObject")
		end
	end, { callback })

	local v8 = usePreferredInput() == input.Directional
	local v9 = useIsSpatial()

	local v10 = React.useCallback(function(instance)
		if not instance:IsDescendantOf(CoreGui) then
			return
		end

		if v8 and not v9 then
			v6(instance)
		end
	end, { v8, v9, v6 })

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local v11 = useDescendantHasFocus(state)
	local ref3 = React.useRef(nil)

	React.useEffect(function()
		if state then
			if not ref.current then
				v10(state)
				ref.current = true
			end

			if v5 and not ref2.current and v11 then
				ref2.current = true
			end

			local descendantAddedConnection

			if v5 and not ref2.current then
				descendantAddedConnection = state.DescendantAdded:Connect(function(guiObject)
					if not ref3.current and guiObject:IsA("GuiObject") and guiObject.Selectable then
						ref3.current = task.delay(0.1, function()
							v10(state)
							ref3.current = nil
						end)
					end
				end)
			else
				descendantAddedConnection = nil
			end

			return function()
				if descendantAddedConnection then
					descendantAddedConnection:Disconnect()
				end

				if ref3.current then
					task.cancel(ref3.current)
					ref3.current = nil
				end
			end
		end

		ref.current = false
		ref2.current = false
	end, { state, v5, v10, v11 })

	return v7
end

return useFocusOnMount
