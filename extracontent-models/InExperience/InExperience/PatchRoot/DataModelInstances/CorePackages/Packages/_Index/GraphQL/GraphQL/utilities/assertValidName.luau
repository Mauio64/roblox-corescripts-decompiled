local ParentParent = script.Parent.Parent
local devAssert = require(ParentParent.jsutils.devAssert).devAssert
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError

local function isValidNameError(s1: string) -- line: 34
	-- upvalues: devAssert (copy), GraphQLError (copy)
	devAssert(type(s1) == "string", "Expected name to be a string.")

	if string.len(s1) > 1 and s1:sub(1, 1) == "_" and s1:sub(2, 2) == "_" then
		return GraphQLError.new("Name \"" .. s1 .. "\" must not begin with \"__\", which is reserved by GraphQL introspection.")
	end

	local start, stop = string.find(s1, "[_%a][_%a%d]*")

	if start ~= 1 or stop ~= string.len(s1) then
		return GraphQLError.new("Names must match [_%a][_%a%d]* but \"" .. s1 .. "\" does not.")
	end

	return nil
end

return {
	assertValidName = function(s2: string) -- line: 23
		-- upvalues: isValidNameError (ref)
		local v6 = isValidNameError(s2)

		if v6 then
			error(v6)
		end

		return s2
	end,
	isValidNameError = isValidNameError
}
