local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("GraphQLServer").Parent

local ApolloClient = require(parent.ApolloClient)
local apolloClient = ApolloClient.ApolloClient
local HttpLink = ApolloClient.HttpLink
local InMemoryCache = ApolloClient.InMemoryCache

local ApolloLocalState = require(parent.ApolloLocalState)
local typePolicies = ApolloLocalState.typePolicies

local Server = require(script.Parent.Server)
local Fetch = require(parent.Fetch)
local buildFetch = Fetch.buildFetch

local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

require(script.ApolloClientTestUtilsTypes)

local function mockHttpService(data) -- 1 equivalent call inferred from this helper
	return {
		RequestInternal = function(_, p)
			return {
				Start = function(_, callback)
					local v

					if data.responseMap and data.responseMap[p.Url] then
						v = data.responseMap[p.Url]
					else
						v = data.defaultResponse or {}
					end

					callback(true, {
						Body = HttpService:JSONEncode(v.Body),
						Success = v.Success == nil or v.Success,
						StatusCode = not v.StatusCode and 200 or v.StatusCode,
						StatusMessage = not v.StatusMessage and "OK" or v.StatusMessage,
						Headers = not v.Headers and {} or v.Headers
					})

					if data.responseSpy then
						data.responseSpy(p)
					end
				end
			}
		end
	}
end

local ApolloClientTestUtils = {}

function ApolloClientTestUtils.mockApolloClient(data)
	local v = mockHttpService(data) -- inferred equivalent call
	local v2 = Server.new({ mockResolvers = data.mockResolvers, fetchImpl = buildFetch(v) })

	return (apolloClient.new({
		cache = InMemoryCache.new({ typePolicies = typePolicies }),
		link = HttpLink.new({
			uri = "/api",
			fetch = function(_, p)
				return v2:fetchLocal(p)
			end
		})
	}))
end

ApolloClientTestUtils.mockHttpService = mockHttpService

function ApolloClientTestUtils.appendApolloClientToReducer(callback, apolloClient2)
	return function(options, p)
		local v = callback(options or {}, p)
		return (Object.assign(table.clone(v), {
			ApolloClient = { apolloClient = apolloClient2 }
		}))
	end
end

return ApolloClientTestUtils
