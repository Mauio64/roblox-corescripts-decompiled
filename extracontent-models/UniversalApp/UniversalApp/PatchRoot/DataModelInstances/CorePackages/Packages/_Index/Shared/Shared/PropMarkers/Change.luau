local lib = require(script.Parent.Parent["Type.roblox"])
local t1 = {}
local t2 = {
	__tostring = function(p1) -- line: 33
		return string.format("RoactHostChangeEvent(%s)", p1.name)
	end
}

setmetatable(t1, {
	__index = function(_, p3) -- line: 39
		-- upvalues: lib (copy), t2 (copy), t1 (copy)
		local t3 = {
			[lib] = lib.HostChangeEvent,
			name = p3
		}

		setmetatable(t3, t2)
		t1[p3] = t3

		return t3
	end
})

return t1
