local getIntrospectionQuery = require(script.getIntrospectionQuery)
local buildASTSchema = require(script.buildASTSchema)
local printSchema = require(script.printSchema)
local TypeInfo = require(script.TypeInfo)
local typeComparators = require(script.typeComparators)
local assertValidName = require(script.assertValidName)
local findBreakingChanges = require(script.findBreakingChanges)

local Utilities = {
	getIntrospectionQuery = getIntrospectionQuery.getIntrospectionQuery,
	getOperationAST = 0,
	getOperationRootType = 0,
	introspectionFromSchema = 0,
	buildClientSchema = 0,
	buildASTSchema = 0,
	buildSchema = 0,
	parse = 0,
	extendSchema = 0,
	lexicographicSortSchema = 0,
	printSchema = 0,
	printType = 0,
	printIntrospectionSchema = 0,
	typeFromAST = 0,
	valueFromAST = 0,
	valueFromASTUntyped = 0,
	astFromValue = 0,
	TypeInfo = 0,
	visitWithTypeInfo = 0,
	coerceInputValue = 0,
	concatAST = 0,
	separateOperations = 0,
	stripIgnoredCharacters = 0,
	isEqualType = 0,
	isTypeSubTypeOf = 0,
	doTypesOverlap = 0,
	assertValidName = 0,
	isValidNameError = 0,
	BreakingChangeType = 0,
	DangerousChangeType = 0,
	findBreakingChanges = 0,
	findDangerousChanges = 0
}

local getOperationAST = require(script.getOperationAST)
Utilities.getOperationAST = getOperationAST.getOperationAST

local getOperationRootType = require(script.getOperationRootType)
Utilities.getOperationRootType = getOperationRootType.getOperationRootType

local introspectionFromSchema = require(script.introspectionFromSchema)
Utilities.introspectionFromSchema = introspectionFromSchema.introspectionFromSchema

local buildClientSchema = require(script.buildClientSchema)
Utilities.buildClientSchema = buildClientSchema.buildClientSchema

Utilities.buildASTSchema = buildASTSchema.buildASTSchema
Utilities.buildSchema = buildASTSchema.buildSchema
Utilities.parse = buildASTSchema.parse

local extendSchema = require(script.extendSchema)
Utilities.extendSchema = extendSchema.extendSchema

local lexicographicSortSchema = require(script.lexicographicSortSchema)
Utilities.lexicographicSortSchema = lexicographicSortSchema.lexicographicSortSchema

Utilities.printSchema = printSchema.printSchema
Utilities.printType = printSchema.printType
Utilities.printIntrospectionSchema = printSchema.printIntrospectionSchema

local typeFromAST = require(script.typeFromAST)
Utilities.typeFromAST = typeFromAST.typeFromAST

local valueFromAST = require(script.valueFromAST)
Utilities.valueFromAST = valueFromAST.valueFromAST

local valueFromASTUntyped = require(script.valueFromASTUntyped)
Utilities.valueFromASTUntyped = valueFromASTUntyped.valueFromASTUntyped

local astFromValue = require(script.astFromValue)
Utilities.astFromValue = astFromValue.astFromValue

Utilities.TypeInfo = TypeInfo.TypeInfo
Utilities.visitWithTypeInfo = TypeInfo.visitWithTypeInfo

local coerceInputValue = require(script.coerceInputValue)
Utilities.coerceInputValue = coerceInputValue.coerceInputValue

local concatAST = require(script.concatAST)
Utilities.concatAST = concatAST.concatAST

local separateOperations = require(script.separateOperations)
Utilities.separateOperations = separateOperations.separateOperations

local stripIgnoredCharacters = require(script.stripIgnoredCharacters)
Utilities.stripIgnoredCharacters = stripIgnoredCharacters.stripIgnoredCharacters

Utilities.isEqualType = typeComparators.isEqualType
Utilities.isTypeSubTypeOf = typeComparators.isTypeSubTypeOf
Utilities.doTypesOverlap = typeComparators.doTypesOverlap

Utilities.assertValidName = assertValidName.assertValidName
Utilities.isValidNameError = assertValidName.isValidNameError

Utilities.BreakingChangeType = findBreakingChanges.BreakingChangeType
Utilities.DangerousChangeType = findBreakingChanges.DangerousChangeType
Utilities.findBreakingChanges = findBreakingChanges.findBreakingChanges
Utilities.findDangerousChanges = findBreakingChanges.findDangerousChanges
return Utilities
