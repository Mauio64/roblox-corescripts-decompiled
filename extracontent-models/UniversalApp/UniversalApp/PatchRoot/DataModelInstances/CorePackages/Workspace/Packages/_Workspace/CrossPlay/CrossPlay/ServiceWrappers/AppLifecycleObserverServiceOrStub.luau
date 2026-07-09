local Parent = script:FindFirstAncestor("CrossPlay").Parent
local t1 = {
	OnBecomeActive = require(Parent.AppCommonLib).Signal.new()
}
local AppLifecycleObserverService = nil

pcall(function() -- line: 10
	-- upvalues: AppLifecycleObserverService (ref)
	AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
end)

return AppLifecycleObserverService or t1
