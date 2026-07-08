local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local Service = require(ChromeShared.Service)

require(CorePackages.Workspace.Packages.Chrome)

local useObservableValue = require(ChromeShared.Hooks.useObservableValue)

return function() -- line: 10
	-- upvalues: useObservableValue (copy), Service (copy)
	return useObservableValue(Service:windowList()) or {}
end
