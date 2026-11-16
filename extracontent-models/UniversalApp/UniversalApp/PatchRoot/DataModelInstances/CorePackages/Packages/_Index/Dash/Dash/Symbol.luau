local parent = script.Parent
local class = require(parent.class)

local v = class("Symbol", function(name: string)
	return { name = name }
end)

function v.toString(p)
	return ("Symbol(%s)"):format(p.name)
end

return v
