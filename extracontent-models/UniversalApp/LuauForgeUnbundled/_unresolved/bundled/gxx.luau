local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/fpu")

local v5 = {
	new = function()
		return {}
	end,
	["validateJson"] = t.interface({ restriction = t.optional(t.table) }),
	validateModel = t.interface({ restriction = t.table })
}

function v5.fromJsonData(p2)
	if not v5.validateJson(p2) then
		return module.error("ModerationDetail.fromJsonData expects a valid moderation JSON response")
	end

	local v6 = v5.new()

	if p2.restriction then
		v6.restriction = {
			source = p2.restriction.source,
			moderationStatus = p2.restriction.moderationStatus,
			startTime = p2.restriction.startTime,
			endTime = p2.restriction.endTime,
			durationSeconds = p2.restriction.durationSeconds
		}
	end

	return module.success(v6)
end

return v5
