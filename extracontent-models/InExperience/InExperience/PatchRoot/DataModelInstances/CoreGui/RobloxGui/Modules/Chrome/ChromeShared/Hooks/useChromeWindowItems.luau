local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local Service = require(ChromeShared.Service)
require(CorePackages.Workspace.Packages.Chrome)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)

return function()
	return useObservableValue(Service:windowList()) or {}
end
