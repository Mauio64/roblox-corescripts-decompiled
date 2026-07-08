local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Promise = require(ParentParent.Promise)
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local Kind = GraphQL.Kind
local validate = GraphQL.validate
local specifiedRules = GraphQL.specifiedRules
local concatAST = GraphQL.concatAST
local versionInfo = GraphQL.versionInfo

require(script.Parent.loaders)

local AggregateError = require(script.Parent.AggregateError).AggregateError
local createDefaultRules = nil

function t1.validateGraphQlDocuments(p1, p2, p3) -- line: 66
	-- upvalues: createDefaultRules (ref), Promise (copy), Map (copy), Kind (copy), Array (copy), concatAST (copy), validate (copy)
	local v19 = if p3 == nil then createDefaultRules() else p3

	return Promise.resolve():andThen(function() -- line: 74
		-- upvalues: Map (copy), p2 (copy), Kind (copy), Array (copy), Promise (copy), concatAST (copy), validate (copy), p1 (copy), v19 (copy)
		local v30 = Map.new()
		local t2 = {}

		for _, v33 in p2 do
			if v33.document then
				local t3 = {}

				for _, v36 in v33.document.definitions do
					if v36.kind == Kind.FRAGMENT_DEFINITION then
						v30:set(v36.name.value, v36)
					else
						table.insert(t3, v36)
					end
				end

				table.insert(t2, {
					location = v33.location,
					document = {
						kind = Kind.DOCUMENT,
						definitions = t3
					}
				})
			end
		end

		local t4 = {}
		local t5 = {
			kind = Kind.DOCUMENT,
			definitions = Array.concat({}, v30:values())
		}

		Promise.all(Array.map(t2, function(p4) -- line: 104
			-- upvalues: Promise (copy), concatAST (copy), t5 (copy), validate (copy), p1 (copy), v19 (copy), t4 (copy)
			return Promise.resolve():andThen(function() -- line: 105
				-- upvalues: concatAST (copy), t5 (copy), p4 (copy), validate (copy), p1 (copy), v19 (copy), t4 (copy)
				local v45 = concatAST({
					t5,
					p4.document
				})
				local v46 = validate(p1, v45, v19)

				if #v46 > 0 then
					table.insert(t4, {
						filePath = p4.location,
						errors = v46
					})
				end
			end)
		end)):expect()

		return t4
	end)
end
function t1.checkValidationErrors(p5) -- line: 123
	-- upvalues: Error (copy), AggregateError (copy), Array (copy)
	if #p5 > 0 then
		local t6 = {}

		for _, v23 in p5 do
			for _, v25 in v23.errors do
				local v26 = Error.new()

				v26.name = "GraphQLDocumentError"
				v26.message = ("%s: %s"):format(tostring(v26.name), (tostring(v25.message)))
				v26.stack = v26.message

				if v25.locations then
					for _, v28 in v25.locations do
						v26.stack = tostring(v26.stack) .. ("\n    at %s:%s:%s"):format(tostring(v23.filePath), tostring(v28.line), (tostring(v28.column)))
					end
				end

				table.insert(t6, v26)
			end
		end

		error(AggregateError.new(t6, ("GraphQL Document Validation failed with %s errors;\n  %s"):format(tostring(#t6), (tostring(Array.join(Array.map(t6, function(p6, p7) -- line: 170
			return ("Error %s: %s"):format(tostring(p7), (tostring(p6.stack)))
		end), "\n\n"))))))
	end
end
function createDefaultRules() -- line: 185
	-- upvalues: versionInfo (copy), Array (copy), specifiedRules (copy)
	local t7 = {
		"NoUnusedFragmentsRule",
		"NoUnusedVariablesRule",
		"KnownDirectivesRule"
	}

	if versionInfo.major < 15 then
		t7 = Array.map(t7, function(p8) -- line: 192
			return (p8:gsub("Rule$", "", 1))
		end)
	end

	return Array.filter(specifiedRules, function(p9: ((...any) -> ...any)) -- line: 200
		-- upvalues: Array (copy), t7 (ref)
		local v43 = debug.info(p9, "n")

		return not Array.includes(t7, v43)
	end)
end

t1.createDefaultRules = createDefaultRules

return t1
