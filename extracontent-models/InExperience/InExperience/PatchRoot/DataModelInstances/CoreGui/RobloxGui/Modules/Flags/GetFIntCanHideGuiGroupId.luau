return function()
	local success, result = pcall(function()
		return game:GetFastInt("CanHideGuiGroupId")
	end)

	return success and result
end
