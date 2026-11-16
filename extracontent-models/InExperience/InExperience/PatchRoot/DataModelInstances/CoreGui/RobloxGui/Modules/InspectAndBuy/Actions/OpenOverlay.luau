local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(overlay, overlayProps)
	return { overlay = overlay, overlayProps = overlayProps }
end)
