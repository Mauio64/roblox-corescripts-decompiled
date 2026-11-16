local function withInt(p, p2, callback)
	local v = game:SetFastIntForTesting(p, p2)
	local success, result = pcall(callback)

	game:SetFastIntForTesting(p, v)

	if not success then
		error(result)
	end
end

return withInt
