local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Result = require(Modules.LuaApp.Result)
local t1 = {
	new = function() -- line: 21
		return {}
	end,
	validateJson = t.interface({
		restriction = t.optional(t.table)
	}),
	validateModel = t.interface({
		restriction = t.table
	})
}

function t1.fromJsonData(p1) -- line: 43
	-- upvalues: t1 (copy), Result (copy)
	if not t1.validateJson(p1) then
		return Result.error("ModerationDetail.fromJsonData expects a valid moderation JSON response")
	end

	local v7 = t1.new()

	if p1.restriction then
		v7.restriction = {
			source = p1.restriction.source,
			moderationStatus = p1.restriction.moderationStatus,
			startTime = p1.restriction.startTime,
			endTime = p1.restriction.endTime,
			durationSeconds = p1.restriction.durationSeconds
		}
	end

	return Result.success(v7)
end

return t1
