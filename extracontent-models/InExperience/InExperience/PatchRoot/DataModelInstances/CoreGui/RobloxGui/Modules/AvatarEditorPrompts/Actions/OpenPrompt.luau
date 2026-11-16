local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(promptType, promptInfo)
	return { promptType = promptType, promptInfo = promptInfo }
end)
