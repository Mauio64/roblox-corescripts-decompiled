local ParentParent = script.Parent.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array
local t1 = {}

require(script.Parent.Observable)

function t1.iterateObserversSafely(p1, s1: string, p2) -- line: 26
	-- upvalues: Array (copy)
	local t2 = {}

	p1:forEach(function(p3) -- line: 37
		-- upvalues: s1 (copy), t2 (copy)
		if p3[s1] ~= nil then
			table.insert(t2, p3)
		end
	end)
	Array.forEach(t2, function(p4) -- line: 43
		-- upvalues: s1 (copy), p2 (copy)
		p4[s1](p4, p2)
	end)
end

return t1
