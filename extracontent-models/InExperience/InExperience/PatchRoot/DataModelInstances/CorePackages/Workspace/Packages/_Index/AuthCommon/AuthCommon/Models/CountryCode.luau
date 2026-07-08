local t1 = {
	new = function() -- line: 4
		return {}
	end
}

function t1.fromJSON(p1) -- line: 10
	-- upvalues: t1 (copy)
	local v3 = t1.new()

	v3.name = p1.name
	v3.code = p1.code
	v3.prefix = p1.prefix
	v3.localizedName = p1.localizedName
	v3.isDefault = p1.isDefault

	return v3
end

return t1
