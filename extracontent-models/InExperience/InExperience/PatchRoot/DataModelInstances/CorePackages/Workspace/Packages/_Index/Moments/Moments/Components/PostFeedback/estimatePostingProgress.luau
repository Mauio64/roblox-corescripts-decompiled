local function estimatePostingProgress(p: number, p2: number, p3: number, value: number)
	local v = math.clamp(value, 0, 1)

	if p3 <= 0 then
		return v
	end

	return v * math.clamp((p - p2) / p3, 0, 1)
end

return estimatePostingProgress
