local GraphQLServer = script:FindFirstAncestor("GraphQLServer")
local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder).UrlBuilder
local UrlBase = require(GraphQLServer.Parent.UrlBuilder).UrlBase

require(GraphQLServer.Parent.LuauPolyfill)

local Promise = require(GraphQLServer.Parent.Promise)
local GraphQLError = require(GraphQLServer.Parent.GraphQL).GraphQLError

require(GraphQLServer.graphql.generatedTypes)

local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response
local t1 = {}
local v10 = UrlBuilder.new({
	path = "access-management/v1/feature-access",
	base = UrlBase.APIS,
	query = {
		featureNames = "{featureNames}"
	}
})

function t1.getFeatureAccessFromFeatureNamesList(t2: {[any]: any}, p1) -- line: 27
	-- upvalues: fetch (copy), Promise (copy), v10 (copy), Response (copy), GraphQLError (copy)
	local v14 = p1 or fetch

	return Promise.new(function(resolve, reject) -- line: 33
		-- upvalues: t2 (copy), v10 (copy), v14 (copy), Response (copy), GraphQLError (copy)
		local v23 = table.concat(t2, ",")
		local v24 = v10({
			featureNames = v23
		})
		local v25 = v14(v24, {
			method = "GET"
		}):catch(function() -- line: 37
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if v25.status == 304 then
			reject(GraphQLError.new("Got Response: 304, using cached data instead"))

			return
		end

		if not v25.ok then
			reject(GraphQLError.new("Failed to find feature access values"))

			return
		end

		local v26 = v25:json():catch(function() -- line: 55
			return nil
		end):expect()

		if not v26 then
			reject(GraphQLError.new("Failed to decode HTTP response as JSON for AMP Feature Access API"))

			return
		end

		local t3 = {}

		for _, v29 in v26.features do
			table.insert(t3, {
				featureName = v29.featureName,
				access = v29.access
			})
		end

		resolve({
			features = t3
		})
	end)
end

local v11 = UrlBuilder.new({
	path = "access-management/v1/upsell-feature-access",
	base = UrlBase.APIS,
	query = {
		{
			name = "featureName",
			value = "{featureName}",
			optional = false
		},
		{
			name = "successfulActions",
			value = "{successfulActions}",
			optional = false
		},
		{
			name = "nameSpace",
			value = "{nameSpace}",
			optional = true
		},
		{
			name = "extraParameters",
			value = "{extraParameters}",
			optional = true
		}
	}
})

function t1.getUpsellFeatureAccessFromFeatureName(s1: string, t4: {[any]: any}, p2, s2: string?, s3: string?) -- line: 93
	-- upvalues: fetch (copy), Promise (copy), v11 (copy), Response (copy), GraphQLError (copy)
	local v20 = p2 or fetch

	return Promise.new(function(resolve, reject) -- line: 102
		-- upvalues: t4 (copy), v11 (copy), s1 (copy), s2 (copy), s3 (copy), v20 (copy), Response (copy), GraphQLError (copy)
		local v32 = table.concat(t4, ",")
		local v33 = v11({
			featureName = s1,
			successfulActions = v32,
			nameSpace = s2,
			extraParameters = s3
		})
		local v34 = v20(v33, {
			method = "GET"
		}):catch(function() -- line: 111
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if v34.status == 304 then
			reject(GraphQLError.new("Got Response: 304, using cached data instead"))

			return
		end

		if not v34.ok then
			reject(GraphQLError.new("Failed to find upsell feature access values"))

			return
		end

		local v35 = v34:json():catch(function() -- line: 129
			return nil
		end):expect()

		if not v35 then
			reject(GraphQLError.new("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API"))

			return
		end

		resolve({
			featureName = v35.featureName,
			access = v35.access,
			recourse = v35.recourse,
			recourses = v35.recourses,
			shouldPrompt = v35.shouldPrompt
		})
	end)
end

return t1
