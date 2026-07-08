local scriptParent = script.Parent
local Object = require(scriptParent.LuauPolyfill).Object
local t1 = {}
local loaders = require(script.loaders)

Object.assign(t1, loaders)

local helpers = require(script.helpers)

Object.assign(t1, helpers)

local lib = require(script["get-directives"])

Object.assign(t1, lib)

local lib2 = require(script["get-arguments-with-directives"])

Object.assign(t1, lib2)

local lib3 = require(script["get-implementing-types"])

Object.assign(t1, lib3)

local lib4 = require(script["print-schema-with-directives"])

Object.assign(t1, lib4)

local lib5 = require(script["get-fields-with-directives"])

Object.assign(t1, lib5)

local lib6 = require(script["validate-documents"])

Object.assign(t1, lib6)

local lib7 = require(script["parse-graphql-json"])

Object.assign(t1, lib7)

local lib8 = require(script["parse-graphql-sdl"])

Object.assign(t1, lib8)

local lib9 = require(script["build-operation-for-field"])

Object.assign(t1, lib9)

local types = require(script.types)

Object.assign(t1, types)

local filterSchema = require(script.filterSchema)

Object.assign(t1, filterSchema)

local heal = require(script.heal)

Object.assign(t1, heal)

local getResolversFromSchema = require(script.getResolversFromSchema)

Object.assign(t1, getResolversFromSchema)

local forEachField = require(script.forEachField)

Object.assign(t1, forEachField)

local forEachDefaultValue = require(script.forEachDefaultValue)

Object.assign(t1, forEachDefaultValue)

local mapSchema = require(script.mapSchema)

Object.assign(t1, mapSchema)

local addTypes = require(script.addTypes)

Object.assign(t1, addTypes)

local rewire = require(script.rewire)

Object.assign(t1, rewire)

local prune = require(script.prune)

Object.assign(t1, prune)

local mergeDeep = require(script.mergeDeep)

Object.assign(t1, mergeDeep)

local Interfaces = require(script.Interfaces)

Object.assign(t1, Interfaces)

local stub = require(script.stub)

Object.assign(t1, stub)

local selectionSets = require(script.selectionSets)

Object.assign(t1, selectionSets)

local getResponseKeyFromInfo = require(script.getResponseKeyFromInfo)

Object.assign(t1, getResponseKeyFromInfo)

local fields = require(script.fields)

Object.assign(t1, fields)

local renameType = require(script.renameType)

Object.assign(t1, renameType)

local transformInputValue = require(script.transformInputValue)

Object.assign(t1, transformInputValue)

local mapAsyncIterator = require(script.mapAsyncIterator)

Object.assign(t1, mapAsyncIterator)

local updateArgument = require(script.updateArgument)

Object.assign(t1, updateArgument)

local implementsAbstractType = require(script.implementsAbstractType)

Object.assign(t1, implementsAbstractType)

local errors = require(script.errors)

Object.assign(t1, errors)

local visitResult = require(script.visitResult)

Object.assign(t1, visitResult)

local getArgumentValues = require(script.getArgumentValues)

Object.assign(t1, getArgumentValues)

local valueMatchesCriteria = require(script.valueMatchesCriteria)

Object.assign(t1, valueMatchesCriteria)

local isAsyncIterable = require(script.isAsyncIterable)

Object.assign(t1, isAsyncIterable)

local isDocumentNode = require(script.isDocumentNode)

Object.assign(t1, isDocumentNode)

local astFromValueUntyped = require(script.astFromValueUntyped)

Object.assign(t1, astFromValueUntyped)

local executor = require(script.executor)

Object.assign(t1, executor)

local AggregateError = require(script.AggregateError)

Object.assign(t1, AggregateError)

local rootTypes = require(script.rootTypes)

Object.assign(t1, rootTypes)

local comments = require(script.comments)

Object.assign(t1, comments)

local collectFields = require(script.collectFields)

Object.assign(t1, collectFields)

local inspect = require(script.inspect)

Object.assign(t1, inspect)

local memoize = require(script.memoize)

Object.assign(t1, memoize)

local fixSchemaAst = require(script.fixSchemaAst)

Object.assign(t1, fixSchemaAst)

local getOperationASTFromRequest = require(script.getOperationASTFromRequest)

Object.assign(t1, getOperationASTFromRequest)

local extractExtensionsFromSchema = require(script.extractExtensionsFromSchema)

Object.assign(t1, extractExtensionsFromSchema)

return t1
