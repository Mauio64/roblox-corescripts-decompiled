local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local null = require(ParentParent.luaUtils.null)
local jsutils = ParentParent.jsutils
local language = ParentParent.language
local GraphQLError = require(ParentParent.error.GraphQLError).GraphQLError
local inspect = require(jsutils.inspect).inspect
local Kind = require(language.kinds).Kind
local print = require(language.printer).print
local definition = require(ParentParent.type.definition)
local getNamedType = definition.getNamedType
local isNonNullType = definition.isNonNullType
local isLeafType = definition.isLeafType
local isObjectType = definition.isObjectType
local isListType = definition.isListType
local isInterfaceType = definition.isInterfaceType
local typeFromAST = require(ParentParent.utilities.typeFromAST).typeFromAST
local t1 = {}
local findConflictsWithinSelectionSet = nil
local collectConflictsBetweenFieldsAndFragment = nil
local collectConflictsBetween = nil
local collectConflictsWithin = nil
local collectConflictsBetweenFragments = nil
local getFieldsAndFragmentNames = nil
local getReferencedFieldsAndFragmentNames = nil
local findConflict = nil
local sameArguments = nil
local doTypesConflict = nil
local subfieldConflicts = nil
local t6 = nil

local function reasonMessage(p1) -- line: 49
	-- upvalues: Array (copy), reasonMessage (copy)
	if Array.isArray(p1) then
		return table.concat(Array.map(p1, function(p2) -- line: 52
			-- upvalues: reasonMessage (copy)
			local v204 = p2[1]
			local v205 = p2[2]

			return ("subfields \"%s\" conflict because "):format(v204) .. reasonMessage(v205)
		end), " and ")
	end

	return p1
end

function t1.OverlappingFieldsCanBeMergedRule(p3) -- line: 70
	-- upvalues: t6 (ref), findConflictsWithinSelectionSet (ref), Array (copy), reasonMessage (copy), GraphQLError (copy)
	local v42 = t6.new()
	local t2 = {}

	return {
		SelectionSet = function(_, p5) -- line: 82
			-- upvalues: findConflictsWithinSelectionSet (ref), p3 (copy), t2 (copy), v42 (copy), Array (copy), reasonMessage (copy), GraphQLError (copy)
			local v208 = findConflictsWithinSelectionSet(p3, t2, v42, p3:getParentType(), p5)

			for _, v in ipairs(v208) do
				local v211 = v[1]
				local v212 = v211[1]
				local v213 = v211[2]
				local v214 = v[2]
				local v215 = v[3]
				local v216 = if not Array.isArray(v213) then v213 else table.concat(Array.map(v213, function(p6) -- line: 52
					-- upvalues: reasonMessage (copy)
					local v227 = p6[1]
					local v228 = p6[2]

					return ("subfields \"%s\" conflict because "):format(v227) .. reasonMessage(v228)
				end), " and ")

				p3:reportError(GraphQLError.new(("Fields \"%s\" conflict because %s. Use different aliases on the fields to fetch both if this was intentional."):format(v212, v216), Array.concat(v214, v215)))
			end
		end
	}
end
function findConflictsWithinSelectionSet(p7, p8, p9, p10, p11) -- line: 168
	-- upvalues: getFieldsAndFragmentNames (ref), collectConflictsWithin (ref), collectConflictsBetweenFieldsAndFragment (ref), collectConflictsBetweenFragments (ref)
	local t3 = {}
	local v50 = getFieldsAndFragmentNames(p7, p8, p10, p11)
	local v51 = v50[1]
	local v52 = v50[2]

	collectConflictsWithin(p7, t3, p8, p9, v51)

	if #v52 ~= 0 then
		for i = 1, #v52 do
			collectConflictsBetweenFieldsAndFragment(p7, t3, p8, p9, false, v51, v52[i])

			for j = i + 1, #v52 do
				collectConflictsBetweenFragments(p7, t3, p8, p9, false, v52[i], v52[j])
			end
		end
	end

	return t3
end
function collectConflictsBetweenFieldsAndFragment(p12, p13, p14, p15, p16, p17, p18) -- line: 230
	-- upvalues: getReferencedFieldsAndFragmentNames (ref), collectConflictsBetween (ref), collectConflictsBetweenFieldsAndFragment (ref)
	local v62 = p12:getFragment(p18)

	if not v62 then
		return
	end

	local v63 = getReferencedFieldsAndFragmentNames(p12, p14, v62)
	local v64 = v63[1]
	local v65 = v63[2]

	if p17 == v64 then
		return
	end

	collectConflictsBetween(p12, p13, p14, p15, p16, p17, v64)

	for i = 1, #v65 do
		collectConflictsBetweenFieldsAndFragment(p12, p13, p14, p15, p16, p17, v65[i])
	end
end
function collectConflictsBetweenFragments(p19, p20, p21, p22, p23, p24, p25) -- line: 285
	-- upvalues: getReferencedFieldsAndFragmentNames (ref), collectConflictsBetween (ref), collectConflictsBetweenFragments (ref)
	if p24 == p25 then
		return
	end

	if p22:has(p24, p25, p23) then
		return
	end

	p22:add(p24, p25, p23)

	local v74 = p19:getFragment(p24)
	local v75 = p19:getFragment(p25)

	if not v74 or not v75 then
		return
	end

	local v76 = getReferencedFieldsAndFragmentNames(p19, p21, v74)
	local v77 = v76[1]
	local v78 = v76[2]
	local v79 = getReferencedFieldsAndFragmentNames(p19, p21, v75)
	local v80 = v79[1]
	local v81 = v79[2]

	collectConflictsBetween(p19, p20, p21, p22, p23, v77, v80)

	for i = 1, #v81 do
		collectConflictsBetweenFragments(p19, p20, p21, p22, p23, p24, v81[i])
	end

	for i = 1, #v78 do
		collectConflictsBetweenFragments(p19, p20, p21, p22, p23, v78[i], p25)
	end
end

local function findConflictsBetweenSubSelectionSets(p26, p27, p28, p29, p30, p31, p32, p33) -- line: 370
	-- upvalues: getFieldsAndFragmentNames (ref), collectConflictsBetween (ref), collectConflictsBetweenFieldsAndFragment (ref), collectConflictsBetweenFragments (ref)
	local t4 = {}
	local v93 = getFieldsAndFragmentNames(p26, p27, p30, p31)
	local v94 = v93[1]
	local v95 = v93[2]
	local v96 = getFieldsAndFragmentNames(p26, p27, p32, p33)
	local v97 = v96[1]
	local v98 = v96[2]

	collectConflictsBetween(p26, t4, p27, p28, p29, v94, v97)

	if #v98 ~= 0 then
		for i = 1, #v98 do
			collectConflictsBetweenFieldsAndFragment(p26, t4, p27, p28, p29, v94, v98[i])
		end
	end

	if #v95 ~= 0 then
		for i = 1, #v95 do
			collectConflictsBetweenFieldsAndFragment(p26, t4, p27, p28, p29, v97, v95[i])
		end
	end

	for i = 1, #v95 do
		for j = 1, #v98 do
			collectConflictsBetweenFragments(p26, t4, p27, p28, p29, v95[i], v98[j])
		end
	end

	return t4
end

function collectConflictsWithin(p34, p35, p36, p37, p38) -- line: 461
	-- upvalues: findConflict (ref)
	for _, v109 in p38 do
		local v110 = v109[1]
		local v111 = v109[2]

		if #v111 > 1 then
			for i = 1, #v111 do
				for j = i + 1, #v111 do
					local v114 = findConflict(p34, p36, p37, false, v110, v111[i], v111[j])

					if v114 then
						table.insert(p35, v114)
					end
				end
			end
		end
	end
end
function collectConflictsBetween(p39, p40, p41, p42, p43, p44, p45) -- line: 506
	-- upvalues: findConflict (ref)
	for _, v in ipairs(p44:keys()) do
		local v124 = p45[v]

		if v124 then
			local v125 = p44[v]

			for i = 1, #v125 do
				for j = 1, #v124 do
					local v128 = findConflict(p39, p41, p42, p43, v, v125[i], v124[j])

					if v128 then
						table.insert(p40, v128)
					end
				end
			end
		end
	end
end
function findConflict(p46, p47, p48, b1: boolean, s1: string, p49, p50) -- line: 547
	-- upvalues: isObjectType (copy), sameArguments (ref), doTypesConflict (ref), inspect (copy), findConflictsBetweenSubSelectionSets (copy), getNamedType (copy), subfieldConflicts (ref)
	local v136 = p49[1]
	local v137 = p49[2]
	local v138 = p49[3]
	local v139 = p50[1]
	local v140 = p50[2]
	local v141 = p50[3]
	local v142 = b1 or v136 ~= v139 and (isObjectType(v136) and isObjectType(v139))

	if not v142 then
		local value = v137.name.value
		local value2 = v140.name.value

		if value ~= value2 then
			return {
				{
					s1,
					("\"%s\" and \"%s\" are different fields"):format(value, value2)
				},
				{ v137 },
				{ v140 }
			}
		end

		local v145 = v137.arguments or {}
		local v146 = v140.arguments or {}

		if not sameArguments(v145, v146) then
			return {
				{
					s1,
					"they have differing arguments"
				},
				{ v137 },
				{ v140 }
			}
		end
	end

	local v147 = v138 and v138.type
	local v148 = v141 and v141.type

	if v147 and v148 and doTypesConflict(v147, v148) then
		return {
			{
				s1,
				("they return conflicting types \"%s\" and \"%s\""):format(inspect(v147), inspect(v148))
			},
			{ v137 },
			{ v140 }
		}
	end

	local selectionSet = v137.selectionSet
	local selectionSet2 = v140.selectionSet

	if selectionSet and selectionSet2 then
		local v151 = findConflictsBetweenSubSelectionSets(p46, p47, p48, v142, getNamedType(v147), selectionSet, getNamedType(v148), selectionSet2)

		return subfieldConflicts(v151, s1, v137, v140)
	end

	return nil
end

local sameValue = nil
local _collectFieldsAndFragmentNames = nil

function sameArguments(p51, p52) -- line: 645
	-- upvalues: Array (copy), sameValue (ref)
	if #p51 ~= #p52 then
		return false
	end

	return Array.every(p51, function(p53) -- line: 649
		-- upvalues: Array (copy), p52 (copy), sameValue (ref)
		local v218 = Array.find(p52, function(p54) -- line: 650
			-- upvalues: p53 (copy)
			return p54.name.value == p53.name.value
		end)

		if not v218 then
			return false
		end

		return sameValue(p53.value, v218.value)
	end)
end
function sameValue(p55, p56) -- line: 660
	-- upvalues: print (copy)
	return print(p55) == print(p56)
end
function doTypesConflict(p57, p58) -- line: 667
	-- upvalues: isListType (copy), doTypesConflict (ref), isNonNullType (copy), isLeafType (copy)
	if isListType(p57) then
		if isListType(p58) then
			return doTypesConflict(p57.ofType, p58.ofType)
		end

		return true
	end

	if isListType(p58) then
		return true
	end

	if isNonNullType(p57) then
		if isNonNullType(p58) then
			return doTypesConflict(p57.ofType, p58.ofType)
		end

		return true
	end

	if isNonNullType(p58) then
		return true
	end

	if isLeafType(p57) or isLeafType(p58) then
		return p57 ~= p58
	end

	return false
end
function getFieldsAndFragmentNames(p59, p60, p61, p62) -- line: 695
	-- upvalues: Map (copy), _collectFieldsAndFragmentNames (ref), Object (copy)
	local v162 = p60[p62]

	if not v162 then
		local v163 = Map.new()
		local t5 = {}

		_collectFieldsAndFragmentNames(p59, p61, p62, v163, t5)
		v162 = {
			v163,
			Object.keys(t5)
		}
		p60[p62] = v162
	end

	return v162
end
function getReferencedFieldsAndFragmentNames(p63, p64, p65) -- line: 717
	-- upvalues: typeFromAST (copy), getFieldsAndFragmentNames (ref)
	local v168 = p64[p65.selectionSet]

	if v168 then
		return v168
	end

	local v169 = typeFromAST(p63:getSchema(), p65.typeCondition)

	return getFieldsAndFragmentNames(p63, p64, v169, p65.selectionSet)
end
function _collectFieldsAndFragmentNames(p66, p67, p68, p69, p70) -- line: 733
	-- upvalues: Kind (copy), isObjectType (copy), isInterfaceType (copy), null (copy), typeFromAST (copy), _collectFieldsAndFragmentNames (ref)
	for _, v in ipairs(p68.selections) do
		local kind = v.kind

		if kind == Kind.FIELD then
			local value = v.name.value
			local v179 = nil

			if isObjectType(p67) or isInterfaceType(p67) then
				v179 = p67:getFields():get(value)
			end

			local v180 = if not v.alias then value else v.alias.value

			if not p69[v180] then
				p69[v180] = {}
			end

			table.insert(p69[v180], {
				p67 or null,
				v or null,
				v179 or null
			})
		elseif kind == Kind.FRAGMENT_SPREAD then
			p70[v.name.value] = true
		elseif kind == Kind.INLINE_FRAGMENT then
			local typeCondition = v.typeCondition
			local v182 = p67

			if typeCondition then
				v182 = typeFromAST(p66:getSchema(), typeCondition)
			end

			_collectFieldsAndFragmentNames(p66, v182, v.selectionSet, p69, p70)
		end
	end
end
function subfieldConflicts(p71, s2: string, p72, p73) -- line: 780
	-- upvalues: Array (copy)
	if #p71 > 0 then
		return {
			{
				s2,
				Array.map(p71, function(p74) -- line: 785
					return p74[1]
				end)
			},
			Array.reduce(p71, function(p75, p76) -- line: 789
				-- upvalues: Array (copy)
				local v222 = p76[2]

				return Array.concat(p75, v222)
			end, { p72 }),
			Array.reduce(p71, function(p77, p78) -- line: 793
				-- upvalues: Array (copy)
				local v225 = p78[3]

				return Array.concat(p77, v225)
			end, { p73 })
		}
	end

	return nil
end

t6 = {}

local t7 = {
	__index = t6
}

function t6.new() -- line: 819
	-- upvalues: t7 (copy)
	local self = setmetatable({}, t7)

	self._data = {}

	return self
end
function t6.has(t8: {[any]: any}, s3: string, s4: string, b2: boolean) -- line: 825
	local v192 = t8._data[s3]
	local v193 = v192 and v192[s4]

	if v193 == nil then
		return false
	end

	if b2 == false then
		return v193 == false
	end

	return true
end
function t6.add(t9: {[any]: any}, s5: string, s6: string, b3: boolean) -- line: 840
	t9:_pairSetAdd(s5, s6, b3)
	t9:_pairSetAdd(s6, s5, b3)
end
function t6._pairSetAdd(t10: {[any]: any}, s7: string, s8: string, b4: boolean) -- line: 845
	local v202 = t10._data[s7]

	if not v202 then
		v202 = {}
		t10._data[s7] = v202
	end

	v202[s8] = b4
end

return t1
