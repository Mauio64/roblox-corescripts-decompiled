local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local function useRefreshCreatorCreditOnUnhide(onOnUnhide, p2)
	React.useEffect(function()
		if onOnUnhide == nil then
			return function() end
		end

		local onUnhideConnection = (p2 or AppLifecycleObserverService).OnUnhide:Connect(onOnUnhide)
		return function()
			onUnhideConnection:Disconnect()
		end
	end, { p2, onOnUnhide })
end

return useRefreshCreatorCreditOnUnhide
