local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local llama = dependencies.llama
local isEnum = require(script.Parent.Parent.Utils.isEnum)
local t = dependencies.t
local formatKeyValidationError = require(script.Parent.formatKeyValidationError)
local v7 = require(script.Parent.formatErrorForIncorrectKey)(t.strictInterface({
	name = t.any,
	counter = t.optional(t.any)
}))

return function(p1) -- line: 14
	-- upvalues: llama (copy), isEnum (copy), formatKeyValidationError (copy), v7 (copy)
	llama.Dictionary.map(p1, function(p2, p3) -- line: 15
		-- upvalues: isEnum (copy), formatKeyValidationError (copy), v7 (copy)
		local v11 = if not isEnum(p3) then p3 else p3.rawValue()

		assert(type(p2.name) == "string", formatKeyValidationError("name", "a string", v11))
		assert(type(p2.counter) == "number" or p2.counter == nil, formatKeyValidationError("counter", "nil or a number", v11))
		assert(v7(p2, v11))
	end)

	return true
end
