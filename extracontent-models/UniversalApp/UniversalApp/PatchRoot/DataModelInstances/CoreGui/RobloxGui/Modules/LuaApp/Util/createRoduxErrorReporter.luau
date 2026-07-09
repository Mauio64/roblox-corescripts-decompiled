local Modules = game:GetService("CoreGui").RobloxGui.Modules
local inspect = require(Modules.LuaApp.Util.inspect).inspect
local tableDiff = require(Modules.LuaApp.Util.tableDiff)

local function backtraceDetails(p1, p2, p3, p4) -- line: 6
	-- upvalues: tableDiff (copy)
	if type(p4.thrownValue) ~= "string" then
		return nil
	end

	local v9 = p4.thrownValue:find("\n")

	if not v9 then
		return nil
	end

	return {
		message = p4.message .. "\n" .. p4.thrownValue:sub(1, v9 - 1),
		stacks = p4.thrownValue:sub(v9 + 1):split("\n\n"),
		annotations = {
			rodux_actions = p3,
			rodux_diff = tableDiff(p1, p2) or {}
		}
	}
end

return function(p5) -- line: 24
	-- upvalues: inspect (copy), backtraceDetails (copy), tableDiff (copy)
	return {
		reportReducerError = function(_, p7, p8) -- line: 26
			-- upvalues: inspect (copy), p5 (copy), backtraceDetails (copy)
			local v14 = string.format("%s\n\nAction:\n%s\n\nError contents:\n%s", p8.message, inspect(p7), (tostring(p8.thrownValue)))

			p5(v14, (backtraceDetails({}, {}, { p7 }, p8)))
		end,
		reportUpdateError = function(p9, p10, p11, p12) -- line: 35
			-- upvalues: inspect (copy), tableDiff (copy), p5 (copy), backtraceDetails (copy)
			local v19 = string.format("%s\n\nStore changes in the last flush:\n%s\n\nMost recent actions (starting with the oldest):\n%s\n\nError contents:\n%s", p12.message, inspect(tableDiff(p9, p10)), inspect(p11), (tostring(p12.thrownValue)))

			p5(v19, (backtraceDetails(p9, p10, p11, p12)))
		end
	}
end
