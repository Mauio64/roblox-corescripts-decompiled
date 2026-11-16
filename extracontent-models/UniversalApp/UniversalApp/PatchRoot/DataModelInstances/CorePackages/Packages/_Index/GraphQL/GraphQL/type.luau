require(script.Parent.jsutils.Path)

local schema = require(script.schema)
local Type = {}

Type.isSchema = schema.isSchema

Type.assertSchema = schema.assertSchema

Type.GraphQLSchema = schema.GraphQLSchema

local definition = require(script.definition)

Type.isType = definition.isType
Type.isScalarType = definition.isScalarType
Type.isObjectType = definition.isObjectType
Type.isInterfaceType = definition.isInterfaceType
Type.isUnionType = definition.isUnionType
Type.isEnumType = definition.isEnumType
Type.isInputObjectType = definition.isInputObjectType
Type.isListType = definition.isListType
Type.isNonNullType = definition.isNonNullType
Type.isInputType = definition.isInputType
Type.isOutputType = definition.isOutputType
Type.isLeafType = definition.isLeafType
Type.isCompositeType = definition.isCompositeType
Type.isAbstractType = definition.isAbstractType
Type.isWrappingType = definition.isWrappingType
Type.isNullableType = definition.isNullableType
Type.isNamedType = definition.isNamedType
Type.isRequiredArgument = definition.isRequiredArgument
Type.isRequiredInputField = definition.isRequiredInputField

Type.assertType = definition.assertType
Type.assertScalarType = definition.assertScalarType
Type.assertObjectType = definition.assertObjectType
Type.assertInterfaceType = definition.assertInterfaceType
Type.assertUnionType = definition.assertUnionType
Type.assertEnumType = definition.assertEnumType
Type.assertInputObjectType = definition.assertInputObjectType
Type.assertListType = definition.assertListType
Type.assertNonNullType = definition.assertNonNullType
Type.assertInputType = definition.assertInputType
Type.assertOutputType = definition.assertOutputType
Type.assertLeafType = definition.assertLeafType
Type.assertCompositeType = definition.assertCompositeType
Type.assertAbstractType = definition.assertAbstractType
Type.assertWrappingType = definition.assertWrappingType
Type.assertNullableType = definition.assertNullableType
Type.assertNamedType = definition.assertNamedType

Type.getNullableType = definition.getNullableType
Type.getNamedType = definition.getNamedType

Type.GraphQLScalarType = definition.GraphQLScalarType
Type.GraphQLObjectType = definition.GraphQLObjectType
Type.GraphQLInterfaceType = definition.GraphQLInterfaceType
Type.GraphQLUnionType = definition.GraphQLUnionType
Type.GraphQLEnumType = definition.GraphQLEnumType
Type.GraphQLInputObjectType = definition.GraphQLInputObjectType

Type.GraphQLList = definition.GraphQLList
Type.GraphQLNonNull = definition.GraphQLNonNull

local directives = require(script.directives)

Type.isDirective = directives.isDirective

Type.assertDirective = directives.assertDirective

Type.GraphQLDirective = directives.GraphQLDirective

Type.isSpecifiedDirective = directives.isSpecifiedDirective
Type.specifiedDirectives = directives.specifiedDirectives
Type.GraphQLIncludeDirective = directives.GraphQLIncludeDirective
Type.GraphQLSkipDirective = directives.GraphQLSkipDirective
Type.GraphQLDeprecatedDirective = directives.GraphQLDeprecatedDirective
Type.GraphQLSpecifiedByDirective = directives.GraphQLSpecifiedByDirective

Type.DEFAULT_DEPRECATION_REASON = directives.DEFAULT_DEPRECATION_REASON

local scalars = require(script.scalars)

Type.isSpecifiedScalarType = scalars.isSpecifiedScalarType

Type.specifiedScalarTypes = scalars.specifiedScalarTypes
Type.GraphQLInt = scalars.GraphQLInt
Type.GraphQLFloat = scalars.GraphQLFloat
Type.GraphQLString = scalars.GraphQLString
Type.GraphQLBoolean = scalars.GraphQLBoolean
Type.GraphQLID = scalars.GraphQLID

local introspection = require(script.introspection)

Type.isIntrospectionType = introspection.isIntrospectionType

Type.introspectionTypes = introspection.introspectionTypes
Type.__Schema = introspection.__Schema
Type.__Directive = introspection.__Directive
Type.__DirectiveLocation = introspection.__DirectiveLocation
Type.__Type = introspection.__Type
Type.__Field = introspection.__Field
Type.__InputValue = introspection.__InputValue
Type.__EnumValue = introspection.__EnumValue
Type.__TypeKind = introspection.__TypeKind

Type.TypeKind = introspection.TypeKind

Type.SchemaMetaFieldDef = introspection.SchemaMetaFieldDef
Type.TypeMetaFieldDef = introspection.TypeMetaFieldDef
Type.TypeNameMetaFieldDef = introspection.TypeNameMetaFieldDef

local validate = require(script.validate)

Type.validateSchema = validate.validateSchema
Type.assertValidSchema = validate.assertValidSchema

return Type
