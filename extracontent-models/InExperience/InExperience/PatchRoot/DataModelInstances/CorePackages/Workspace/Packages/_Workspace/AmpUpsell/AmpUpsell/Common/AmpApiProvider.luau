local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(AmpUpsellParent.UrlBuilder).UrlBuilder
local UrlBase = require(AmpUpsellParent.UrlBuilder).UrlBase
local Fetch = require(AmpUpsellParent.Fetch)
local Promise = require(AmpUpsellParent.Promise)
local SharedFlags = require(AmpUpsellParent.SharedFlags)
local fetch = Fetch.fetch
local Response = Fetch.Response
local AccessResponseEnum = require(AmpUpsell.Common.Enums).AccessResponseEnum

require(AmpUpsell.Common.Types)

local gql = require(AmpUpsellParent.ApolloClient).gql
local Base64 = require(AmpUpsellParent.AuthCommon).Utils.Base64
local GetFFlagAmpGqlPassSuccessfulActions = require(AmpUpsell.Flags.GetFFlagAmpGqlPassSuccessfulActions)
local FFlagAllowAmpV2FeatureAccessCall = SharedFlags.FFlagAllowAmpV2FeatureAccessCall
local v16 = UrlBuilder.new({
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
local v17 = UrlBuilder.new({
	path = "access-management/v1/feature-access",
	base = UrlBase.APIS,
	query = if not FFlagAllowAmpV2FeatureAccessCall then {
		featureNames = "{featureNames}"
	} else {
		featureNames = "{featureNames}",
		nameSpace = "{nameSpace}"
	}
})

local function getUpsellFeatureAccessFromFeatureName(s1: string, t1: {[any]: any}, s2: string?, s3: string?) -- line: 54
	-- upvalues: fetch (copy), Promise (copy), v16 (copy), Response (copy)
	local v23 = fetch

	return Promise.new(function(resolve, reject) -- line: 61
		-- upvalues: t1 (copy), v16 (copy), s1 (copy), s2 (copy), s3 (copy), v23 (copy), Response (copy)
		local v43 = table.concat(t1, ",")
		local v44 = v16({
			featureName = s1,
			successfulActions = v43,
			nameSpace = s2,
			extraParameters = s3
		})
		local v45 = v23(v44, {
			method = "GET"
		}):catch(function() -- line: 70
			-- upvalues: Response (copy)
			return Response.error()
		end):expect()

		if v45.status == 304 then
			reject("Got Response: 304")

			return
		end

		if not v45.ok then
			reject("Failed to find upsell feature access values")

			return
		end

		local v46 = v45:json():catch(function() -- line: 88
			return nil
		end):expect()

		if not v46 then
			reject("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API")

			return
		end

		resolve({
			access = v46.access,
			recourse = v46.recourse,
			recourses = v46.recourses,
			shouldPrompt = v46.shouldPrompt
		})
	end)
end

return {
	upsellFeatureAccess = function(s4: string, t2: {[any]: any}, s5: string?, t3: {[any]: any}?) -- line: 107
		-- upvalues: Base64 (copy), HttpService (copy), fetch (copy), Promise (copy), v16 (copy), Response (copy), AccessResponseEnum (copy)
		local v28 = if not t3 then nil else Base64.Encode(HttpService:JSONEncode(t3))
		local v29 = fetch

		return (Promise.new(function(resolve, reject) -- line: 61
			-- upvalues: t2 (copy), v16 (copy), s4 (copy), s5 (copy), v28 (copy), v29 (copy), Response (copy)
			local v49 = table.concat(t2, ",")
			local v50 = v16({
				featureName = s4,
				successfulActions = v49,
				nameSpace = s5,
				extraParameters = v28
			})
			local v51 = v29(v50, {
				method = "GET"
			}):catch(function() -- line: 70
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()

			if v51.status == 304 then
				reject("Got Response: 304")

				return
			end

			if not v51.ok then
				reject("Failed to find upsell feature access values")

				return
			end

			local v52 = v51:json():catch(function() -- line: 88
				return nil
			end):expect()

			if not v52 then
				reject("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API")

				return
			end

			resolve({
				access = v52.access,
				recourse = v52.recourse,
				recourses = v52.recourses,
				shouldPrompt = v52.shouldPrompt
			})
		end):catch(function(_) -- line: 117
			-- upvalues: AccessResponseEnum (copy)
			return {
				access = AccessResponseEnum.Error
			}
		end):expect())
	end,
	upsellFeatureAccessGql = function(p2, s6: string, t4: {[any]: any}, s7: string?, t5: {[any]: any}?) -- line: 189
		-- upvalues: gql (copy), Base64 (copy), HttpService (copy), GetFFlagAmpGqlPassSuccessfulActions (copy), AccessResponseEnum (copy)
		local v38 = gql(require(script.Parent.GetUpsellFeatureAccess))
		local v39 = if not t5 then nil else Base64.Encode(HttpService:JSONEncode(t5))
		local v40 = p2:query({
			fetchPolicy = "network-only",
			query = v38,
			variables = {
				featureName = s6,
				successfulActions = if not GetFFlagAmpGqlPassSuccessfulActions() then {} else t4,
				nameSpace = s7,
				extraParameters = v39
			}
		}):catch(function(_) -- line: 211
			-- upvalues: AccessResponseEnum (copy)
			return {
				access = AccessResponseEnum.Error
			}
		end):expect()

		if v40.data and v40.data.getUpsellFeatureAccess.featureAccess then
			return v40.data.getUpsellFeatureAccess.featureAccess
		end

		return {
			access = AccessResponseEnum.Error
		}
	end,
	getFeatureAccess = function(t6: {[any]: any}, s8: string?) -- line: 126
		-- upvalues: fetch (copy), Promise (copy), FFlagAllowAmpV2FeatureAccessCall (copy), v17 (copy), Response (copy), AccessResponseEnum (copy)
		local v32 = fetch

		return (Promise.new(function(resolve, reject) -- line: 128
			-- upvalues: t6 (copy), FFlagAllowAmpV2FeatureAccessCall (copy), v17 (copy), s8 (copy), v32 (copy), Response (copy)
			local v56 = table.concat(t6, ",")
			local v57 = if not FFlagAllowAmpV2FeatureAccessCall then v17({
				featureNames = v56
			}) else v17({
				featureNames = v56,
				nameSpace = not s8 and "" or s8
			})
			local v58 = v32(v57, {
				method = "GET"
			}):catch(function() -- line: 140
				-- upvalues: Response (copy)
				return Response.error()
			end):expect()

			if v58.status == 304 then
				reject("Got Response: 304")

				return
			end

			if not v58.ok then
				reject("Failed to find get feature access values")

				return
			end

			local v59 = v58:json():catch(function() -- line: 158
				return nil
			end):expect()

			if not v59 then
				reject("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API")

				return
			end

			local t7 = {}

			for _, v62 in v59.features do
				table.insert(t7, {
					feature = v62.featureName,
					access = v62.access
				})
			end

			resolve({
				featureAccessList = t7
			})
		end):catch(function(_) -- line: 181
			-- upvalues: AccessResponseEnum (copy)
			return {
				access = AccessResponseEnum.Error
			}
		end):expect())
	end
}
