local parent = script.Parent
local parent2 = parent.Parent
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local globals = require(script.globals)
local dev = globals.DEV
invariant2(typeof(dev) == "boolean", (tostring(dev)))

local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local globals2 = require(script.globals)
local Utilities = {}
Utilities.DEV = dev
Utilities.NULL = globals2.NULL

local directives = require(script.graphql.directives)
Utilities.shouldInclude = directives.shouldInclude
Utilities.hasDirectives = directives.hasDirectives
Utilities.hasClientExports = directives.hasClientExports
Utilities.getDirectiveNames = directives.getDirectiveNames
Utilities.getInclusionDirectives = directives.getInclusionDirectives

local fragments = require(script.graphql.fragments)

Utilities.createFragmentMap = fragments.createFragmentMap
Utilities.getFragmentQueryDocument = fragments.getFragmentQueryDocument
Utilities.getFragmentFromSelection = fragments.getFragmentFromSelection

local getFromAST = require(script.graphql.getFromAST)
Utilities.checkDocument = getFromAST.checkDocument
Utilities.getOperationDefinition = getFromAST.getOperationDefinition
Utilities.getOperationName = getFromAST.getOperationName
Utilities.getFragmentDefinitions = getFromAST.getFragmentDefinitions
Utilities.getQueryDefinition = getFromAST.getQueryDefinition
Utilities.getFragmentDefinition = getFromAST.getFragmentDefinition
Utilities.getMainDefinition = getFromAST.getMainDefinition
Utilities.getDefaultValues = getFromAST.getDefaultValues

local storeUtils = require(script.graphql.storeUtils)

Utilities.makeReference = storeUtils.makeReference
Utilities.isDocumentNode = storeUtils.isDocumentNode
Utilities.isReference = storeUtils.isReference
Utilities.isField = storeUtils.isField
Utilities.isInlineFragment = storeUtils.isInlineFragment
Utilities.valueToObjectRepresentation = storeUtils.valueToObjectRepresentation
Utilities.storeKeyNameFromField = storeUtils.storeKeyNameFromField
Utilities.argumentsObjectFromField = storeUtils.argumentsObjectFromField
Utilities.resultKeyNameFromField = storeUtils.resultKeyNameFromField
Utilities.getStoreKeyName = storeUtils.getStoreKeyName
Utilities.getTypenameFromResult = storeUtils.getTypenameFromResult

local transform = require(script.graphql.transform)

Utilities.addTypenameToDocument = transform.addTypenameToDocument
Utilities.buildQueryFromSelectionSet = transform.buildQueryFromSelectionSet
Utilities.removeDirectivesFromDocument = transform.removeDirectivesFromDocument
Utilities.removeConnectionDirectiveFromDocument = transform.removeConnectionDirectiveFromDocument
Utilities.removeArgumentsFromDocument = transform.removeArgumentsFromDocument
Utilities.removeFragmentSpreadFromDocument = transform.removeFragmentSpreadFromDocument
Utilities.removeClientSetsFromDocument = transform.removeClientSetsFromDocument

local pagination = require(script.policies.pagination)
Utilities.concatPagination = pagination.concatPagination
Utilities.offsetLimitPagination = pagination.offsetLimitPagination
Utilities.relayStylePagination = pagination.relayStylePagination

local Observable = require(script.observables.Observable)
Utilities.Observable = Observable.Observable

Object.assign(Utilities, require(script.common.mergeDeep))
Object.assign(Utilities, require(script.common.cloneDeep))
Object.assign(Utilities, require(script.common.maybeDeepFreeze))
Object.assign(Utilities, require(script.common.stringifyForDisplay))
Object.assign(Utilities, require(script.observables.iteration))
Object.assign(Utilities, require(script.observables.asyncMap))
local Concast = require(script.observables.Concast)
Object.assign(Utilities, Concast)

Object.assign(Utilities, require(script.observables.subclassing))
Object.assign(Utilities, require(script.common.arrays))
Object.assign(Utilities, require(script.common.objects))
Object.assign(Utilities, require(script.common.errorHandling))
Object.assign(Utilities, require(script.common.canUse))
Object.assign(Utilities, require(script.common.compact))
Object.assign(Utilities, require(script.common.makeUniqueId))

return Utilities
