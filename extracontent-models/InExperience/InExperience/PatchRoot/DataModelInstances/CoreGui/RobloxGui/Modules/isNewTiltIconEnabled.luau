local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled

return function() -- line: 7
	-- upvalues: Enabled (copy), isNewInGameMenuEnabled (copy)
	return Enabled() and not isNewInGameMenuEnabled()
end
