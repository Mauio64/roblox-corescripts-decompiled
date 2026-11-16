local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local function useRefreshCreatorCreditOnUnhide(onOnUnhide, p)
	React.useEffect(function()
		if onOnUnhide == nil then
			return function() end
		end

		local onUnhideConnection = (p or AppLifecycleObserverService).OnUnhide:Connect(onOnUnhide)
		return function()
			onUnhideConnection:Disconnect()
		end
	end, { p, onOnUnhide })
end

return useRefreshCreatorCreditOnUnhide
