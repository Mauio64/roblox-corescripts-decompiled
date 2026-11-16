local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/ReactOtter")

local v5 = { dampingRatio = 1, frequency = 3 }

local function calculateTargetScrollOffset(p2, p3, p4, p5, p6)
	local v6

	if p4 == Enum.ScrollingDirection.X then
		v6 = p2.CanvasPosition.X + (p3.AbsolutePosition.X - p2.AbsolutePosition.X)
	else
		v6 = p2.CanvasPosition.Y + (p3.AbsolutePosition.Y - p2.AbsolutePosition.Y)
	end

	if v6 < p6 then
		return 0
	end

	return (math.max(v6 - p5, 0))
end

local function useAnimatedScrollToSelection(p2, value, value2, p3)
	local v6 = value or 0
	local v7 = value2 or 0
	local v8 = p3 or v5
	local v9, v10 = ReactOtter.useAnimatedBinding(0)

	local v11 = React.useCallback(function(ancestor, p4, p5, instance)
		if p4 then
			return
		end

		if instance and instance:IsDescendantOf(ancestor) then
			local v14

			if p2 == Enum.ScrollingDirection.X then
				v14 = ancestor.CanvasPosition.X + (instance.AbsolutePosition.X - ancestor.AbsolutePosition.X)
			else
				v14 = ancestor.CanvasPosition.Y + (instance.AbsolutePosition.Y - ancestor.AbsolutePosition.Y)
			end

			local v15 = v14 < v7 and 0 or math.max(v14 - v6, 0)

			v10(ReactOtter.spring(v15, v8))
		end
	end, { v6, p2, v7, v8 })

	return React.useMemo(function()
		return v9:map(function(p4)
			if p2 == Enum.ScrollingDirection.X then
				return (Vector2.new(p4, 0))
			end

			return (Vector2.new(0, p4))
		end)
	end, { p2 }), v11
end

return useAnimatedScrollToSelection
