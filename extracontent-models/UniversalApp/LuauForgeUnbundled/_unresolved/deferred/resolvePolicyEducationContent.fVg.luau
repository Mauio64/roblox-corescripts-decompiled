local module = require("@luauforge/deferred/fVh")
local module2 = require("@luauforge/deferred/fVi")

local function resolvePolicyEducationContent(p2, p3)
	local v5 = p3 and module.CONTENT_BY_ABUSE_KEY[p2]

	if v5 then
		return v5.education
	end

	return module2[p2]
end

return resolvePolicyEducationContent
