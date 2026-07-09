local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

return require(Modules.Common.Action)(script.Name, function(p1) -- line: 7
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "tableOfHumanoidDescriptionProperties passed into SetHumanoidDescriptionProperties")

	for k, v in pairs(p1) do
		ArgCheck.isNonEmptyString(k, "tableOfHumanoidDescriptionProperties's key (outfitId)")
		ArgCheck.isType(v, "table", "tableOfHumanoidDescriptionProperties's value (table of HumanoidDescription properties)")
	end

	return {
		tableOfHumanoidDescriptionProperties = p1
	}
end)
