local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Iteration = {}

require(script.Parent.Observable)

function Iteration.iterateObserversSafely(object, p: string, p2)
	local v = {}

	object:forEach(function(p3)
		if p3[p] ~= nil then
			table.insert(v, p3)
		end
	end)

	Array.forEach(v, function(p3)
		p3[p](p3, p2)
	end)
end

return Iteration
