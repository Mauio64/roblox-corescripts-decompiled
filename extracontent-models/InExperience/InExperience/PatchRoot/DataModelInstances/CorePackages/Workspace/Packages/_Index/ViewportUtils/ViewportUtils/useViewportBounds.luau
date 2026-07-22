local Parent = script:FindFirstAncestor("ViewportUtils").Parent
local Display = require(Parent.Display)
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local SharedFlags = require(Parent.SharedFlags)
local intersectBounds = require(script.Parent.intersectBounds)
local useClipAncestorBounds = require(script.Parent.useClipAncestorBounds)
local v9 = game:DefineFastFlag("LuaAppFixFrameBoundsImpressions", false)
local FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold = SharedFlags.FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
local v11 = game:DefineFastFlag("LuaAppThrottleViewportBoundsScreenSize", false)
local FIntLuaAppViewportBoundsScreenSizeThreshold = SharedFlags.FIntLuaAppViewportBoundsScreenSizeThreshold
local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions
local v15 = game:DefineFastFlag("LuaAppUseViewportBoundsInsetFix", false)

local function boundsEqual(t1: {[any]: any}, t2: {[any]: any}) -- line: 34
	return t1.min == t2.min and t1.max == t2.max
end
local function screenSizeBoundsEqual(t3: {[any]: any}, t4: {[any]: any}) -- line: 38
	-- upvalues: FIntLuaAppViewportBoundsScreenSizeThreshold (copy)
	local v24 = FIntLuaAppViewportBoundsScreenSizeThreshold

	return v24 > math.abs(t3.max.X - t4.max.X) and (v24 > math.abs(t3.max.Y - t4.max.Y) and (t3.min.X == t4.min.X and t3.min.Y == t4.min.Y))
end

local t5 = {
	min = Vector2.zero,
	max = Vector2.zero
}

local function calculateClampedViewportBounds(vector2: Vector2?, vector2_2: Vector2?, t6: {[any]: any}) -- line: 48
	-- upvalues: v9 (copy), t5 (copy)
	local v28 = vector2 or Vector2.zero
	local v29 = v28 + (vector2_2 or Vector2.zero)
	local v30 = math.max(t6.min.X, v28.X)
	local v31 = math.min(t6.max.X, v29.X)
	local v32 = math.max(t6.min.Y, v28.Y)
	local v33 = math.min(t6.max.Y, v29.Y)

	if v9 and (v31 <= v30 or v33 <= v32) then
		return t5
	end

	return {
		min = Vector2.new(v30, v32),
		max = Vector2.new(v31, v33)
	}
end

return function(t7: {[any]: any}?, b1: boolean?, b2: boolean?) -- line: 69
	-- upvalues: v11 (copy), React (copy), Signals (copy), Display (copy), v15 (copy), screenSizeBoundsEqual (copy), SignalsReact (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), useClipAncestorBounds (copy), t5 (copy), v9 (copy), intersectBounds (copy), calculateClampedViewportBounds (copy), FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold (copy), FIntLuaAppViewportBoundsScreenSizeThreshold (copy), FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions (copy)
	local u38

	if v11 then
		local v37 = React.useMemo(function() -- line: 77
			-- upvalues: Signals (copy), Display (copy), v15 (copy), b1 (copy), screenSizeBoundsEqual (copy)
			return Signals.createComputed(function(p1) -- line: 78
				-- upvalues: Display (copy), v15 (copy), b1 (copy)
				local v58 = Display.GetDisplayStore(p1)
				local v59 = v58.getViewportSize(p1)
				local v60 = v58.getTopBarHeight(p1)
				local v61 = if not v15 then v58.getGuiInset(p1) else nil

				return {
					min = Vector2.new(0, v60),
					max = Vector2.new(v59.X, if not v15 and not b1 then v59.Y - v61.bottom else v59.Y)
				}
			end, screenSizeBoundsEqual)
		end, { b1 })

		u38 = SignalsReact.useSignalState(v37)
	else
		local v39 = SignalsReact.useSignalState(function(p2) -- line: 99
			-- upvalues: Display (copy)
			return Display.GetDisplayStore(p2).getViewportSize(p2)
		end)
		local v40 = SignalsReact.useSignalState(function(p3) -- line: 102
			-- upvalues: Display (copy)
			return Display.GetDisplayStore(p3).getTopBarHeight(p3)
		end)
		local v41 = if not v15 then SignalsReact.useSignalState(function(p4) -- line: 107
			-- upvalues: Display (copy)
			return Display.GetDisplayStore(p4).getGuiInset(p4)
		end) else nil

		u38 = React.useMemo(function() -- line: 112
			-- upvalues: v40 (copy), v39 (copy), v15 (copy), b1 (copy), v41 (copy)
			return {
				min = Vector2.new(0, v40),
				max = Vector2.new(v39.X, if not v15 and not b1 then v39.Y - v41.bottom else v39.Y)
			}
		end, {
			v40,
			v39,
			if not v15 then v41 else nil,
			b1
		})
	end

	local v42 = if not FFlagLuaAppRespectClipAncestorImpressions then nil else useClipAncestorBounds(if not b2 then nil else t7)
	local v43, v44 = React.useState(t5)
	local v45 = if not v9 then v44 else React.useCallback(function(t8: {[any]: any}) -- line: 139
		-- upvalues: v44 (copy)
		v44(function(t9: {[any]: any}) -- line: 140
			-- upvalues: t8 (copy)
			local v63 = t8

			if t9.min == v63.min and t9.max == v63.max then
				return t9
			end

			return t8
		end)
	end, {})

	React.useEffect(function() -- line: 150
		-- upvalues: t7 (copy), v9 (copy), v11 (copy), v45 (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), intersectBounds (copy), u38 (ref), calculateClampedViewportBounds (copy), FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold (copy), FIntLuaAppViewportBoundsScreenSizeThreshold (copy)
		local t10 = {}
		local current = nil

		if t7 then
			current = t7.current
		end

		if current then
			local AbsolutePosition = current.AbsolutePosition
			local AbsoluteSize = current.AbsoluteSize
			local u55 = if not v9 then nil else AbsolutePosition
			local u56 = if not v11 then nil else AbsoluteSize

			v45(if not FFlagLuaAppRespectClipAncestorImpressions then calculateClampedViewportBounds(AbsolutePosition, AbsoluteSize, u38) else intersectBounds({
				min = AbsolutePosition,
				max = AbsolutePosition + AbsoluteSize
			}, u38))
			table.insert(t10, current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 182
				-- upvalues: AbsolutePosition (ref), current (ref), v9 (copy), FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold (copy), u55 (ref), v45 (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), intersectBounds (copy), AbsoluteSize (ref), u38 (ref), calculateClampedViewportBounds (copy)
				AbsolutePosition = current.AbsolutePosition

				if v9 then
					local v64 = FIntLuaAppUpdateImpressionsViewportBoundsPositionThreshold
					local v65 = AbsolutePosition - u55

					if v64 > math.abs(v65.X) and v64 > math.abs(v65.Y) then
						return
					end

					u55 = AbsolutePosition
				end

				v45(if not FFlagLuaAppRespectClipAncestorImpressions then calculateClampedViewportBounds(AbsolutePosition, AbsoluteSize, u38) else intersectBounds({
					min = AbsolutePosition,
					max = AbsolutePosition + AbsoluteSize
				}, u38))
			end))
			table.insert(t10, current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 210
				-- upvalues: AbsoluteSize (ref), current (ref), v11 (copy), FIntLuaAppViewportBoundsScreenSizeThreshold (copy), u56 (ref), v45 (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), intersectBounds (copy), AbsolutePosition (ref), u38 (ref), calculateClampedViewportBounds (copy)
				AbsoluteSize = current.AbsoluteSize

				if v11 then
					local v66 = FIntLuaAppViewportBoundsScreenSizeThreshold
					local v67 = AbsoluteSize - u56

					if v66 > math.abs(v67.X) and v66 > math.abs(v67.Y) then
						return
					end

					u56 = AbsoluteSize
				end

				v45(if not FFlagLuaAppRespectClipAncestorImpressions then calculateClampedViewportBounds(AbsolutePosition, AbsoluteSize, u38) else intersectBounds({
					min = AbsolutePosition,
					max = AbsolutePosition + AbsoluteSize
				}, u38))
			end))
		else
			v45(u38)
		end

		return function() -- line: 234
			-- upvalues: t10 (copy)
			for _, v69 in t10 do
				v69:Disconnect()
			end
		end
	end, {
		t7,
		u38,
		if not FFlagLuaAppRespectClipAncestorImpressions then nil else v45
	})

	local v46 = if not FFlagLuaAppRespectClipAncestorImpressions then v43 else React.useMemo(function() -- line: 248
		-- upvalues: v42 (copy), intersectBounds (copy), v43 (copy)
		if v42 then
			return (intersectBounds(v43, v42))
		end

		return v43
	end, {
		v43,
		v42
	})

	return if not FFlagLuaAppRespectClipAncestorImpressions then v43 else v46, if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then nil else u38
end
