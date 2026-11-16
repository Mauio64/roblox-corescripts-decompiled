local parent = script:FindFirstAncestor("AuthCommon").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(countryCodeList)
	return { countryCodeList = countryCodeList }
end)
