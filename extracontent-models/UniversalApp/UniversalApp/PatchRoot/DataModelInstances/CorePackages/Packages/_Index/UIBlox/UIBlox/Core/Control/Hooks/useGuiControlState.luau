local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local useForwardRef = require(ParentParentParent.ReactUtils).useForwardRef
local ControlState = require(ParentParent.Core.Control.Enum.ControlState)
local ControlStateEvent = require(ParentParent.Core.Control.Enum.ControlStateEvent)
local createGuiControlStateTable = require(ParentParent.Core.Control.createGuiControlStateTable)

local function useGuiControlState(p1, p2, b1: boolean) -- line: 20
	-- upvalues: React (copy), ControlState (copy), createGuiControlStateTable (copy), ControlStateEvent (copy), useForwardRef (copy)
	local v12 = React.useRef(ControlState.Initialize)
	local v13 = React.useRef(b1)
	local v14 = React.useRef(false)
	local v15 = React.useCallback(function(p3, p4) -- line: 35
		-- upvalues: v12 (copy), p2 (copy)
		v12.current = p4
		p2(p3, p4)
	end, { p2 })
	local v16 = React.useMemo(function() -- line: 40
		-- upvalues: createGuiControlStateTable (copy), v15 (copy)
		return createGuiControlStateTable(v15)
	end, {})

	React.useEffect(function() -- line: 44
		-- upvalues: v16 (copy), v15 (copy)
		v16:onStateChange(v15)
	end, { v15 })

	local v17 = React.useCallback(function(p5) -- line: 48
		-- upvalues: v13 (copy), v16 (copy), ControlStateEvent (copy), v14 (copy)
		local t1 = {}

		if p5 then
			table.insert(t1, p5.InputBegan:Connect(function(input) -- line: 66
				-- upvalues: v13 (copy), v16 (copy), ControlStateEvent (copy)
				if not v13.current then
					return nil
				end

				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.Return then
					v16.events[ControlStateEvent.PrimaryPressed]()
				end
			end))
			table.insert(t1, p5.InputEnded:Connect(function(input) -- line: 82
				-- upvalues: v13 (copy), v16 (copy), ControlStateEvent (copy)
				if not v13.current then
					return nil
				end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					v16.events[ControlStateEvent.PrimaryReleasedHover]()

					return
				end

				if input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.Return then
					v16.events[ControlStateEvent.PrimaryReleased]()
				end
			end))
			table.insert(t1, p5.SelectionGained:Connect(function() -- line: 101
				-- upvalues: v13 (copy), v16 (copy), ControlStateEvent (copy)
				if not v13.current then
					return nil
				end

				v16.events[ControlStateEvent.SelectionGained]()
			end))
			table.insert(t1, p5.SelectionLost:Connect(function() -- line: 110
				-- upvalues: v13 (copy), v16 (copy), ControlStateEvent (copy)
				if not v13.current then
					return nil
				end

				v16.events[ControlStateEvent.SelectionLost]()
			end))
			table.insert(t1, p5.MouseEnter:Connect(function() -- line: 121
				-- upvalues: v13 (copy), v14 (copy), v16 (copy), ControlStateEvent (copy)
				if not v13.current then
					return nil
				end

				v14.current = true
				v16.events[ControlStateEvent.PointerHover]()
			end))
			table.insert(t1, p5.MouseLeave:Connect(function() -- line: 131
				-- upvalues: v13 (copy), v14 (copy), v16 (copy), ControlStateEvent (copy)
				if not v13.current then
					return nil
				end

				v14.current = false
				v16.events[ControlStateEvent.PointerHoverEnd]()
			end))
		end

		return function() -- line: 141
			-- upvalues: t1 (copy)
			for _, v in ipairs(t1) do
				v:Disconnect()
			end
		end
	end, {
		v16,
		v14
	})

	React.useEffect(function() -- line: 148
		-- upvalues: v13 (copy), b1 (copy)
		v13.current = b1
	end, { b1 })

	return useForwardRef(p1, v17), v16
end

return useGuiControlState
