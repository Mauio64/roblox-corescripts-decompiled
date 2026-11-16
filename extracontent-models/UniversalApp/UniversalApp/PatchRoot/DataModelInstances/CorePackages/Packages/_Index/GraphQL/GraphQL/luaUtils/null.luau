return (setmetatable({ __NULL_IDENTIFIER__ = "__GRAPHQL_NULL_OBJECT__" }, {
	__newindex = function(_, p, _)
		local formatted = ("%q (%s) is not a valid member of %s"):format(tostring(p), typeof(p), "null")

		error(formatted, 2)
	end,
	__metatable = false,
	__tostring = function(): string
		return "null"
	end
}))
