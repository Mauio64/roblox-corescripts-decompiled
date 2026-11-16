return {
	isNonNullObject = function(p): boolean
		return p ~= nil and type(p) == "table"
	end
}
