local Typeroblox = require(script.Parent.Parent["Type.roblox"])

local Change = {}

local v = {
	__tostring = function(p)
		return string.format("RoactHostChangeEvent(%s)", p.name)
	end
}

setmetatable(Change, {
	__index = function(_, name)
		local v2 = { [Typeroblox] = Typeroblox.HostChangeEvent, name = name }

		setmetatable(v2, v)
		Change[name] = v2

		return v2
	end
})

return Change
