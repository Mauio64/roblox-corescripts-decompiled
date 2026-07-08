return (setmetatable({
	__NULL_IDENTIFIER__ = "__GRAPHQL_NULL_OBJECT__"
}, {
	__metatable = false,
	__newindex = function(_, p2, _) -- line: 7
		local v4 = ("%q (%s) is not a valid member of %s"):format(tostring(p2), typeof(p2), "null")

		error(v4, 2)
	end,
	__tostring = function() -- line: 17
		return "null"
	end
}))
