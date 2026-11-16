local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ReactUtils = require(parent2.ReactUtils)
local useForwardRef = ReactUtils.useForwardRef
local ControlState = require(parent.Core.Control.Enum.ControlState)
local ControlStateEvent = require(parent.Core.Control.Enum.ControlStateEvent)

local createGuiControlStateTable = require(parent.Core.Control.createGuiControlStateTable)

local function useGuiControlState(p, callback, current: boolean)
	local ref = React.useRef(ControlState.Initialize)
	local ref2 = React.useRef(current)

	local ref3 = React.useRef(false)

	local v = React.useCallback(function(p2, current2)
		ref.current = current2
		callback(p2, current2)
	end, { callback })

	local v2 = React.useMemo(function()
		return createGuiControlStateTable(v)
	end, {})

	React.useEffect(function()
		v2:onStateChange(v)
	end, { v })

	local v3 = React.useCallback(function(data)
		local connections = {}

		if data then
			table.insert(connections, data.InputBegan:Connect(function(input)
				if not ref2.current then
					return nil
				end

				if
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
					or input.KeyCode == Enum.KeyCode.ButtonA
					or input.KeyCode == Enum.KeyCode.Return
				then
					v2.events[ControlStateEvent.PrimaryPressed]()
				end
			end))

			table.insert(connections, data.InputEnded:Connect(function(input)
				if not ref2.current then
					return nil
				end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					v2.events[ControlStateEvent.PrimaryReleasedHover]()
				elseif
					input.UserInputType == Enum.UserInputType.Touch
					or input.KeyCode == Enum.KeyCode.ButtonA
					or input.KeyCode == Enum.KeyCode.Return
				then
					v2.events[ControlStateEvent.PrimaryReleased]()
				end
			end))

			table.insert(connections, data.SelectionGained:Connect(function()
				if not ref2.current then
					return nil
				end

				v2.events[ControlStateEvent.SelectionGained]()
			end))

			table.insert(connections, data.SelectionLost:Connect(function()
				if not ref2.current then
					return nil
				end

				v2.events[ControlStateEvent.SelectionLost]()
			end))

			table.insert(connections, data.MouseEnter:Connect(function()
				if not ref2.current then
					return nil
				end

				ref3.current = true
				v2.events[ControlStateEvent.PointerHover]()
			end))

			table.insert(connections, data.MouseLeave:Connect(function()
				if not ref2.current then
					return nil
				end

				ref3.current = false
				v2.events[ControlStateEvent.PointerHoverEnd]()
			end))
		end

		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
		end
	end, { v2, ref3 })

	React.useEffect(function()
		ref2.current = current
	end, { current })

	return useForwardRef(p, v3), v2
end

return useGuiControlState
