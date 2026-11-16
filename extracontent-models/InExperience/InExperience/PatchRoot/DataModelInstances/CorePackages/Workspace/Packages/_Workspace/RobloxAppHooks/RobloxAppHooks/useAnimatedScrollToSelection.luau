local parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local v = { dampingRatio = 1, frequency = 3 }

local function calculateTargetScrollOffset(ancestor, instance, p, p2: number, p3: number) -- 1 equivalent call inferred from this helper
	local v2

	if p == Enum.ScrollingDirection.X then
		v2 = ancestor.CanvasPosition.X + (instance.AbsolutePosition.X - ancestor.AbsolutePosition.X)
	else
		v2 = ancestor.CanvasPosition.Y + (instance.AbsolutePosition.Y - ancestor.AbsolutePosition.Y)
	end

	if v2 < p3 then
		return 0
	end

	return (math.max(v2 - p2, 0))
end

local function useAnimatedScrollToSelection(p, value: number?, value2: number?, p2)
	local v2 = value or 0
	local v3 = value2 or 0
	local v4 = p2 or v
	local v5, v6 = ReactOtter.useAnimatedBinding(0)

	local v7 = React.useCallback(function(ancestor, flag: boolean, _, instance)
		if flag then
			return
		end

		if instance and instance:IsDescendantOf(ancestor) then
			local targetScrollOffset = calculateTargetScrollOffset(ancestor, instance, p, v2, v3) -- inferred equivalent call
			v6(ReactOtter.spring(targetScrollOffset, v4))
		end
	end, { v2, p, v3, v4 })

	return React.useMemo(function()
		return v5:map(function(p3: number)
			if p == Enum.ScrollingDirection.X then
				return (Vector2.new(p3, 0))
			end

			return (Vector2.new(0, p3))
		end)
	end, { p }), v7
end

return useAnimatedScrollToSelection
