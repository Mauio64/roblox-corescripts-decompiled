local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local jsutils = ParentParent.jsutils
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local didYouMean = require(jsutils.didYouMean).didYouMean
local suggestionList = require(jsutils.suggestionList).suggestionList
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local language = ParentParent.language
local predicates = require(language.predicates)
local isTypeDefinitionNode = predicates.isTypeDefinitionNode
local isTypeSystemDefinitionNode = predicates.isTypeSystemDefinitionNode
local isTypeSystemExtensionNode = predicates.isTypeSystemExtensionNode
local type = ParentParent.type
local specifiedScalarTypes = require(type.scalars).specifiedScalarTypes
local introspectionTypes = require(type.introspection).introspectionTypes
local t1 = {}
local u20 = nil
local isStandardTypeName = nil
local isSDLNode = nil

function t1.KnownTypeNamesRule(p1) -- line: 43
	-- upvalues: Map (copy), isTypeDefinitionNode (copy), Array (copy), Object (copy), isSDLNode (ref), isStandardTypeName (ref), suggestionList (copy), u20 (ref), GraphQLError (copy), didYouMean (copy)
	local v24 = p1:getSchema()
	local u25 = Map.new()

	if v24 then
		u25 = v24:getTypeMap()
	end

	local t2 = {}

	for _, v in ipairs(p1:getDocument().definitions) do
		if isTypeDefinitionNode(v) then
			t2[v.name.value] = true
		end
	end

	local v29 = Array.concat(u25:keys(), Object.keys(t2))

	return {
		NamedType = function(_, p3, _, p5, _, p7) -- line: 65
			-- upvalues: u25 (ref), t2 (copy), isSDLNode (ref), isStandardTypeName (ref), suggestionList (copy), Array (copy), u20 (ref), v29 (copy), p1 (copy), GraphQLError (copy), didYouMean (copy)
			local value = p3.name.value

			if not u25:get(value) and not t2[value] then
				local v40 = p7[3] or p5
				local v41 = v40 ~= nil and isSDLNode(v40)

				if v41 and isStandardTypeName(value) then
					return
				end

				local v42 = suggestionList(value, v41 and Array.concat(u20, v29) or v29)

				p1:reportError(GraphQLError.new(("Unknown type \"%s\"."):format(value) .. didYouMean(v42), p3))
			end
		end
	}
end

u20 = Array.map(Array.concat(specifiedScalarTypes, introspectionTypes), function(p8) -- line: 93
	return p8.name
end)

function isStandardTypeName(s1: string) -- line: 98
	-- upvalues: Array (copy), u20 (ref)
	return Array.indexOf(u20, s1) ~= -1
end
function isSDLNode(p9) -- line: 102
	-- upvalues: Array (copy), isTypeSystemDefinitionNode (copy), isTypeSystemExtensionNode (copy)
	return not Array.isArray(p9) and (isTypeSystemDefinitionNode(p9) or isTypeSystemExtensionNode(p9))
end

return t1
