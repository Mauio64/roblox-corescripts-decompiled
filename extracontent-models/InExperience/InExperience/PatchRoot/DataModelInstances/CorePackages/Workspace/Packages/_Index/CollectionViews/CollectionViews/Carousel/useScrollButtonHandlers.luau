local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local FFlagCollectionViewMathChanges = require(CollectionViewsParent.SharedFlags).FFlagCollectionViewMathChanges

require(CollectionViews.Carousel.calculateCarouselSpacingMetrics)

local function useScrollButtonHandlers(t1: {[any]: any}, n1: number, b1: boolean, n2: number, p1, n3: number, n4: number?, p2) -- line: 16
	-- upvalues: ArgCheck (copy), React (copy), FFlagCollectionViewMathChanges (copy), UserGameSettings (copy), TweenService (copy)
	ArgCheck.assert(n2 >= 1)
	ArgCheck.assert(n1 >= 0)

	local v17, v18 = React.useState(false)
	local v19, v20 = React.useState(b1)
	local v21 = React.useRef(0)
	local v22 = math.max(0, n1 - n2)
	local v23 = React.useRef(nil)
	local v24 = React.useCallback(function(n5: number?) -- line: 38
		-- upvalues: v21 (copy), v22 (copy)
		v21.current = math.max(0, (math.min(v22, n5)))

		return v21.current
	end, {
		v22,
		v21
	})
	local v25 = React.useCallback(function() -- line: 45
		-- upvalues: b1 (copy), v18 (copy), v20 (copy), v21 (copy), v22 (copy)
		if not b1 then
			v18(false)
			v20(false)

			return
		end

		v18(v21.current > 0)
		v20(v21.current < v22)
	end, {
		b1,
		v22,
		v21
	})
	local v26 = React.useCallback(function(n6: number, b2: boolean?) -- line: 63
		-- upvalues: t1 (copy), FFlagCollectionViewMathChanges (copy), n2 (copy), p2 (copy), p1 (copy), n3 (copy), UserGameSettings (copy), v23 (copy), TweenService (copy), n4 (copy), v25 (copy)
		local current = t1.current

		if current ~= nil then
			local v33

			if FFlagCollectionViewMathChanges then
				if n2 < 1 then
					return
				end

				v33 = math.floor(n6 * p2:getValue().stride + 0.5)
			else
				v33 = n6 * (p1:getValue().X + n3)
			end

			local CanvasPosition = current.CanvasPosition

			if FFlagCollectionViewMathChanges and math.abs(CanvasPosition.X - v33) < 1 then
				return
			end

			local vector2 = Vector2.new(v33, CanvasPosition.Y)

			if b2 and not UserGameSettings.ReducedMotion then
				if v23.current then
					v23.current:Cancel()
				end

				v23.current = TweenService:Create(current, TweenInfo.new(n4 or 0.75, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
					CanvasPosition = vector2
				}):Play()

				return
			end

			current.CanvasPosition = vector2
			v25()
		end
	end, {
		v25,
		if not FFlagCollectionViewMathChanges then p1 else p2,
		if not FFlagCollectionViewMathChanges then n3 else n2,
		v23,
		n4,
		t1
	})
	local v27 = React.useCallback(function() -- line: 113
		-- upvalues: v24 (copy), v21 (copy), n2 (copy), v26 (copy)
		local v36 = v24(v21.current - n2)

		v26(v36, true)
	end, {
		v26,
		v24,
		n2,
		v21
	})
	local v28 = React.useCallback(function() -- line: 118
		-- upvalues: v24 (copy), v21 (copy), n2 (copy), v26 (copy)
		local v37 = v24(v21.current + n2)

		v26(v37, true)
	end, {
		v26,
		v24,
		n2,
		v21
	})

	React.useEffect(function() -- line: 126
		-- upvalues: v24 (copy), v21 (copy), b1 (copy), v26 (copy), v25 (copy)
		v24(v21.current)

		if b1 then
			v26(v21.current)
		end

		v25()
	end, {
		v24,
		v26,
		b1
	})
	React.useEffect(function() -- line: 142
		-- upvalues: b1 (copy), t1 (copy), v24 (copy), v21 (copy), v26 (copy), v25 (copy)
		if not b1 then
			return nil
		end

		local t2 = {}

		if t1.current ~= nil then
			local current = t1.current

			table.insert(t2, current:GetPropertyChangedSignal("CanvasSize"):Connect(function() -- line: 152
				-- upvalues: v24 (copy), v21 (copy), v26 (copy), v25 (copy)
				v24(v21.current)
				v26(v21.current)
				v25()
			end))
			table.insert(t2, current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 161
				-- upvalues: v24 (copy), v21 (copy), v25 (copy)
				v24(v21.current)
				v25()
			end))
		end

		return function() -- line: 168
			-- upvalues: t2 (copy)
			for _, v41 in t2 do
				v41:Disconnect()
			end
		end
	end, {
		v26,
		v21,
		t1,
		b1,
		v24
	})

	return v27, v28, v17, v19
end

return useScrollButtonHandlers
