local parent = script.Parent.Parent.Parent.Parent
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local definition = require(parent.type.definition)
local getNamedType = definition.getNamedType
local isInputObjectType = definition.isInputObjectType

return {
	NoDeprecatedCustomRule = function(object)
		return {
			Field = function(_, p)
				local fieldDef = object:getFieldDef()
				local deprecationReason = fieldDef and fieldDef.deprecationReason

				if fieldDef and deprecationReason ~= nil then
					local parentType = object:getParentType()
					invariant2(parentType ~= nil)
					object:reportError(graphQLError.new(
						("The field %s.%s is deprecated. %s"):format(parentType.name, fieldDef.name, deprecationReason),
						p
					))
				end
			end,
			Argument = function(_, p)
				local argument = object:getArgument()
				local deprecationReason = argument and argument.deprecationReason

				if argument and deprecationReason ~= nil then
					local directive = object:getDirective()

					if directive ~= nil then
						object:reportError(graphQLError.new(
							("Directive \"@%s\" argument \"%s\" is deprecated. %s"):format(
								directive.name,
								argument.name,
								deprecationReason
							),
							p
						))
						return
					end

					local parentType = object:getParentType()
					local fieldDef = object:getFieldDef()
					invariant2(parentType ~= nil and fieldDef ~= nil)
					object:reportError(graphQLError.new(
						("Field \"%s.%s\" argument \"%s\" is deprecated. %s"):format(
							parentType.name,
							fieldDef.name,
							argument.name,
							deprecationReason
						),
						p
					))
				end
			end,
			ObjectField = function(_, p)
				local namedType = getNamedType(object:getParentInputType())

				if isInputObjectType(namedType) then
					local v = namedType:getFields():get(p.name.value)

					local deprecationReason = v and v.deprecationReason

					if deprecationReason ~= nil then
						object:reportError(graphQLError.new(
							("The input field %s.%s is deprecated. %s"):format(
								namedType.name,
								v.name,
								deprecationReason
							),
							p
						))
					end
				end
			end,
			EnumValue = function(_, p)
				local enumValue = object:getEnumValue()
				local deprecationReason = enumValue and enumValue.deprecationReason

				if enumValue and deprecationReason ~= nil then
					local namedType = getNamedType(object:getInputType())
					invariant2(namedType ~= nil)
					object:reportError(graphQLError.new(
						("The enum value \"%s.%s\" is deprecated. %s"):format(
							namedType.name,
							enumValue.name,
							deprecationReason
						),
						p
					))
				end
			end
		}
	end
}
