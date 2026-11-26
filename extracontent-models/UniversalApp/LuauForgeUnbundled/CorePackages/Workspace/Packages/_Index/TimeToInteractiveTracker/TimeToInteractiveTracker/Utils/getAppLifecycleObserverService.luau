return function()
	local success, result = pcall(function()
		return game:GetService("AppLifecycleObserverService")
	end)

	if success then
		return result
	end

	return nil
end
