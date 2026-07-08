local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local t1 = {
	dampingRatio = 1,
	frequency = 3
}

local function calculateTargetScrollOffset(p1, p2, p3, n1: number, n2: number) -- line: 10
	local v12 = if p3 ~= Enum.ScrollingDirection.X then p1.CanvasPosition.Y + (p2.AbsolutePosition.Y - p1.AbsolutePosition.Y) else p1.CanvasPosition.X + (p2.AbsolutePosition.X - p1.AbsolutePosition.X)

	if v12 < n2 then
		return 0
	end

	return (math.max(v12 - n1, 0))
end
local function useAnimatedScrollToSelection(p4, n3: number?, n4: number?, p5) -- line: 28
	-- upvalues: t1 (copy), ReactOtter (copy), React (copy)
	local v17 = n3 or 0
	local v18 = n4 or 0
	local v19 = p5 or t1
	local v20, v21 = ReactOtter.useAnimatedBinding(0)
	local v22 = React.useCallback(function(p6, b1: boolean, _, p8) -- line: 41
		-- upvalues: p4 (copy), v17 (copy), v18 (copy), v21 (copy), ReactOtter (copy), v19 (copy)
		if b1 then
			return
		end

		if p8 and p8:IsDescendantOf(p6) then
			local v27 = p4
			local v28 = v17
			local v29 = v18
			local v30 = if v27 ~= Enum.ScrollingDirection.X then p6.CanvasPosition.Y + (p8.AbsolutePosition.Y - p6.AbsolutePosition.Y) else p6.CanvasPosition.X + (p8.AbsolutePosition.X - p6.AbsolutePosition.X)
			local v31 = if not (v30 < v29) then math.max(v30 - v28, 0) else 0

			v21(ReactOtter.spring(v31, v19))
		end
	end, {
		v17,
		p4,
		v18,
		v19
	})

	return React.useMemo(function() -- line: 59
		-- upvalues: v20 (copy), p4 (copy)
		return v20:map(function(n5: number) -- line: 60
			-- upvalues: p4 (copy)
			if p4 == Enum.ScrollingDirection.X then
				return (Vector2.new(n5, 0))
			end

			return (Vector2.new(0, n5))
		end)
	end, { p4 }), v22
end

return useAnimatedScrollToSelection
