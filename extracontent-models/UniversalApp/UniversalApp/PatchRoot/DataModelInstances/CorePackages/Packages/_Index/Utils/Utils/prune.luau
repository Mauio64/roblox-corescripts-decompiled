local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local getNamedType = GraphQL.getNamedType
local isObjectType = GraphQL.isObjectType
local isInterfaceType = GraphQL.isInterfaceType
local isUnionType = GraphQL.isUnionType
local isInputObjectType = GraphQL.isInputObjectType
local isSpecifiedScalarType = GraphQL.isSpecifiedScalarType
local isScalarType = GraphQL.isScalarType
local isEnumType = GraphQL.isEnumType

require(script.Parent.types)

local mapSchema = require(script.Parent.mapSchema).mapSchema
local MapperKind = require(script.Parent.Interfaces).MapperKind
local getRootTypes = require(script.Parent.rootTypes).getRootTypes
local getImplementingTypes = require(script.Parent["get-implementing-types"]).getImplementingTypes
local String = LuauPolyfill.String
local visitSchema = nil
local visitQueue = nil
local getDirectivesArgumentsTypeNames = nil

function t1.pruneSchema(p1, p2) -- line: 69
	-- upvalues: visitSchema (ref), String (copy), visitQueue (ref), mapSchema (copy), MapperKind (copy), Boolean (copy), isSpecifiedScalarType (copy), isUnionType (copy), isInputObjectType (copy), isInterfaceType (copy), isObjectType (copy), isScalarType (copy), Object (copy)
	local v28 = if p2 == nil then {} else p2
	local skipEmptyCompositeTypePruning = v28.skipEmptyCompositeTypePruning
	local skipEmptyUnionPruning = v28.skipEmptyUnionPruning
	local skipPruning = v28.skipPruning
	local skipUnimplementedInterfacesPruning = v28.skipUnimplementedInterfacesPruning
	local skipUnusedTypesPruning = v28.skipUnusedTypesPruning
	local t2 = {}
	local u35 = nil

	while true do
		u35 = visitSchema(p1)

		if skipPruning then
			local t3 = {}

			for _, v38 in p1:getTypeMap() do
				local v39 = v38[1]

				if not String.startsWith(v39, "__") then
					local v40 = p1:getType(v39)

					if v40 and skipPruning(v40) then
						table.insert(t3, v39)
					end
				end
			end

			u35 = visitQueue(t3, p1, u35)
		end

		t2 = {}
		p1 = mapSchema(p1, {
			[MapperKind.TYPE] = function(p3) -- line: 111
				-- upvalues: Boolean (copy), u35 (ref), isSpecifiedScalarType (copy), isUnionType (copy), isInputObjectType (copy), isInterfaceType (copy), isObjectType (copy), isScalarType (copy), skipUnusedTypesPruning (copy), skipEmptyUnionPruning (copy), skipEmptyCompositeTypePruning (copy), skipUnimplementedInterfacesPruning (copy), t2 (ref), Object (copy)
				if not Boolean.toJSBoolean(u35:has(p3.name)) and not Boolean.toJSBoolean(isSpecifiedScalarType(p3)) then
					if isUnionType(p3) or isInputObjectType(p3) or isInterfaceType(p3) or isObjectType(p3) or isScalarType(p3) then
						if Boolean.toJSBoolean(skipUnusedTypesPruning) then
							return p3
						end

						if isUnionType(p3) and skipEmptyUnionPruning and not Boolean.toJSBoolean(#p3:getTypes()) then
							return p3
						end

						if (isInputObjectType(p3) or isInterfaceType(p3) or isObjectType(p3)) and skipEmptyCompositeTypePruning and not Boolean.toJSBoolean(#p3:getFields():keys()) then
							return p3
						end

						if isInterfaceType(p3) and skipUnimplementedInterfacesPruning then
							return p3
						end
					end

					table.insert(t2, p3.name)
					u35:delete(p3.name)

					return Object.None
				end

				return p3
			end
		})

		if #t2 == 0 then
			break
		end
	end

	return p1
end
function visitSchema(p4) -- line: 216
	-- upvalues: getRootTypes (copy), visitQueue (ref)
	local t4 = {}

	for _, v44 in getRootTypes(p4) do
		table.insert(t4, v44.name)
	end

	return visitQueue(t4, p4)
end
function visitQueue(p5, p6, p7) -- line: 227
	-- upvalues: Set (copy), Map (copy), Boolean (copy), isUnionType (copy), Array (copy), isInterfaceType (copy), getImplementingTypes (copy), isEnumType (copy), getDirectivesArgumentsTypeNames (ref), isObjectType (copy), getNamedType (copy)
	local v48 = if p7 == nil then Set.new() else p7
	local v49 = Map.new()

	while #p5 ~= 0 do
		local v50 = table.remove(p5)

		if v48:has(v50) and v49[v50] ~= true then
			continue
		end

		local v51 = p6:getType(v50)

		if not Boolean.toJSBoolean(v51) or not v51 then
			continue
		end

		if Boolean.toJSBoolean(isUnionType(v51)) then
			p5 = Array.concat(p5, Array.map(v51:getTypes(), function(p8) -- line: 262
				return p8.name
			end))
		end

		if isInterfaceType(v51) and v49[v50] == true then
			p5 = Array.concat(p5, getImplementingTypes(v51.name, p6))
			v49[tostring(v50)] = false
		end

		if Boolean.toJSBoolean(isEnumType(v51)) then
			p5 = Array.concat(p5, Array.flatMap(v51:getValues(), function(p9) -- line: 301
				-- upvalues: getDirectivesArgumentsTypeNames (ref), p6 (copy)
				if p9.astNode then
					return getDirectivesArgumentsTypeNames(p6, p9.astNode)
				end

				return {}
			end))
		end

		if v51.getInterfaces ~= nil then
			p5 = Array.concat(p5, Array.map(v51:getInterfaces(), function(p10) -- line: 322
				return p10.name
			end))
		end

		if v51.getFields ~= nil then
			local v52 = v51:getFields():entries()

			if #v52 == 0 then
				continue
			end

			for _, v54 in v52 do
				local v55 = v54[2]

				if Boolean.toJSBoolean(isObjectType(v51)) then
					p5 = Array.concat(p5, Array.flatMap(v55.args, function(p11) -- line: 368
						-- upvalues: getNamedType (copy), Array (copy), getDirectivesArgumentsTypeNames (ref), p6 (copy)
						local t5 = { getNamedType(p11.type).name }

						if p11.astNode then
							t5 = Array.concat(t5, getDirectivesArgumentsTypeNames(p6, p11.astNode))
						end

						return t5
					end))
				end

				local v56 = getNamedType(v55.type)

				table.insert(p5, v56.name)

				if Boolean.toJSBoolean(v55.astNode) then
					p5 = Array.concat(p5, getDirectivesArgumentsTypeNames(p6, v55.astNode))
				end

				if isInterfaceType(v56) and not v49:has(v56.name) then
					v49[tostring(v56.name)] = true
				end
			end
		end

		if Boolean.toJSBoolean(v51.astNode) then
			p5 = Array.concat(p5, getDirectivesArgumentsTypeNames(p6, v51.astNode))
		end

		v48:add(v50)
	end

	return v48
end
function getDirectivesArgumentsTypeNames(p12, p13) -- line: 421
	-- upvalues: Array (copy), getNamedType (copy)
	return Array.flatMap(p13.directives or {}, function(p14) -- line: 432
		-- upvalues: p12 (copy), Array (copy), getNamedType (copy)
		local v66 = p12:getDirective(p14.name.value)
		local v67 = if typeof(v66) ~= "table" then nil else v66.args
		local v68 = if v67 == nil then nil else Array.map(v67, function(p15) -- line: 436
			-- upvalues: getNamedType (copy)
			return getNamedType(p15.type).name
		end)

		if v68 ~= nil then
			return v68
		end

		return {}
	end)
end

return t1
