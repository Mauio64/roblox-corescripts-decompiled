return {
	isIteratableObject = function(p1) -- line: 27
		if typeof(p1) ~= "table" then
			return false
		end

		if next(p1) == nil then
			return true
		end

		if #p1 == 0 then
			return false
		end

		return true
	end
}
