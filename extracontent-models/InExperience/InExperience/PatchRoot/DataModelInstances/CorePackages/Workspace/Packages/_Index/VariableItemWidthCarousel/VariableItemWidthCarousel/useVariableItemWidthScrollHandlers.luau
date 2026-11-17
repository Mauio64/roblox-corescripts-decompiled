local VariableItemWidthCarousel = script:FindFirstAncestor("VariableItemWidthCarousel")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local TweenService = game:GetService("TweenService")
local parent = VariableItemWidthCarousel.Parent

local React = require(parent.React)

local function clampTargetCanvasPosition(p, value: number) -- 1 equivalent call inferred from this helper
	return Vector2.new(math.round((math.clamp(value, 0, p.AbsoluteCanvasSize.X - p.AbsoluteSize.X))), 0)
end

function useVariableItemWidthScrollHandlers(list, p: number, callback, p2, value: number?)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(0)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(Vector2.zero)
	local v = React.useMemo(function()
		local result = { [0] = 0 }

		for i, _ in ipairs(list) do
			result[i] = callback(i)
		end

		return result
	end, { list, callback })

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if p2.current then
			local current = p2.current

			setState3(current.AbsoluteSize)

			absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState3(current.AbsoluteSize)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { p2 })

	local v2 = React.useCallback(function(instance, canvasPosition: Vector2)
		if ref.current then
			ref.current:Cancel()
		end

		ref2.current = canvasPosition.X

		if UserGameSettings.ReducedMotion then
			instance.CanvasPosition = canvasPosition
			return
		end

		ref.current = TweenService:Create(
			instance,
			TweenInfo.new(value or 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut),
			{ CanvasPosition = canvasPosition }
		):Play()
	end, { UserGameSettings.ReducedMotion, value })

	local v3 = React.useCallback(function()
		local current = p2.current

		if current then
			setState(ref2.current > 0)
			setState2(ref2.current < current.AbsoluteCanvasSize.X - state3.X)
		else
			setState(false)
			setState2(false)
		end
	end, { setState, setState2, state3 })

	local v4 = React.useCallback(function(_)
		local total = 0

		for i = #list, 1, -1 do
			local v4 = v[i]
			total += v4 + (v4 > 0 and p or 0)

			if state3.X <= total then
				return i
			end
		end

		return 1
	end, { list, v, p, state3 })

	local v5 = React.useCallback(function(p3, p4: number)
		local x = state3.X

		local current = ref3.current
		local count = 0
		local total = 0
		local total2 = 0

		for i = math.max(current, 1), #list do
			local v5 = v[i]
			total2 += v5 + (v5 > 0 and p or 0)

			if x <= total2 then
				break
			end

			count += 1
		end

		local v5 = math.clamp(math.max(1, count) * p4, -#list, #list)

		for i = 0, math.clamp(current + v5, 0, #list) do
			local v6 = v[i]
			total += v6 + (v6 > 0 and p or 0)
		end

		local v6 = math.clamp(current + v5, 0, v4(p3))

		return clampTargetCanvasPosition(p3, total), v6 -- inferred equivalent call
	end, { list, v, p, clampTargetCanvasPosition, v4, state3 })

	local v6 = React.useCallback(function()
		local current = p2.current

		if current then
			local v6, current2 = v5(current, -1)
			ref3.current = current2
			v2(current, v6)
			v3()
		end
	end, { v2, v3, v5 })

	local v7 = React.useCallback(function()
		local current = p2.current

		if current then
			local v7, current2 = v5(current, 1)
			ref3.current = current2
			v2(current, v7)
			v3()
		end
	end, { v2, v3, v5 })

	React.useEffect(v3, { v3 })

	return v6, v7, state, state2, v3
end

return useVariableItemWidthScrollHandlers
