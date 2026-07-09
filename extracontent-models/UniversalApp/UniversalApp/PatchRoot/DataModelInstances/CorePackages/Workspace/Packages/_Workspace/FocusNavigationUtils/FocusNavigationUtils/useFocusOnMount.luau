local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)
local useFocusGuiObject = require(Parent.ReactFocusNavigation).useFocusGuiObject
local Responsive = require(Parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input
local useDescendantHasFocus = require(script.Parent.useDescendantHasFocus)

local function useFocusOnMount(p1, b1: boolean?) -- line: 30
	-- upvalues: useFocusGuiObject (copy), React (copy), usePreferredInput (copy), Input (copy), useIsSpatial (copy), CoreGui (copy), useDescendantHasFocus (copy)
	local v13 = b1 == nil or b1
	local v14 = useFocusGuiObject()
	local v15, v16 = React.useState(nil)
	local v17 = React.useCallback(function(p2) -- line: 38
		-- upvalues: p1 (copy), v16 (copy)
		if p1 then
			if type(p1) == "function" then
				p1(p2)
			elseif type(p1) == "table" then
				p1.current = p2
			end
		end

		if p2 == nil then
			v16(nil)

			return
		end

		if not p2:IsA("GuiObject") then
			warn("useFocusOnMount: ref is not a GuiObject")

			return
		end

		v16(p2)
	end, { p1 })
	local v18 = usePreferredInput() == Input.Directional
	local v19 = useIsSpatial()
	local v20 = React.useCallback(function(p3) -- line: 61
		-- upvalues: CoreGui (copy), v18 (copy), v19 (copy), v14 (copy)
		if not p3:IsDescendantOf(CoreGui) then
			return
		end

		if v18 and not v19 then
			v14(p3)
		end
	end, {
		v18,
		v19,
		v14
	})
	local v21 = React.useRef(false)
	local v22 = React.useRef(false)
	local v23 = useDescendantHasFocus(v15)
	local v24 = React.useRef(nil)

	React.useEffect(function() -- line: 75
		-- upvalues: v15 (copy), v21 (copy), v22 (copy), v20 (copy), v13 (copy), v23 (copy), v24 (copy)
		if not v15 then
			v21.current = false
			v22.current = false

			return
		end

		if not v21.current then
			v20(v15)
			v21.current = true
		end

		if v13 and not v22.current and v23 then
			v22.current = true
		end

		local v27 = if not v13 or v22.current then nil else v15.DescendantAdded:Connect(function(descendant) -- line: 98
			-- upvalues: v24 (copy), v20 (copy), v15 (copy)
			if not v24.current and (descendant:IsA("GuiObject") and descendant.Selectable) then
				v24.current = task.delay(0.1, function() -- line: 100
					-- upvalues: v20 (copy), v15 (copy), v24 (copy)
					v20(v15)
					v24.current = nil
				end)
			end
		end)

		return function() -- line: 107
			-- upvalues: v27 (copy), v24 (copy)
			if v27 then
				v27:Disconnect()
			end

			if v24.current then
				task.cancel(v24.current)
				v24.current = nil
			end
		end
	end, {
		v15,
		v13,
		v20,
		v23
	})

	return v17
end

return useFocusOnMount
