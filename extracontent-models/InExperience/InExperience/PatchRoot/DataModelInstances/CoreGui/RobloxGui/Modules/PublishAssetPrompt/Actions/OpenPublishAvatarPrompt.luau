local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator(script.Name, function(promptType: string, guid: string, scopes)
	return {
		promptInfo = { promptType = promptType, guid = guid, scopes = scopes }
	}
end)
