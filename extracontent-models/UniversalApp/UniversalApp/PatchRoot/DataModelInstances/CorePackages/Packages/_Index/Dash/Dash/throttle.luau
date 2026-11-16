local parent = script.Parent
local assign = require(parent.assign)

local function throttle(callback, p: number, p2)
	local v = assign({ leading = true, trailing = true }, p2)

	local v2 = math.max(0, p)
	local leading = v.leading
	local trailing = v.trailing

	local v3 = -1e999
	local thread = nil
	local v4 = {}

	local function clearScheduled() -- 1 equivalent call inferred from this helper
		if thread then
			task.cancel(thread)
			thread = nil
		end
	end

	local function invoke() -- 1 equivalent call inferred from this helper
		v3 = os.clock()
		thread = nil
		callback(table.unpack(v4))
	end

	return function(...)
		local now = os.clock()
		v4 = { ... }

		local v5 = now - v3

		if leading and v2 <= v5 then
			clearScheduled() -- inferred equivalent call
			invoke() -- inferred equivalent call
		elseif trailing and not thread then
			local v6 = v2 - (now - (v3 == -1e999 and now or v3))
			local v7 = v6 < 0 and 0 or v6

			thread = task.delay(v7, invoke)
		end
	end
end

return throttle
