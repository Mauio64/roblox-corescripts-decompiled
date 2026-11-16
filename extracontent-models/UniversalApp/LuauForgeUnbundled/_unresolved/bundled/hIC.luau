local v5 = {
	OnBecomeActive = require("@luauforge/bundled/hIx").Signal.new()
}

local v6 = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v6 = AppLifecycleObserverService
end)

return v6 or v5
