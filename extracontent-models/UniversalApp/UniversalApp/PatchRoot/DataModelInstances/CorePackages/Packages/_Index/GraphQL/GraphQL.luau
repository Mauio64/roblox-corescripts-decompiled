local version = require(script.version)
local GraphQL = {}

GraphQL.version = version.version
GraphQL.versionInfo = version.versionInfo

local graphql = require(script.graphql)
GraphQL.graphql = graphql.graphql
GraphQL.graphqlSync = graphql.graphqlSync

local kind = require(script.type)

GraphQL.GraphQLSchema = kind.GraphQLSchema
GraphQL.GraphQLDirective = kind.GraphQLDirective
GraphQL.GraphQLScalarType = kind.GraphQLScalarType
GraphQL.GraphQLObjectType = kind.GraphQLObjectType
GraphQL.GraphQLInterfaceType = kind.GraphQLInterfaceType
GraphQL.GraphQLUnionType = kind.GraphQLUnionType
GraphQL.GraphQLEnumType = kind.GraphQLEnumType
GraphQL.GraphQLInputObjectType = kind.GraphQLInputObjectType
GraphQL.GraphQLList = kind.GraphQLList
GraphQL.GraphQLNonNull = kind.GraphQLNonNull

GraphQL.specifiedScalarTypes = kind.specifiedScalarTypes
GraphQL.GraphQLInt = kind.GraphQLInt
GraphQL.GraphQLFloat = kind.GraphQLFloat
GraphQL.GraphQLString = kind.GraphQLString
GraphQL.GraphQLBoolean = kind.GraphQLBoolean
GraphQL.GraphQLID = kind.GraphQLID

GraphQL.specifiedDirectives = kind.specifiedDirectives
GraphQL.GraphQLIncludeDirective = kind.GraphQLIncludeDirective
GraphQL.GraphQLSkipDirective = kind.GraphQLSkipDirective
GraphQL.GraphQLDeprecatedDirective = kind.GraphQLDeprecatedDirective
GraphQL.GraphQLSpecifiedByDirective = kind.GraphQLSpecifiedByDirective

GraphQL.TypeKind = kind.TypeKind

GraphQL.DEFAULT_DEPRECATION_REASON = kind.DEFAULT_DEPRECATION_REASON

GraphQL.introspectionTypes = kind.introspectionTypes
GraphQL.__Schema = kind.__Schema
GraphQL.__Directive = kind.__Directive
GraphQL.__DirectiveLocation = kind.__DirectiveLocation
GraphQL.__Type = kind.__Type
GraphQL.__Field = kind.__Field
GraphQL.__InputValue = kind.__InputValue
GraphQL.__EnumValue = kind.__EnumValue
GraphQL.__TypeKind = kind.__TypeKind

GraphQL.SchemaMetaFieldDef = kind.SchemaMetaFieldDef
GraphQL.TypeMetaFieldDef = kind.TypeMetaFieldDef
GraphQL.TypeNameMetaFieldDef = kind.TypeNameMetaFieldDef

GraphQL.isSchema = kind.isSchema
GraphQL.isDirective = kind.isDirective
GraphQL.isType = kind.isType
GraphQL.isScalarType = kind.isScalarType
GraphQL.isObjectType = kind.isObjectType
GraphQL.isInterfaceType = kind.isInterfaceType
GraphQL.isUnionType = kind.isUnionType
GraphQL.isEnumType = kind.isEnumType
GraphQL.isInputObjectType = kind.isInputObjectType
GraphQL.isListType = kind.isListType
GraphQL.isNonNullType = kind.isNonNullType
GraphQL.isInputType = kind.isInputType
GraphQL.isOutputType = kind.isOutputType
GraphQL.isLeafType = kind.isLeafType
GraphQL.isCompositeType = kind.isCompositeType
GraphQL.isAbstractType = kind.isAbstractType
GraphQL.isWrappingType = kind.isWrappingType
GraphQL.isNullableType = kind.isNullableType
GraphQL.isNamedType = kind.isNamedType
GraphQL.isRequiredArgument = kind.isRequiredArgument
GraphQL.isRequiredInputField = kind.isRequiredInputField
GraphQL.isSpecifiedScalarType = kind.isSpecifiedScalarType
GraphQL.isIntrospectionType = kind.isIntrospectionType
GraphQL.isSpecifiedDirective = kind.isSpecifiedDirective

GraphQL.assertSchema = kind.assertSchema
GraphQL.assertDirective = kind.assertDirective
GraphQL.assertType = kind.assertType
GraphQL.assertScalarType = kind.assertScalarType
GraphQL.assertObjectType = kind.assertObjectType
GraphQL.assertInterfaceType = kind.assertInterfaceType
GraphQL.assertUnionType = kind.assertUnionType
GraphQL.assertEnumType = kind.assertEnumType
GraphQL.assertInputObjectType = kind.assertInputObjectType
GraphQL.assertListType = kind.assertListType
GraphQL.assertNonNullType = kind.assertNonNullType
GraphQL.assertInputType = kind.assertInputType
GraphQL.assertOutputType = kind.assertOutputType
GraphQL.assertLeafType = kind.assertLeafType
GraphQL.assertCompositeType = kind.assertCompositeType
GraphQL.assertAbstractType = kind.assertAbstractType
GraphQL.assertWrappingType = kind.assertWrappingType
GraphQL.assertNullableType = kind.assertNullableType
GraphQL.assertNamedType = kind.assertNamedType

GraphQL.getNullableType = kind.getNullableType
GraphQL.getNamedType = kind.getNamedType

GraphQL.validateSchema = kind.validateSchema
GraphQL.assertValidSchema = kind.assertValidSchema

local language = require(script.language)

GraphQL.Token = language.Token
GraphQL.Source = language.Source
GraphQL.Location = language.Location
GraphQL.getLocation = language.getLocation

GraphQL.printLocation = language.printLocation
GraphQL.printSourceLocation = language.printSourceLocation

GraphQL.Lexer = language.Lexer

GraphQL.TokenKind = language.TokenKind

GraphQL.parse = language.parse
GraphQL.parseValue = language.parseValue
GraphQL.parseType = language.parseType

GraphQL.print = language.print

GraphQL.visit = language.visit
GraphQL.visitInParallel = language.visitInParallel
GraphQL.getVisitFn = language.getVisitFn
GraphQL.BREAK = language.BREAK
GraphQL.REMOVE = language.REMOVE
GraphQL.Kind = language.Kind
GraphQL.DirectiveLocation = language.DirectiveLocation

GraphQL.isDefinitionNode = language.isDefinitionNode
GraphQL.isExecutableDefinitionNode = language.isExecutableDefinitionNode
GraphQL.isSelectionNode = language.isSelectionNode
GraphQL.isValueNode = language.isValueNode
GraphQL.isTypeNode = language.isTypeNode
GraphQL.isTypeSystemDefinitionNode = language.isTypeSystemDefinitionNode
GraphQL.isTypeDefinitionNode = language.isTypeDefinitionNode
GraphQL.isTypeSystemExtensionNode = language.isTypeSystemExtensionNode
GraphQL.isTypeExtensionNode = language.isTypeExtensionNode

local execution = require(script.execution)

GraphQL.execute = execution.execute
GraphQL.executeSync = execution.executeSync
GraphQL.defaultFieldResolver = execution.defaultFieldResolver
GraphQL.defaultTypeResolver = execution.defaultTypeResolver
GraphQL.responsePathAsArray = execution.responsePathAsArray
GraphQL.getDirectiveValues = execution.getDirectiveValues

local subscription = require(script.subscription)
GraphQL.subscribe = subscription.subscribe
GraphQL.createSourceEventStream = subscription.createSourceEventStream

local validation = require(script.validation)

GraphQL.validate = validation.validate
GraphQL.ValidationContext = validation.ValidationContext

GraphQL.specifiedRules = validation.specifiedRules

GraphQL.ExecutableDefinitionsRule = validation.ExecutableDefinitionsRule
GraphQL.FieldsOnCorrectTypeRule = validation.FieldsOnCorrectTypeRule
GraphQL.FragmentsOnCompositeTypesRule = validation.FragmentsOnCompositeTypesRule
GraphQL.KnownArgumentNamesRule = validation.KnownArgumentNamesRule
GraphQL.KnownDirectivesRule = validation.KnownDirectivesRule
GraphQL.KnownFragmentNamesRule = validation.KnownFragmentNamesRule
GraphQL.KnownTypeNamesRule = validation.KnownTypeNamesRule
GraphQL.LoneAnonymousOperationRule = validation.LoneAnonymousOperationRule
GraphQL.NoFragmentCyclesRule = validation.NoFragmentCyclesRule
GraphQL.NoUndefinedVariablesRule = validation.NoUndefinedVariablesRule
GraphQL.NoUnusedFragmentsRule = validation.NoUnusedFragmentsRule
GraphQL.NoUnusedVariablesRule = validation.NoUnusedVariablesRule
GraphQL.OverlappingFieldsCanBeMergedRule = validation.OverlappingFieldsCanBeMergedRule
GraphQL.PossibleFragmentSpreadsRule = validation.PossibleFragmentSpreadsRule
GraphQL.ProvidedRequiredArgumentsRule = validation.ProvidedRequiredArgumentsRule
GraphQL.ScalarLeafsRule = validation.ScalarLeafsRule
GraphQL.SingleFieldSubscriptionsRule = validation.SingleFieldSubscriptionsRule
GraphQL.UniqueArgumentNamesRule = validation.UniqueArgumentNamesRule
GraphQL.UniqueDirectivesPerLocationRule = validation.UniqueDirectivesPerLocationRule
GraphQL.UniqueFragmentNamesRule = validation.UniqueFragmentNamesRule
GraphQL.UniqueInputFieldNamesRule = validation.UniqueInputFieldNamesRule
GraphQL.UniqueOperationNamesRule = validation.UniqueOperationNamesRule
GraphQL.UniqueVariableNamesRule = validation.UniqueVariableNamesRule
GraphQL.ValuesOfCorrectTypeRule = validation.ValuesOfCorrectTypeRule
GraphQL.VariablesAreInputTypesRule = validation.VariablesAreInputTypesRule
GraphQL.VariablesInAllowedPositionRule = validation.VariablesInAllowedPositionRule

GraphQL.LoneSchemaDefinitionRule = validation.LoneSchemaDefinitionRule
GraphQL.UniqueOperationTypesRule = validation.UniqueOperationTypesRule
GraphQL.UniqueTypeNamesRule = validation.UniqueTypeNamesRule
GraphQL.UniqueEnumValueNamesRule = validation.UniqueEnumValueNamesRule
GraphQL.UniqueFieldDefinitionNamesRule = validation.UniqueFieldDefinitionNamesRule
GraphQL.UniqueDirectiveNamesRule = validation.UniqueDirectiveNamesRule
GraphQL.PossibleTypeExtensionsRule = validation.PossibleTypeExtensionsRule

GraphQL.NoDeprecatedCustomRule = validation.NoDeprecatedCustomRule
GraphQL.NoSchemaIntrospectionCustomRule = validation.NoSchemaIntrospectionCustomRule

local err = require(script.error)
GraphQL.GraphQLError = err.GraphQLError
GraphQL.syntaxError = err.syntaxError
GraphQL.locatedError = err.locatedError
GraphQL.printError = err.printError
GraphQL.formatError = err.formatError

local utilities = require(script.utilities)

GraphQL.getIntrospectionQuery = utilities.getIntrospectionQuery

GraphQL.getOperationAST = utilities.getOperationAST

GraphQL.getOperationRootType = utilities.getOperationRootType

GraphQL.introspectionFromSchema = utilities.introspectionFromSchema

GraphQL.buildClientSchema = utilities.buildClientSchema

GraphQL.buildASTSchema = utilities.buildASTSchema

GraphQL.buildSchema = utilities.buildSchema
GraphQL.parse = utilities.parse

GraphQL.extendSchema = utilities.extendSchema

GraphQL.lexicographicSortSchema = utilities.lexicographicSortSchema

GraphQL.printSchema = utilities.printSchema

GraphQL.printType = utilities.printType

GraphQL.printIntrospectionSchema = utilities.printIntrospectionSchema

GraphQL.typeFromAST = utilities.typeFromAST

GraphQL.valueFromAST = utilities.valueFromAST

GraphQL.valueFromASTUntyped = utilities.valueFromASTUntyped

GraphQL.astFromValue = utilities.astFromValue

GraphQL.TypeInfo = utilities.TypeInfo
GraphQL.visitWithTypeInfo = utilities.visitWithTypeInfo

GraphQL.coerceInputValue = utilities.coerceInputValue

GraphQL.concatAST = utilities.concatAST

GraphQL.separateOperations = utilities.separateOperations

GraphQL.stripIgnoredCharacters = utilities.stripIgnoredCharacters

GraphQL.isEqualType = utilities.isEqualType
GraphQL.isTypeSubTypeOf = utilities.isTypeSubTypeOf
GraphQL.doTypesOverlap = utilities.doTypesOverlap

GraphQL.assertValidName = utilities.assertValidName

GraphQL.isValidNameError = utilities.isValidNameError

GraphQL.BreakingChangeType = utilities.BreakingChangeType
GraphQL.DangerousChangeType = utilities.DangerousChangeType
GraphQL.findBreakingChanges = utilities.findBreakingChanges
GraphQL.findDangerousChanges = utilities.findDangerousChanges

GraphQL.NULL = require(script.luaUtils.null)

GraphQL.stringify = require(script.luaUtils.stringify)

return GraphQL
