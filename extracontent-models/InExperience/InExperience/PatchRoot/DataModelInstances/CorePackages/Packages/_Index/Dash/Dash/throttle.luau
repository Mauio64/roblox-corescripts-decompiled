local scriptParent = script.Parent
local assign = require(scriptParent.assign)

local function throttle(p1, n1: number, t1: {[any]: any}?) -- line: 43
	-- upvalues: assign (copy)
	local t2 = {
		leading = true,
		trailing = true
	}
	local v8 = assign(t2, t1)
	local v9 = math.max(0, n1)
	local leading = v8.leading
	local trailing = v8.trailing
	local n2 = -1e999
	local u13 = nil
	local t3 = {}

	local function clearScheduled() -- line: 59
		-- upvalues: u13 (ref)
		if u13 then
			task.cancel(u13)
			u13 = nil
		end
	end
	local function invoke() -- line: 66
		-- upvalues: n2 (ref), u13 (ref), p1 (copy), t3 (ref)
		n2 = os.clock()
		u13 = nil
		p1(table.unpack(t3))
	end

	return function(...) -- line: 73
		-- upvalues: t3 (ref), n2 (ref), leading (copy), v9 (copy), u13 (ref), p1 (copy), trailing (copy), invoke (copy)
		local elapsed = os.clock()

		t3 = { ... }

		local v18 = elapsed - n2

		if leading and v18 >= v9 then
			if u13 then
				task.cancel(u13)
				u13 = nil
			end

			n2 = os.clock()
			u13 = nil
			p1(table.unpack(t3))

			return
		end

		if trailing and not u13 then
			local v19 = n2 == -1e999 and elapsed or n2
			local v20 = v9 - (elapsed - v19)

			if v20 < 0 then
				v20 = 0
			end

			u13 = task.delay(v20, invoke)
		end
	end
end

return throttle
