local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)

local function useRefreshCreatorCreditOnUnhide(p1: ((...any) -> ...any)?, t1: {[any]: any}?) -- line: 14
	-- upvalues: React (copy), AppLifecycleObserverService (copy)
	React.useEffect(function() -- line: 18
		-- upvalues: p1 (copy), t1 (copy), AppLifecycleObserverService (copy)
		if p1 == nil then
			return function() -- line: 20
			end
		end

		local connection = (t1 or AppLifecycleObserverService).OnUnhide:Connect(p1)

		return function() -- line: 24
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		t1,
		p1
	})
end

return useRefreshCreatorCreditOnUnhide
