local UserGameSettings = UserSettings():GetService("UserGameSettings")
local TweenService = game:GetService("TweenService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/React")

local function clampTargetCanvasPosition(p2, value)
	return Vector2.new(math.round((math.clamp(value, 0, p2.AbsoluteCanvasSize.X - p2.AbsoluteSize.X))), 0)
end

function LUAUFORGE_MODULE_GLOBALS_cUP_useVariableItemWidthScrollHandlers(list, p2, callback, p3, value)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(0)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(Vector2.zero)
	local v5 = React.useMemo(function()
		local result = { [0] = 0 }

		for i, item in ipairs(list) do
			result[i] = callback(i)
		end

		return result
	end, { list, callback })

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if p3.current then
			local current = p3.current

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
	end, { p3 })

	local v6 = React.useCallback(function(instance, canvasPosition)
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

	local v7 = React.useCallback(function()
		local current = p3.current

		if current then
			setState(ref2.current > 0)
			setState2(ref2.current < current.AbsoluteCanvasSize.X - state3.X)
		else
			setState(false)
			setState2(false)
		end
	end, { setState, setState2, state3 })

	local v8 = React.useCallback(function(p4)
		local total = 0

		for i = #list, 1, -1 do
			local v9 = v5[i]
			total += v9 + (v9 > 0 and p2 or 0)

			if state3.X <= total then
				return i
			end
		end

		return 1
	end, { list, v5, p2, state3 })

	local v9 = React.useCallback(function(p4, p5)
		local x = state3.X

		local current = ref3.current
		local count = 0
		local total = 0
		local total2 = 0

		for i = math.max(current, 1), #list do
			local v10 = v5[i]
			total2 += v10 + (v10 > 0 and p2 or 0)

			if x <= total2 then
				break
			end

			count += 1
		end

		local v10 = math.clamp((math.max)(1, count) * p5, -#list, #list)

		for i = 0, math.clamp(current + v10, 0, #list) do
			local v11 = v5[i]
			total += v11 + (v11 > 0 and p2 or 0)
		end

		local v11 = math.clamp(current + v10, 0, v8(p4))
		return
			Vector2.new(math.round((math.clamp(total, 0, p4.AbsoluteCanvasSize.X - p4.AbsoluteSize.X))), 0),
			v11
	end, { list, v5, p2, clampTargetCanvasPosition, v8, state3 })

	local v10 = React.useCallback(function()
		local current = p3.current

		if current then
			local v11, v12 = v9(current, -1)
			ref3.current = v12
			v6(current, v11)
			v7()
		end
	end, { v6, v7, v9 })

	local v11 = React.useCallback(function()
		local current = p3.current

		if current then
			local v12, v13 = v9(current, 1)
			ref3.current = v13
			v6(current, v12)
			v7()
		end
	end, { v6, v7, v9 })

	React.useEffect(v7, { v7 })

	return v10, v11, state, state2, v7
end

return LUAUFORGE_MODULE_GLOBALS_cUP_useVariableItemWidthScrollHandlers
