local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local ExtractExtensionsFromSchema = {}

local mapSchema = require(script.Parent.mapSchema)
local mapSchema2 = mapSchema.mapSchema

require(parent.GraphQL)

require(script.Parent.types)

local Interfaces = require(script.Parent.Interfaces)
local MapperKind = Interfaces.MapperKind

function ExtractExtensionsFromSchema.extractExtensionsFromSchema(p)
	local extensionsFromSchema = {
		schemaExtensions = Boolean.toJSBoolean(p.extensions) and p.extensions or {},
		types = {}
	}

	mapSchema2(p, {
		[tostring(MapperKind.OBJECT_TYPE)] = function(p2)
			extensionsFromSchema.types[tostring(p2.name)] = {
				fields = {},
				type = "object",
				extensions = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			}

			return p2
		end,
		[tostring(MapperKind.INTERFACE_TYPE)] = function(p2)
			extensionsFromSchema.types[tostring(p2.name)] = {
				fields = {},
				type = "interface",
				extensions = not Boolean.toJSBoolean(p2.extensions) and {} or p2.extensions
			}

			return p2
		end,
		[tostring(MapperKind.FIELD)] = function(p2, p3, p4)
			extensionsFromSchema.types[p4].fields[p3] = {
				arguments = {},
				extensions = not Boolean.toJSBoolean(p2.extensions) and {} or p2.extensions
			}

			local args = p2.args

			if args ~= nil then
				for _, list in args do
					local v = table.unpack(list)

					extensionsFromSchema.types[p4].fields[p3].arguments[tostring(v)] = Boolean.toJSBoolean(args[tostring(v)].extensions)
						and args[tostring(v)].extensions
						or {}
				end
			end

			return p2
		end,
		[tostring(MapperKind.ENUM_TYPE)] = function(p2)
			extensionsFromSchema.types[tostring(p2.name)] = {
				values = {},
				type = "enum",
				extensions = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			}

			return p2
		end,
		[tostring(MapperKind.ENUM_VALUE)] = function(p2, p3, _, p4)
			extensionsFromSchema.types[p3].values[p4] = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			return p2
		end,
		[tostring(MapperKind.SCALAR_TYPE)] = function(p2)
			extensionsFromSchema.types[tostring(p2.name)] = {
				type = "scalar",
				extensions = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			}

			return p2
		end,
		[tostring(MapperKind.UNION_TYPE)] = function(p2)
			extensionsFromSchema.types[tostring(p2.name)] = {
				type = "union",
				extensions = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			}

			return p2
		end,
		[tostring(MapperKind.INPUT_OBJECT_TYPE)] = function(p2)
			extensionsFromSchema.types[tostring(p2.name)] = {
				fields = {},
				type = "input",
				extensions = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			}

			return p2
		end,
		[tostring(MapperKind.INPUT_OBJECT_FIELD)] = function(p2, p3, p4)
			extensionsFromSchema.types[p4].fields[p3] = {
				extensions = Boolean.toJSBoolean(p2.extensions) and p2.extensions or {}
			}
			return p2
		end
	})

	return extensionsFromSchema
end
return ExtractExtensionsFromSchema
