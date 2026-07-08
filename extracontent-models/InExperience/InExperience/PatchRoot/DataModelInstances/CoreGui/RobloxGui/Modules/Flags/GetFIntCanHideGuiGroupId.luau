return function() -- line: 1
	local ok, result = pcall(function() -- line: 2
		return game:GetFastInt("CanHideGuiGroupId")
	end)

	return ok and result
end
