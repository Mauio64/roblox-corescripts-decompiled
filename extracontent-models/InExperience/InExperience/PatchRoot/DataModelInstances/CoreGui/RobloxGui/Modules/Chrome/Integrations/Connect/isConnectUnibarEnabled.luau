local CorePackages = game:GetService("CorePackages")

local isConnectDropdownEnabled = require(script.Parent.isConnectDropdownEnabled)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

return function()
	return isConnectDropdownEnabled() and GetFFlagIsSquadEnabled()
end
