local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_LOCALE_ID", function(newLocaleId)
	return { newLocaleId = newLocaleId }
end)
