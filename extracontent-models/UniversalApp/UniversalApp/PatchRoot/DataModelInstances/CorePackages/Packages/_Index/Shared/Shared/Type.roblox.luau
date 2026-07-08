local lib = require(script.Parent["Symbol.roblox"])
local v2 = newproxy(true)
local t1 = {}

local function addType(p1) -- line: 32
	-- upvalues: t1 (copy), lib (copy)
	t1[p1] = lib.named("Roact" .. p1)
end

t1.HostChangeEvent = lib.named("RoactHostChangeEvent")
t1.HostEvent = lib.named("RoactHostEvent")

function t1.of(p2) -- line: 39
	-- upvalues: v2 (copy)
	if typeof(p2) ~= "table" then
		return nil
	end

	return p2[v2]
end

getmetatable(v2).__index = t1
getmetatable(v2).__tostring = function() -- line: 49
	return "RoactType"
end

return v2
