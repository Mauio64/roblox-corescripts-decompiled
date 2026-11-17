local HttpService = game:GetService("HttpService")
local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local parent = GraphQLServer.Parent

local FFlagUserProfileBetterErrors = require(GraphQLServer.Flags.FFlagUserProfileBetterErrors)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserProfileMergeCachedNames = SharedFlags2.FFlagUserProfileMergeCachedNames
local SharedFlags3 = require(parent.SharedFlags)
local FIntUserProfileStoreBatchSize = SharedFlags3.FIntUserProfileStoreBatchSize
local PlatformProfileRequest = require(GraphQLServer.PlatformProfileRequest)
local fillRequestedNames = require(GraphQLServer.fillRequestedNames)
require(parent.LuauPolyfill)
local UrlBuilder = require(parent.UrlBuilder)
local Promise = require(parent.Promise)
local Fetch = require(parent.Fetch)
local Http = require(parent.Http)
local Url = Http.Url

local urlBuilder = UrlBuilder.UrlBuilder

local GraphQL = require(parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local fetch = Fetch.fetch

local Response = Fetch.Response
require(script.Parent.Parent.generatedTypes)

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "user-profile-api/v1/user/profiles/get-profiles"
})()
local function fetchProfilesByIds(userIds, fields, p)
	local v2 = p or fetch
	return Promise.new(function(callback, callback2)
		if FFlagUserProfilePlatformProfile and FIntUserProfileStoreBatchSize < #userIds then
			local v3 = {}

			for i = 1, #userIds, FIntUserProfileStoreBatchSize do
				local v4 = {}

				for j = i, math.min(i + FIntUserProfileStoreBatchSize - 1, #userIds) do
					table.insert(v4, userIds[j])
				end

				local expect = fetchProfilesByIds(v4, fields, v2):expect()

				for _, v5 in expect do
					table.insert(v3, v5)
				end
			end

			callback(v3)
			return
		end

		local expect = v2(v, {
			body = HttpService:JSONEncode({
				UserIds = userIds,
				Fields = fields,
				includePlatformProfile = FFlagUserProfilePlatformProfile and PlatformProfileRequest.hasPlatformFields(fields) and true or nil
			}),
			method = "POST",
			headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}):catch(function(p2)
			if not FFlagUserProfileBetterErrors then
				return Response.error()
			end

			local v3 = Response.error()
			v3.statusText = p2.message
			return v3
		end):expect()

		if expect.ok then
			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if not expect then
				callback2(GraphQLError.new(`Failed to decode HTTP response as JSON for user matching id: {userIds[1]}`))
				return
			end

			local profileDetails = expect2.profileDetails

			if FFlagUserProfilePlatformProfile then
				profileDetails = PlatformProfileRequest.normalizeProfiles(profileDetails, fields)
			end

			if FFlagUserProfileMergeCachedNames then
				profileDetails = fillRequestedNames(profileDetails, fields)
			end

			callback(profileDetails)
		elseif FFlagUserProfileBetterErrors then
			callback2(GraphQLError.new(expect.statusText, nil, nil, nil, nil, {
				extensions = { status = expect.status, statusText = expect.statusText }
			}))
		else
			callback2(GraphQLError.new(`Failed to fetch user profiles. Error code: {expect.status}`))
		end
	end)
end

return { fetchProfilesByIds = fetchProfilesByIds }
