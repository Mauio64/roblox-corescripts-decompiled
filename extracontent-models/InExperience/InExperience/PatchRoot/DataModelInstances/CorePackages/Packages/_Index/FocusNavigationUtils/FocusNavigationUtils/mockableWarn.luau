local v = warn
return (setmetatable({
	mock = function(p)
		v = p
	end,
	unmock = function()
		v = warn
	end
}, {
	__call = function(_, ...)
		v(...)
	end
}))
