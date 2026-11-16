local success, _ = pcall(function()
	return game:GetService("ProcessService")
end)

return function()
	return success
end
