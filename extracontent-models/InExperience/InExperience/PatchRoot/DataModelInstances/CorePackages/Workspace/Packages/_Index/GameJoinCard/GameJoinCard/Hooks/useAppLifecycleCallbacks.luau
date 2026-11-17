local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)

local function useAppLifecycleCallbacks(onOnHide, onOnUnhide, p)
	local v = p or AppLifecycleObserverService
	React.useEffect(function()
		if onOnHide == nil then
			return nil
		end

		local onHideConnection = v.OnHide:Connect(onOnHide)
		return function()
			onHideConnection:Disconnect()
		end
	end, { onOnHide, v })

	React.useEffect(function()
		if onOnUnhide == nil then
			return nil
		end

		local onUnhideConnection = v.OnUnhide:Connect(onOnUnhide)
		return function()
			onUnhideConnection:Disconnect()
		end
	end, { onOnUnhide, v })
end

return useAppLifecycleCallbacks
