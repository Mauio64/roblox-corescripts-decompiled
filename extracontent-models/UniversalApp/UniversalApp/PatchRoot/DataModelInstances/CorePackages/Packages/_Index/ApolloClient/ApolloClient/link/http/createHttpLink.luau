local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set

local GraphQL = require(parent.GraphQL)
local visit = GraphQL.visit

local core = require(script.Parent.Parent.core)
local apolloLink = core.ApolloLink
local utilities = require(script.Parent.Parent.Parent.utilities)
local observable = utilities.Observable
local serializeFetchParameter = require(script.Parent.serializeFetchParameter)
local serializeFetchParameter2 = serializeFetchParameter.serializeFetchParameter
local selectURI = require(script.Parent.selectURI)
local selectURI2 = selectURI.selectURI
local parseAndCheckHttpResponse = require(script.Parent.parseAndCheckHttpResponse)
local parseAndCheckHttpResponse2 = parseAndCheckHttpResponse.parseAndCheckHttpResponse
local checkFetcher = require(script.Parent.checkFetcher)
local checkFetcher2 = checkFetcher.checkFetcher
local selectHttpOptionsAndBody = require(script.Parent.selectHttpOptionsAndBody)
local selectHttpOptionsAndBody2 = selectHttpOptionsAndBody.selectHttpOptionsAndBody
local fallbackHttpConfig = selectHttpOptionsAndBody.fallbackHttpConfig

local createSignalIfSupported = require(script.Parent.createSignalIfSupported)
local createSignalIfSupported2 = createSignalIfSupported.createSignalIfSupported
local rewriteURIForGET = require(script.Parent.rewriteURIForGET)
local rewriteURIForGET2 = rewriteURIForGET.rewriteURIForGET
local utils = require(script.Parent.Parent.utils)
local fromError = utils.fromError
return {
	createHttpLink = function(p)
		local v = p == nil and {} or p

		local v2 = v.uri == nil and "/graphql" or v.uri or "/graphql"
		local fetch = v.fetch
		local includeExtensions = v.includeExtensions
		local useGETForQueries = v.useGETForQueries
		local v3

		if v.includeUnusedVariables == nil then
			v3 = false
		else
			v3 = v.includeUnusedVariables or false
		end

		local v4 = Object.assign({}, v, {
			uri = Object.None,
			fetch = Object.None,
			includeExtensions = Object.None,
			useGETForQueries = Object.None,
			includeUnusedVariables = Object.None
		})

		checkFetcher2(fetch)

		if not Boolean.toJSBoolean(fetch) then
			fetch = _G.fetch
		end

		local v5 = {
			http = { includeExtensions = includeExtensions },
			options = v4.fetchOptions,
			credentials = v4.credentials,
			headers = v4.headers
		}

		return apolloLink.new(function(_, object)
			local v6 = selectURI2(object, v2)

			local context = object:getContext()

			local v7 = {}

			if Boolean.toJSBoolean(context.clientAwareness) then
				local name = context.clientAwareness.name
				local version = context.clientAwareness.version

				if Boolean.toJSBoolean(name) then
					v7["apollographql-client-name"] = name
				end

				if Boolean.toJSBoolean(version) then
					v7["apollographql-client-version"] = version
				end
			end

			local headers = Object.assign({}, v7, context.headers)

			local v8 = selectHttpOptionsAndBody2(object, fallbackHttpConfig, v5, {
				http = context.http,
				options = context.fetchOptions,
				credentials = context.credentials,
				headers = headers
			})
			local options = v8.options
			local body = v8.body

			if body.variables ~= nil and not v3 then
				local v9 = Set.new(Object.keys(body.variables))
				visit(object.query, {
					Variable = function(_, p2, _, p3)
						if Boolean.toJSBoolean(p3) and p3.kind ~= "VariableDefinition" then
							v9:delete(p2.name.value)
						end
					end
				})

				if Boolean.toJSBoolean(v9.size) then
					body.variables = Object.assign({}, body.variables)
					v9:forEach(function(p2)
						body.variables[p2] = nil
					end)
				end
			end

			local controller

			if Boolean.toJSBoolean(options.signal) then
				controller = nil
			else
				local signalIfSupported = createSignalIfSupported2()
				controller = signalIfSupported.controller
				local signal = signalIfSupported.signal

				if Boolean.toJSBoolean(controller) then
					options.signal = signal
				end
			end

			local function definitionIsMutation(p2): boolean
				return p2.kind == "OperationDefinition" and p2.operation == "mutation"
			end

			if
				Boolean.toJSBoolean(useGETForQueries)
				and not Array.some(object.query.definitions, definitionIsMutation)
			then
				options.method = "GET"
			end

			if options.method == "GET" then
				local v9 = rewriteURIForGET2(v6, body)
				v6 = v9.newURI
				local parseError = v9.parseError

				if Boolean.toJSBoolean(parseError) then
					return fromError(parseError)
				end
			else
				local success, result = pcall(function()
					options.body = serializeFetchParameter2(body, "Payload")
				end)

				if not success then
					return fromError(result)
				end
			end

			return observable.new(function(object2)
				fetch(v6, options):andThen(function(response)
					object:setContext({ response = response })
					return response
				end):andThen(parseAndCheckHttpResponse2(object)):andThen(function(p2)
					object2:next(p2)
					object2:complete()
					return p2
				end):catch(function(p2)
					if p2.name == "AbortError" then
						return
					end

					if
						Boolean.toJSBoolean(p2.result)
						and Boolean.toJSBoolean(p2.result.errors)
						and Boolean.toJSBoolean(p2.result.data)
					then
						object2:next(p2.result)
					end

					object2:error(p2)
				end)

				return function()
					if Boolean.toJSBoolean(controller) then
						controller:abort()
					end
				end
			end)
		end)
	end
}
