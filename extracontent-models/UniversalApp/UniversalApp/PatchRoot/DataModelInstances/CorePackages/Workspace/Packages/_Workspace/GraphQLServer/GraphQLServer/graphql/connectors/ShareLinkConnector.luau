local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("GraphQLServer").Parent

require(Parent.LuauPolyfill)

local UrlBuilder = require(Parent.UrlBuilder)
local Promise = require(Parent.Promise)
local Fetch = require(Parent.Fetch)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local GraphQLError = require(Parent.GraphQL).GraphQLError
local fetch = Fetch.fetch
local Response = Fetch.Response

require(script.Parent.Parent.generatedTypes)

local v11 = UrlBuilder2.new({
	path = "sharelinks/v1/get-or-create-link",
	base = UrlBase.APIS
})()

return {
	fetchShareLink = function(p1, p2) -- line: 40
		-- upvalues: fetch (copy), HttpService (copy), Promise (copy), v11 (copy), Response (copy), GraphQLError (copy)
		local v14 = p2 or fetch
		local json = HttpService:JSONEncode(p1.data)
		local json2 = HttpService:JSONEncode({
			linkType = p1.linkType,
			data = json
		})

		return Promise.new(function(resolve, reject) -- line: 50
			-- upvalues: v14 (copy), v11 (copy), json2 (copy), Response (copy), GraphQLError (copy)
			local v19 = v14(v11, {
				method = "POST",
				body = json2,
				headers = {
					["Content-Type"] = "application/json",
					Accept = "application/json"
				}
			}):catch(function(p3) -- line: 59
				-- upvalues: Response (copy)
				local v22 = Response.error()

				v22.statusText = p3.message

				return v22
			end):expect()

			if not v19.ok then
				print(v19.statusText .. " " .. v19.status)
				reject(GraphQLError.new(v19.statusText, nil, nil, nil, nil, {
					extensions = {
						status = v19.status,
						statusText = v19.statusText
					}
				}))

				return
			end

			local v20 = v19:json():catch(function() -- line: 83
				return nil
			end):expect()

			if not v19 then
				reject(GraphQLError.new(`Failed to decode HTTP response as JSON for share link matching type: { type }`))

				return
			end

			resolve(v20)
		end)
	end
}
