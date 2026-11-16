return function(p): boolean
	local typeName = type(p)

	if typeName == "function" then
		return true
	elseif typeName == "table" then
		return type(p.render) == "function"
	else
		return false
	end
end
