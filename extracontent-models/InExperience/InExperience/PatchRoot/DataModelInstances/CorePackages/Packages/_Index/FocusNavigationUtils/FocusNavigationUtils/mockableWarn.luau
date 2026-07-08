local _warn = warn

return (setmetatable({
	mock = function(p1) -- line: 4
		-- upvalues: _warn (ref)
		_warn = p1
	end,
	unmock = function() -- line: 7
		-- upvalues: _warn (ref)
		_warn = warn
	end
}, {
	__call = function(_, ...) -- line: 11
		-- upvalues: _warn (ref)
		_warn(...)
	end
}))
