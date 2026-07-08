local ParentParent = script.Parent.Parent.Parent
local jsutils = ParentParent.jsutils
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local didYouMean = require(jsutils.didYouMean).didYouMean
local suggestionList = require(jsutils.suggestionList).suggestionList
local naturalCompare = require(jsutils.naturalCompare).naturalCompare
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local definition = require(ParentParent.type.definition)
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isAbstractType = definition.isAbstractType
local getSuggestedFieldNames = nil
local getSuggestedTypeNames = nil
local t1 = {
	FieldsOnCorrectTypeRule = function(p1) -- line: 36
		-- upvalues: didYouMean (copy), getSuggestedTypeNames (ref), getSuggestedFieldNames (ref), GraphQLError (copy)
		return {
			Field = function(_, p3) -- line: 38
				-- upvalues: p1 (copy), didYouMean (copy), getSuggestedTypeNames (ref), getSuggestedFieldNames (ref), GraphQLError (copy)
				local v34 = p1:getParentType()

				if v34 and not p1:getFieldDef() then
					local v35 = p1:getSchema()
					local value = p3.name.value
					local v37 = didYouMean("to use an inline fragment on", getSuggestedTypeNames(v35, v34, value))

					if v37 == "" then
						v37 = didYouMean(getSuggestedFieldNames(v34, value))
					end

					p1:reportError(GraphQLError.new(("Cannot query field \"%s\" on type \"%s\"."):format(value, v34.name) .. v37, p3))
				end
			end
		}
	end
}

function getSuggestedTypeNames(p4, p5, p6) -- line: 77
	-- upvalues: isAbstractType (copy), Array (copy), isInterfaceType (copy), naturalCompare (copy)
	if not isAbstractType(p5) then
		return {}
	end

	local t2 = {}
	local t3 = {}

	for _, v in ipairs(p4:getPossibleTypes(p5)) do
		if v:getFields():get(p6) then
			t2[v] = true
			t3[v.name] = 1

			for _, v2 in ipairs(v:getInterfaces()) do
				if v2:getFields():get(p6) then
					t2[v2] = true
					t3[v2.name] = (t3[v2.name] or 0) + 1
				end
			end
		end
	end

	local t4 = {}

	for k, _ in pairs(t2) do
		table.insert(t4, k)
	end

	Array.sort(t4, function(p7, p8) -- line: 114
		-- upvalues: t3 (copy), isInterfaceType (copy), p4 (copy), naturalCompare (copy)
		local v40 = t3[p8.name] - t3[p7.name]

		if v40 ~= 0 then
			return v40
		end

		if isInterfaceType(p7) and p4:isSubType(p7, p8) then
			return -1
		end

		if isInterfaceType(p8) and p4:isSubType(p8, p7) then
			return 1
		end

		return naturalCompare(p7.name, p8.name)
	end)

	return Array.map(t4, function(p9) -- line: 131
		return p9.name
	end)
end
function getSuggestedFieldNames(p10, p11) -- line: 140
	-- upvalues: isObjectType (copy), isInterfaceType (copy), suggestionList (copy)
	if isObjectType(p10) or isInterfaceType(p10) then
		local v31 = p10:getFields():keys()

		return suggestionList(p11, v31)
	end

	return {}
end

return t1
