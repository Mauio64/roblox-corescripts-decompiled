local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local t1 = {}
local visit = require(ParentParent.GraphQL).visit
local ApolloLink = require(script.Parent.Parent.core).ApolloLink
local Observable = require(script.Parent.Parent.Parent.utilities).Observable
local serializeFetchParameter = require(script.Parent.serializeFetchParameter).serializeFetchParameter
local selectURI = require(script.Parent.selectURI).selectURI
local parseAndCheckHttpResponse = require(script.Parent.parseAndCheckHttpResponse).parseAndCheckHttpResponse
local checkFetcher = require(script.Parent.checkFetcher).checkFetcher
local selectHttpOptionsAndBody = require(script.Parent.selectHttpOptionsAndBody)
local selectHttpOptionsAndBody2 = selectHttpOptionsAndBody.selectHttpOptionsAndBody
local fallbackHttpConfig = selectHttpOptionsAndBody.fallbackHttpConfig
local createSignalIfSupported = require(script.Parent.createSignalIfSupported).createSignalIfSupported
local rewriteURIForGET = require(script.Parent.rewriteURIForGET).rewriteURIForGET
local fromError = require(script.Parent.Parent.utils).fromError

function t1.createHttpLink(p1) -- line: 41
	-- upvalues: Object (copy), checkFetcher (copy), Boolean (copy), ApolloLink (copy), selectURI (copy), selectHttpOptionsAndBody2 (copy), fallbackHttpConfig (copy), Set (copy), visit (copy), createSignalIfSupported (copy), Array (copy), rewriteURIForGET (copy), fromError (copy), serializeFetchParameter (copy), Observable (copy), parseAndCheckHttpResponse (copy)
	if p1 == nil then
		p1 = {}
	end

	local v22 = p1.uri ~= nil and p1.uri or "/graphql"
	local fetch = p1.fetch
	local includeExtensions = p1.includeExtensions
	local useGETForQueries = p1.useGETForQueries
	local v26 = p1.includeUnusedVariables ~= nil and (p1.includeUnusedVariables or false)
	local v27 = Object.assign({}, p1, {
		uri = Object.None,
		fetch = Object.None,
		includeExtensions = Object.None,
		useGETForQueries = Object.None,
		includeUnusedVariables = Object.None
	})

	checkFetcher(fetch)

	if not Boolean.toJSBoolean(fetch) then
		fetch = _G.fetch
	end

	local t2 = {
		http = {
			includeExtensions = includeExtensions
		},
		options = v27.fetchOptions,
		credentials = v27.credentials,
		headers = v27.headers
	}

	return ApolloLink.new(function(_, p3) -- line: 78
		-- upvalues: selectURI (copy), v22 (copy), Boolean (copy), Object (copy), selectHttpOptionsAndBody2 (copy), fallbackHttpConfig (copy), t2 (copy), v26 (copy), Set (copy), visit (copy), createSignalIfSupported (copy), useGETForQueries (copy), Array (copy), rewriteURIForGET (copy), fromError (copy), serializeFetchParameter (copy), Observable (copy), fetch (ref), parseAndCheckHttpResponse (copy)
		local u31 = selectURI(p3, v22)
		local v32 = p3:getContext()
		local t3 = {}

		if Boolean.toJSBoolean(v32.clientAwareness) then
			local name = v32.clientAwareness.name
			local version = v32.clientAwareness.version

			if Boolean.toJSBoolean(name) then
				t3["apollographql-client-name"] = name
			end

			if Boolean.toJSBoolean(version) then
				t3["apollographql-client-version"] = version
			end
		end

		local v36 = Object.assign({}, t3, v32.headers)
		local t4 = {
			http = v32.http,
			options = v32.fetchOptions,
			credentials = v32.credentials,
			headers = v36
		}
		local v38 = selectHttpOptionsAndBody2(p3, fallbackHttpConfig, t2, t4)
		local options = v38.options
		local body = v38.body

		if body.variables ~= nil and not v26 then
			local v41 = Set.new(Object.keys(body.variables))

			visit(p3.query, {
				Variable = function(_, p5, _, p7) -- line: 122
					-- upvalues: Boolean (copy), v41 (copy)
					if Boolean.toJSBoolean(p7) and p7.kind ~= "VariableDefinition" then
						v41:delete(p5.name.value)
					end
				end
			})

			if Boolean.toJSBoolean(v41.size) then
				body.variables = Object.assign({}, body.variables)
				v41:forEach(function(p8) -- line: 139
					-- upvalues: body (copy)
					body.variables[p8] = nil
				end)
			end
		end

		local u42 = nil

		if not Boolean.toJSBoolean(options.signal) then
			local v43 = createSignalIfSupported()
			local controller = v43.controller
			local signal = v43.signal

			u42 = controller

			if Boolean.toJSBoolean(u42) then
				options.signal = signal
			end
		end

		local function definitionIsMutation(p9) -- line: 156
			return p9.kind == "OperationDefinition" and p9.operation == "mutation"
		end

		if Boolean.toJSBoolean(useGETForQueries) and not Array.some(p3.query.definitions, definitionIsMutation) then
			options.method = "GET"
		end

		if options.method == "GET" then
			local v47 = rewriteURIForGET(u31, body)
			local newURI = v47.newURI
			local parseError = v47.parseError

			if Boolean.toJSBoolean(parseError) then
				return fromError(parseError)
			end

			u31 = newURI
		else
			local ok, result = pcall(function() -- line: 174
				-- upvalues: options (copy), serializeFetchParameter (copy), body (copy)
				options.body = serializeFetchParameter(body, "Payload")
			end)

			if not ok then
				return fromError(result)
			end
		end

		return Observable.new(function(p10) -- line: 181
			-- upvalues: fetch (ref), u31 (ref), options (copy), p3 (copy), parseAndCheckHttpResponse (copy), Boolean (copy), u42 (ref)
			fetch(u31, options):andThen(function(p11) -- line: 183
				-- upvalues: p3 (copy)
				p3:setContext({
					response = p11
				})

				return p11
			end):andThen(parseAndCheckHttpResponse(p3)):andThen(function(p12) -- line: 188
				-- upvalues: p10 (copy)
				p10:next(p12)
				p10:complete()

				return p12
			end):catch(function(p13) -- line: 194
				-- upvalues: Boolean (copy), p10 (copy)
				if p13.name == "AbortError" then
					return
				end

				if Boolean.toJSBoolean(p13.result) and Boolean.toJSBoolean(p13.result.errors) and Boolean.toJSBoolean(p13.result.data) then
					p10:next(p13.result)
				end

				p10:error(p13)
			end)

			return function() -- line: 241
				-- upvalues: Boolean (copy), u42 (ref)
				if Boolean.toJSBoolean(u42) then
					u42:abort()
				end
			end
		end)
	end)
end

return t1
