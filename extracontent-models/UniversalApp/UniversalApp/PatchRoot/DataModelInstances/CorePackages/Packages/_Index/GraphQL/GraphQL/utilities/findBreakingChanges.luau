local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local keyMapOrdered = require(ParentParent.luaUtils.keyMapOrdered).keyMapOrdered
local jsutils = ParentParent.jsutils
local inspect = require(jsutils.inspect).inspect
local invariant = require(jsutils.invariant).invariant
local naturalCompare = require(jsutils.naturalCompare).naturalCompare
local language = ParentParent.language
local print = require(language.printer).print
local visit = require(language.visitor).visit

require(language.ast)

local type = ParentParent.type

require(type.schema)

local definition = require(type.definition)
local isSpecifiedScalarType = require(type.scalars).isSpecifiedScalarType
local isScalarType = definition.isScalarType
local isObjectType = definition.isObjectType
local isInterfaceType = definition.isInterfaceType
local isUnionType = definition.isUnionType
local isEnumType = definition.isEnumType
local isInputObjectType = definition.isInputObjectType
local isNonNullType = definition.isNonNullType
local isListType = definition.isListType
local isNamedType = definition.isNamedType
local isRequiredArgument = definition.isRequiredArgument
local isRequiredInputField = definition.isRequiredInputField
local astFromValue = require(script.Parent.astFromValue).astFromValue
local findSchemaChanges = nil
local findTypeChanges = nil
local findDirectiveChanges = nil
local diff = nil
local findEnumTypeChanges = nil
local findUnionTypeChanges = nil
local findInputObjectTypeChanges = nil
local findFieldChanges = nil
local findImplementedInterfacesChanges = nil
local typeKindName = nil
local isChangeSafeForInputObjectFieldOrFieldArg = nil
local findArgChanges = nil
local isChangeSafeForObjectOrInterfaceField = nil
local stringifyValue = nil
local v43 = Object.freeze({
	TYPE_REMOVED = "TYPE_REMOVED",
	TYPE_CHANGED_KIND = "TYPE_CHANGED_KIND",
	TYPE_REMOVED_FROM_UNION = "TYPE_REMOVED_FROM_UNION",
	VALUE_REMOVED_FROM_ENUM = "VALUE_REMOVED_FROM_ENUM",
	REQUIRED_INPUT_FIELD_ADDED = "REQUIRED_INPUT_FIELD_ADDED",
	IMPLEMENTED_INTERFACE_REMOVED = "IMPLEMENTED_INTERFACE_REMOVED",
	FIELD_REMOVED = "FIELD_REMOVED",
	FIELD_CHANGED_KIND = "FIELD_CHANGED_KIND",
	REQUIRED_ARG_ADDED = "REQUIRED_ARG_ADDED",
	ARG_REMOVED = "ARG_REMOVED",
	ARG_CHANGED_KIND = "ARG_CHANGED_KIND",
	DIRECTIVE_REMOVED = "DIRECTIVE_REMOVED",
	DIRECTIVE_ARG_REMOVED = "DIRECTIVE_ARG_REMOVED",
	REQUIRED_DIRECTIVE_ARG_ADDED = "REQUIRED_DIRECTIVE_ARG_ADDED",
	DIRECTIVE_REPEATABLE_REMOVED = "DIRECTIVE_REPEATABLE_REMOVED",
	DIRECTIVE_LOCATION_REMOVED = "DIRECTIVE_LOCATION_REMOVED"
})
local v44 = Object.freeze({
	VALUE_ADDED_TO_ENUM = "VALUE_ADDED_TO_ENUM",
	TYPE_ADDED_TO_UNION = "TYPE_ADDED_TO_UNION",
	OPTIONAL_INPUT_FIELD_ADDED = "OPTIONAL_INPUT_FIELD_ADDED",
	OPTIONAL_ARG_ADDED = "OPTIONAL_ARG_ADDED",
	IMPLEMENTED_INTERFACE_ADDED = "IMPLEMENTED_INTERFACE_ADDED",
	ARG_DEFAULT_VALUE_CHANGE = "ARG_DEFAULT_VALUE_CHANGE"
})

function findSchemaChanges(p1, p2) -- line: 146
	-- upvalues: Array (copy), findTypeChanges (ref), findDirectiveChanges (ref)
	return Array.concat(findTypeChanges(p1, p2), findDirectiveChanges(p1, p2))
end
function findDirectiveChanges(p3, p4) -- line: 156
	-- upvalues: diff (ref), v43 (copy), isRequiredArgument (copy)
	local t1 = {}
	local v54 = diff(p3:getDirectives(), p4:getDirectives())

	for _, v in ipairs(v54.removed) do
		table.insert(t1, {
			type = v43.DIRECTIVE_REMOVED,
			description = ("%s was removed."):format(v.name)
		})
	end

	for _, v in ipairs(v54.persisted) do
		local v59 = v[1]
		local v60 = v[2]
		local v61 = diff(v59.args, v60.args)

		for _, v2 in ipairs(v61.added) do
			if isRequiredArgument(v2) then
				table.insert(t1, {
					type = v43.REQUIRED_DIRECTIVE_ARG_ADDED,
					description = ("A required arg %s on directive %s was added."):format(v2.name, v59.name)
				})
			end
		end

		for _, v3 in ipairs(v61.removed) do
			table.insert(t1, {
				type = v43.DIRECTIVE_ARG_REMOVED,
				description = ("%s was removed from %s."):format(v3.name, v59.name)
			})
		end

		if v59.isRepeatable and not v60.isRepeatable then
			table.insert(t1, {
				type = v43.DIRECTIVE_REPEATABLE_REMOVED,
				description = ("Repeatable flag was removed from %s."):format(v59.name)
			})
		end

		for _, v4 in ipairs(v59.locations) do
			if table.find(v60.locations, v4) == nil then
				table.insert(t1, {
					type = v43.DIRECTIVE_LOCATION_REMOVED,
					description = ("%s was removed from %s."):format(v4, v59.name)
				})
			end
		end
	end

	return t1
end
function findTypeChanges(p5, p6) -- line: 215
	-- upvalues: diff (ref), v43 (copy), isSpecifiedScalarType (copy), isEnumType (copy), findEnumTypeChanges (ref), isUnionType (copy), findUnionTypeChanges (ref), isInputObjectType (copy), findInputObjectTypeChanges (ref), isObjectType (copy), Array (copy), findFieldChanges (ref), findImplementedInterfacesChanges (ref), isInterfaceType (copy), typeKindName (ref)
	local t2 = {}
	local v71 = diff(p5:getTypeMap():values(), p6:getTypeMap():values())

	for _, v in ipairs(v71.removed) do
		table.insert(t2, {
			type = v43.TYPE_REMOVED,
			description = isSpecifiedScalarType(v) and ("Standard scalar %s was removed because it is not referenced anymore."):format(v.name) or ("%s was removed."):format(v.name)
		})
	end

	for _, v in ipairs(v71.persisted) do
		local v76 = v[1]
		local v77 = v[2]

		if isEnumType(v76) and isEnumType(v77) then
			for _, v5 in ipairs(findEnumTypeChanges(v76, v77)) do
				table.insert(t2, v5)
			end
		elseif isUnionType(v76) and isUnionType(v77) then
			for _, v6 in ipairs(findUnionTypeChanges(v76, v77)) do
				table.insert(t2, v6)
			end
		elseif isInputObjectType(v76) and isInputObjectType(v77) then
			for _, v7 in ipairs(findInputObjectTypeChanges(v76, v77)) do
				table.insert(t2, v7)
			end
		elseif isObjectType(v76) and isObjectType(v77) then
			for _, v8 in ipairs(Array.concat(findFieldChanges(v76, v77), findImplementedInterfacesChanges(v76, v77))) do
				table.insert(t2, v8)
			end
		elseif isInterfaceType(v76) and isInterfaceType(v77) then
			for _, v9 in ipairs(Array.concat(findFieldChanges(v76, v77), findImplementedInterfacesChanges(v76, v77))) do
				table.insert(t2, v9)
			end
		elseif v76.new ~= v77.new then
			table.insert(t2, {
				type = v43.TYPE_CHANGED_KIND,
				description = ("%s changed from %s to %s."):format(v76.name, typeKindName(v76), typeKindName(v77))
			})
		end
	end

	return t2
end
function findInputObjectTypeChanges(p7, p8) -- line: 284
	-- upvalues: diff (ref), isRequiredInputField (copy), v43 (copy), v44 (copy), isChangeSafeForInputObjectFieldOrFieldArg (ref)
	local t3 = {}
	local v91 = diff(p7:getFields():values(), p8:getFields():values())

	for _, v in ipairs(v91.added) do
		if isRequiredInputField(v) then
			table.insert(t3, {
				type = v43.REQUIRED_INPUT_FIELD_ADDED,
				description = ("A required field %s on input type %s was added."):format(v.name, p7.name)
			})
		else
			table.insert(t3, {
				type = v44.OPTIONAL_INPUT_FIELD_ADDED,
				description = ("An optional field %s on input type %s was added."):format(v.name, p7.name)
			})
		end
	end

	for _, v in ipairs(v91.removed) do
		table.insert(t3, {
			type = v43.FIELD_REMOVED,
			description = ("%s.%s was removed."):format(p7.name, v.name)
		})
	end

	for _, v in ipairs(v91.persisted) do
		local v98 = v[1]
		local v99 = v[2]

		if not isChangeSafeForInputObjectFieldOrFieldArg(v98.type, v99.type) then
			table.insert(t3, {
				type = v43.FIELD_CHANGED_KIND,
				description = ("%s.%s changed type from %s to %s."):format(p7.name, v98.name, tostring(v98.type), (tostring(v99.type)))
			})
		end
	end

	return t3
end
function findUnionTypeChanges(p9, p10) -- line: 339
	-- upvalues: diff (ref), v44 (copy), v43 (copy)
	local t4 = {}
	local v103 = diff(p9:getTypes(), p10:getTypes())

	for _, v in ipairs(v103.added) do
		table.insert(t4, {
			type = v44.TYPE_ADDED_TO_UNION,
			description = ("%s was added to union type %s."):format(v.name, p9.name)
		})
	end

	for _, v in ipairs(v103.removed) do
		table.insert(t4, {
			type = v43.TYPE_REMOVED_FROM_UNION,
			description = ("%s was removed from union type %s."):format(v.name, p9.name)
		})
	end

	return t4
end
function findEnumTypeChanges(p11, p12) -- line: 368
	-- upvalues: diff (ref), v44 (copy), v43 (copy)
	local t5 = {}
	local v111 = diff(p11:getValues(), p12:getValues())

	for _, v in ipairs(v111.added) do
		table.insert(t5, {
			type = v44.VALUE_ADDED_TO_ENUM,
			description = ("%s was added to enum type %s."):format(v.name, p11.name)
		})
	end

	for _, v in ipairs(v111.removed) do
		table.insert(t5, {
			type = v43.VALUE_REMOVED_FROM_ENUM,
			description = ("%s was removed from enum type %s."):format(v.name, p11.name)
		})
	end

	return t5
end
function findImplementedInterfacesChanges(p13, p14) -- line: 390
	-- upvalues: diff (ref), v44 (copy), v43 (copy)
	local t6 = {}
	local v119 = diff(p13:getInterfaces(), p14:getInterfaces())

	for _, v in ipairs(v119.added) do
		table.insert(t6, {
			type = v44.IMPLEMENTED_INTERFACE_ADDED,
			description = ("%s added to interfaces implemented by %s."):format(v.name, p13.name)
		})
	end

	for _, v in ipairs(v119.removed) do
		table.insert(t6, {
			type = v43.IMPLEMENTED_INTERFACE_REMOVED,
			description = ("%s no longer implements interface %s."):format(p13.name, v.name)
		})
	end

	return t6
end
function findFieldChanges(p15, p16) -- line: 420
	-- upvalues: diff (ref), v43 (copy), findArgChanges (ref), isChangeSafeForObjectOrInterfaceField (ref)
	local t7 = {}
	local v127 = diff(p15:getFields():values(), p16:getFields():values())

	for _, v in ipairs(v127.removed) do
		table.insert(t7, {
			type = v43.FIELD_REMOVED,
			description = ("%s.%s was removed."):format(p15.name, v.name)
		})
	end

	for _, v in ipairs(v127.persisted) do
		local v132 = v[1]
		local v133 = v[2]

		for _, v10 in ipairs(findArgChanges(p15, v132, v133)) do
			table.insert(t7, v10)
		end

		if not isChangeSafeForObjectOrInterfaceField(v132.type, v133.type) then
			table.insert(t7, {
				type = v43.FIELD_CHANGED_KIND,
				description = ("%s.%s changed type from "):format(p15.name, v132.name) .. ("%s to %s."):format(tostring(v132.type), (tostring(v133.type)))
			})
		end
	end

	return t7
end
function findArgChanges(p17, p18, p19) -- line: 461
	-- upvalues: diff (ref), v43 (copy), isChangeSafeForInputObjectFieldOrFieldArg (ref), v44 (copy), stringifyValue (ref), isRequiredArgument (copy)
	local t8 = {}
	local v140 = diff(p18.args, p19.args)

	for _, v in ipairs(v140.removed) do
		table.insert(t8, {
			type = v43.ARG_REMOVED,
			description = ("%s.%s arg %s was removed."):format(p17.name, p18.name, v.name)
		})
	end

	for _, v in ipairs(v140.persisted) do
		local v145 = v[1]
		local v146 = v[2]

		if not isChangeSafeForInputObjectFieldOrFieldArg(v145.type, v146.type) then
			table.insert(t8, {
				type = v43.ARG_CHANGED_KIND,
				description = ("%s.%s arg %s has changed type from "):format(p17.name, p18.name, v145.name) .. ("%s to %s."):format(tostring(v145.type), (tostring(v146.type)))
			})
		elseif v145.defaultValue ~= nil then
			if v146.defaultValue == nil then
				table.insert(t8, {
					type = v44.ARG_DEFAULT_VALUE_CHANGE,
					description = ("%s.%s arg %s defaultValue was removed."):format(p17.name, p18.name, v145.name)
				})
			else
				local v147 = stringifyValue(v145.defaultValue, v145.type)
				local v148 = stringifyValue(v146.defaultValue, v146.type)

				if v147 ~= v148 then
					table.insert(t8, {
						type = v44.ARG_DEFAULT_VALUE_CHANGE,
						description = ("%s.%s arg %s has changed defaultValue from %s to %s."):format(p17.name, p18.name, v145.name, v147, v148)
					})
				end
			end
		end
	end

	for _, v in ipairs(v140.added) do
		if isRequiredArgument(v) then
			table.insert(t8, {
				type = v43.REQUIRED_ARG_ADDED,
				description = ("A required arg %s on %s.%s was added."):format(v.name, p17.name, p18.name)
			})
		else
			table.insert(t8, {
				type = v44.OPTIONAL_ARG_ADDED,
				description = ("An optional arg %s on %s.%s was added."):format(v.name, p17.name, p18.name)
			})
		end
	end

	return t8
end
function isChangeSafeForObjectOrInterfaceField(p20, p21) -- line: 550
	-- upvalues: isListType (copy), isChangeSafeForObjectOrInterfaceField (ref), isNonNullType (copy), isNamedType (copy)
	if isListType(p20) then
		return isListType(p21) and isChangeSafeForObjectOrInterfaceField(p20.ofType, p21.ofType) or isNonNullType(p21) and isChangeSafeForObjectOrInterfaceField(p20, p21.ofType)
	end

	if isNonNullType(p20) then
		return isNonNullType(p21) and isChangeSafeForObjectOrInterfaceField(p20.ofType, p21.ofType)
	end

	return isNamedType(p21) and p20.name == p21.name or isNonNullType(p21) and isChangeSafeForObjectOrInterfaceField(p20, p21.ofType)
end
function isChangeSafeForInputObjectFieldOrFieldArg(p22, p23) -- line: 572
	-- upvalues: isListType (copy), isChangeSafeForInputObjectFieldOrFieldArg (ref), isNonNullType (copy), isNamedType (copy)
	if isListType(p22) then
		return isListType(p23) and isChangeSafeForInputObjectFieldOrFieldArg(p22.ofType, p23.ofType)
	end

	if isNonNullType(p22) then
		return isNonNullType(p23) and isChangeSafeForInputObjectFieldOrFieldArg(p22.ofType, p23.ofType) or not isNonNullType(p23) and isChangeSafeForInputObjectFieldOrFieldArg(p22.ofType, p23)
	end

	return isNamedType(p23) and p22.name == p23.name
end
function typeKindName(p24) -- line: 593
	-- upvalues: isScalarType (copy), isObjectType (copy), isInterfaceType (copy), isUnionType (copy), isEnumType (copy), isInputObjectType (copy), invariant (copy), inspect (copy)
	if isScalarType(p24) then
		return "a Scalar type"
	end

	if isObjectType(p24) then
		return "an Object type"
	end

	if isInterfaceType(p24) then
		return "an Interface type"
	end

	if isUnionType(p24) then
		return "a Union type"
	end

	if isEnumType(p24) then
		return "an Enum type"
	end

	if isInputObjectType(p24) then
		return "an Input type"
	end

	invariant(false, "Unexpected type: " .. inspect(p24))

	return ""
end
function stringifyValue(p25, p26) -- line: 620
	-- upvalues: astFromValue (copy), invariant (copy), visit (copy), Array (copy), naturalCompare (copy), Object (copy), print (copy)
	local v158 = astFromValue(p25, p26)

	invariant(v158 ~= nil)

	local v159 = visit(v158, {
		ObjectValue = function(_, p28) -- line: 628
			-- upvalues: Array (copy), naturalCompare (copy), Object (copy)
			local v176 = Array.concat({}, p28.fields)

			Array.sort(v176, function(p29, p30) -- line: 632
				-- upvalues: naturalCompare (copy)
				return naturalCompare(p29.name.value, p30.name.value)
			end)

			return Object.assign({}, p28, {
				fields = v176
			})
		end
	})

	return print(v159)
end
function diff(p31, p32) -- line: 645
	-- upvalues: keyMapOrdered (copy)
	local t9 = {}
	local t10 = {}
	local t11 = {}
	local v165 = keyMapOrdered(p31, function(p33) -- line: 656
		return p33.name
	end)
	local v166 = keyMapOrdered(p32, function(p34) -- line: 659
		return p34.name
	end)

	for _, v in ipairs(p31) do
		local v169 = v166:get(v.name)

		if v169 == nil then
			table.insert(t10, v)
		else
			table.insert(t11, {
				v,
				v169
			})
		end
	end

	for _, v in ipairs(p32) do
		if v165:get(v.name) == nil then
			table.insert(t9, v)
		end
	end

	return {
		added = t9,
		persisted = t11,
		removed = t10
	}
end

return {
	BreakingChangeType = v43,
	DangerousChangeType = v44,
	findBreakingChanges = function(p35, p36) -- line: 122
		-- upvalues: Array (copy), findSchemaChanges (ref), v43 (copy)
		return (Array.filter(findSchemaChanges(p35, p36), function(p37) -- line: 126
			-- upvalues: v43 (copy)
			return v43[p37.type] ~= nil
		end))
	end,
	findDangerousChanges = function(p38, p39) -- line: 136
		-- upvalues: Array (copy), findSchemaChanges (ref), v44 (copy)
		return (Array.filter(findSchemaChanges(p38, p39), function(p40) -- line: 140
			-- upvalues: v44 (copy)
			return v44[p40.type] ~= nil
		end))
	end
}
