local HttpService = game:GetService("HttpService")
local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local GraphQLServerParent = GraphQLServer.Parent
local FFlagUserProfileBetterErrors = require(GraphQLServer.Flags.FFlagUserProfileBetterErrors)

require(GraphQLServerParent.LuauPolyfill)

local UrlBuilder = require(GraphQLServerParent.UrlBuilder)
local Promise = require(GraphQLServerParent.Promise)
local Fetch = require(GraphQLServerParent.Fetch)
local Url = require(GraphQLServerParent.Http).Url
local UrlBuilder2 = UrlBuilder.UrlBuilder
local GraphQLError = require(GraphQLServerParent.GraphQL).GraphQLError
local fetch = Fetch.fetch
local Response = Fetch.Response

require(script.Parent.Parent.generatedTypes)

local v13 = UrlBuilder2.new({
	path = "user-profile-api/v1/user/profiles/get-profiles",
	base = Url.APIS_URL
})()

return {
	fetchProfilesByIds = function(t1: {[any]: any}, t2: {[any]: any}, p1) -- line: 33
		-- upvalues: fetch (copy), Promise (copy), v13 (copy), HttpService (copy), FFlagUserProfileBetterErrors (copy), Response (copy), GraphQLError (copy)
		local v17 = p1 or fetch

		return Promise.new(function(resolve, reject) -- line: 39
			-- upvalues: v17 (copy), v13 (copy), HttpService (copy), t1 (copy), t2 (copy), FFlagUserProfileBetterErrors (copy), Response (copy), GraphQLError (copy)
			local v20 = v17(v13, {
				method = "POST",
				body = HttpService:JSONEncode({
					UserIds = t1,
					Fields = t2
				}),
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function(p2) -- line: 51
				-- upvalues: FFlagUserProfileBetterErrors (copy), Response (copy)
				if FFlagUserProfileBetterErrors then
					local v23 = Response.error()

					v23.statusText = p2.message

					return v23
				end

				return Response.error()
			end):expect()

			if not v20.ok then
				if FFlagUserProfileBetterErrors then
					reject(GraphQLError.new(v20.statusText, nil, nil, nil, nil, {
						extensions = {
							status = v20.status,
							statusText = v20.statusText
						}
					}))

					return
				end

				reject(GraphQLError.new(`Failed to fetch user profiles. Error code: { v20.status }`))

				return
			end

			local v21 = v20:json():catch(function() -- line: 82
				return nil
			end):expect()

			if not v20 then
				reject(GraphQLError.new(`Failed to decode HTTP response as JSON for user matching id: { t1[1] }`))

				return
			end

			resolve(v21.profileDetails)
		end)
	end
}
