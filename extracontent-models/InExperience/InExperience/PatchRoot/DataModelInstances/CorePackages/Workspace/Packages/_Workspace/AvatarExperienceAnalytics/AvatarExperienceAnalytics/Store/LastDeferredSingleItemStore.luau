local u1 = nil

return {
	setSnapshot = function(t1: {[any]: any}) -- line: 10
		-- upvalues: u1 (ref)
		u1 = t1
	end,
	getSnapshot = function() -- line: 14
		-- upvalues: u1 (ref)
		return u1
	end,
	clearSnapshot = function() -- line: 18
		-- upvalues: u1 (ref)
		u1 = nil
	end
}
