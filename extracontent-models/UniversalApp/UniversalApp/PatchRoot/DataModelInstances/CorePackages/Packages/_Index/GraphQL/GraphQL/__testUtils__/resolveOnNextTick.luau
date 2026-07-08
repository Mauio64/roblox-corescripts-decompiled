local Promise = require(script.Parent.Parent.Parent.Promise)

return function() -- line: 11
	-- upvalues: Promise (copy)
	return Promise.defer(function(p1) -- line: 13
		p1(nil)
	end)
end
