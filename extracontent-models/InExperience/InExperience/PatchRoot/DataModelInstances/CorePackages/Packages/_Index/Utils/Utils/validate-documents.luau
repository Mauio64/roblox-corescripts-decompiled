local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map

local Promise = require(parent.Promise)

local ValidateDocuments = {}

local GraphQL = require(parent.GraphQL)
local Kind = GraphQL.Kind
local validate = GraphQL.validate

local specifiedRules = GraphQL.specifiedRules

local concatAST = GraphQL.concatAST

local versionInfo = GraphQL.versionInfo

require(script.Parent.loaders)

local AggregateError = require(script.Parent.AggregateError)
local aggregateError = AggregateError.AggregateError

local createDefaultRules

function ValidateDocuments.validateGraphQlDocuments(p, items, p2)
	if p2 == nil then
		p2 = createDefaultRules()
	end

	return Promise.resolve():andThen(function()
		local v = Map.new()
		local v2 = {}

		for _, item in items do
			if not item.document then
				continue
			end

			local definitions = {}

			for _, definition in item.document.definitions do
				if definition.kind == Kind.FRAGMENT_DEFINITION then
					v:set(definition.name.value, definition)
				else
					table.insert(definitions, definition)
				end
			end

			table.insert(v2, {
				location = item.location,
				document = { kind = Kind.DOCUMENT, definitions = definitions }
			})
		end

		local v3 = {}
		local v4 = { kind = Kind.DOCUMENT, definitions = Array.concat({}, v:values()) }

		Promise.all(Array.map(v2, function(p3)
			return Promise.resolve():andThen(function()
				local errors = validate(p, concatAST({ v4, p3.document }), p2)

				if #errors > 0 then
					table.insert(v3, { filePath = p3.location, errors = errors })
				end
			end)
		end)):expect()
		return v3
	end)
end
function ValidateDocuments.checkValidationErrors(list)
	if #list > 0 then
		local v = {}

		for _, item in list do
			for _, err in item.errors do
				local v2 = Error.new()
				v2.name = "GraphQLDocumentError"
				v2.message = ("%s: %s"):format(tostring(v2.name), (tostring(err.message)))
				v2.stack = v2.message

				if err.locations then
					for _, location in err.locations do
						v2.stack = tostring(v2.stack) .. ("\n    at %s:%s:%s"):format(
							tostring(item.filePath),
							tostring(location.line),
							(tostring(location.column))
						)
					end
				end

				table.insert(v, v2)
			end
		end

		error(aggregateError.new(
			v,
			("GraphQL Document Validation failed with %s errors;\n  %s"):format(
				tostring(#v),
				(tostring(Array.join(Array.map(v, function(p, p2)
					return ("Error %s: %s"):format(tostring(p2), (tostring(p.stack)))
				end), "\n\n")))
			)
		))
	end
end

createDefaultRules = function()
	local mapped = { "NoUnusedFragmentsRule", "NoUnusedVariablesRule", "KnownDirectivesRule" }

	if versionInfo.major < 15 then
		mapped = Array.map(mapped, function(value)
			return (value:gsub("Rule$", "", 1))
		end)
	end

	return Array.filter(specifiedRules, function(callback): boolean
		local v = debug.info(callback, "n")
		return not Array.includes(mapped, v)
	end)
end

ValidateDocuments.createDefaultRules = createDefaultRules
return ValidateDocuments
