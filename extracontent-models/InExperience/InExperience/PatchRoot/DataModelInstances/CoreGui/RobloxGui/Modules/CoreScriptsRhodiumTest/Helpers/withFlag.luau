local function withFlag(p, callback)
	local v = game:SetFastFlagForTesting(p, true)
	local success, result = pcall(callback)

	game:SetFastFlagForTesting(p, v)

	assert(success, (tostring(result)))
end

return withFlag
