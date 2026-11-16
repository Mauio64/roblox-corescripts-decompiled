local v5 = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v5 = AppLifecycleObserverService
end)

local module = require("@luauforge/deferred/gjp")

local useFoldersStore = require("@luauforge/deferred/gjo").useFoldersStore

local function useRefreshFolders(p2)
	local refreshFolders = useFoldersStore().refreshFolders

	module.useEffect(function()
		refreshFolders()
		local v6 = p2 or v5

		if v6 == nil then
			return function() end
		end

		local onUnhideConnection = v6.OnUnhide:Connect(function()
			refreshFolders()
		end)
		return function()
			onUnhideConnection:Disconnect()
		end
	end, { refreshFolders, p2 })
end

return useRefreshFolders
