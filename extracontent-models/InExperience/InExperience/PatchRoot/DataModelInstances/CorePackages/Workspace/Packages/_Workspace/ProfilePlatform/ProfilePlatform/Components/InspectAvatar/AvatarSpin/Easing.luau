return {
	smoothstep = function(p: number, p2: number, p3: number)
		local v = math.clamp((p3 - p) / (p2 - p), 0, 1)
		return v * v * (3 - v * 2)
	end
}
