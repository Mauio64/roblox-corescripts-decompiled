local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(toastTitle, toastSubtitle)
	return { toastTitle = toastTitle, toastSubtitle = toastSubtitle }
end)
