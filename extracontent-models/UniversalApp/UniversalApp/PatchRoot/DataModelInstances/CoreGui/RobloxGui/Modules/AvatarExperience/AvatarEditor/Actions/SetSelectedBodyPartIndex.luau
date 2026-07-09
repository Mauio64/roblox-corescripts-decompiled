local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local mutedError = require(Modules.LuaApp.mutedError)

return Rodux.makeActionCreator(script.Name, function(n1: number) -- line: 12
	-- upvalues: Constants (copy), mutedError (copy)
	if n1 < 0 or n1 > #Constants.BodyPartButtonData then
		mutedError("selectedBodyPartIndex is out of range")
	end

	return {
		selectedBodyPartIndex = n1
	}
end)
