local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local keyMapOrdered = require(parent.luaUtils.keyMapOrdered)
local keyMapOrdered2 = keyMapOrdered.keyMapOrdered

local jsutils = parent.jsutils
local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local invariant = require(jsutils.invariant)
local invariant2 = invariant.invariant
local naturalCompare = require(jsutils.naturalCompare)
local naturalCompare2 = naturalCompare.naturalCompare

local language = parent.language
local printer = require(language.printer)
local Print = printer.print
local visitor = require(language.visitor)
local visit = visitor.visit
require(language.ast)

local kind = parent.type
require(kind.schema)

local definition = require(kind.definition)

local scalars = require(kind.scalars)
local isSpecifiedScalarType = scalars.isSpecifiedScalarType
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

local astFromValue = require(script.Parent.astFromValue)
local astFromValue2 = astFromValue.astFromValue

local findSchemaChanges
local findTypeChanges
local findDirectiveChanges
local diff
local findEnumTypeChanges
local findUnionTypeChanges
local findInputObjectTypeChanges
local findFieldChanges
local findImplementedInterfacesChanges
local typeKindName
local isChangeSafeForInputObjectFieldOrFieldArg
local findArgChanges
local isChangeSafeForObjectOrInterfaceField
local stringifyValue

local frozen = Object.freeze({
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

local frozen2 = Object.freeze({
	VALUE_ADDED_TO_ENUM = "VALUE_ADDED_TO_ENUM",
	TYPE_ADDED_TO_UNION = "TYPE_ADDED_TO_UNION",
	OPTIONAL_INPUT_FIELD_ADDED = "OPTIONAL_INPUT_FIELD_ADDED",
	OPTIONAL_ARG_ADDED = "OPTIONAL_ARG_ADDED",
	IMPLEMENTED_INTERFACE_ADDED = "IMPLEMENTED_INTERFACE_ADDED",
	ARG_DEFAULT_VALUE_CHANGE = "ARG_DEFAULT_VALUE_CHANGE"
})

local function findBreakingChanges(p, p2)
	return (Array.filter(findSchemaChanges(p, p2), function(p3): boolean
		return frozen[p3.type] ~= nil
	end))
end

local function findDangerousChanges(p, p2)
	return (Array.filter(findSchemaChanges(p, p2), function(p3): boolean
		return frozen2[p3.type] ~= nil
	end))
end

findSchemaChanges = function(p, p2)
	return Array.concat(findTypeChanges(p, p2), findDirectiveChanges(p, p2))
end

findDirectiveChanges = function(object, object2)
	local v = diff(object:getDirectives(), object2:getDirectives())
	local directiveChanges = {}

	for _, v2 in ipairs(v.removed) do
		table.insert(directiveChanges, {
			type = frozen.DIRECTIVE_REMOVED,
			description = ("%s was removed."):format(v2.name)
		})
	end

	for _, v2 in ipairs(v.persisted) do
		local v3 = v2[1]
		local v4 = v2[2]
		local v5 = diff(v3.args, v4.args)

		for _, v6 in ipairs(v5.added) do
			if isRequiredArgument(v6) then
				table.insert(directiveChanges, {
					type = frozen.REQUIRED_DIRECTIVE_ARG_ADDED,
					description = ("A required arg %s on directive %s was added."):format(v6.name, v3.name)
				})
			end
		end

		for _, v6 in ipairs(v5.removed) do
			table.insert(directiveChanges, {
				type = frozen.DIRECTIVE_ARG_REMOVED,
				description = ("%s was removed from %s."):format(v6.name, v3.name)
			})
		end

		if v3.isRepeatable and not v4.isRepeatable then
			table.insert(directiveChanges, {
				type = frozen.DIRECTIVE_REPEATABLE_REMOVED,
				description = ("Repeatable flag was removed from %s."):format(v3.name)
			})
		end

		for _, location in ipairs(v3.locations) do
			if table.find(v4.locations, location) == nil then
				table.insert(directiveChanges, {
					type = frozen.DIRECTIVE_LOCATION_REMOVED,
					description = ("%s was removed from %s."):format(location, v3.name)
				})
			end
		end
	end

	return directiveChanges
end

findTypeChanges = function(object, object2)
	local v = diff(object:getTypeMap():values(), object2:getTypeMap():values())
	local typeChanges = {}

	for _, v2 in ipairs(v.removed) do
		table.insert(typeChanges, {
			type = frozen.TYPE_REMOVED,
			description = isSpecifiedScalarType(v2) and ("Standard scalar %s was removed because it is not referenced anymore."):format(v2.name) or ("%s was removed."):format(v2.name)
		})
	end

	for _, v2 in ipairs(v.persisted) do
		local v3 = v2[1]
		local v4 = v2[2]

		if isEnumType(v3) and isEnumType(v4) then
			for _, v5 in ipairs(findEnumTypeChanges(v3, v4)) do
				table.insert(typeChanges, v5)
			end
		elseif isUnionType(v3) and isUnionType(v4) then
			for _, v5 in ipairs(findUnionTypeChanges(v3, v4)) do
				table.insert(typeChanges, v5)
			end
		elseif isInputObjectType(v3) and isInputObjectType(v4) then
			for _, v5 in ipairs(findInputObjectTypeChanges(v3, v4)) do
				table.insert(typeChanges, v5)
			end
		elseif isObjectType(v3) and isObjectType(v4) then
			for _, v5 in ipairs(Array.concat(findFieldChanges(v3, v4), findImplementedInterfacesChanges(v3, v4))) do
				table.insert(typeChanges, v5)
			end
		elseif isInterfaceType(v3) and isInterfaceType(v4) then
			for _, v5 in ipairs(Array.concat(findFieldChanges(v3, v4), findImplementedInterfacesChanges(v3, v4))) do
				table.insert(typeChanges, v5)
			end
		elseif v3.new ~= v4.new then
			table.insert(typeChanges, {
				type = frozen.TYPE_CHANGED_KIND,
				description = ("%s changed from %s to %s."):format(v3.name, typeKindName(v3), typeKindName(v4))
			})
		end
	end

	return typeChanges
end

findInputObjectTypeChanges = function(object, object2)
	local v = diff(object:getFields():values(), object2:getFields():values())
	local inputObjectTypeChanges = {}

	for _, v2 in ipairs(v.added) do
		if isRequiredInputField(v2) then
			table.insert(inputObjectTypeChanges, {
				type = frozen.REQUIRED_INPUT_FIELD_ADDED,
				description = ("A required field %s on input type %s was added."):format(v2.name, object.name)
			})
		else
			table.insert(inputObjectTypeChanges, {
				type = frozen2.OPTIONAL_INPUT_FIELD_ADDED,
				description = ("An optional field %s on input type %s was added."):format(v2.name, object.name)
			})
		end
	end

	for _, v2 in ipairs(v.removed) do
		table.insert(inputObjectTypeChanges, {
			type = frozen.FIELD_REMOVED,
			description = ("%s.%s was removed."):format(object.name, v2.name)
		})
	end

	for _, v2 in ipairs(v.persisted) do
		local v3 = v2[1]
		local v4 = v2[2]

		if not isChangeSafeForInputObjectFieldOrFieldArg(v3.type, v4.type) then
			table.insert(inputObjectTypeChanges, {
				type = frozen.FIELD_CHANGED_KIND,
				description = ("%s.%s changed type from %s to %s."):format(
					object.name,
					v3.name,
					tostring(v3.type),
					(tostring(v4.type))
				)
			})
		end
	end

	return inputObjectTypeChanges
end

findUnionTypeChanges = function(object, object2)
	local v = diff(object:getTypes(), object2:getTypes())
	local unionTypeChanges = {}

	for _, v2 in ipairs(v.added) do
		table.insert(unionTypeChanges, {
			type = frozen2.TYPE_ADDED_TO_UNION,
			description = ("%s was added to union type %s."):format(v2.name, object.name)
		})
	end

	for _, v2 in ipairs(v.removed) do
		table.insert(unionTypeChanges, {
			type = frozen.TYPE_REMOVED_FROM_UNION,
			description = ("%s was removed from union type %s."):format(v2.name, object.name)
		})
	end

	return unionTypeChanges
end

findEnumTypeChanges = function(object, object2)
	local v = diff(object:getValues(), object2:getValues())
	local enumTypeChanges = {}

	for _, v2 in ipairs(v.added) do
		table.insert(enumTypeChanges, {
			type = frozen2.VALUE_ADDED_TO_ENUM,
			description = ("%s was added to enum type %s."):format(v2.name, object.name)
		})
	end

	for _, v2 in ipairs(v.removed) do
		table.insert(enumTypeChanges, {
			type = frozen.VALUE_REMOVED_FROM_ENUM,
			description = ("%s was removed from enum type %s."):format(v2.name, object.name)
		})
	end

	return enumTypeChanges
end

findImplementedInterfacesChanges = function(object, object2)
	local v = diff(object:getInterfaces(), object2:getInterfaces())
	local implementedInterfacesChanges = {}

	for _, v2 in ipairs(v.added) do
		table.insert(implementedInterfacesChanges, {
			type = frozen2.IMPLEMENTED_INTERFACE_ADDED,
			description = ("%s added to interfaces implemented by %s."):format(v2.name, object.name)
		})
	end

	for _, v2 in ipairs(v.removed) do
		table.insert(implementedInterfacesChanges, {
			type = frozen.IMPLEMENTED_INTERFACE_REMOVED,
			description = ("%s no longer implements interface %s."):format(object.name, v2.name)
		})
	end

	return implementedInterfacesChanges
end

findFieldChanges = function(object, object2)
	local v = diff(object:getFields():values(), object2:getFields():values())
	local fieldChanges = {}

	for _, v2 in ipairs(v.removed) do
		table.insert(fieldChanges, {
			type = frozen.FIELD_REMOVED,
			description = ("%s.%s was removed."):format(object.name, v2.name)
		})
	end

	for _, v2 in ipairs(v.persisted) do
		local v3 = v2[1]
		local v4 = v2[2]

		for _, v5 in ipairs(findArgChanges(object, v3, v4)) do
			table.insert(fieldChanges, v5)
		end

		if not isChangeSafeForObjectOrInterfaceField(v3.type, v4.type) then
			table.insert(fieldChanges, {
				type = frozen.FIELD_CHANGED_KIND,
				description = ("%s.%s changed type from "):format(object.name, v3.name) .. ("%s to %s."):format(tostring(v3.type), (tostring(v4.type)))
			})
		end
	end

	return fieldChanges
end

findArgChanges = function(object, p, p2)
	local v = diff(p.args, p2.args)
	local argChanges = {}

	for _, v2 in ipairs(v.removed) do
		table.insert(argChanges, {
			type = frozen.ARG_REMOVED,
			description = ("%s.%s arg %s was removed."):format(object.name, p.name, v2.name)
		})
	end

	for _, v2 in ipairs(v.persisted) do
		local v3 = v2[1]
		local v4 = v2[2]

		if isChangeSafeForInputObjectFieldOrFieldArg(v3.type, v4.type) then
			if v3.defaultValue ~= nil then
				if v4.defaultValue == nil then
					table.insert(argChanges, {
						type = frozen2.ARG_DEFAULT_VALUE_CHANGE,
						description = ("%s.%s arg %s defaultValue was removed."):format(object.name, p.name, v3.name)
					})
				else
					local v5 = stringifyValue(v3.defaultValue, v3.type)
					local v6 = stringifyValue(v4.defaultValue, v4.type)

					if v5 ~= v6 then
						table.insert(argChanges, {
							type = frozen2.ARG_DEFAULT_VALUE_CHANGE,
							description = ("%s.%s arg %s has changed defaultValue from %s to %s."):format(
								object.name,
								p.name,
								v3.name,
								v5,
								v6
							)
						})
					end
				end
			end
		else
			table.insert(argChanges, {
				type = frozen.ARG_CHANGED_KIND,
				description = ("%s.%s arg %s has changed type from "):format(object.name, p.name, v3.name) .. ("%s to %s."):format(tostring(v3.type), (tostring(v4.type)))
			})
		end
	end

	for _, v2 in ipairs(v.added) do
		if isRequiredArgument(v2) then
			table.insert(argChanges, {
				type = frozen.REQUIRED_ARG_ADDED,
				description = ("A required arg %s on %s.%s was added."):format(v2.name, object.name, p.name)
			})
		else
			table.insert(argChanges, {
				type = frozen2.OPTIONAL_ARG_ADDED,
				description = ("An optional arg %s on %s.%s was added."):format(v2.name, object.name, p.name)
			})
		end
	end

	return argChanges
end

isChangeSafeForObjectOrInterfaceField = function(kind2, kind3)
	if isListType(kind2) then
		return isListType(kind3) and isChangeSafeForObjectOrInterfaceField(kind2.ofType, kind3.ofType)
			or isNonNullType(kind3) and isChangeSafeForObjectOrInterfaceField(kind2, kind3.ofType)
	end

	if isNonNullType(kind2) then
		return isNonNullType(kind3) and isChangeSafeForObjectOrInterfaceField(kind2.ofType, kind3.ofType)
	end

	return isNamedType(kind3) and kind2.name == kind3.name and true
		or isNonNullType(kind3) and isChangeSafeForObjectOrInterfaceField(kind2, kind3.ofType)
end

isChangeSafeForInputObjectFieldOrFieldArg = function(kind2, kind3)
	if isListType(kind2) then
		return isListType(kind3) and isChangeSafeForInputObjectFieldOrFieldArg(kind2.ofType, kind3.ofType)
	end

	if isNonNullType(kind2) then
		return isNonNullType(kind3) and isChangeSafeForInputObjectFieldOrFieldArg(kind2.ofType, kind3.ofType)
			or not isNonNullType(kind3) and isChangeSafeForInputObjectFieldOrFieldArg(kind2.ofType, kind3)
	end

	return isNamedType(kind3) and kind2.name == kind3.name
end

typeKindName = function(p): string
	if isScalarType(p) then
		return "a Scalar type"
	end

	if isObjectType(p) then
		return "an Object type"
	end

	if isInterfaceType(p) then
		return "an Interface type"
	end

	if isUnionType(p) then
		return "a Union type"
	end

	if isEnumType(p) then
		return "an Enum type"
	end

	if isInputObjectType(p) then
		return "an Input type"
	end

	invariant2(false, "Unexpected type: " .. inspect2(p))

	return ""
end

stringifyValue = function(defaultValue, kind2)
	local v = astFromValue2(defaultValue, kind2)

	invariant2(v ~= nil)

	return Print((visit(v, {
		ObjectValue = function(_, p)
			local joined = Array.concat({}, p.fields)

			Array.sort(joined, function(p2, p3)
				return naturalCompare2(p2.name.value, p3.name.value)
			end)

			return Object.assign({}, p, { fields = joined })
		end
	})))
end

diff = function(list, list2)
	local v = keyMapOrdered2(list, function(p)
		return p.name
	end)

	local v2 = keyMapOrdered2(list2, function(p)
		return p.name
	end)
	local persisted = {}
	local removed = {}
	local added = {}

	for _, item in ipairs(list) do
		local v3 = v2:get(item.name)

		if v3 == nil then
			table.insert(removed, item)
		else
			table.insert(persisted, { item, v3 })
		end
	end

	for _, item in ipairs(list2) do
		if v:get(item.name) == nil then
			table.insert(added, item)
		end
	end

	return { added = added, persisted = persisted, removed = removed }
end

return {
	BreakingChangeType = frozen,
	DangerousChangeType = frozen2,
	findBreakingChanges = findBreakingChanges,
	findDangerousChanges = findDangerousChanges
}
