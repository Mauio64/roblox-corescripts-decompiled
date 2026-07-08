local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useForwardRef = require(FoundationParent.ReactUtils).useForwardRef
local ControlState = require(Foundation.Enums.ControlState)

require(Foundation.Enums.ControlStateEvent)
require(Foundation.Components.Types)

local t1 = {
	[Enum.GuiState.Idle] = ControlState.Default,
	[Enum.GuiState.Hover] = ControlState.Hover,
	[Enum.GuiState.Press] = ControlState.Pressed,
	[Enum.GuiState.NonInteractable] = ControlState.Disabled
}

local function useGuiControlState(p1, p2) -- line: 22
	-- upvalues: React (copy), ControlState (copy), t1 (copy), useForwardRef (copy)
	local v10 = React.useRef(false)
	local v11 = React.useRef(ControlState.Initialize)
	local v12 = React.useCallback(function(p3) -- line: 26
		-- upvalues: v11 (copy), v10 (copy), ControlState (copy), p2 (copy)
		local current = v11.current

		if v10.current then
			if p3 == ControlState.Default or p3 == ControlState.Hover then
				p3 = ControlState.Selected
			elseif p3 == ControlState.Pressed then
				p3 = ControlState.SelectedPressed
			end
		end

		if current == p3 then
			return
		end

		v11.current = p3

		if p2 ~= nil then
			p2(p3)
		end
	end, { p2 })
	local v13 = React.useCallback(function(p4) -- line: 48
		-- upvalues: v12 (copy), t1 (copy), v10 (copy), v11 (copy)
		local t2 = {}

		if p4 then
			v12(t1[p4.GuiState])
			table.insert(t2, p4:GetPropertyChangedSignal("GuiState"):Connect(function() -- line: 55
				-- upvalues: t1 (copy), p4 (copy), v12 (copy)
				local v18 = t1[p4.GuiState]

				v12(v18)
			end))
			table.insert(t2, p4.SelectionGained:Connect(function() -- line: 64
				-- upvalues: v10 (copy), v12 (copy), v11 (copy)
				v10.current = true
				v12(v11.current)
			end))
			table.insert(t2, p4.SelectionLost:Connect(function() -- line: 71
				-- upvalues: v10 (copy), v12 (copy), v11 (copy)
				v10.current = false
				v12(v11.current)
			end))
		end

		return function() -- line: 78
			-- upvalues: t2 (copy)
			for _, v20 in t2 do
				v20:Disconnect()
			end
		end
	end, { v12 })

	return useForwardRef(p1, v13)
end

return useGuiControlState
