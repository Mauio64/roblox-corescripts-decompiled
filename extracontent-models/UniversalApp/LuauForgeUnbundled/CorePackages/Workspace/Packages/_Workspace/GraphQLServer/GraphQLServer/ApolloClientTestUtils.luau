local HttpService = game:GetService("HttpService")

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/ApolloClient")
local apolloClient = module.ApolloClient
local httpLink = module.HttpLink
local inMemoryCache = module.InMemoryCache

local typePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/ApolloLocalState").typePolicies

local Server = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/Server")
local buildFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch").buildFetch

local object = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Object

require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/ApolloClientTestUtils/ApolloClientTestUtilsTypes")

return {
	mockApolloClient = function(data)
		local v6 = Server.new({
			mockResolvers = data.mockResolvers,
			fetchImpl = buildFetch({
				RequestInternal = function(p2, p3)
					return {
						Start = function(self, callback)
							local v6

							if data.responseMap and data.responseMap[p3.Url] then
								v6 = data.responseMap[p3.Url]
							else
								v6 = data.defaultResponse or {}
							end

							callback(true, {
								Body = HttpService:JSONEncode(v6.Body),
								Success = v6.Success == nil or v6.Success,
								StatusCode = not v6.StatusCode and 200 or v6.StatusCode,
								StatusMessage = not v6.StatusMessage and "OK" or v6.StatusMessage,
								Headers = not v6.Headers and {} or v6.Headers
							})

							if data.responseSpy then
								data.responseSpy(p3)
							end
						end
					}
				end
			})
		})

		return (apolloClient.new({
			cache = inMemoryCache.new({ typePolicies = typePolicies }),
			link = httpLink.new({
				uri = "/api",
				fetch = function(p2, p3)
					return v6:fetchLocal(p3)
				end
			})
		}))
	end,
	mockHttpService = function(data)
		return {
			RequestInternal = function(p2, p3)
				return {
					Start = function(self, callback)
						local v5

						if data.responseMap and data.responseMap[p3.Url] then
							v5 = data.responseMap[p3.Url]
						else
							v5 = data.defaultResponse or {}
						end

						callback(true, {
							Body = HttpService:JSONEncode(v5.Body),
							Success = v5.Success == nil or v5.Success,
							StatusCode = not v5.StatusCode and 200 or v5.StatusCode,
							StatusMessage = not v5.StatusMessage and "OK" or v5.StatusMessage,
							Headers = not v5.Headers and {} or v5.Headers
						})

						if data.responseSpy then
							data.responseSpy(p3)
						end
					end
				}
			end
		}
	end,
	appendApolloClientToReducer = function(callback, p2)
		return function(options, p3)
			local v5 = callback(options or {}, p3)
			return (object.assign(table.clone(v5), {
				ApolloClient = { apolloClient = p2 }
			}))
		end
	end
}
