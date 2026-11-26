local v5 = { phase = "Home", progress = 0 }
local v6 = { phase = "World", progress = 1 }

return {
	initialState = v5,
	reduce = function(p2, p3)
		if p3.type == "Expand" then
			if p2.phase == "Home" or p2.phase == "Collapsing" then
				return { phase = "Expanding", progress = p2.progress }
			end

			return p2
		elseif p3.type == "Collapse" then
			if p2.phase == "World" or p2.phase == "Expanding" then
				return { phase = "Collapsing", progress = p2.progress }
			end

			return p2
		elseif p3.type == "Progress" then
			local v7 = math.clamp(p3.progress, 0, 1)

			if p2.phase == "Expanding" then
				if v7 >= 1 then
					return v6
				end

				return { phase = "Expanding", progress = v7 }
			end

			if p2.phase ~= "Collapsing" then
				return p2
			end

			if v7 <= 0 then
				return v5
			end

			return { phase = "Collapsing", progress = v7 }
		elseif p3.type == "Settle" then
			if p2.phase == "Expanding" then
				return v6
			end

			if p2.phase == "Collapsing" then
				return v5
			end

			return p2
		elseif p2.phase == "Home" then
			return p2
		else
			return v5
		end
	end,
	isTransitioning = function(p2): boolean
		return p2 == "Expanding" or p2 == "Collapsing"
	end,
	getTarget = function(p2): number
		if p2 == "Expanding" or p2 == "World" then
			return 1
		end

		return 0
	end,
	interpolateRect = function(p2, p3, value)
		local v7 = math.clamp(value, 0, 1)
		return Rect.new(p2.Min:Lerp(p3.Min, v7), p2.Max:Lerp(p3.Max, v7))
	end
}
