local function createEvent()
	local v5 = {}

	local function connect(p2)
		v5[p2] = true
		return function()
			v5[p2] = nil
		end
	end

	local function fire(...)
		local clone = table.clone(v5)

		for k in clone do
			k(...)
		end
	end

	return connect, fire
end

return createEvent
