return {
	isNonNullObject = function(p1) -- line: 9
		return p1 ~= nil and type(p1) == "table"
	end
}
