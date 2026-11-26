local retrievalStatus = require("@luauforge/bundled/dus").Enum.RetrievalStatus

local module = require("@luauforge/bundled/dwx")

return function(p2, p3)
	local v5 = p2 or retrievalStatus.NotStarted

	if p3.type == module.name then
		v5 = p3.status
	end

	return v5
end
