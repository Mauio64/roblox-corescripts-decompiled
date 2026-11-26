local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")

local function useAppLifecycleCallbacks(onOnHide, onOnUnhide, p2)
	local v5 = p2 or AppLifecycleObserverService
	React.useEffect(function()
		if onOnHide == nil then
			return nil
		end

		local onHideConnection = v5.OnHide:Connect(onOnHide)
		return function()
			onHideConnection:Disconnect()
		end
	end, { onOnHide, v5 })

	React.useEffect(function()
		if onOnUnhide == nil then
			return nil
		end

		local onUnhideConnection = v5.OnUnhide:Connect(onOnUnhide)
		return function()
			onUnhideConnection:Disconnect()
		end
	end, { onOnUnhide, v5 })
end

return useAppLifecycleCallbacks
