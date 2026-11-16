local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus

local module = require("@luauforge/bundled/dtt")

return function(p2, data)
	local v5 = p2 or { status = retrievalStatus.NotStarted, isRefreshFetch = false }

	return data.type == module.name and {
		status = data.status,
		isRefreshFetch = data.isRefreshFetch or false
	} or v5
end
