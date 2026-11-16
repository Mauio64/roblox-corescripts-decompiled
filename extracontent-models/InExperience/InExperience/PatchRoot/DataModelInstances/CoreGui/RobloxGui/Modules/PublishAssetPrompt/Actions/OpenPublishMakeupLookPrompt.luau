local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator(script.Name, function(promptType: string, guid: string, scopes, makeupEntries)
	return {
		promptInfo = {
			promptType = promptType,
			guid = guid,
			scopes = scopes,
			makeupEntries = makeupEntries
		}
	}
end)
