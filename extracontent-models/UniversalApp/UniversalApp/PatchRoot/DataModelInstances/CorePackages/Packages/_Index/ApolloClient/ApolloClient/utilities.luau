local t1 = {}
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local invariant = require(scriptParent.jsutils.invariant).invariant
local DEV = require(script.globals).DEV

invariant(typeof(DEV) == "boolean", (tostring(DEV)))
t1.DEV = DEV

local Object = require(scriptParentParent.LuauPolyfill).Object

t1.NULL = require(script.globals).NULL

local directives = require(script.graphql.directives)

t1.shouldInclude = directives.shouldInclude
t1.hasDirectives = directives.hasDirectives
t1.hasClientExports = directives.hasClientExports
t1.getDirectiveNames = directives.getDirectiveNames
t1.getInclusionDirectives = directives.getInclusionDirectives

local fragments = require(script.graphql.fragments)

t1.createFragmentMap = fragments.createFragmentMap
t1.getFragmentQueryDocument = fragments.getFragmentQueryDocument
t1.getFragmentFromSelection = fragments.getFragmentFromSelection

local getFromAST = require(script.graphql.getFromAST)

t1.checkDocument = getFromAST.checkDocument
t1.getOperationDefinition = getFromAST.getOperationDefinition
t1.getOperationName = getFromAST.getOperationName
t1.getFragmentDefinitions = getFromAST.getFragmentDefinitions
t1.getQueryDefinition = getFromAST.getQueryDefinition
t1.getFragmentDefinition = getFromAST.getFragmentDefinition
t1.getMainDefinition = getFromAST.getMainDefinition
t1.getDefaultValues = getFromAST.getDefaultValues

local storeUtils = require(script.graphql.storeUtils)

t1.makeReference = storeUtils.makeReference
t1.isDocumentNode = storeUtils.isDocumentNode
t1.isReference = storeUtils.isReference
t1.isField = storeUtils.isField
t1.isInlineFragment = storeUtils.isInlineFragment
t1.valueToObjectRepresentation = storeUtils.valueToObjectRepresentation
t1.storeKeyNameFromField = storeUtils.storeKeyNameFromField
t1.argumentsObjectFromField = storeUtils.argumentsObjectFromField
t1.resultKeyNameFromField = storeUtils.resultKeyNameFromField
t1.getStoreKeyName = storeUtils.getStoreKeyName
t1.getTypenameFromResult = storeUtils.getTypenameFromResult

local transform = require(script.graphql.transform)

t1.addTypenameToDocument = transform.addTypenameToDocument
t1.buildQueryFromSelectionSet = transform.buildQueryFromSelectionSet
t1.removeDirectivesFromDocument = transform.removeDirectivesFromDocument
t1.removeConnectionDirectiveFromDocument = transform.removeConnectionDirectiveFromDocument
t1.removeArgumentsFromDocument = transform.removeArgumentsFromDocument
t1.removeFragmentSpreadFromDocument = transform.removeFragmentSpreadFromDocument
t1.removeClientSetsFromDocument = transform.removeClientSetsFromDocument

local pagination = require(script.policies.pagination)

t1.concatPagination = pagination.concatPagination
t1.offsetLimitPagination = pagination.offsetLimitPagination
t1.relayStylePagination = pagination.relayStylePagination
t1.Observable = require(script.observables.Observable).Observable
Object.assign(t1, require(script.common.mergeDeep))
Object.assign(t1, require(script.common.cloneDeep))
Object.assign(t1, require(script.common.maybeDeepFreeze))
Object.assign(t1, require(script.common.stringifyForDisplay))
Object.assign(t1, require(script.observables.iteration))
Object.assign(t1, require(script.observables.asyncMap))

local Concast = require(script.observables.Concast)

Object.assign(t1, Concast)
Object.assign(t1, require(script.observables.subclassing))
Object.assign(t1, require(script.common.arrays))
Object.assign(t1, require(script.common.objects))
Object.assign(t1, require(script.common.errorHandling))
Object.assign(t1, require(script.common.canUse))
Object.assign(t1, require(script.common.compact))
Object.assign(t1, require(script.common.makeUniqueId))

return t1
