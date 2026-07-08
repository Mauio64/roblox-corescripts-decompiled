local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLScalarType = GraphQL.GraphQLScalarType
local isScalarType = GraphQL.isScalarType
local isEnumType = GraphQL.isEnumType
local isInterfaceType = GraphQL.isInterfaceType
local isUnionType = GraphQL.isUnionType
local isObjectType = GraphQL.isObjectType
local isSpecifiedScalarType = GraphQL.isSpecifiedScalarType

require(script.Parent.Interfaces)

local String = LuauPolyfill.String

function t1.getResolversFromSchema(p1, b1: boolean?) -- line: 37
	-- upvalues: String (copy), Boolean (copy), isScalarType (copy), isSpecifiedScalarType (copy), GraphQLScalarType (copy), isEnumType (copy), isInterfaceType (copy), isUnionType (copy), isObjectType (copy)
	local t2 = {}
	local v17 = p1:getTypeMap()

	for _, v19 in v17 do
		local v20 = v19[1]

		if not String.startsWith(v20, "__") then
			local v21 = v17:get(v20)

			if Boolean.toJSBoolean(isScalarType(v21)) then
				if not Boolean.toJSBoolean(isSpecifiedScalarType(v21)) then
					local v22 = v21:toConfig()

					v22.astNode = nil

					local serialize = v22.serialize
					local parseValue = v22.parseValue
					local parseLiteral = v22.parseLiteral

					if serialize then
						function v22.serialize(...) -- line: 73
							-- upvalues: serialize (copy), v22 (copy)
							return serialize(v22, ...)
						end
					end

					if parseValue then
						function v22.parseValue(...) -- line: 79
							-- upvalues: parseValue (copy), v22 (copy)
							return parseValue(v22, ...)
						end
					end

					if parseLiteral then
						function v22.parseLiteral(...) -- line: 85
							-- upvalues: parseLiteral (copy), v22 (copy)
							return parseLiteral(v22, ...)
						end
					end

					t2[tostring(v20)] = GraphQLScalarType.new(v22)
				end
			elseif Boolean.toJSBoolean(isEnumType(v21)) then
				t2[tostring(v20)] = {}

				for _, v27 in (v21:getValues()) do
					t2[tostring(v20)][tostring(v27.name)] = v27.value
				end
			elseif Boolean.toJSBoolean(isInterfaceType(v21)) then
				if v21.resolveType ~= nil then
					t2[v20] = {
						__resolveType = v21.resolveType
					}
				end
			elseif Boolean.toJSBoolean(isUnionType(v21)) then
				if v21.resolveType ~= nil then
					t2[v20] = {
						__resolveType = v21.resolveType
					}
				end
			elseif Boolean.toJSBoolean(isObjectType(v21)) then
				t2[tostring(v20)] = {}

				if v21.isTypeOf ~= nil then
					t2[v20].__isTypeOf = v21.isTypeOf
				end

				local v28 = v21:getFields()

				for _, v30 in v28 do
					local v31 = v30[1]
					local v32 = v28:get(v31)

					if v32.subscribe ~= nil then
						t2[tostring(v20)][tostring(v31)] = Boolean.toJSBoolean(t2[tostring(v20)][tostring(v31)]) and t2[tostring(v20)][tostring(v31)] or {}
						t2[tostring(v20)][tostring(v31)].subscribe = v32.subscribe
					end

					if v32.resolve == nil or ((if typeof(v32.resolve) ~= "table" then nil else v32.resolve.name)) == "defaultFieldResolver" then
						continue
					end

					local v33 = if typeof(v32.resolve) ~= "table" then nil else v32.resolve.name

					if v33 == "defaultMergedResolver" then
						if not Boolean.toJSBoolean(b1) then
							continue
						end
					elseif v33 == "defaultFieldResolver" then
						continue
					end

					t2[tostring(v20)][tostring(v31)] = Boolean.toJSBoolean(t2[tostring(v20)][tostring(v31)]) and t2[tostring(v20)][tostring(v31)] or {}
					t2[tostring(v20)][tostring(v31)].resolve = v32.resolve
				end
			end
		end
	end

	return t2
end

return t1
