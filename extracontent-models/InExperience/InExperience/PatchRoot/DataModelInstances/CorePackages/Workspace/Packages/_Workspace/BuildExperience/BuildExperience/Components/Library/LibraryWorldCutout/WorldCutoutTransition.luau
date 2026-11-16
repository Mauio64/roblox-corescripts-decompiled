local initialState = { phase = "Home", progress = 0 }
local v = { phase = "World", progress = 1 }
local WorldCutoutTransition = {}
WorldCutoutTransition.initialState = initialState

function WorldCutoutTransition.reduce(p, p2)
	if p2.type == "Expand" then
		if p.phase == "Home" or p.phase == "Collapsing" then
			return { phase = "Expanding", progress = p.progress }
		end

		return p
	elseif p2.type == "Collapse" then
		if p.phase == "World" or p.phase == "Expanding" then
			return { phase = "Collapsing", progress = p.progress }
		end

		return p
	elseif p2.type == "Progress" then
		local progress = math.clamp(p2.progress, 0, 1)

		if p.phase == "Expanding" then
			if progress >= 1 then
				return v
			end

			return { phase = "Expanding", progress = progress }
		end

		if p.phase ~= "Collapsing" then
			return p
		end

		if progress <= 0 then
			return initialState
		end

		return { phase = "Collapsing", progress = progress }
	elseif p2.type == "Settle" then
		if p.phase == "Expanding" then
			return v
		end

		if p.phase == "Collapsing" then
			return initialState
		end

		return p
	else
		return if p.phase == "Home" then p else initialState
	end
end

function WorldCutoutTransition.isTransitioning(p: string): boolean
	return p == "Expanding" or p == "Collapsing"
end

function WorldCutoutTransition.getTarget(p: string): number
	return if p == "Expanding" or p == "World" then 1 else 0
end

function WorldCutoutTransition.interpolateRect(rect: Rect, rect2: Rect, value: number)
	local v2 = math.clamp(value, 0, 1)
	return Rect.new(rect.Min:Lerp(rect2.Min, v2), rect.Max:Lerp(rect2.Max, v2))
end

return WorldCutoutTransition
