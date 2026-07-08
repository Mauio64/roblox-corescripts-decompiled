local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

local Observable = require(script.Parent.Observable).Observable

function t1.fixObservableSubclass(p1) -- line: 30
	-- upvalues: Observable (copy)
	local function set(p2) -- line: 32
		-- upvalues: p1 (copy), Observable (copy)
		p1[p2] = Observable
	end

	p1["@@species"] = Observable

	return p1
end

return t1
