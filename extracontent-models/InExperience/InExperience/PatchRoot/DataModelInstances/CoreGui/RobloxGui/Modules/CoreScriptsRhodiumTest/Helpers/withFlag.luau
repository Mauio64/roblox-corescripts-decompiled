local function withFlag(p1, p2) -- line: 18
	local v4 = game:SetFastFlagForTesting(p1, true)
	local ok, result = pcall(p2)

	game:SetFastFlagForTesting(p1, v4)
	assert(ok, (tostring(result)))
end

return withFlag
