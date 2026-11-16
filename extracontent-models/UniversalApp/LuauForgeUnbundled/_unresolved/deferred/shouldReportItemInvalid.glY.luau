local module = require("@luauforge/bundled/dxy")

local function shouldReportItemInvalid(p2, p3, p4, p5): boolean
	if p4 == p5 then
		return false
	end

	return p2 == module.Done and p3 == nil
end

return shouldReportItemInvalid
