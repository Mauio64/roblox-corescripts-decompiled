local createSignal = require(script.Parent.createSignal)

local function createReadableSignal(p1) -- line: 30
	-- upvalues: createSignal (copy)
	local v4, v5 = createSignal()
	local u6 = p1

	local function fire(p2) -- line: 43
		-- upvalues: u6 (ref), v5 (copy)
		u6 = p2
		v5(p2)
	end

	return {
		subscribe = function(_: {[any]: any}, p3: ((...any) -> ...any)) -- line: 35
			-- upvalues: v4 (copy)
			return v4:subscribe(p3)
		end,
		getValue = function(_: {[any]: any}) -- line: 39
			-- upvalues: u6 (ref)
			return u6
		end
	}, fire
end

return createReadableSignal
