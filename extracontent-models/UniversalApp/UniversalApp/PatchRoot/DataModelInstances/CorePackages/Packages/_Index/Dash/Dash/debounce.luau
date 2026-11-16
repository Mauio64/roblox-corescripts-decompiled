local parent = script.Parent
local assign = require(parent.assign)

local function debounce(callback, duration: number, p)
	local v = assign({ leading = false, trailing = true }, p)

	local count = 0
	local thread = nil
	local v2 = false
	local function fn() end

	local fn2

	if v.trailing then
		fn2 = function(p2: number, flag: boolean, ...)
			if count == p2 then
				v2 = false

				if not flag then
					callback(...)
				end
			end
		end
	else
		fn2 = v.leading and function(p2: number)
			if count == p2 then
				v2 = false
			end
		end or fn
	end

	return function(...)
		count += 1
		local v3 = count
		local v4 = v.leading and not v2

		if thread then
			task.cancel(thread)
			thread = nil
		end

		if v4 then
			v2 = true
			callback(...)
		end

		thread = task.delay(duration, fn2, v3, v4, ...)
	end
end

return debounce
