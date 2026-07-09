local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)
local GetFFlagAXEnableNewInventoryItemsList = require(CoreGui.RobloxGui.Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)

return Rodux.makeActionCreator(script.Name, function(n1: number, s1: string, b1: boolean) -- line: 14
	-- upvalues: GetFFlagAXEnableNewInventoryItemsList (copy)
	return {
		outfitId = n1,
		outfitType = if not GetFFlagAXEnableNewInventoryItemsList() then nil else s1,
		isEditable = if not GetFFlagAXEnableNewInventoryItemsList() then nil else b1
	}
end)
