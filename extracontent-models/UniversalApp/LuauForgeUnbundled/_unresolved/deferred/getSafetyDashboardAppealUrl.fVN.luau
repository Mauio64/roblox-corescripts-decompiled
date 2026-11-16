require("@luauforge/deferred/fUR")
local urlBuilder = require("@luauforge/deferred/fVy").UrlBuilder

local function getSafetyDashboardAppealUrl(p2)
	if p2 and p2.uid ~= "" then
		return urlBuilder.static.safetyDashboard.violation({ id = p2.uid })
	end

	return urlBuilder.static.safetyDashboard.violations()
end

return getSafetyDashboardAppealUrl
