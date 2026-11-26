local INTERVENTION_TYPES = require("@luauforge/deferred/gzN").Constants.INTERVENTION_TYPES

local module = require("@luauforge/deferred/gzO")

require("@luauforge/deferred/gzP")

local function canReactivate(p2, p3, p4): boolean
	if p4 ~= "" then
		return true
	end

	local v5 = module.Workspace:GetServerTimeNow() * 1000
	local dateTime = DateTime.fromIsoDate(p3)

	local v6 = dateTime and dateTime.UnixTimestampMillis < v5

	if p2 == INTERVENTION_TYPES.Warning or p2 == INTERVENTION_TYPES.Banned and v6 then
		return true
	end

	return false
end

return canReactivate
