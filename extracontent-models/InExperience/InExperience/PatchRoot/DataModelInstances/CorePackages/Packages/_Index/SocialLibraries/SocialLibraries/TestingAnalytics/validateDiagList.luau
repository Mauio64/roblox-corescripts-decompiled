local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local llama = dependencies.llama
local isEnum = require(script.Parent.Parent.Utils.isEnum)
local t = dependencies.t
local formatKeyValidationError = require(script.Parent.formatKeyValidationError)
local formatErrorForIncorrectKey = require(script.Parent.formatErrorForIncorrectKey)

local v = formatErrorForIncorrectKey(t.strictInterface({ name = t.any, counter = t.optional(t.any) }))

return function(p): boolean
	llama.Dictionary.map(p, function(p2, p3)
		if isEnum(p3) then
			p3 = p3.rawValue()
		end

		assert(type(p2.name) == "string", formatKeyValidationError("name", "a string", p3))
		assert(
			type(p2.counter) == "number" or p2.counter == nil,
			formatKeyValidationError("counter", "nil or a number", p3)
		)

		assert(v(p2, p3))
	end)

	return true
end
