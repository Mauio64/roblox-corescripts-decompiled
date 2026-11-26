local module = require("@luauforge/bundled/fBF")

local v5 = {
	[module.SlideInFromRight] = "slideInFromRight",
	[module.SlideInFromBottom] = "slideInFromBottom"
}

return function(p2)
	if p2 then
		return v5[p2]
	end

	return nil
end
