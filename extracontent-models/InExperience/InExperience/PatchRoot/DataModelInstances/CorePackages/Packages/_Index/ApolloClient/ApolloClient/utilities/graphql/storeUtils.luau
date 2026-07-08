local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local HttpService = game:GetService("HttpService")
local t1 = {}
local u8 = nil
local stringify = nil
local isField = nil

require(script.Parent.types)
require(ParentParentParent.GraphQL)

local InvariantError = require(ParentParent.jsutils.invariant).InvariantError
local isNonNullObject = require(script.Parent.Parent.common.objects).isNonNullObject
local fragments = require(script.Parent.fragments)
local objectKeysForEach = require(ParentParent.luaUtils.objectKeysForEach)
local getFragmentFromSelection = fragments.getFragmentFromSelection

function t1.makeReference(s1: string) -- line: 59
	return {
		__ref = tostring(s1)
	}
end
function t1.isReference(p1) -- line: 64
	return type(p1) == "table" and type(p1.__ref) == "string"
end
function t1.isDocumentNode(p2) -- line: 74
	-- upvalues: isNonNullObject (copy), Array (copy)
	return isNonNullObject(p2) and (p2.kind == "Document" and Array.isArray(p2.definitions))
end

local function isStringValue(p3) -- line: 81
	return p3.kind == "StringValue"
end
local function isBooleanValue(p4) -- line: 85
	return p4.kind == "BooleanValue"
end
local function isIntValue(p5) -- line: 89
	return p5.kind == "IntValue"
end
local function isFloatValue(p6) -- line: 93
	return p6.kind == "FloatValue"
end
local function isVariable(p7) -- line: 97
	return p7.kind == "Variable"
end
local function isObjectValue(p8) -- line: 101
	return p8.kind == "ObjectValue"
end
local function isListValue(p9) -- line: 105
	return p9.kind == "ListValue"
end
local function isEnumValue(p10) -- line: 109
	return p10.kind == "EnumValue"
end
local function isNullValue(p11) -- line: 113
	return p11.kind == "NullValue"
end
local function valueToObjectRepresentation(p12, p13, p14, p15) -- line: 117
	-- upvalues: Array (copy), valueToObjectRepresentation (copy), InvariantError (copy)
	if p14.kind == "IntValue" or p14.kind == "FloatValue" then
		p12[p13.value] = tonumber(p14.value)

		return
	end

	if p14.kind == "BooleanValue" or p14.kind == "StringValue" then
		p12[p13.value] = p14.value

		return
	end

	if p14.kind == "ObjectValue" then
		local t2 = {}

		Array.map(p14.fields, function(p16) -- line: 125
			-- upvalues: valueToObjectRepresentation (copy), t2 (copy), p15 (copy)
			valueToObjectRepresentation(t2, p16.name, p16.value, p15)

			return nil
		end)
		p12[p13.value] = t2

		return
	end

	if p14.kind == "Variable" then
		local v45 = (p15 or {})[p14.name.value]

		p12[p13.value] = v45

		return
	end

	if p14.kind == "ListValue" then
		p12[p13.value] = Array.map(p14.values, function(p17) -- line: 136
			-- upvalues: valueToObjectRepresentation (copy), p13 (copy), p15 (copy)
			local t3 = {}

			valueToObjectRepresentation(t3, p13, p17, p15)

			return t3[p13.value]
		end)

		return
	end

	if p14.kind == "EnumValue" then
		p12[p13.value] = p14.value

		return
	end

	if p14.kind == "NullValue" then
		p12[p13.value] = nil

		return
	end

	error(InvariantError.new(tostring(("The inline argument \"%s\" of kind \"%s\""):format(p13.value, p14.kind)) .. "is not supported. Use variables instead of inline arguments to " .. "overcome this limitation."))
end

t1.valueToObjectRepresentation = valueToObjectRepresentation

function t1.storeKeyNameFromField(p18, p19) -- line: 158
	-- upvalues: Array (copy), valueToObjectRepresentation (copy), u8 (ref)
	local t4 = nil

	if p18.directives then
		t4 = {}
		Array.forEach(p18.directives, function(p20) -- line: 162
			-- upvalues: t4 (ref), Array (copy), valueToObjectRepresentation (copy), p19 (copy)
			t4[p20.name.value] = {}

			if p20.arguments then
				Array.forEach(p20.arguments, function(p21) -- line: 166
					-- upvalues: valueToObjectRepresentation (copy), t4 (ref), p20 (copy), p19 (copy)
					local name = p21.name
					local value = p21.value

					valueToObjectRepresentation(t4[p20.name.value], name, value, p19)
				end)
			end
		end)
	end

	local t5 = nil

	if p18.arguments and #p18.arguments > 0 then
		t5 = {}
		Array.forEach(p18.arguments, function(p22) -- line: 177
			-- upvalues: valueToObjectRepresentation (copy), t5 (ref), p19 (copy)
			local name = p22.name
			local value = p22.value

			valueToObjectRepresentation(t5, name, value, p19)
		end)
	end

	return u8(p18.name.value, t5, t4)
end

local t6 = {
	"connection",
	"include",
	"skip",
	"client",
	"rest",
	"export"
}

u8 = Object.assign(setmetatable({}, {
	__call = function(_, s2: string, t7: {[any]: any}?, p24) -- line: 201
		-- upvalues: Array (copy), stringify (ref), objectKeysForEach (copy), t6 (copy)
		if t7 and (p24 and p24.connection and p24.connection.key) then
			if p24.connection.filter and #p24.connection.filter > 0 then
				local v54 = if not p24.connection.filter then {} else p24.connection.filter

				Array.sort(v54, nil)

				local t8 = {}

				Array.forEach(v54, function(p25) -- line: 227
					-- upvalues: t8 (copy), t7 (copy)
					t8[p25] = t7[p25]
				end)

				return ("%s(%s)"):format(p24.connection.key, stringify(t8))
			end

			return p24.connection.key
		end

		local u56 = s2

		if t7 then
			u56 ..= ("(%s)"):format((stringify(t7)))
		end

		if p24 then
			objectKeysForEach(p24, function(p26) -- line: 254
				-- upvalues: Array (copy), t6 (copy), p24 (copy), u56 (ref), stringify (ref)
				if Array.indexOf(t6, p26) ~= -1 then
					return
				end

				if p24[p26] and next(p24[p26]) ~= nil then
					u56 ..= ("@%s(%s)"):format(p26, stringify(p24[p26]))

					return
				end

				u56 ..= ("@%s"):format(p26)
			end)
		end

		return u56
	end
}), {
	setStringify = function(_, p28) -- line: 273
		-- upvalues: stringify (ref)
		local v59 = stringify

		stringify = p28

		return v59
	end
})
t1.getStoreKeyName = u8

function stringify(p29) -- line: 284
	-- upvalues: isNonNullObject (copy), HttpService (copy), Array (copy), Object (copy), stringify (ref)
	if not isNonNullObject(p29) then
		return HttpService:JSONEncode(p29)
	end

	local v61 = Array.map(Array.sort(Object.keys(p29), nil), function(p30) -- line: 295
		-- upvalues: stringify (ref), p29 (copy)
		return {
			p30,
			stringify(p29[p30])
		}
	end)

	if Array.isArray(p29) then
		return ("[%s]"):format(Array.join(Array.map(v61, function(p31) -- line: 301
			return p31[2]
		end), ","))
	end

	return ("{%s}"):format(Array.join(Array.map(v61, function(p32) -- line: 308
		return ("\"%s\":%s"):format(p32[1], p32[2])
	end), ","))
end
function t1.argumentsObjectFromField(p33, t9: {[any]: any}) -- line: 329
	-- upvalues: Array (copy), valueToObjectRepresentation (copy)
	if p33.arguments and #p33.arguments > 0 then
		local t10 = {}

		Array.forEach(p33.arguments, function(p34) -- line: 334
			-- upvalues: valueToObjectRepresentation (copy), t10 (copy), t9 (copy)
			local name = p34.name
			local value = p34.value

			valueToObjectRepresentation(t10, name, value, t9)
		end)

		return t10
	end

	return nil
end
function t1.resultKeyNameFromField(p35) -- line: 344
	if p35.alias then
		return p35.alias.value
	end

	return p35.name.value
end

local function getTypenameFromResult(t11: {[any]: any}, p36, p37) -- line: 355
	-- upvalues: isField (ref), getTypenameFromResult (copy), getFragmentFromSelection (copy)
	if typeof(t11.__typename) == "string" then
		return t11.__typename
	end

	for _, v in ipairs(p36.selections) do
		if not isField(v) then
			local v71 = getTypenameFromResult(t11, getFragmentFromSelection(v, p37).selectionSet, p37)

			if typeof(v71) ~= "string" then
				continue
			end

			return v71
		end

		if v.name.value == "__typename" then
			return t11[if not v.alias then v.name.value else v.alias.value]
		end
	end

	return nil
end

t1.getTypenameFromResult = getTypenameFromResult

function isField(p38) -- line: 385
	return p38.kind == "Field"
end

t1.isField = isField

function t1.isInlineFragment(p39) -- line: 390
	return p39.kind == "InlineFragment"
end

return t1
