return {
	isIteratableObject = function(list): boolean
		return typeof(list) == "table" and (next(list) == nil or #list ~= 0)
	end
}
