local t1 = {}
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Object = require(scriptParentParent.LuauPolyfill).Object
local DEV = require(scriptParent.utilities).DEV
local ApolloClient = require(script.ApolloClient)

t1.ApolloClient = ApolloClient.ApolloClient
t1.mergeOptions = ApolloClient.mergeOptions

local ObservableQuery = require(script.ObservableQuery)

t1.applyNextFetchPolicy = ObservableQuery.applyNextFetchPolicy
t1.ObservableQuery = ObservableQuery.ObservableQuery
require(script.watchQueryOptions)
t1.NetworkStatus = require(script.networkStatus).NetworkStatus

local types = require(script.types)

Object.assign(t1, types)
require(script.LocalState)

local errors = require(script.Parent.errors)

t1.isApolloError = errors.isApolloError
t1.ApolloError = errors.ApolloError

local cache = require(script.Parent.cache)

t1.ApolloCache = cache.ApolloCache
t1.defaultDataIdFromObject = cache.defaultDataIdFromObject
t1.InMemoryCache = cache.InMemoryCache
t1.MissingFieldError = cache.MissingFieldError
t1.makeVar = cache.makeVar
t1.None = cache.None

local types2 = require(script.Parent.cache.inmemory.types)

Object.assign(t1, types2)

local core = require(script.Parent.link.core)

Object.assign(t1, core)

local http = require(script.Parent.link.http)

Object.assign(t1, http)

local utils = require(script.Parent.link.utils)

t1.fromError = utils.fromError
t1.toPromise = utils.toPromise
t1.fromPromise = utils.fromPromise
t1.throwServerError = utils.throwServerError

local utilities = require(script.Parent.utilities)

t1.Observable = utilities.Observable
t1.isReference = utilities.isReference
t1.makeReference = utilities.makeReference
t1.NULL = utilities.NULL

local setVerbosity = require(scriptParent.jsutils.invariant).setVerbosity

t1.setLogVerbosity = setVerbosity
setVerbosity(not DEV and "silent" or "log")

local GraphQLTag = require(scriptParentParent.GraphQLTag)

t1.gql = GraphQLTag.default
t1.resetCaches = GraphQLTag.resetCaches
t1.disableFragmentWarnings = GraphQLTag.disableFragmentWarnings
t1.enableExperimentalFragmentVariables = GraphQLTag.enableExperimentalFragmentVariables
t1.disableExperimentalFragmentVariables = GraphQLTag.disableExperimentalFragmentVariables

return t1
