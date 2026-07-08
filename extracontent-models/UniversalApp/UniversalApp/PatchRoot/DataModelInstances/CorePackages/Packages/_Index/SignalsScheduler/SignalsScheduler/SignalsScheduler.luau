local u1 = false
local t1 = {}

local function batch(p1: ((...any) -> ...any)) -- line: 7
	-- upvalues: u1 (ref), t1 (copy)
	if not u1 then
		u1 = true
		p1()

		for _, v6 in t1 do
			v6()
		end

		table.clear(t1)
		u1 = false

		return
	end

	p1()
end

return {
	batch = batch,
	flush = function() -- line: 21
		-- upvalues: batch (copy)
		batch(function() -- line: 22
		end)
	end,
	schedule = function(p2: ((...any) -> ...any)) -- line: 25
		-- upvalues: t1 (copy)
		table.insert(t1, p2)
	end
}
