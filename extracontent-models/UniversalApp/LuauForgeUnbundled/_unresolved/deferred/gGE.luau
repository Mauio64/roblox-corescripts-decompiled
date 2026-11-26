local module = require("@luauforge/deferred/gGF")
local module2 = require("@luauforge/deferred/gGD")

local v5 = {
	[module2.DefaultError] = {
		toastTitle = module.DefaultErrorTitle,
		toastSubtitle = module.DefaultErrorSubtitle
	}
}

return function(p2, p3)
	if p2 == module2.Custom and p3 then
		return p3
	end

	return v5[p2]
end
