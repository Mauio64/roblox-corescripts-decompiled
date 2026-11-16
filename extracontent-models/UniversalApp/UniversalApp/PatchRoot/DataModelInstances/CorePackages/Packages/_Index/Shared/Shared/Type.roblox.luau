local Symbolroblox = require(script.Parent["Symbol.roblox"])

local v = newproxy(true)

local v2 = {}

local function addType(p) -- 2 equivalent calls inferred from this helper
	v2[p] = Symbolroblox.named("Roact" .. p)
end

addType("HostChangeEvent") -- inferred equivalent call
addType("HostEvent") -- inferred equivalent call

function v2.of(p)
	if typeof(p) == "table" then
		return p[v]
	end

	return nil
end

getmetatable(v).__index = v2

getmetatable(v).__tostring = function(): string
	return "RoactType"
end

return v
