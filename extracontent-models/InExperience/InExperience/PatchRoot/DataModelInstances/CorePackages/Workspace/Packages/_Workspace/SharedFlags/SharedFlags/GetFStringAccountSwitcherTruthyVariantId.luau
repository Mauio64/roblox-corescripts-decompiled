return function() -- line: 4
	local ok, result = pcall(function() -- line: 5
		return game:GetFastString("AccountSwitcherTruthyVariantId")
	end)

	if ok then
		return result
	end

	return "1"
end
