local function estimatePostingProgress(p2, p3, p4, value)
	local v5 = math.clamp(value, 0, 1)

	if p4 <= 0 then
		return v5
	end

	return v5 * math.clamp((p2 - p3) / p4, 0, 1)
end

return estimatePostingProgress
