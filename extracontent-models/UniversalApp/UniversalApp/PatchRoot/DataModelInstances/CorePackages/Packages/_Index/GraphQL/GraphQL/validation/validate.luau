local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local LuauPolyfill = require(scriptParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local devAssert = require(scriptParentParent.jsutils.devAssert).devAssert
local GraphQLError = require(scriptParentParent.error.GraphQLError).GraphQLError

require(scriptParentParent.language.ast)
require(scriptParentParent.type.schema)

local visitor = require(scriptParentParent.language.visitor)
local visit = visitor.visit
local visitInParallel = visitor.visitInParallel
local assertValidSchema = require(scriptParentParent.type.validate).assertValidSchema
local TypeInfo = require(scriptParentParent.utilities.TypeInfo)
local TypeInfo2 = TypeInfo.TypeInfo
local visitWithTypeInfo = TypeInfo.visitWithTypeInfo
local specifiedRules = require(scriptParent.specifiedRules)
local specifiedRules2 = specifiedRules.specifiedRules
local specifiedSDLRules = specifiedRules.specifiedSDLRules
local ValidationContext = require(scriptParent.ValidationContext)
local SDLValidationContext = ValidationContext.SDLValidationContext
local ValidationContext2 = ValidationContext.ValidationContext
local t5 = {
	validate = function(p1, p2, p3, t1: {[any]: any}?, p4) -- line: 64
		-- upvalues: specifiedRules2 (copy), TypeInfo2 (copy), devAssert (copy), assertValidSchema (copy), ValidationContext2 (copy), GraphQLError (copy), visitInParallel (copy), Array (copy), visit (copy), visitWithTypeInfo (copy)
		local v28 = p3 or specifiedRules2
		local v29 = t1 or {
			maxErrors = nil
		}
		local v30 = p4 or TypeInfo2.new(p1)

		devAssert(p2, "Must provide document.")
		assertValidSchema(p1)

		local t2 = {}
		local t3 = {}
		local v33 = ValidationContext2.new(p1, p2, v30, function(p5) -- line: 82
			-- upvalues: v29 (copy), t3 (copy), GraphQLError (copy), t2 (copy)
			if v29.maxErrors ~= nil and #t3 >= v29.maxErrors then
				table.insert(t3, GraphQLError.new("Too many validation errors, error limit reached. Validation aborted."))
				error(t2)
			end

			table.insert(t3, p5)
		end)
		local v34 = visitInParallel(Array.map(v28, function(p6) -- line: 98
			-- upvalues: v33 (copy)
			return p6(v33)
		end))
		local ok, result = pcall(function() -- line: 103
			-- upvalues: visit (copy), p2 (copy), visitWithTypeInfo (copy), v30 (copy), v34 (copy)
			visit(p2, visitWithTypeInfo(v30, v34))
		end)

		if not ok and result ~= t2 then
			error(result)
		end

		return t3
	end,
	validateSDL = function(p7, p8, p9) -- line: 118
		-- upvalues: specifiedSDLRules (copy), SDLValidationContext (copy), Array (copy), visit (copy), visitInParallel (copy)
		local v40 = p9 or specifiedSDLRules
		local t4 = {}
		local v42 = SDLValidationContext.new(p7, p8, function(p10) -- line: 126
			-- upvalues: t4 (copy)
			table.insert(t4, p10)
		end)
		local v43 = Array.map(v40, function(p11) -- line: 129
			-- upvalues: v42 (copy)
			return p11(v42)
		end)

		visit(p7, visitInParallel(v43))

		return t4
	end
}

function t5.assertValidSDL(p12) -- line: 142
	-- upvalues: t5 (copy), Error (copy), Array (copy)
	local v45 = t5.validateSDL(p12)

	if #v45 ~= 0 then
		error(Error.new(table.concat(Array.map(v45, function(p13) -- line: 146
			return p13.message
		end), "\n\n")))
	end
end
function t5.assertValidSDLExtension(p14, p15) -- line: 160
	-- upvalues: t5 (copy), Error (copy), Array (copy)
	local v48 = t5.validateSDL(p14, p15)

	if #v48 ~= 0 then
		error(Error.new(table.concat(Array.map(v48, function(p16) -- line: 164
			if typeof(p16) == "string" then
				return p16
			end

			return p16.message
		end), "\n\n")))
	end
end

return t5
