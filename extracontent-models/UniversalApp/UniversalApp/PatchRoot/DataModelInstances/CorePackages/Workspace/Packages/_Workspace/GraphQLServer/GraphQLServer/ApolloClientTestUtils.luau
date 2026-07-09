local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local ApolloClient = require(Parent.ApolloClient)
local ApolloClient2 = ApolloClient.ApolloClient
local HttpLink = ApolloClient.HttpLink
local InMemoryCache = ApolloClient.InMemoryCache
local typePolicies = require(Parent.ApolloLocalState).typePolicies
local Server = require(script.Parent.Server)
local buildFetch = require(Parent.Fetch).buildFetch
local Object = require(Parent.LuauPolyfill).Object

require(script.ApolloClientTestUtilsTypes)

return {
	mockApolloClient = function(p1) -- line: 53
		-- upvalues: HttpService (copy), Server (copy), buildFetch (copy), ApolloClient2 (copy), InMemoryCache (copy), typePolicies (copy), HttpLink (copy)
		local t1 = {
			RequestInternal = function(_, p3) -- line: 25
				-- upvalues: p1 (copy), HttpService (copy)
				return {
					Start = function(_, p5) -- line: 27
						-- upvalues: p1 (copy), p3 (copy), HttpService (copy)
						local v31 = if not p1.responseMap or not p1.responseMap[p3.Url] then p1.defaultResponse or {} else p1.responseMap[p3.Url]

						p5(true, {
							Body = HttpService:JSONEncode(v31.Body),
							Success = v31.Success == nil or v31.Success,
							StatusCode = not v31.StatusCode and 200 or v31.StatusCode,
							StatusMessage = not v31.StatusMessage and "OK" or v31.StatusMessage,
							Headers = if not v31.Headers then {} else v31.Headers
						})

						if p1.responseSpy then
							p1.responseSpy(p3)
						end
					end
				}
			end
		}
		local v14 = Server.new({
			mockResolvers = p1.mockResolvers,
			fetchImpl = buildFetch(t1)
		})

		return (ApolloClient2.new({
			cache = InMemoryCache.new({
				typePolicies = typePolicies
			}),
			link = HttpLink.new({
				uri = "/api",
				fetch = function(_, p7) -- line: 65
					-- upvalues: v14 (copy)
					return v14:fetchLocal(p7)
				end
			})
		}))
	end,
	mockHttpService = function(p8) -- line: 23
		-- upvalues: HttpService (copy)
		return {
			RequestInternal = function(_, p10) -- line: 25
				-- upvalues: p8 (copy), HttpService (copy)
				return {
					Start = function(_, p12) -- line: 27
						-- upvalues: p8 (copy), p10 (copy), HttpService (copy)
						local v28 = if not p8.responseMap or not p8.responseMap[p10.Url] then p8.defaultResponse or {} else p8.responseMap[p10.Url]

						p12(true, {
							Body = HttpService:JSONEncode(v28.Body),
							Success = v28.Success == nil or v28.Success,
							StatusCode = not v28.StatusCode and 200 or v28.StatusCode,
							StatusMessage = not v28.StatusMessage and "OK" or v28.StatusMessage,
							Headers = if not v28.Headers then {} else v28.Headers
						})

						if p8.responseSpy then
							p8.responseSpy(p10)
						end
					end
				}
			end
		}
	end,
	appendApolloClientToReducer = function(p13, p14) -- line: 74
		-- upvalues: Object (copy)
		return function(p15, p16) -- line: 75
			-- upvalues: p13 (copy), Object (copy), p14 (copy)
			local v25 = p13(p15 or {}, p16)

			return (Object.assign(table.clone(v25), {
				ApolloClient = {
					apolloClient = p14
				}
			}))
		end
	end
}
