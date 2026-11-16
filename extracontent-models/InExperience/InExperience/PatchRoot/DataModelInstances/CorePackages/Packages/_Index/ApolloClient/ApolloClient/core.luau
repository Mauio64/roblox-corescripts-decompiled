local parent = script.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local utilities = require(parent.utilities)
local dev = utilities.DEV

local ApolloClient = require(script.ApolloClient)
local Core = {}

Core.ApolloClient = ApolloClient.ApolloClient

Core.mergeOptions = ApolloClient.mergeOptions

local ObservableQuery = require(script.ObservableQuery)
Core.applyNextFetchPolicy = ObservableQuery.applyNextFetchPolicy
Core.ObservableQuery = ObservableQuery.ObservableQuery

require(script.watchQueryOptions)

local networkStatus = require(script.networkStatus)
Core.NetworkStatus = networkStatus.NetworkStatus

local types = require(script.types)
Object.assign(Core, types)

require(script.LocalState)

local errors = require(script.Parent.errors)
Core.isApolloError = errors.isApolloError
Core.ApolloError = errors.ApolloError

local cache = require(script.Parent.cache)
Core.ApolloCache = cache.ApolloCache
Core.defaultDataIdFromObject = cache.defaultDataIdFromObject
Core.InMemoryCache = cache.InMemoryCache
Core.MissingFieldError = cache.MissingFieldError
Core.makeVar = cache.makeVar

Core.None = cache.None

local types2 = require(script.Parent.cache.inmemory.types)
Object.assign(Core, types2)

local core = require(script.Parent.link.core)
Object.assign(Core, core)

local http = require(script.Parent.link.http)
Object.assign(Core, http)

local utils = require(script.Parent.link.utils)
Core.fromError = utils.fromError
Core.toPromise = utils.toPromise
Core.fromPromise = utils.fromPromise
Core.throwServerError = utils.throwServerError

local utilities2 = require(script.Parent.utilities)
Core.Observable = utilities2.Observable

Core.isReference = utilities2.isReference
Core.makeReference = utilities2.makeReference
Core.NULL = utilities2.NULL

local invariant = require(parent.jsutils.invariant)
local setVerbosity = invariant.setVerbosity
Core.setLogVerbosity = setVerbosity

setVerbosity(dev and "log" or "silent")

local GraphQLTag = require(parent2.GraphQLTag)
Core.gql = GraphQLTag.default
Core.resetCaches = GraphQLTag.resetCaches
Core.disableFragmentWarnings = GraphQLTag.disableFragmentWarnings
Core.enableExperimentalFragmentVariables = GraphQLTag.enableExperimentalFragmentVariables
Core.disableExperimentalFragmentVariables = GraphQLTag.disableExperimentalFragmentVariables

return Core
