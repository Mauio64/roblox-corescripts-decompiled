local CorePackages = game:GetService("CorePackages")
local isConnectDropdownEnabled = require(script.Parent.isConnectDropdownEnabled)
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled

return function() -- line: 6
	-- upvalues: isConnectDropdownEnabled (copy), GetFFlagIsSquadEnabled (copy)
	return isConnectDropdownEnabled() and GetFFlagIsSquadEnabled()
end
