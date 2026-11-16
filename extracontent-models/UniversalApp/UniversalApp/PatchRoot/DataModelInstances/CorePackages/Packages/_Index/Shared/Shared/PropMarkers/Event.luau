local Typeroblox = require(script.Parent.Parent["Type.roblox"])

local Event = {}

local v = {
	__tostring = function(p)
		return string.format("RoactHostEvent(%s)", p.name)
	end
}

setmetatable(Event, {
	__index = function(_, name)
		local v2 = { [Typeroblox] = Typeroblox.HostEvent, name = name }

		setmetatable(v2, v)

		Event[name] = v2

		return v2
	end
})

return Event
