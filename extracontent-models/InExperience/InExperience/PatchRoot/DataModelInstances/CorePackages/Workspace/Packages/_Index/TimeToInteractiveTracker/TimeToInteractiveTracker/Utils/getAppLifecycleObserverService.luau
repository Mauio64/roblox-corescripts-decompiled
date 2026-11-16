return function()
	local success, result = pcall(function()
		return game:GetService("AppLifecycleObserverService")
	end)
	return if success then result else nil
end
