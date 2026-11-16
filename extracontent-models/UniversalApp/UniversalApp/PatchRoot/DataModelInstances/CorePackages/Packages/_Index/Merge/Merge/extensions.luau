local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

require(parent.GraphQL)

local Utils = require(parent.Utils)

local mergeDeep = Utils.mergeDeep

local Utils2 = require(parent.Utils)
local Extensions = {}

Extensions.extractExtensionsFromSchema = Utils2.extractExtensionsFromSchema

function Extensions.mergeExtensions(p)
	return mergeDeep(p)
end

local function applyExtensionObject(p, p2)
	if not p then
		return
	end

	p.extensions = mergeDeep({
		Boolean.toJSBoolean(p.extensions) and p.extensions or {},
		Boolean.toJSBoolean(p2) and p2 or {}
	})
end
function Extensions.applyExtensions(object, p)
	applyExtensionObject(object, p.schemaExtensions)

	for _, v in Object.entries(Boolean.toJSBoolean(p.types) and p.types or {}) do
		local v2 = v[1]
		local v3 = v[2]

		local kind = object:getType(v2)

		if not Boolean.toJSBoolean(kind) then
			continue
		end

		applyExtensionObject(kind, v3.extensions)

		if v3.type == "object" or v3.type == "interface" then
			for _, v4 in Object.entries(v3.fields) do
				local v5 = v4[1]
				local v6 = v4[2]

				local v7 = kind:getFields():get(v5)

				if not Boolean.toJSBoolean(v7) then
					continue
				end

				applyExtensionObject(v7, v6.extensions)

				for _, list in Object.entries(v6.arguments) do
					local v8, v9 = table.unpack(list, 1, 2)
					applyExtensionObject(Array.find(v7.args, function(p2): boolean
						return p2.name == v8
					end), v9)
				end
			end
		elseif v3.type == "input" then
			for _, list in Object.entries(v3.fields) do
				local v4, v5 = table.unpack(list, 1, 2)

				applyExtensionObject(kind:getFields():get(v4), v5.extensions)
			end
		elseif v3.type == "enum" then
			for _, list in Object.entries(v3.values) do
				local v4, v5 = table.unpack(list, 1, 2)
				applyExtensionObject(kind:getValue(v4), v5)
			end
		end
	end

	return object
end
return Extensions
