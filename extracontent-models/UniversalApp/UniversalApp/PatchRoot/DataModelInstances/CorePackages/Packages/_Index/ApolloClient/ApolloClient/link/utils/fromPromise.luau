local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

local Observable = require(script.Parent.Parent.Parent.utilities).Observable

function t1.fromPromise(p1) -- line: 21
	-- upvalues: Observable (copy)
	return Observable.new(function(p2) -- line: 22
		-- upvalues: p1 (copy)
		p1:andThen(function(p3) -- line: 24
			-- upvalues: p2 (copy)
			p2:next(p3)
			p2:complete()
		end):catch(function(p4) -- line: 28
			-- upvalues: p2 (copy)
			p2.error(p2, p4)
		end)
	end)
end

return t1
