local parent = script.Parent.Parent.Parent
local jsutils = parent.jsutils
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local didYouMean = require(jsutils.didYouMean)
local didYouMean2 = didYouMean.didYouMean
local suggestionList = require(jsutils.suggestionList)
local suggestionList2 = suggestionList.suggestionList
local naturalCompare = require(jsutils.naturalCompare)
local naturalCompare2 = naturalCompare.naturalCompare
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local definition = require(parent.type.definition)
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isAbstractType = definition.isAbstractType

local getSuggestedFieldNames
local getSuggestedTypeNames

local FieldsOnCorrectTypeRule = {
	FieldsOnCorrectTypeRule = function(object)
		return {
			Field = function(_, p)
				local parentType = object:getParentType()

				if parentType and not object:getFieldDef() then
					local schema = object:getSchema()
					local value = p.name.value

					local v = didYouMean2(
						"to use an inline fragment on",
						getSuggestedTypeNames(schema, parentType, value)
					)

					if v == "" then
						v = didYouMean2(getSuggestedFieldNames(parentType, value))
					end

					object:reportError(graphQLError.new(
						("Cannot query field \"%s\" on type \"%s\"."):format(value, parentType.name) .. v,
						p
					))
				end
			end
		}
	end
}

getSuggestedTypeNames = function(schema, parentType, value)
	if not isAbstractType(parentType) then
		return {}
	end

	local set = {}
	local v = {}

	for _, v2 in ipairs(schema:getPossibleTypes(parentType)) do
		if not v2:getFields():get(value) then
			continue
		end

		set[v2] = true
		v[v2.name] = 1

		for _, v3 in ipairs(v2:getInterfaces()) do
			if not v3:getFields():get(value) then
				continue
			end

			set[v3] = true
			v[v3.name] = (v[v3.name] or 0) + 1
		end
	end

	local v2 = {}

	for k, _ in pairs(set) do
		table.insert(v2, k)
	end

	Array.sort(v2, function(p, p2)
		local v3 = v[p2.name] - v[p.name]

		if v3 ~= 0 then
			return v3
		end

		if isInterfaceType(p) and schema:isSubType(p, p2) then
			return -1
		end

		if isInterfaceType(p2) and schema:isSubType(p2, p) then
			return 1
		end

		return naturalCompare2(p.name, p2.name)
	end)

	return Array.map(v2, function(p)
		return p.name
	end)
end

getSuggestedFieldNames = function(parentType, value)
	if isObjectType(parentType) or isInterfaceType(parentType) then
		return suggestionList2(value, (parentType:getFields():keys()))
	end

	return {}
end

return FieldsOnCorrectTypeRule
