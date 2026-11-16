require(script.Parent.Parent.Types)

return function(object, callback)
	return function(p)
		if object then
			object:info(callback(p))
		end

		return p
	end
end
