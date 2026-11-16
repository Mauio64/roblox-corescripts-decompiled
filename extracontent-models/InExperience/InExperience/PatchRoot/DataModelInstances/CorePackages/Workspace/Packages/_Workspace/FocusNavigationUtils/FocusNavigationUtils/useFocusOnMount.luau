local CoreGui = game:GetService("CoreGui")
local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input
local useDescendantHasFocus = require(script.Parent.useDescendantHasFocus)

local function useFocusOnMount(callback, flag: boolean?)
	local v = flag == nil or flag

	local v2 = useFocusGuiObject()
	local state, setState = React.useState(nil)

	local v3 = React.useCallback(function(guiObject)
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

	local v4 = usePreferredInput() == Input.Directional
	local v5 = useIsSpatial()

	local v6 = React.useCallback(function(instance)
		if not instance:IsDescendantOf(CoreGui) then
			return
		end

		if v4 and not v5 then
			v2(instance)
		end
	end, { v4, v5, v2 })

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local v7 = useDescendantHasFocus(state)
	local ref3 = React.useRef(nil)

	React.useEffect(function()
		if state then
			if not ref.current then
				v6(state)
				ref.current = true
			end

			if v and not ref2.current and v7 then
				ref2.current = true
			end

			local descendantAddedConnection

			if v and not ref2.current then
				descendantAddedConnection = state.DescendantAdded:Connect(function(guiObject)
					if not ref3.current and guiObject:IsA("GuiObject") and guiObject.Selectable then
						ref3.current = task.delay(0.1, function()
							v6(state)
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
	end, { state, v, v6, v7 })

	return v3
end

return useFocusOnMount
