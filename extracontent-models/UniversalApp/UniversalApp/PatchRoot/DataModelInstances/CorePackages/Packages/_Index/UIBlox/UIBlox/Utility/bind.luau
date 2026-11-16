return function(callback, p)
	return function(p2, ...)
		if p2 == p then
			return callback(p, ...)
		end

		return callback(p, p2, ...)
	end
end
