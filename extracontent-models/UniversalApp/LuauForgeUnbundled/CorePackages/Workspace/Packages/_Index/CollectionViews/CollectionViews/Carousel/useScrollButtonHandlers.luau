local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")

local function useScrollButtonHandlers(p2, p3, p4, p5, object, p6, value)
	ArgCheck.assert(p5 >= 1)
	ArgCheck.assert(p3 >= 0)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(p4)

	local ref = React.useRef(0)
	local v5 = math.max(0, p3 - p5)

	local ref2 = React.useRef(nil)

	local v6 = React.useCallback(function(p7)
		ref.current = math.max(0, (math.min(v5, p7)))
		return ref.current
	end, { v5, ref })

	local v7 = React.useCallback(function()
		if p4 then
			setState(ref.current > 0)
			setState2(ref.current < v5)
		else
			setState(false)
			setState2(false)
		end
	end, { p4, v5, ref })

	local v8 = React.useCallback(function(p7, p8)
		local current = p2.current

		if current ~= nil then
			local v9 = p7 * (object:getValue().X + p6)
			local canvasPosition = current.CanvasPosition
			local vector2 = Vector2.new(v9, canvasPosition.Y)

			if p8 and not UserGameSettings.ReducedMotion then
				if ref2.current then
					ref2.current:Cancel()
				end

				ref2.current = TweenService:Create(
					current,
					TweenInfo.new(value or 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut),
					{ CanvasPosition = vector2 }
				):Play()
			else
				current.CanvasPosition = vector2
				v7()
			end
		end
	end, { v7, object, p6, ref2, value, p2 })

	local v9 = React.useCallback(function()
		v8(v6(ref.current - p5), true)
	end, { v8, v6, p5, ref })

	local v10 = React.useCallback(function()
		v8(v6(ref.current + p5), true)
	end, { v8, v6, p5, ref })

	React.useEffect(function()
		v6(ref.current)

		if p4 then
			v8(ref.current)
		end

		v7()
	end, { v6, v8, p4 })

	React.useEffect(function()
		if not p4 then
			return nil
		end

		local connections = {}

		if p2.current ~= nil then
			local current = p2.current
			table.insert(connections, current:GetPropertyChangedSignal("CanvasSize"):Connect(function()
				v6(ref.current)
				v8(ref.current)
				v7()
			end))

			table.insert(connections, current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				v6(ref.current)
				v7()
			end))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v8, ref, p2, p4, v6 })

	return v9, v10, state, state2
end

return useScrollButtonHandlers
