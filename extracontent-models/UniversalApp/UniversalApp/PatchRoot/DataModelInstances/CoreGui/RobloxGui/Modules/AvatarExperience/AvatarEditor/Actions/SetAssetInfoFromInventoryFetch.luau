local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 15
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(t1, "table", "SetAssetInfoFromInventoryFetch action expects assets to be a table")

	return {
		assets = t1
	}
end)
