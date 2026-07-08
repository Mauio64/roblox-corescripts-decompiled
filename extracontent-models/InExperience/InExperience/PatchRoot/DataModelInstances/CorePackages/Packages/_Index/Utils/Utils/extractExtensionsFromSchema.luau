local ParentParent = script.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local t1 = {}
local mapSchema = require(script.Parent.mapSchema).mapSchema

require(ParentParent.GraphQL)
require(script.Parent.types)

local MapperKind = require(script.Parent.Interfaces).MapperKind

function t1.extractExtensionsFromSchema(p1) -- line: 42
	-- upvalues: Boolean (copy), mapSchema (copy), MapperKind (copy)
	local t2 = {
		schemaExtensions = Boolean.toJSBoolean(p1.extensions) and p1.extensions or {},
		types = {}
	}

	mapSchema(p1, {
		[tostring(MapperKind.OBJECT_TYPE)] = function(p2) -- line: 48
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[tostring(p2.name)] = {
				type = "object",
				fields = {},
				extensions = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			}

			return p2
		end,
		[tostring(MapperKind.INTERFACE_TYPE)] = function(p3) -- line: 59
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[tostring(p3.name)] = {
				type = "interface",
				fields = {},
				extensions = if not Boolean.toJSBoolean(p3.extensions) then {} else p3.extensions
			}

			return p3
		end,
		[tostring(MapperKind.FIELD)] = function(p4, p5, p6) -- line: 73
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[p6].fields[p5] = {
				arguments = {},
				extensions = if not Boolean.toJSBoolean(p4.extensions) then {} else p4.extensions
			}

			local args = p4.args

			if args ~= nil then
				for _, v15 in args do
					local v16 = table.unpack(v15)

					t2.types[p6].fields[p5].arguments[tostring(v16)] = Boolean.toJSBoolean(args[tostring(v16)].extensions) and args[tostring(v16)].extensions or {}
				end
			end

			return p4
		end,
		[tostring(MapperKind.ENUM_TYPE)] = function(p7) -- line: 110
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[tostring(p7.name)] = {
				type = "enum",
				values = {},
				extensions = Boolean.toJSBoolean(p7.extensions) and p7.extensions or {}
			}

			return p7
		end,
		[tostring(MapperKind.ENUM_VALUE)] = function(p8, p9, _, p11) -- line: 121
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[p9].values[p11] = Boolean.toJSBoolean(p8.extensions) and p8.extensions or {}

			return p8
		end,
		[tostring(MapperKind.SCALAR_TYPE)] = function(p12) -- line: 135
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[tostring(p12.name)] = {
				type = "scalar",
				extensions = Boolean.toJSBoolean(p12.extensions) and p12.extensions or {}
			}

			return p12
		end,
		[tostring(MapperKind.UNION_TYPE)] = function(p13) -- line: 145
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[tostring(p13.name)] = {
				type = "union",
				extensions = Boolean.toJSBoolean(p13.extensions) and p13.extensions or {}
			}

			return p13
		end,
		[tostring(MapperKind.INPUT_OBJECT_TYPE)] = function(p14) -- line: 155
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[tostring(p14.name)] = {
				type = "input",
				fields = {},
				extensions = Boolean.toJSBoolean(p14.extensions) and p14.extensions or {}
			}

			return p14
		end,
		[tostring(MapperKind.INPUT_OBJECT_FIELD)] = function(p15, p16, p17) -- line: 166
			-- upvalues: t2 (copy), Boolean (copy)
			t2.types[p17].fields[p16] = {
				extensions = Boolean.toJSBoolean(p15.extensions) and p15.extensions or {}
			}

			return p15
		end
	})

	return t2
end

return t1
