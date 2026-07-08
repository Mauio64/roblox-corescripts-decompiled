local ParentParent = script.Parent.Parent

require(ParentParent.jsutils.ObjMap)

local keyMap = require(ParentParent.jsutils.keyMap).keyMap
local inspect = require(ParentParent.jsutils.inspect).inspect
local invariant = require(ParentParent.jsutils.invariant).invariant

require(ParentParent.language.ast)

local Kind = require(ParentParent.language.kinds).Kind
local definition = require(ParentParent.type.definition)
local isLeafType = definition.isLeafType
local isInputObjectType = definition.isInputObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local null = require(ParentParent.luaUtils.null)
local isMissingVariable = nil

local function valueFromAST(p1, p2, p3) -- line: 37
	-- upvalues: Kind (copy), null (copy), isNonNullType (copy), valueFromAST (copy), isListType (copy), isMissingVariable (ref), isInputObjectType (copy), keyMap (copy), isLeafType (copy), invariant (copy), inspect (copy)
	if not p1 then
		return
	end

	if p1.kind == Kind.VARIABLE then
		local value = p1.name.value

		if p3 == nil or p3[value] == nil then
			return
		end

		local v18 = p3[value]

		if v18 == null and isNonNullType(p2) then
			return
		end

		return v18
	end

	if isNonNullType(p2) then
		if p1.kind == Kind.NULL then
			return
		end

		return valueFromAST(p1, p2.ofType, p3)
	end

	if p1.kind == Kind.NULL then
		return null
	end

	if isListType(p2) then
		local ofType = p2.ofType

		if p1.kind == Kind.LIST then
			local t1 = {}

			for _, v in ipairs(p1.values) do
				if isMissingVariable(v, p3) then
					if isNonNullType(ofType) then
						return
					end

					table.insert(t1, null)

					continue
				end

				local v23 = valueFromAST(v, ofType, p3)

				if v23 == nil then
					return
				end

				table.insert(t1, v23)
			end

			return t1
		end

		local v24 = valueFromAST(p1, ofType, p3)

		if v24 == nil then
			return
		end

		return { v24 }
	end

	if isInputObjectType(p2) then
		if p1.kind ~= Kind.OBJECT then
			return
		end

		local t2 = {}
		local v26 = keyMap(p1.fields, function(p4) -- line: 118
			return p4.name.value
		end)

		for _, v in ipairs(p2:getFields():values()) do
			local v29 = v26[v.name]

			if not v29 or isMissingVariable(v29.value, p3) then
				if v.defaultValue ~= nil then
					t2[v.name] = v.defaultValue

					continue
				end

				if not isNonNullType(v.type) then
					continue
				end

				return
			end

			local v30 = valueFromAST(v29.value, v.type, p3)

			if v30 == nil then
				return
			end

			t2[v.name] = v30
		end

		return t2
	end

	if isLeafType(p2) then
		local u31 = nil

		if not pcall(function() -- line: 148
			-- upvalues: u31 (ref), p2 (copy), p1 (copy), p3 (copy)
			u31 = p2:parseLiteral(p1, p3)
		end) then
			return
		end

		if u31 == nil then
			return
		end

		return u31
	end

	invariant(false, "Unexpected input type: " .. inspect(p2))
end

function isMissingVariable(p5, p6) -- line: 170
	-- upvalues: Kind (copy)
	return p5.kind == Kind.VARIABLE and (p6 == nil or p6[p5.name.value] == nil)
end

return {
	valueFromAST = valueFromAST
}
