local parent = script.Parent.Parent
local devAssert = require(parent.jsutils.devAssert)
local devAssert2 = devAssert.devAssert
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError

local isValidNameError

local function assertValidName(p: string)
	local v = isValidNameError(p)

	if v then
		error(v)
	end

	return p
end

isValidNameError = function(value: string)
	devAssert2(type(value) == "string", "Expected name to be a string.")

	if string.len(value) > 1 and value:sub(1, 1) == "_" and value:sub(2, 2) == "_" then
		return graphQLError.new("Name \"" .. value .. "\" must not begin with \"__\", which is reserved by GraphQL introspection.")
	end

	local v, v2 = string.find(value, "[_%a][_%a%d]*")
	local v3

	if v == 1 then
		v3 = string.len(value) == v2
	else
		v3 = false
	end

	if v3 then
		return nil
	end

	return graphQLError.new("Names must match [_%a][_%a%d]* but \"" .. value .. "\" does not.")
end

return { assertValidName = assertValidName, isValidNameError = isValidNameError }
