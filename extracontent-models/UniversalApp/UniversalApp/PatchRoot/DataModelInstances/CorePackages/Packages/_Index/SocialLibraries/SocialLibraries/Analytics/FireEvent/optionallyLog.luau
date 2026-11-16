require(script.Parent.Types)

return function(object, callback)
	return function(p: string)
		if object then
			object:info(callback(p))
		end

		return p
	end
end
