local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}

require(ParentParent.GraphQL)

local mergeDeep = require(ParentParent.Utils).mergeDeep

t1.extractExtensionsFromSchema = require(ParentParent.Utils).extractExtensionsFromSchema

function t1.mergeExtensions(p1) -- line: 44
	-- upvalues: mergeDeep (copy)
	return mergeDeep(p1)
end

local function applyExtensionObject(p2, p3) -- line: 48
	-- upvalues: mergeDeep (copy), Boolean (copy)
	if not p2 then
		return
	end

	p2.extensions = mergeDeep({
		Boolean.toJSBoolean(p2.extensions) and p2.extensions or {},
		Boolean.toJSBoolean(p3) and p3 or {}
	})
end

function t1.applyExtensions(p4, p5) -- line: 69
	-- upvalues: applyExtensionObject (copy), Object (copy), Boolean (copy), Array (copy)
	applyExtensionObject(p4, p5.schemaExtensions)

	for _, v15 in Object.entries(Boolean.toJSBoolean(p5.types) and p5.types or {}) do
		local v16 = v15[1]
		local v17 = v15[2]
		local v18 = p4:getType(v16)

		if Boolean.toJSBoolean(v18) then
			applyExtensionObject(v18, v17.extensions)

			if v17.type == "object" or v17.type == "interface" then
				for _, v20 in Object.entries(v17.fields) do
					local v21 = v20[1]
					local v22 = v20[2]
					local v23 = v18:getFields():get(v21)

					if Boolean.toJSBoolean(v23) then
						applyExtensionObject(v23, v22.extensions)

						for _, v25 in Object.entries(v22.arguments) do
							local v26, v27 = table.unpack(v25, 1, 2)

							applyExtensionObject(Array.find(v23.args, function(p6) -- line: 107
								-- upvalues: v26 (copy)
								return p6.name == v26
							end), v27)
						end
					end
				end
			elseif v17.type == "input" then
				for _, v29 in Object.entries(v17.fields) do
					local v30, v31 = table.unpack(v29, 1, 2)
					local v32 = v18:getFields():get(v30)

					applyExtensionObject(v32, v31.extensions)
				end
			elseif v17.type == "enum" then
				for _, v34 in Object.entries(v17.values) do
					local v35, v36 = table.unpack(v34, 1, 2)
					local v37 = v18:getValue(v35)

					applyExtensionObject(v37, v36)
				end
			end
		end
	end

	return p4
end

return t1
