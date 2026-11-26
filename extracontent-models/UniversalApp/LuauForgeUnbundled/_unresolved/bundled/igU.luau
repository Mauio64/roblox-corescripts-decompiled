local inspect = require("@game/CorePackages/Packages/_Index/GraphQL/GraphQL/jsutils/inspect").inspect
local module = require("@luauforge/bundled/igY")

local function backtraceDetails(p2, p3, p4, p5)
	if type(p5.thrownValue) ~= "string" then
		return nil
	end

	local v5 = p5.thrownValue:find("\n")

	if v5 then
		return {
			message = p5.message .. "\n" .. p5.thrownValue:sub(1, v5 - 1),
			stacks = p5.thrownValue:sub(v5 + 1):split("\n\n"),
			annotations = {
				rodux_actions = p4,
				rodux_diff = module(p2, p3) or {}
			}
		}
	end

	return nil
end

return function(callback)
	return {
		reportReducerError = function(p2, p3, p4)
			callback(
				string.format(
					"%s\n\nAction:\n%s\n\nError contents:\n%s",
					p4.message,
					inspect(p3),
					(tostring(p4.thrownValue))
				),
				backtraceDetails({}, {}, { p3 }, p4)
			)
		end,
		reportUpdateError = function(p2, p3, p4, p5)
			callback(
				string.format(
					"%s\n\nStore changes in the last flush:\n%s\n\nMost recent actions (starting with the oldest):\n%s\n\nError contents:\n%s",
					p5.message,
					inspect(module(p2, p3)),
					inspect(p4),
					(tostring(p5.thrownValue))
				),
				backtraceDetails(p2, p3, p4, p5)
			)
		end
	}
end
