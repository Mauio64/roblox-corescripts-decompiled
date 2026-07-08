local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.Parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local inspect = require(ParentParent.jsutils.inspect).inspect

require(ParentParent.language.ast)

local isNode = require(script.Parent.ast).isNode
local t1 = {
	Name = {},
	Document = { "definitions" },
	OperationDefinition = {
		"name",
		"variableDefinitions",
		"directives",
		"selectionSet"
	},
	VariableDefinition = {
		"variable",
		"type",
		"defaultValue",
		"directives"
	},
	Variable = { "name" },
	SelectionSet = { "selections" },
	Field = {
		"alias",
		"name",
		"arguments",
		"directives",
		"selectionSet"
	},
	Argument = {
		"name",
		"value"
	},
	FragmentSpread = {
		"name",
		"directives"
	},
	InlineFragment = {
		"typeCondition",
		"directives",
		"selectionSet"
	},
	FragmentDefinition = {
		"name",
		"variableDefinitions",
		"typeCondition",
		"directives",
		"selectionSet"
	},
	IntValue = {},
	FloatValue = {},
	StringValue = {},
	BooleanValue = {},
	NullValue = {},
	EnumValue = {},
	ListValue = { "values" },
	ObjectValue = { "fields" },
	ObjectField = {
		"name",
		"value"
	},
	Directive = {
		"name",
		"arguments"
	},
	NamedType = { "name" },
	ListType = { "type" },
	NonNullType = { "type" },
	SchemaDefinition = {
		"description",
		"directives",
		"operationTypes"
	},
	OperationTypeDefinition = { "type" },
	ScalarTypeDefinition = {
		"description",
		"name",
		"directives"
	},
	ObjectTypeDefinition = {
		"description",
		"name",
		"interfaces",
		"directives",
		"fields"
	},
	FieldDefinition = {
		"description",
		"name",
		"arguments",
		"type",
		"directives"
	},
	InputValueDefinition = {
		"description",
		"name",
		"type",
		"defaultValue",
		"directives"
	},
	InterfaceTypeDefinition = {
		"description",
		"name",
		"interfaces",
		"directives",
		"fields"
	},
	UnionTypeDefinition = {
		"description",
		"name",
		"directives",
		"types"
	},
	EnumTypeDefinition = {
		"description",
		"name",
		"directives",
		"values"
	},
	EnumValueDefinition = {
		"description",
		"name",
		"directives"
	},
	InputObjectTypeDefinition = {
		"description",
		"name",
		"directives",
		"fields"
	},
	DirectiveDefinition = {
		"description",
		"name",
		"arguments",
		"locations"
	},
	SchemaExtension = {
		"directives",
		"operationTypes"
	},
	ScalarTypeExtension = {
		"name",
		"directives"
	},
	ObjectTypeExtension = {
		"name",
		"interfaces",
		"directives",
		"fields"
	},
	InterfaceTypeExtension = {
		"name",
		"interfaces",
		"directives",
		"fields"
	},
	UnionTypeExtension = {
		"name",
		"directives",
		"types"
	},
	EnumTypeExtension = {
		"name",
		"directives",
		"values"
	},
	InputObjectTypeExtension = {
		"name",
		"directives",
		"fields"
	}
}
local v8 = Object.freeze({})
local null = require(ParentParent.luaUtils.null)

local function getVisitFn(p1, s1: string, b1: boolean) -- line: 465
	local v40 = p1[s1]

	if v40 then
		if not b1 and type(v40) == "function" then
			return v40
		end

		local v41 = nil

		if typeof(v40) ~= "function" then
			v41 = if not b1 then v40.enter else v40.leave
		end

		if type(v41) == "function" then
			return v41
		end
	else
		local v42 = if not b1 then p1.enter else p1.leave

		if v42 then
			if type(v42) == "function" then
				return v42
			end

			local v43 = v42[s1]

			if type(v43) == "function" then
				return v43
			end
		end
	end
end

return {
	BREAK = v8,
	REMOVE = null,
	visit = function(p2, p3, p4) -- line: 249
		-- upvalues: t1 (copy), Array (copy), null (copy), isNode (copy), inspect (copy), getVisitFn (ref), v8 (copy)
		local v14 = p4 or t1
		local prev = nil
		local v16 = Array.isArray(p2)
		local t2 = { p2 }
		local n1 = 0
		local t3 = {}
		local v20 = nil
		local t4 = {}
		local t5 = {}

		repeat
			n1 += 1

			local v23 = n1 == #t2 + 1
			local v24 = v23 and #t3 ~= 0
			local v25, v26

			if v23 then
				v25 = if #t5 ~= 0 then t4[#t4] else nil
				v26 = v20
				v20 = table.remove(t5)

				if v24 then
					if v16 then
						v26 = Array.slice(v26)
					else
						local t6 = {}

						for k in pairs(v26) do
							t6[k] = v26[k]
						end

						v26 = t6
					end

					local n2 = 0

					for i = 1, #t3 do
						local v31 = t3[i][1]
						local v32 = t3[i][2]

						if v16 then
							v31 -= n2
						end

						if v16 and v32 == nil then
							Array.splice(v26, v31, 1)
							n2 += 1
						else
							v26[v31] = v32
						end
					end
				end

				n1 = prev.index
				t2 = prev.keys
				t3 = prev.edits
				v16 = prev.inArray
				prev = prev.prev
			else
				v25 = if not v20 then nil else if not v16 then t2[n1] else n1
				v26 = if not v20 then p2 else v20[v25]

				if v26 == nil or v26 == null then
					continue
				end

				if v20 then
					table.insert(t4, v25)
				end
			end

			local v33 = nil

			if not Array.isArray(v26) then
				if not isNode(v26) then
					error("Invalid AST Node: " .. inspect(v26) .. ".")
				end

				local v34 = getVisitFn(p3, v26.kind, v23)

				if v34 then
					v33 = v34(p3, v26, v25, v20, t4, t5)

					if v33 == v8 then
						break
					end

					if v33 == false then
						if not v23 then
							table.remove(t4)

							continue
						end
					elseif v33 ~= nil or v33 == null then
						if v33 == null then
							v33 = nil
						end

						table.insert(t3, {
							v25,
							v33
						})

						if not v23 then
							if not isNode(v33) then
								table.remove(t4)

								continue
							end

							v26 = v33
						end
					end
				end
			end

			if v33 == nil and v24 then
				table.insert(t3, {
					v25,
					v26
				})
			end

			if v23 then
				table.remove(t4)
			else
				prev = {
					inArray = v16,
					index = n1,
					keys = t2,
					edits = t3,
					prev = prev
				}
				v16 = Array.isArray(v26)
				t2 = if not v16 then v14[v26.kind] or {} else v26
				n1 = 0
				t3 = {}

				if v20 then
					table.insert(t5, v20)
				end

				v20 = v26
			end
		until prev == nil

		if #t3 ~= 0 then
			p2 = t3[#t3][2]
		end

		return p2
	end,
	visitInParallel = function(p5) -- line: 412
		-- upvalues: getVisitFn (ref), v8 (copy)
		local t7 = {}

		return {
			enter = function(_, p7, ...) -- line: 417
				-- upvalues: p5 (copy), t7 (copy), getVisitFn (ref), v8 (copy)
				for i = 1, #p5 do
					if t7[i] ~= nil then
						continue
					end

					local v47 = getVisitFn(p5[i], p7.kind, false)

					if not v47 then
						continue
					end

					local v48 = v47(p5[i], p7, ...)

					if v48 ~= false then
						if v48 == v8 then
							t7[i] = v8

							continue
						end

						if v48 == nil then
							continue
						end

						return v48
					end

					t7[i] = p7
				end
			end,
			leave = function(_, ...) -- line: 439
				-- upvalues: p5 (copy), t7 (copy), getVisitFn (ref), v8 (copy)
				local v50 = ...

				for i = 1, #p5 do
					if t7[i] == nil then
						local v52 = getVisitFn(p5[i], v50.kind, true)

						if not v52 then
							continue
						end

						local v53 = v52(p5[i], ...)

						if v53 == v8 then
							t7[i] = v8

							continue
						end

						if v53 == nil or v53 == false then
							continue
						end

						return v53
					end

					if v50 == t7[i] then
						t7[i] = nil
					end
				end
			end
		}
	end,
	getVisitFn = getVisitFn,
	QueryDocumentKeys = t1
}
