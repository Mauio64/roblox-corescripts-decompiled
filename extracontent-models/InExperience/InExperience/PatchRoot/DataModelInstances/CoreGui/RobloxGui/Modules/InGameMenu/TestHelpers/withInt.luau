local function withInt(p1, p2, p3) -- line: 4
	local v5 = game:SetFastIntForTesting(p1, p2)
	local ok, result = pcall(p3)

	game:SetFastIntForTesting(p1, v5)
	assert(ok, result)
end

return withInt
