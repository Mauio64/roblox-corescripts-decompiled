local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}

require(ParentParent.GraphQL)

local getArgumentValues = require(script.Parent.getArgumentValues).getArgumentValues

local function getDirectivesInExtensions(p1, p2) -- line: 95
	-- upvalues: Array (copy), Object (copy)
	local v13 = if p2 == nil then { "directives" } else p2

	return (Array.reduce(v13, function(p3, p4) -- line: 104
		-- upvalues: Object (copy)
		if p3 == Object.None or p3 == nil then
			return nil
		end

		return p3[p4]
	end, if typeof(p1) ~= "table" or not p1.extensions then Object.None else p1.extensions))
end

t1.getDirectivesInExtensions = getDirectivesInExtensions

local function _getDirectiveInExtensions(p5, s1: string) -- line: 121
	-- upvalues: Array (copy)
	local v16 = Array.filter(p5, function(p6) -- line: 125
		-- upvalues: s1 (copy)
		return p6.name == s1
	end)

	if #v16 == 0 then
		return nil
	end

	return (Array.map(v16, function(p7) -- line: 134
		if p7.args ~= nil then
			return p7.args
		end

		return {}
	end))
end
local function getDirectiveInExtensions(p8, s2: string, p9) -- line: 141
	-- upvalues: Array (copy), Object (copy), Boolean (copy), _getDirectiveInExtensions (copy)
	local v20 = if p9 == nil then { "directives" } else p9
	local v21 = Array.reduce(v20, function(p10, p11) -- line: 151
		-- upvalues: Object (copy)
		if p10 == Object.None or p10 == nil then
			return nil
		end

		return p10[p11]
	end, if typeof(p8) ~= "table" or not p8.extensions then Object.None else p8.extensions)

	if v21 == nil then
		return nil
	end

	if Boolean.toJSBoolean(Array.isArray(v21)) then
		return (_getDirectiveInExtensions(v21, s2))
	end

	local t2 = {}

	for _, v24 in Object.entries(v21) do
		local v25, v26 = table.unpack(v24, 1, 2)

		if Boolean.toJSBoolean(Array.isArray(v26)) then
			for _, v28 in v26 do
				table.insert(t2, {
					name = v25,
					args = v28
				})
			end
		else
			table.insert(t2, {
				name = v25,
				args = v26
			})
		end
	end

	return (_getDirectiveInExtensions(t2, s2))
end

t1.getDirectiveInExtensions = getDirectiveInExtensions

function t1.getDirectives(p12, p13, p14) -- line: 214
	-- upvalues: getDirectivesInExtensions (copy), Boolean (copy), Array (copy), Object (copy), getArgumentValues (copy)
	local v32 = if p14 == nil then { "directives" } else p14
	local v33 = getDirectivesInExtensions(p13, v32)

	if v33 ~= nil and #v33 > 0 then
		return v33
	end

	local v34 = if not Boolean.toJSBoolean(if not Boolean.toJSBoolean(p12) then p12 else p12.getDirectives) then {} else p12:getDirectives()
	local v35 = Array.reduce(v34, function(p15, p16) -- line: 237
		p15[tostring(p16.name)] = p16

		return p15
	end, {})
	local t3 = {}

	if Boolean.toJSBoolean(p13.astNode) then
		table.insert(t3, p13.astNode)
	end

	if Array.indexOf(Object.keys(p13), "extensionASTNodes") ~= -1 and Boolean.toJSBoolean(p13.extensionASTNodes) then
		t3 = Array.concat({}, t3, p13.extensionASTNodes)
	end

	local t4 = {}

	for _, v39 in t3 do
		if Boolean.toJSBoolean(v39.directives) then
			for _, v41 in v39.directives do
				local v42 = v35[tostring(v41.name.value)]

				if Boolean.toJSBoolean(v42) then
					table.insert(t4, {
						name = v41.name.value,
						args = getArgumentValues(v42, v41)
					})
				end
			end
		end
	end

	return t4
end
function t1.getDirective(p17, p18, s3: string, p19) -- line: 278
	-- upvalues: getDirectiveInExtensions (copy), Boolean (copy), Array (copy), Object (copy), getArgumentValues (copy)
	local v47 = if p19 == nil then { "directives" } else p19
	local v48 = getDirectiveInExtensions(p18, s3, v47)

	if v48 ~= nil then
		return v48
	end

	local v49 = if not Boolean.toJSBoolean(if not Boolean.toJSBoolean(p17) then p17 else p17.getDirective) then nil else p17:getDirective(s3)

	if v49 == nil then
		return nil
	end

	local t5 = {}

	if Boolean.toJSBoolean(p18.astNode) then
		table.insert(t5, p18.astNode)
	end

	if Array.indexOf(Object.keys(p18), "extensionASTNodes") ~= -1 and Boolean.toJSBoolean(p18.extensionASTNodes) then
		t5 = Array.concat({}, t5, p18.extensionASTNodes)
	end

	local t6 = {}

	for _, v53 in t5 do
		if Boolean.toJSBoolean(v53.directives) then
			for _, v55 in v53.directives do
				if s3 == v55.name.value then
					table.insert(t6, getArgumentValues(v49, v55))
				end
			end
		end
	end

	if not Boolean.toJSBoolean(#t6) then
		return nil
	end

	return t6
end

return t1
