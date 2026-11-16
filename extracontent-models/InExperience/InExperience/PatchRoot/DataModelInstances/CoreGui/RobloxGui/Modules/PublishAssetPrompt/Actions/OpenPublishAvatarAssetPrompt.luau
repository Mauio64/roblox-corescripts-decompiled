local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator(script.Name, function(promptType: string, accessoryType, guid: string, scopes)
	return {
		promptInfo = {
			promptType = promptType,
			accessoryType = accessoryType,
			guid = guid,
			scopes = scopes
		}
	}
end)
