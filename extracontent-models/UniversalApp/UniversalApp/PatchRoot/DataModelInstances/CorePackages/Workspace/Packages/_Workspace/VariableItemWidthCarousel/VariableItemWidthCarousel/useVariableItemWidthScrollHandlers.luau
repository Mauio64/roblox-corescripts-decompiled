local VariableItemWidthCarousel = script:FindFirstAncestor("VariableItemWidthCarousel")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local TweenService = game:GetService("TweenService")
local VariableItemWidthCarouselParent = VariableItemWidthCarousel.Parent
local React = require(VariableItemWidthCarouselParent.React)

local function clampTargetCanvasPosition(p1, n1: number) -- line: 8
	return Vector2.new(math.round((math.clamp(n1, 0, p1.AbsoluteCanvasSize.X - p1.AbsoluteSize.X))), 0)
end

function useVariableItemWidthScrollHandlers(t1: {[any]: any}, n2: number, p2: ((...any) -> ...any), t2: {[any]: any}, n3: number?) -- line: 15
	-- upvalues: React (copy), UserGameSettings (copy), TweenService (copy), clampTargetCanvasPosition (copy)
	local v14 = React.useRef(nil)
	local v15 = React.useRef(0)
	local v16 = React.useRef(0)
	local v17, v18 = React.useState(false)
	local v19, v20 = React.useState(true)
	local v21, v22 = React.useState(Vector2.zero)
	local v23 = React.useMemo(function() -- line: 28
		-- upvalues: t1 (copy), p2 (copy)
		local t3 = {
			[0] = 0
		}

		for i, _ in ipairs(t1) do
			t3[i] = p2(i)
		end

		return t3
	end, {
		t1,
		p2
	})

	React.useEffect(function() -- line: 36
		-- upvalues: t2 (copy), v22 (copy)
		local connection = nil

		if t2.current then
			local current = t2.current

			v22(current.AbsoluteSize)
			connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 44
				-- upvalues: v22 (copy), current (copy)
				v22(current.AbsoluteSize)
			end)
		end

		return function() -- line: 49
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { t2 })

	local v24 = React.useCallback(function(p3, vector2: Vector2) -- line: 57
		-- upvalues: v14 (copy), v15 (copy), UserGameSettings (copy), n3 (copy), TweenService (copy)
		if v14.current then
			v14.current:Cancel()
		end

		v15.current = vector2.X

		if UserGameSettings.ReducedMotion then
			p3.CanvasPosition = vector2

			return
		end

		local tweenInfo = TweenInfo.new(n3 or 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

		v14.current = TweenService:Create(p3, tweenInfo, {
			CanvasPosition = vector2
		}):Play()
	end, {
		UserGameSettings.ReducedMotion,
		n3
	})
	local v25 = React.useCallback(function() -- line: 73
		-- upvalues: t2 (copy), v18 (copy), v15 (copy), v20 (copy), v21 (copy)
		local current = t2.current

		if current then
			v18(v15.current > 0)
			v20(v15.current < current.AbsoluteCanvasSize.X - v21.X)

			return
		end

		v18(false)
		v20(false)
	end, {
		v18,
		v20,
		v21
	})
	local v26 = React.useCallback(function(_) -- line: 84
		-- upvalues: t1 (copy), v23 (copy), n2 (copy), v21 (copy)
		local n4 = 0

		for i = #t1, 1, -1 do
			local v42 = v23[i]

			n4 += v42 + (v42 > 0 and n2 or 0)

			if n4 >= v21.X then
				return i
			end
		end

		return 1
	end, {
		t1,
		v23,
		n2,
		v21
	})
	local v27 = React.useCallback(function(p5, n5: number) -- line: 97
		-- upvalues: v21 (copy), v16 (copy), t1 (copy), v23 (copy), n2 (copy), v26 (copy)
		local X = v21.X
		local n6 = 0
		local current = v16.current
		local n7 = 0
		local n8 = 0

		for i = math.max(current, 1), #t1 do
			local v51 = v23[i]

			n8 += v51 + (v51 > 0 and n2 or 0)

			if X <= n8 then
				break
			end

			n7 += 1
		end

		local v52 = math.clamp(math.max(1, n7) * n5, -#t1, #t1)

		for i = 0, math.clamp(current + v52, 0, #t1) do
			local v54 = v23[i]

			n6 += v54 + (v54 > 0 and n2 or 0)
		end

		local v55 = math.clamp(current + v52, 0, v26(p5))

		return Vector2.new(math.round((math.clamp(n6, 0, p5.AbsoluteCanvasSize.X - p5.AbsoluteSize.X))), 0), v55
	end, {
		t1,
		v23,
		n2,
		clampTargetCanvasPosition,
		v26,
		v21
	})
	local v28 = React.useCallback(function() -- line: 132
		-- upvalues: t2 (copy), v27 (copy), v16 (copy), v24 (copy), v25 (copy)
		local current = t2.current

		if current then
			local v57, v58 = v27(current, -1)

			v16.current = v58
			v24(current, v57)
			v25()
		end
	end, {
		v24,
		v25,
		v27
	})
	local v29 = React.useCallback(function() -- line: 149
		-- upvalues: t2 (copy), v27 (copy), v16 (copy), v24 (copy), v25 (copy)
		local current = t2.current

		if current then
			local v60, v61 = v27(current, 1)

			v16.current = v61
			v24(current, v60)
			v25()
		end
	end, {
		v24,
		v25,
		v27
	})

	React.useEffect(v25, { v25 })

	return v28, v29, v17, v19, v25
end

return useVariableItemWidthScrollHandlers
