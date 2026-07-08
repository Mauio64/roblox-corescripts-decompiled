local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local GraphQLObjectType = require(ParentParent.GraphQL).GraphQLObjectType
local MapperKind = require(script.Parent.Interfaces).MapperKind
local mapSchema = require(script.Parent.mapSchema)
local mapSchema2 = mapSchema.mapSchema
local correctASTNodes = mapSchema.correctASTNodes
local addTypes = require(script.Parent.addTypes).addTypes
local Map = LuauPolyfill.Map

function t1.appendObjectFields(p1, s1: string, p2) -- line: 41
	-- upvalues: addTypes (copy), GraphQLObjectType (copy), mapSchema2 (copy), MapperKind (copy), Map (copy), correctASTNodes (copy), Object (copy)
	if p1:getType(s1) == nil then
		return addTypes(p1, { GraphQLObjectType.new({
			name = s1,
			fields = p2
		}) })
	end

	return mapSchema2(p1, {
		[MapperKind.OBJECT_TYPE] = function(p3) -- line: 54
			-- upvalues: s1 (copy), Map (copy), p2 (copy), correctASTNodes (copy), GraphQLObjectType (copy), Object (copy)
			if p3.name == s1 then
				local v30 = p3:toConfig()
				local fields = v30.fields
				local v32 = Map.new()

				for _, v34 in fields do
					local v35 = v34[1]

					v32:set(v35, fields:get(v35))
				end

				for _, v37 in p2 do
					local v38 = v37[1]

					v32:set(v38, p2:get(v38))
				end

				return (correctASTNodes(GraphQLObjectType.new(Object.assign({}, v30, {
					fields = v32
				}))))
			end

			return nil
		end
	})
end
function t1.removeObjectFields(p4, s2: string, p5: ((...any) -> ...any)) -- line: 100
	-- upvalues: Map (copy), mapSchema2 (copy), MapperKind (copy), Boolean (copy), correctASTNodes (copy), GraphQLObjectType (copy), Object (copy)
	local v19 = Map.new()

	return {
		mapSchema2(p4, {
			[MapperKind.OBJECT_TYPE] = function(p6) -- line: 112
				-- upvalues: s2 (copy), Map (copy), Boolean (copy), p5 (copy), v19 (copy), correctASTNodes (copy), GraphQLObjectType (copy), Object (copy)
				if p6.name == s2 then
					local v40 = p6:toConfig()
					local fields = v40.fields
					local v42 = Map.new()

					for _, v44 in fields do
						local v45 = table.unpack(v44)
						local v46 = fields:get(v45)

						if Boolean.toJSBoolean(p5(v45, v46)) then
							v19:set(v45, v46)
						else
							v42:set(v45, v46)
						end
					end

					return (correctASTNodes(GraphQLObjectType.new(Object.assign({}, v40, {
						fields = v42
					}))))
				end

				return nil
			end
		}),
		v19
	}
end
function t1.selectObjectFields(p7, s3: string, p8: ((...any) -> ...any)) -- line: 160
	-- upvalues: Map (copy), mapSchema2 (copy), MapperKind (copy), Boolean (copy)
	local v23 = Map.new()

	mapSchema2(p7, {
		[tostring(MapperKind.OBJECT_TYPE)] = function(p9) -- line: 170
			-- upvalues: s3 (copy), Boolean (copy), p8 (copy), v23 (copy)
			if p9.name == s3 then
				local fields = p9:toConfig().fields

				for _, v50 in fields do
					local v51 = v50[1]
					local v52 = fields:get(v51)

					if Boolean.toJSBoolean(p8(v51, v52)) then
						v23:set(v51, v52)
					end
				end
			end

			return nil
		end
	})

	return v23
end
function t1.modifyObjectFields(p10, s4: string, p11: ((...any) -> ...any), p12) -- line: 200
	-- upvalues: Map (copy), mapSchema2 (copy), MapperKind (copy), Boolean (copy), correctASTNodes (copy), GraphQLObjectType (copy), Object (copy)
	local v28 = Map.new()

	return {
		mapSchema2(p10, {
			[MapperKind.OBJECT_TYPE] = function(p13) -- line: 213
				-- upvalues: s4 (copy), Map (copy), Boolean (copy), p11 (copy), v28 (copy), p12 (copy), correctASTNodes (copy), GraphQLObjectType (copy), Object (copy)
				if p13.name == s4 then
					local v54 = p13:toConfig()
					local fields = v54.fields
					local v56 = Map.new()

					for _, v58 in fields do
						local v59 = v58[1]
						local v60 = fields:get(v59)

						if Boolean.toJSBoolean(p11(v59, v60)) then
							v28:set(v59, v60)
						else
							v56:set(v59, v60)
						end
					end

					for _, v62 in p12 do
						local v63 = v62[1]

						v56:set(v63, (p12:get(v63)))
					end

					return (correctASTNodes(GraphQLObjectType.new(Object.assign({}, v54, {
						fields = v56
					}))))
				end

				return nil
			end
		}),
		v28
	}
end

return t1
