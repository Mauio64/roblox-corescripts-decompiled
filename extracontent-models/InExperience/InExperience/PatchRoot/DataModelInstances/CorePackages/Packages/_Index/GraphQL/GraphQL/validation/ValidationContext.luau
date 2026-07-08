local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local jsutils = ParentParent.jsutils

require(jsutils.ObjMap)

local language = ParentParent.language
local Kind = require(language.kinds).Kind
local visit = require(language.visitor).visit

require(language.ast)
require(ParentParent.error.GraphQLError)

local TypeInfo = require(ParentParent.utilities.TypeInfo)
local TypeInfo2 = TypeInfo.TypeInfo
local visitWithTypeInfo = TypeInfo.visitWithTypeInfo

require(ParentParent.type.schema)
require(ParentParent.type.directives)
require(ParentParent.type.definition)

local t1 = {}
local t2 = {
	__index = t1
}

function t1.new(p1, p2: ((...any) -> ...any)) -- line: 100
	-- upvalues: t2 (copy)
	return (setmetatable({
		_fragments = nil,
		_ast = p1,
		_fragmentSpreads = {},
		_recursivelyReferencedFragments = {},
		_onError = p2
	}, t2))
end
function t1.reportError(p3, p4) -- line: 115
	p3._onError(p4)
end
function t1.getDocument(p5) -- line: 119
	return p5._ast
end
function t1.getFragment(t3: {[any]: any}, s1: string) -- line: 123
	-- upvalues: Kind (copy)
	local _fragments

	if t3._fragments then
		_fragments = t3._fragments
	else
		_fragments = {}

		for _, v in ipairs(t3:getDocument().definitions) do
			if v.kind == Kind.FRAGMENT_DEFINITION then
				_fragments[v.name.value] = v
			end
		end

		t3._fragments = _fragments
	end

	return _fragments[s1]
end
function t1.getFragmentSpreads(p6, p7) -- line: 139
	-- upvalues: Kind (copy)
	local v31 = p6._fragmentSpreads[p7] or {}

	if not p6._fragmentSpreads[p7] then
		local t4 = { p7 }

		while #t4 ~= 0 do
			local v33 = table.remove(t4)

			for _, v in ipairs(v33.selections) do
				if v.kind == Kind.FRAGMENT_SPREAD then
					table.insert(v31, v)
				elseif v.selectionSet then
					table.insert(t4, v.selectionSet)
				end
			end
		end

		p6._fragmentSpreads[p7] = v31
	end

	return v31
end
function t1.getRecursivelyReferencedFragments(p8, p9) -- line: 165
	local v38 = p8._recursivelyReferencedFragments[p9] or {}

	if not p8._recursivelyReferencedFragments[p9] then
		local t5 = {}
		local t6 = { p9.selectionSet }

		while #t6 ~= 0 do
			local v41 = table.remove(t6)

			for _, v in ipairs(p8:getFragmentSpreads(v41)) do
				local value = v.name.value

				if t5[value] ~= true then
					t5[value] = true

					local v45 = p8:getFragment(value)

					if v45 then
						table.insert(v38, v45)
						table.insert(t6, v45.selectionSet)
					end
				end
			end
		end

		p8._recursivelyReferencedFragments[p9] = v38
	end

	return v38
end

local self = setmetatable({}, {
	__index = t1
})
local t7 = {
	__index = self
}

function self.new(p10, p11, p12: ((...any) -> ...any)) -- line: 208
	-- upvalues: t1 (copy), t7 (copy)
	local v49 = t1.new(p10, p12)

	v49._schema = p11

	return (setmetatable(v49, t7))
end
function self.getSchema(p13) -- line: 218
	return p13._schema
end

local self2 = setmetatable({}, {
	__index = t1
})
local t8 = {
	__index = self2
}

function self2.new(p14, p15, p16, p17: ((...any) -> ...any)) -- line: 257
	-- upvalues: t1 (copy), Map (copy), t8 (copy)
	local v55 = t1.new(p15, p17)

	v55._schema = p14
	v55._typeInfo = p16
	v55._variableUsages = Map.new()
	v55._recursiveVariableUsages = Map.new()

	return (setmetatable(v55, t8))
end
function self2.getSchema(p18) -- line: 274
	return p18._schema
end
function self2.getVariableUsages(p19, p20) -- line: 278
	-- upvalues: TypeInfo2 (copy), visit (copy), visitWithTypeInfo (copy)
	local v59 = p19._variableUsages[p20]

	if not v59 then
		local t9 = {}
		local v61 = TypeInfo2.new(p19._schema)

		visit(p20, visitWithTypeInfo(v61, {
			VariableDefinition = function() -- line: 286
				return false
			end,
			Variable = function(_, p22) -- line: 289
				-- upvalues: t9 (copy), v61 (copy)
				table.insert(t9, {
					node = p22,
					type = v61:getInputType(),
					defaultValue = v61:getDefaultValue()
				})
			end
		}))
		v59 = t9
		p19._variableUsages[p20] = v59
	end

	return v59
end
function self2.getRecursiveVariableUsages(p23, p24) -- line: 305
	-- upvalues: Array (copy)
	local v64 = p23._recursiveVariableUsages[p24]

	if not v64 then
		v64 = p23:getVariableUsages(p24)

		for _, v in ipairs(p23:getRecursivelyReferencedFragments(p24)) do
			v64 = Array.concat(v64, p23:getVariableUsages(v))
		end

		p23._recursiveVariableUsages[p24] = v64
	end

	return v64
end
function self2.getType(p25) -- line: 319
	return p25._typeInfo:getType()
end
function self2.getParentType(p26) -- line: 323
	return p26._typeInfo:getParentType()
end
function self2.getInputType(p27) -- line: 327
	return p27._typeInfo:getInputType()
end
function self2.getParentInputType(p28) -- line: 331
	return p28._typeInfo:getParentInputType()
end
function self2.getFieldDef(p29) -- line: 335
	return p29._typeInfo:getFieldDef()
end
function self2.getDirective(p30) -- line: 339
	return p30._typeInfo:getDirective()
end
function self2.getArgument(p31) -- line: 343
	return p31._typeInfo:getArgument()
end
function self2.getEnumValue(p32) -- line: 347
	return p32._typeInfo:getEnumValue()
end

return {
	ASTValidationContext = t1,
	SDLValidationContext = self,
	ValidationContext = self2
}
