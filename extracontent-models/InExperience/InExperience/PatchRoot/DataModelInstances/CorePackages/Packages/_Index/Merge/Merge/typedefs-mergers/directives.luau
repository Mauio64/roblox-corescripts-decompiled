local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local t1 = {}
local print = require(ParentParent.GraphQL).print

require(script.Parent["merge-typedefs_types"])

local isSome = require(ParentParent.Utils).isSome
local deduplicateLists = nil

local function directiveAlreadyExists(p1, p2) -- line: 43
	-- upvalues: Boolean (copy), Array (copy)
	return Boolean.toJSBoolean(Array.find(p1, function(p3) -- line: 49
		-- upvalues: p2 (copy)
		return p3.name.value == p2.name.value
	end))
end
local function nameAlreadyExists(p4, p5) -- line: 54
	-- upvalues: Array (copy)
	return Array.some(p5, function(p6) -- line: 55
		-- upvalues: p4 (copy)
		return p6.value == p4.value
	end)
end
local function mergeArguments(p7, p8) -- line: 60
	-- upvalues: Array (copy), deduplicateLists (ref), Boolean (copy)
	local v22 = Array.concat({}, p8)

	for _, v24 in p7 do
		local v25 = Array.findIndex(v22, function(p9) -- line: 73
			-- upvalues: v24 (copy)
			return p9.name.value == v24.name.value
		end)

		if v25 > -1 then
			local v26 = v22[v25]

			if v26.value.kind == "ListValue" then
				local values = v26.value.values
				local values2 = v24.value.values

				v26.value.values = deduplicateLists(values, values2, function(p10, p11) -- line: 87
					-- upvalues: Boolean (copy), Array (copy)
					local value = p10.value

					return not Boolean.toJSBoolean(value) or not Array.some(p11, function(p12) -- line: 94
						-- upvalues: value (copy)
						return p12.value == value
					end)
				end)
			else
				v26.value = v24.value
			end
		else
			table.insert(v22, v24)
		end
	end

	return v22
end
local function deduplicateDirectives(p13) -- line: 108
	-- upvalues: Array (copy), mergeArguments (copy), isSome (copy)
	return (Array.filter(Array.map(p13, function(p14, p15, p16) -- line: 112
		-- upvalues: Array (copy), mergeArguments (copy)
		local v63 = Array.findIndex(p16, function(p17) -- line: 114
			-- upvalues: p14 (copy)
			return p17.name.value == p14.name.value
		end)

		if v63 ~= p15 then
			local v64 = p16[v63]

			p14.arguments = mergeArguments(p14.arguments, v64.arguments)

			return nil
		end

		return p14
	end), isSome))
end

function t1.mergeDirectives(p18, p19, p20) -- line: 133
	-- upvalues: Boolean (copy), Array (copy), mergeArguments (copy), isSome (copy), directiveAlreadyExists (copy)
	local v33 = if p18 == nil then {} else p18
	local v34 = if p19 == nil then {} else p19
	local v35 = p20 and p20.reverseDirectives
	local v36 = if not Boolean.toJSBoolean(v35) then v34 else v33
	local v37 = if not Boolean.toJSBoolean(v35) then v33 else v34
	local v38 = Array.concat({}, v36)
	local v39 = Array.filter(Array.map(v38, function(p21, p22, p23) -- line: 112
		-- upvalues: Array (copy), mergeArguments (copy)
		local v68 = Array.findIndex(p23, function(p24) -- line: 114
			-- upvalues: p21 (copy)
			return p24.name.value == p21.name.value
		end)

		if v68 ~= p22 then
			local v69 = p23[v68]

			p21.arguments = mergeArguments(p21.arguments, v69.arguments)

			return nil
		end

		return p21
	end), isSome)

	for _, v41 in v37 do
		if Boolean.toJSBoolean(directiveAlreadyExists(v39, v41)) then
			local v42 = Array.findIndex(v39, function(p25) -- line: 155
				-- upvalues: v41 (copy)
				return p25.name.value == v41.name.value
			end)
			local v43 = v39[v42]

			v39[v42].arguments = mergeArguments(Boolean.toJSBoolean(v41.arguments) and v41.arguments or {}, Boolean.toJSBoolean(v43.arguments) and v43.arguments or {})
		else
			table.insert(v39, v41)
		end
	end

	return v39
end

local function validateInputs(p26, p27) -- line: 176
	-- upvalues: print (copy), Object (copy), Boolean (copy), Error (copy)
	local v46 = print(Object.assign({}, p26, {
		description = Object.None
	}))
	local v47 = print(Object.assign({}, p27, {
		description = Object.None
	}))
	local v48 = v46:gsub("directive @w*d*", ""):gsub(" on .*$", "") == v47:gsub("directive @w*d*", ""):gsub(" on .*$", "")

	if not Boolean.toJSBoolean(v48) then
		error(Error.new(("Unable to merge GraphQL directive \"%s\". \nExisting directive:  \n\t%s \nReceived directive: \n\t%s"):format(tostring(p26.name.value), tostring(v47), (tostring(v46)))))
	end
end

function t1.mergeDirective(p28, p29) -- line: 201
	-- upvalues: validateInputs (copy), Object (copy), Array (copy)
	if p29 then
		validateInputs(p28, p29)

		return Object.assign({}, p28, {
			locations = Array.concat({}, p29.locations, Array.filter(p28.locations, function(p30) -- line: 219
				-- upvalues: p29 (copy), Array (copy)
				local locations = p29.locations

				return not Array.some(locations, function(p31) -- line: 55
					-- upvalues: p30 (copy)
					return p31.value == p30.value
				end)
			end))
		})
	end

	return p28
end
function deduplicateLists(p32, p33, p34: ((...any) -> ...any)) -- line: 229
	-- upvalues: Array (copy)
	return Array.concat(p32, Array.filter(p33, function(p35) -- line: 247
		-- upvalues: p34 (copy), p32 (copy)
		return p34(p35, p32)
	end))
end

return t1
