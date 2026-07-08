local t1 = {}
local Observable = require(script.Parent.Parent.Parent.utilities).Observable

function t1.fromError(p1) -- line: 17
	-- upvalues: Observable (copy)
	return Observable.new(function(p2) -- line: 18
		-- upvalues: p1 (copy)
		p2:error(p1)
	end)
end

return t1
