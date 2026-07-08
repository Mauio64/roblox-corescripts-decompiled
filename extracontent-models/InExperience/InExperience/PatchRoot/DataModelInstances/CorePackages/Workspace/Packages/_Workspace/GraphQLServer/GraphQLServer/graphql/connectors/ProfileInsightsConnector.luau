local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local UrlBase = require(Parent.UrlBuilder).UrlBase
local Promise = require(Parent.Promise)
local GraphQLError = require(Parent.GraphQL).GraphQLError
local Response = require(Parent.Fetch).Response
local fetch = require(Parent.Fetch).fetch

require(Parent.LuauPolyfill)
require(script.Parent.Parent.generatedTypes)

local FFlagPlayerSearchEnableOnlineFrequents = require(Parent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents
local v10 = UrlBuilder.new({
	path = "profile-insights-api/v1/multiProfileInsights",
	base = UrlBase.APIS
})

return {
	findProfileInsightsByUserIds = function(t1: {[any]: any}, n1: number?, s1: string?, p1) -- line: 113
		-- upvalues: fetch (copy), Promise (copy), v10 (copy), HttpService (copy), Response (copy), GraphQLError (copy)
		local v15 = p1 or fetch

		return Promise.new(function(resolve, reject) -- line: 121
			-- upvalues: v15 (copy), v10 (copy), HttpService (copy), t1 (copy), s1 (copy), n1 (copy), Response (copy), GraphQLError (copy)
			local v25 = v15(v10(), {
				method = "POST",
				body = HttpService:JSONEncode({
					userIds = t1,
					count = if not s1 then n1 or 2 else nil,
					rankingStrategy = s1
				}),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function() -- line: 135
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()

			if not v25.ok then
				reject(GraphQLError.new(string.format("Failed to fetch profile insights. Error code: %d", v25.status)))

				return
			end

			local v26 = v25:json():catch(function() -- line: 151
				return nil
			end):expect()

			if not v26 then
				reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for profile insights: %s.", HttpService:JSONEncode(t1))))

				return
			end

			resolve(v26.userInsights)
		end)
	end,
	findProfileInsightsByUserIdsFeed = function(t2: {[any]: any}, n2: number?, s2: string?, s3: string?, p2) -- line: 173
		-- upvalues: FFlagPlayerSearchEnableOnlineFrequents (copy), fetch (copy), Promise (copy), v10 (copy), HttpService (copy), Response (copy), GraphQLError (copy)
		local v21 = if not FFlagPlayerSearchEnableOnlineFrequents then nil else s3
		local v22 = p2 or fetch

		return (Promise.new(function(resolve, reject) -- line: 121
			-- upvalues: v22 (copy), v10 (copy), HttpService (copy), t2 (copy), v21 (copy), n2 (copy), Response (copy), GraphQLError (copy)
			local v29 = v22(v10(), {
				method = "POST",
				body = HttpService:JSONEncode({
					userIds = t2,
					count = if not v21 then n2 or 2 else nil,
					rankingStrategy = v21
				}),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function() -- line: 135
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()

			if not v29.ok then
				reject(GraphQLError.new(string.format("Failed to fetch profile insights. Error code: %d", v29.status)))

				return
			end

			local v30 = v29:json():catch(function() -- line: 151
				return nil
			end):expect()

			if not v30 then
				reject(GraphQLError.new(string.format("Failed to decode HTTP response as JSON for profile insights: %s.", HttpService:JSONEncode(t2))))

				return
			end

			resolve(v30.userInsights)
		end):andThen(function(p3) -- line: 185
			-- upvalues: s2 (copy)
			return {
				pageId = s2,
				profileInsights = p3
			}
		end))
	end
}
