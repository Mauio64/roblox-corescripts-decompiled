local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 14
	return {
		wasItemEquipped = t1.wasItemEquipped,
		fetchItemFailed = t1.fetchItemFailed,
		itemId = t1.itemId,
		itemType = t1.itemType
	}
end)
