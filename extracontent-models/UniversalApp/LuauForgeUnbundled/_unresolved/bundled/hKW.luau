local module = require("@luauforge/bundled/dwB")

return function(p2, p3, p4, p5): boolean
	return p2 ~= nil
		and p2.toastType == module.QuickLaunchError
		and p3.toastType == module.QuickLaunchError
		and p4 ~= nil
		and p5 ~= nil
		and p4 ~= p5
end
