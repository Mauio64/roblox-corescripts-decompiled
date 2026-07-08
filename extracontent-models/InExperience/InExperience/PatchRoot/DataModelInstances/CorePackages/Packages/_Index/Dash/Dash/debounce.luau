local scriptParent = script.Parent
local assign = require(scriptParent.assign)

local function debounce(p1, n1: number, t1: {[any]: any}?) -- line: 30
	-- upvalues: assign (copy)
	local t2 = {
		leading = false,
		trailing = true
	}
	local v8 = assign(t2, t1)
	local n2 = 0
	local u10 = nil
	local u11 = false

	local function u12() -- line: 41
	end

	if v8.trailing then
		function u12(n3: number, b1: boolean, ...) -- line: 44
			-- upvalues: n2 (ref), u11 (ref), p1 (copy)
			if n3 == n2 then
				u11 = false

				if not b1 then
					p1(...)
				end
			end
		end
	elseif v8.leading then
		function u12(n4: number) -- line: 56
			-- upvalues: n2 (ref), u11 (ref)
			if n4 == n2 then
				u11 = false
			end
		end
	end

	return function(...) -- line: 63
		-- upvalues: n2 (ref), v8 (copy), u11 (ref), u10 (ref), p1 (copy), n1 (copy), u12 (ref)
		n2 += 1

		local v16 = n2
		local v17 = v8.leading and not u11

		if u10 then
			task.cancel(u10)
			u10 = nil
		end

		if v17 then
			u11 = true
			p1(...)
		end

		u10 = task.delay(n1, u12, v16, v17, ...)
	end
end

return debounce
