local HttpService = game:GetService("HttpService")

local FFlagUserProfileBetterErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/Flags/FFlagUserProfileBetterErrors")
local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").FFlagUserProfilePlatformProfile
local fFlagUserProfileMergeCachedNames = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").FFlagUserProfileMergeCachedNames
local fIntUserProfileStoreBatchSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").FIntUserProfileStoreBatchSize
local PlatformProfileRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/PlatformProfileRequest")
local fillRequestedNames = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/fillRequestedNames")
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Http").Url

local urlBuilder = UrlBuilder.UrlBuilder

local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
local fetch = Fetch.fetch

local response = Fetch.Response
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "user-profile-api/v1/user/profiles/get-profiles"
})()
local function fetchProfilesByIds(list, p2, p3)
	local v6 = p3 or fetch
	return Promise.new(function(callback, callback2)
		if fFlagUserProfilePlatformProfile and fIntUserProfileStoreBatchSize < #list then
			local v8 = {}

			for i = 1, #list, fIntUserProfileStoreBatchSize do
				local v9 = {}

				for j = i, math.min(i + fIntUserProfileStoreBatchSize - 1, #list) do
					table.insert(v9, list[j])
				end

				local expect = fetchProfilesByIds(v9, p2, v6):expect()

				for k, v10 in expect do
					table.insert(v8, v10)
				end
			end

			callback(v8)
			return
		end

		local expect = v6(v5, {
			body = HttpService:JSONEncode({
				UserIds = list,
				Fields = p2,
				includePlatformProfile = fFlagUserProfilePlatformProfile and PlatformProfileRequest.hasPlatformFields(p2) and true or nil
			}),
			method = "POST",
			headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}):catch(function(p4)
			if not FFlagUserProfileBetterErrors then
				return response.error()
			end

			local v8 = response.error()
			v8.statusText = p4.message
			return v8
		end):expect()

		if expect.ok then
			local expect2 = expect:json():catch(function(): nil
				return nil
			end):expect()

			if not expect then
				callback2(graphQLError.new(`Failed to decode HTTP response as JSON for user matching id: {list[1]}`))
				return
			end

			local profileDetails = expect2.profileDetails

			if fFlagUserProfilePlatformProfile then
				profileDetails = PlatformProfileRequest.normalizeProfiles(profileDetails, p2)
			end

			if fFlagUserProfileMergeCachedNames then
				profileDetails = fillRequestedNames(profileDetails, p2)
			end

			callback(profileDetails)
		elseif FFlagUserProfileBetterErrors then
			callback2(graphQLError.new(expect.statusText, nil, nil, nil, nil, {
				extensions = { status = expect.status, statusText = expect.statusText }
			}))
		else
			callback2(graphQLError.new(`Failed to fetch user profiles. Error code: {expect.status}`))
		end
	end)
end

return { fetchProfilesByIds = fetchProfilesByIds }
