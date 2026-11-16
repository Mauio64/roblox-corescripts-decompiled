local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_INPUT_TYPE", function(inputType)
	return { inputType = inputType }
end)
