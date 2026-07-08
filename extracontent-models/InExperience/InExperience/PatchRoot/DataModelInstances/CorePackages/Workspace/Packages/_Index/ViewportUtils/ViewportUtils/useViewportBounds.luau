local Parent = script:FindFirstAncestor("ViewportUtils").Parent
local Display = require(Parent.Display)
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local SharedFlags = require(Parent.SharedFlags)
local v7 = game:DefineFastFlag("LuaAppFixFrameBoundsImpressions", false)
local v8 = game:DefineFastInt("LuaAppUpdateImpressionsViewportBoundsPositionThreshold", 50)
local v9 = game:DefineFastFlag("LuaAppThrottleViewportBoundsScreenSize", false)
local v10 = game:DefineFastInt("LuaAppViewportBoundsScreenSizeThreshold", 50)
local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local v12 = game:DefineFastFlag("LuaAppUseViewportBoundsInsetFix", false)

local function boundsEqual(t1: {[any]: any}, t2: {[any]: any}) -- line: 30
	return t1.min == t2.min and t1.max == t2.max
end
local function screenSizeBoundsEqual(t3: {[any]: any}, t4: {[any]: any}) -- line: 34
	-- upvalues: v10 (copy)
	local v21 = v10

	return v21 > math.abs(t3.max.X - t4.max.X) and (v21 > math.abs(t3.max.Y - t4.max.Y) and (t3.min.X == t4.min.X and t3.min.Y == t4.min.Y))
end

local t5 = {
	min = Vector2.zero,
	max = Vector2.zero
}

local function calculateClampedViewportBounds(vector2: Vector2?, vector2_2: Vector2?, t6: {[any]: any}) -- line: 44
	-- upvalues: v7 (copy), t5 (copy)
	local v25 = vector2 or Vector2.zero
	local v26 = v25 + (vector2_2 or Vector2.zero)
	local v27 = math.max(t6.min.X, v25.X)
	local v28 = math.min(t6.max.X, v26.X)
	local v29 = math.max(t6.min.Y, v25.Y)
	local v30 = math.min(t6.max.Y, v26.Y)

	if v7 and (v28 <= v27 or v30 <= v29) then
		return t5
	end

	return {
		min = Vector2.new(v27, v29),
		max = Vector2.new(v28, v30)
	}
end

return function(t7: {[any]: any}?, b1: boolean?) -- line: 65
	-- upvalues: v9 (copy), React (copy), Signals (copy), Display (copy), v12 (copy), screenSizeBoundsEqual (copy), SignalsReact (copy), t5 (copy), v7 (copy), calculateClampedViewportBounds (copy), v8 (copy), v10 (copy), FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions (copy)
	local u34

	if v9 then
		local v33 = React.useMemo(function() -- line: 69
			-- upvalues: Signals (copy), Display (copy), v12 (copy), b1 (copy), screenSizeBoundsEqual (copy)
			return Signals.createComputed(function(p1) -- line: 70
				-- upvalues: Display (copy), v12 (copy), b1 (copy)
				local v52 = Display.GetDisplayStore(p1)
				local v53 = v52.getViewportSize(p1)
				local v54 = v52.getTopBarHeight(p1)
				local v55 = if not v12 then v52.getGuiInset(p1) else nil

				return {
					min = Vector2.new(0, v54),
					max = Vector2.new(v53.X, if not v12 and not b1 then v53.Y - v55.bottom else v53.Y)
				}
			end, screenSizeBoundsEqual)
		end, { b1 })

		u34 = SignalsReact.useSignalState(v33)
	else
		local v35 = SignalsReact.useSignalState(function(p2) -- line: 91
			-- upvalues: Display (copy)
			return Display.GetDisplayStore(p2).getViewportSize(p2)
		end)
		local v36 = SignalsReact.useSignalState(function(p3) -- line: 94
			-- upvalues: Display (copy)
			return Display.GetDisplayStore(p3).getTopBarHeight(p3)
		end)
		local v37 = if not v12 then SignalsReact.useSignalState(function(p4) -- line: 99
			-- upvalues: Display (copy)
			return Display.GetDisplayStore(p4).getGuiInset(p4)
		end) else nil

		u34 = React.useMemo(function() -- line: 104
			-- upvalues: v36 (copy), v35 (copy), v12 (copy), b1 (copy), v37 (copy)
			return {
				min = Vector2.new(0, v36),
				max = Vector2.new(v35.X, if not v12 and not b1 then v35.Y - v37.bottom else v35.Y)
			}
		end, {
			v36,
			v35,
			if not v12 then v37 else nil,
			b1
		})
	end

	local v38, v39 = React.useState(t5)
	local v40 = if not v7 then v39 else React.useCallback(function(t8: {[any]: any}) -- line: 127
		-- upvalues: v39 (copy)
		v39(function(t9: {[any]: any}) -- line: 128
			-- upvalues: t8 (copy)
			local v57 = t8

			if t9.min == v57.min and t9.max == v57.max then
				return t9
			end

			return t8
		end)
	end, {})

	React.useEffect(function() -- line: 137
		-- upvalues: t7 (copy), v7 (copy), v9 (copy), v40 (copy), calculateClampedViewportBounds (copy), u34 (ref), v8 (copy), v10 (copy)
		local t10 = {}
		local current = nil

		if t7 then
			current = t7.current
		end

		if current then
			local AbsolutePosition = current.AbsolutePosition
			local AbsoluteSize = current.AbsoluteSize
			local u49 = if not v7 then nil else AbsolutePosition
			local u50 = if not v9 then nil else AbsoluteSize

			v40((calculateClampedViewportBounds(AbsolutePosition, AbsoluteSize, u34)))
			table.insert(t10, current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 160
				-- upvalues: AbsolutePosition (ref), current (ref), v7 (copy), v8 (copy), u49 (ref), v40 (copy), calculateClampedViewportBounds (copy), AbsoluteSize (ref), u34 (ref)
				AbsolutePosition = current.AbsolutePosition

				if v7 then
					local v58 = v8
					local v59 = AbsolutePosition - u49

					if v58 > math.abs(v59.X) and v58 > math.abs(v59.Y) then
						return
					end

					u49 = AbsolutePosition
				end

				v40((calculateClampedViewportBounds(AbsolutePosition, AbsoluteSize, u34)))
			end))
			table.insert(t10, current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 183
				-- upvalues: AbsoluteSize (ref), current (ref), v9 (copy), v10 (copy), u50 (ref), v40 (copy), calculateClampedViewportBounds (copy), AbsolutePosition (ref), u34 (ref)
				AbsoluteSize = current.AbsoluteSize

				if v9 then
					local v60 = v10
					local v61 = AbsoluteSize - u50

					if v60 > math.abs(v61.X) and v60 > math.abs(v61.Y) then
						return
					end

					u50 = AbsoluteSize
				end

				v40((calculateClampedViewportBounds(AbsolutePosition, AbsoluteSize, u34)))
			end))
		else
			v40(u34)
		end

		return function() -- line: 204
			-- upvalues: t10 (copy)
			for _, v63 in t10 do
				v63:Disconnect()
			end
		end
	end, {
		t7,
		u34
	})

	return v38, if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then nil else u34
end
