local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)

local function useScrollButtonHandlers(p, p2: number, flag: boolean, p3: number, object, p4: number, value: number?)
	ArgCheck.assert(p3 >= 1)
	ArgCheck.assert(p2 >= 0)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(flag)

	local ref = React.useRef(0)
	local v = math.max(0, p2 - p3)

	local ref2 = React.useRef(nil)

	local v2 = React.useCallback(function(p5: number?)
		ref.current = math.max(0, (math.min(v, p5)))
		return ref.current
	end, { v, ref })

	local v3 = React.useCallback(function()
		if flag then
			setState(ref.current > 0)
			setState2(ref.current < v)
		else
			setState(false)
			setState2(false)
		end
	end, { flag, v, ref })

	local v4 = React.useCallback(function(p5: number, flag2: boolean?)
		local current = p.current

		if current ~= nil then
			local v4 = p5 * (object:getValue().X + p4)
			local canvasPosition = current.CanvasPosition
			local vector2 = Vector2.new(v4, canvasPosition.Y)

			if flag2 and not UserGameSettings.ReducedMotion then
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
				v3()
			end
		end
	end, { v3, object, p4, ref2, value, p })

	local v5 = React.useCallback(function()
		v4(v2(ref.current - p3), true)
	end, { v4, v2, p3, ref })

	local v6 = React.useCallback(function()
		v4(v2(ref.current + p3), true)
	end, { v4, v2, p3, ref })

	React.useEffect(function()
		v2(ref.current)

		if flag then
			v4(ref.current)
		end

		v3()
	end, { v2, v4, flag })

	React.useEffect(function()
		if not flag then
			return nil
		end

		local connections = {}

		if p.current ~= nil then
			local current = p.current
			table.insert(connections, current:GetPropertyChangedSignal("CanvasSize"):Connect(function()
				v2(ref.current)
				v4(ref.current)
				v3()
			end))

			table.insert(connections, current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				v2(ref.current)
				v3()
			end))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v4, ref, p, flag, v2 })

	return v5, v6, state, state2
end

return useScrollButtonHandlers
